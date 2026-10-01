extends RefCounted

## HUD 程序生成贴图工厂（从 Main.gd 拆出，解决其超出 1000 行上限）
## 只做两件事：准心箭头贴图、聚焦暗角贴图——纯函数、不依赖场景与节点状态。
## 刻意不写 class_name：引用方用 preload（与 VehicleTable / Cover / WeaponTable 同一惯例，
## 免去「新 class_name 要等 Godot 重新扫描才可用」那类问题）

## 等腰三角箭头准心贴图。
## 尖端＝纹理中心＝屏心，所以旋转轴正好落在尖端；
## 箭身向 -x 延伸 ⇒ 箭头指向 +x，rotation 0 时 +x 即射击方向
## （箭身若画在 +x 侧，箭头就朝 -x，真机上正好反 —— 2026-09-28 踩过这个坑）
static func crosshair_arrow() -> ImageTexture:
	var size := GameConfig.CROSSHAIR_ARROW_SIZE
	var center := size / 2
	var length := GameConfig.CROSSHAIR_ARROW_LENGTH
	var half_height := GameConfig.CROSSHAIR_ARROW_HALF_HEIGHT
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var color := Color("7bd88f")
	for step in range(length + 1):
		var x := center - step
		# step = 0 是尖端、step = length 是底边
		var half := int(round(float(half_height) * float(step) / float(length)))
		for y in range(center - half, center + half + 1):
			image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(image)


## 程序生成的边缘暗角贴图（聚焦时全屏拉伸）：中心透明、边缘渐黑
static func vignette() -> ImageTexture:
	var texture_size := 64
	var image := Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var center := Vector2(texture_size, texture_size) * 0.5
	var max_distance := center.length()
	for y in texture_size:
		for x in texture_size:
			var t := Vector2(x + 0.5, y + 0.5).distance_to(center) / max_distance
			t = clampf((t - 0.45) / 0.55, 0.0, 1.0)
			image.set_pixel(x, y, Color(0.0, 0.0, 0.0, t * t * GameConfig.FOCUS_VIGNETTE_ALPHA))
	return ImageTexture.create_from_image(image)
