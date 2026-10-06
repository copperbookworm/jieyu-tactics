extends Node

## 【临时 · C 项微基准】跑完可删（2026-10-06 · 第七十七版）
##
## 施工单 §7 的 C 项都是"每帧都付"的小刀，单看某一刀都可能落在噪声里 —— 所以这里逐个量"每次调用"的
## 差值，而不是去量整帧 fps（整帧会被对局状态漂移掩盖，第十八节已经吃过这个亏）。
##
## 量两件事：
##   ① 组查询 vs 帧级缓存：`get_tree().get_nodes_in_group("enemy")` 对比 `Ally._cached_enemies()`
##      —— C1（小地图 `_draw`）与 C3（debug 箭头 `_process`）改的都是这一处
##   ② `Enemy._process(dt)` 在"压制与闪白都归零"时的每次开销 —— C4
##      （改前/改后用同一个探针跑两次，差值就是 C4 省下的；见文件头的用法）
##
## 用法：godot --headless --path <proj> res://scenes/_probe_c_items.tscn

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const AllyScript := preload("res://entities/ally/Ally.gd")

const WARMUP_S := 4.0
const REPEAT := 2000          # 组查询/缓存：次数多些才盖得住噪声
const PROC_REPEAT := 600      # _process：10 s 的帧数

var _main: Node = null
var _t := 0.0
var _done := false


func _ready() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = packed.instantiate()
	_main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(_main)


func _process(delta: float) -> void:
	if _done:
		return
	_t += delta
	if _t < WARMUP_S:
		return
	_done = true
	_measure()
	get_tree().quit(0)


func _live_enemies() -> Array:
	var out: Array = []
	for n in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(n) and n.get("alive") != false:
			out.append(n)
	return out


func _measure() -> void:
	var enemies := _live_enemies()
	if enemies.is_empty():
		print("[C微基准] 没有活着的敌人，放弃")
		return
	var e = enemies[0]
	print("[C微基准] 活敌 %d 个" % enemies.size())

	# ① 组查询 vs 帧级缓存
	var t0 := Time.get_ticks_usec()
	for i in REPEAT:
		var raw: Array = get_tree().get_nodes_in_group("enemy")
		if raw.is_empty():
			break
	var raw_us := float(Time.get_ticks_usec() - t0) / float(REPEAT)
	t0 = Time.get_ticks_usec()
	for i in REPEAT:
		var cached: Array = AllyScript._cached_enemies()
		if cached.is_empty():
			break
	var cache_us := float(Time.get_ticks_usec() - t0) / float(REPEAT)
	print("[C微基准·①] 组查询 %.3f µs/次 → 帧级缓存 %.3f µs/次（省 %.3f µs，%.1f×）" % [
			raw_us, cache_us, raw_us - cache_us, raw_us / maxf(cache_us, 0.0001)])
	print("             换算：小地图每帧 1 次 + debug 箭头每帧 1 次 ⇒ 约省 %.1f µs/帧" % [
			(raw_us - cache_us) * 2.0])

	# ② Enemy._process（压制与闪白都归零、且上一帧没画过 ⇒ C4 的提前返回路径）
	e.suppression = 0.0
	e._hit_flash_left = 0.0
	e._suppression_drawn = false
	e._flash_drawn = false
	var dt := 1.0 / 60.0
	t0 = Time.get_ticks_usec()
	for i in PROC_REPEAT:
		e._process(dt)
	var proc_us := float(Time.get_ticks_usec() - t0) / float(PROC_REPEAT)
	print("[C微基准·②] 归零态 Enemy._process %.3f µs/次（20 敌 × 60 帧 ⇒ %.1f µs/帧）" % [
			proc_us, proc_us * 20.0])
	print("[C微基准·口径] headless debug 构建；②里探针也在跑可见性节拍，改前/改后同条件，看**差值**")
