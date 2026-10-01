class_name AimCameraController
extends Node2D

## 准心拖拽与相机跟随（docx 相机确认稿 · 照抄 fight-2 实现）
## 核心规则：准心 = 屏幕中心 = 相机中心，三者恒等；单 Camera2D 跟准心，无死区
## 输入：滑动屏幕 / 按住左键拖动 → crosshair_world += screen_delta / camera.zoom.x
## 每帧 resolve_crosshair：① 拖拽上限（步兵 500 m）② 地形遮挡回退 1 m
## 视线起点取被控单位中心

@export var smooth_speed: float = GameConfig.CAMERA_SMOOTH_SPEED
@export var zoom_index: int = GameConfig.DEFAULT_ZOOM_INDEX
@export var max_drag_distance: float = GameConfig.SIGHT_MAX_DISTANCE_INFANTRY

var crosshair_world := Vector2.ZERO

## 本帧准心是否被地形挡住（供 HUD 染色提示，区分于「拖拽上限」）
var blocked_by_terrain := false

## 右半屏接管瞄准：记录发起拖拽的触点编号，-1 表示当前没有瞄准手指。
var _aim_touch_index := -1

var _unit: Node2D = null
var _camera: Camera2D = null
var _sight: SightSystem = null
var _grid: HeightGrid = null


func setup(unit: Node2D, camera: Camera2D, sight: SightSystem) -> void:
	_unit = unit
	_camera = camera
	_sight = sight
	_grid = sight.grid if sight != null else null
	crosshair_world = unit.global_position
	camera.zoom = Vector2.ONE * GameConfig.ZOOM_LEVELS[zoom_index]


func _process(delta: float) -> void:
	if _unit == null or _camera == null:
		return
	_resolve_crosshair()
	var weight := clampf(smooth_speed * delta, 0.0, 1.0)
	_camera.global_position = _camera.global_position.lerp(crosshair_world, weight)


func _unhandled_input(event: InputEvent) -> void:
	# 只有「右半屏起手」的触摸才接管瞄准：左手在左下推摇杆时不抢准心。
	var screen_delta := Vector2.ZERO
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if touch.position.x >= GameConfig.VIEWPORT_WIDTH * 0.5:
				_aim_touch_index = touch.index
		elif touch.index == _aim_touch_index:
			_aim_touch_index = -1
		return
	if event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index != _aim_touch_index:
			return
		screen_delta = drag.relative
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
			and _aim_touch_index == -1:
		# 桌面鼠标，以及 Android 把触摸「模拟」出的鼠标事件（会绕过 set_input_as_handled）：
		# 同样只认右半屏，否则推摇杆的手会把准心一起拖走。
		# _aim_touch_index != -1 时说明正有手指在右半屏拖（触摸已处理），不能再叠加一次鼠标位移。
		var motion := event as InputEventMouseMotion
		if motion.position.x < GameConfig.VIEWPORT_WIDTH * 0.5:
			return
		screen_delta = motion.relative
	if screen_delta.is_zero_approx():
		return
	# 准心＝屏幕中心，屏幕位移 ÷ zoom.x = 世界位移（zoom.x 即 px/m，docx 相机确认稿）
	var zoom_factor := _camera.zoom.x if _camera != null else 1.0
	crosshair_world += screen_delta / maxf(zoom_factor, 0.001)
	get_viewport().set_input_as_handled()


## ① 拖拽上限 ② 地形遮挡回退——被钳制时广播 EventBus.crosshair_clamped
func _resolve_crosshair() -> void:
	var unit_pos := _unit.global_position
	var offset := crosshair_world - unit_pos
	var direction := offset.normalized() if offset.length() > 0.001 else Vector2.RIGHT
	var clamped := false
	blocked_by_terrain = false

	if offset.length() > max_drag_distance:
		crosshair_world = unit_pos + direction * max_drag_distance
		clamped = true

	# 近距豁免开关：CROSSHAIR_SIGHT_NEAR_EXEMPT 现为 0（文档严格口径），条件恒为真
	if _sight != null and offset.length() > GameConfig.CROSSHAIR_SIGHT_NEAR_EXEMPT:
		# 视线起点按玩家姿态（卧姿 0.6 m）：趴下后准心也该被沙袋挡住，
		# 不能出现「趴着还能越过沙袋瞄」（2026-09-28 真机反馈）
		var origin_height := _sight.unit_sight_height(unit_pos, _unit)
		var target_height := _sight.eye_height_at(crosshair_world)
		var blocker := _sight.terrain_first_blocker(
				unit_pos, origin_height, crosshair_world, target_height,
				GameConfig.CROSSHAIR_SIGHT_MARGIN_PER_METER)
		if blocker["blocked"]:
			var blocker_center: Vector2 = _grid.cell_to_world_center(blocker["cell"])
			var keep_distance := unit_pos.distance_to(blocker_center) \
					- GameConfig.CROSSHAIR_CLAMP_OFFSET
			crosshair_world = unit_pos + direction * maxf(keep_distance, 0.0)
			clamped = true
			blocked_by_terrain = true
		elif _sight.occluder_blocks(unit_pos, origin_height, crosshair_world, target_height):
			# 被沙袋 / 矮墙挡住：退到掩体前（docx 4.7 第③级也管准心）
			var cover_hit := _sight.first_cover_hit(unit_pos, crosshair_world)
			if cover_hit != Vector2.INF:
				var keep := unit_pos.distance_to(cover_hit) - GameConfig.CROSSHAIR_CLAMP_OFFSET
				crosshair_world = unit_pos + direction * maxf(keep, 0.0)
				clamped = true
				blocked_by_terrain = true

	if clamped:
		EventBus.crosshair_clamped.emit(crosshair_world)


## 三档离散缩放（docx 相机数值落地：防非整数 PPU 破坏像素对齐）
func set_zoom_index(index: int) -> void:
	zoom_index = clampi(index, 0, GameConfig.ZOOM_LEVELS.size() - 1)
	if _camera != null:
		_camera.zoom = Vector2.ONE * GameConfig.ZOOM_LEVELS[zoom_index]
