@tool
extends EditorScript

## 出生点挑选（systems/terrain/SpawnPicker.gd）自测：
##   坡度双尺度过滤 · 离掩体 ≥5 m · 离占领点逐级放宽 100/60/30/0 · 并列时先平后远离掩体
##   · 多边形内外与边界距离 · 微调 nudge 的兜底语义 · 确定性
## 全部用合成 HeightGrid（不依赖任何地图文件）

const PickerScript := preload("res://systems/terrain/SpawnPicker.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_polygon_math()
	_test_flat_beats_cliff()
	_test_node_distance_tiers()
	_test_cover_avoidance()
	_test_pick_within()
	_test_determinism()
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


func _check_near(title: String, actual: float, expected: float, tolerance: float) -> void:
	if absf(actual - expected) <= tolerance:
		_passed += 1
		print("[OK]   %s (%.2f ≈ %.2f)" % [title, actual, expected])
	else:
		_failed += 1
		print("[FAIL] %s  期望=%.2f±%.2f 实际=%.2f" % [title, expected, tolerance, actual])


## 合成地形：默认全平（0 m），可指定若干「陡坡圆盘」
func _grid(size: int = 200) -> HeightGrid:
	var grid := HeightGrid.new(size, size)
	for y in size:
		for x in size:
			grid.set_height_at_cell(x, y, 0.0)
	return grid


## 在 (cx,cy) 周围造一块**站不住的地形**：半径 r 内沿对角线做陡台阶，每格 15 m 高差。
## 两个坑都踩过：① 抬成平顶台地 → 内部坡度 0，挑选器选它对（第一版测试写错）；
## ② 用 2 格周期的棋盘格 → 而坡度采样步长是 4 m / 8 m（偶数格），相位不变照样是平的。
## 台阶保证任何 4 m / 8 m 步都跨过大高差 ⇒ 双尺度坡度必然超 30°。
func _make_rough(grid: HeightGrid, center: Vector2, radius: float, step_height: float = 15.0) -> void:
	var cell := grid.world_to_cell(center)
	var r := int(radius)
	for dy in range(-r, r + 1):
		for dx in range(-r, r + 1):
			if Vector2(dx, dy).length() <= radius:
				grid.set_height_at_cell(cell.x + dx, cell.y + dy, float(dx + dy) * step_height)


func _test_polygon_math() -> void:
	var square := [[0, 0], [100, 0], [100, 100], [0, 100]]
	_check_true("多边形：内部点判在内", PickerScript.point_in_polygon(square, Vector2(50, 50)))
	_check_true("多边形：外部点判在外", not PickerScript.point_in_polygon(square, Vector2(150, 50)))
	_check_near("多边形：内部点到边界距离", PickerScript.edge_distance(square, Vector2(50, 50)), 50.0, 0.01)
	_check_near("多边形：外部点到边界距离", PickerScript.polygon_distance(square, Vector2(130, 50)), 30.0, 0.01)
	_check("多边形：内部点的关系距离 = 0", PickerScript.polygon_distance(square, Vector2(50, 50)), 0.0)
	_check("坐标两种写法都收", PickerScript.to_vec2([3, 4]), Vector2(3, 4))
	_check("坐标 Vector2 原样返回", PickerScript.to_vec2(Vector2(1, 2)), Vector2(1, 2))


func _test_flat_beats_cliff() -> void:
	var grid := _grid()
	# 左半边是破碎地形，右半边平
	_make_rough(grid, Vector2(30, 50), 25.0)
	var polygon := [[0, 0], [100, 0], [100, 100], [0, 100]]
	var picked := PickerScript.pick(grid, polygon, [], [])
	_check_true("挑得出点", picked != Vector2.INF)
	# 并列时取「离出生区边界更远」⇒ 落点会被推到破碎区之外（破碎区在 (30,50) r=25）
	_check_true("挑出的点避开了破碎地形（离其圆心 %.1f m > 25）" % picked.distance_to(Vector2(30, 50)),
			picked.distance_to(Vector2(30, 50)) > 25.0)
	_check_true("挑出的点双尺度坡度都合格", PickerScript.slope_ok(grid, picked))


func _test_node_distance_tiers() -> void:
	var grid := _grid()
	var polygon := [[0, 0], [200, 0], [200, 200], [0, 200]]
	var node := Vector2(100, 100)
	# 100 m 这一档：整块地都是平的，绕着节点一圈都合格 ⇒ 必须挑出 ≥100 m 的点
	var picked := PickerScript.pick(grid, polygon, [node], [])
	_check_true("能挑出点", picked != Vector2.INF)
	_check_true("离节点 ≥ 100 m（实测 %.1f m）" % picked.distance_to(node),
			picked.distance_to(node) >= 100.0 - 4.3)   # 采样步长 3 m + 边界余量，允许一个采样的误差
	# 把多边形缩到节点附近（最大可离 40 m）⇒ 100 档挑不出，逐级放宽后必须仍挑得出来
	var small := [[60, 60], [140, 60], [140, 140], [60, 140]]
	var near := PickerScript.pick(grid, small, [node], [])
	_check_true("被节点围住时逐级放宽而非返回空", near != Vector2.INF)
	_check_true("放宽后离节点仍尽量远（≥ 30 m，实测 %.1f m）" % near.distance_to(node),
			near.distance_to(node) >= 30.0)


func _test_cover_avoidance() -> void:
	var grid := _grid()
	var polygon := [[0, 0], [100, 0], [100, 100], [0, 100]]
	var occluders := [{"polygon": [[40, 40], [60, 40], [60, 60], [40, 60]]}]
	var picked := PickerScript.pick(grid, polygon, [], occluders)
	_check_true("挑得出点", picked != Vector2.INF)
	var cover := PickerScript.cover_distance(occluders, picked)
	_check_true("离掩体 ≥ 5 m（实测 %.1f m）" % cover, cover >= PickerScript.MIN_COVER_DIST)
	# 整块地都被一栋大楼压住 ⇒ 返回 INF（让调用方退回兜底点）
	var big := [{"polygon": [[-10, -10], [110, -10], [110, 110], [-10, 110]]}]
	_check("全区被掩体压住 → 返回 INF", PickerScript.pick(grid, polygon, [], big), Vector2.INF)


func _test_pick_within() -> void:
	var grid := _grid()
	# 破碎区半径 8 m 要**小于**微调半径 15 m，否则「原地 15 m 内全是烂地」——那时按约定就该原样返回 ideal
	_make_rough(grid, Vector2(50, 50), 8.0)
	var ideal := Vector2(50, 50)
	var nudged := PickerScript.nudge(grid, ideal, 15.0, [])
	_check_true("微调后不再是原点", nudged != ideal)
	_check_true("微调后的点在半径内（实测 %.1f m）" % nudged.distance_to(ideal),
			nudged.distance_to(ideal) <= 15.0 + 0.01)
	_check_true("微调后的点坡度合格", PickerScript.slope_ok(grid, nudged))
	# 半径内没有合格点 ⇒ 原样返回 ideal（调用方要的是「尽量」而不是「必须」）
	var blocked := [{"polygon": [[0, 0], [100, 0], [100, 100], [0, 100]]}]
	_check("半径内全被压住 → 原样返回 ideal", PickerScript.nudge(grid, ideal, 10.0, blocked), ideal)


func _test_determinism() -> void:
	var grid := _grid()
	_make_rough(grid, Vector2(80, 80), 30.0)
	var polygon := [[0, 0], [200, 0], [200, 200], [0, 200]]
	var first := PickerScript.pick(grid, polygon, [Vector2(30, 30)], [])
	var second := PickerScript.pick(grid, polygon, [Vector2(30, 30)], [])
	_check("同输入两次挑选结果一致（确定性）", first, second)
