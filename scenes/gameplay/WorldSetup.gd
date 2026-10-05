extends Node

## 世界装配（2026-09-30 候选 N：从 Main.gd 拆出）
## 只干一件事：把「地形 → 玩家 → 相机 → 占领节点 → 掩体 → 敌人」建出来。
## 建好的东西写回 Main 的公开字段（grid / sight / player / camera / camera_controller /
## terrain_texture / capture_zones），Main 只负责调用与接线。
##
## 约定：所有实体都 add_child 到 Main 上（不是本模块），保持场景树与绘制顺序和拆分前一致。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CoverScript := preload("res://entities/cover/Cover.gd")
## 玩家的队友（3 名强力版，候选 Q · 使用者 2026-10-02）
const AllyScript := preload("res://entities/ally/Ally.gd")
## 敌方 FOB（候选 L2）：同样无 class_name，preload 引用
const FobScript := preload("res://entities/fob/Fob.gd")
## 环境互动区（docx 4.17）：同样无 class_name，preload 引用
const TerrainZoneScript := preload("res://entities/zone/TerrainZone.gd")
## 掩体被摧毁后落的贴地残痕（4.17 破坏互动：留残痕 + 小减速，不影响通视）
const RubblePatchScript := preload("res://entities/zone/RubblePatch.gd")
## 本局模式规则（人数口径：docx 5.8）—— 队友数从这里取
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
## 编成（docx 4.10.8 / 5.8）：组 4 人 · 一小队至少 2 组
const OrganizationScript := preload("res://systems/match/Organization.gd")
## 编成命令层（docx 4.10.8）：主线下发给小队长、小队长按模板派发小队内子任务
const SquadOrdersScript := preload("res://systems/match/SquadOrders.gd")
## 出生点挑选（2026-10-05）：从地图出生区里现挑一个「站得住」的点（纯逻辑，可单测）
const SpawnPickerScript := preload("res://systems/terrain/SpawnPicker.gd")
## 敌人驻守部署（2026-10-05 第六十三版 · 拍板 B）：怎么把敌人分到 5 个节点 + 东侧预备队（纯算术）
const EnemyDeploymentScript := preload("res://systems/match/EnemyDeployment.gd")

var terrain_sprite: Sprite2D = null
## 本局友好方编成（组 / 小队 / 队长）—— 由 _spawn_allies 建好后写回，供 HUD / 任务链读
var organization: Dictionary = {}
## 本次装配真的建出了多少单位（装配事实，不受战斗结果影响：单位会被打死并 free 掉，
## 任务事件还会往 enemy 组里塞穿插兵 Infiltrator# ⇒ 拿「组里还剩几个」当装配断言会假红，2026-10-03 踩过）
## 本局组任务（编成命令层派发的结果）—— 供 HUD / 参谋 / 队友 AI 读
var squad_orders: Dictionary = {}
var spawned_enemy_count := 0
var spawned_ally_count := 0
## 掩体被摧毁后落的残痕（4.17）：它们与泥泞 / 雪地共用一条移速链路，所以要并进 player.zones
var _rubble_zones: Array = []
## 本模块持有 Main 引用（只为「拍板 B 的预备队支援」这一个信号回调 —— 其余函数仍按参数传 main）
var main_ref = null
## 地图 zones.json 的缓存副本（出生锚点 / 白旗点 / 敌人驻守三处共用一次解析）
var _map_zones: Dictionary = {}
## 东侧出生区的预备队（拍板 B）：节点被我方占下后，这些人向前支援下一个节点
var reserve_enemies: Array = []


