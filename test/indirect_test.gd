@tool
extends EditorScript

## 间瞄解算测试（docx 7.4 闭式解）：仰角解出后弹道必须落回地面、射程边界、飞行时间、爆炸衰减
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 用 preload 引用两个刻意不写 class_name 的模块（见 Cover.gd 头部说明）
##
## 2026-09-30 口径修正（红基线归零）：第十三版把间瞄初速按射程反标定成 105 → 180 m/s，
## 而无阻力闭式解那几组断言还留在 105 m/s 时代的数上（飞行时间窗口、> 5 m 中段抬高、
## 「430 m 就算超射程」）。现在这些断言改成按当前 v0 现算 / 守物理关系，不再写死旧标定值。

const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_arc_lands_at_target()
	_test_out_of_range()
	_test_flight_time()
	_test_blast_falloff()
	_test_dragged_range_shorter()
	_test_dragged_solve_accuracy()
	_test_range_matches_trajectory_exactly()
	_test_trajectory_shape()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 闭式解自洽校验：解出的仰角，其弹道在水平距离 D 处的高度应回到 0（落回地面）
## v0 = 180 m/s 时低伸解本来就平（实测中段高度：80 m → 0.68 m、200 m → 4.27 m、350 m → 13.28 m），
## 所以不再断言「中段 > 5 m」这种与初速绑死的阈值，改守两条物理关系：
##   ① 中段确实抬离地面 ② 打得更远 → 抬得更高、仰角更大（单调）
func _test_arc_lands_at_target() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var last_mid := -1.0
	var last_elevation := -1.0
	for distance in [80.0, 200.0, 350.0]:
		var elevation := BallisticsSystem.solve_elevation(distance, v0)
		_check_true("解算：%.0f m 能解出仰角" % distance, elevation > 0.0)
		var arc := BallisticsSystem.solve_arc(distance, v0, elevation)
		var last: Dictionary = arc[arc.size() - 1]
		_check_true("解算：%.0f m 处弹道高度回到 0（误差 < 0.01 m）" % distance,
				absf(float(last["height"])) < 0.01)
		var middle: Dictionary = arc[int(arc.size() / 2)]
		var mid_height := float(middle["height"])
		_check_true("解算：%.0f m 的弹道中段抬离地面（%.2f m）" % [distance, mid_height],
				mid_height > 0.0)
		var rising := "解算：打得更远抬得更高（%.0f m 的中段 %.2f m > 上一档 %.2f m）"
		_check_true(rising % [distance, mid_height, last_mid], mid_height > last_mid)
		var steeper := "解算：仰角随射程单调递增（%.2f° > 上一档 %.2f°）"
		_check_true(steeper % [rad_to_deg(elevation), rad_to_deg(last_elevation)],
				elevation > last_elevation)
		last_mid = mid_height
		last_elevation = elevation


## 超出无阻力最大射程（v²/g_eff）时应解不出来。
## 注意：v0 = 180 m/s 时上限是 1179.6 m，430 m 当然解得出——越界点必须按当前 v0 现算。
func _test_out_of_range() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var max_range := v0 * v0 / GameConfig.GRAVITY_EFFECTIVE
	var beyond := max_range + 50.0
	var far_elevation := BallisticsSystem.solve_elevation(beyond, v0)
	_check_true("解算：%.0f m 超出无阻力射程 %.0f m → 返回负值（打不到）"
			% [beyond, max_range], far_elevation < 0.0)
	_check_true("解算：无阻力最大射程 %.0f m ≥ INDIRECT_MAX_RANGE %.0f m"
			% [max_range, GameConfig.INDIRECT_MAX_RANGE],
			max_range >= GameConfig.INDIRECT_MAX_RANGE - 1.0)


## 飞行时间 = D /(v0·cosθ)。300 m 在 v0 = 180 m/s 下是 1.68 s（105 m/s 时代是 3.13 s），
## 所以不用固定秒数窗口，改守：与水平速度定义一致 + 不超兜底上限 + 随射程递增。
func _test_flight_time() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var distance := 300.0
	var elevation := BallisticsSystem.solve_elevation(distance, v0)
	var flight := BallisticsSystem.solve_flight_time(distance, v0, elevation)
	var expected := distance / (v0 * cos(elevation))
	_check_true("飞行时间：%.2f s 与 D/(v0·cosθ) = %.2f s 一致（差 < 0.001 s）"
			% [flight, expected], absf(flight - expected) < 0.001)
	_check_true("飞行时间：落在 (0, INDIRECT_FLIGHT_MAX %.0f s] 内"
			% GameConfig.INDIRECT_FLIGHT_MAX,
			flight > 0.0 and flight <= GameConfig.INDIRECT_FLIGHT_MAX)
	var near_elevation := BallisticsSystem.solve_elevation(100.0, v0)
	var near_flight := BallisticsSystem.solve_flight_time(100.0, v0, near_elevation)
	_check_true("飞行时间：打得越远飞得越久（300 m %.2f s > 100 m %.2f s）"
			% [flight, near_flight], flight > near_flight)


