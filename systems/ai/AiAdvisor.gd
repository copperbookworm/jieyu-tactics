extends Node

## 《解域》AI 参谋（局间顾问）· 运行时装配 —— 注册为 autoload「AiAdvisor」
##
## 定位（2026-10-02 使用者拍板）：**局间顾问**。实时战斗里没有它的位置（网络往返 2~8 s），
## 所以它只在一局结束后出手：复盘。战斗中的决策依旧归规则参谋（QuestTable 权重 + CommandBook 白名单）。
##
## 三条铁律（改代码时别破）：
##   ① 玩家自备 key，不填就完全不联网；用量记录只写本机 user://，不上报任何服务器
##   ② 生成式只产出「文字」，永不写游戏状态 —— 复盘不碰任何游戏数据，因此没有注入面
##   ③ 预算闸门优先于功能：预计超预算就拒绝并说明原因，绝不悄悄花玩家的钱
##
## 为什么是 autoload：跨场景（重开一局不该重读配置与账本），且 Main.gd 已到 398/400 行上限，
## 不能再往里塞装配。调用点用「运行时按名字取」的写法（见 systems/audio/Sfx.gd）。
##
## ⚠ 本文件刻意**不引用任何全局 class_name**（GameConfig / RoleTable 也走运行时 load +
##    常量表 / 静态方法表取用）：tools/ai_transport_check.gd 这类 --script 入口会在
##    全局类注册之前编译到本文件。
## 刻意不写 class_name：引用方 preload。

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")
const RequestBuilder := preload("res://systems/ai/AiRequestBuilder.gd")
const Parser := preload("res://systems/ai/AiResponseParser.gd")
const PriceTable := preload("res://systems/ai/AiPriceTable.gd")
const LedgerScript := preload("res://systems/ai/AiUsageLedger.gd")
const KeyVault := preload("res://systems/ai/AiKeyVault.gd")
const DigestScript := preload("res://systems/ai/AiBattleDigest.gd")
const PromptScript := preload("res://systems/ai/AiPrompt.gd")
const PanelScript := preload("res://ui/AiAdvisorPanel.gd")

const CONFIG_PATH := "user://ai_advisor.cfg"
const KEY_PATH := "user://ai_advisor.key"
const EXPORT_PATH := "user://ai_usage_export.csv"
const GAME_CONFIG_PATH := "res://data/config/GameConfig.gd"
const ROLE_TABLE_PATH := "res://data/config/RoleTable.gd"
const REQUEST_TIMEOUT := 60.0

## 默认值只此一份：_load_config 与「恢复默认」共用
const DEFAULTS := {
	"enabled": false,
	"provider": "deepseek",
	"model": "",
	"base_url": "",
	"max_tokens_per_call": 512,
	"budget_tokens_per_match": 4000,
	"budget_tokens_per_day": 20000,
	"auto_debrief": false,
	"competitive": false,
}

signal debrief_started()
signal debrief_finished(ok: bool, text: String, entry: Dictionary)
signal usage_changed()

var enabled := false
var provider_id := "deepseek"
var model := ""
var base_url_override := ""
var max_tokens_per_call := 512
var budget_tokens_per_match := 4000
var budget_tokens_per_day := 20000
var auto_debrief := false
## 竞技 / 严格对抗模式的关闭开关。PVEVP 开放（使用者拍板）：只有竞技才关。
var competitive := false

var ledger = null
var panel = null

## 账本目录可注入：自检工具用它指向临时目录，绝不碰玩家真实的 user://ai_usage
var ledger_dir := LedgerScript.DEFAULT_DIR

var _http: HTTPRequest = null
var _vault = null
var _key := ""
var _snapshot: Dictionary = {}
var _pending: Dictionary = {}
var _busy := false
var _ui_allowed := true
var _match_tokens := 0
var _match_kills := 0
var _match_deaths := 0
var _quest_done: Array = []
var _quest_failed: Array = []
var _last_entry: Dictionary = {}
var _last_text := ""
var _last_error := ""
var _started_usec := 0
var _session_id := ""
var _cfg_script = null
var _role_script = null


