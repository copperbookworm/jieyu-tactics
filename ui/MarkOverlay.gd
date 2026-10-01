class_name MarkOverlay
extends Node2D

## 主视图上的报点标记（世界坐标）：类型色圆点 + 时效渐隐
## docx 4.11.2：标记是「最后目击位置」，固定不动，30 s 后淡出

var _marks: MarkSystem = null


func setup(marks: MarkSystem) -> void:
	_marks = marks


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
		draw_circle(mark_position, GameConfig.MARK_ICON_RADIUS, color)
		draw_arc(mark_position, GameConfig.MARK_ICON_RADIUS * 1.8, 0.0, TAU, 24,
				Color(color.r, color.g, color.b, color.a * 0.7), 1.5)
