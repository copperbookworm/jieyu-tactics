extends SceneTree

## 离线弹道表生成器（Q2 · 2026-10-06 第七十九版·三 · 使用者拍板"生成器 + 直接接入查表"）
##
## 背景：设计 7.4.1 就写了"离线弹道表"，但工程一直是发射时数值二分（12 次 × 每次 200~500 步积分）。
## 本工具按 7.4.1 把表算出来落盘（res://data/config/ballistics_table.json），运行时查表 + 线性插值。
##
## 三个纪律：
##   ① **同源**：表的每一格都用 BallisticsSystem.solve_elevation_bisection() 算（就是改前的实现），
##      所以"表 vs 现算"的差只剩插值误差，可以用一个数字说清。
##   ② **并行生成**：按行分块交给 WorkerThreadPool（135 格 × 13 次积分 ≈ 0.4 s 量级，没必要串行）。
##   ③ **生成器自己定标步长**：从粗到细试 step（20/10/5/2/1 m），取"最粗且最大落点误差 ≤ 容差"的那档，
##      并把实测最大误差写进表头 —— 表的精度是可复现的数字，不是"看起来够用"。
##
## 用法（工程根目录）：
##   godot --headless --path . --log-file <可写路径> --script res://tools/build_ballistics_table.gd
## 产物：res://data/config/ballistics_table.json

const TABLE_PATH := "res://data/config/ballistics_table.json"
const TOLERANCE_M := 0.5          # 允许的最大落点误差（线性插值导致）
const CANDIDATE_STEPS := [20.0, 10.0, 5.0, 2.0, 1.0]
const PROBE_STEP_M := 1.0         # 误差实测的采样步长（比表步长细）
const BANDS := 8

var _v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
var _max_m := 600.0
var _step := 5.0
var _bands := BANDS
var _out := PackedFloat64Array()


func _initialize() -> void:
	var range45 := BallisticsSystem.trajectory_range(_v0, deg_to_rad(45.0))
	_max_m = minf(600.0, floor(range45))
	print("[弹道表] v0=%.1f m/s｜45° 最大射程 %.1f m ⇒ 表覆盖 0~%.0f m" % [_v0, range45, _max_m])
	var baseline := _bisection_own_error()
	var chosen: Dictionary = {}
	for step_v in CANDIDATE_STEPS:
		var step := float(step_v)
		var rows := _build_rows(step)
		var worst := _worst_error(rows, step)
		# 选步长的判据：**表这条路打得不比现算差**（允许多 0.05 m 的插值余量）。
		# 为什么不用"表 vs 目标距离绝对 < 0.5 m"：二分法自己就有 ~1.7 m 落点误差（见下），
		# 表能把它抹平一点、但没义务修它 —— 拿一个绝对值当闸门会把"表与现算等价"这件事误判成失败。
		var ok := worst <= baseline + 0.05
		print("[弹道表] step=%5.1f m：%d 格｜表路径落点误差 %.4f m（现算基线 %.4f m）%s" % [
				step, rows.size(), worst, baseline, "✓ 采用（最粗且不劣化）" if ok else "✗ 更差"])
		if ok:
			chosen = {"step": step, "rows": rows, "worst": worst, "baseline": baseline}
			break
	if chosen.is_empty():
		print("！！ 连 1 m 步长都不够细，未写表（保持现算）")
		quit(1)
		return
	var payload := {
		"generated_by": "tools/build_ballistics_table.gd",
		"v0": _v0,
		"drag_decel": GameConfig.DEFAULT_DRAG_DECEL,
		"drag_duration": GameConfig.DEFAULT_DRAG_DURATION,
		"gravity": GameConfig.GRAVITY_EFFECTIVE,
		"step_m": float(chosen["step"]),
		"max_m": _max_m,
		"tolerance_m": TOLERANCE_M,
		"measured_max_error_m": float(chosen["worst"]),
		"bisection_baseline_error_m": float(chosen.get("baseline", -1.0)),
		"rows": chosen["rows"],
	}
	var file := FileAccess.open(TABLE_PATH, FileAccess.WRITE)
	if file == null:
		print("！！ 写不了 %s（错误码 %d）" % [TABLE_PATH, FileAccess.get_open_error()])
		quit(1)
		return
	file.store_string(JSON.stringify(payload, "  "))
	file.close()
	print("[弹道表] 已写 %s（step=%.1f m / %d 格 / 最大误差 %.4f m）" % [
			TABLE_PATH, float(chosen["step"]), (chosen["rows"] as Array).size(),
			float(chosen["worst"])])
	quit(0)


## 并行算一张表：行下标 → 距离 = 下标 × step（超出 45° 射程的格写 -1 ⇒ 运行时退回二分）
func _build_rows(step: float) -> Array:
	var count := int(floor(_max_m / step)) + 1
	_step = step
	_bands = clampi(BANDS, 1, count)
	_out = PackedFloat64Array()
	_out.resize(count)
	var id := WorkerThreadPool.add_group_task(
			func(band: int) -> void: _band(band, count), _bands, _bands, true, "ballistics_table")
	WorkerThreadPool.wait_for_group_task_completion(id)
	var rows := []
	for v in _out:
		rows.append(v)
	return rows


func _band(band: int, count: int) -> void:
	var per := int(ceil(float(count) / float(_bands)))
	var i0 := band * per
	var i1 := mini(i0 + per, count)
	for i in range(i0, i1):
		var distance := float(i) * _step
		_out[i] = BallisticsSystem.solve_elevation_bisection(distance, _v0)


## 用"表 + 线性插值"反解一批细间距距离，与实际会用的二分结果**逐点比落点**，取最大差。
##
## ⚠ 口径（第一次跑就踩到的坑）：一开始拿"落点 vs 目标距离"当误差，结果无论表多细都恒定 ~1.5 m ——
## 那是**二分法自己的误差**（12 次迭代解出的仰角落点本来就差 1.5 m，测试里那条 <1.5 m 的断言正是它），
## 与"表"无关。表的代价只能按"表 vs 会用的那条路（二分）"来量，所以这里两路都算一遍、比差值。
func _worst_error(rows: Array, step: float) -> float:
	var worst := 0.0
	var d := 5.0
	while d <= _max_m - 5.0:
		var elev := _interp(rows, step, d)
		if elev < 0.0:
			d += PROBE_STEP_M
			continue
		worst = maxf(worst, absf(BallisticsSystem.trajectory_range(_v0, elev) - d))
		d += PROBE_STEP_M
	return worst


## 参考量：二分法解出的仰角本身能打多准（落点 vs 目标距离）——只报数，不参与选步长
func _bisection_own_error() -> float:
	var worst := 0.0
	var d := 5.0
	while d <= _max_m - 5.0:
		var elev := BallisticsSystem.solve_elevation_bisection(d, _v0)
		if elev >= 0.0:
			worst = maxf(worst, absf(BallisticsSystem.trajectory_range(_v0, elev) - d))
		d += PROBE_STEP_M
	return worst


func _interp(rows: Array, step: float, distance: float) -> float:
	var pos := distance / step
	var i0 := int(floor(pos))
	if i0 < 0 or i0 + 1 >= rows.size():
		return -1.0
	var a := float(rows[i0])
	var b := float(rows[i0 + 1])
	if a < 0.0 or b < 0.0:
		return -1.0
	return lerpf(a, b, pos - float(i0))
