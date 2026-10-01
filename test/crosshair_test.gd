@tool
extends EditorScript

## 准心箭头方向测试（回归用）：尖端必须在纹理中心、箭身在中心左侧。
## 背景：2026-09-28 曾把箭身画在 +x 侧，箭头实际朝 -x，真机上指向正好相反。
## 运行：脚本编辑器打开本文件 → 文件 → 运行

## HUD 程序生成贴图的来源（准心箭头 / 聚焦暗角）：2026-09-29 从 Main.gd 拆出，Main 因此回到 1000 行以内
const FACTORY_SCRIPT := "res://ui/HudTextureFactory.gd"

var _passed := 0
var _failed := 0


func _run() -> void:
	var script: GDScript = load(FACTORY_SCRIPT)
	if script == null:
		print("！！ 加载不到 %s" % FACTORY_SCRIPT)
		return
	var texture: ImageTexture = script.crosshair_arrow()
	if texture == null:
		print("！！ 箭头纹理生成失败")
		return
	var image := texture.get_image()
	var center := GameConfig.CROSSHAIR_ARROW_SIZE / 2
	var tail_x := center - GameConfig.CROSSHAIR_ARROW_LENGTH
	_check_true("尖端在纹理中心（该列很窄，≤ 3 px）", _column_width(image, center) <= 3)
	_check_true("底边在中心左侧且最宽（≥ 2 × 半高 - 1）",
			_column_width(image, tail_x) >= GameConfig.CROSSHAIR_ARROW_HALF_HEIGHT * 2 - 1)
	_check("中心右侧无像素（箭头不朝 -x）", _column_width(image, center + 2), 0)
	_check_true("箭身越靠近底边越宽",
			_column_width(image, tail_x) > _column_width(image, center - 2))
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


## 该列非透明像素数
func _column_width(image: Image, x: int) -> int:
	if x < 0 or x >= image.get_width():
		return 0
	var count := 0
	for y in image.get_height():
		if image.get_pixel(x, y).a > 0.01:
			count += 1
	return count
