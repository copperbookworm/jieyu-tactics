class_name JieyuMapRender
extends RefCounted

## 审阅贴图：把高度 / 通行性 / 区域画成能一眼看懂的图（插件 dock 与产物 PNG 共用）。
##
## 与 MapGenerator.build_terrain_texture 的分工：
##   · MapGenerator 的那张是**运行时**给玩家看的地形贴图（含 debug 标红）；
##   · 本类的是**编辑期**给设计者看的审阅图：高程着色 + 等高线 + 节点 / 五结构 / 掩体叠画，
##     只有它落盘成 terrain.png（12.8.1），不参与游戏运行。
##
## 性能口径：1000×1000 逐像素在纯 GDScript 下是秒级，本类只在「重新渲染」时跑一次。

## 与 MapGenerator.TERRAIN_COLORS 同一条丘陵草原配色（低 → 高）
const TERRAIN_COLORS := [
	{"ratio": 0.10, "color": Color("3f5a3a")},
	{"ratio": 0.25, "color": Color("4a6b3c")},
	{"ratio": 0.50, "color": Color("5d7a41")},
	{"ratio": 0.75, "color": Color("7a8447")},
	{"ratio": 1.01, "color": Color("948b58")},
]

const COLOR_NODE := Color(0.98, 0.98, 0.98)
const COLOR_CORE := Color(1.0, 0.85, 0.2)
const COLOR_RING := Color(1.0, 0.45, 0.15)
const COLOR_BUILDING := Color(0.65, 0.65, 0.72)
const COLOR_WALL := Color(0.45, 0.45, 0.52)
const COLOR_SPAWN_WEST := Color(0.25, 0.55, 1.0)
const COLOR_SPAWN_EAST := Color(1.0, 0.32, 0.32)
const CONTOUR_STEP_M := 10.0


## ────────────── 高程着色 ──────────────

## 单张地形贴图（不叠任何标注）—— 落盘成 terrain.png
static func terrain_image(grid: HeightGrid,
		roughness_threshold: float = -1.0) -> Image:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		return Image.create(1, 1, false, Image.FORMAT_RGB8)
	var image := Image.create(grid.width, grid.height, false, Image.FORMAT_RGB8)
	for y in grid.height:
		for x in grid.width:
			var height := grid.height_at_cell(x, y)
			if roughness_threshold > 0.0 and _is_rough(grid, x, y, roughness_threshold):
				image.set_pixel(x, y, Color(1.0, 0.3, 0.25))
			else:
				image.set_pixel(x, y, height_to_color(height))
	return image


static func _is_rough(grid: HeightGrid, x: int, y: int, threshold: float) -> bool:
	var here := grid.height_at_cell(x, y)
	for offset in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
		if absf(here - grid.height_at_cell(x + offset[0], y + offset[1])) > threshold:
			return true
	return false


static func height_to_color(height: float) -> Color:
	var ratio := clampf(height / GameConfig.MAX_ELEVATION, 0.0, 1.0)
	for entry in TERRAIN_COLORS:
		if ratio <= float(entry["ratio"]):
			return entry["color"]
	return TERRAIN_COLORS[TERRAIN_COLORS.size() - 1]["color"]


## ────────────── 设计审阅图（着色 + 等高线 + 全部标注）──────────────

## layers 可选键：
##   terrain(默认 true) / contours / zones / occluders / passability / grid_km
static func overview_image(doc: JieyuMapDoc, layers: Dictionary = {}) -> Image:
	if doc == null or not doc.is_valid():
		return Image.create(1, 1, false, Image.FORMAT_RGB8)
	var grid := doc.to_height_grid()
	var image := terrain_image(grid)
	if bool(layers.get("passability", false)):
		_blend_passability(image, grid)
	if bool(layers.get("contours", true)):
		_draw_contours(image, grid)
	if bool(layers.get("zones", true)):
		_draw_zones(image, doc)
	if bool(layers.get("occluders", true)):
		_draw_occluders(image, doc)
	if bool(layers.get("grid_km", false)):
		_draw_grid(image)
	return image


## 不可通行红域叠加（与 MapInspector.build_passability_image 同判据：MAX_SLOPE_DEG）
static func _blend_passability(image: Image, grid: HeightGrid) -> void:
	var step := GameConfig.PREVIEW_SLOPE_STEP
	var red := Color(0.9, 0.15, 0.1)
	var alpha := clampf(GameConfig.PREVIEW_PASSABLE_ALPHA, 0.0, 1.0)
	var y := 0
	while y < grid.height:
		var x := 0
		while x < grid.width:
			if _is_steep(grid, x, y, step):
				var x1 := mini(x + step, grid.width)
				var y1 := mini(y + step, grid.height)
				for by in range(y, y1):
					for bx in range(x, x1):
						image.set_pixel(bx, by, image.get_pixel(bx, by).lerp(red, alpha))
			x += step
		y += step


static func _is_steep(grid: HeightGrid, x: int, y: int, step: int) -> bool:
	var here := Vector2i(x, y)
	var right := Vector2i(mini(x + step, grid.width - 1), y)
	var down := Vector2i(x, mini(y + step, grid.height - 1))
	if grid.slope_deg(here, right) > GameConfig.MAX_SLOPE_DEG:
		return true
	return grid.slope_deg(here, down) > GameConfig.MAX_SLOPE_DEG