## 建场。map_preview_mode 时只建地形 + 预览层（游戏循环一行都不动）
func setup(main, height_image_path: String, map_seed: int, enemy_count: int) -> void:
	main.grid = _load_grid(height_image_path, map_seed)
	main.sight = SightSystem.new(main.grid)
	_build_terrain(main)
	if main.map_preview_mode:
		_build_map_preview(main)
		return
	main_ref = main
	_map_zones = _load_map_zones(main)
	# 地图数据只解析一次：出生点挑选 / 掩体 / 载具落点共用同一份（occluders.json 有 60 KB+）
	main.map_occluders = _load_occluders(main)
	# 出生锚点（2026-10-05）：读地图出生区现挑一个站得住的点，玩家 / 友军载具 / 补给车共用
	main.spawn_anchor = _spawn_anchor(main)
	_build_player(main)
	main.player.apply_role(main.player_role)  # 兵种（3.1）：弹匣 / 备弹 / 伤害倍率
	main.player.sight = main.sight            # 子弹挡掩体（与通视同一套高度口径）
	_build_camera(main)
	main.capture_zones = _build_capture_zones(main)
	_build_covers(main)
	_build_terrain_zones(main)   # 4.17：泥泞 / 雪地减速、草丛隐蔽（要在玩家之后、敌人之前）
	_build_enemy_fob(main)
	_spawn_enemies(main, enemy_count)
	# 拍板 B 的后半句：节点被我方占下 → 东侧预备队向前支援（见 _on_flag_state_changed）
	if not EventBus.flag_state_changed.is_connected(_on_flag_state_changed):
		EventBus.flag_state_changed.connect(_on_flag_state_changed)
	# 队友（2026-10-02）：3 名强力队友进 friendly 组。集成冒烟已订正过「敌人 2 个」那条过期断言 ——
	# 队友会先击毙开局步兵，事件驱动的穿插兵也会进 enemy 组，所以那条不再用等值。
	_spawn_allies(main, _ally_target())
	# 编成命令层（docx 4.10.8）：主线下发给小队长，小队长按模板把小队内子任务派到每个组。
	# **必须放在 _spawn_allies 之后** —— 编成是在那里建的，放前面会派发出 0 条任务（踩过）。
	squad_orders = SquadOrdersScript.issue(organization, main.capture_zones.size(), 0)
	_apply_squad_orders(main)


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


## 高度图读取（工具链 A）。
## 【2026-10-01 候选 T ①】优先走「导入后的资源」：导出后 PNG 会被打成 .ctex 封进包里，
## 这时 Image.load_from_file("res://…png") 读不到原图，Godot 会 WARNING「this will not work on export」。
## 顺序：① ResourceLoader 取 Texture2D → get_image()（编辑器与导出包都走这条路）
##       ② 退回 Image.load_from_file（绝对路径 / 没进导入管线的裸文件 / 刚放进项目还没导入的图）
static func _load_height_image(path: String) -> Image:
	if ResourceLoader.exists(path, "Texture2D"):
		var texture := ResourceLoader.load(path, "Texture2D") as Texture2D
		if texture != null:
			var imported := texture.get_image()
			if imported != null and imported.get_width() > 0:
				return imported
			push_warning("[地形] 高度图资源没有像素数据，退回直接读文件：%s" % path)
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
	# 出生点来自地图出生区（挑不出时才由 _spawn_anchor 退回 demo_spawn_point）—— 见该函数注释
	main.player.global_position = main.spawn_anchor
	main.player.respawn_point = main.player.global_position   # 候选 Q：重生回这个点
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


