class_name MapPreview
extends Node2D

## 地图检测模式（Main.map_preview_mode = true 时启用）——不进游戏循环，直接看地形效果
## 看什么：地形贴图本身 ＋ 爬不上去的红域（可达性）＋ 关键点（节点/出生/敌人初始点）
##        ＋ 通视探针（轻触落点，扫 120 条射线，绿=可见、红=被地形挡住）
## 操作：单指拖动＝平移 ｜ 轻触＝落探针 ｜ 按钮＝可达性图层/放大/缩小 ｜ R 键＝按当前探针重扫

var _grid: HeightGrid = null
var _sight: SightSystem = null
var _camera: Camera2D = null

var _overlay: Sprite2D = null
var _zoom_index := 0

var _probe_world := Vector2.INF
var _rays: Array = []
var _probe_info: Dictionary = {}

var _touch_index := -1
var _touch_moved := 0.0
var _info_label: Label = null


func setup(grid: HeightGrid, sight: SightSystem, camera: Camera2D) -> void:
	_grid = grid
	_sight = sight
	_camera = camera


func _ready() -> void:
	if _camera != null:
		_camera.zoom = Vector2.ONE * float(GameConfig.PREVIEW_ZOOM_LEVELS[_zoom_index])
	if _grid != null:
		_overlay = Sprite2D.new()
		_overlay.name = "PassabilityOverlay"
		_overlay.texture = ImageTexture.create_from_image(
				MapInspector.build_passability_image(_grid))
		_overlay.centered = false
		add_child(_overlay)
	_build_ui()
	_update_info_label()


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "PreviewUI"
	add_child(layer)

	var hint := Label.new()
	hint.text = "地图检测模式（不进游戏循环）：拖动平移 ｜ 轻触屏幕落探针扫通视 ｜ R 重扫"
	hint.position = Vector2(16.0, 12.0)
	layer.add_child(hint)

	_info_label = Label.new()
	_info_label.position = Vector2(16.0, 38.0)
	layer.add_child(_info_label)

	var toggle := Button.new()
	toggle.text = "可达性"
	toggle.position = Vector2(GameConfig.VIEWPORT_WIDTH - 300.0, 12.0)
	toggle.pressed.connect(_toggle_overlay)
	layer.add_child(toggle)

	var zoom_in := Button.new()
	zoom_in.text = "放大"
	zoom_in.position = Vector2(GameConfig.VIEWPORT_WIDTH - 190.0, 12.0)
	zoom_in.pressed.connect(_change_zoom.bind(1))
	layer.add_child(zoom_in)

	var zoom_out := Button.new()
	zoom_out.text = "缩小"
	zoom_out.position = Vector2(GameConfig.VIEWPORT_WIDTH - 98.0, 12.0)
	zoom_out.pressed.connect(_change_zoom.bind(-1))
	layer.add_child(zoom_out)


func _toggle_overlay() -> void:
	if _overlay != null:
		_overlay.visible = not _overlay.visible


func _change_zoom(direction: int) -> void:
	var levels: Array = GameConfig.PREVIEW_ZOOM_LEVELS
	_zoom_index = clampi(_zoom_index + direction, 0, levels.size() - 1)
	if _camera != null:
		_camera.zoom = Vector2.ONE * float(levels[_zoom_index])
	_update_info_label()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if (event as InputEventKey).keycode == KEY_R:
			_scan(_probe_world)
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index == -1:
			_touch_index = touch.index
			_touch_moved = 0.0
		elif not touch.pressed and touch.index == _touch_index:
			if _touch_moved < 8.0:
				_place_probe(touch.position)
			_touch_index = -1
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			_touch_moved += drag.relative.length()
			_pan(drag.relative)
	elif event is InputEventMouseButton and event.pressed \
			and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		_place_probe((event as InputEventMouseButton).position)
	elif event is InputEventMouseMotion and _touch_index == -1 \
			and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# 触摸拖动期间屏蔽鼠标分支：Android 会把触摸模拟成鼠标事件，否则平移翻倍
		_pan((event as InputEventMouseMotion).relative)


func _pan(screen_delta: Vector2) -> void:
	if _camera == null:
		return
	_camera.position -= screen_delta / maxf(_camera.zoom.x, 0.001)


