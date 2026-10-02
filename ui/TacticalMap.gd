class_name TacticalMap
extends Control

## 战术地图全屏（docx 4.11.1 图层 / 4.11.3 操作 / 4.11.7 确认稿）
## 定位：取消对局内全部麦之后，这是唯一的战术沟通渠道，也是任务 / 报点 / 间瞄三件事的载体
## 第一版做到：① 不暂停游戏（只是个覆盖层）② 开图期间由 Main 冻结移动与开火
##             ③ 固定朝北不旋转，拖动平移 + 三档缩放
##             ④ 图层：地形 → 节点与净进度 → 任务目标 → 世界目标（补给车 / 侧翼通路 / 敌方 FOB）→ 己方 → 报点标记
##             ⑤ 报点：底部先选类型 → 点地图位置（通视前提由 Main 判定后回话）
## 未做：间瞄选落点（7.4.2）、小队标记链与集结点、载具图层、PVEVP 战线

const MapLayerSourceScript := preload("res://ui/MapLayerSource.gd")

signal closed
signal mark_placed(type: int, position: Vector2)
## 间瞄选落点（docx 4.11.3）：地图上点位置 → 请求往那儿打一发
signal indirect_target_selected(target: Vector2)

## 间瞄选点模式（docx 4.11.3）：开启后点地图 = 选落点，而不是落报点
## 注意：公有 var 必须排在私有 var 之前（gdlint class-definitions-order）
var indirect_mode := false

var _grid: HeightGrid = null
var _player: Node2D = null
var _zones: Array = []
var _marks: MarkSystem = null
var _quests: QuestSystem = null
var _terrain_texture: Texture2D = null
var _main = null     # Main（鸭子类型）：世界目标图层从这里取（2026-10-01 ④）

var _center_world := Vector2.ZERO
var _zoom_index := 0
var _selected_type := 0
var _type_buttons: Array[Button] = []
var _indirect_button: Button = null
var _hint_label: Label = null
var _zoom_label: Label = null
var _hint_timer := 0.0
var _drag_index := -1
var _drag_moved := 0.0


func setup(grid: HeightGrid, player: Node2D, zones: Array, marks: MarkSystem,
		quests: QuestSystem, terrain_texture: Texture2D, main_node = null) -> void:
	_grid = grid
	_player = player
	_zones = zones
	_marks = marks
	_quests = quests
	_terrain_texture = terrain_texture
	_main = main_node


func _ready() -> void:
	size = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)
	# 全屏吃掉输入：开图时不许下层的摇杆 / 准心 / 开火抢事件
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
	_build_ui()
	visible = false


func is_open() -> bool:
	return visible


func open() -> void:
	# 每次开图都居中到自己（docx 4.11.3：固定朝北，保证「左/右」有唯一参照）
	if _player != null:
		_center_world = _player.global_position
	visible = true
	show_hint("拖动平移 ｜ 底部先选标记类型，再点地图位置落点", 3.0)
	queue_redraw()


func close() -> void:
	visible = false
	closed.emit()


func show_hint(text: String, seconds: float = 2.0) -> void:
	if _hint_label == null:
		return
	_hint_label.text = text
	_hint_timer = seconds


## 世界 ↔ 屏幕（战术地图自己的坐标系：中心点 + px/m 缩放）
static func world_to_screen(world: Vector2, center_world: Vector2, zoom: float) -> Vector2:
	var viewport_center := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	return viewport_center + (world - center_world) * zoom


static func screen_to_world(screen: Vector2, center_world: Vector2, zoom: float) -> Vector2:
	var viewport_center := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	return center_world + (screen - viewport_center) / maxf(zoom, 0.0001)


