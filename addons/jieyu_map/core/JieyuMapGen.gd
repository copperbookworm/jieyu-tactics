class_name JieyuMapGen
extends RefCounted

## 地图生成与自动布点（12.8.3 噪声基底 + 手工雕刻的自动化近似 + 六章指标约束）。
##
## 分工：本类只做「按配方算出字节 / 按指标挑位置」，不碰文件、不碰编辑器。
## 所有阈值都从 `JieyuMapSpec` 取，不在这里写第二份数字。
##
## 为什么要自动布点：设计流程里「二、纸面原型」与「三、灰盒验证」之间的来回最耗时，
## 自动布点把「先摆一版能跑的骨架」变成一次调用，人再在这版骨架上改。

## 布点打分权重（越大越优先）
const WEIGHT_FLATNESS := 3.0
const WEIGHT_ROAD := 1.5
const WEIGHT_ELEV_PENALTY := 2.0

## ────────────── 并行分块（2026-10-06 第七十九版 · 并行计算整改）──────────────
## 与工程侧 HeightGrid / MapGenerator 同一口径：低于阈值走单线程，小图并行只赔不赚。
const PARALLEL_MIN_CELLS := 262144
const PARALLEL_MAX_BANDS := 12
## 噪声分块脚手架
static var _gen_out := PackedByteArray()
static var _gen_layers: Array = []
static var _gen_seed := 0
static var _gen_total_amp := 0.0
static var _gen_ratio := 0.0
static var _gen_max_elev := 0.0
static var _gen_octaves := 4
static var _gen_lacunarity := 2.0
static var _gen_gain := 0.5
static var _gen_w := 0
static var _gen_h := 0
static var _gen_bands := 1
## 内容层分块脚手架
static var _content_doc = null
static var _content_recipe: Dictionary = {}
static var _content_max_elev := 0.0
static var _content_slope_limit := 0.0
static var _content_w := 0
static var _content_h := 0
static var _content_bands := 1
static var _content_rgb := PackedByteArray()
static var _content_l8 := PackedByteArray()
static var _rows_image_bytes := PackedByteArray()
static var _material_bytes := PackedByteArray()
static var _content_counts := PackedInt32Array()


## 分块数：chunks <= 0 = 自动（小图 1 块）
static func _bands(chunks: int, cells: int, rows: int) -> int:
	var bands := chunks
	if bands <= 0:
		bands = 1 if cells < PARALLEL_MIN_CELLS else clampi(OS.get_processor_count() - 1, 2, PARALLEL_MAX_BANDS)
	return clampi(bands, 1, maxi(rows, 1))


## 与 Image.set_pixel 同一条字节换算：uint8_t(CLAMP(v * 255.0, 0, 255))
static func _to_byte(v: float) -> int:
	return int(clampf(v * 255.0, 0.0, 255.0))


## ────────────── 1. 噪声基底（12.8.3）──────────────

## 生成高度字节。recipe 字段（全部可省）：
##   seed / octaves / lacunarity / gain / layers[{feature_m, amp_m}] / max_elevation_m
##   water_level_m（河谷水位）/ river_axis（"y"|"x"|""）/ river_center_ratio / river_half_width_m
static func generate_heights(recipe: Dictionary,
		grid_w: int = GameConfig.GRID_WIDTH,
		grid_h: int = GameConfig.GRID_HEIGHT,
		chunks: int = 0) -> PackedByteArray:
	var max_elev := float(recipe.get("max_elevation_m", GameConfig.MAX_ELEVATION))
	var seed_value := int(recipe.get("seed", GameConfig.DEFAULT_MAP_SEED))
	var noise_layers: Array = recipe.get("layers", JieyuMapSpec.NOISE_LAYERS)

	var total_amp := 0.0
	for layer_v in noise_layers:
		total_amp += float((layer_v as Dictionary).get("amp_m", 0.0))
	if noise_layers.is_empty() or is_zero_approx(total_amp):
		push_error("[JieyuMapGen] 噪声层为空，拒绝生成")
		var flat := PackedByteArray()
		flat.resize(grid_w * grid_h)
		flat.fill(0)
		return flat

	# 【2026-10-06 第七十九版 · 并行计算整改】400 万次采样按行分块并行；
	# 每个块各自 new 一套 FastNoiseLite（同一实例跨线程共用不是文档承诺的用法），参数与 seed 一致
	# ⇒ 逐格结果与串行相同。chunks <= 0 = 自动，显式 1 = 串行（等价性测试用）。
	_gen_layers = noise_layers
	_gen_seed = seed_value
	_gen_total_amp = total_amp
	_gen_ratio = max_elev / total_amp
	_gen_max_elev = max_elev
	_gen_octaves = int(recipe.get("octaves", JieyuMapSpec.NOISE_OCTAVES))
	_gen_lacunarity = float(recipe.get("lacunarity", JieyuMapSpec.NOISE_LACUNARITY))
	_gen_gain = float(recipe.get("gain", JieyuMapSpec.NOISE_GAIN))
	_gen_w = grid_w
	_gen_h = grid_h
	_gen_bands = _bands(chunks, grid_w * grid_h, grid_h)
	_gen_out = PackedByteArray()
	_gen_out.resize(grid_w * grid_h)
	if _gen_bands <= 1:
		_noise_band(0)
	else:
		var id := WorkerThreadPool.add_group_task(
				func(band: int) -> void: _noise_band(band),
				_gen_bands, _gen_bands, true, "map_noise")
		WorkerThreadPool.wait_for_group_task_completion(id)
	var data := _gen_out
	_gen_out = PackedByteArray()
	_carve_river(data, grid_w, grid_h, recipe, max_elev)
	return data


## 一个噪声分块（顺序与并行共用这一份实现 ⇒ 两条路径逐字节一致）
static func _noise_band(band: int) -> void:
	var rows := int(ceil(float(_gen_h) / float(_gen_bands)))
	var y0 := band * rows
	var y1 := mini(y0 + rows, _gen_h)
	if y0 >= y1:
		return
	var noises: Array[FastNoiseLite] = []
	for layer_v in _gen_layers:
		var layer: Dictionary = layer_v
		var noise := FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		noise.fractal_type = FastNoiseLite.FRACTAL_FBM
		noise.fractal_octaves = _gen_octaves
		noise.fractal_lacunarity = _gen_lacunarity
		noise.fractal_gain = _gen_gain
		noise.frequency = 1.0 / maxf(float(layer.get("feature_m", 100.0)), 1.0)
		noise.seed = _gen_seed
		noises.append(noise)
	for y in range(y0, y1):
		var row := y * _gen_w
		for x in _gen_w:
			var accumulated := 0.0
			for i in noises.size():
				accumulated += noises[i].get_noise_2d(float(x), float(y)) \
						* float((_gen_layers[i] as Dictionary).get("amp_m", 0.0))
			# 与 HeightGrid.fill_from_noise 同一条公式，保证「插件生成的基底 = 工程噪声地形」
			var value := clampf((accumulated + _gen_total_amp) * 0.5 * _gen_ratio, 0.0, _gen_max_elev)
			_gen_out[row + x] = JieyuMapSpec.height_to_gray(value, _gen_max_elev)


static func _carve_river(data: PackedByteArray, grid_w: int, grid_h: int,
		recipe: Dictionary, max_elev: float) -> void:
	var axis := str(recipe.get("river_axis", ""))
	if axis.is_empty():
		return
	var water_level := float(recipe.get("water_level_m", 0.0))
	if water_level <= 0.0:
		return
	var center_ratio := float(recipe.get("river_center_ratio", 0.5))
	var half_width := maxf(float(recipe.get("river_half_width_m", 30.0)), 1.0)
	var span := float(grid_h if axis == "y" else grid_w)
	var center := center_ratio * span
	for y in grid_h:
		for x in grid_w:
			var offset := absf(float(y if axis == "y" else x) - center)
			# 越靠近河道中心越往水位压；半宽外线性衰减，到两倍半宽处不再影响
			var weight := 1.0 - clampf((offset - half_width) / half_width, 0.0, 1.0)
			if weight <= 0.0:
				continue
			var index := y * grid_w + x
			var current := JieyuMapSpec.gray_to_height(data[index], max_elev)
			data[index] = JieyuMapSpec.height_to_gray(
					lerpf(current, water_level, weight * weight), max_elev)


