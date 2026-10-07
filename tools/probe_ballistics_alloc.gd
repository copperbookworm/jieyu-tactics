extends SceneTree

## 【P1-B 取证探针 · 2026-10-06 第七十九版】弹道求解去分配（trajectory_range）值多少？
##
## 口径：桌面 headless、debug；同一批 (v0, 距离)，各跑 N 次取总时长。
## "旧口径" = trajectory() 建点数组再取最后一点；"新口径" = trajectory_range() 只算落点。
## 数值等价性由 test/indirect_test.gd 的 _test_range_matches_trajectory_exactly 钉住。
##
## 用法：godot --headless --path . --log-file <可写路径> --script res://tools/probe_ballistics_alloc.gd

const ROUNDS := 40
const DISTANCES := [120.0, 200.0, 300.0, 400.0]


func _old_range(v0: float, elevation: float, distance: float) -> float:
	var points := BallisticsSystem.trajectory(v0, elevation, distance)
	if points.size() <= 1:
		return 0.0
	var last: Dictionary = points[points.size() - 1]
	return float(last["x"])


func _old_solve(distance: float, v0: float) -> float:
	if _old_range(v0, deg_to_rad(45.0), 600.0) < distance:
		return -1.0
	var low := 0.0
	var high := deg_to_rad(45.0)
	for i in 12:
		var mid := (low + high) * 0.5
		if _old_range(v0, mid, 600.0) < distance:
			low = mid
		else:
			high = mid
	return high


func _initialize() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var t := Time.get_ticks_usec()
	var acc_old := 0.0
	for r in ROUNDS:
		for d in DISTANCES:
			acc_old += _old_solve(float(d), v0)
	var old_ms := float(Time.get_ticks_usec() - t) / 1000.0

	t = Time.get_ticks_usec()
	var acc_new := 0.0
	for r in ROUNDS:
		for d in DISTANCES:
			acc_new += BallisticsSystem.solve_elevation_dragged(float(d), v0)
	var new_ms := float(Time.get_ticks_usec() - t) / 1000.0
	var calls := ROUNDS * DISTANCES.size()
	print("[弹道去分配] %d 次反解：旧（建点数组）%.1f ms | 新（只算落点）%.1f ms | 提速 %.2fx | 单次 %.3f → %.3f ms" % [
			calls, old_ms, new_ms, old_ms / maxf(new_ms, 0.001), old_ms / calls, new_ms / calls])
	print("[弹道去分配] 两次结果一致: %s（%.3f vs %.3f）" % [
			str(absf(acc_old - acc_new) < 0.001), acc_old, acc_new])
	quit(0)