## 玩家的队友（3 名，强力版）：进 friendly 组 —— MatchFlow 的重生预算＝进攻方人数×2 会把他们算进去
## 队友数：模式定义了就用模式的（PVP 20 v 20 要 19 名 / PVEVP 4P 要 3 名），
## 没有模式（单独跑 Main.tscn 的测试、兵棋模式）就退回 GameConfig.ALLY_SQUAD_SIZE = 3
## —— 这条回落保证「单跑 Main.tscn」的集成冒烟与几何门禁一行都不用改。
## 把组任务发给每个队友：组 0/1/2… 各自去自己那个节点（docx 4.10.8 的执行层）。
## 只有「组任务」存在、且该组有坐标时才置 order_active —— 否则队友保持跟随玩家（旧行为）。
func _apply_squad_orders(main) -> void:
	var positions: Array = []
	for zone in main.capture_zones:
		if zone is Node2D:
			positions.append((zone as Node2D).global_position)
	var targets := SquadOrdersScript.order_targets(squad_orders, positions)
	var ord: Dictionary = squad_orders.get("orders", {})
	for node in get_tree().get_nodes_in_group("friendly"):
		var ally = node
		if ally == null or not ("group_index" in ally):
			continue
		var g := int(ally.group_index)
		if not targets.has(g):
			continue
		ally.order_target = targets[g]
		ally.order_active = true
		var entry: Dictionary = ord.get(g, {})
		ally.order_text = String(entry.get("text", ""))


func _ally_target() -> int:
	var n := MatchRulesScript.ally_count()
	return n if n > 0 else GameConfig.ALLY_SQUAD_SIZE


func _spawn_allies(main, count: int) -> void:
	# 编成（docx 4.10.8 / 5.8）：玩家是名册第 0 位，队友从 1 起 —— 把每人的组 / 小队 / 组长身份发下去
	organization = OrganizationScript.of_friendly_total(1 + count)
	spawned_ally_count = count
	var member_of: Dictionary = organization["member_of"]
	for i in count:
		var ally := AllyScript.new()
		ally.name = "Ally%d" % i
		ally.setup(main, main.player, main.sight, main.grid, i)
		var m: Dictionary = member_of.get(i + 1, {})
		ally.group_index = int(m.get("group", -1))
		ally.squad_index = int(m.get("squad", -1))
		ally.is_group_leader = bool(m.get("is_group_leader", false))
		ally.is_squad_leader = bool(m.get("is_squad_leader", false))
		main.add_child(ally)


## 敌人出生：demo 只给了 2 个点位，而人数口径（docx 5.8）要 20（PVP）/ 30（PVEVP）。
## 点位用完之后**循环复用**，并沿圆周散开，免得十几个敌人叠成一堆（叠在一起会让性能采样失真：
## 通视 DDA 与命中判定都变成近似零距离的退化情况）。
## 前 points.size() 个与旧实现逐字一致（位置、命名都不变）⇒ 默认 2 敌的场景回归面为零。
func _spawn_enemies(main, enemy_count: int) -> void:
	var slots := _enemy_slots(main, enemy_count)
	if slots.is_empty():
		return
	spawned_enemy_count = enemy_count
	reserve_enemies.clear()
	for index in enemy_count:
		var slot: Dictionary = slots[index % slots.size()]
		var enemy := Enemy.new()
		enemy.name = "Enemy%d" % index
		enemy.global_position = slot["position"]
		enemy.setup(main.sight, main.player, main.camera, main.grid)
		if bool(slot.get("reserve", false)):
			reserve_enemies.append(enemy)
		main.add_child(enemy)


## 敌人落点（2026-10-05 第六十三版 · 使用者拍板 **B**：按 RAAS 节点 + 东侧出生区分组驻守）。
## 返回**恰好 enemy_count 个** {position, reserve}；地图没给节点 / 没有东侧出生区时退回老口径
## （出生锚点 + demo 相对偏移，保住退化路径）。每个点都过一次「原地找平地」微调。
func _enemy_slots(main, enemy_count: int) -> Array:
	var nodes := _zone_node_positions(_map_zones)
	var reserve_center := _spawn_area_center(main, _map_zones, "east")
	if nodes.is_empty() or reserve_center == Vector2.INF:
		return _legacy_enemy_slots(main, enemy_count)
	var plan := EnemyDeploymentScript.plan(nodes.size(), enemy_count)
	var slots: Array = []
	for node_index in nodes.size():
		for slot in int(plan["per_node"][node_index]):
			var ideal: Vector2 = nodes[node_index] \
					+ EnemyDeploymentScript.node_slot_offset(slot)
			slots.append({"position": _nudged(main, ideal), "reserve": false})
	for slot in int(plan["reserve"]):
		var ideal: Vector2 = reserve_center + EnemyDeploymentScript.reserve_slot_offset(slot)
		slots.append({"position": _nudged(main, ideal), "reserve": true})
	return slots