## ────────────── 2. 从高度推可布点位置 ──────────────

## 局部坡度（度）。step 越大越接近「能不能摆一个建制」的尺度
static func slope_deg_at(data: PackedByteArray, grid_w: int, grid_h: int, max_elev: float,
		x: int, y: int, step: int = 8) -> float:
	var x1 := clampi(x + step, 0, grid_w - 1)
	var y1 := clampi(y + step, 0, grid_h - 1)
	var here := JieyuMapSpec.gray_to_height(data[y * grid_w + x], max_elev)
	var right := JieyuMapSpec.gray_to_height(data[y * grid_w + x1], max_elev)
	var down := JieyuMapSpec.gray_to_height(data[y1 * grid_w + x], max_elev)
	var run_x := float(x1 - x)
	var run_y := float(y1 - y)
	var slope_x := 0.0 if run_x <= 0.0 else rad_to_deg(atan2(absf(right - here), run_x))
	var slope_y := 0.0 if run_y <= 0.0 else rad_to_deg(atan2(absf(down - here), run_y))
	return maxf(slope_x, slope_y)


## 生成一张「可放置分数图」（越大越适合放节点 / 建筑）。
## 分数 = 平坦度 × 权重 + 道路邻近 × 权重 − 高程惩罚
static func buildability_map(data: PackedByteArray, grid_w: int, grid_h: int, max_elev: float,
		roads: Array = [], sample_step: int = 8) -> PackedFloat32Array:
	var cols := int(ceil(float(grid_w) / float(sample_step)))
	var rows := int(ceil(float(grid_h) / float(sample_step)))
	var scores := PackedFloat32Array()
	scores.resize(cols * rows)
	var slope_limit := maxf(JieyuMapSpec.vehicle_slope_limit(), 0.001)
	for row in rows:
		for col in cols:
			var x := mini(col * sample_step, grid_w - 1)
			var y := mini(row * sample_step, grid_h - 1)
			var slope := slope_deg_at(data, grid_w, grid_h, max_elev, x, y, sample_step)
			var flatness := clampf(1.0 - slope / slope_limit, 0.0, 1.0)
			var score := flatness * WEIGHT_FLATNESS
			if not roads.is_empty():
				var nearest := nearest_road_distance(roads, Vector2(x, y))
				score += WEIGHT_ROAD * clampf(1.0 - nearest / 150.0, 0.0, 1.0)
			var elev := JieyuMapSpec.gray_to_height(data[y * grid_w + x], max_elev)
			score -= WEIGHT_ELEV_PENALTY * clampf((elev - 90.0) / 60.0, 0.0, 1.0)
			scores[row * cols + col] = score
	return scores


static func nearest_road_distance(roads: Array, point: Vector2) -> float:
	var best := INF
	for road_v in roads:
		if not (road_v is Dictionary):
			continue
		var path: Array = (road_v as Dictionary).get("path", [])
		for i in range(1, path.size()):
			best = minf(best, distance_to_segment(point, vec2(path[i - 1]), vec2(path[i])))
	return 0.0 if is_inf(best) else best


