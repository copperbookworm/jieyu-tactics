@tool
class_name JieyuMapCanvas
extends Control

## 地图画布：显示高度图 / 审阅图，处理鼠标 → 地图格的换算与笔刷拖拽。
##
## 只干三件事：① 画（贴图 + 叠加层 + 笔刷预览 + 比例尺）
##             ② 把屏幕坐标翻成世界格坐标（含缩放 / 平移）
##             ③ 拖拽时发出绘制信号（真正的改高度由 Dock 调 JieyuMapPainter 做）
##
## 这样分层的原因：画布可以单独 headless 实例化做几何断言，改高度的逻辑也能无头单测。

signal stroke_started(at_cell: Vector2i)
signal stroke_moved(from_cell: Vector2i, to_cell: Vector2i)
signal stroke_ended()

const MIN_ZOOM := 0.1
const MAX_ZOOM := 8.0
const ZOOM_STEP := 1.15

var texture: Texture2D = null:
	set(value):
		texture = value
		queue_redraw()

var map_size := Vector2i(1000, 1000):
	set(value):
		map_size = value
		_fit_zoom()
		queue_redraw()

var zoom := 0.6:
	set(value):
		zoom = clampf(value, MIN_ZOOM, MAX_ZOOM)
		queue_redraw()

var pan := Vector2.ZERO:
	set(value):
		pan = value
		queue_redraw()

## 笔刷半径（米）与是否可见
var brush_radius := 30.0:
	set(value):
		brush_radius = maxf(value, 0.5)
		queue_redraw()

var brush_visible := true:
	set(value):
		brush_visible = value
		queue_redraw()

## 叠加层：把审阅图（等高线 / 节点 / 掩体）作为半透明层压上去
var overlay: Texture2D = null:
	set(value):
		overlay = value
		queue_redraw()

var overlay_alpha := 1.0:
	set(value):
		overlay_alpha = clampf(value, 0.0, 1.0)
		queue_redraw()

## 鼠标当前所在的地图格（-1 = 不在图上）
var hover_cell := Vector2i(-1, -1)

var _painting := false
var _drag_button := 0
var _last_cell := Vector2i(-1, -1)
var _drag_start := Vector2.ZERO
var _panning := false
var _pan_origin := Vector2.ZERO
var _fitted := false


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	resized.connect(_on_resized)


func _on_resized() -> void:
	if not _fitted:
		_fit_zoom()
	queue_redraw()


## 让整张图正好铺满画布（首次显示 / 换图时调）
func _fit_zoom() -> void:
	if size.x <= 1.0 or size.y <= 1.0 or map_size.x <= 0 or map_size.y <= 0:
		return
	var fit := minf(size.x / float(map_size.x), size.y / float(map_size.y))
	zoom = clampf(fit, MIN_ZOOM, MAX_ZOOM)
	pan = Vector2.ZERO
	_fitted = true


func fit_now() -> void:
	_fitted = false
	_fit_zoom()
	queue_redraw()


## ────────────── 坐标换算 ──────────────

func world_rect() -> Rect2:
	return Rect2(pan, Vector2(map_size) * zoom)


func screen_to_cell(screen: Vector2) -> Vector2i:
	var local := (screen - pan) / zoom
	return Vector2i(floori(local.x), floori(local.y))


func cell_to_screen(cell: Vector2i) -> Vector2:
	return pan + (Vector2(cell) + Vector2(0.5, 0.5)) * zoom


func is_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < map_size.x and cell.y < map_size.y


## ────────────── 输入 ──────────────

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_button(event)
	elif event is InputEventMouseMotion:
		_handle_motion(event)
	elif event is InputEventMagnifyGesture:
		_zoom_at((event as InputEventMagnifyGesture).position,
				(event as InputEventMagnifyGesture).factor)


func _handle_button(event: InputEventMouseButton) -> void:
	var button := event as InputEventMouseButton
	var cell := screen_to_cell(button.position)
	match button.button_index:
		MOUSE_BUTTON_WHEEL_UP:
			if button.pressed:
				_zoom_at(button.position, ZOOM_STEP)
				accept_event()
		MOUSE_BUTTON_WHEEL_DOWN:
			if button.pressed:
				_zoom_at(button.position, 1.0 / ZOOM_STEP)
				accept_event()
		MOUSE_BUTTON_MIDDLE:
			_panning = button.pressed
			_pan_origin = button.position - pan
			accept_event()
		MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT:
			if button.pressed:
				_painting = true
				_drag_button = button.button_index
				_drag_start = button.position
				_last_cell = cell
				stroke_started.emit(cell)
			else:
				if _painting:
					stroke_ended.emit()
				_painting = false
			accept_event()
		_:
			pass


func _handle_motion(event: InputEventMouseMotion) -> void:
	var motion := event as InputEventMouseMotion
	if _panning:
		pan = motion.position - _pan_origin
		queue_redraw()
		return
	var cell := screen_to_cell(motion.position)
	if cell != hover_cell:
		hover_cell = cell
		queue_redraw()
	if _painting and _drag_button != 0:
		stroke_moved.emit(_last_cell, cell)
		_last_cell = cell


func _zoom_at(anchor: Vector2, factor: float) -> void:
	var before := (anchor - pan) / zoom
	zoom = clampf(zoom * factor, MIN_ZOOM, MAX_ZOOM)
	pan = anchor - before * zoom
	queue_redraw()


## ────────────── 绘制 ──────────────

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.09, 0.09, 0.11))
	var rect := world_rect()
	if texture != null:
		draw_texture_rect(texture, rect, false)
	if overlay != null:
		draw_texture_rect(overlay, rect, false, Color(1, 1, 1, overlay_alpha))
	draw_rect(rect, Color(0.5, 0.5, 0.55), false, 1.0)
	if brush_visible and is_inside(hover_cell):
		var radius := brush_radius * zoom
		var center := cell_to_screen(hover_cell)
		draw_arc(center, radius, 0.0, TAU, 64, Color(1.0, 0.9, 0.3, 0.9), 1.5)
		draw_line(center - Vector2(6, 0), center + Vector2(6, 0), Color(1, 1, 1, 0.5), 1.0)
		draw_line(center - Vector2(0, 6), center + Vector2(0, 6), Color(1, 1, 1, 0.5), 1.0)
	_draw_scale_bar()


## 比例尺：右下角画一条代表 100 m 的线（1 m = 1 格）
func _draw_scale_bar() -> void:
	var pixels := 100.0 * zoom
	if pixels < 20.0 or pixels > size.x - 40.0:
		return
	var origin := Vector2(20.0, size.y - 20.0)
	draw_line(origin, origin + Vector2(pixels, 0.0), Color(1, 1, 1, 0.85), 2.0)
	draw_line(origin, origin - Vector2(0, 5), Color(1, 1, 1, 0.85), 2.0)
	draw_line(origin + Vector2(pixels, 0), origin + Vector2(pixels, -5),
			Color(1, 1, 1, 0.85), 2.0)
	draw_string(ThemeDB.fallback_font, origin + Vector2(0, -8), "100 m",
			HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1, 1, 1, 0.85))