func _ready() -> void:
	ledger = LedgerScript.new(ledger_dir)
	_vault = KeyVault.new(KEY_PATH)
	_load_config()
	_key = _vault.load_key()
	_http = HTTPRequest.new()
	_http.name = "AiHttp"
	_http.timeout = REQUEST_TIMEOUT
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)
	_wire_bus()
	# headless 下不建 UI：跑批环境不需要按钮（几何门禁只扫 Main.tscn，但少一层更干净）
	_ui_allowed = DisplayServer.get_name() != "headless"
	if _ui_allowed:
		_build_panel()


# ────────────────────────────── 接线 ──────────────────────────────

func _wire_bus() -> void:
	var bus := get_node_or_null("/root/EventBus")
	if bus == null:
		return
	_connect_if(bus, "match_finished", _on_match_finished)
	_connect_if(bus, "enemy_killed", _on_enemy_killed)
	_connect_if(bus, "player_died", _on_player_died)
	# 任务完成 / 失败不在 EventBus 上，靠 node_added 逮住 QuestSystem（这样不必碰 Main.gd）
	var tree := get_tree()
	if tree == null:
		return
	if not tree.node_added.is_connected(_on_node_added):
		tree.node_added.connect(_on_node_added)
	if tree.current_scene != null:
		_on_node_added(tree.current_scene)


func _connect_if(bus: Node, signal_name: String, target: Callable) -> void:
	if bus.has_signal(signal_name) and not bus.is_connected(signal_name, target):
		bus.connect(signal_name, target)


func _on_node_added(node: Node) -> void:
	if node == null or String(node.name) != "QuestSystem":
		return
	_connect_if(node, "quest_completed", _on_quest_completed)
	_connect_if(node, "quest_failed", _on_quest_failed)


func _on_enemy_killed(_enemy) -> void:
	_match_kills = _match_kills + 1


func _on_player_died() -> void:
	_match_deaths = _match_deaths + 1


func _on_quest_completed(quest: Dictionary) -> void:
	_quest_done.append(String(quest.get("name", "")))


func _on_quest_failed(quest: Dictionary) -> void:
	_quest_failed.append(String(quest.get("name", "")))


func _build_panel() -> void:
	panel = PanelScript.new()
	panel.name = "AiAdvisorPanel"
	add_child(panel)
	panel.setup(self)


# ────────────────────────────── 战局快照 ──────────────────────────────

func _on_match_finished(winner) -> void:
	_snapshot = capture_snapshot(String(winner))
	_session_id = "m%d" % int(Time.get_unix_time_from_system())
	_match_tokens = 0
	_match_kills = 0
	_match_deaths = 0
	_quest_done = []
	_quest_failed = []
	usage_changed.emit()
	if auto_debrief and can_request() == "":
		request_debrief()


## 把游戏对象拍平成纯字典（交给 AiBattleDigest 收敛）。全部走 _prop 鸭子类型读，
## 因为 Main 没有 class_name，这些字段名是它与子模块之间既有的接口约定。
func capture_snapshot(outcome: String) -> Dictionary:
	var snap := {
		"outcome": outcome, "reason": "",
		"duration_s": 0, "overtime": false,
		"score": 0, "kills": _match_kills, "deaths": _match_deaths,
		"respawn_left": 0, "role_name": "", "zones": [], "quests": {},
		"vehicles": "",
	}
	var tree := get_tree()
	var scene: Node = tree.current_scene if tree != null else null
	if scene == null:
		return snap
	var flow = _prop(scene, "match_flow")
	if flow != null:
		snap["reason"] = String(_prop(flow, "reason", ""))
		snap["overtime"] = int(_prop(flow, "phase", 0)) == 1
		snap["respawn_left"] = int(_prop(flow, "budget", 0))
		var total := float(_const_of(_game_config(), "MATCH_DURATION", 0.0))
		var left := float(_prop(flow, "time_left", 0.0))
		if total > 0.0:
			snap["duration_s"] = int(round(maxf(total - left, 0.0)))
	snap["score"] = int(_prop(scene, "score", 0))
	snap["zones"] = _zones_snapshot(_prop(scene, "capture_zones", []))
	snap["quests"] = _quests_snapshot(_prop(scene, "quests"))
	snap["role_name"] = _role_name(int(_prop(scene, "player_role", 0)))
	snap["vehicles"] = _vehicles_text(_prop(scene, "vehicles"))
	return snap


