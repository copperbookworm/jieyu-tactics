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