## 等高线：跨过 CONTOUR_STEP_M 整数倍的格描一道浅色
static func _draw_contours(image: Image, grid: HeightGrid) -> void:
	var line := Color(0.08, 0.10, 0.08, 0.55)
	for y in grid.height:
		for x in grid.width:
			var here := grid.height_at_cell(x, y)
			var band := floori(here / CONTOUR_STEP_M)
			if x + 1 < grid.width:
				if floori(grid.height_at_cell(x + 1, y) / CONTOUR_STEP_M) != band:
					image.set_pixel(x, y, image.get_pixel(x, y).lerp(line, 0.7))
			if y + 1 < grid.height:
				if floori(grid.height_at_cell(x, y + 1) / CONTOUR_STEP_M) != band:
					image.set_pixel(x, y, image.get_pixel(x, y).lerp(line, 0.7))


## 节点 / 核心区 / 压制圈 / 出生区 / 集结点
static func _draw_zones(image: Image, doc: JieyuMapDoc) -> void:
	for area_v in doc.zones.get("spawn_areas", []):
		if not (area_v is Dictionary):
			continue
		var area: Dictionary = area_v
		var color := COLOR_SPAWN_WEST if str(area.get("side", "")) == "west" else COLOR_SPAWN_EAST
		_fill_polygon(image, area.get("polygon", []), color, 0.35)
		_stroke_polygon(image, area.get("polygon", []), color)

	for rally_v in doc.zones.get("rally_zones", []):
		if rally_v is Dictionary:
			_stroke_polygon(image, (rally_v as Dictionary).get("allowed_polygon", []),
					Color(0.3, 0.9, 0.7), 0.5)

	var nodes: Array = doc.zones.get("raas_nodes", [])
	var node_ids: Array = []
	for node_v in nodes:
		node_ids.append(str((node_v as Dictionary).get("id", "")))
	var flags: Array = doc.zones.get("flags", [])
	for i in nodes.size():
		var node: Dictionary = nodes[i]
		var pos := JieyuMapGen.vec2(node.get("pos", [0, 0]))
		var core := JieyuMapSpec.CORE_RADIUS_M
		var ring: Array = JieyuMapSpec.PRESSURE_RING_M
		if i < flags.size() and flags[i] is Dictionary:
			var flag: Dictionary = flags[i]
			core = float(flag.get("core_radius_m", core))
			var ring_v: Variant = flag.get("pressure_ring_m", null)
			if ring_v is Array and (ring_v as Array).size() == 2:
				ring = ring_v
		_stroke_circle(image, pos, float(ring[1]), COLOR_RING, 0.45)
		_stroke_circle(image, pos, float(ring[0]), COLOR_RING, 0.65)
		_disc(image, pos, core, COLOR_CORE, 0.45)
		_stroke_circle(image, pos, core, COLOR_CORE, 0.9)
		_marker(image, pos, COLOR_NODE)
		_blit_text(image, pos + Vector2(core + 4.0, -core - 4.0),
				str(node.get("id", "N%d" % (i + 1))), COLOR_NODE)


## 掩体 / 建筑轮廓
static func _draw_occluders(image: Image, doc: JieyuMapDoc) -> void:
	for item_v in doc.occluders:
		if not (item_v is Dictionary):
			continue
		var item: Dictionary = item_v
		var is_building := str(item.get("type", "")) == "building"
		var color := COLOR_BUILDING if is_building else COLOR_WALL
		var polygon: Variant = item.get("polygon", null)
		if is_building:
			_fill_polygon(image, polygon, color, 0.55)
		_stroke_polygon(image, polygon, color, 0.9)


## 公里格网（每 100 m 一道暗线）—— 量距离用
static func _draw_grid(image: Image) -> void:
	var line := Color(0.0, 0.0, 0.0, 0.35)
	var step := 100
	for x in range(0, image.get_width(), step):
		for y in image.get_height():
			image.set_pixel(x, y, image.get_pixel(x, y).lerp(line, 0.5))
	for y in range(0, image.get_height(), step):
		for x in image.get_width():
			image.set_pixel(x, y, image.get_pixel(x, y).lerp(line, 0.5))


## ────────────── 基础图元 ──────────────

static func _disc(image: Image, center: Vector2, radius: float, color: Color,
		alpha: float = 1.0) -> void:
	var cx := center.x
	var cy := center.y
	for y in range(maxi(floori(cy - radius), 0), mini(ceili(cy + radius) + 1, image.get_height())):
		for x in range(maxi(floori(cx - radius), 0), mini(ceili(cx + radius) + 1,
				image.get_width())):
			if Vector2(x, y).distance_to(center) > radius:
				continue
			image.set_pixel(x, y, image.get_pixel(x, y).lerp(color, clampf(alpha, 0.0, 1.0)))


