extends Node

## 世界装配（2026-09-30 候选 N：从 Main.gd 拆出）
## 只干一件事：把「地形 → 玩家 → 相机 → 占领节点 → 掩体 → 敌人」建出来。
## 建好的东西写回 Main 的公开字段（grid / sight / player / camera / camera_controller /
## terrain_texture / capture_zones），Main 只负责调用与接线。
##
## 约定：所有实体都 add_child 到 Main 上（不是本模块），保持场景树与绘制顺序和拆分前一致。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CoverScript := preload("res://entities/cover/Cover.gd")

var terrain_sprite: Sprite2D = null


## 建场。map_preview_mode 时只建地形 + 预览层（游戏循环一行都不动）
func setup(main, height_image_path: String, map_seed: int, enemy_count: int) -> void:
	main.grid = _load_grid(height_image_path, map_seed)
	main.sight = SightSystem.new(main.grid)
	_build_terrain(main)
	if main.map_preview_mode:
		_build_map_preview(main)
		return
	_build_player(main)
	main.player.apply_role(main.player_role)  # 兵种（3.1）：弹匣 / 备弹 / 伤害倍率
	main.player.sight = main.sight            # 子弹挡掩体（与通视同一套高度口径）
	_build_camera(main)
	main.capture_zones = _build_capture_zones(main)
	_build_covers(main)
	_spawn_enemies(main, enemy_count)


## 地形来源（工具链 A）：填了高度图就优先导入；导入失败或没填 → 退回噪声地形
## 「图即所见」：图里的高度就是地形，不做压平、不做缩放
func _load_grid(height_image_path: String, map_seed: int) -> HeightGrid:
	var path := height_image_path if not height_image_path.is_empty() \
			else GameConfig.MAP_HEIGHT_IMAGE
	if not path.is_empty():
		var loaded := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
		var image := _load_height_image(path)
		if image != null and loaded.fill_from_image(image):
			print("[地形] 已导入自制高度图：%s" % path)
			return loaded
		push_error("[地形] 高度图导入失败，退回噪声地形：%s" % path)
	print("[地形] 噪声地形（seed=%d）" % map_seed)
	return MapGenerator.build_demo_grid(map_seed)


static func _load_height_image(path: String) -> Image:
	var image := Image.load_from_file(path)
	if image == null:
		push_error("[地形] 高度图读取失败：%s" % path)
	return image


## 地形贴图：1 px = 1 m，centered = false 让图片左上角对齐世界原点
## 注意：1000×1000 逐像素上色在纯 GDScript 下要数秒，第一版可接受
func _build_terrain(main) -> void:
	terrain_sprite = Sprite2D.new()
	terrain_sprite.name = "Terrain"
	# debug 构建把起伏大的格子直接标红（合并进地形贴图，省一张叠加纹理、减渲染压力）
	var roughness_threshold := 1.5 if OS.is_debug_build() else -1.0
	terrain_sprite.texture = MapGenerator.build_terrain_texture(main.grid, roughness_threshold)
	terrain_sprite.centered = false
	main.add_child(terrain_sprite)
	# HUD / 战术地图 / 小地图都要这张贴图，交回 Main 中转
	main.terrain_texture = terrain_sprite.texture


## 地图检测模式：只建相机 + 预览层（不动游戏循环的任何一件事）
func _build_map_preview(main) -> void:
	main.camera = Camera2D.new()
	main.camera.name = "PreviewCamera"
	main.camera.position = Vector2(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT) * 0.5
	main.add_child(main.camera)
	var preview := MapPreview.new()
	preview.name = "MapPreview"
	preview.setup(main.grid, main.sight, main.camera)
	main.add_child(preview)
	print("[预览] 地图检测模式：拖动平移 / 轻触落探针扫通视 / R 重扫")


func _build_player(main) -> void:
	main.player = PlayerUnit.new()
	main.player.name = "Player"
	main.player.global_position = MapGenerator.demo_spawn_point()
	main.add_child(main.player)


func _build_camera(main) -> void:
	main.camera = Camera2D.new()
	main.camera.name = "Camera"
	main.camera.global_position = main.player.global_position
	main.add_child(main.camera)
	main.camera.make_current()

	main.camera_controller = AimCameraController.new()
	main.camera_controller.name = "AimCameraController"
	main.add_child(main.camera_controller)
	main.camera_controller.setup(main.player, main.camera, main.sight)


func _spawn_enemies(main, enemy_count: int) -> void:
	var points := MapGenerator.demo_enemy_points()
	for index in mini(enemy_count, points.size()):
		var enemy := Enemy.new()
		enemy.name = "Enemy%d" % index
		enemy.global_position = points[index]
		enemy.setup(main.sight, main.player, main.camera, main.grid)
		main.add_child(enemy)


## 掩体（docx 4.7 第③级）：第一版按 demo 点放沙袋（挡通视也挡子弹，见 Cover.gd）
func _build_covers(main) -> void:
	var points := MapGenerator.demo_cover_points()
	for i in points.size():
		var cover = CoverScript.new()
		cover.name = "Cover%d" % (i + 1)
		cover.global_position = points[i]
		main.add_child(cover)


## 白旗点：第一版用 DEMO_NODES 前 3 个节点（全占即胜，验证 L5/L6 循环）
func _build_capture_zones(main) -> Array:
	var zones: Array = []
	for i in 3:
		var zone := CaptureZone.new()
		zone.name = "Zone%d" % (i + 1)
		zone.global_position = MapGenerator.DEMO_NODES[i]
		zone.setup(main.player)
		main.add_child(zone)
		zones.append(zone)
	return zones
