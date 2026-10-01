class_name MiniMap
extends Node2D

## 小地图（CS:GO 风格角落缩略图）：地形缩略 + 节点 + 玩家位置
## 挂在 HUD CanvasLayer 下（屏幕坐标）；世界 1000 m 映射到 150 px
## 节点圆点颜色随占领状态：灰=未占、白=争夺中、蓝=已占；黄点=玩家

const MINI_SIZE := 150.0
const MAP_SIZE := 1000.0

var _terrain_texture: ImageTexture = null
var _player: Node2D = null
var _zones: Array = []
var _marks: MarkSystem = null
var _indirect = null   # IndirectFire（动态类型：该模块刻意无 class_name，见其文件头）


func setup(terrain_texture: ImageTexture, player: Node2D, zones: Array,
		marks: MarkSystem = null) -> void:
	_terrain_texture = terrain_texture
	_player = player
	_zones = zones
	_marks = marks


## 间瞄落点也要在小地图上看得见——否则选了远处的点，玩家完全没有反馈
func set_indirect(fire) -> void:
	_indirect = fire


func _ready() -> void:
	# 右上角，避开开火按钮（右下）与准心（屏心）
	position = Vector2(GameConfig.VIEWPORT_WIDTH - MINI_SIZE - 8.0, 8.0)
	var bg := Sprite2D.new()
	bg.texture = _terrain_texture
	bg.scale = Vector2.ONE * (MINI_SIZE / MAP_SIZE)
	bg.centered = false
	add_child(bg)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var scale_factor := MINI_SIZE / MAP_SIZE
	for zone in _zones:
		var capture_zone := zone as CaptureZone
		if capture_zone == null:
			continue
		var color := Color(0.5, 0.5, 0.5)
		if capture_zone.state == CaptureZone.State.BLUE:
			color = Color(0.3, 0.5, 1.0)
		elif capture_zone.state == CaptureZone.State.RED:
			color = Color(0.9, 0.3, 0.25)
		elif not is_zero_approx(capture_zone.progress):
			color = Color(1.0, 1.0, 1.0)
		draw_circle(capture_zone.global_position * scale_factor, 5.0, color)
	if _player != null:
		draw_circle(_player.global_position * scale_factor, 3.5, Color(1.0, 0.9, 0.3))
	if is_inside_tree():
		for enemy in get_tree().get_nodes_in_group("enemy"):
			var enemy_node := enemy as Node2D
			if enemy_node == null or enemy_node.is_queued_for_deletion():
				continue
			draw_circle(enemy_node.global_position * scale_factor, 3.0,
					Color(0.95, 0.3, 0.25))
	# 间瞄落点（飞行中）：橙色圈——选了远处的点也让玩家知道打哪
	if _indirect != null:
		for shell in _indirect.pending_shells():
			var target: Vector2 = shell["target"]
			draw_circle(target * scale_factor, 4.0, Color(1.0, 0.55, 0.20, 0.95))
			draw_arc(target * scale_factor, 7.0, 0.0, TAU, 16,
					Color(1.0, 0.55, 0.20, 0.75), 1.5)
	# 报点标记（docx 4.11.2：小地图只显示己方与「已报点」的敌方，标记带时效渐隐）
	if _marks != null:
		for mark in _marks.marks:
			var mark_position: Vector2 = mark["position"]
			var color := MarkSystem.type_color(int(mark["type"]))
			var total := maxf(float(mark["duration"]), 0.001)
			var life := clampf(float(mark["time_left"]) / total, 0.0, 1.0)
			color.a = 0.4 + 0.6 * life
			draw_circle(mark_position * scale_factor, 4.0, color)
	draw_rect(Rect2(Vector2.ZERO, Vector2(MINI_SIZE, MINI_SIZE)),
			Color(1.0, 1.0, 1.0, 0.5), false, 2.0)
