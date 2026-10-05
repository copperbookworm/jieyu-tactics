class_name MapGenerator
extends RefCounted

## 地图装配（docx 12.8 地图数据规格）
## 第一版不做 PNG 资产与 TileSet：高程网格在运行时由噪声生成，
## 地形表现直接把高程上色成 ImageTexture 贴到一个 Sprite2D 上（1 px = 1 m）。
## 这样绕开 .tres / .tscn 手工制作，先让循环跑起来。
##
## 【2026-10-03 第四十八版】新增：4.17 内容层 material.png 的解析
## （单通道 id 图：0 无 / 1 泥泞 / 2 雪地 / 3 草丛 / 4 瓦砾 → 圆形区域列表）。
## 工程侧的 TerrainZone 第一版只支持圆饼，所以这里做「连通域 → 等效圆」的收敛；
## 格式解析集中在文件里，WorldSetup 只管按结果建节点。

## 丘陵草原配色（低 → 高），按最大海拔比例分段
const TERRAIN_COLORS := [
	{"ratio": 0.10, "color": Color("3f5a3a")},  # 河谷／低地
	{"ratio": 0.25, "color": Color("4a6b3c")},  # 草地
	{"ratio": 0.50, "color": Color("5d7a41")},  # 缓坡
	{"ratio": 0.75, "color": Color("7a8447")},  # 高地
	{"ratio": 1.01, "color": Color("948b58")},  # 山脊／裸土
]

## material.png 的 id → TerrainZone 的 kind（与 entities/zone/TerrainZone.gd 的 Kind 枚举同值）
const MATERIAL_KIND_MAP := {1: 0, 2: 1, 3: 2}
## 0 = 无内容层，4 = 瓦砾（残痕由 Cover 摧毁时现落，不从图里读）
const MATERIAL_SKIP_IDS := [0, 4]

## 内容层区域的最小格数：小于它就当噪声丢掉。
## material.png 是程序生成的，边缘会有零星单格散点，全收进来会长出一堆半径不足 1 m 的圆饼。
const MATERIAL_MIN_CELLS := 40

## grassland_demo 五节点世界坐标（docx 12.8.4，单位 m，原点左上）
const DEMO_NODES := [
	Vector2(150.0, 500.0),  # N1 西侧起点
	Vector2(350.0, 300.0),  # N2
	Vector2(500.0, 500.0),  # N3 中央枢纽
	Vector2(680.0, 700.0),  # N4
	Vector2(850.0, 500.0),  # N5 东侧终点
]
const NODE_FLATTEN_RADIUS := 30.0  # m，节点周边压平半径（手工雕刻的自动近似）


## 生成 1 km 基底高程（噪声 + 节点区压平）
static func build_demo_grid(seed_value: int = GameConfig.DEFAULT_MAP_SEED) -> HeightGrid:
	var grid := HeightGrid.new(GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT)
	grid.fill_from_noise(seed_value)
	for node in DEMO_NODES:
		flatten_area(grid, node, NODE_FLATTEN_RADIUS)
	return grid


## 把圆形区域压平到该区平均高度——保证占领区／出生区不悬在斜坡上
static func flatten_area(grid: HeightGrid, center: Vector2, radius: float) -> void:
	if grid == null or radius <= 0.0:
		return
	var center_cell := grid.world_to_cell(center)
	var cell_radius := ceili(radius / grid.cell_size)
	var total := 0.0
	var count := 0
	for y in range(center_cell.y - cell_radius, center_cell.y + cell_radius + 1):
		for x in range(center_cell.x - cell_radius, center_cell.x + cell_radius + 1):
			if not grid.is_inside(x, y):
				continue
			if Vector2(x, y).distance_to(Vector2(center_cell)) > float(cell_radius):
				continue
			total += grid.height_at_cell(x, y)
			count += 1
	if count == 0:
		return
	var average := total / float(count)
	for y in range(center_cell.y - cell_radius, center_cell.y + cell_radius + 1):
		for x in range(center_cell.x - cell_radius, center_cell.x + cell_radius + 1):
			if not grid.is_inside(x, y):
				continue
			if Vector2(x, y).distance_to(Vector2(center_cell)) > float(cell_radius):
				continue
			grid.set_height_at_cell(x, y, average)


