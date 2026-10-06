extends Node

## 【临时 · 轨 2 卡顿归属探针 v4】（跑完可删）
## v3 已证明：**把游戏脚本全关，整场 20v20 的 p50=0.002ms、p99=0.004ms、卡顿 1 次**（只剩开局那一下）
## ⇒ 每 1.5s 那 13~20 次 >10ms 的卡顿 **全来自游戏脚本**（物理/引擎不是原因）。
## v4 按脚本分组关停，数「>10ms 卡顿次数」——哪一组关掉后卡顿消失，哪一组就是元凶。
##
## 用法：godot --headless --path <proj> res://scenes/_probe_systems.tscn

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const WARMUP_S := 3.0
const WINDOW_S := 1.2
const HARD_LIMIT_S := 150.0
const STALL_MS := 10.0

## 分组顺序按「周期性可疑度」排：0.1s / 1s 节流的、HUD 文本、特效、任务
const SUSPECTS: Array = [
	"res://entities/enemy/Enemy.gd",
	"res://entities/ally/Ally.gd",
	"res://entities/player/Player.gd",
	"res://ui/MiniMap.gd",
	"res://ui/MarkOverlay.gd",
	"res://ui/HudBuilder.gd",
	"res://ui/QuestCard.gd",
	"res://ui/CombatFeedPanel.gd",
	"res://ui/IndirectOverlay.gd",
	"res://ui/TacticalMap.gd",
	"res://systems/effects/EffectSpawner.gd",
	"res://systems/match/MatchFlow.gd",
	"res://systems/quest/QuestSystem.gd",
	"res://systems/marks/MarkSystem.gd",
	"res://entities/visual/UnitFigure.gd",
	"res://entities/effects/BlobShadow.gd",
	"res://systems/ai/AiAdvisor.gd",
	"res://systems/audio/AudioSystem.gd",
	# 2026-10-06 M3 补齐（施工单 改动1.md §4 M3 点名的 x3/x4/x5/x7，原清单缺）
	"res://ui/DebugEnemyArrow.gd",                    # x3：每帧 get_nodes_in_group("enemy") 遍历全场
	"res://systems/combat/Tracer.gd",                 # x4/x5：曳光节点（每发一颗，逐帧移动）
	"res://entities/effects/MuzzleFlash.gd",          # x4：枪口火光
	"res://scenes/gameplay/PlayerFireController.gd",  # x5：玩家开火链
	"res://scenes/gameplay/ExplosiveController.gd",   # x7
	"res://systems/combat/IndirectFire.gd",           # x7
	"res://ui/PerfOverlay.gd",                        # debug-only；本探针不走 MatchHost ⇒ 通常不会命中
]

var _main: Node = null
var _samples: Array = []
var _stalls: Array = []
var _elapsed := 0.0
var _window := 0.0
var _hard := 0.0
var _index := -1
var _variants: Array = []
var _results: Array = []
var _by_script: Dictionary = {}
var _all_scripted: Array = []


func _ready() -> void:
	Engine.max_fps = 0
	OS.low_processor_usage_mode = false
	OS.low_processor_usage_mode_sleep_usec = 0
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = packed.instantiate()
	_main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(_main)
	_by_script = _collect_scripted()
	for key in _by_script.keys():
		_all_scripted.append_array(_by_script[key])
	_variants = [{"name": "00_基线", "kind": "none"}]
	_variants.append({"name": "01_全部脚本关", "kind": "all"})
	# 关键：**每个单项后面插一个基线**。单点基线会被"对局随时间演进（单位在死、战场在变）"污染——
	# 实测 00_基线 602.7 fps vs 99_基线重来 737.0 fps（差 22%），不夹基线时很多单项会算出**负增益**
	# （关 HUD −196 fps 之类），根本没有归因价值。夹了之后每项与「前后相邻基线的均值」比，
	# 漂移被压成一阶小量。
	var bi := 0
	for path in SUSPECTS:
		if _by_script.has(path):
			var nodes: Array = _by_script[path]
			bi += 1
			_variants.append({"name": "关_%s(%d)" % [str(path).get_file(), nodes.size()], "kind": "script", "nodes": nodes})
			_variants.append({"name": "_基线#%02d" % bi, "kind": "none"})
	_variants.append({"name": "99_基线重来", "kind": "none"})
	print("[卡顿归属] 敌人 %d 队友 %d｜分组 %d｜窗口 %d 个（每窗 %.1fs）" % [
			_main.enemy_count, MatchRulesScript.ally_count(), _by_script.size(), _variants.size(), WINDOW_S])


func _collect_scripted() -> Dictionary:
	var by_script: Dictionary = {}
	var stack: Array = [get_tree().root]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n != self:
			var s: Variant = n.get_script()
			if s is Script:
				var sc: Script = s
				var key: String = str(sc.resource_path)
				if not key.is_empty():
					if not by_script.has(key):
						by_script[key] = []
					by_script[key].append(n)
		for c in n.get_children():
			stack.append(c)
	return by_script


func _tick(nodes: Array, on: bool) -> void:
	for n in nodes:
		if is_instance_valid(n) and n != self:
			n.set_process(on)
			n.set_physics_process(on)


func _apply(idx: int, on: bool) -> void:
	var v: Dictionary = _variants[idx]
	var kind: String = v["kind"]
	if kind == "all":
		_tick(_all_scripted, on)
	elif kind == "script":
		var nodes: Array = v["nodes"]
		_tick(nodes, on)


