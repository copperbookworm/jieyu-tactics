@tool
extends EditorScript

## 离线弹道表测试（Q2 · 2026-10-06 第七十九版·三 · 使用者拍板"生成器 + 直接接入查表"）
##
## 钉三件事：
##   ① 表真的在（资产入库、初速/量程对得上、生成时记录的误差 ≤ 1.6 m）；
##   ② **表这条路打得更准**（落点误差不超过现算二分基线），且随距离单调；
##   ③ 表未命中时**逐位退回二分**（其他初速 / 超出量程）—— 老调用方与单测因此不受影响。
##
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 tools/run_tests_headless.gd 跑批

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table_loaded()
	_test_table_accuracy_and_monotonic()
	_test_fallback_is_bitwise_bisection()
	_test_speed_report()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻 [FAIL] 行看期望值与实际值" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


# ────────────── ① 表在不在 ──────────────

func _test_table_loaded() -> void:
	var info := BallisticsSystem.table_info()
	_check_true("离线弹道表已装载（rows=%d）" % int(info["rows"]), bool(info["loaded"]))
	_check("表初速 == INDIRECT_MUZZLE_VELOCITY（%.1f）" % GameConfig.INDIRECT_MUZZLE_VELOCITY,
			float(info["v0"]), GameConfig.INDIRECT_MUZZLE_VELOCITY)
	_check_true("表步长 > 0（%.1f m）" % float(info["step_m"]), float(info["step_m"]) > 0.0)
	_check_true("表量程 ≥ INDIRECT_MAX_RANGE（%.0f ≥ %.0f）" % [
			float(info["max_m"]), GameConfig.INDIRECT_MAX_RANGE],
			float(info["max_m"]) >= GameConfig.INDIRECT_MAX_RANGE)
	_check_true("生成时记录的最大落点误差 ≤ 1.6 m（实得 %.4f）" % float(info["measured_max_error_m"]),
			float(info["measured_max_error_m"]) <= 1.6)
	_check_true("表资产在工程里（%s）" % BallisticsSystem.TABLE_PATH,
			FileAccess.file_exists(BallisticsSystem.TABLE_PATH))


# ────────────── ② 精度与单调 ──────────────

func _test_table_accuracy_and_monotonic() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var previous := -1.0
	var worst := 0.0
	var monotone := true
	for d in [50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0]:
		var elevation := BallisticsSystem.solve_elevation_dragged(d, v0)
		if elevation <= 0.0 or elevation > deg_to_rad(45.0) + 0.001:
			_check_true("%.0f m 解出合法仰角（实得 %.4f rad）" % [d, elevation], false)
			continue
		var landed := BallisticsSystem.trajectory_range(v0, elevation)
		worst = maxf(worst, absf(landed - d))
		if previous >= 0.0 and elevation < previous - 0.000001:
			monotone = false
		previous = elevation
	_check_true("表路径落点误差 ≤ 1.6 m（8 个距离实测最大 %.4f m）" % worst, worst <= 1.6)
	_check_true("仰角随距离单调不减", monotone)
	# 与"现算基线"对比：表的误差不许比二分更差
	var baseline := 0.0
	for d in [50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0]:
		var elev := BallisticsSystem.solve_elevation_bisection(d, v0)
		if elev > 0.0:
			baseline = maxf(baseline, absf(BallisticsSystem.trajectory_range(v0, elev) - d))
	print("[弹道表] 表路径最大落点误差 %.4f m ｜ 现算二分基线 %.4f m｜表步长 %.1f m / %d 格" % [
			worst, baseline, float(BallisticsSystem.table_info()["step_m"]),
			int(BallisticsSystem.table_info()["rows"])])
	_check_true("表不比现算更差（%.4f ≤ %.4f + 0.05）" % [worst, baseline], worst <= baseline + 0.05)


# ────────────── ③ 未命中必须逐位退回二分 ──────────────

func _test_fallback_is_bitwise_bisection() -> void:
	# ① 别的初速（表里没有）⇒ 与二分逐位相同
	for v0 in [123.0, 200.0, 90.0]:
		var same := true
		for d in [80.0, 250.0, 380.0]:
			if BallisticsSystem.solve_elevation_dragged(d, v0) \
					!= BallisticsSystem.solve_elevation_bisection(d, v0):
				same = false
		_check_true("初速 %.0f（表里没有）⇒ 逐位退回二分" % v0, same)
	# ② 超出表量程 ⇒ 逐位退回二分
	var info := BallisticsSystem.table_info()
	var beyond := float(info["max_m"]) + 20.0
	var v0_main := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var reachable := BallisticsSystem.solve_elevation_bisection(beyond, v0_main)
	_check("超出量程 %.0f m：逐位退回二分（%.6f）" % [beyond, reachable],
			BallisticsSystem.solve_elevation_dragged(beyond, v0_main), reachable)
	# ③ 非法输入
	_check("距离 0：返回 -1", BallisticsSystem.solve_elevation_dragged(0.0, v0_main), -1.0)
	_check("初速 0：返回 -1", BallisticsSystem.solve_elevation_dragged(200.0, 0.0), -1.0)
	# ④ 同一输入两次相同（表是只读的）
	var a := BallisticsSystem.solve_elevation_dragged(275.0, v0_main)
	var b := BallisticsSystem.solve_elevation_dragged(275.0, v0_main)
	_check("同一输入两次结果相同", a, b)


# ────────────── ④ 速度（只报告 + 一个宽松下限）──────────────

func _test_speed_report() -> void:
	var v0 := GameConfig.INDIRECT_MUZZLE_VELOCITY
	var rounds := 400
	var t := Time.get_ticks_usec()
	for i in rounds:
		BallisticsSystem.solve_elevation_dragged(60.0 + float(i % 300), v0)
	var table_ms := float(Time.get_ticks_usec() - t) / 1000.0
	t = Time.get_ticks_usec()
	for i in rounds:
		BallisticsSystem.solve_elevation_bisection(60.0 + float(i % 300), v0)
	var bisect_ms := float(Time.get_ticks_usec() - t) / 1000.0
	print("[弹道表] %d 次反解：查表 %.1f ms（%.3f ms/次）| 现算二分 %.1f ms（%.3f ms/次）| 提速 %.1f×" % [
			rounds, table_ms, table_ms / rounds, bisect_ms, bisect_ms / rounds,
			bisect_ms / maxf(table_ms, 0.001)])
	_check_true("查表至少快 5×（实测 %.1f×）" % (bisect_ms / maxf(table_ms, 0.001)),
			bisect_ms / maxf(table_ms, 0.001) >= 5.0)