func _build_ui() -> void:
	var title := Label.new()
	title.text = "战术地图（固定朝北 ｜ 不暂停）"
	title.position = Vector2(16.0, 10.0)
	add_child(title)

	_zoom_label = Label.new()
	_zoom_label.position = Vector2(GameConfig.VIEWPORT_WIDTH - 218.0, 14.0)
	add_child(_zoom_label)

	var zoom_out := Button.new()
	zoom_out.text = "－"
	zoom_out.size = Vector2(44.0, 40.0)
	zoom_out.position = Vector2(GameConfig.VIEWPORT_WIDTH - 310.0, 8.0)
	zoom_out.pressed.connect(_change_zoom.bind(-1))
	add_child(zoom_out)

	var zoom_in := Button.new()
	zoom_in.text = "＋"
	zoom_in.size = Vector2(44.0, 40.0)
	zoom_in.position = Vector2(GameConfig.VIEWPORT_WIDTH - 260.0, 8.0)
	zoom_in.pressed.connect(_change_zoom.bind(1))
	add_child(zoom_in)

	var close_button := Button.new()
	close_button.text = "关闭"
	close_button.size = Vector2(80.0, 40.0)
	close_button.position = Vector2(GameConfig.VIEWPORT_WIDTH - 90.0, 8.0)
	close_button.pressed.connect(close)
	add_child(close_button)

	_hint_label = Label.new()
	_hint_label.position = Vector2(16.0, GameConfig.VIEWPORT_HEIGHT - 104.0)
	add_child(_hint_label)

	# 间瞄选点开关（docx 4.11.3）：开启后点地图就是选落点
	_indirect_button = Button.new()
	_indirect_button.text = "间瞄选点：关"
	_indirect_button.size = Vector2(156.0, 44.0)
	_indirect_button.position = Vector2(GameConfig.VIEWPORT_WIDTH - 172.0,
			GameConfig.VIEWPORT_HEIGHT - 104.0)
	_indirect_button.pressed.connect(_toggle_indirect)
	add_child(_indirect_button)

	# 底部：6 类标记选择（docx 4.11.3「选标记类型 → 点位置 → 广播」）
	var count := MarkSystem.TYPE_LABELS.size()
	var width := GameConfig.TACTICAL_TYPE_BUTTON_WIDTH
	var total := float(count) * width
	var start_x := (GameConfig.VIEWPORT_WIDTH - total) * 0.5
	for i in count:
		var button := Button.new()
		button.text = MarkSystem.type_label(i)
		button.size = Vector2(width - 4.0, GameConfig.TACTICAL_TYPE_BUTTON_HEIGHT)
		button.position = Vector2(start_x + float(i) * width, GameConfig.VIEWPORT_HEIGHT
				- GameConfig.TACTICAL_TYPE_BUTTON_HEIGHT - 8.0)
		button.add_theme_color_override("font_color", MarkSystem.type_color(i))
		button.pressed.connect(_select_type.bind(i))
		add_child(button)
		_type_buttons.append(button)
	_refresh_type_buttons()
	_update_zoom_label()


func _select_type(type: int) -> void:
	_selected_type = type
	_refresh_type_buttons()


func _refresh_type_buttons() -> void:
	for i in _type_buttons.size():
		_type_buttons[i].modulate = (Color(1.0, 1.0, 1.0) if i == _selected_type
				else Color(1.0, 1.0, 1.0, 0.5))


func _change_zoom(direction: int) -> void:
	var levels: Array = GameConfig.TACTICAL_ZOOM_LEVELS
	_zoom_index = clampi(_zoom_index + direction, 0, levels.size() - 1)
	_update_zoom_label()
	queue_redraw()


func _update_zoom_label() -> void:
	if _zoom_label != null:
		_zoom_label.text = "缩放 ×%.1f" % _zoom()


func _zoom() -> float:
	return float(GameConfig.TACTICAL_ZOOM_LEVELS[_zoom_index])


func _to_screen(world: Vector2) -> Vector2:
	return world_to_screen(world, _center_world, _zoom())


func _process(delta: float) -> void:
	if not visible:
		return
	if _hint_timer > 0.0:
		_hint_timer = maxf(_hint_timer - delta, 0.0)
		if _hint_timer <= 0.0 and _hint_label != null:
			_hint_label.text = ""
	queue_redraw()  # 标记时效在变，重绘跟得上


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			_drag_index = touch.index
			_drag_moved = 0.0
		elif touch.index == _drag_index:
			if _drag_moved < GameConfig.TACTICAL_PRESS_SLOP:
				_emit_place_mark(touch.position)
			_drag_index = -1
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _drag_index:
			_drag_moved += drag.relative.length()
			_pan(drag.relative)
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT:
			if mouse.pressed:
				_drag_moved = 0.0
			elif _drag_moved < GameConfig.TACTICAL_PRESS_SLOP:
				_emit_place_mark(mouse.position)
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var motion := event as InputEventMouseMotion
		_drag_moved += motion.relative.length()
		_pan(motion.relative)


