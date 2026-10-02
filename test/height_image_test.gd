@tool
extends EditorScript

## 高度图导入测试（工具链 A）：黑=0、白=满高、中灰=半高、渐变线性、尺寸不符拒绝
## 运行：脚本编辑器打开本文件 → 文件 → 运行

## WorldSetup 刻意无 class_name（引用方 preload，见其文件头），所以这里也 preload
const WorldSetupScript := preload("res://scenes/gameplay/WorldSetup.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_all_black_is_zero()
	_test_all_white_is_max()
	_test_gradient_linear()
	_test_mid_gray()
	_test_size_mismatch_rejected()
	_test_loader_prefers_imported_texture()
	_test_loader_missing_file()
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


## 【候选 T ① · 2026-10-01】高度图读取优先走「导入后的资源」。
## 导出后 PNG 会被打成 .ctex 封进包，Image.load_from_file("res://…png") 读不到原图
## （Godot 会 WARNING「this will not work on export」）。这里钉住两件事：
##   ① 项目里那张图确实已被导入（ResourceLoader 认得，走的才是导出也成立的那条路）
##   ② 读出来的像素尺寸正确、且能直接填进网格
func _test_loader_prefers_imported_texture() -> void:
	var path: String = GameConfig.MAP_HEIGHT_IMAGE
	_check_true("候选 T ①：高度图已在导入管线里（ResourceLoader.exists 为真）",
			ResourceLoader.exists(path, "Texture2D"))
	var image: Image = WorldSetupScript._load_height_image(path)
	_check_true("候选 T ①：读得出像素（不再依赖直接读 res:// 原图）", image != null)
	if image == null:
		return
	_check("候选 T ①：宽 = 网格宽", image.get_width(), GameConfig.GRID_WIDTH)
	_check("候选 T ①：高 = 网格高", image.get_height(), GameConfig.GRID_HEIGHT)
	var grid := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
	_check_true("候选 T ①：读出的图能直接填进网格", grid.fill_from_image(image))


## 兜底路径：不存在的文件返回 null（不抛异常）。下一行 [地形] 报错是本用例故意触发的。
func _test_loader_missing_file() -> void:
	_check("候选 T ①：不存在的路径返回 null（下面那行 [地形] 报错是预期的）",
			WorldSetupScript._load_height_image("res://assets/maps/no_such_height_map.png"),
			null)
