class_name FireButton
extends Control

## 触屏开火按钮（屏幕右下角），点按一次发射一发
## 手机横屏：右手拇指点按开火，左手摇杆移动，其余区域拖准心

signal fired

@export var button_radius := 60.0  # px

var _center := Vector2.ZERO


func _ready() -> void:
	size = Vector2(160.0, 160.0)
	position = Vector2(GameConfig.VIEWPORT_WIDTH - size.x, GameConfig.VIEWPORT_HEIGHT - size.y)
	_center = size * 0.5
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE  # 触屏走 _input


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _is_inside(touch.position):
			fired.emit()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and _is_inside(mouse.position):
			fired.emit()
			get_viewport().set_input_as_handled()


func _is_inside(point: Vector2) -> bool:
	return _center.distance_to(point - global_position) <= button_radius


func _draw() -> void:
	draw_circle(_center, button_radius, Color(0.9, 0.3, 0.3, 0.22))
	draw_arc(_center, button_radius, 0.0, TAU, 48, Color(0.9, 0.3, 0.3, 0.7), 3.0)