## 老口径（退化路径）：出生锚点 + demo 相对偏移；点位数不够时循环复用 + 圆周散开
func _legacy_enemy_slots(main, enemy_count: int) -> Array:
	var points := MapGenerator.demo_enemy_points()
	if points.is_empty():
		return []
	var slots: Array = []
	for index in enemy_count:
		slots.append({"position": _enemy_spawn_position(points, index), "reserve": false})
	return slots


## 落点微调：正式图上节点圆环 / 出生区里都可能正好是陡坡或楼
func _nudged(main, ideal: Vector2) -> Vector2:
	return SpawnPickerScript.nudge(main.grid, ideal,
			SpawnPickerScript.NUDGE_RADIUS, main.map_occluders)


## 出生区多边形的中心（东侧预备队集结用）；没有该 side 时返回 Vector2.INF
func _spawn_area_center(main, zones: Dictionary, side: String) -> Vector2:
	for area_v in zones.get("spawn_areas", []):
		if not (area_v is Dictionary):
			continue
		var area: Dictionary = area_v
		if String(area.get("side", "")) != side:
			continue
		var polygon: Array = area.get("polygon", [])
		if polygon.size() < 3:
			return Vector2.INF
		var sum := Vector2.ZERO
		for point_v in polygon:
			sum += JieyuMapGen.vec2(point_v)
		return _nudged(main, sum / float(polygon.size()))
	return Vector2.INF


## 拍板 B 的后半句：我方占下一个节点 → 东侧预备队「向前支援」下一个节点。
## 口令走 Enemy.set_move_target()（换 _patrol_target，到点后它自己回到原地巡逻）——
## 不新增 AI 状态机，也不给敌人加寻路：第一版的战场很小，直线过去就够。
func _on_flag_state_changed(node_name: Variant, state: int) -> void:
	if state != 1:   # CaptureZone.State.BLUE（不引用 CaptureZone，免得与它的 EventBus 依赖成环）
		return
	if main_ref == null or reserve_enemies.is_empty():
		return
	var nodes := _zone_node_positions(_map_zones)
	if nodes.is_empty():
		return
	var index := _capture_zone_index(node_name)
	if index < 0:
		return
	var target: Vector2 = nodes[mini(index + 1, nodes.size() - 1)]
	var moved := 0
	for enemy_v in reserve_enemies:
		if is_instance_valid(enemy_v) and not (enemy_v as Node).is_queued_for_deletion():
			enemy_v.set_move_target(target)
			moved += 1
	if moved > 0:
		print("[敌人] 预备队 %d 人向前支援 → 节点 %d %s" % [moved, mini(index + 1, nodes.size() - 1) + 1,
				str(target)])


func _capture_zone_index(node_name: Variant) -> int:
	if main_ref == null:
		return -1
	for i in (main_ref.capture_zones as Array).size():
		var zone = main_ref.capture_zones[i]
		if is_instance_valid(zone) and String((zone as Node).name) == String(node_name):
			return i
	return -1


func _exit_tree() -> void:
	if EventBus.flag_state_changed.is_connected(_on_flag_state_changed):
		EventBus.flag_state_changed.disconnect(_on_flag_state_changed)