static func distance_to_segment(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var length_sq := ab.length_squared()
	if length_sq < 0.0001:
		return p.distance_to(a)
	var t := clampf((p - a).dot(ab) / length_sq, 0.0, 1.0)
	return p.distance_to(a + ab * t)


## [x, y] / {"x","y"} / Vector2 → Vector2（zones.json 里的坐标是数组，这里统一收口）
static func vec2(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Array and (value as Array).size() >= 2:
		return Vector2(float((value as Array)[0]), float((value as Array)[1]))
	if value is Dictionary:
		var d: Dictionary = value
		return Vector2(float(d.get("x", 0.0)), float(d.get("y", 0.0)))
	return Vector2.ZERO


## 贪心挑点：按分数降序、满足 min_dist 就收下，直到收满 count 个
static func pick_spots(scores: PackedFloat32Array, cols: int, rows: int, sample_step: int,
		count: int, min_dist_m: float, min_score: float = 0.0) -> Array[Vector2]:
	var order: Array[int] = []
	for i in scores.size():
		if scores[i] >= min_score:
			order.append(i)
	order.sort_custom(func(a: int, b: int) -> bool: return scores[a] > scores[b])
	var chosen: Array[Vector2] = []
	for index in order:
		if chosen.size() >= count:
			break
		var point := Vector2(float(index % cols * sample_step), float(index / cols * sample_step))
		var ok := true
		for existing in chosen:
			if existing.distance_to(point) < min_dist_m:
				ok = false
				break
		if ok:
			chosen.append(point)
	return chosen


## ────────────── 3. 节点 / 白旗点五结构 / 出生区 ──────────────

## 按「折线骨架 + 平坦度微调 + 间距矫正」把 count 个节点摆到地图上。
## 默认走 12.8.4 的折线骨架：西侧起点 → 中央枢纽 → 东侧终点（不落在一条直线上）。
## 关键约束是六章的「占领点间距 200–500 m」——骨架只是初值，后面两步保证真的落在这个区间。
static func generate_nodes(doc: JieyuMapDoc, count: int = 5, seed_value: int = -1) -> Array:
	if count <= 0:
		return []
	var max_elev := doc.max_elevation()
	var sample_step := 10
	var scores := buildability_map(doc.height, doc.width, doc.height_px, max_elev, [], sample_step)
	var cols := int(ceil(float(doc.width) / float(sample_step)))
	var rows := int(ceil(float(doc.height_px) / float(sample_step)))
	var nodes: Array = []
	var margin := 70.0
	var left := margin
	var right := maxf(float(doc.width) - margin, margin + 10.0)
	var top := margin
	var bottom := maxf(float(doc.height_px) - margin, margin + 10.0)
	var mid_y := (top + bottom) * 0.5
	# 锯齿幅度取 20 m 与可用高度的 12% 之间的小者：锯齿会拉长段长，
	# 太长会把「相邻间距 ≤ 500 m」顶破（1000 图上振幅 30% 实测会到 572 m）。
	var amplitude := minf(20.0, (bottom - top) * 0.12)
	# 目标间距：横向均分（折线的水平跨距被图宽限制）
	var wanted_spacing := clampf((right - left) / float(maxi(count - 1, 1)),
			JieyuMapSpec.NODE_SPACING_MIN_M * 1.08, JieyuMapSpec.NODE_SPACING_MAX_M * 0.98)
	# 骨架：横向等分 + 上下小锯齿（制造绕行，但不改变间距口径）
	var top_row := mid_y - amplitude
	var bottom_row := mid_y + amplitude
	for i in count:
		var t := 0.0 if count <= 1 else float(i) / float(count - 1)
		var y := top_row if i % 2 == 0 else bottom_row
		if count > 2 and i == count / 2:
			y = mid_y   # 中央枢纽摆在中间高度，别贴边
		nodes.append(Vector2(left + (right - left) * t, y))

	# ① 骨架间距不够就整体拉伸（保证「间距达标」优先于「地形好看」）
	if count > 1:
		var skeleton_span := (nodes[0] as Vector2).distance_to(nodes[count - 1])
		var per_step := skeleton_span / float(count - 1)
		if per_step < JieyuMapSpec.NODE_SPACING_MIN_M * 1.05:
			var scale := JieyuMapSpec.NODE_SPACING_MIN_M * 1.05 / maxf(per_step, 0.001)
			var center := Vector2((left + right) * 0.5, mid_y)
			for i in nodes.size():
				nodes[i] = center + ((nodes[i] as Vector2) - center) * scale
		nodes = _clamp_nodes(nodes, doc, margin)

	# ② 再按地形微调（只在小范围内挪，不破坏间距）
	for i in nodes.size():
		var current: Vector2 = nodes[i]
		var refined := refine_position(scores, cols, rows, sample_step, current, 40.0)
		var offset := refined - current
		var limit := wanted_spacing * 0.15
		if offset.length() > limit:
			offset = offset.normalized() * limit
		nodes[i] = current + offset
	nodes = _clamp_nodes(nodes, doc, 40.0)

	# ③ 间距矫正：把还挤在一起的点沿连线推开（迭代有限次，收敛即可）
	for _pass in 12:
		var moved := false
		for i in nodes.size():
			for j in range(i + 1, nodes.size()):
				var a: Vector2 = nodes[i]
				var b: Vector2 = nodes[j]
				var delta := b - a
				var distance := delta.length()
				if distance < 0.01:
					# 两点重合：按编号给一个确定方向推开，不然除零会算出 NaN
					delta = Vector2(1.0, 0.0).rotated(float(i + j) * 0.7)
					distance = 0.01
				if distance >= JieyuMapSpec.NODE_SPACING_MIN_M * 1.06:
					continue
				var push := (JieyuMapSpec.NODE_SPACING_MIN_M * 1.08 - distance) * 0.5
				var unit := delta / distance
				nodes[i] = a - unit * push
				nodes[j] = b + unit * push
				moved = true
		nodes = _clamp_nodes(nodes, doc, 30.0)
		if not moved:
			break

	# ④ 段长夹回上限：地形微调可能把某一跳拉长（六章上限 500 m）
	for _shrink in 4:
		var shortened := false
		for i in range(nodes.size() - 1):
			var a: Vector2 = nodes[i]
			var b: Vector2 = nodes[i + 1]
			var step := a.distance_to(b)
			if step <= JieyuMapSpec.NODE_SPACING_MAX_M * 0.98:
				continue
			var unit := (b - a) / step
			var excess := step - JieyuMapSpec.NODE_SPACING_MAX_M * 0.98
			nodes[i + 1] = b - unit * excess
			shortened = true
		nodes = _clamp_nodes(nodes, doc, 30.0)
		if not shortened:
			break

	# ⑤ 收口：段长夹短之后可能又有一跳掉到下限以下 —— 再推一次并复核。
	# 这一步只保证「下限」，不动上限（下限破了才是 ERROR 级）。
	for _fix in 4:
		var fixed := false
		for i in range(nodes.size() - 1):
			var a: Vector2 = nodes[i]
			var b: Vector2 = nodes[i + 1]
			var step := a.distance_to(b)
			if step >= JieyuMapSpec.NODE_SPACING_MIN_M * 1.05:
				continue
			var unit := (b - a) / maxf(step, 0.001)
			var need := (JieyuMapSpec.NODE_SPACING_MIN_M * 1.08 - step) * 0.5
			nodes[i] = a - unit * need
			nodes[i + 1] = b + unit * need
			fixed = true
		nodes = _clamp_nodes(nodes, doc, 25.0)
		if not fixed:
			break

	var result: Array = []
	for i in nodes.size():
		var name := ""
		if i == 0:
			name = "西侧起点"
		elif i == count - 1:
			name = "东侧终点"
		elif i == count / 2:
			name = "中央枢纽"
		result.append({
			"id": "N%d" % (i + 1),
			"name": name,
			"pos": [roundi(nodes[i].x), roundi(nodes[i].y)],
		})
	return result


## 相邻节点间的最小直线距离（六章「占领点间距 200–500 m」是**相邻两点**的口径）
static func min_node_step(nodes: Array) -> float:
	var smallest := INF
	for i in range(nodes.size() - 1):
		smallest = minf(smallest, vec2((nodes[i] as Dictionary).get("pos", [0, 0])).distance_to(
				vec2((nodes[i + 1] as Dictionary).get("pos", [0, 0]))))
	return 0.0 if is_inf(smallest) else smallest


## 任意两点间的最小直线距离（用于「推进链会不会自相重叠」这类判断）
static func min_node_spacing(nodes: Array) -> float:
	var smallest := INF
	for i in nodes.size():
		for j in range(i + 1, nodes.size()):
			smallest = minf(smallest, vec2((nodes[i] as Dictionary).get("pos", [0, 0])).distance_to(
					vec2((nodes[j] as Dictionary).get("pos", [0, 0]))))
	return 0.0 if is_inf(smallest) else smallest


## 把节点坐标压回 [margin, 尺寸-margin] 之内（间距矫正会把点推出地图）
static func _clamp_nodes(nodes: Array, doc: JieyuMapDoc, margin: float) -> Array:
	var result: Array = []
	for i in nodes.size():
		var point: Vector2 = nodes[i]
		result.append(Vector2(
				clampf(point.x, margin, float(doc.width) - margin),
				clampf(point.y, margin, float(doc.height_px) - margin)))
	return result


## 在目标位置附近找分数最高的格（半径内搜索）
static func refine_position(scores: PackedFloat32Array, cols: int, rows: int, sample_step: int,
		target: Vector2, radius_m: float) -> Vector2:
	var best := target
	var best_score := -INF
	var cell_radius := int(ceil(radius_m / float(sample_step)))
	var col0 := int(target.x) / sample_step
	var row0 := int(target.y) / sample_step
	for dy in range(-cell_radius, cell_radius + 1):
		for dx in range(-cell_radius, cell_radius + 1):
			var col := col0 + dx
			var row := row0 + dy
			if col < 0 or row < 0 or col >= cols or row >= rows:
				continue
			var score := scores[row * cols + col]
			if score > best_score:
				best_score = score
				best = Vector2(float(col * sample_step), float(row * sample_step))
	return best


## 把节点列表变成完整的 zones（五节点 × 五结构 + 两个出生区 + 集结点可用区）
static func build_zones(nodes: Array, grid_w: int, grid_h: int,
		seed_value: int = -1) -> Dictionary:
	var zones := JieyuMapDoc.empty_zones()
	var flags: Array = []
	for i in nodes.size():
		var node: Dictionary = nodes[i]
		var pos := vec2(node.get("pos", [0, 0]))
		var node_id := str(node.get("id", "N%d" % (i + 1)))
		zones["raas_nodes"].append({
			"id": node_id,
			"name": str(node.get("name", "")),
			"pos": [float(pos.x), float(pos.y)],
		})
		flags.append({
			"node": node_id,
			"side": "west" if i * 2 < nodes.size() else "east",
			"core_radius_m": JieyuMapSpec.CORE_RADIUS_M,
			"pressure_ring_m": [JieyuMapSpec.PRESSURE_RING_M[0],
					JieyuMapSpec.PRESSURE_RING_M[1]],
			"approach_routes": JieyuMapSpec.RECOMMENDED_APPROACH_ROUTES,
			"spawn_offset_m": [JieyuMapSpec.SPAWN_OFFSET_M[0], JieyuMapSpec.SPAWN_OFFSET_M[1]],
		})
	zones["flags"] = flags
	zones["spawn_areas"] = _default_spawn_areas(grid_w, grid_h)
	zones["rally_zones"] = _default_rally_zones(nodes)
	return zones


## 两个出生区：贴西 / 贴东边缘的矩形（4.4 出生点是心脏，别放枪口下）
static func _default_spawn_areas(grid_w: int, grid_h: int) -> Array:
	var inset := 40.0
	var band := 90.0
	var top := float(grid_h) * 0.30
	var bottom := float(grid_h) * 0.70
	return [
		{
			"side": "west",
			"polygon": [
				[inset, top], [inset + band, top],
				[inset + band, bottom], [inset, bottom],
			],
		},
		{
			"side": "east",
			"polygon": [
				[float(grid_w) - inset - band, top], [float(grid_w) - inset, top],
				[float(grid_w) - inset, bottom], [float(grid_w) - inset - band, bottom],
			],
		},
	]


## 每个节点一个集结点可用区（点外、离核心 ≥ 100 m 的一圈）
static func _default_rally_zones(nodes: Array) -> Array:
	var result: Array = []
	var inner := JieyuMapSpec.MIN_DIST_TO_CORE_M
	var outer := inner + 120.0
	var segments := 8
	for i in nodes.size():
		var pos := vec2((nodes[i] as Dictionary).get("pos", [0, 0]))
		var ring: Array = []
		for s in segments:
			var angle := TAU * float(s) / float(segments)
			ring.append([roundi(pos.x + cos(angle) * outer), roundi(pos.y + sin(angle) * outer)])
		result.append({
			"node": str((nodes[i] as Dictionary).get("id", "N%d" % (i + 1))),
			"allowed_polygon": ring,
			"min_dist_to_core_m": inner,
		})
	return result


## ────────────── 4. 建筑群 / 掩体 ──────────────

## 在节点外围压制圈附近摆建筑群（12.8.4「白旗点周边掩体」的自动近似）。
## 返回 12.8.7 口径的 occluders 数组。
static func place_settlements(doc: JieyuMapDoc, zones: Dictionary, recipe: Dictionary,
		seed_value: int = -1) -> Array:
	var max_elev := doc.max_elevation()
	var sample_step := 8
	var scores := buildability_map(doc.height, doc.width, doc.height_px, max_elev,
			recipe.get("roads", []), sample_step)
	var cols := int(ceil(float(doc.width) / float(sample_step)))
	var rows := int(ceil(float(doc.height_px) / float(sample_step)))
	var rng := RandomNumberGenerator.new()
	rng.seed = (seed_value if seed_value > 0 else GameConfig.DEFAULT_MAP_SEED) + 977

	var occluders: Array = []
	var wall_index := 0
	var nodes: Array = zones.get("raas_nodes", [])
	var groups := int(recipe.get("settlement_groups", 0))
	if groups <= 0:
		groups = 1 if nodes.is_empty() else maxi(1, int(nodes.size() * 0.6))
	var buildings_per_group := int(recipe.get("buildings_per_group", 7))
	# 2026-10-04：配方可以给**显式建筑群锚点**（settlements[]）。
	# 为什么需要：自动布点只保证「避开核心区 + 落在可建地」，
	# 保证不了六章的「最长无掩体可通行直线 ≤ 300 m」—— 实测青岭走廊第一版在东北角
	# 留了一条 620 m 的横向开阔带。这条指标只有地图作者能靠「在这儿摆一撮房子」满足。
	# settlements 与自动锚点是**替换**关系（给了就不跑自动选择），不是叠加。
	var explicit_settlements: Array = recipe.get("settlements", [])
	if not explicit_settlements.is_empty():
		for entry_v in explicit_settlements:
			var entry: Dictionary = entry_v
			_place_buildings(occluders, doc, nodes, vec2(entry.get("pos", [0, 0])),
					int(entry.get("buildings", buildings_per_group)),
					maxf(float(entry.get("spread_m", 60.0)), JieyuMapSpec.URBAN_SPACING_MIN_M),
					rng)
	else:
		for g in groups:
			var anchor := _pick_settlement_anchor(scores, cols, rows, sample_step, nodes, g, rng)
			if anchor.x < 0.0:
				continue
			_place_buildings(occluders, doc, nodes, anchor, buildings_per_group,
					JieyuMapSpec.URBAN_SPACING_MAX_M * float(buildings_per_group) * 0.8, rng)
	# 沿节点外围再撒一圈半高墙（0.5–2 m：人高掩体，可由高程或遮挡层承担）
	for node_v in nodes:
		var pos := vec2((node_v as Dictionary).get("pos", [0, 0]))
		for i in 6:
			var angle := TAU * float(i) / 6.0 + rng.randf() * 0.4
			var ring_radius := rng.randf_range(JieyuMapSpec.PRESSURE_RING_M[0],
					JieyuMapSpec.PRESSURE_RING_M[1] * 0.5)
			var center := pos + Vector2(cos(angle), sin(angle)) * ring_radius
			if center.x < 8.0 or center.y < 8.0 \
					or center.x > float(doc.width) - 8.0 \
					or center.y > float(doc.height_px) - 8.0:
				continue
			if not _far_enough(occluders, center):
				continue
			wall_index += 1
			var wall_half_x := float(roundi(rng.randf_range(2.5, 5.0)))
			var wall_half_y := float(roundi(rng.randf_range(1.0, 1.8)))
			# 半高墙 = 沙袋类：文档 4.17 / 20.5 给了明文耐久 200（与工程 GameConfig.COVER_HP 同值），
			# 这是整份文档里**唯一**有据可依的可摧毁物件血量。
			occluders.append({
				"id": "wall_%02d" % wall_index,
				"type": "wall",
				"polygon": rect_polygon(center, wall_half_x, wall_half_y),
				"h_low": 0.0,
				"h_top": roundf(rng.randf_range(0.8, 2.0) * 10.0) / 10.0,
				"destructible": JieyuMapSpec.DEFAULT_DESTRUCTIBLE,
				"hp": JieyuMapSpec.SANDBAG_HP,
				# 沙袋/半高墙**吃子弹伤害**（4.17 / 20.5：耐久 200，打光退出 occluder 组）
				"absorbs_bullets": true,
				# 4.6 铁律「不能完全封闭、必须留有暴露面」⇒ 半高墙默认留一条缝
				"openings": default_openings_for_wall(wall_half_x, wall_half_y),
			})
	# 2026-10-04：配方可给**显式半高墙 / 田埂**（walls[]，每条 {pos, half_size, h_top}）。
	# 为什么需要：六章的「每 150–200 m 打断长视线」在一张开阔的 1 km 图上，
	# 光靠建筑群（8–14 m 见方、簇状分布）补不齐 —— 田埂 / 沙袋线是更轻的一档：
	# 只挡视线与子弹、不阻挡人员通行（4.17），而且它同样进 covered 栅格。
	var explicit_walls: Array = recipe.get("walls", [])
	for wall_v in explicit_walls:
		var wall_entry: Dictionary = wall_v
		var wall_center := vec2(wall_entry.get("pos", [0, 0]))
		var wall_half := vec2(wall_entry.get("half_size", [4.0, 1.5]))
		if wall_center.x - wall_half.x < 8.0 or wall_center.y - wall_half.y < 8.0 \
				or wall_center.x + wall_half.x > float(doc.width) - 8.0 \
				or wall_center.y + wall_half.y > float(doc.height_px) - 8.0:
			continue
		if not _far_enough(occluders, wall_center):
			continue
		wall_index += 1
		occluders.append({
			"id": "wall_%02d" % wall_index,
			"type": "wall",
			"polygon": rect_polygon(wall_center, wall_half.x, wall_half.y),
			"h_low": 0.0,
			"h_top": float(wall_entry.get("h_top", 1.2)),
			"destructible": JieyuMapSpec.DEFAULT_DESTRUCTIBLE,
			"hp": JieyuMapSpec.SANDBAG_HP,
			"absorbs_bullets": true,
			"openings": default_openings_for_wall(wall_half.x, wall_half.y),
		})
	_apply_damage_profiles(occluders)
	return occluders


## 六章：遮挡体间距 ≥ 5 m（校验器按**中心距**判；贴在一起会穿模、也会堵死枪线）。
## 自动散点很容易撞出几对 —— 实测青岭走廊第一版 6 对 <5 m。落笔前统一在这里挡掉。
## 建筑、节点外围沙袋圈、显式田埂三条路径都要过它，否则「建筑 vs 沙袋」还是会贴在一起。
static func _far_enough(occluders: Array, center: Vector2) -> bool:
	for item_v in occluders:
		var polygon: Variant = (item_v as Dictionary).get("polygon", null)
		if not (polygon is Array) or (polygon as Array).size() < 3:
			continue
		var sum := Vector2.ZERO
		for point_v in polygon:
			sum += vec2(point_v)
		if (sum / float((polygon as Array).size())).distance_to(center) \
				< JieyuMapSpec.URBAN_SPACING_MIN_M:
			return false
	return true


## 在锚点周围撒一撮建筑（自动布点与显式 settlements[] 共用的一段）。
## 三条硬约束都在这里：① 不越图边 15 m；② 不落进任何节点核心区（core + 5 m，4.2 / 六章）；
## ③ 矩形中心先取整再用（rect_polygon 的口径，开口才不会漂到墙外）。
## spread_m 是撒点半径上限；自动锚点用「建筑数 × 15 m × 0.8」，显式锚点由配方给。
## 【2026-10-06 第七十九版】**本函数保持单线程**（并行计算整改里唯一"明知可并行但不做"的一处）：
## 每个候选点的取舍依赖前面已经放下的 occluders（_far_enough 扫累积列表）与共享 rng 的推进顺序，
## 并行会同时改变「放哪些」与「放在哪」⇒ 生成结果不可复现、与已有的地图资产对不上。
## 要提速得先换算法（空间索引 + 派生式 RNG），那是另一件事，不在本轮。
static func _place_buildings(occluders: Array, doc: JieyuMapDoc, nodes: Array,
		anchor: Vector2, count: int, spread_m: float, rng: RandomNumberGenerator) -> int:
	var placed := 0
	var attempts := 0
	while placed < count and attempts < count * 30:
		attempts += 1
		var angle := rng.randf() * TAU
		var radius := rng.randf_range(JieyuMapSpec.URBAN_SPACING_MIN_M, spread_m)
		var center := anchor + Vector2(cos(angle), sin(angle)) * radius
		if center.x < 15.0 or center.y < 15.0 \
				or center.x > float(doc.width) - 15.0 \
				or center.y > float(doc.height_px) - 15.0:
			continue
		var near_core := false
		for node_v in nodes:
			if vec2((node_v as Dictionary).get("pos", [0, 0])).distance_to(center) \
					< JieyuMapSpec.CORE_RADIUS_M + 5.0:
				near_core = true
				break
		if near_core:
			continue   # 4.2 / 六章：核心占领区不堆建筑，别把判定器变迷宫
		if not _far_enough(occluders, center):
			continue
		var half_x := float(roundi(rng.randf_range(4.0, 7.0)))
		var half_y := float(roundi(rng.randf_range(4.0, 7.0)))
		occluders.append({
			"id": "building_%02d" % (occluders.size() + 1),
			"type": "building",
			"polygon": rect_polygon(center, half_x, half_y),
			"h_low": 0.0,
			# 顶高取六章的「掩体密度分级：间距 5–15 m、高 1.5–3 m（城市 / 建筑群）」
			# —— 这对常量（BUILDING_H_LOW_M / BUILDING_H_TOP_M）以前只在校验器的说明文字里用，
			# 生成器自己却写 3–6 m，等于校验器替工程说了一句假话。2026-10-04 对齐。
			"h_top": roundf(rng.randf_range(JieyuMapSpec.BUILDING_H_LOW_M,
					JieyuMapSpec.BUILDING_H_TOP_M) * 10.0) / 10.0,
			# 2026-10-03 拍板①：一律 destructible = true；
			# 拍板②：结构值按占地 tiering（小屋 800 / 标准 1200 / 加固 3000），
			# 锚点与工程的 FOB 结构值同档（1200）。
			"destructible": JieyuMapSpec.DEFAULT_DESTRUCTIBLE,
			"hp": building_hp_for_footprint(half_x * 2.0, half_y * 2.0),
			# 2026-10-03 拍板「普通子弹对建筑伤害恒为 0」：建筑不吃子弹伤害，
			# 只吃弹种口径的结构伤害（structure_damage 列）。
			"absorbs_bullets": false,
			# 拍板①开口：默认一窗一门（六章「每个占领点 3 个以上入口/射击窗」）
			"openings": default_openings_for(half_x, half_y),
		})
		placed += 1
	return placed


## 建筑结构值：按占地分三档（拍板②的「标准档 1200」）
##   < 60 m²  → 小屋 / 哨所 800
##   < 200 m² → 标准建筑 1200（锚点，与 FOB 同档）
##   ≥ 200 m² → 加固 / 多层 3000
## 为什么按占地而不是按类型名：类型名是自由文本（12.8.7 只约束了 wall / building…），
## 靠它分档迟早写错；占地是几何事实，插件与地图作者都能一眼算出来。
static func building_hp_for_footprint(width_m: float, depth_m: float) -> float:
	var footprint := absf(width_m) * absf(depth_m)
	if footprint < 60.0:
		return JieyuMapSpec.STRUCTURE_HP_SMALL
	if footprint < 200.0:
		return JieyuMapSpec.STRUCTURE_HP_HOUSE
	return JieyuMapSpec.STRUCTURE_HP_REINFORCED


## 给每条可摧毁的遮挡体补上三段阈值（拍板④）。
## 形态固定成三行，工程侧照表读即可，不需要懂怎么算出来的：
##   intact    —— 耐久比 > damaged_below_ratio
##   damaged   —— h_top × damaged_height_scale（挡视线的缝变大）
##   destroyed —— h_top × 0（退出遮挡），并留一圈残痕
static func _apply_damage_profiles(occluders: Array) -> void:
	for item_v in occluders:
		var item: Dictionary = item_v
		if not bool(item.get("destructible", false)):
			continue
		var is_building := str(item.get("type", "")) == "building"
		item["damage_profiles"] = damage_profiles_for(is_building)


## 三段阈值表（building = true 时受损顶高比例取 0.60，否则取 0.45）
static func damage_profiles_for(is_building: bool) -> Array:
	var damaged_scale := JieyuMapSpec.DAMAGE_BUILDING_DAMAGED_HEIGHT_SCALE if is_building \
			else JieyuMapSpec.DAMAGE_DEFAULT_DAMAGED_HEIGHT_SCALE
	return [
		{
			"state": JieyuMapSpec.DAMAGE_STATE_INTACT,
			"damaged_below_ratio": JieyuMapSpec.DAMAGE_DEFAULT_DAMAGED_BELOW_RATIO,
			"height_scale": 1.0,
			"blocks_sight": true,
		},
		{
			"state": JieyuMapSpec.DAMAGE_STATE_DAMAGED,
			"damaged_below_ratio": 0.0,
			"height_scale": damaged_scale,
			"blocks_sight": true,
		},
		{
			"state": JieyuMapSpec.DAMAGE_STATE_DESTROYED,
			"damaged_below_ratio": -1.0,
			"height_scale": JieyuMapSpec.DAMAGE_DEFAULT_DESTROYED_HEIGHT_SCALE,
			"blocks_sight": false,
			"rubble": {
				"material_id": JieyuMapSpec.RUBBLE_MATERIAL_ID,
				"radius_scale": JieyuMapSpec.RUBBLE_RADIUS_SCALE,
				"speed_scale": JieyuMapSpec.RUBBLE_SPEED_SCALE,
			},
		},
	]


## 给一栋新建筑生成默认开口（拍板①：只有打中开口才伤得到里面；
## 六章「每个占领点 3 个以上入口/射击窗」⇒ 默认给 2 个，校验器会把少于 2 个的报出来）。
## 摆在「较长的那一对边」的中段、两边各一个 —— 保证有两条不同方向的进入/射击路线。
## h_top = 0 是约定值：表示「到掩体顶」（工程侧读到 0 就取顶高），免得写字面高度后与 h_top 打架。
static func default_openings_for(half_x: float, half_y: float) -> Array:
	var half_w := JieyuMapSpec.WINDOW_HALF_WIDTH
	var half_t := JieyuMapSpec.OPENING_HALF_THICKNESS
	var door_w := JieyuMapSpec.DOOR_HALF_WIDTH
	if half_x >= half_y:
		return [
			{"type": JieyuMapSpec.OPENING_WINDOW, "center": [0.0, -half_y],
				"half_size": [half_w, half_t], "h_low": JieyuMapSpec.WINDOW_SILL_M, "h_top": 0.0},
			{"type": JieyuMapSpec.OPENING_DOOR, "center": [0.0, half_y],
				"half_size": [door_w, half_t], "h_low": JieyuMapSpec.DOOR_SILL_M, "h_top": 0.0},
		]
	return [
		{"type": JieyuMapSpec.OPENING_WINDOW, "center": [-half_x, 0.0],
			"half_size": [half_t, half_w], "h_low": JieyuMapSpec.WINDOW_SILL_M, "h_top": 0.0},
		{"type": JieyuMapSpec.OPENING_DOOR, "center": [half_x, 0.0],
			"half_size": [half_t, door_w], "h_low": JieyuMapSpec.DOOR_SILL_M, "h_top": 0.0},
	]


## 给一段半高墙（沙袋类）生成一个开口 —— 4.6 的铁律是「不能完全封闭、必须留有暴露面」，
## 所以默认给一条缝；不想要缝就在插件里用「删开口」工具去掉。
## ⚠ 缝的跨墙厚必须**跟着墙厚走**（取墙厚的一半）：写死 0.6 会在薄墙（半厚 1.0）上
## 悬到墙外去 —— 校验器会报「没贴在墙面上」，实测第一版就是这个毛病。
static func default_openings_for_wall(half_x: float, half_y: float) -> Array:
	var along_x := half_x >= half_y
	var span := half_x if along_x else half_y
	var thickness_axis := half_y if along_x else half_x
	var half_w := minf(JieyuMapSpec.DOOR_HALF_WIDTH, span * 0.6)
	var half_t := minf(JieyuMapSpec.OPENING_HALF_THICKNESS, thickness_axis * 0.5)
	return [{
		"type": JieyuMapSpec.OPENING_DOOR,
		"center": [0.0, -half_y] if along_x else [-half_x, 0.0],
		"half_size": [half_w, half_t] if along_x else [half_t, half_w],
		"h_low": 0.0,
		"h_top": 0.0,
	}]


## 轴对齐矩形多边形（12.8.7 polygon 用 [x, y] 数组）。
## ⚠ 中心**先取整再用**：这样「多边形坐标的取整中心」与「origin 的名义中心」严格相等，
## 开口（openings 的本地坐标就是相对 origin 的名义中心）才不会漂到墙外去。
## 历史坑：中心取整、半宽不取整 ⇒ 两者错开最多 0.5 m ⇒ 校验器报「开口没贴在墙面上」。
static func rect_polygon(center: Vector2, half_x: float, half_y: float) -> Array:
	var cx := roundi(center.x)
	var cy := roundi(center.y)
	return [
		[cx - roundi(half_x), cy - roundi(half_y)],
		[cx + roundi(half_x), cy - roundi(half_y)],
		[cx + roundi(half_x), cy + roundi(half_y)],
		[cx - roundi(half_x), cy + roundi(half_y)],
	]


## 挑建筑群基地：偏向侧翼、离节点不远不近、且本身可建
static func _pick_settlement_anchor(scores: PackedFloat32Array, cols: int, rows: int,
		sample_step: int, nodes: Array, group_index: int,
		rng: RandomNumberGenerator) -> Vector2:
	var best := Vector2(-1.0, -1.0)
	var best_score := -INF
	for row in rows:
		for col in cols:
			var point := Vector2(float(col * sample_step), float(row * sample_step))
			var score := scores[row * cols + col]
			var nearest := INF
			for node_v in nodes:
				nearest = minf(nearest,
						vec2((node_v as Dictionary).get("pos", [0, 0])).distance_to(point))
			# 离节点太近（核心区）扣分，太远（没战术价值）也扣分
			score -= clampf((JieyuMapSpec.PRESSURE_RING_M[1] * 1.5 - nearest) / 100.0, 0.0, 3.0)
			score -= clampf((nearest - 400.0) / 200.0, 0.0, 2.0)
			score += float((col + group_index * 3 + rng.randi_range(0, 2)) % 7) * 0.05
			if score > best_score:
				best_score = score
				best = point
	return best


## 道路折线：两点之间加正弦摆动的中间点（道路要绕，别一条直线）
static func path_between(a: Vector2, b: Vector2, segments: int = 8,
		amplitude_m: float = 60.0, phase_index: int = 0) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var span := b - a
	if span.length() < 1.0:
		return [a, b]
	var normal := Vector2(-span.y, span.x).normalized()
	var phase := float(phase_index % 7) * 0.7
	for i in segments + 1:
		var t := float(i) / float(segments)
		var offset := sin(t * PI * 2.0 + phase) * amplitude_m * sin(t * PI)
		points.append(a + span * t + normal * offset)
	return points


## ────────────── 5. 内容层图（4.17）──────────────

## 4.17 环境互动区的配色（行序方案里工程侧按同色像素分段，所以每行必须纯色）
## 第四色是瓦砾残痕（material id 4）—— 它不在内容层图里生成，只给工程侧的取值留位。
const CONTENT_COLORS := [
	Color8(107, 82, 51),    # 0 泥泞
	Color8(240, 245, 255),  # 1 雪地
	Color8(61, 133, 61),    # 2 草丛
	Color8(120, 112, 100),  # 3 瓦砾（残痕）
]
## kind（0 泥泞 / 1 雪地 / 2 草丛）→ material.png 的 id（1 / 2 / 3）
const CONTENT_MATERIAL_IDS := [1, 2, 3]


## 生成 content.png（按行序排 N 片区域）与 material.png（单通道 id 图）。
## 判据：低洼 → 泥泞；高海拔 → 雪地；中低海拔 → 草丛；超过坡度阈值的坡面上不生成。
## 返回 {"rows": Image, "material": Image, "counts": [三种各多少格]}
## 返回 {"rows": Image, "material": Image, "counts": [三种各多少格]}；chunks <= 0 = 自动
static func build_content_images(doc: JieyuMapDoc, recipe: Dictionary = {},
		chunks: int = 0) -> Dictionary:
	var w: int = doc.width
	var hp: int = doc.height_px
	# 【2026-10-06 第七十九版 · 并行计算整改】100 万像素按行分块并行；
	# 先写字节、主线程一次 create_from_data（旧实现是逐像素 set_pixel）。
	# ⚠ 每一块的计数写进 _content_counts 自己的槽位（band*8 + kind），主线程最后求和 ——
	#   共享同一个累加器会因为 Packed 数组的 copy-on-write 而丢数（见 docs/性能预算.md 第二十八节）。
	_content_doc = doc
	_content_recipe = recipe
	_content_max_elev = doc.max_elevation()
	_content_slope_limit = JieyuMapSpec.vehicle_slope_limit()
	_content_w = w
	_content_h = hp
	_content_bands = _bands(chunks, w * hp, hp)
	_content_rgb = _content_rgb_lut()
	_content_l8 = _content_l8_lut()
	_rows_image_bytes = PackedByteArray()
	_rows_image_bytes.resize(w * hp * 3)
	_material_bytes = PackedByteArray()
	_material_bytes.resize(w * hp)
	_content_counts = PackedInt32Array()
	_content_counts.resize(_content_bands * 8)
	if _content_bands <= 1:
		_content_rows(0)
	else:
		var id := WorkerThreadPool.add_group_task(
				func(band: int) -> void: _content_rows(band),
				_content_bands, _content_bands, true, "map_content")
		WorkerThreadPool.wait_for_group_task_completion(id)
	var counts := [0, 0, 0]
	for band in _content_bands:
		for k in 3:
			counts[k] += _content_counts[band * 8 + k]
	var rows_image := Image.create_from_data(w, hp, false, Image.FORMAT_RGB8, _rows_image_bytes)
	var material := Image.create_from_data(w, hp, false, Image.FORMAT_L8, _material_bytes)
	_rows_image_bytes = PackedByteArray()
	_material_bytes = PackedByteArray()
	return {"rows": rows_image, "material": material, "counts": counts}


## 内容层的一个分块（顺序与并行共用 ⇒ 逐字节一致）；y0/y1 由 _content_bands 决定
static func _content_rows(band: int) -> void:
	var w := _content_w
	var rows := int(ceil(float(_content_h) / float(_content_bands)))
	var y0 := band * rows
	var y1 := mini(y0 + rows, _content_h)
	if y0 >= y1:
		return
	var doc = _content_doc
	var recipe := _content_recipe
	var max_elev := _content_max_elev
	var mud_max_ratio := float(recipe.get("mud_max_ratio", 0.10))
	var snow_min_ratio := float(recipe.get("snow_min_ratio", 0.62))
	var grass_max_ratio := float(recipe.get("grass_max_ratio", 0.55))
	var slope_limit := _content_slope_limit
	var rgb := _content_rgb
	var l8 := _content_l8
	var count_base := band * 8
	for y in range(y0, y1):
		for x in w:
			var ratio: float = doc.height_at(x, y) / maxf(max_elev, 0.001)
			if slope_deg_at(doc.height, doc.width, doc.height_px, max_elev, x, y, 4) > slope_limit:
				continue
			# 确定性打点，避免大片纯色看起来像贴图错误（同一张图每次生成结果一致）
			var speckle := sin(float(x) * 12.9898 + float(y) * 78.233) * 43758.5453
			var noise01 := speckle - floorf(speckle)
			var kind := -1
			var keep_chance := 0.65
			if ratio <= mud_max_ratio:
				kind = 0
			elif ratio >= snow_min_ratio:
				kind = 1
			elif ratio <= grass_max_ratio:
				kind = 2
				keep_chance = 0.55
			if kind < 0 or noise01 > keep_chance:
				continue
			_content_counts[count_base + kind] += 1
			var index := y * w + x
			_material_bytes[index] = l8[kind]
			var o := index * 3
			_rows_image_bytes[o] = rgb[kind * 3]
			_rows_image_bytes[o + 1] = rgb[kind * 3 + 1]
			_rows_image_bytes[o + 2] = rgb[kind * 3 + 2]


## 内容层配色 / id 的字节 LUT（从 CONTENT_COLORS / CONTENT_MATERIAL_IDS 派生，避免漂移）
static func _content_rgb_lut() -> PackedByteArray:
	if _content_rgb.size() == CONTENT_COLORS.size() * 3 and _content_rgb.size() > 0:
		return _content_rgb
	_content_rgb = PackedByteArray()
	for c in CONTENT_COLORS:
		_content_rgb.append(_to_byte(c.r))
		_content_rgb.append(_to_byte(c.g))
		_content_rgb.append(_to_byte(c.b))
	return _content_rgb


static func _content_l8_lut() -> PackedByteArray:
	if _content_l8.size() == CONTENT_MATERIAL_IDS.size() and _content_l8.size() > 0:
		return _content_l8
	_content_l8 = PackedByteArray()
	for id in CONTENT_MATERIAL_IDS:
		_content_l8.append(_to_byte(Color8(id, id, id).r))
	return _content_l8


## meta.json 的 content_layers 声明（12.8.7 之外的扩展字段，工程侧没有就静默跳过）
static func content_layer_meta(rows_file: String = "", material_file: String = "") -> Dictionary:
	return {
		"name": "terrain_content",
		"rows_file": rows_file,
		"material_file": material_file,
		"merge_mode": "max_conceal",
	}


## ────────────── 6. 一键：配方 → 完整文档 ──────────────

## 从配方生成一张完整地图（高度 + 五节点 + 五结构 + 出生区 + 建筑 + 内容层）。
## 返回的 doc.warnings 里是「生成完了但有话说」。
## ────────────── 出生区落脚地（12.8.4 续航区 · 2026-10-05 补）──────────────
##
## 背景：生成器原来只压平**节点核心**，不压平出生区；而校验器的出生区检查只看多边形**顶点**的坡度
## （四个角都在平地就放行）。两条合起来，「内部是 60° 陡崖的出生区」能一路 validate 全绿 ——
## 默认图青岭走廊就是这么漏出去的（实测质心 60.5°、当时的 demo 出生点 45.8°）。
##
## 现在：生成器在每个出生区里压平一块圆盘（半径 + 过渡带），选址**只看几何**
## （出生区边界 / 已放好的掩体 / 节点距离）—— 因为「平地」正是要造出来的东西，不能拿它当选址依据。
## 校验器那边独立复核「真的存在这样一块平地」（spawn.no_pad），两边不共用结论。

## 点在多边形内（射线法，凸 / 凹都对）
static func point_in_polygon(polygon: Array, point: Vector2) -> bool:
	var count := polygon.size()
	if count < 3:
		return false
	var inside := false
	var j := count - 1
	for i in count:
		var a := vec2(polygon[i])
		var b := vec2(polygon[j])
		if ((a.y > point.y) != (b.y > point.y)) \
				and point.x < (b.x - a.x) * (point.y - a.y) / maxf(b.y - a.y, 0.00001) + a.x:
			inside = not inside
		j = i
	return inside


## 点到多边形边界的距离（点在里面时给的是「离边界多远」）
static func polygon_edge_distance(polygon: Array, point: Vector2) -> float:
	var count := polygon.size()
	if count == 0:
		return INF
	if count == 1:
		return point.distance_to(vec2(polygon[0]))
	var best := INF
	for i in count:
		best = minf(best, _segment_distance(vec2(polygon[i]), vec2(polygon[(i + 1) % count]), point))
	return best


## 点与多边形的关系距离：在里面 = 0，在外面 = 到边界的距离
static func polygon_distance(polygon: Array, point: Vector2) -> float:
	return 0.0 if point_in_polygon(polygon, point) else polygon_edge_distance(polygon, point)


static func _segment_distance(a: Vector2, b: Vector2, point: Vector2) -> float:
	var span := b - a
	var length_squared := span.length_squared()
	if length_squared <= 0.000001:
		return point.distance_to(a)
	return point.distance_to(a + span * clampf((point - a).dot(span) / length_squared, 0.0, 1.0))


static func _polygon_bounds(polygon: Array) -> Rect2:
	if polygon.is_empty():
		return Rect2()
	var low := vec2(polygon[0])
	var high := vec2(polygon[0])
	for point_v in polygon:
		var point := vec2(point_v)
		low = Vector2(minf(low.x, point.x), minf(low.y, point.y))
		high = Vector2(maxf(high.x, point.x), maxf(high.y, point.y))
	return Rect2(low, high - low)


## 离最近遮挡体多边形多远
static func nearest_occluder_distance(occluders: Array, point: Vector2) -> float:
	var best := INF
	for item_v in occluders:
		var polygon: Array = (item_v as Dictionary).get("polygon", [])
		if polygon.size() >= 3:
			best = minf(best, polygon_distance(polygon, point))
	return best


## 离最近 RAAS 节点多远
static func nearest_node_distance(nodes: Array, point: Vector2) -> float:
	var best := INF
	for node_v in nodes:
		best = minf(best, point.distance_to(vec2((node_v as Dictionary).get("pos", [0, 0]))))
	return best


## 出生区落脚地选址。返回 {ok, center, cover_dist, node_dist, tier, side}
## 判据：① 落在出生区内、离边界 ≥ 半径（落脚地要真的在声明区内）
##       ② 离最近遮挡体 ≥ 半径 + SPAWN_PAD_CLEAR_M（落脚地里不许有楼 / 沙袋）
##       ③ 离最近节点 ≥ 100 m（12.8.4「续航区在点外 100~200 m」），挑不出逐级放宽 60 → 30 → 0
## 并列时：先选离掩体更远的，再选离节点距离更接近 150 m 的（100~200 带的中值）。
static func best_spawn_pad_center(doc: JieyuMapDoc, polygon: Array, nodes: Array,
		side: String) -> Dictionary:
	var radius := JieyuMapSpec.SPAWN_PAD_RADIUS_M
	var margin := radius + JieyuMapSpec.SPAWN_PAD_CLEAR_M
	var bounds := _polygon_bounds(polygon)
	var result := {"ok": false, "center": Vector2.ZERO, "cover_dist": -1.0,
			"node_dist": -1.0, "tier": -1.0, "side": side}
	for tier_v in JieyuMapSpec.SPAWN_OFFSET_M + [60.0, 30.0, 0.0]:
		var tier := float(tier_v)
		var best := {}
		var x := bounds.position.x + radius
		while x <= bounds.end.x - radius:
			var y := bounds.position.y + radius
			while y <= bounds.end.y - radius:
				var point := Vector2(x, y)
				if point_in_polygon(polygon, point) \
						and polygon_edge_distance(polygon, point) >= radius:
					var cover := nearest_occluder_distance(doc.occluders, point)
					var node_dist := nearest_node_distance(nodes, point)
					if cover >= margin and node_dist >= tier:
						var better := best.is_empty() \
								or cover > float(best["cover_dist"]) + 0.001 \
								or (absf(cover - float(best["cover_dist"])) <= 0.001 \
								and absf(node_dist - 150.0) < absf(float(best["node_dist"]) - 150.0))
						if better:
							best = {"cover_dist": cover, "node_dist": node_dist, "center": point}
				y += 5.0
			x += 5.0
		if not best.is_empty():
			result["ok"] = true
			result["center"] = best["center"]
			result["cover_dist"] = best["cover_dist"]
			result["node_dist"] = best["node_dist"]
			result["tier"] = tier
			return result
	return result


## 给每个出生区压平一块落脚地；返回选址清单（供日志 / 自检 / 测试读）
static func flatten_spawn_pads(doc: JieyuMapDoc, zones: Dictionary, nodes: Array) -> Array:
	var pads: Array = []
	for spawn_v in zones.get("spawn_areas", []):
		if not (spawn_v is Dictionary):
			continue
		var spawn: Dictionary = spawn_v
		var polygon: Array = spawn.get("polygon", [])
		if polygon.size() < 3:
			continue
		var side := str(spawn.get("side", "?"))
		var pad := best_spawn_pad_center(doc, polygon, nodes, side)
		if bool(pad["ok"]):
			JieyuMapPainter.flatten_disc(doc, pad["center"], JieyuMapSpec.SPAWN_PAD_RADIUS_M,
					JieyuMapSpec.SPAWN_PAD_FALLOFF_M, -1.0)
		else:
			push_warning("[地图] 出生区 %s 找不到落脚地选址（区内被掩体占满 / 贴边太近）" % side)
		pads.append(pad)
	return pads


static func from_recipe(map_id: String, recipe: Dictionary) -> JieyuMapDoc:
	var grid_w := int(recipe.get("grid_w", GameConfig.GRID_WIDTH))
	var grid_h := int(recipe.get("grid_h", GameConfig.GRID_HEIGHT))
	var seed_value := int(recipe.get("seed", GameConfig.DEFAULT_MAP_SEED))
	var doc := JieyuMapDoc.create(map_id, grid_w, grid_h, seed_value)
	doc.meta["name"] = str(recipe.get("name", map_id))
	doc.meta["terrain_type"] = str(recipe.get("terrain_type", "grassland"))
	doc.meta["players"] = int(recipe.get("players", 64))
	if recipe.has("max_elevation_m"):
		doc.meta["max_elevation_m"] = float(recipe["max_elevation_m"])
	if recipe.has("modes"):
		doc.meta["modes"] = (recipe["modes"] as Array).duplicate()
	if recipe.has("noise"):
		doc.meta["noise"] = (recipe["noise"] as Dictionary).duplicate(true)
	else:
		var noise := JieyuMapSpec.default_noise(seed_value)
		for key in ["octaves", "lacunarity", "gain", "layers"]:
			if recipe.has(key):
				noise[key] = recipe[key]
		doc.meta["noise"] = noise

	var gen_recipe: Dictionary = (doc.meta["noise"] as Dictionary).duplicate(true)
	gen_recipe["max_elevation_m"] = doc.max_elevation()
	for key in ["water_level_m", "river_axis", "river_center_ratio", "river_half_width_m"]:
		if recipe.has(key):
			gen_recipe[key] = recipe[key]
	doc.set_height_bytes(generate_heights(gen_recipe, grid_w, grid_h))

	# 手工雕刻（配方里声明就做）：任意圆形压平 / 台地
	for entry_v in recipe.get("flatten_areas", []):
		var entry: Dictionary = entry_v
		JieyuMapPainter.flatten_disc(doc, vec2(entry.get("pos", [0, 0])),
				float(entry.get("radius_m", 60.0)), float(entry.get("falloff_m", 30.0)),
				float(entry.get("target_m", -1.0)))
	for entry_v in recipe.get("plateaus", []):
		var entry: Dictionary = entry_v
		JieyuMapPainter.carve_plateau(doc, vec2(entry.get("pos", [0, 0])),
				float(entry.get("radius_m", 120.0)), float(entry.get("peak_m", 100.0)),
				float(entry.get("falloff_m", 180.0)))

	# 道路：先规划折线，再交给画笔压平
	var roads: Array = []
	for road_v in recipe.get("roads", []):
		var road: Dictionary = road_v
		var path: Array[Vector2] = []
		for point_v in road.get("path", []):
			path.append(vec2(point_v))
		if path.size() < 2:
			continue
		var width := float(road.get("width_m", JieyuMapSpec.VEHICLE_CORRIDOR_MIN_M))
		JieyuMapPainter.carve_road(doc, path, width,
				float(road.get("max_slope_deg", JieyuMapSpec.CORRIDOR_FLAT_DEG)))
		roads.append({
			"name": str(road.get("name", "road")),
			"path": road.get("path", []),
			"width_m": width,
		})

	var nodes: Array = recipe.get("raas_nodes", [])
	if nodes.is_empty():
		nodes = generate_nodes(doc, int(recipe.get("node_count", 5)), seed_value)
	# 节点区压平（12.8.4「白旗点周边的掩体」的自动近似）。
	# ⚠ 必须放在**道路之后**：道路是「沿程坡度受控」的路基，在陡坡上会把走廊抬成一条
	# 高于两侧的堤（这是有意的 —— 六章要求载具通道能走通）。若这条堤正好穿过节点核心，
	# 核心格就会出现远超 30° 的陡坎 —— 2026-10-04 实测青岭走廊 N1 核心格 79.3°，
	# 校验器报 node.core_not_passable。
	# ⚠ 显式给的 raas_nodes 以前**不压平**（只有自动布点才压平）—— 这是个不对称：
	# 手写节点的图反而更容易在核心格踩到陡坎。2026-10-04 修正为两条分支都压平。
	for node_v in nodes:
		JieyuMapPainter.flatten_disc(doc, vec2((node_v as Dictionary)["pos"]),
				JieyuMapSpec.CORE_RADIUS_M * 2.0, 25.0, -1.0)
	doc.zones = build_zones(nodes, grid_w, grid_h, seed_value)
	if recipe.has("spawn_areas"):
		doc.zones["spawn_areas"] = (recipe["spawn_areas"] as Array).duplicate(true)
	if recipe.has("flags"):
		doc.zones["flags"] = (recipe["flags"] as Array).duplicate(true)
	doc.occluders = place_settlements(doc, doc.zones, recipe, seed_value)
	# 出生区落脚地压平（2026-10-05）：必须在**掩体之后**（选址要看哪块空地还没被占）、
	# **内容层之前**（泥 / 雪 / 草按高程分，压平要反映到内容图上）。
	flatten_spawn_pads(doc, doc.zones, nodes)

	var content := build_content_images(doc, recipe)
	var total_content := int(content["counts"][0]) + int(content["counts"][1]) \
			+ int(content["counts"][2])
	var rows_path := ""
	var material_path := ""
	if total_content > 0:
		rows_path = JieyuMapSpec.FILE_CONTENT_ROWS
		material_path = JieyuMapSpec.FILE_MATERIAL
		# 行序图必须是彩色的（工程侧按同色像素分段），材质图是单通道 id 图
		doc.layers["content_rows"] = content["rows"]
		doc.layers["content_material"] = content["material"]
	doc.meta["content_layers"] = content_layer_meta(rows_path, material_path)
	doc.meta["content_counts"] = content["counts"]
	doc.meta["roads"] = roads
	doc.meta["recipe"] = _recipe_echo(recipe, seed_value, grid_w, grid_h)
	return doc


## 配方回写进 meta（保证「这张图是怎么来的」可复现）
static func _recipe_echo(recipe: Dictionary, seed_value: int, grid_w: int, grid_h: int) -> Dictionary:
	return {
		"seed": seed_value,
		"grid_w": grid_w,
		"grid_h": grid_h,
		"node_count": int(recipe.get("node_count", 5)),
		"settlement_groups": int(recipe.get("settlement_groups", 0)),
		"buildings_per_group": int(recipe.get("buildings_per_group", 7)),
		"river_axis": str(recipe.get("river_axis", "")),
		"water_level_m": float(recipe.get("water_level_m", 0.0)),
		"generator": "jieyu_map/%s" % JieyuMapSpec.NOISE_TYPE,
	}