func _test_blast_falloff() -> void:
	_check("爆炸：爆心伤害 = 90", IndirectFireScript.blast_damage_at(0.0),
			GameConfig.INDIRECT_BLAST_DAMAGE)
	_check_true("爆炸：半径处已衰减到最低伤害附近",
			IndirectFireScript.blast_damage_at(GameConfig.INDIRECT_BLAST_RADIUS)
			<= GameConfig.INDIRECT_BLAST_MIN_DAMAGE + 0.01)
	_check("爆炸：半径外 0 伤害",
			IndirectFireScript.blast_damage_at(GameConfig.INDIRECT_BLAST_RADIUS + 1.0), 0.0)
	_check_true("爆炸：伤害随距离单调下降",
			IndirectFireScript.blast_damage_at(2.0)
			> IndirectFireScript.blast_damage_at(8.0))


## 带阻力（7.4.2 定标）必须比无阻力近，且仍要覆盖间瞄射程上限
func _test_dragged_range_shorter() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var free_max := v0 * v0 / GameConfig.GRAVITY_EFFECTIVE
	var dragged_max := BallisticsSystem.trajectory_range(v0, deg_to_rad(45.0))
	_check_true("带阻力：45° 最大射程 %.0f m 明显小于无阻力 %.0f m" % [dragged_max, free_max],
			dragged_max < free_max)
	_check_true("带阻力：45° 最大射程 %.0f m 仍覆盖间瞄上限 %.0f m"
			% [dragged_max, GameConfig.INDIRECT_MAX_RANGE],
			dragged_max >= GameConfig.INDIRECT_MAX_RANGE)


## 反解仰角：解出的仰角回代积分器，落点误差要小（二分 12 次）
func _test_dragged_solve_accuracy() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	for distance in [100.0, 250.0, 350.0]:
		var elevation := BallisticsSystem.solve_elevation_dragged(distance, v0)
		_check_true("带阻力解算：%.0f m 能解出仰角" % distance, elevation > 0.0)
		var landed := BallisticsSystem.trajectory_range(v0, elevation)
		_check_true("带阻力解算：%.0f m 落点误差 < 1.5 m（实得 %.2f m）"
				% [distance, absf(landed - distance)], absf(landed - distance) < 1.5)
		_check_true("带阻力解算：低伸解不超过 45°", elevation <= deg_to_rad(45.0) + 0.001)


## 【2026-10-06 第七十九版】trajectory_range 改成"不建点数组"的实现后，必须与
## trajectory() 取最后一点**逐位相同**（同一段积分内核，但这条断言是防止哪天有人各改一边）。
func _test_range_matches_trajectory_exactly() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var cases := [
		[0.0, 100.0], [0.1, 250.0], [deg_to_rad(20.0), 300.0],
		[deg_to_rad(45.0), 600.0], [deg_to_rad(60.0), 400.0],
	]
	var mismatch := 0
	for c in cases:
		var elevation: float = c[0]
		var distance: float = c[1]
		var points := BallisticsSystem.trajectory(v0, elevation, distance)
		var last: Dictionary = points[points.size() - 1]
		var expect := float(last["x"])
		var actual := BallisticsSystem.trajectory_range(v0, elevation, distance)
		if actual != expect:
			mismatch += 1
	_check("落点快路径与 points 版逐位相同（%d 组，不一致 %d 组）" % [cases.size(), mismatch], mismatch, 0)
	_check("落点快路径：水平发射（0°）落点很短但仍 > 0",
			BallisticsSystem.trajectory_range(v0, 0.0, 600.0) > 0.0, true)


## 弹道形状：先升后降、终点回到地面。
## v0 = 180 m/s 时带阻力弹道顶点实测 300 m → 14.20 m、400 m → 30.97 m；
## 表现层已从简（不再画弧线/弹丸），所以不再要求「> 20 m 高抛可见」这种表现口径，
## 改守：明显离地 + 顶点不在两端（先升后降）+ 越远顶点越高（拖住初速/阻力被调平的回归）。
func _test_trajectory_shape() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var points := BallisticsSystem.trajectory(v0,
			BallisticsSystem.solve_elevation_dragged(300.0, v0))
	_check_true("弹道：采样点足够多（%d 点）" % points.size(), points.size() > 50)
	var peak := 0.0
	var peak_index := 0
	for i in points.size():
		if float(points[i]["height"]) > peak:
			peak = float(points[i]["height"])
			peak_index = i
	_check_true("弹道：最高点 %.2f m 明显离地（> 10 m）" % peak, peak > 10.0)
	_check_true("弹道：先升后降（最高点在第 %d / %d 个采样点，不在两端）"
			% [peak_index, points.size()],
			peak_index > 0 and peak_index < points.size() - 1)
	var last: Dictionary = points[points.size() - 1]
	_check_true("弹道：终点高度回到 0 附近（%.2f m）" % float(last["height"]),
			absf(float(last["height"])) < 2.0)
	var far_points := BallisticsSystem.trajectory(v0,
			BallisticsSystem.solve_elevation_dragged(400.0, v0))
	var far_peak := 0.0
	for point in far_points:
		far_peak = maxf(far_peak, float(point["height"]))
	_check_true("弹道：打得更远顶点更高（400 m %.2f m > 300 m %.2f m）" % [far_peak, peak],
			far_peak > peak)