func _pan(screen_delta: Vector2) -> void:
	_center_world -= screen_delta / _zoom()
	queue_redraw()


func _emit_place_mark(screen_pos: Vector2) -> void:
	var world := screen_to_world(screen_pos, _center_world, _zoom())
	if indirect_mode:
		indirect_target_selected.emit(_snap_to_mark(world))
		return
	mark_placed.emit(_selected_type, world)


## 间瞄靶点吸附（docx 4.11.4）：落点附近有己方报点标记时直接吸附上去——
## 这就是「侦察兵标 → 间瞄覆盖」的杀伤链
func _snap_to_mark(world: Vector2) -> Vector2:
	if _marks == null:
		return world
	var best := world
	var best_distance := GameConfig.INDIRECT_SNAP_RADIUS
	for mark in _marks.marks:
		var mark_position: Vector2 = mark["position"]
		var distance := world.distance_to(mark_position)
		if distance < best_distance:
			best_distance = distance
			best = mark_position
	return best


func _toggle_indirect() -> void:
	indirect_mode = not indirect_mode
	if _indirect_button != null:
		_indirect_button.text = "间瞄选点：%s" % ("开" if indirect_mode else "关")
	show_hint("间瞄选点已%s：点地图任意位置即为落点" % ("开启" if indirect_mode else "关闭"), 2.5)


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO,
			Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)),
			Color(0.02, 0.03, 0.05, GameConfig.TACTICAL_BG_ALPHA))
	_draw_terrain_layer()
	_draw_zone_layer()
	_draw_quest_layer()
	_draw_world_layer()
	_draw_unit_layer()
	_draw_mark_layer()


## ① 底层：地形（1 px = 1 m 的贴图按缩放铺开）
func _draw_terrain_layer() -> void:
	if _terrain_texture == null:
		return
	var rect := Rect2(_to_screen(Vector2.ZERO),
			Vector2(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT) * _zoom())
	draw_texture_rect(_terrain_texture, rect, false, Color(1.0, 1.0, 1.0, 0.9))
	draw_rect(rect, Color(1.0, 1.0, 1.0, 0.45), false, 2.0)


## ② 战术层：节点与净进度（蓝/红/白与争夺进度）
func _draw_zone_layer() -> void:
	for zone in _zones:
		var capture_zone := zone as CaptureZone
		if capture_zone == null:
			continue
		var zone_screen := _to_screen(capture_zone.global_position)
		var color := _zone_color(capture_zone)
		draw_arc(zone_screen, GameConfig.CAPTURE_ZONE_RADIUS * _zoom(), 0.0, TAU, 48,
				Color(color.r, color.g, color.b, 0.75), 2.0)
		draw_circle(zone_screen, 7.0, color)
		var bar_width := 40.0
		var bar := Rect2(zone_screen + Vector2(-bar_width * 0.5, 12.0),
				Vector2(bar_width, 4.0))
		draw_rect(bar, Color(1.0, 1.0, 1.0, 0.25))
		draw_rect(Rect2(bar.position, Vector2(bar_width * ((capture_zone.progress + 1.0) * 0.5),
				bar.size.y)), color)


func _zone_color(capture_zone: CaptureZone) -> Color:
	if capture_zone.state == CaptureZone.State.BLUE:
		return Color(0.3, 0.5, 1.0)
	if capture_zone.state == CaptureZone.State.RED:
		return Color(0.9, 0.3, 0.25)
	if not is_zero_approx(capture_zone.progress):
		return Color(1.0, 1.0, 1.0, 0.85)
	return Color(0.5, 0.5, 0.5)


