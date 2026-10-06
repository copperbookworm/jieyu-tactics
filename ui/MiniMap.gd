class_name MiniMap
extends Node2D

## 小地图（CS:GO 风格角落缩略图）：地形缩略 + 节点 + 玩家位置
## 挂在 HUD CanvasLayer 下（屏幕坐标）；世界 1000 m 映射到 150 px
## 节点圆点颜色随占领状态：灰=未占、白=争夺中、蓝=已占；黄点=玩家
##
## 【2026-10-01 ④】补世界目标图层：己方补给车 / 侧翼通路 / 敌方 FOB（暴露后）。
## 取数统一走 MapLayerSource（与战术地图同一份口径，别在两张图上各写一套）。

const MapLayerSourceScript := preload("res://ui/MapLayerSource.gd")
## C1（施工单 §7）：敌组帧级缓存 —— 复用 Ally 里既有的那一份（`static _cached_enemies()`，
## 口径是"物理帧号变了才重建"），不在小地图里另造一套。Ally 刻意无 class_name，故 preload 成常量。
const AllyScript := preload("res://entities/ally/Ally.gd")

const MINI_SIZE := 150.0
const MAP_SIZE := 1000.0
## C1（施工单 §7）：重绘节流到 **10 Hz**（施工单授权的 5~10 Hz 档）。
## 为什么必须节流：`_draw` 自己要画 20 个敌人光点 + 玩家点 + 占领圈 + 间瞄落点 + 报点标记 +
## 世界图层（通路/补给车/FOB），M3 消融实测"整块关掉小地图"值 **+228.8 fps**（≈0.34 ms/帧）——
## 这笔钱几乎全在 `_draw` 里，而**不是**组查询（实测只省 0.33 µs/次）。
## 为什么不用"占领变化才重绘"（施工单的另一个选项）：同一个 `_draw` 里还画着每帧都在动的东西
## （敌人光点、补给车与其目标线、报点渐隐、间瞄落点），只在占领变化时重绘会让它们**冻住**。
## 代价（写在明处）：这些动画元素现在是 10 Hz 步进而不是 60 Hz。若观感不可接受，调大下面这个常数
## （0.05 = 20 Hz）即可，开销按比例回升。
const REDRAW_INTERVAL := 0.1

var _redraw_left := 0.0

var _terrain_texture: ImageTexture = null
var _player: Node2D = null
var _zones: Array = []
var _marks: MarkSystem = null
var _indirect = null   # IndirectFire（动态类型：该模块刻意无 class_name，见其文件头）
var _main = null       # Main（鸭子类型）：世界目标图层从这里取


func setup(terrain_texture: ImageTexture, player: Node2D, zones: Array,
		marks: MarkSystem = null, main_node = null) -> void:
	_terrain_texture = terrain_texture
	_player = player
	_zones = zones
	_marks = marks
	_main = main_node


## 间瞄落点也要在小地图上看得见——否则选了远处的点，玩家完全没有反馈
func set_indirect(fire) -> void:
	_indirect = fire


func _ready() -> void:
	# 右上角，避开开火按钮（右下）与准心（屏心）
	position = Vector2(GameConfig.VIEWPORT_WIDTH - MINI_SIZE - 8.0, 8.0)
	var bg := Sprite2D.new()
	bg.texture = _mini_texture()
	bg.centered = false
	add_child(bg)


## 小地图专用的**预缩小**贴图（2026-10-05 性能修复）。
## 原来直接把 1000×1000 的全图按 150/1000 缩放每帧绘制 —— 没有 mipmap，6.7× 缩小的采样
## 在移动 GPU 上是典型的 cache 抖动源（notes f057 记的就是这一条）。
## 一次性缩到 150×150 存成独立贴图，之后每帧只是 1:1 绘制。
func _mini_texture() -> ImageTexture:
	if _terrain_texture == null:
		return null
	var source := _terrain_texture.get_image()
	if source == null:
		return null
	var small := source.duplicate() as Image
	small.resize(int(MINI_SIZE), int(MINI_SIZE), Image.INTERPOLATE_BILINEAR)
	return ImageTexture.create_from_image(small)


func _process(delta: float) -> void:
	# C1（施工单 §7）：节流到 REDRAW_INTERVAL（10 Hz）。`queue_redraw()` 本身很便宜，
	# 省的是**引擎随后真的跑一遍 `_draw`** 的次数（60 Hz → 10 Hz = 少画 5/6）。
	# 组查询那部分另走帧级缓存（见 `_draw`）—— 它只值 0.33 µs/次，不是本项的大头。
	_redraw_left -= delta
	if _redraw_left > 0.0:
		return
	_redraw_left = REDRAW_INTERVAL
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
		# C1：走帧级缓存，消掉每次 `_draw` 的组查询与数组分配。**只读遍历**（返回的是共享引用，不要改它）。
		for enemy in AllyScript._cached_enemies():
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
	_draw_world_layer(scale_factor)
	draw_rect(Rect2(Vector2.ZERO, Vector2(MINI_SIZE, MINI_SIZE)),
			Color(1.0, 1.0, 1.0, 0.5), false, 2.0)


## 世界目标图层（2026-10-01 ④）：侧翼通路（地形要素，常显）→ 补给车（己方全显）→ 敌方 FOB（暴露后）
## 画在标记层之上：报点是「情报」，这些是「已知实体」，压在上面更醒目
func _draw_world_layer(scale_factor: float) -> void:
	if _main == null:
		return
	var lane = MapLayerSourceScript.lane(_main)
	if lane != null:
		var lane_color := Color(0.95, 0.75, 0.30, 0.9) if lane.active \
				else Color(0.75, 0.70, 0.45, 0.4)
		var corners := MapLayerSourceScript.lane_edges(lane.entry_position,
				lane.exit_position, lane.half_width)
		if corners.size() == 4:
			draw_line(corners[0] * scale_factor, corners[2] * scale_factor, lane_color, 2.0)
			draw_line(corners[1] * scale_factor, corners[3] * scale_factor, lane_color, 2.0)
	var convoy = MapLayerSourceScript.convoy(_main)
	if convoy != null:
		var from: Vector2 = convoy.global_position
		draw_line(from * scale_factor, convoy.target_position * scale_factor,
				Color(0.55, 0.85, 0.55, 0.45), 1.0)
		var box := Rect2(from * scale_factor - Vector2(3.0, 3.0), Vector2(6.0, 6.0))
		draw_rect(box, Color(0.45, 0.90, 0.55, 0.95))
		draw_rect(box, Color(0.9, 1.0, 0.9, 0.9), false, 1.0)
	for fob in MapLayerSourceScript.visible_fobs(get_tree()):
		var fob_pos: Vector2 = fob.global_position * scale_factor
		var fob_box := Rect2(fob_pos - Vector2(4.0, 3.0), Vector2(8.0, 6.0))
		if bool(fob.destroyed):
			draw_rect(fob_box, Color(0.45, 0.40, 0.36, 0.7))
		else:
			draw_rect(fob_box, Color(0.90, 0.28, 0.24, 0.95))
			draw_rect(fob_box, Color(1.0, 0.92, 0.82, 0.95), false, 1.0)