func _zones_snapshot(raw: Variant) -> Array:
	var out: Array = []
	if typeof(raw) != TYPE_ARRAY:
		return out
	var zones: Array = raw
	for i in zones.size():
		# CaptureZone.State：NEUTRAL=0 / BLUE=1（我方）/ RED=2（敌方）
		var state := int(_prop(zones[i], "state", 0))
		var side := "neutral"
		if state == 1:
			side = "ours"
		elif state == 2:
			side = "enemy"
		out.append({"n": i + 1, "side": side, "progress": float(_prop(zones[i], "progress", 0.0))})
	return out


func _quests_snapshot(quests) -> Dictionary:
	var out := {"main": "", "done": _quest_done.duplicate(), "failed": _quest_failed.duplicate(),
		"completed_count": 0}
	if quests == null:
		return out
	out["completed_count"] = int(_prop(quests, "completed_count", 0))
	var main_q: Variant = _call_main_quest(quests)
	if typeof(main_q) == TYPE_DICTIONARY:
		out["main"] = String((main_q as Dictionary).get("name", ""))
	return out


## QuestSystem 的 main_quest() 是**实例方法**；测试替身里可能是静态的。两条都走。
func _call_main_quest(quests) -> Variant:
	if quests == null:
		return null
	if quests.has_method("main_quest"):
		return quests.call("main_quest")
	var script = _script_of(quests)
	if _has_static(script, "main_quest"):
		return script.call("main_quest")
	return null


func _role_name(role: int) -> String:
	if _role_script == null:
		_role_script = load(ROLE_TABLE_PATH)
	if _has_static(_role_script, "role_name"):
		return String(_role_script.call("role_name", role))
	return ""


func _vehicles_text(vehicles) -> String:
	if vehicles == null:
		return ""
	var parts: Array[String] = []
	var mine = _prop(vehicles, "vehicle")
	if mine != null:
		parts.append("我方载具 %s" % ("已被摧毁" if bool(_prop(mine, "destroyed", false)) else "在场"))
	var theirs = _prop(vehicles, "enemy_vehicle")
	if theirs != null:
		parts.append("敌方载具 %s" % ("已被击毁" if bool(_prop(theirs, "destroyed", false)) else "在场"))
	return "，".join(parts)


func _game_config():
	if _cfg_script == null:
		_cfg_script = load(GAME_CONFIG_PATH)
	return _cfg_script


## 鸭子类型读属性：Main 与其子模块之间就是靠字段名通信的（Main 无 class_name）。
## 注意：它读的是**实例属性**；脚本常量用下面的 _const_of()。
static func _prop(obj, property_name: String, fallback = null) -> Variant:
	if obj == null or not (obj is Object):
		return fallback
	var o: Object = obj
	for p in o.get_property_list():
		if String(p.get("name", "")) == property_name:
			return o.get(property_name)
	return fallback


## 读 GDScript 里的常量（常量不在 get_property_list 里，必须走常量表）
static func _const_of(script, constant_name: String, fallback = null) -> Variant:
	if script == null or not (script is GDScript):
		return fallback
	var map: Dictionary = (script as GDScript).get_script_constant_map()
	return map.get(constant_name, fallback)


## 拿到一个对象背后的 GDScript（传实例或传脚本本身都认）
static func _script_of(target):
	if target == null:
		return null
	if target is GDScript:
		return target
	if target is Object:
		var s = (target as Object).get_script()
		if s is GDScript:
			return s
	return null


## 脚本里有没有这个（静态）方法。GDScript 的静态方法 has_method() 不可靠，用方法表判。
## ⚠ 传实例进来要能认（踩过：传了实例、这里只认 GDScript，结果 main_quest 永远取不到）。
static func _has_static(target, method_name: String) -> bool:
	var script = _script_of(target)
	if script == null:
		return false
	for m in (script as GDScript).get_script_method_list():
		if String(m.get("name", "")) == method_name:
			return true
	return false


# ────────────────────────────── 闸门与状态 ──────────────────────────────

