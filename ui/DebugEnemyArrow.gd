class_name DebugEnemyArrow
extends Node2D

## 开发阶段专用：实时黄色箭头指向最近的存活敌人（带距离，米）
## 只在 debug 构建显示（编辑器里按 F5 运行就是 debug），导出 release 后自动隐藏
## 这是"地图太大找不到敌人"的开发辅助，不要带进正式玩法
##
## C3（施工单 §7）：`_nearest_alive_enemy` 原先每帧 `get_tree().get_nodes_in_group("enemy")` ——
## 每次调用都**新分配一个数组**。改走**帧级缓存**（复用 Ally 里既有的那份），**不降频率**：
## 箭头方向随玩家与相机每帧变化，降到 5~10 Hz 会明显卡顿。本项只影响 debug 包（显隐门在 `_ready`）。
const AllyScript := preload("res://entities/ally/Ally.gd")

@export var enabled := true
@export var arrow_radius := 140.0  # px，箭头距玩家屏幕位置的距离

var _camera: Camera2D = null
var _player: Node2D = null
var _arrow: Sprite2D = null
var _distance_label: Label = null


func setup(camera: Camera2D, player: Node2D) -> void:
	_camera = camera
	_player = player


func _ready() -> void:
	visible = enabled and OS.is_debug_build()
	_arrow = Sprite2D.new()
	_arrow.texture = _make_arrow_texture()
	add_child(_arrow)
	_distance_label = Label.new()
	_distance_label.add_theme_color_override("font_color", Color("ffd75a"))
	add_child(_distance_label)


func _process(_delta: float) -> void:
	if not visible or _camera == null or _player == null:
		return
	var nearest := _nearest_alive_enemy()
	if nearest == null:
		_arrow.visible = false
		_distance_label.visible = false
		return
	_arrow.visible = true
	_distance_label.visible = true

	# 世界坐标 → 屏幕坐标（zoom 即 px/m，相机位置对应屏幕中心）
	var zoom := maxf(_camera.zoom.x, 0.001)
	var screen_center := Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) * 0.5
	var player_screen := (_player.global_position - _camera.global_position) * zoom + screen_center
	var enemy_screen := (nearest.global_position - _camera.global_position) * zoom + screen_center
	var direction := enemy_screen - player_screen
	if direction.length() < 1.0:
		return
	direction = direction.normalized()

	position = player_screen + direction * arrow_radius
	_arrow.rotation = direction.angle()
	var distance := _player.global_position.distance_to(nearest.global_position)
	_distance_label.text = "%d m" % int(distance)
	_distance_label.position = direction * 34.0 - Vector2(16.0, 8.0)


func _nearest_alive_enemy() -> Node2D:
	var nearest: Node2D = null
	var best_distance := INF
	# C3：帧级缓存（同一物理帧内共用一份），只读遍历，不要改返回的数组
	for node in AllyScript._cached_enemies():
		var enemy := node as Node2D
		if enemy == null or enemy.is_queued_for_deletion():
			continue
		var distance := _player.global_position.distance_to(enemy.global_position)
		if distance < best_distance:
			best_distance = distance
			nearest = enemy
	return nearest


## 程序生成的三角形贴图（尖端朝右，配合 rotation 指向敌人）
static func _make_arrow_texture() -> ImageTexture:
	var texture_size := 36
	var image := Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var color := Color("ffd75a")
	var mid := float(texture_size) * 0.5
	var tip_x := float(texture_size - 1)
	for y in texture_size:
		for x in texture_size:
			var dx := tip_x - float(x)
			var dy := absf(float(y) - mid)
			if dx >= 0.0 and dy <= dx * 0.55:
				image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(image)
