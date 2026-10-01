class_name FocusButton
extends Control

## 触屏聚焦键（屏幕右下、开火键左侧）：按住进入聚焦模式，松开退出。
## 依据「取消开镜 → 聚焦模式」确认稿：俯视不举枪放大，改为收窄准心 + 降散布 + 边缘暗角。

signal focus_changed(on: bool)

@export var button_radius := 48.0  # px

var _center := Vector2.ZERO
var _active_touch := -1


func _ready() -> void:
	size = Vector2(120.0, 120.0)
	position = Vector2(GameConfig.VIEWPORT_WIDTH - 160.0 - size.x,
			GameConfig.VIEWPORT_HEIGHT - size.y)
	_center = size * 0.5
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE  # 触屏走 _input


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _is_inside(touch.position):
			_active_touch = touch.index
			focus_changed.emit(true)
			get_viewport().set_input_as_handled()
		elif not touch.pressed and touch.index == _active_touch:
			_active_touch = -1
			focus_changed.emit(false)
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and _is_inside(mouse.position):
			focus_changed.emit(mouse.pressed)


func _is_inside(point: Vector2) -> bool:
	return _center.distance_to(point - global_position) <= button_radius


func _draw() -> void:
	draw_circle(_center, button_radius, Color(0.3, 0.7, 0.9, 0.20))
	draw_arc(_center, button_radius, 0.0, TAU, 48, Color(0.3, 0.7, 0.9, 0.7), 3.0)
