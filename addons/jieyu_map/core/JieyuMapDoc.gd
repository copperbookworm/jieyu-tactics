class_name JieyuMapDoc
extends RefCounted

## 《解域》地图文档：内存里的一张地图 + 12.8 的磁盘读写。
##
## 单一数据源原则：绘制/生成期间**高度就是 heightmap.png 的字节**。
## 运行时 `HeightGrid.fill_from_image` 把灰度按 gray / 255 × max_elevation 解码，
## 本类存字节、再按同一公式量化回字节 —— 往返是无损恒等（不存在「存进去 12.3 m、
## 读出来 12.35 m」的漂移），因此**在工作副本里编辑字节等价于编辑最终产物**。
##
## 落盘布局（12.8.1 的目录结构 + 工程现有 res://assets/maps/ 约定）：
##   res://assets/maps/<map_id>/heightmap.png   ← 成品：运行时直接导入的高度图
##   res://assets/maps/<map_id>/meta.json       ← 12.8.7
##   res://assets/maps/<map_id>/zones.json      ← 12.8.7
##   res://assets/maps/<map_id>/occluders.json  ← 12.8.7
##   res://assets/maps/<map_id>/terrain.png     ← 按高程分段着色的审阅贴图
##   res://assets/maps/<map_id>/layers/<n>.png  ← 工作层（草稿，可直接在外部画图软件里改）

var map_id := ""
var meta: Dictionary = {}
var zones: Dictionary = {}
var occluders: Array = []

var height := PackedByteArray()   ## 一维行优先，index = y * width + x（12.2）
var width := 0
var height_px := 0

## 各高度层的原始字节（层名 → PackedByteArray），供「层分离 → 求和」的工作流用
var layers: Dictionary = {}
var warnings: Array[String] = []
var source_path := ""


## ────────────── 构造 / 尺寸 ──────────────

func is_valid() -> bool:
	return width > 0 and height_px > 0 and height.size() == width * height_px


func index_of(x: int, y: int) -> int:
	return y * width + x


