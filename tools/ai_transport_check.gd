extends SceneTree

## AI 参谋 · 网络链路端到端自检（对着本地 mock 供应商，不花一分钱）
##
## 为什么必须有它：单元测试只能验纯函数。这条真正走 HTTPRequest → TCP → mock → JSON 解析
## → usage 归一 → 写进 user:// 账本，并且**反查 mock 侧留档**，证明「发出去的 prompt 里
## 真的带着战报」。这是「能接上 API」这句话唯一的硬证据。
##
## 用法（两件事，mock 先起）：
##   node tools/ai_mock_server.mjs 8123 "<proj>/tmp_ai_mock_last.json"
##   godot --headless --path <proj> --log-file <可写路径> \
##         --script res://tools/ai_transport_check.gd -- --port=8123
## 退出码：0 = 全绿，1 = 有失败。

const AdvisorScript := preload("res://systems/ai/AiAdvisor.gd")
const LedgerScript := preload("res://systems/ai/AiUsageLedger.gd")

const MOCK_LOG := "res://tmp_ai_mock_last.json"
const E2E_LEDGER_DIR := "user://ai_usage_e2e"
const DEADLINE := 30.0

var _advisor = null
var _ledger = null
var _passed := 0
var _failed := 0
var _stage := 0
var _elapsed := 0.0
var _done := false
var _port := 8123


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--port="):
			_port = int(a.substr(7))
	print("===== AI 参谋 · 网络链路端到端自检（mock 端口 %d）=====" % _port)
	# 用独立目录，绝不碰玩家真实的 user://ai_usage
	_ledger = LedgerScript.new(E2E_LEDGER_DIR)
	_ledger.clear()
	_advisor = AdvisorScript.new()
	_advisor.name = "AiAdvisorE2E"
	_advisor.ledger_dir = E2E_LEDGER_DIR
	root.add_child(_advisor)
	var main = _fake_main()
	root.add_child(main)
	current_scene = main
	# ⚠ 配置必须等到第一个 _process 帧：--script 模式下节点的 _ready 在 _initialize 之后才跑，
	#   而 _ready 里的 _load_config() 会把这里设的值覆盖回默认值（踩过）。


func _process(delta: float) -> bool:
	if _done:
		return true
	_elapsed += delta
	if _stage == 0:
		_stage = 1
		_configure_and_fire()
		return false
	if _elapsed > DEADLINE:
		_check_true("30 s 内拿到响应（mock 起来了吗？）", false)
		_report()
		_done = true
		quit(1)
		return true
	return false


## 第一帧才做：_ready 已经跑完（配置、密钥保管、HTTPRequest 都已就位）
func _configure_and_fire() -> void:
	_advisor.provider_id = "custom"
	_advisor.base_url_override = "http://127.0.0.1:%d" % _port
	_advisor.model = "mock-model"
	_advisor.enabled = true
	_advisor.competitive = false
	_advisor.auto_debrief = false
	_advisor.max_tokens_per_call = 64
	_advisor.budget_tokens_per_match = 0
	_advisor.budget_tokens_per_day = 0
	_check_true("API key 存进本机（不落明文）", _advisor.set_api_key("sk-mock-test"))
	_check_true("key 回读一致", _advisor.key_is_set())
	_advisor.debrief_finished.connect(_on_finished)
	_advisor._on_match_finished("player")
	_check_true("战局快照抓到了", _advisor.has_snapshot())
	_check("预算/前置检查放行（本局与今日都不设上限）", _advisor.request_debrief(), "")


