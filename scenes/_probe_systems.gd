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
	for path in SUSPECTS:
		if _by_script.has(path):
			var nodes: Array = _by_script[path]
			_variants.append({"name": "关_%s(%d)" % [str(path).get_file(), nodes.size()], "kind": "script", "nodes": nodes})
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
	var max_stall := 0.0
	for v in _stalls:
		max_stall = maxf(max_stall, float(v))
	var row: Dictionary = {
		"name": str(_variants[_index]["name"]),
		"p50": sorted[int(float(count) * 0.5)],
		"p99": sorted[mini(int(float(count) * 0.99), count - 1)],
		"max": sorted[count - 1],
		"stalls": _stalls.size(),
		"worst": max_stall,
	}
	_results.append(row)
	print("[卡顿] %-30s p50=%6.3f p99=%7.3f max=%7.3f ms｜>10ms %3d 次（最大 %.1f）" % [
			row["name"], row["p50"], row["p99"], row["max"], row["stalls"], row["worst"]])


func _summary() -> void:
	if _results.is_empty():
		return
	var base: Dictionary = _results[0]
	for row in _results:
		if str(row["name"]).begins_with("99_"):
			base = row
	print("[卡顿归属·汇总] 基线 = %s（>10ms %d 次/%.1fs，最大 %.1f ms）" % [
			base["name"], base["stalls"], WINDOW_S, base["worst"]])
	var rows: Array = _results.duplicate()
	rows.sort_custom(_cmp_stalls)
	for row in rows:
		print("    %-30s >10ms=%3d 次  最大=%6.1f ms  p99=%7.3f" % [
				row["name"], row["stalls"], row["worst"], row["p99"]])