func _place_probe(screen_pos: Vector2) -> void:
	if _camera == null:
		return
	var viewport_center := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	_probe_world = _camera.position + (screen_pos - viewport_center) \
			/ maxf(_camera.zoom.x, 0.001)
	_scan(_probe_world)


func _scan(world_pos: Vector2) -> void:
	if world_pos == Vector2.INF or _grid == null or _sight == null:
		return
	_rays = MapInspector.scan_visibility(_grid, _sight, world_pos)
	_probe_info = MapInspector.sample_info(_grid, world_pos)
	_update_info_label()
	queue_redraw()


func _update_info_label() -> void:
	if _info_label == null:
		return
	var zoom_text := "缩放 ×%.2f" % float(GameConfig.PREVIEW_ZOOM_LEVELS[_zoom_index])
	if _probe_world == Vector2.INF:
		_info_label.text = "%s ｜ 轻触屏幕落探针" % zoom_text
		return
	var clear_count := 0
	for ray in _rays:
		if not ray["blocked"]:
			clear_count += 1
	var passable: bool = _probe_info.get("passable", true)
	var walk_text := "可通行" if passable else "不可通行（坡度超限）"
	_info_label.text = "%s ｜ 探针 (%.0f, %.0f) 高程 %.1f m ｜ 最大坡度 %.1f° ｜ %s ｜ 通视 %d/%d 条无阻挡" % [
		zoom_text, _probe_world.x, _probe_world.y, float(_probe_info.get("height", 0.0)),
		float(_probe_info.get("slope_deg", 0.0)), walk_text, clear_count, _rays.size()]


func _draw() -> void:
	# 地图边界
	draw_rect(Rect2(0.0, 0.0, GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT),
			Color(1.0, 1.0, 1.0, 0.5), false, 3.0)
	# 关键点：节点（含占领半径）/ 出生点 / 敌人初始点——预览模式没有实体，直接用地图数据
	for i in MapGenerator.DEMO_NODES.size():
		var node_pos: Vector2 = MapGenerator.DEMO_NODES[i]
		draw_arc(node_pos, GameConfig.CAPTURE_ZONE_RADIUS, 0.0, TAU, 48,
				Color(0.4, 0.7, 1.0, 0.9), 3.0)
		draw_circle(node_pos, 10.0, Color(0.4, 0.7, 1.0))
	var spawn := MapGenerator.demo_spawn_point()
	draw_circle(spawn, 14.0, Color(1.0, 0.9, 0.3))
	for enemy_point in MapGenerator.demo_enemy_points():
		draw_circle(enemy_point, 12.0, Color(0.95, 0.3, 0.25))
	# 载具（候选 I/K）：预览模式不建实体，但位置必须能从图上读出来——
	# 否则「坦克在哪」只能靠猜，调试时根本找不到车
	var vehicles := MapGenerator.demo_vehicle_points()
	var vehicle_marks := [
		{"point": vehicles[0], "color": Color(0.35, 0.75, 0.45), "label": "我方车"},
		{"point": vehicles[1], "color": Color(0.85, 0.3, 0.25), "label": "敌方坦克"},
	]
	for mark in vehicle_marks:
		var point: Vector2 = mark["point"]
		var body := Rect2(point - Vector2(16.0, 9.0), Vector2(32.0, 18.0))
		draw_rect(body, mark["color"])
		draw_rect(body, Color(1.0, 1.0, 1.0, 0.85), false, 2.0)
		# 只用 font / 位置 / 文本三个参数：可选参数（对齐、字号、色）顺序没在本地手册核对过，不冒险
		draw_string(ThemeDB.fallback_font, point + Vector2(20.0, 6.0),
				String(mark["label"]))
	if _probe_world == Vector2.INF:
		return
	# 通视探针：绿=该方向可见（地形没挡），红=被地形挡住
	for ray in _rays:
		var end_point: Vector2 = ray["point"]
		var color := Color(0.35, 0.95, 0.45, 0.55)
		if ray["blocked"]:
			color = Color(0.95, 0.35, 0.3, 0.7)
		draw_line(_probe_world, end_point, color, 2.0)
	draw_circle(_probe_world, 10.0, Color(1.0, 1.0, 1.0))