func _process(delta: float) -> void:
	_hard += delta
	if _hard > HARD_LIMIT_S:
		push_warning("[卡顿归属] 硬性超时保护，提前退出")
		_summary()
		get_tree().quit(0)
		return
	_elapsed += delta
	if _index < 0:
		if _elapsed < WARMUP_S:
			return
		_elapsed = 0.0
		_advance(0)
		return
	_window += delta
	var ms := delta * 1000.0
	_samples.append(ms)
	if ms >= STALL_MS:
		_stalls.append(ms)
	if _window < WINDOW_S:
		return
	_window = 0.0
	_report()
	if _index + 1 < _variants.size():
		_advance(_index + 1)
	else:
		_summary()
		get_tree().quit(0)


func _advance(i: int) -> void:
	if _index >= 0:
		_apply(_index, true)      # 先恢复上一窗关掉的那组（否则会累积、窗窗都被污染）
	_index = i
	_apply(i, false)              # 只关这一窗要看的那组
	_samples.clear()
	_stalls.clear()


func _cmp_stalls(a: Dictionary, b: Dictionary) -> bool:
	return int(a["stalls"]) > int(b["stalls"])


func _report() -> void:
	var sorted: Array = _samples.duplicate()
	sorted.sort()
	var count: int = sorted.size()
	if count < 4:
		return
	var sum_ms := 0.0
	for v in _samples:
		sum_ms += float(v)
	var fps := 0.0
	if sum_ms > 0.0:
		fps = float(count) * 1000.0 / sum_ms
	var max_stall := 0.0
	for v in _stalls:
		max_stall = maxf(max_stall, float(v))
	var row: Dictionary = {
		"i": _index,
		"name": str(_variants[_index]["name"]),
		"frames": count,
		"fps": fps,
		"p50": sorted[int(float(count) * 0.5)],
		"p99": sorted[mini(int(float(count) * 0.99), count - 1)],
		"max": sorted[count - 1],
		"stalls": _stalls.size(),
		"worst": max_stall,
	}
	_results.append(row)
	print("[卡顿] %-34s fps=%6.1f p50=%6.3f p99=%7.3f max=%7.3f ms｜>10ms %3d 次" % [
			row["name"], row["fps"], row["p50"], row["p99"], row["max"], row["stalls"]])


## 按 Δfps 降序
func _cmp_delta(a: Dictionary, b: Dictionary) -> bool:
	return float(a["d"]) > float(b["d"])


func _is_base_name(nm: String) -> bool:
	return nm.begins_with("00_") or nm.begins_with("99_") or nm.begins_with("_基线")


## 参考 fps：取「执行顺序上最近的前一个基线」与「后一个基线」的均值（缺一侧就用另一侧）
func _ref_fps(idx: float, bases: Array) -> float:
	var prev: Dictionary = {}
	var next: Dictionary = {}
	for r in bases:
		var ri := float(r["i"])
		if ri < idx:
			prev = r
		elif next.is_empty():
			next = r
	if not prev.is_empty() and not next.is_empty():
		return (float(prev["fps"]) + float(next["fps"])) * 0.5
	if not prev.is_empty():
		return float(prev["fps"])
	if not next.is_empty():
		return float(next["fps"])
	return 0.0


func _summary() -> void:
	if _results.is_empty():
		return
	var bases: Array = []
	for row in _results:
		if _is_base_name(str(row["name"])):
			bases.append(row)
	if bases.size() >= 2:
		var f := float(bases[0]["fps"])
		var l := float(bases[bases.size() - 1]["fps"])
		var pct := 0.0
		if f > 0.0:
			pct = (l - f) * 100.0 / f
		print("[卡顿归属] 运行内基线漂移：首基线 fps=%.1f → 末基线 fps=%.1f（%+.1f%%）—— 所以下面每项都比「相邻基线均值」" % [f, l, pct])
	# 施工单 §4 M3 的验收口径：每项单独禁掉后的 fps 增量，且已用相邻基线消掉漂移
	var rows: Array = []
	for row in _results:
		if _is_base_name(str(row["name"])):
			continue
		var ref := _ref_fps(float(row["i"]), bases)
		rows.append({
			"name": str(row["name"]),
			"fps": float(row["fps"]),
			"ref": ref,
			"d": float(row["fps"]) - ref,
			"p99": float(row["p99"]),
		})
	rows.sort_custom(_cmp_delta)
	print("    %-34s %8s %8s %8s %8s" % ["变体（这一窗关掉的那一组）", "fps", "参考", "Δfps", "p99"])
	for r in rows:
		print("    %-34s %8.1f %8.1f %+8.1f %8.3f" % [r["name"], r["fps"], r["ref"], r["d"], r["p99"]])
	var singles: Array = []
	for r in rows:
		if str(r["name"]).begins_with("01_"):
			continue
		singles.append(r)
	if singles.size() >= 1:
		var n := mini(2, singles.size())
		var msg := "[卡顿归属·结论] 单项收益最大："
		for i in n:
			msg += "%s（Δfps=%+.1f）" % [singles[i]["name"], singles[i]["d"]]
			if i < n - 1:
				msg += "、"
		print(msg + " ⇒ 登记为下一步优化对象")
