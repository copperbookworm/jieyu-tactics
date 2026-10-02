class_name MapGenerator
extends RefCounted

## 地图装配（docx 12.8 地图数据规格）
## 第一版不做 PNG 资产与 TileSet：高程网格在运行时由噪声生成，
## 地形表现直接把高程上色成 ImageTexture 贴到一个 Sprite2D 上（1 px = 1 m）。
## 这样绕开 .tres / .tscn 手工制作，先让循环跑起来。

## 丘陵草原配色（低 → 高），按最大海拔比例分段
const TERRAIN_COLORS := [
	{"ratio": 0.10, "color": Color("3f5a3a")},  # 河谷／低地
	{"ratio": 0.25, "color": Color("4a6b3c")},  # 草地
	{"ratio": 0.50, "color": Color("5d7a41")},  # 缓坡
	{"ratio": 0.75, "color": Color("7a8447")},  # 高地
	{"ratio": 1.01, "color": Color("948b58")},  # 山脊／裸土
]

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


static func demo_enemy_points() -> Array[Vector2]:
	var spawn := demo_spawn_point()
	return [
		spawn + Vector2(45.0, -10.0),
		spawn + Vector2(70.0, 30.0),
	]


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
