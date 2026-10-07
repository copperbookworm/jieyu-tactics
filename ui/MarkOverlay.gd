class_name MarkOverlay
extends Node2D

## 主视图上的报点标记（世界坐标）：类型色圆点 + 时效渐隐
## docx 4.11.2：标记是「最后目击位置」，固定不动，30 s 后淡出

var _marks: MarkSystem = null


func setup(marks: MarkSystem) -> void:
	_marks = marks


const ArtAssetsScript := preload("res://systems/art/ArtAssets.gd")

## 标记类型 → 美术 id。**顺序必须与 MarkSystem.MarkType 一致**（ENEMY/VEHICLE/POSITION/SUPPLY/SMOKE/RALLY）。
const MARK_ICON_IDS := ["ui_mark_enemy", "ui_mark_vehicle", "ui_mark_position",
		"ui_mark_supply", "ui_mark_smoke", "ui_mark_rally"]


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if _marks == null:
		return
	for mark in _marks.marks:
		var mark_position: Vector2 = mark["position"]
		var color := MarkSystem.type_color(int(mark["type"]))
		# 时效尾巴：剩得越少越淡
		var total := maxf(float(mark["duration"]), 0.001)
		var life := clampf(float(mark["time_left"]) / total, 0.0, 1.0)
		color.a = 0.35 + 0.6 * life
		# 美术优先（2026-10-07 第九十四版）：六个标记类型各有一张 32×32 图标，
		# 尺寸与程序绘制的圆点**逐字一致**（半径 MARK_ICON_RADIUS），所以只是形状变了、位置与大小不变。
		# 文件不在就退回「圆点 + 时效圈」的程序绘制。
		var icon: Texture2D = null
		var type_index := int(mark["type"])
		if type_index >= 0 and type_index < MARK_ICON_IDS.size():
			icon = ArtAssetsScript.texture(MARK_ICON_IDS[type_index])
		if icon != null:
			var half := GameConfig.MARK_ICON_RADIUS
			draw_texture_rect(icon,
					Rect2(mark_position - Vector2(half, half), Vector2(half, half) * 2.0),
					false, Color(1.0, 1.0, 1.0, color.a))
			continue
		draw_circle(mark_position, GameConfig.MARK_ICON_RADIUS, color)
		draw_arc(mark_position, GameConfig.MARK_ICON_RADIUS * 1.8, 0.0, TAU, 24,
				Color(color.r, color.g, color.b, color.a * 0.7), 1.5)