## 出生锚点（2026-10-05）：从地图 spawn_areas（west）里现挑一个「站得住」的点。
## 为什么不取质心：实测正式图 west 出生区的质心是 60.5° 的坡（demo 出生点也有 45.8°）——
## 地图生成器只压平节点核心、**不压平出生区**，所以出生点必须现挑（判据见 SpawnPicker.gd）。
## 挑不出（没地图 / 没 spawn_areas / 全区都陡）就退回 demo_spawn_point()。
func _spawn_anchor(main) -> Vector2:
	var zones := _load_map_zones(main)
	var polygon: Array = []
	for area_v in zones.get("spawn_areas", []):
		if not (area_v is Dictionary):
			continue
		var area: Dictionary = area_v
		if String(area.get("side", "")) == "west":
			polygon = area.get("polygon", [])
			break
	if polygon.size() < 3:
		print("[地图] 没有 west spawn_areas → 出生点退回 demo 摆位")
		return MapGenerator.demo_spawn_point()
	var picked := SpawnPickerScript.pick(main.grid, polygon, _zone_node_positions(zones),
			main.map_occluders)
	if picked == Vector2.INF:
		push_warning("[地图] west 出生区里挑不出可用点（全区陡 / 全被掩体压住）→ 退回 demo 出生点")
		return MapGenerator.demo_spawn_point()
	print("[地图] 出生点取自 west 出生区：%s（双尺度坡度 ≤ %.0f°，离最近节点 ≥ %.0f m）"
			% [str(picked), GameConfig.MAX_SLOPE_DEG, SpawnPickerScript.NODE_DIST_TIERS[0]])
	return picked


## zones.json 里的 raas_nodes 坐标（出生点挑选要避开占领点 —— 12.8.4：续航区在点外 100~200 m）
func _zone_node_positions(zones: Dictionary) -> Array:
	var positions: Array = []
	for node_v in zones.get("raas_nodes", []):
		if node_v is Dictionary:
			positions.append(JieyuMapGen.vec2((node_v as Dictionary).get("pos", [0, 0])))
	return positions


## 第 index 个敌人的出生点：前 N 个用 demo 点（与旧实现一致），之后循环复用 + 圆周散开
static func _enemy_spawn_position(points: Array, index: int) -> Vector2:
	if index < points.size():
		return points[index]
	var ring := index - points.size()
	var base: Vector2 = points[ring % points.size()]
	var lap := ring / points.size()
	var angle := TAU * float(ring % 12) / 12.0 + float(lap) * 0.37
	return base + Vector2(cos(angle), sin(angle)) * (14.0 + 9.0 * float(lap))


## 掩体（docx 4.7 第③级）：两套来源，优先用**地图数据**。
##
## ① 地图目录里有 occluders.json（12.8.1 / 12.8.7 口径）⇒ 按它建：
##    每项有 polygon / h_low / h_top / destructible / hp / damage_profiles，
##    这里把它们折进第一版的 Cover（轴对齐矩形 + 顶高 + 耐久的近似），
##    并把「摧毁」信号接到残痕（4.17 破坏互动：留贴地残痕 + 小减速，不影响通视）。
## ② 没有地图数据（例如没设 map_id、或跑的是旧图）⇒ 退回 demo 摆位，保证退化路径仍然可玩。
##    2026-10-04 第五十九版起**默认地图就是正式图**，所以正常开局走的是 ①，掩体数量以地图数据为准
##    （集成冒烟不再写死「20 个沙袋」，改成数地图 occluders.json 的条目数）。
func _build_covers(main) -> void:
	var entries: Array = main.map_occluders
	if entries.is_empty():
		var points := MapGenerator.demo_cover_points()
		for i in points.size():
			var cover = CoverScript.new()
			cover.name = "Cover%d" % (i + 1)
			cover.global_position = points[i]
			main.add_child(cover)
		return
	var rubble_zones: Array = []
	for i in entries.size():
		var entry: Dictionary = entries[i]
		var cover = CoverScript.new()
		cover.name = "Cover%d" % (i + 1)
		cover.global_position = _polygon_center(entry.get("polygon", []))
		var polygon: Array = entry.get("polygon", [])
		cover.half_size = _polygon_half_size(polygon)
		cover.height = float(entry.get("h_top", GameConfig.COVER_SANDBAG_HEIGHT))
		cover.max_hp = float(entry.get("hp", GameConfig.COVER_HP))
		# 开口（窗 / 门洞，2026-10-03 拍板①）：只有打中开口才伤得到建筑里面。
		# 地图数据里是**本地坐标** + **相对地面**的高度区间，Cover.pierces_at() 用同一套口径。
		cover.openings = _normalized_openings(entry.get("openings", []), cover.height)
		# 建筑 / 掩体是否「吃普通子弹」：false ⇒ 弹种伤害只走 structure_damage 那一档
		cover.absorbs_bullets = bool(entry.get("absorbs_bullets", true))
		var destructible := bool(entry.get("destructible", true))
		main.add_child(cover)
		# 不可摧毁的遮挡体（例如按老口径标的建筑）退出可破坏链路：
		# 耐久开到很大 + 不进残痕接线，语义上就是「打不烂的实体墙」
		if not destructible:
			cover.max_hp = INF
			cover.hp = INF
			continue
		rubble_zones.append(cover)
		_connect_rubble(main, cover)