## 账本惰性就绪：面板可能在 _ready 之前就读用量（自检时会），别让 Nil 冒到 UI 层
func _led():
	if ledger == null:
		ledger = LedgerScript.new(ledger_dir)
	return ledger


func key_is_set() -> bool:
	return _key != ""


func key_display() -> String:
	return KeyVault.redact(_key)


func resolved_model() -> String:
	var m := model.strip_edges()
	if m != "":
		return m
	return String(CatalogScript.resolve(provider_id).get("default_model", ""))


func status_text() -> String:
	if competitive:
		return "竞技模式下已关闭"
	if not enabled:
		return "未开启（不联网、不花 token）"
	if _key == "":
		return "已开启，但还没填 API key"
	return "%s ｜ %s" % [CatalogScript.label_of(provider_id), resolved_model()]


## 发一次请求预计花多少 token（prompt 粗估 + 输出上限）
func estimated_call_tokens() -> int:
	var digest_text := DigestScript.to_text(DigestScript.build(_snapshot))
	return PromptScript.estimate_prompt_tokens(digest_text) + max_tokens_per_call


## 返回不能请求的原因；"" = 可以请求
func can_request() -> String:
	if competitive:
		return "竞技模式下 AI 参谋已关闭"
	if not enabled:
		return "AI 参谋未开启（在参谋面板里打开）"
	if _key == "":
		return "还没填 API key"
	if _busy:
		return "上一次请求还没回来"
	# 没有战局快照就发 = 发一份空战报（真机上踩到：面板写着「先打完一局」，按钮却可点）
	if not has_snapshot():
		return "还没有可复盘的战局 —— 先打完一局再回来"
	if resolved_model() == "":
		return "没填模型名"
	var provider := CatalogScript.resolve(provider_id)
	if RequestBuilder.endpoint(provider, base_url_override, resolved_model()) == "":
		return "没填 base_url（自定义供应商必填）"
	return budget_block_reason()


func budget_block_reason() -> String:
	var estimate := estimated_call_tokens()
	if budget_tokens_per_match > 0 and _match_tokens + estimate > budget_tokens_per_match:
		return "本局预算不够：已用 %d / 上限 %d token（可在参谋面板调高）" % [
			_match_tokens, budget_tokens_per_match]
	if budget_tokens_per_day > 0:
		var used := tokens_today()
		if used + estimate > budget_tokens_per_day:
			return "今日预算不够：已用 %d / 上限 %d token（可在参谋面板调高）" % [
				used, budget_tokens_per_day]
	return ""


func has_snapshot() -> bool:
	return not _snapshot.is_empty()


func last_entry() -> Dictionary:
	return _last_entry


func last_text() -> String:
	return _last_text


func last_error() -> String:
	return _last_error


func is_busy() -> bool:
	return _busy


func match_tokens() -> int:
	return _match_tokens


# ────────────────────────────── 发请求 ──────────────────────────────

