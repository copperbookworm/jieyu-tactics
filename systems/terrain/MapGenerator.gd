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
## 连通域洪泛的 4 邻域（常量数组按下标取：原来的 `for offset in [[1, 0], …]` 每弹一格新建 4 个 Array）
const NB_DX := [1, -1, 0, 0]
const NB_DY := [0, 0, 1, -1]
## 0 = 无内容层，4 = 瓦砾（残痕由 Cover 摧毁时现落，不从图里读）
const MATERIAL_SKIP_IDS := [0, 4]

## 内容层区域的最小格数：小于它就当噪声丢掉。
## material.png 是程序生成的，边缘会有零星单格散点，全收进来会长出一堆半径不足 1 m 的圆饼。
const MATERIAL_MIN_CELLS := 40

## 并行烘焙的静态脚手架（2026-10-06 第七十九版 · 并行计算整改）
## 阈值与 HeightGrid.PARALLEL_MIN_CELLS 同口径：小网格并行只赔不赚（建任务 + 等完成有固定开销）。
const PAINT_PARALLEL_MIN_CELLS := 262144
const PAINT_MAX_BANDS := 12
static var _paint_heights := PackedFloat32Array()
static var _paint_out := PackedByteArray()
static var _paint_w := 0
static var _paint_h := 0
static var _paint_bands := 1
static var _paint_rough := -1.0
static var _lut_ratio := PackedFloat32Array()
static var _lut_rgb := PackedByteArray()
static var _rough_rgb := PackedByteArray()
static var _kind_lut := PackedInt32Array()

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
##
## 【2026-10-06 第七十九版 · 并行计算整改】改成两段式：
##   ① 一次整块导出高程（HeightGrid.heights_readonly()，只读共享）
##   ② 按行分块（WorkerThreadPool）把 RGB8 字节直接写进 PackedByteArray
##   ③ 主线程一次 Image.create_from_data()
## 旧实现每格两次 GDScript 方法调用（height_at_cell + height_to_color）+ 一次 set_pixel：
## 1000×1000 实测 debug 4.3~5.2 s / release 1.0~1.2 s；两段式后 debug 0.71~0.81 s（抽检像素零不一致）。
## chunks <= 0 = 自动（小图或测试自动走单线程）；显式传 1 可强制串行（等价性测试用）。
## ⚠ 用 static 脚手架传参 ⇒ 本函数**不可重入**：只许主线程调用（现状唯一调用点是 WorldSetup._build_terrain）。
static func build_terrain_texture(grid: HeightGrid,
		roughness_threshold: float = -1.0, chunks: int = 0) -> ImageTexture:
	var image := build_terrain_image(grid, roughness_threshold, chunks)
	if image == null:
		return null
	return ImageTexture.create_from_image(image)


## 上色的中间产物（工具 / 等价性测试直取；与 build_terrain_texture 共用同一条实现）
static func build_terrain_image(grid: HeightGrid,
		roughness_threshold: float = -1.0, chunks: int = 0) -> Image:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		return null
	var w: int = grid.width
	var h: int = grid.height
	_ensure_color_lut()
	_paint_heights = grid.heights_readonly()
	_paint_w = w
	_paint_h = h
	_paint_rough = roughness_threshold
	# ⚠ 每次都新建缓冲：复用「已共享」的 Packed 数组时 resize(同尺寸) 会提前返回、
	# 数组仍是 shared ⇒ 多线程里第一个写入触发 copy-on-write，会互相踩（实测报过 Out of bounds）。
	_paint_out = PackedByteArray()
	_paint_out.resize(w * h * 3)
	var bands := chunks
	if bands <= 0:
		bands = 1 if w * h < PAINT_PARALLEL_MIN_CELLS \
				else clampi(OS.get_processor_count() - 1, 2, PAINT_MAX_BANDS)
	bands = clampi(bands, 1, maxi(h, 1))
	_paint_bands = bands
	if bands <= 1:
		_paint_rows(0, h)
	else:
		var id := WorkerThreadPool.add_group_task(
				func(band: int) -> void: _paint_band(band),
				bands, bands, true, "terrain_paint")
		WorkerThreadPool.wait_for_group_task_completion(id)
	var image := Image.create_from_data(w, h, false, Image.FORMAT_RGB8, _paint_out)
	# 松手：不长期持有这 3 MB 中间缓冲，也把 grid._data 的共享引用放开
	_paint_out = PackedByteArray()
	_paint_heights = PackedFloat32Array()
	return image