## 开口归一化：把 [{type, center:[x,y], half_size:[x,y], h_low, h_top}] 转成
## Cover.openings 要的 [{type, center:Vector2, half_size:Vector2, h_low, h_top}]。
## h_top = 0 是地图数据里的约定值「到掩体顶」，这里替换成实际顶高，
## 免得后面每个判据都要再判一次「0 是到顶还是真的 0」。
func _normalized_openings(raw: Variant, cover_height: float) -> Array:
	var result: Array = []
	if not (raw is Array):
		return result
	for opening_v in (raw as Array):
		if not (opening_v is Dictionary):
			continue
		var opening: Dictionary = opening_v
		var low := float(opening.get("h_low", 0.0))
		var top := float(opening.get("h_top", 0.0))
		result.append({
			"type": str(opening.get("type", "window")),
			"center": _to_vec2(opening.get("center", Vector2.ZERO)),
			"half_size": _to_vec2(opening.get("half_size", Vector2.ZERO)),
			"h_low": low,
			"h_top": (cover_height if top <= 0.0 else top),
		})
	return result


## [x, y] / {"x","y"} / Vector2 → Vector2（JSON 里坐标是数组）
static func _to_vec2(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Array and (value as Array).size() >= 2:
		return Vector2(float((value as Array)[0]), float((value as Array)[1]))
	if value is Dictionary:
		var d: Dictionary = value
		return Vector2(float(d.get("x", 0.0)), float(d.get("y", 0.0)))
	return Vector2.ZERO


## 地图目录（res://assets/maps/<id>/）里的 occluders.json → 条目数组；读不到就是空数组
func _load_occluders(main) -> Array:
	var map_id := _map_id_from_path(str(main.map_height_image) if "map_height_image" in main else "")
	if map_id.is_empty():
		return []
	var path := "res://assets/maps/%s/occluders.json" % map_id
	if not FileAccess.file_exists(path):
		print("[地图] %s 没有 occluders.json → 掩体退回 demo 摆位" % map_id)
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[地图] occluders.json 打不开：%s" % path)
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Array):
		push_error("[地图] occluders.json 顶层不是数组：%s" % path)
		return []
	print("[地图] 已导入地图掩体：%s（%d 个）" % [path, (parsed as Array).size()])
	return parsed


## 从高度图路径反推地图目录名：res://assets/maps/<id>/heightmap.png 或 .../<id>_height.png
static func _map_id_from_path(height_image_path: String) -> String:
	if height_image_path.is_empty():
		return ""
	var directory := height_image_path.get_base_dir()
	if directory.get_file() != "maps" and directory.begins_with("res://assets/maps/"):
		return directory.get_file()
	var file_name := height_image_path.get_file()
	if file_name.ends_with("_height.png"):
		return file_name.trim_suffix("_height.png")
	return ""