func _on_finished(ok: bool, text: String, entry: Dictionary) -> void:
	if _stage == 1:
		_stage = 2
		_check_true("第一次请求成功", ok)
		_check_true("拿到复盘正文", text.contains("【战局判定】"))
		_check("usage.prompt_tokens 归一", int(entry.get("prompt_tokens", 0)), 123)
		_check("usage.completion_tokens 归一", int(entry.get("completion_tokens", 0)), 45)
		_check("缓存命中字段归一（prompt_cache_hit_tokens）", int(entry.get("cached_tokens", 0)), 100)
		_check("usage.total_tokens 归一", int(entry.get("total_tokens", 0)), 168)
		_check("表外模型 → 费用记「未知」而不是 0", int(entry.get("est_cost_micros", 0)), -1)
		_check("状态记 ok", String(entry.get("status", "")), "ok")
		_check_true("延迟被记下来", int(entry.get("latency_ms", -1)) >= 0)
		_check("本局 token 计数累加", _advisor.match_tokens(), 168)
		_verify_request_against_mock()
		# 第二次：401 分支（key 无效要能被正确分类并记账）
		_advisor.model = "mock-unauthorized"
		_stage = 3
		_check("第二次请求放行", _advisor.request_debrief(), "")
		return
	if _stage == 3:
		_stage = 4
		_check_true("401 时 ok 为 false", not ok)
		_check("401 归类为 bad_key", String(entry.get("error_code", "")), "bad_key")
		_check("失败也记账（status=error）", String(entry.get("status", "")), "error")
		_check_true("失败原因说给玩家听", _advisor.last_error().contains("API key"))
		var all: Array = _ledger.load_all()
		_check("账本落了两条", all.size(), 2)
		_check("账本按币种分装（未知价不入金额）", _ledger.aggregate(all)["cost"], {})
		_check("账本汇总识别出 1 次带 usage 的调用", int(_ledger.aggregate(all)["prompt_tokens"]), 123)
		_report()
		_ledger.clear()
		_done = true
		quit(0 if _failed == 0 else 1)


## 反查 mock 留档：证明请求真的发对了地方、带对了头与体、prompt 里真有战报
func _verify_request_against_mock() -> void:
	var f := FileAccess.open(MOCK_LOG, FileAccess.READ)
	if f == null:
		_check_true("mock 侧写了请求留档 %s" % MOCK_LOG, false)
		return
	var raw := f.get_as_text()
	f.close()
	var parsed: Variant = JSON.parse_string(raw)
	_check_true("请求留档是 JSON", typeof(parsed) == TYPE_DICTIONARY)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var d: Dictionary = parsed
	# custom 这个 provider 的 path 是 /v1/chat/completions（中转站/自建网关的常见形状）
	_check("请求打到 OpenAI 兼容路径", String(d.get("path", "")), "/v1/chat/completions")
	_check("请求方法是 POST", String(d.get("method", "")), "POST")
	_check("key 进的是 Authorization 头（不进 URL）", String(d.get("auth", "")), "Bearer sk-mock-test")
	_check("请求体带了模型名", String(d.get("model", "")), "mock-model")
	_check("请求体带了 max_tokens", int(d.get("max_tokens", 0)), 64)
	_check("刻意非流式", bool(d.get("stream", true)), false)
	var messages: Array = d.get("messages", [])
	_check("两条消息：system + user", messages.size(), 2)
	var user := String((messages[1] as Dictionary).get("content", ""))
	_check_true("prompt 里真有战报 · 结局", user.contains("结局: 我方胜利"))
	_check_true("prompt 里真有战报 · 节点", user.contains("N1=我方(0.82)"))
	_check_true("prompt 里真有战报 · 任务", user.contains("占领 N1"))
	_check_true("prompt 里真有战报 · 击杀", user.contains("击杀: 0"))


# ────────────────── 造一个「像 Main 的」场景根 ──────────────────
# 用动态脚本造，好处是不依赖 Main.tscn、也不引任何全局 class_name，
# 同时把 capture_snapshot 的属性抓取逻辑一起验了。

func _fake_main() -> Object:
	var zones: Array = [
		_make("extends RefCounted\nvar state := 1\nvar progress := 0.82\n"),
		_make("extends RefCounted\nvar state := 2\nvar progress := -0.31\n"),
		_make("extends RefCounted\nvar state := 0\nvar progress := 0.0\n"),
	]
	var flow = _make("extends Node\nvar reason := \"时间到：占领数 3 : 1\"\nvar phase := 1\nvar time_left := 58.0\nvar budget := 6\n")
	var quests = _make("extends Node\nvar completed_count := 1\nfunc main_quest() -> Dictionary:\n\treturn {\"name\": \"占领 N1\"}\n")
	var vehicles = _make("extends Node\nvar vehicle = null\nvar enemy_vehicle = null\n")
	var main = _make("extends Node2D\nvar score := 240\nvar player_role := 0\nvar match_flow = null\nvar capture_zones := []\nvar quests = null\nvar vehicles = null\n")
	main.name = "Main"
	main.match_flow = flow
	main.capture_zones = zones
	main.quests = quests
	main.vehicles = vehicles
	return main


func _make(source: String) -> Object:
	var s := GDScript.new()
	s.source_code = source
	if s.reload() != OK:
		_check_true("动态测试脚本编译失败：%s" % source.substr(0, 40), false)
		return null
	return s.new()


# ────────────────── 断言小工具（口径同 test/ 那套）──────────────────

func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _report() -> void:
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