## 一个分块（分块数在 _paint_bands 里；顺序路径就是 bands=1）
static func _paint_band(band: int) -> void:
	var rows := int(ceil(float(_paint_h) / float(_paint_bands)))
	var y0 := band * rows
	var y1 := mini(y0 + rows, _paint_h)
	if y0 >= y1:
		return
	_paint_rows(y0, y1)


## 真正的上色循环（**顺序与并行共用这一份** ⇒ 两种路径逐字节一致）
## 热路径里不许出现 GDScript 方法调用与 Dictionary 取值：
##   配色走预建的 LUT（_lut_ratio / _lut_rgb），红域判定内联（原 _is_rough 每像素调 4 次 height_at_cell）。
static func _paint_rows(y0: int, y1: int) -> void:
	var w := _paint_w
	var heights := _paint_heights      # 只读共享，安全
	var lut_ratio := _lut_ratio
	var lut_rgb := _lut_rgb
	var last_band := lut_ratio.size() - 1
	var rough := _paint_rough
	var max_elev := GameConfig.MAX_ELEVATION
	var rb0 := _rough_rgb[0]
	var rb1 := _rough_rgb[1]
	var rb2 := _rough_rgb[2]
	for y in range(y0, y1):
		var row := y * w
		for x in w:
			var i := (row + x) * 3
			var height := heights[row + x]
			var is_rough := false
			if rough > 0.0:
				# 与原 _is_rough 同一判据、同一顺序（4 邻域，越界钳到边缘）
				var nx := mini(x + 1, w - 1)
				is_rough = absf(height - heights[row + nx]) > rough
				nx = maxi(x - 1, 0)
				if not is_rough:
					is_rough = absf(height - heights[row + nx]) > rough
				var ny := mini(y + 1, _paint_h - 1)
				if not is_rough:
					is_rough = absf(height - heights[ny * w + x]) > rough
				ny = maxi(y - 1, 0)
				if not is_rough:
					is_rough = absf(height - heights[ny * w + x]) > rough
			if is_rough:
				_paint_out[i] = rb0
				_paint_out[i + 1] = rb1
				_paint_out[i + 2] = rb2
			else:
				# 与 height_to_color 同口径：ratio = clampf(h / MAX, 0, 1)，取第一个 ratio <= 阈值的档
				var ratio := height / max_elev
				if ratio > 1.0:
					ratio = 1.0
				elif ratio < 0.0:
					ratio = 0.0
				var band := 0
				while band < last_band and ratio > lut_ratio[band]:
					band += 1
				var o := band * 3
				_paint_out[i] = lut_rgb[o]
				_paint_out[i + 1] = lut_rgb[o + 1]
				_paint_out[i + 2] = lut_rgb[o + 2]