## 矩形近似：取多边形包围盒的半宽/半高（第一版 Cover 只支持矩形，任意多边形留待后续）
static func _polygon_half_size(polygon: Array) -> Vector2:
	if polygon.size() < 3:
		return Vector2(GameConfig.COVER_SANDBAG_HALF_X, GameConfig.COVER_SANDBAG_HALF_Y)
	var min_point := Vector2(INF, INF)
	var max_point := Vector2(-INF, -INF)
	for point_v in polygon:
		var point := JieyuMapGen.vec2(point_v)
		min_point = Vector2(minf(min_point.x, point.x), minf(min_point.y, point.y))
		max_point = Vector2(maxf(max_point.x, point.x), maxf(max_point.y, point.y))
	var half := (max_point - min_point) * 0.5
	return Vector2(maxf(half.x, 0.5), maxf(half.y, 0.5))


static func _polygon_center(polygon: Array) -> Vector2:
	if polygon.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for point_v in polygon:
		sum += JieyuMapGen.vec2(point_v)
	return sum / float(polygon.size())


## 掩体被摧毁 → 在原位落一块贴地残痕（不挡通视、只小减速）
func _connect_rubble(main, cover) -> void:
	cover.destroyed_now.connect(func(node) -> void:
		_spawn_rubble(main, node.global_position,
				maxf(node.half_size.x, node.half_size.y) * GameConfig.RUBBLE_RADIUS_SCALE))


func _spawn_rubble(main, at: Vector2, radius: float) -> void:
	var patch = RubblePatchScript.new()
	patch.name = "Rubble%d" % (_rubble_zones.size() + 1)
	patch.global_position = at
	main.add_child(patch)
	patch.setup(radius, GameConfig.RUBBLE_LIFETIME)
	# 残痕与泥泞 / 雪地共用一条移速链路（TerrainZones.speed_scale_at 只认
	# covers() / speed_scale() 两个方法），所以玩家侧一行都不用改
	_rubble_zones.append(patch)
	if main.player != null and main.player.zones != null:
		main.player.zones.append(patch)


## 环境互动区（docx 4.17）：同样两套来源 —— 地图目录里有内容层图就用它，否则退回 demo 三片。
## 掩体被摧毁后落的残痕也并进 zones（同为「脚下区域」，共用一条移速链路）。
func _build_terrain_zones(main) -> void:
	var zones: Array = []
	for entry in _terrain_zone_entries(main):
		var zone = TerrainZoneScript.new()
		zone.name = "TerrainZone%d" % (zones.size() + 1)
		zone.global_position = entry["position"]
		main.add_child(zone)
		zone.setup(int(entry["kind"]), float(entry["radius"]))
		zones.append(zone)
	zones.append_array(_rubble_zones)
	if main.player != null:
		main.player.zones = zones


## 内容层来源：地图目录的 material.png（4.17 拍板的方案 B，单通道 id 图）优先；
## 没有就退回 MapGenerator.demo_terrain_zones() 的三片摆位。
## 方案 A（content.png 按行序排纯色区域）留给后续：它要逐行检测同色像素，与 B 二选一即可。
func _terrain_zone_entries(main) -> Array:
	var map_id := _map_id_from_path(str(main.map_height_image) if "map_height_image" in main else "")
	if map_id.is_empty():
		return MapGenerator.demo_terrain_zones()
	var path := "res://assets/maps/%s/material.png" % map_id
	if not FileAccess.file_exists(path) and not ResourceLoader.exists(path, "Texture2D"):
		return MapGenerator.demo_terrain_zones()
	# 与高度图同一条纪律（候选 T ①）：优先走「导入后的资源」。
	# 导出后 PNG 会被打成 .ctex 封进包里，Image.load_from_file(res://…) 读不到原图
	# （Godot 还会为此打 WARNING「this will not work on export」）。
	var image: Image = null
	if ResourceLoader.exists(path, "Texture2D"):
		var texture := ResourceLoader.load(path, "Texture2D") as Texture2D
		if texture != null:
			image = texture.get_image()
	if image == null and FileAccess.file_exists(path):
		image = Image.load_from_file(ProjectSettings.globalize_path(path))
	if image == null:
		push_warning("[地图] material.png 读不到，退回 demo 地形区：%s" % path)
		return MapGenerator.demo_terrain_zones()
	var entries := MapGenerator.terrain_zones_from_material_image(image)
	if entries.is_empty():
		print("[地图] material.png 没有任何内容层像素，退回 demo 地形区")
		return MapGenerator.demo_terrain_zones()
	print("[地图] 已导入内容层：%s（%d 片区域）" % [path, entries.size()])
	return entries


