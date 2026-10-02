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

## 4.16：被控单位倒地后，相机锁定在倒地身体上方（俯视固定、不可拖动）
var locked_on_unit := false

## 12.7.4 轻微屏幕震动：受击时叠一个瞬态偏移（不参与准心 / 弹道，只是「画面晃一下」）
var _shake_time := 0.0
var _shake_strength := 0.0

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
	# 12.7.4：受击震动由这里订阅（Player 只广播，不反向依赖相机；Main 因此一行都不用加）
	if EventBus != null and EventBus.has_signal("player_hit") \
			and not EventBus.is_connected("player_hit", _on_player_hit):
		EventBus.connect("player_hit", _on_player_hit)


func _process(delta: float) -> void:
	if _unit == null or _camera == null:
		return
	locked_on_unit = unit_is_downed()
	if locked_on_unit:
		# 4.16：倒地后锁在身体上——俯视固定、不做遮挡回退（人都倒了，没有「瞄准」这回事）
		crosshair_world = _unit.global_position
		blocked_by_terrain = false
	else:
		_resolve_crosshair()
	var weight := clampf(smooth_speed * delta, 0.0, 1.0)
	_camera.global_position = _camera.global_position.lerp(crosshair_world, weight) \
			+ advance_shake(delta)


## 12.7.4 受击震动：叠一个短促的随机偏移（幅度随时间线性归零）
func add_shake(strength: float = GameConfig.SCREEN_SHAKE_STRENGTH,
		time: float = GameConfig.SCREEN_SHAKE_TIME) -> void:
	_shake_strength = maxf(_shake_strength, strength)
	_shake_time = maxf(_shake_time, time)


func shake_active() -> bool:
	return _shake_time > 0.0


## 每帧推进并给出偏移；纯计算，测试可以直接驱动（不必进场景树）
func advance_shake(delta: float) -> Vector2:
	if _shake_time <= 0.0:
		_shake_strength = 0.0
		return Vector2.ZERO
	_shake_time = maxf(_shake_time - delta, 0.0)
	var amplitude := _shake_strength * (_shake_time / GameConfig.SCREEN_SHAKE_TIME)
	if amplitude <= 0.0:
		return Vector2.ZERO
	return Vector2(randf_range(-amplitude, amplitude), randf_range(-amplitude, amplitude))


func _on_player_hit(_damage) -> void:
	add_shake()


## 被控单位是否已倒地（鸭子类型：PlayerUnit 有 downed 属性；别的单位没有就算没倒地）
func unit_is_downed() -> bool:
	return _unit != null and ("downed" in _unit) and bool(_unit.downed)


func _unhandled_input(event: InputEvent) -> void:
	# 只有「右半屏起手」的触摸才接管瞄准：左手在左下推摇杆时不抢准心。
	if unit_is_downed():
		return   # 4.16：倒地后不允许拖动瞄准
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
		elif _sight.smoke_blocks(unit_pos, origin_height, crosshair_world, target_height):
			# 被烟幕挡住：退到烟前（docx 4.12.4「准心拖进烟雾区时按遮挡处理，停在烟前或回退」）
			# blocked_by_terrain 这个名字保留（历史）：地形 / 掩体 / 烟任一挡住它都为 true，
			# 报点红线（4.11.2）因此也一并挡住「隔着烟报点」。
			var smoke_hit := _sight.first_smoke_hit(unit_pos, crosshair_world)
			# 2026-10-02 真机修：**自己站在烟里不能钳**。segment_circle_entry 对「起点在圆内」
			# 返回起点本身 ⇒ keep = 0 - offset ⇒ 准心被钳到脚下，真机表现就是「准心锁死在烟里、拖不动」
			# （载具发烟器必踩：烟就放在自己脚下）。口径：烟挡「从外往里看」，不挡「从烟里往外看」，
			# 隔着烟的远距离判定仍由 smoke_blocks 负责。
			var inside_smoke := smoke_hit == Vector2.INF 					or unit_pos.distance_to(smoke_hit) <= GameConfig.CROSSHAIR_CLAMP_OFFSET
			if not inside_smoke:
				var keep := unit_pos.distance_to(smoke_hit) - GameConfig.CROSSHAIR_CLAMP_OFFSET
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