static func _stroke_circle(image: Image, center: Vector2, radius: float, color: Color,
		alpha: float = 1.0, width: float = 1.0) -> void:
	if radius < 1.0:
		return
	var steps := maxi(int(ceil(TAU * radius)), 24)
	for i in steps:
		var angle := TAU * float(i) / float(steps)
		var point := center + Vector2(cos(angle), sin(angle)) * radius
		_pixel_soft(image, point, color, alpha, width)


static func _stroke_polygon(image: Image, polygon: Variant, color: Color,
		alpha: float = 1.0) -> void:
	if not (polygon is Array) or (polygon as Array).size() < 2:
		return
	var points: Array = polygon
	for i in points.size():
		var a := JieyuMapGen.vec2(points[i])
		var b := JieyuMapGen.vec2(points[(i + 1) % points.size()])
		var steps := maxi(int(ceil(a.distance_to(b))), 1)
		for s in steps + 1:
			_pixel_soft(image, a.lerp(b, float(s) / float(steps)), color, alpha, 1.0)


static func _fill_polygon(image: Image, polygon: Variant, color: Color,
		alpha: float = 1.0) -> void:
	if not (polygon is Array) or (polygon as Array).size() < 3:
		return
	var points: Array = polygon
	var min_y := INF
	var max_y := -INF
	for point_v in points:
		var point := JieyuMapGen.vec2(point_v)
		min_y = minf(min_y, point.y)
		max_y = maxf(max_y, point.y)
	for y in range(maxi(floori(min_y), 0), mini(ceili(max_y) + 1, image.get_height())):
		var crossings: Array[float] = []
		for i in points.size():
			var a := JieyuMapGen.vec2(points[i])
			var b := JieyuMapGen.vec2(points[(i + 1) % points.size()])
			var y0 := a.y
			var y1 := b.y
			if (y0 <= float(y) and y1 > float(y)) or (y1 <= float(y) and y0 > float(y)):
				var t := (float(y) - y0) / (y1 - y0)
				crossings.append(a.x + (b.x - a.x) * t)
		if crossings.size() < 2:
			continue
		crossings.sort()
		var index := 0
		while index + 1 < crossings.size():
			var x0 := maxi(floori(crossings[index]), 0)
			var x1 := mini(ceili(crossings[index + 1]), image.get_width())
			for x in range(x0, x1):
				image.set_pixel(x, y, image.get_pixel(x, y).lerp(color, clampf(alpha, 0.0, 1.0)))
			index += 2


static func _pixel_soft(image: Image, point: Vector2, color: Color, alpha: float,
		width: float) -> void:
	var radius := maxf(width * 0.5, 0.5)
	for y in range(maxi(floori(point.y - radius), 0),
			mini(ceili(point.y + radius), image.get_height())):
		for x in range(maxi(floori(point.x - radius), 0),
				mini(ceili(point.x + radius), image.get_width())):
			image.set_pixel(x, y, image.get_pixel(x, y).lerp(color, clampf(alpha, 0.0, 1.0)))


## 十字标记（节点位置）
static func _marker(image: Image, center: Vector2, color: Color) -> void:
	for d in range(-6, 7):
		_pixel_soft(image, center + Vector2(float(d), 0.0), color, 1.0, 1.0)
		_pixel_soft(image, center + Vector2(0.0, float(d)), color, 1.0, 1.0)
	_stroke_circle(image, center, 8.0, color, 1.0)


## ────────────── 5×7 点阵字（只给节点 id / 坐标用，不依赖任何字体资源）──────────────

const GLYPHS := {
	"0": ["01110", "10001", "10011", "10101", "11001", "10001", "01110"],
	"1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
	"2": ["01110", "10001", "00001", "00010", "00100", "01000", "11111"],
	"3": ["11111", "00010", "00100", "00010", "00001", "10001", "01110"],
	"4": ["00010", "00110", "01010", "10010", "11111", "00010", "00010"],
	"5": ["11111", "10000", "11110", "00001", "00001", "10001", "01110"],
	"6": ["00110", "01000", "10000", "11110", "10001", "10001", "01110"],
	"7": ["11111", "00001", "00010", "00100", "01000", "01000", "01000"],
	"8": ["01110", "10001", "10001", "01110", "10001", "10001", "01110"],
	"9": ["01110", "10001", "10001", "01110", "00001", "00010", "01100"],
	"N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
	"E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
	"W": ["10001", "10001", "10001", "10101", "10101", "11011", "10001"],
	"S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
	"-": ["00000", "00000", "00000", "11111", "00000", "00000", "00000"],
	" ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],
}


## 画一串 5×7 点阵字（未知字符画成空格）
static func _blit_text(image: Image, origin: Vector2, text: String, color: Color) -> void:
	var cursor := origin
	for i in text.length():
		var ch := text.substr(i, 1).to_upper()
		var glyph: Variant = GLYPHS.get(ch, null)
		if glyph == null:
			cursor.x += 4.0
			continue
		var rows: Array = glyph
		for ry in rows.size():
			var row := str(rows[ry])
			for rx in row.length():
				if row.substr(rx, 1) == "1":
					_pixel_soft(image, cursor + Vector2(float(rx), float(ry)), color, 1.0, 1.0)
		cursor.x += 6.0