func is_inside(x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < width and y < height_px


func grid_size() -> Vector2i:
	return Vector2i(width, height_px)


func max_elevation() -> float:
	return float(meta.get("max_elevation_m", GameConfig.MAX_ELEVATION))


## ────────────── 高度读写（字节 / 米两套口径）──────────────

func gray_at(x: int, y: int) -> int:
	if not is_inside(x, y):
		return 0
	return height[index_of(x, y)]


func set_gray(x: int, y: int, value: int) -> void:
	if is_inside(x, y):
		height[index_of(x, y)] = clampi(value, 0, JieyuMapSpec.GRAY_MAX)


func height_at(x: int, y: int) -> float:
	return JieyuMapSpec.gray_to_height(gray_at(x, y), max_elevation())


func set_height(x: int, y: int, height_m: float) -> void:
	set_gray(x, y, JieyuMapSpec.height_to_gray(height_m, max_elevation()))


func height_at_world(pos: Vector2) -> float:
	return height_at(floori(pos.x), floori(pos.y))


## 双线性插值（12.8.2 的采样口径）。写成热路径版本：格子坐标直接算下标 + 四角钳制，
## 原因：校验器的制高点扫描会调用它几十万次，走 height_at() 的函数调用开销比算术还贵。
## cell_size 恒为 1 m（GameConfig.CELL_SIZE），所以世界坐标即格坐标。
func sample_bilinear(world_pos: Vector2) -> float:
	var local := world_pos - Vector2(0.5, 0.5)
	var fx := floorf(local.x)
	var fy := floorf(local.y)
	var x0 := clampi(int(fx), 0, width - 1)
	var y0 := clampi(int(fy), 0, height_px - 1)
	var x1 := clampi(x0 + 1, 0, width - 1)
	var y1 := clampi(y0 + 1, 0, height_px - 1)
	var tx := local.x - fx
	var ty := local.y - fy
	var scale := max_elevation() / float(JieyuMapSpec.GRAY_MAX)
	var h00 := float(height[y0 * width + x0]) * scale
	var h10 := float(height[y0 * width + x1]) * scale
	var h01 := float(height[y1 * width + x0]) * scale
	var h11 := float(height[y1 * width + x1]) * scale
	return lerpf(lerpf(h00, h10, tx), lerpf(h01, h11, tx), ty)


## 整片字节写入（长度必须严格等于 width × height_px，不做缩放/补齐）
func set_height_bytes(data: PackedByteArray) -> bool:
	if data.size() != width * height_px:
		push_error("[JieyuMapDoc] 高度数据长度 %d ≠ %d×%d" % [data.size(), width, height_px])
		return false
	height = data.duplicate()
	return true


func fill_gray(value: int) -> void:
	height.fill(clampi(value, 0, JieyuMapSpec.GRAY_MAX))


## ────────────── 与工程运行时的互操作 ──────────────

## 导出成工程既有的 HeightGrid（WorldSetup / SightSystem / MapInspector 都吃这个类型）
func to_height_grid() -> HeightGrid:
	var grid := HeightGrid.new(width, height_px)
	grid.cell_size = float(meta.get("cell_size_m", GameConfig.CELL_SIZE))
	for y in height_px:
		for x in width:
			grid.set_height_at_cell(x, y,
					JieyuMapSpec.gray_to_height(height[index_of(x, y)], max_elevation()))
	return grid


## 从 HeightGrid 回写字节（量化到 8 位；用于把噪声生成结果灌进文档）
func from_height_grid(grid: HeightGrid) -> void:
	if grid == null or grid.width <= 0 or grid.height <= 0:
		push_error("[JieyuMapDoc] 空网格，无法回写")
		return
	width = grid.width
	height_px = grid.height
	height = PackedByteArray()
	height.resize(width * height_px)
	for y in height_px:
		for x in width:
			set_height(x, y, grid.height_at_cell(x, y))


## 画布贴图（1 px = 1 m，审阅用；工程量级 1000×1000 一次性开销可接受）
func to_height_texture() -> ImageTexture:
	var image := Image.create_from_data(width, height_px, false,
			Image.FORMAT_L8, height)
	return ImageTexture.create_from_image(image)


## ────────────── 尺寸变更 ──────────────

## 新建全 0 文档
static func create(map_id: String, grid_w: int, grid_h: int,
		seed_value: int = -1) -> JieyuMapDoc:
	var doc := JieyuMapDoc.new()
	doc.width = grid_w
	doc.height_px = grid_h
	doc.map_id = map_id
	doc.meta = JieyuMapSpec.default_meta(map_id, seed_value)
	doc.meta["grid"] = grid_w
	doc.meta["size_m"] = [float(grid_w), float(grid_h)]
	doc.zones = empty_zones()
	doc.height = PackedByteArray()
	doc.height.resize(grid_w * grid_h)
	doc.height.fill(0)
	return doc


static func empty_zones() -> Dictionary:
	return {"raas_nodes": [], "flags": [], "spawn_areas": [], "rally_zones": []}


## ────────────── 12.8.7 JSON 读写 ──────────────

## 校验三份 JSON 的必备字段与取值；返回错误文本数组（空 = 合法）
static func validate_schema(z: Dictionary, occ: Array) -> Array[String]:
	var errors: Array[String] = []
	if not (z.get("raas_nodes") is Array):
		errors.append("zones.json 缺少 raas_nodes 数组")
	else:
		var seen := {}
		for i in (z["raas_nodes"] as Array).size():
			var node: Variant = z["raas_nodes"][i]
			if not (node is Dictionary):
				errors.append("raas_nodes[%d] 不是对象" % i)
				continue
			var nd := node as Dictionary
			for key in ["id", "name", "pos"]:
				if not nd.has(key):
					errors.append("raas_nodes[%d] 缺字段 %s" % [i, key])
			var pos: Variant = nd.get("pos", null)
			if not (pos is Array) or (pos as Array).size() != 2:
				errors.append("raas_nodes[%d].pos 必须是 [x, y]" % i)
			elif seen.has(str(nd.get("id", ""))):
				errors.append("raas_nodes[%d].id 重复：%s" % [i, str(nd.get("id", ""))])
			else:
				seen[str(nd.get("id", ""))] = true
	if z.has("flags") and z["flags"] is Array:
		for i in (z["flags"] as Array).size():
			var flag: Variant = z["flags"][i]
			if not (flag is Dictionary):
				errors.append("flags[%d] 不是对象" % i)
				continue
			var fd := flag as Dictionary
			if not fd.has("node"):
				errors.append("flags[%d] 缺字段 node" % i)
			var ring: Variant = fd.get("pressure_ring_m", null)
			if ring != null and (not (ring is Array) or (ring as Array).size() != 2):
				errors.append("flags[%d].pressure_ring_m 必须是 [内, 外]" % i)
	if not (occ is Array):
		errors.append("occluders.json 顶层必须是数组")
	else:
		for i in occ.size():
			var item: Variant = occ[i]
			if not (item is Dictionary):
				errors.append("occluders[%d] 不是对象" % i)
				continue
			var od := item as Dictionary
			for key in ["id", "type", "polygon", "h_low", "h_top"]:
				if not od.has(key):
					errors.append("occluders[%d] 缺字段 %s" % [i, key])
			var poly: Variant = od.get("polygon", null)
			if poly is Array and (poly as Array).size() < 3:
				errors.append("occluders[%d].polygon 至少 3 个顶点" % i)
			if od.has("h_low") and od.has("h_top") \
					and float(od["h_low"]) > float(od["h_top"]):
				errors.append("occluders[%d] h_low > h_top" % i)
			# 开口（窗 / 门洞）：12.8.7 原本没有这个字段，2026-10-03 拍板①补进每条 occluder
			var openings: Variant = od.get("openings", null)
			if openings != null and not (openings is Array):
				errors.append("occluders[%d].openings 必须是数组" % i)
			elif openings is Array:
				for j in (openings as Array).size():
					var opening: Variant = (openings as Array)[j]
					if not (opening is Dictionary):
						errors.append("occluders[%d].openings[%d] 不是对象" % [i, j])
						continue
					var entry := opening as Dictionary
					for key in ["type", "center", "half_size", "h_low", "h_top"]:
						if not entry.has(key):
							errors.append("occluders[%d].openings[%d] 缺字段 %s" % [i, j, key])
					if entry.has("type") \
							and not JieyuMapSpec.OPENING_KINDS.has(str(entry["type"])):
						errors.append("occluders[%d].openings[%d].type 只能是 %s"
								% [i, j, str(JieyuMapSpec.OPENING_KINDS)])
	return errors


static func _read_json(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	return parsed


static func _write_json(path: String, data: Variant) -> Error:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path).get_base_dir())
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[JieyuMapDoc] 写不了 %s" % path)
		return ERR_FILE_CANT_WRITE
	file.store_string(JSON.stringify(data, "  ", true, true))
	file.close()
	return OK


