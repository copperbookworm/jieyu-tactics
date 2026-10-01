@tool
extends EditorScript

## 高度图导入测试（工具链 A）：黑=0、白=满高、中灰=半高、渐变线性、尺寸不符拒绝
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_all_black_is_zero()
	_test_all_white_is_max()
	_test_gradient_linear()
	_test_mid_gray()
	_test_size_mismatch_rejected()
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


func _make_gray_image(size: int, gray: float) -> Image:
	var image := Image.create(size, size, false, Image.FORMAT_L8)
	for y in size:
		for x in size:
			image.set_pixel(x, y, Color(gray, gray, gray))
	return image


func _test_all_black_is_zero() -> void:
	var grid := HeightGrid.new(8, 8)
	var ok := grid.fill_from_image(_make_gray_image(8, 0.0))
	_check_true("全黑图导入成功", ok)
	_check("全黑 → 0 m 平地", grid.height_at_cell(4, 4), 0.0)


func _test_all_white_is_max() -> void:
	var grid := HeightGrid.new(8, 8)
	grid.fill_from_image(_make_gray_image(8, 1.0))
	_check("全白 → MAX_ELEVATION", grid.height_at_cell(4, 4), GameConfig.MAX_ELEVATION)


## 中灰 = 半高，但 8bit 灰度本身是量化过的（150 m ÷ 255 级 ≈ 0.59 m/级，见进度文件「16bit 精度」待办），
## Color(0.5) 落到 127 级 ⇒ 实得 74.71 m，不可能精确等于 75.0。
## 所以这里按「一级以内」判等；要求精确相等等于否定了 8bit 管线本身（2026-09-30 修）。
func _test_mid_gray() -> void:
	var grid := HeightGrid.new(4, 4)
	grid.fill_from_image(_make_gray_image(4, 0.5))
	var half := GameConfig.MAX_ELEVATION * 0.5
	var one_level := GameConfig.MAX_ELEVATION / 255.0
	var actual := grid.height_at_cell(1, 1)
	_check_true("中灰 → 半高（实得 %.2f m，一级量化容差 ±%.2f m）" % [actual, one_level],
			absf(actual - half) <= one_level)


## 左右两列 0 / 1.0：应严格映射成 0 m 与满高（不做任何缩放或插值）
func _test_gradient_linear() -> void:
	var image := Image.create(2, 2, false, Image.FORMAT_L8)
	for y in 2:
		image.set_pixel(0, y, Color(0.0, 0.0, 0.0))
		image.set_pixel(1, y, Color(1.0, 1.0, 1.0))
	var grid := HeightGrid.new(2, 2)
	grid.fill_from_image(image)
	_check("渐变：左列 0 m", grid.height_at_cell(0, 0), 0.0)
	_check("渐变：右列满高", grid.height_at_cell(1, 0), GameConfig.MAX_ELEVATION)


## 尺寸不符：拒绝导入，且原有地形一个格都不许被改写
func _test_size_mismatch_rejected() -> void:
	var grid := HeightGrid.new(8, 8)
	grid.set_height_at_cell(3, 3, 42.0)
	var ok := grid.fill_from_image(_make_gray_image(7, 1.0))
	_check("尺寸不符：拒绝导入（返回 false）", ok, false)
	_check("尺寸不符：原有地形保持不变", grid.height_at_cell(3, 3), 42.0)
