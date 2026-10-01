@tool
extends EditorScript

## 地图检测后端测试：可达性掩码（平地/陡坡）+ 通视探针（平地全通/山脊挡住）+ 单点信息
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_flat_is_all_passable()
	_test_steep_is_marked()
	_test_probe_clear_on_flat()
	_test_probe_blocked_by_ridge()
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


func _count_marked(image: Image) -> int:
	var marked := 0
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a > 0.01:
				marked += 1
	return marked


func _test_flat_is_all_passable() -> void:
	var grid := HeightGrid.new(16, 16)
	var image := MapInspector.build_passability_image(grid)
	_check("平地：可达性掩码无红域", _count_marked(image), 0)
	_check("平地：探针点可通行",
			MapInspector.sample_info(grid, Vector2(8.5, 8.5))["passable"], true)


## 东半边抬到 100 m：x=7 与 x=8 之间坡度约 89°，必须标成不可通行
func _test_steep_is_marked() -> void:
	var grid := HeightGrid.new(16, 16)
	for y in 16:
		for x in range(8, 16):
			grid.set_height_at_cell(x, y, 100.0)
	var image := MapInspector.build_passability_image(grid)
	_check_true("陡坡：可达性掩码出现红域", _count_marked(image) > 0)
	_check("陡坡：崖边点被标为不可通行",
			MapInspector.sample_info(grid, Vector2(7.5, 5.5))["passable"], false)


func _test_probe_clear_on_flat() -> void:
	var grid := HeightGrid.new(64, 64)
	var sight := SightSystem.new(grid)
	var rays := MapInspector.scan_visibility(grid, sight, Vector2(32.5, 32.5), 20.0, 10.0)
	var blocked_count := 0
	for ray in rays:
		if ray["blocked"]:
			blocked_count += 1
	_check_true("平地：射线数量正确（360/10 = 36）", rays.size() == 36)
	_check("平地：探针全部射线无阻挡", blocked_count, 0)


## 南北向山脊墙（x = 40，高 100 m）：朝东被挡、朝西畅通
func _test_probe_blocked_by_ridge() -> void:
	var grid := HeightGrid.new(64, 64)
	for y in 64:
		grid.set_height_at_cell(40, y, 100.0)
	var sight := SightSystem.new(grid)
	var rays := MapInspector.scan_visibility(grid, sight, Vector2(32.5, 32.5), 20.0, 10.0)
	var east_blocked := false
	var west_clear := false
	for ray in rays:
		var dir: Vector2 = ray["dir"]
		if dir.x > 0.98 and ray["blocked"]:
			east_blocked = true
		if dir.x < -0.98 and not ray["blocked"]:
			west_clear = true
	_check_true("山脊：朝东射线被地形挡住", east_blocked)
	_check_true("山脊：朝西射线畅通", west_clear)