## 高程上色成 1 px = 1 m 的地形贴图（替代 TileMapLayer + TileSet）
static func build_terrain_texture(grid: HeightGrid,
		roughness_threshold: float = -1.0) -> ImageTexture:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		return null
	var image := Image.create(grid.width, grid.height, false, Image.FORMAT_RGB8)
	for y in grid.height:
		for x in grid.width:
			var height := grid.height_at_cell(x, y)
			if roughness_threshold > 0.0 and _is_rough(grid, x, y, roughness_threshold):
				image.set_pixel(x, y, Color(1.0, 0.3, 0.25))
			else:
				image.set_pixel(x, y, height_to_color(height))
	return ImageTexture.create_from_image(image)


## 该格与 4 邻域最大高差是否超过阈值
static func _is_rough(grid: HeightGrid, x: int, y: int, threshold: float) -> bool:
	var center_height := grid.height_at_cell(x, y)
	for offset in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
		var neighbor := grid.height_at_cell(x + offset[0], y + offset[1])
		if absf(center_height - neighbor) > threshold:
			return true
	return false


## 导出当前高程为灰度高度图（工具链 A 的起手稿）：黑 = 0 m，白（255）= max_elevation
## 100 万格逐像素 set_pixel 在 GDScript 下要数秒——一次性工具开销，可接受
static func export_height_image(grid: HeightGrid, path: String,
		max_elevation: float = GameConfig.MAX_ELEVATION) -> Error:
	var image := Image.create(grid.width, grid.height, false, Image.FORMAT_L8)
	for y in grid.height:
		for x in grid.width:
			var gray := clampf(grid.height_at_cell(x, y) / max_elevation, 0.0, 1.0)
			image.set_pixel(x, y, Color(gray, gray, gray))
	return image.save_png(path)


static func height_to_color(height: float) -> Color:
	var ratio := clampf(height / GameConfig.MAX_ELEVATION, 0.0, 1.0)
	for entry in TERRAIN_COLORS:
		if ratio <= float(entry["ratio"]):
			return entry["color"]
	return TERRAIN_COLORS[TERRAIN_COLORS.size() - 1]["color"]


## 出生区：N1 外侧（docx 12.8.4 续航区在点外 100~200 m 的隐蔽处）
static func demo_spawn_point() -> Vector2:
	return DEMO_NODES[0] + Vector2(-100.0, 0.0)


## 掩体演示点：每个白旗点周围 4 个沙袋（docx 4.7 第③级掩体层的可玩性落点）
static func demo_cover_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var offsets := [Vector2(18.0, 18.0), Vector2(-18.0, 18.0),
			Vector2(18.0, -18.0), Vector2(-18.0, -18.0)]
	for node in DEMO_NODES:
		for offset in offsets:
			points.append(node + offset)
	return points


## 敌人初始位置：出生点前方 45~75 m（第一版的"30 秒体验"要求出生后不久就能撞见敌人；
## 正式地图里敌人应按 RAAS 节点分布，这里只是让循环先闭环）
## 环境互动区（docx 4.17，候选 O 第四轮）：泥泞 / 雪地 / 草丛各一片 demo 摆位。
## kind ＝ 0 泥泞 / 1 雪地 / 2 草丛（与 entities/zone/TerrainZone.gd 的 Kind 枚举同值）。
## 摆位刻意远离五节点、出生点与车辆（≥ 250 m）：候选 P 的烟、4.16 的倒地这些集成检查会在地形上
## 扫位置，别让「草丛隐蔽」顺手把敌人的发现距离打折而干扰它们的结论。
static func demo_terrain_zones() -> Array:
	return [
		{"kind": 0, "position": Vector2(120.0, 150.0), "radius": 26.0},   # 泥泞（西北）
		{"kind": 1, "position": Vector2(760.0, 240.0), "radius": 24.0},   # 雪地（东北）
		{"kind": 2, "position": Vector2(250.0, 820.0), "radius": 30.0},   # 草丛（西南）
	]


## 敌人相对出生锚点的偏移（单一来源）：demo 摆位与「地图出生区」两条路都用它，
## 免得两边各写一份偏移慢慢漂移。45~75 m 是「出生 30 秒就能撞见敌人」的口径。
const ENEMY_SPAWN_OFFSETS := [Vector2(45.0, -10.0), Vector2(70.0, 30.0)]


static func enemy_spawn_offsets() -> Array[Vector2]:
	var offsets: Array[Vector2] = []
	for offset in ENEMY_SPAWN_OFFSETS:
		offsets.append(offset)
	return offsets