## 把 PackedByteArray / Image 统一成单通道字节视图（长度对不上就返回空数组）
static func _as_byte_view(payload: Variant) -> PackedByteArray:
	if payload is PackedByteArray:
		return payload
	if payload is Image:
		var img := (payload as Image).duplicate() as Image
		if img.get_format() != Image.FORMAT_L8:
			img.convert(Image.FORMAT_L8)
		return img.get_data()
	return PackedByteArray()


## ────────────── 落盘 ──────────────

## 写全量产物。返回错误码；OK 时 warnings 里是「写完了但有话说」
func save(map_id_override: String = "") -> Error:
	var id := map_id_override if not map_id_override.is_empty() else map_id
	if id.is_empty():
		push_error("[JieyuMapDoc] map_id 为空，拒绝保存")
		return ERR_INVALID_PARAMETER
	width = width if width > 0 else int(meta.get("grid", GameConfig.GRID_WIDTH))
	if not is_valid():
		push_error("[JieyuMapDoc] 文档尺寸非法（%d×%d / %d 字节）" % [width, height_px, height.size()])
		return ERR_INVALID_DATA
	map_id = id
	meta["map_id"] = id
	meta["grid"] = width
	meta["size_m"] = [float(width), float(height_px)]
	warnings.clear()

	var dir := JieyuMapSpec.map_dir(id)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	DirAccess.make_dir_recursive_absolute(
			ProjectSettings.globalize_path(dir + JieyuMapSpec.LAYER_DIR_NAME))

	var image := Image.create_from_data(width, height_px, false, Image.FORMAT_L8, height)
	var err := image.save_png(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_HEIGHTMAP))
	if err != OK:
		push_error("[JieyuMapDoc] 高度图写入失败：%s" % error_string(err))
		return err

	# 审阅贴图：按高程分段着色（MapGenerator.TERRAIN_COLORS 的口径），不参与运行时高度
	var preview := JieyuMapRender.terrain_image(to_height_grid())
	err = preview.save_png(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_TERRAIN))
	if err != OK:
		warnings.append("审阅贴图 terrain.png 写入失败：%s" % error_string(err))

	err = _write_json(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_META), meta)
	if err != OK:
		return err
	err = _write_json(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_ZONES), zones)
	if err != OK:
		return err
	err = _write_json(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_OCCLUDERS), occluders)
	if err != OK:
		return err

	# 工作层（草稿）。值可以是 PackedByteArray（灰度层）或 Image（彩色层，如 content.png）
	for layer_name in layers.keys():
		var payload: Variant = layers[layer_name]
		if payload is Image:
			var direct: Image = payload
			if direct.get_width() == width and direct.get_height() == height_px:
				direct.save_png(JieyuMapSpec.layer_file_path(id, "%s.png" % layer_name))
			continue
		var view := _as_byte_view(payload)
		if view.size() != width * height_px:
			continue
		var layer_image := Image.create_from_data(width, height_px, false, Image.FORMAT_L8, view)
		layer_image.save_png(JieyuMapSpec.layer_file_path(id, "%s.png" % layer_name))
		# 内容材质图也按 12.8.1 的文件名放到地图根目录（工程侧按约定名找）
		if layer_name == "content_material":
			layer_image.save_png(JieyuMapSpec.file_path(id, JieyuMapSpec.FILE_MATERIAL))

	# 工程既有的「单张扁平高度图」入口也带上，方便直接改 Main 的 map_height_image 试跑
	image.save_png(JieyuMapSpec.DEFAULT_MAP_ROOT + id + "_height.png")
	return OK


