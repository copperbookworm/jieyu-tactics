class_name TouchJoystick
extends Control

## 触屏虚拟摇杆（屏幕左下角固定），输出归一化方向（-1..1）
## 手机横屏：左手拇指推摇杆移动，右手拇指拖准心
## 用 _input 全局接触屏事件，只在摇杆区域内消费，其它区域放给准心拖拽
## 类名用 TouchJoystick 而非 VirtualJoystick：Godot 4.7 内置了 VirtualJoystick 节点，
## class_name 不得与内置类同名（否则 "hides a native class" 解析错误）；文件名保留原名

@export var radius: float = 90.0        # px，摇杆行程半径
@export var dead_zone: float = 0.15     # 归一化死区，小于它输出 0

const ArtAssetsScript := preload("res://systems/art/ArtAssets.gd")

var move_vector: Vector2 = Vector2.ZERO  # 归一化 -1..1，供玩家每帧读取

var _base_position: Vector2 = Vector2.ZERO  # 底座中心（控件本地坐标）
var _knob_offset: Vector2 = Vector2.ZERO    # 摇杆球当前偏移（px）
var _touch_index: int = -1


func _ready() -> void:
	# 占住屏幕左下角一块区域，不遮挡准心（屏心）与右侧将来放开火键
	size = Vector2(200.0, 200.0)
	position = Vector2(0.0, GameConfig.VIEWPORT_HEIGHT - size.y)
	_base_position = size * 0.5
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE  # 触屏走 _input，GUI 不拦


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index == -1:
			if _base_position.distance_to(touch.position - global_position) <= radius * 1.6:
				_touch_index = touch.index
				_update_knob(touch.position)
				get_viewport().set_input_as_handled()
		elif not touch.pressed and touch.index == _touch_index:
			_release()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			_update_knob(drag.position)
			get_viewport().set_input_as_handled()


func _release() -> void:
	_touch_index = -1
	_knob_offset = Vector2.ZERO
	move_vector = Vector2.ZERO
	queue_redraw()


## 丢掉当前触点（开图等场景切换时由 Player 转调）：手指还按在摇杆上就被打断时，
## 触点会一直记着，回到游戏后就再也接不上新的触摸——必须显式清掉
func reset() -> void:
	_release()


func _update_knob(touch_pos: Vector2) -> void:
	var offset: Vector2 = touch_pos - global_position - _base_position
	if offset.length() > radius:
		offset = offset.normalized() * radius
	_knob_offset = offset
	move_vector = offset / radius
	if move_vector.length() < dead_zone:
		move_vector = Vector2.ZERO
	queue_redraw()


func _draw() -> void:
	# 美术优先（2026-10-07 第九十四版）：ui_joystick_base(180) / ui_joystick_knob(81) 与程序绘制同几何
	# （81 / 180 = 0.45 = 下面 knob 的比例），所以换成贴图**画面上不会位移或变形**；
	# 文件不在就退回原来的圆 + 圈程序绘制。正式美术到位时同名替换即可，这里一行都不用改。
	var base_tex := ArtAssetsScript.texture("ui_joystick_base")
	var knob_tex := ArtAssetsScript.texture("ui_joystick_knob")
	if base_tex != null:
		draw_texture_rect(base_tex, Rect2(_base_position - Vector2(radius, radius),
				Vector2(radius, radius) * 2.0), false)
	else:
		draw_circle(_base_position, radius, Color(1.0, 1.0, 1.0, 0.12))
		draw_arc(_base_position, radius, 0.0, TAU, 48, Color(1.0, 1.0, 1.0, 0.45), 2.0)
	var knob_r := radius * 0.45
	if knob_tex != null:
		draw_texture_rect(knob_tex, Rect2(_base_position + _knob_offset - Vector2(knob_r, knob_r),
				Vector2(knob_r, knob_r) * 2.0), false)
	else:
		draw_circle(_base_position + _knob_offset, knob_r, Color(1.0, 1.0, 1.0, 0.55))