static func demo_enemy_points() -> Array[Vector2]:
	var spawn := demo_spawn_point()
	var points: Array[Vector2] = []
	for offset in ENEMY_SPAWN_OFFSETS:
		points.append(spawn + offset)
	return points


## 载具出生点：[我方车, 敌方坦克]——Main 建载具与地图预览共用这一处，
## 免得预览里看不到载具、或者两边坐标各写一份慢慢漂移
static func demo_vehicle_points() -> Array[Vector2]:
	return [
		demo_spawn_point() + Vector2(35.0, 0.0),
		DEMO_NODES[1] + Vector2(40.0, 20.0),
	]


## 敌方 FOB 位置（候选 L2）：放在 N4 外侧、通往 N5 的必经方向上——等于是敌方后方的工事。
## 单一数据源：WorldSetup 建实体与地图预览画标记都用它，免得两边坐标各写一份慢慢漂移。
static func demo_enemy_fob_point() -> Vector2:
	return DEMO_NODES[3] + Vector2(40.0, 40.0)


## 侧翼通路（候选 L4，docx 4.10.11 T-S6）：[入口（敌方来向）, 出口（我方一侧）]。
## 北路侧翼：从东北方向沿 y≈180 插向我方西侧高地。长度 220 m，穿插兵 2.6 m/s 约 85 s 走完，
## 短于官方给的 150 s 时限 —— 有真实压力，但也留得出拦截时间。
static func demo_flank_lane() -> Array[Vector2]:
	return [Vector2(520.0, 180.0), Vector2(300.0, 180.0)]


# ────────────── 4.17 内容层：material.png → 区域列表 ──────────────

## 把 material.png（单通道 id 图）转成 TerrainZone 能吃的区域列表。
## 返回 [{kind, position, radius, cells}]；图里没有任何内容层像素时返回空数组（调用方退回 demo）。
##
## 做法：先按 id 取掩码 → 4 邻域连通域（迭代式洪泛，不用递归，免得大区域爆栈）→
## 每个连通域取「格心均值」当圆心、取「等面积圆半径」当半径。
## 为什么用等面积而不是外接半径：外接半径会把长条状区域做成一个大圆饼盖住半张图；
## 等面积圆在面积上等价，形状误差落在玩家最不敏感的那一维（区域边缘的弧线）。
static func terrain_zones_from_material_image(image: Image,
		min_cells: int = MATERIAL_MIN_CELLS) -> Array:
	var entries: Array = []
	if image == null or image.get_width() <= 0 or image.get_height() <= 0:
		return entries
	var img := image.duplicate() as Image
	if img.get_format() != Image.FORMAT_L8:
		img.convert(Image.FORMAT_L8)
	var width := img.get_width()
	var height := img.get_height()
	var data := img.get_data()

	var visited := PackedByteArray()
	visited.resize(width * height)
	visited.fill(0)

	for start in width * height:
		var cell_id := data[start]
		if visited[start] == 1 or MATERIAL_SKIP_IDS.has(cell_id) or not MATERIAL_KIND_MAP.has(cell_id):
			continue
		# 4 邻域洪泛：手写队列（Array 当栈用），遇到不同 id 就停
		var stack: Array[int] = [start]
		visited[start] = 1
		var count := 0
		var sum_x := 0
		var sum_y := 0
		while not stack.is_empty():
			var index: int = stack.pop_back()
			var x := index % width
			var y := index / width
			count += 1
			sum_x += x
			sum_y += y
			for offset in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
				var nx: int = x + int(offset[0])
				var ny: int = y + int(offset[1])
				if nx < 0 or ny < 0 or nx >= width or ny >= height:
					continue
				var n_index := ny * width + nx
				if visited[n_index] == 1 or data[n_index] != cell_id:
					continue
				visited[n_index] = 1
				stack.append(n_index)
		if count < min_cells:
			continue
		# 1 格 = 1 m ⇒ 面积（m²）= 格数；等面积圆半径 r = sqrt(area / π)
		var radius := sqrt(float(count) / PI)
		entries.append({
			"kind": int(MATERIAL_KIND_MAP[cell_id]),
			"position": Vector2(float(sum_x) / float(count), float(sum_y) / float(count)),
			"radius": radius,
			"cells": count,
		})
	return entries
