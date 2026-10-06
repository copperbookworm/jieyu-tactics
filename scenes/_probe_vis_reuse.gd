extends Node

## 【临时 · 可见性复用（施工单 A）微基准】跑完可删（2026-10-06 · 第七十七版）
##
## 为什么不能用 tools/scale_probe.gd 量 A：
##   `_update_visibility` 一开头就是框检测 `in_world_view(...)`，headless 里相机状态没有意义，
##   实测**改前改后都是 2 µs** —— 它提前 return 了，压根没走到 has_sight。所以那个探针量不到本改动。
##   本探针把相机摆到敌人身上，让框检测**通过**，再分别量两条路径：
##     · 复用路径：缓存正对当前目标（A 之后的 `_update_visibility`）
##     · 重算路径：缓存作废（等价于 A 之前的 `_update_visibility`，每次都现算 has_sight）
##
## 用法：godot --headless --path <proj> res://scenes/_probe_vis_reuse.gd（用 .tscn 启动）

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const WARMUP_S := 4.0
const REPEAT := 60            # 每个路径重复次数（取平均）

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
	if _main == null or _main.sight == null or _main.player == null:
		print("[A微基准] 场景没准备好，放弃")
		return
	var enemies := _live_enemies()
	if enemies.is_empty():
		print("[A微基准] 没有活着的敌人，放弃")
		return
	var e = enemies[0]
	var cam = _main.camera
	if cam == null:
		print("[A微基准] 没有相机，无法让框检测通过，放弃")
		return
	# 把相机摆到敌人身上 ⇒ in_world_view 必过（这正是 scale_probe 做不到的）
	cam.global_position = e.global_position
	e._player = _main.player
	e._target = _main.player
	e.alive = true
	var passes: bool = bool(_main.sight.in_world_view(e.global_position,
			cam.global_position, cam.zoom.x))
	print("[A微基准] 敌人 %s｜框检测通过=%s｜目标==玩家=%s" % [
			str(e.name), str(passes), str(e._target == e._player)])
	if not passes:
		print("[A微基准] 框检测仍不通过，测不到，放弃")
		return

	# ① 重算路径：缓存作废 ⇒ 每次现算 has_sight（= A 之前的行为）
	var t0 := Time.get_ticks_usec()
	for i in REPEAT:
		e._cache_sees(null, false)
		e._update_visibility()
	var recompute_us := float(Time.get_ticks_usec() - t0) / float(REPEAT)

	# ② 复用路径：缓存正对当前目标 ⇒ 直接取缓存（= A 之后的行为）
	t0 = Time.get_ticks_usec()
	for i in REPEAT:
		e._cache_sees(e._player, true)
		e._update_visibility()
	var reuse_us := float(Time.get_ticks_usec() - t0) / float(REPEAT)

	var ratio := 0.0
	if reuse_us > 0.0:
		ratio = recompute_us / reuse_us
	print("[A微基准·结果] 可见性一次调用：重算 **%.1f µs** → 复用 **%.1f µs**（快 %.1f×，省 %.1f µs/次）" % [
			recompute_us, reuse_us, ratio, recompute_us - reuse_us])
	# 换算到帧预算：可见性 10 Hz（每 0.1 s 一次）、20 个敌人
	var per_frame_us := (recompute_us - reuse_us) * 20.0 / 6.0
	print("[A微基准·换算] 20 敌 × 10 Hz、按 60 Hz 帧折算：约省 **%.0f µs/帧**（一帧预算 16667 µs 的 %.2f%%）" % [
			per_frame_us, 100.0 * per_frame_us / 16667.0])
	print("[A微基准·口径] debug 编辑器构建、单点重复 %d 次；绝对值偏悲观，看两条路径的比值与差值" % REPEAT)