## 配色 LUT（从 TERRAIN_COLORS 派生 ⇒ 不会和 height_to_color 漂移）与红域字节
## _to_byte 与 Image.set_pixel(FORMAT_RGB8) 同一条换算：uint8_t(CLAMP(v * 255.0, 0, 255))
static func _ensure_color_lut() -> void:
	if _lut_ratio.size() == TERRAIN_COLORS.size():
		return
	_lut_ratio = PackedFloat32Array()
	_lut_rgb = PackedByteArray()
	for entry in TERRAIN_COLORS:
		_lut_ratio.append(float(entry["ratio"]))
		var c: Color = entry["color"]
		_lut_rgb.append(_to_byte(c.r))
		_lut_rgb.append(_to_byte(c.g))
		_lut_rgb.append(_to_byte(c.b))
	_rough_rgb = PackedByteArray()
	var rough := Color(1.0, 0.3, 0.25)
	_rough_rgb.append(_to_byte(rough.r))
	_rough_rgb.append(_to_byte(rough.g))
	_rough_rgb.append(_to_byte(rough.b))


static func _to_byte(v: float) -> int:
	return int(clampf(v * 255.0, 0.0, 255.0))


## 导出当前高程为灰度高度图（工具链 A 的起手稿）：黑 = 0 m，白（255）= max_elevation
## 【2026-10-06 第七十九版】去掉逐像素 set_pixel（100 万格要数秒）：整块字节 + create_from_data。
## L8 的字节换算与 set_pixel 同口径（gray = clampf(h / MAX, 0, 1)，再 _to_byte）。
static func export_height_image(grid: HeightGrid, path: String,
		max_elevation: float = GameConfig.MAX_ELEVATION) -> Error:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		return ERR_INVALID_DATA
	var w: int = grid.width
	var h: int = grid.height
	var heights := grid.heights_readonly()
	var gray := PackedByteArray()
	gray.resize(w * h)
	var cells := w * h
	for i in cells:
		gray[i] = _to_byte(clampf(heights[i] / max_elevation, 0.0, 1.0))
	var image := Image.create_from_data(w, h, false, Image.FORMAT_L8, gray)
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
##
## 【2026-10-06 第七十九版 · 并行计算整改】只做常数因子优化，**连通域本身不并行**：
## 洪泛的先后顺序决定 entries 的顺序（进而决定 TerrainZone 的建节点顺序），
## 而并行连通域要么引入 union-find 的原子操作、要么改变顺序 —— 在没量到瓶颈前不值得冒这个险。
## 去掉的三处每像素开销：
##   ① MATERIAL_SKIP_IDS.has + MATERIAL_KIND_MAP.has 两次 Dictionary 查找 → 一张 256 项 kind 表；
##   ② `for offset in [[1, 0], …]` 每弹一格新建 4 个 Array → 两个常量数组按下标取；
##   ③ 高度/掩码整块下标直取（原来是 set_height_at_cell 这类方法调用）。
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

	var kind_of := _material_kind_lut()

	var visited := PackedByteArray()
	visited.resize(width * height)
	visited.fill(0)

	for start in width * height:
		if visited[start] == 1:
			continue
		var cell_id := data[start]
		# 两次 Dictionary 查找（SKIP_IDS / KIND_MAP）换成一张 256 项的表（见函数头注释）
		if kind_of[cell_id] < 0:
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
			for k in 4:
				var nx: int = x + NB_DX[k]
				var ny: int = y + NB_DY[k]
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
			"kind": int(kind_of[cell_id]),
			"position": Vector2(float(sum_x) / float(count), float(sum_y) / float(count)),
			"radius": radius,
			"cells": count,
		})
	return entries


## material.png 的 id → kind 的 256 项查表（-1 = 这一格不是内容层）。
## 从 MATERIAL_KIND_MAP / MATERIAL_SKIP_IDS 派生 ⇒ 加新 id 时不会漏改第二处。
static func _material_kind_lut() -> PackedInt32Array:
	if _kind_lut.size() == 256:
		return _kind_lut
	_kind_lut = PackedInt32Array()
	_kind_lut.resize(256)
	_kind_lut.fill(-1)
	for id in MATERIAL_KIND_MAP:
		_kind_lut[int(id)] = int(MATERIAL_KIND_MAP[id])
	for id in MATERIAL_SKIP_IDS:
		_kind_lut[int(id)] = -1
	return _kind_lut