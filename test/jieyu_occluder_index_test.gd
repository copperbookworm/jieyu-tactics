@tool
extends EditorScript

## 掩体空间网格索引的等价性测试（2026-10-06 第七十九版·三 · 使用者拍板 Q3）
##
## 钉住的唯一一件事：**索引版与全表版逐位相同**（不是"差不多"）。
## 为什么必须这么钉：第十六节那次掩体索引就是"候选压缩 124×、逐次判定 0 不一致"却仍然
## 让集成冒烟红两条、最后整条回滚 —— 教训是"只比最终布尔值不够"，这次比的是**距离的原始返回值**
## （最细的可比量），并把同一批点喂给两种实现逐点对拍。
##
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 tools/run_tests_headless.gd 跑批

const OccluderIndexScript := preload("res://addons/jieyu_map/core/JieyuOccluderIndex.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_empty_and_degenerate()
	_test_real_map_exact_equivalence()
	_test_cell_size_does_not_change_result()
	_test_outside_and_inside_points()
	_test_perf_report()
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


# ────────────── 夹具 ──────────────

## 顶点均值（JieyuMapChecks 里有同名私有实现，这里自己算一份，免得跨类调私有）
func _centroid(polygon: Array) -> Vector2:
	if polygon.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for point_v in polygon:
		var p: Vector2 = point_v if point_v is Vector2 else Vector2(float(point_v[0]), float(point_v[1]))
		sum += p
	return sum / float(polygon.size())


func _real_occluders() -> Array:
	var doc := JieyuMapDoc.load_from_dir("qingling_corridor")
	if doc == null:
		return []
	return doc.occluders


func _rng_points(count: int, seed_value: int, spread: float) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var out: Array = []
	for i in count:
		out.append(Vector2(rng.randf_range(-spread, 1000.0 + spread),
				rng.randf_range(-spread, 1000.0 + spread)))
	return out


# ────────────── ① 空 / 退化 ──────────────

func _test_empty_and_degenerate() -> void:
	var idx = OccluderIndexScript.new()
	idx.build([])
	_check("空表：索引为空", idx.is_empty(), true)
	_check("空表：距离 = INF", idx.nearest_distance(Vector2(10.0, 10.0)), INF)

	var bad: Array = [
		{"polygon": [[0.0, 0.0], [1.0, 0.0]]},                                  # 顶点 < 3：不入索引
		{"polygon": [[5.0, 5.0], [5.0, 5.0], [5.0, 5.0]]},                      # 退化：三点重合
		{"polygon": [[20.0, 20.0], [30.0, 20.0], [30.0, 30.0], [20.0, 30.0]]},  # 正常方块
	]
	idx.build(bad)
	_check("顶点 < 3 被丢掉（只剩 2 块）", idx.count(), 2)
	_check("退化多边形：点它自己上 = 0", idx.nearest_distance(Vector2(5.0, 5.0)), 0.0)
	# 全表版对同一批输入
	_check("退化多边形：与全表版一致",
			idx.nearest_distance(Vector2(5.0, 5.0)),
			JieyuMapGen.nearest_occluder_distance(bad, Vector2(5.0, 5.0)))
	_check("方块内部 = 0（与全表版一致）",
			idx.nearest_distance(Vector2(25.0, 25.0)),
			JieyuMapGen.nearest_occluder_distance(bad, Vector2(25.0, 25.0)))
	_check("方块外一点（与全表版一致）",
			idx.nearest_distance(Vector2(40.0, 25.0)),
			JieyuMapGen.nearest_occluder_distance(bad, Vector2(40.0, 25.0)))


# ────────────── ② 真图逐点对拍（本轮的主证据）──────────────

func _test_real_map_exact_equivalence() -> void:
	var occluders := _real_occluders()
	_check_true("读得到真图掩体（%d 块）" % occluders.size(), occluders.size() > 100)
	if occluders.size() == 0:
		return
	var idx = OccluderIndexScript.new()
	idx.build(occluders, 25.0)
	var points := _rng_points(600, 20261006, 60.0)
	var mismatch := 0
	var first_bad := -1
	var worst_diff := 0.0
	for i in points.size():
		var p: Vector2 = points[i]
		var indexed: float = idx.nearest_distance(p)
		var brute: float = JieyuMapGen.nearest_occluder_distance(occluders, p)
		if indexed != brute:
			mismatch += 1
			if first_bad < 0:
				first_bad = i
			worst_diff = maxf(worst_diff, absf(indexed - brute))
	_check("真图 600 个随机点：索引版 == 全表版（逐位；不一致 %d 个，首个 #%d，最大差 %.6f）"
			% [mismatch, first_bad, worst_diff], mismatch, 0)


# ────────────── ③ 格边长不许改变结果 ──────────────

func _test_cell_size_does_not_change_result() -> void:
	var occluders := _real_occluders()
	if occluders.is_empty():
		return
	var points := _rng_points(120, 7, 40.0)
	var mismatch := 0
	for cell in [1.0, 5.0, 25.0, 50.0, 120.0, 400.0]:
		var idx = OccluderIndexScript.new()
		idx.build(occluders, cell)
		for p_v in points:
			var p: Vector2 = p_v
			if idx.nearest_distance(p) != JieyuMapGen.nearest_occluder_distance(occluders, p):
				mismatch += 1
	_check("格边长 1/5/25/50/120/400 m 都不改变结果（%d 次对拍，不一致 %d）"
			% [points.size() * 6, mismatch], mismatch, 0)


# ────────────── ④ 点在掩体内 / 远在地图外 ──────────────

func _test_outside_and_inside_points() -> void:
	var occluders := _real_occluders()
	if occluders.is_empty():
		return
	var idx = OccluderIndexScript.new()
	idx.build(occluders, 25.0)
	var inside_checked := 0
	var mismatch := 0
	for item_v in occluders:
		var polygon: Array = (item_v as Dictionary).get("polygon", [])
		if polygon.size() < 3:
			continue
		var center := _centroid(polygon)
		if idx.nearest_distance(center) != JieyuMapGen.nearest_occluder_distance(occluders, center):
			mismatch += 1
		inside_checked += 1
	_check("每块掩体的形心：索引版 == 全表版（%d 块，不一致 %d）" % [inside_checked, mismatch], mismatch, 0)
	_check("掩体形心距离恒为 0（全表版口径）",
			JieyuMapGen.nearest_occluder_distance(occluders,
					_centroid((occluders[0] as Dictionary)["polygon"])), 0.0)
	# 远在地图外四个角（含负坐标）
	for p in [Vector2(-500.0, -500.0), Vector2(2000.0, 2000.0), Vector2(-10.0, 900.0)]:
		_check("地图外 %s：索引版 == 全表版" % str(p),
				idx.nearest_distance(p), JieyuMapGen.nearest_occluder_distance(occluders, p))


# ────────────── ⑤ 性能（只报告，不当断言 —— 机器不同数字会漂）──────────────

func _test_perf_report() -> void:
	var occluders := _real_occluders()
	if occluders.is_empty():
		return
	var points := _rng_points(2000, 99, 40.0)
	var idx = OccluderIndexScript.new()
	idx.build(occluders, 25.0)
	var t := Time.get_ticks_usec()
	for p_v in points:
		idx.nearest_distance(p_v)
	var indexed_ms := float(Time.get_ticks_usec() - t) / 1000.0
	t = Time.get_ticks_usec()
	for p_v in points:
		JieyuMapGen.nearest_occluder_distance(occluders, p_v)
	var brute_ms := float(Time.get_ticks_usec() - t) / 1000.0
	print("[索引] %d 块掩体 / %d 次查询：索引版 %.1f ms（%.2f µs/次）| 全表版 %.1f ms（%.2f µs/次）| 提速 %.1f×" % [
			occluders.size(), points.size(), indexed_ms, indexed_ms * 1000.0 / float(points.size()),
			brute_ms, brute_ms * 1000.0 / float(points.size()), brute_ms / maxf(indexed_ms, 0.001)])
	_check_true("索引版至少快 3×（实测 %.1f×）" % (brute_ms / maxf(indexed_ms, 0.001)),
			brute_ms / maxf(indexed_ms, 0.001) >= 3.0)