## 返回 "" = 已发出；否则是不能发的原因
func request_debrief() -> String:
	var blocked := can_request()
	if blocked != "":
		_last_error = blocked
		return blocked
	var provider := CatalogScript.resolve(provider_id)
	var use_model := resolved_model()
	var url := RequestBuilder.endpoint(provider, base_url_override, use_model)
	var digest_text := DigestScript.to_text(DigestScript.build(_snapshot))
	var messages := PromptScript.debrief_messages(digest_text)
	var body := RequestBuilder.payload_json(provider, use_model, messages, max_tokens_per_call)
	var headers := RequestBuilder.headers(provider, _key)
	_pending = {
		"provider": provider_id,
		"model": use_model,
		"dialect": String(provider.get("dialect", CatalogScript.DIALECT_OPENAI)),
		"prompt_tokens_est": PromptScript.estimate_prompt_tokens(digest_text),
	}
	_busy = true
	_last_error = ""
	_started_usec = Time.get_ticks_usec()
	debrief_started.emit()
	var err := _http.request(url, headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		# 请求根本没发出去：也要记一条（否则玩家会以为「没花钱」，而 HTTP 层可能已经建连）
		_record_and_emit(Parser.network_failure(err), 0)
		return _last_error
	return ""


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if not _busy:
		return
	if result != HTTPRequest.RESULT_SUCCESS:
		_record_and_emit(Parser.network_failure(result), response_code)
		return
	var dialect := String(_pending.get("dialect", CatalogScript.DIALECT_OPENAI))
	_record_and_emit(Parser.parse(dialect, response_code, body.get_string_from_utf8()), response_code)


func _record_and_emit(parsed: Dictionary, response_code: int) -> void:
	var latency := int((Time.get_ticks_usec() - _started_usec) / 1000)
	var entry: Dictionary = _led().record(_entry_for(parsed, response_code, latency))
	_last_entry = entry
	_match_tokens += int(entry.get("total_tokens", 0))
	_busy = false
	if bool(parsed.get("ok", false)):
		_last_text = String(parsed.get("text", ""))
		_last_error = ""
	else:
		_last_error = "%s：%s" % [Parser.error_text(String(parsed.get("error_code", ""))),
				String(parsed.get("error_message", ""))]
	debrief_finished.emit(bool(parsed.get("ok", false)), _last_text, entry)
	usage_changed.emit()


func _entry_for(parsed: Dictionary, response_code: int, latency_ms: int) -> Dictionary:
	var usage: Dictionary = parsed.get("usage", {})
	var model_id := String(_pending.get("model", ""))
	var prompt := int(usage.get("prompt_tokens", 0))
	var completion := int(usage.get("completion_tokens", 0))
	var cached := int(usage.get("cached_tokens", 0))
	return {
		"provider": String(_pending.get("provider", "")),
		"model": model_id,
		"purpose": "debrief",
		"phase": "post_match",
		"session_id": _session_id,
		"prompt_tokens": prompt,
		"completion_tokens": completion,
		"cached_tokens": cached,
		"reasoning_tokens": int(usage.get("reasoning_tokens", 0)),
		"total_tokens": int(usage.get("total_tokens", prompt + completion)),
		"est_cost_micros": PriceTable.cost_micros(model_id, prompt, completion, cached),
		"currency": PriceTable.currency_of(model_id),
		"price_version": PriceTable.VERSION,
		"latency_ms": latency_ms,
		"http_status": response_code,
		"status": "ok" if bool(parsed.get("ok", false)) else "error",
		"error_code": String(parsed.get("error_code", "")),
		"error_message": String(parsed.get("error_message", "")).substr(0, 300),
	}


# ────────────────────────────── 用量查询 / 导出 ──────────────────────────────

func today_key() -> String:
	return Time.get_date_string_from_system()


func tokens_today() -> int:
	return _led().tokens_on_date(today_key())


func day_summary(date_key: String) -> Dictionary:
	var agg: Dictionary = _led().aggregate(_led().load_all())
	var day: Variant = (agg["by_day"] as Dictionary).get(date_key, null)
	if typeof(day) != TYPE_DICTIONARY:
		return {"calls": 0, "tokens": 0, "cost": {}}
	return day


func total_summary() -> Dictionary:
	return _led().aggregate(_led().load_all())


func usage_text() -> String:
	var today := day_summary(today_key())
	var all := total_summary()
	var lines: Array[String] = []
	lines.append("今日：%d 次调用 ｜ %d token ｜ %s" % [
			int(today.get("calls", 0)), int(today.get("tokens", 0)),
			_format_cost(today.get("cost", {}))])
	lines.append("累计：%d 次调用 ｜ %d token（失败 %d 次）" % [
			int(all.get("calls", 0)), int(all.get("total_tokens", 0)), int(all.get("failed", 0))])
	lines.append("累计估算花费：%s" % _format_cost(all.get("cost", {})))
	var by_model: Dictionary = all.get("by_model", {})
	if not by_model.is_empty():
		lines.append("")
		lines.append("按模型：")
		for m in by_model.keys():
			var g: Dictionary = by_model[m]
			lines.append("  %s：%d 次 ｜ %d token ｜ %s" % [m, int(g.get("calls", 0)),
					int(g.get("tokens", 0)), _format_cost(g.get("cost", {}))])
	if int(all.get("unknown_price", 0)) > 0:
		lines.append("")
		lines.append("（%d 次调用用了价目表外的模型，费用显示「未知」—— 记账不猜数）"
				% int(all.get("unknown_price", 0)))
	if not _last_entry.is_empty():
		lines.append("")
		lines.append("最近一次：%s ｜ %s ｜ 入 %d / 出 %d / 缓存 %d token ｜ %s ｜ %d ms" % [
			String(_last_entry.get("model", "")), String(_last_entry.get("status", "")),
			int(_last_entry.get("prompt_tokens", 0)), int(_last_entry.get("completion_tokens", 0)),
			int(_last_entry.get("cached_tokens", 0)),
			_format_cost({String(_last_entry.get("currency", "")):
					int(_last_entry.get("est_cost_micros", -1))}),
			int(_last_entry.get("latency_ms", 0))])
	return "\n".join(lines)


func _format_cost(cost: Variant) -> String:
	if typeof(cost) != TYPE_DICTIONARY:
		return "—"
	var d: Dictionary = cost
	if d.is_empty():
		return "—"
	var parts: Array[String] = []
	for currency in d.keys():
		parts.append(PriceTable.format_micros(int(d[currency]), String(currency)))
	return " ＋ ".join(parts) + "（估算）"


## 导出 CSV（玩家拿它去和自己的供应商账单对账）。返回路径，"" = 没数据/写不了
func export_csv() -> String:
	var all: Array = _led().load_all()
	if all.is_empty():
		return ""
	var f := FileAccess.open(EXPORT_PATH, FileAccess.WRITE)
	if f == null:
		return ""
	f.store_string(ledger.to_csv(all))
	f.close()
	return EXPORT_PATH


func clear_records() -> int:
	var removed: int = _led().clear()
	_last_entry = {}
	usage_changed.emit()
	return removed


# ────────────────────────────── 配置与密钥 ──────────────────────────────

func set_api_key(raw: String) -> bool:
	_key = raw.strip_edges()
	return _vault.save_key(_key)


func clear_api_key() -> void:
	_key = ""
	_vault.clear()


func save_config() -> bool:
	var cfg := ConfigFile.new()
	cfg.set_value("advisor", "enabled", enabled)
	cfg.set_value("advisor", "provider", provider_id)
	cfg.set_value("advisor", "model", model)
	cfg.set_value("advisor", "base_url", base_url_override)
	cfg.set_value("advisor", "max_tokens_per_call", max_tokens_per_call)
	cfg.set_value("advisor", "budget_tokens_per_match", budget_tokens_per_match)
	cfg.set_value("advisor", "budget_tokens_per_day", budget_tokens_per_day)
	cfg.set_value("advisor", "auto_debrief", auto_debrief)
	cfg.set_value("advisor", "competitive", competitive)
	# ⚠ key 不进这个文件（分文件混淆存放，见 AiKeyVault 头部说明）
	return cfg.save(CONFIG_PATH) == OK


func _load_config() -> void:
	enabled = bool(DEFAULTS["enabled"])
	provider_id = String(DEFAULTS["provider"])
	model = String(DEFAULTS["model"])
	base_url_override = String(DEFAULTS["base_url"])
	max_tokens_per_call = int(DEFAULTS["max_tokens_per_call"])
	budget_tokens_per_match = int(DEFAULTS["budget_tokens_per_match"])
	budget_tokens_per_day = int(DEFAULTS["budget_tokens_per_day"])
	auto_debrief = bool(DEFAULTS["auto_debrief"])
	competitive = bool(DEFAULTS["competitive"])
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK:
		return
	enabled = bool(cfg.get_value("advisor", "enabled", enabled))
	provider_id = String(cfg.get_value("advisor", "provider", provider_id))
	model = String(cfg.get_value("advisor", "model", model))
	base_url_override = String(cfg.get_value("advisor", "base_url", base_url_override))
	max_tokens_per_call = int(cfg.get_value("advisor", "max_tokens_per_call", max_tokens_per_call))
	budget_tokens_per_match = int(cfg.get_value("advisor", "budget_tokens_per_match", budget_tokens_per_match))
	budget_tokens_per_day = int(cfg.get_value("advisor", "budget_tokens_per_day", budget_tokens_per_day))
	auto_debrief = bool(cfg.get_value("advisor", "auto_debrief", auto_debrief))
	competitive = bool(cfg.get_value("advisor", "competitive", competitive))