## 读盘。目录里没有 heightmap.png 就返回 null
static func load_from_dir(map_id: String) -> JieyuMapDoc:
	var dir := JieyuMapSpec.map_dir(map_id)
	var height_path := JieyuMapSpec.file_path(map_id, JieyuMapSpec.FILE_HEIGHTMAP)
	var image: Image = null
	var absolute := ProjectSettings.globalize_path(height_path)
	if FileAccess.file_exists(height_path):
		image = Image.load_from_file(absolute)
	elif FileAccess.file_exists(absolute):
		image = Image.load_from_file(absolute)
	if image == null:
		push_error("[JieyuMapDoc] 读不到高度图：%s" % height_path)
		return null
	return from_image(map_id, image, dir)


## 从任意高度图（PNG / 内存 Image）建文档 —— 「把美术画的灰度图接手进插件编辑」
static func from_image(map_id: String, image: Image, source_dir: String = "") -> JieyuMapDoc:
	if image == null or image.get_width() <= 0:
		push_error("[JieyuMapDoc] 高度图为空")
		return null
	var doc := create(map_id, image.get_width(), image.get_height())
	# 与 HeightGrid.fill_from_image 同口径：先转 8 位单通道，再整块读
	var img := image.duplicate() as Image
	if img.get_format() != Image.FORMAT_L8:
		img.convert(Image.FORMAT_L8)
	doc.set_height_bytes(img.get_data())

	var meta_path := source_dir + JieyuMapSpec.FILE_META
	if not source_dir.is_empty() and FileAccess.file_exists(meta_path):
		var parsed: Variant = _read_json(meta_path)
		if parsed is Dictionary:
			for key in (parsed as Dictionary).keys():
				doc.meta[key] = (parsed as Dictionary)[key]
		else:
			doc.warnings.append("meta.json 解析失败，用默认 metadata")
	doc.meta["map_id"] = map_id
	doc.meta["grid"] = doc.width
	doc.meta["size_m"] = [float(doc.width), float(doc.height_px)]

	var zones_path := source_dir + JieyuMapSpec.FILE_ZONES
	if not source_dir.is_empty() and FileAccess.file_exists(zones_path):
		var parsed_zones: Variant = _read_json(zones_path)
		if parsed_zones is Dictionary:
			doc.zones = parsed_zones
		else:
			doc.warnings.append("zones.json 解析失败，按空 zones 处理")

	var occ_path := source_dir + JieyuMapSpec.FILE_OCCLUDERS
	if not source_dir.is_empty() and FileAccess.file_exists(occ_path):
		var parsed_occ: Variant = _read_json(occ_path)
		if parsed_occ is Array:
			doc.occluders = parsed_occ
		else:
			doc.warnings.append("occluders.json 解析失败，按空数组处理")

	for key in ["raas_nodes", "flags", "spawn_areas", "rally_zones"]:
		if not doc.zones.has(key):
			doc.zones[key] = []
	if doc.zones.get("flags", []).is_empty() and not doc.zones["raas_nodes"].is_empty():
		doc.warnings.append("zones.json 有节点但没有任何 flags —— 白旗点五结构是空的")
	doc.source_path = source_dir
	return doc


## 列出 res://assets/maps/ 下所有「带 heightmap.png 或 <id>_height.png 的地图目录」
static func list_map_dirs() -> Array[String]:
	var found: Array[String] = []
	var root := JieyuMapSpec.DEFAULT_MAP_ROOT
	var dir := DirAccess.open(root)
	if dir == null:
		return found
	for sub in dir.get_directories():
		if sub.begins_with("."):
			continue
		if FileAccess.file_exists(root + sub + "/" + JieyuMapSpec.FILE_HEIGHTMAP):
			found.append(sub)
	found.sort()
	return found


## 列出 res://assets/maps/ 下的单张扁平高度图（历史产物 <id>_height.png）
static func list_flat_height_maps() -> Array[String]:
	var found: Array[String] = []
	var dir := DirAccess.open(JieyuMapSpec.DEFAULT_MAP_ROOT)
	if dir == null:
		return found
	for file in dir.get_files():
		if file.ends_with("_height.png"):
			found.append(JieyuMapSpec.DEFAULT_MAP_ROOT + file)
	found.sort()
	return found