## ③ 任务层：当前主线任务的目标节点高亮（docx 4.10 → 4.11 的接口）
func _draw_quest_layer() -> void:
	if _quests == null:
		return
	var main_quest: Dictionary = _quests.main_quest()
	var target := main_quest.get("zone") as CaptureZone
	if target == null:
		return
	draw_arc(_to_screen(target.global_position),
			GameConfig.CAPTURE_ZONE_RADIUS * _zoom() + 7.0, 0.0, TAU, 48,
			Color(1.0, 0.85, 0.35, 0.95), 3.0)


## ③.5 世界目标层（2026-10-01 ④，docx 4.11.1 ④单位层）
## 侧翼通路（地形要素，常显；任务激活时画亮）／己方补给车（含到目标的路线）／敌方 FOB（暴露后）
func _draw_world_layer() -> void:
	if _main == null:
		return
	var lane = MapLayerSourceScript.lane(_main)
	if lane != null:
		var lane_color := Color(0.95, 0.75, 0.30, 0.9) if lane.active \
				else Color(0.75, 0.70, 0.45, 0.4)
		# 走廊两边：与 Lane 世界视图同一口径（半宽 × 当前缩放），四角由 MapLayerSource 统一算
		var corners := MapLayerSourceScript.lane_edges(lane.entry_position,
				lane.exit_position, lane.half_width)
		if corners.size() == 4:
			var left_entry := _to_screen(corners[0])
			var right_entry := _to_screen(corners[1])
			var left_exit := _to_screen(corners[2])
			var right_exit := _to_screen(corners[3])
			draw_line(left_entry, left_exit, lane_color, 2.0)
			draw_line(right_entry, right_exit, lane_color, 2.0)
			# 入口（敌方来向）红、出口（我方一侧）蓝——与 Lane._draw 一致
			draw_line(left_entry, right_entry, Color(0.90, 0.35, 0.30, 0.85), 3.0)
			draw_line(left_exit, right_exit, Color(0.35, 0.75, 0.95, 0.85), 3.0)
	var convoy = MapLayerSourceScript.convoy(_main)
	if convoy != null:
		var from := _to_screen(convoy.global_position)
		var to := _to_screen(convoy.target_position)
		draw_line(from, to, Color(0.55, 0.85, 0.55, 0.5), 2.0)
		draw_circle(to, 8.0, Color(0.45, 0.90, 0.55, 0.25))
		draw_circle(from, 6.0, Color(0.45, 0.90, 0.55, 0.95))
		draw_arc(from, 11.0, 0.0, TAU, 24, Color(0.45, 0.90, 0.55, 0.6), 1.5)
	for fob in MapLayerSourceScript.visible_fobs(get_tree()):
		var fob_screen := _to_screen(fob.global_position)
		var half_size := Vector2(GameConfig.FOB_HALF_X, GameConfig.FOB_HALF_Y) * _zoom()
		if bool(fob.destroyed):
			draw_rect(Rect2(fob_screen - half_size, half_size * 2.0),
					Color(0.45, 0.40, 0.36, 0.7))
		else:
			draw_rect(Rect2(fob_screen - half_size, half_size * 2.0),
					Color(0.90, 0.28, 0.24, 0.85))
			draw_rect(Rect2(fob_screen - half_size, half_size * 2.0),
					Color(1.0, 0.92, 0.82, 0.95), false, 2.0)


## ④ 单位层：己方（第一版只有玩家自己；docx 4.11.2：己方全显）
func _draw_unit_layer() -> void:
	if _player == null:
		return
	var player_screen := _to_screen(_player.global_position)
	draw_circle(player_screen, 6.0, Color(1.0, 0.9, 0.3))
	draw_arc(player_screen, 12.0, 0.0, TAU, 24, Color(1.0, 0.9, 0.3, 0.6), 1.5)


## ⑤ 报点标记层：敌方只有被报点才出现，且是「最后目击位置」+ 时效渐隐
func _draw_mark_layer() -> void:
	if _marks == null:
		return
	for mark in _marks.marks:
		var mark_position: Vector2 = mark["position"]
		var color := MarkSystem.type_color(int(mark["type"]))
		var total := maxf(float(mark["duration"]), 0.001)
		var life := clampf(float(mark["time_left"]) / total, 0.0, 1.0)
		color.a = 0.4 + 0.6 * life
		draw_circle(_to_screen(mark_position), 5.0, color)