## 敌方 FOB（候选 L2，docx 4.10.11 T-S2）：一座敌方后方工事。
## 位置来自 MapGenerator.demo_enemy_fob_point()（单一数据源，地图预览共用）。
## 「必须先报点暴露才发得出摧毁任务」这条在 QuestSystem 里判，本函数只负责把它摆到世界上。
func _build_enemy_fob(main) -> void:
	var fob = FobScript.new()
	fob.name = "EnemyFob"
	fob.global_position = MapGenerator.demo_enemy_fob_point()
	main.add_child(fob)


## 白旗点：第一版 3 个（三节点全占即胜，验证 L5/L6 循环）。
## 位置**优先取地图自己的推进链**（zones.json 的 raas_nodes），地图没给才退回 DEMO_NODES。
## 为什么必须优先用地图的（2026-10-04 实测，不是洁癖）：正式图「青岭走廊」的地图 N2 与 demo N2
## 差 44.7 m，而 demo N2 在正式图上是 **45.8° 的坡**、核心圈里还压着一栋房子 ——
## 只换高度图不换点，白旗点会直接烂掉一个。
func _build_capture_zones(main) -> Array:
	var positions := _capture_zone_positions(main)
	var zones: Array = []
	for i in positions.size():
		var zone := CaptureZone.new()
		zone.name = "Zone%d" % (i + 1)
		zone.global_position = positions[i]
		zone.setup(main.player)
		main.add_child(zone)
		zones.append(zone)
	return zones


## 白旗点坐标：地图的 raas_nodes 前 3 个；不足 3 个就用满它；一个都没有才退回 demo 摆位。
func _capture_zone_positions(main) -> Array:
	var nodes: Array = _load_map_zones(main).get("raas_nodes", [])
	var positions: Array = []
	for node_v in nodes:
		if node_v is Dictionary:
			positions.append(JieyuMapGen.vec2((node_v as Dictionary).get("pos", [0, 0])))
	if positions.size() >= 3:
		var first_three: Array = positions.slice(0, 3)
		print("[地图] 白旗点取自地图推进链前 3 个：%s" % str(first_three))
		return first_three
	if positions.size() > 0:
		print("[地图] 白旗点：地图只给了 %d 个节点，用满它" % positions.size())
		return positions
	print("[地图] 没有 zones.json / 没有 raas_nodes → 白旗点退回 demo 摆位")
	return [MapGenerator.DEMO_NODES[0], MapGenerator.DEMO_NODES[1], MapGenerator.DEMO_NODES[2]]


## 地图目录（res://assets/maps/<id>/）里的 zones.json → 字典；读不到就是空字典。
## 这里只取需要的项（raas_nodes），不做全量 schema 校验 —— schema 归插件侧 JieyuMapChecks 管。
func _load_map_zones(main) -> Dictionary:
	var map_id := _map_id_from_path(str(main.map_height_image) if "map_height_image" in main else "")
	if map_id.is_empty():
		return {}
	var path := "res://assets/maps/%s/zones.json" % map_id
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[地图] zones.json 打不开：%s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		push_error("[地图] zones.json 顶层不是对象：%s" % path)
		return {}
	return parsed
