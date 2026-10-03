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

## 半高墙（沙袋类）的耐久占位值，对齐工程 `GameConfig.COVER_HP`（200）。
## 文档侧只有 4.17 / 20.5 一句「耐久 200，清零后退出 occluder 组」，
## 所以这是**唯一**有据可依的可摧毁物件血量；建筑不写 hp（文档没有这个规则）。
const SANDBAG_HP := 200.0


## ────────────── 1. 噪声基底（12.8.3）──────────────

## 生成高度字节。recipe 字段（全部可省）：
##   seed / octaves / lacunarity / gain / layers[{feature_m, amp_m}] / max_elevation_m
##   water_level_m（河谷水位）/ river_axis（"y"|"x"|""）/ river_center_ratio / river_half_width_m
static func generate_heights(recipe: Dictionary,
		grid_w: int = GameConfig.GRID_WIDTH,
		grid_h: int = GameConfig.GRID_HEIGHT) -> PackedByteArray:
	var max_elev := float(recipe.get("max_elevation_m", GameConfig.MAX_ELEVATION))
	var seed_value := int(recipe.get("seed", GameConfig.DEFAULT_MAP_SEED))
	var noise_layers: Array = recipe.get("layers", JieyuMapSpec.NOISE_LAYERS)

	var noises: Array[FastNoiseLite] = []
	var total_amp := 0.0
	for layer_v in noise_layers:
		var layer: Dictionary = layer_v
		var noise := FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		noise.fractal_type = FastNoiseLite.FRACTAL_FBM
		noise.fractal_octaves = int(recipe.get("octaves", JieyuMapSpec.NOISE_OCTAVES))
		noise.fractal_lacunarity = float(recipe.get("lacunarity", JieyuMapSpec.NOISE_LACUNARITY))
		noise.fractal_gain = float(recipe.get("gain", JieyuMapSpec.NOISE_GAIN))
		noise.frequency = 1.0 / maxf(float(layer.get("feature_m", 100.0)), 1.0)
		noise.seed = seed_value
		noises.append(noise)
		total_amp += float(layer.get("amp_m", 0.0))
	if noises.is_empty() or is_zero_approx(total_amp):
		push_error("[JieyuMapGen] 噪声层为空，拒绝生成")
		var flat := PackedByteArray()
		flat.resize(grid_w * grid_h)
		flat.fill(0)
		return flat

	var elevation_ratio := max_elev / total_amp
	var data := PackedByteArray()
	data.resize(grid_w * grid_h)
	for y in grid_h:
		for x in grid_w:
			var accumulated := 0.0
			for i in noises.size():
				accumulated += noises[i].get_noise_2d(float(x), float(y)) \
						* float((noise_layers[i] as Dictionary).get("amp_m", 0.0))
			# 与 HeightGrid.fill_from_noise 同一条公式，保证「插件生成的基底 = 工程噪声地形」
			var value := clampf((accumulated + total_amp) * 0.5 * elevation_ratio, 0.0, max_elev)
			data[y * grid_w + x] = JieyuMapSpec.height_to_gray(value, max_elev)

	_carve_river(data, grid_w, grid_h, recipe, max_elev)
	return data


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
	for g in groups:
		var anchor := _pick_settlement_anchor(scores, cols, rows, sample_step, nodes, g, rng)
		if anchor.x < 0.0:
			continue
		var placed := 0
		var attempts := 0
		while placed < buildings_per_group and attempts < buildings_per_group * 12:
			attempts += 1
			var angle := rng.randf() * TAU
			var radius := rng.randf_range(JieyuMapSpec.URBAN_SPACING_MIN_M,
					JieyuMapSpec.URBAN_SPACING_MAX_M * float(buildings_per_group) * 0.8)
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
			occluders.append({
				"id": "building_%02d" % (occluders.size() + 1),
				"type": "building",
				"polygon": rect_polygon(center, rng.randf_range(4.0, 7.0),
						rng.randf_range(4.0, 7.0)),
				"h_low": 0.0,
				"h_top": roundf(rng.randf_range(3.0, 6.0) * 10.0) / 10.0,
				"destructible": false,
			})
			placed += 1
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
			wall_index += 1
			# 12.8.7 的 destructible / hp 是**可选**字段；文档里唯一有明确耐久的可摧毁物件是沙袋
			# （4.17 / 20.5：耐久 200，打光退出 occluder 组），所以这里产出的半高墙标成可摧毁。
			# ⚠ 建筑一律 destructible=false —— 文档至今没有建筑毁伤规则（21.2.2 ⑧ 自认），
			#   标 true 只会凭空发明一套血量（难崩模式的「建筑毁伤更多」也在第一版被降级）。
			occluders.append({
				"id": "wall_%02d" % wall_index,
				"type": "wall",
				"polygon": rect_polygon(center, rng.randf_range(2.5, 5.0),
						rng.randf_range(1.0, 1.8)),
				"h_low": 0.0,
				"h_top": roundf(rng.randf_range(0.8, 2.0) * 10.0) / 10.0,
				"destructible": true,
				"hp": SANDBAG_HP,
			})
	return occluders


## 轴对齐矩形多边形（12.8.7 polygon 用 [x, y] 数组）
static func rect_polygon(center: Vector2, half_x: float, half_y: float) -> Array:
	return [
		[roundi(center.x - half_x), roundi(center.y - half_y)],
		[roundi(center.x + half_x), roundi(center.y - half_y)],
		[roundi(center.x + half_x), roundi(center.y + half_y)],
		[roundi(center.x - half_x), roundi(center.y + half_y)],
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

## 4.17 环境互动区的三种颜色（行序方案里工程侧按同色像素分段，所以每行必须纯色）
const CONTENT_COLORS := [
	Color8(107, 82, 51),    # 0 泥泞
	Color8(240, 245, 255),  # 1 雪地
	Color8(61, 133, 61),    # 2 草丛
]


## 生成 content.png（按行序排 N 片区域）与 material.png（单通道 id 图）。
## 判据：低洼 → 泥泞；高海拔 → 雪地；中低海拔 → 草丛；超过坡度阈值的坡面上不生成。
## 返回 {"rows": Image, "material": Image, "counts": [三种各多少格]}
static func build_content_images(doc: JieyuMapDoc, recipe: Dictionary = {}) -> Dictionary:
	var max_elev := doc.max_elevation()
	var mud_max_ratio := float(recipe.get("mud_max_ratio", 0.10))
	var snow_min_ratio := float(recipe.get("snow_min_ratio", 0.62))
	var grass_max_ratio := float(recipe.get("grass_max_ratio", 0.55))
	var slope_limit := JieyuMapSpec.vehicle_slope_limit()
	var rows_image := Image.create(doc.width, doc.height_px, false, Image.FORMAT_RGB8)
	rows_image.fill(Color(0, 0, 0))
	var material := Image.create(doc.width, doc.height_px, false, Image.FORMAT_L8)
	material.fill(0)
	var counts := [0, 0, 0]
	for y in doc.height_px:
		for x in doc.width:
			var ratio := doc.height_at(x, y) / maxf(max_elev, 0.001)
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
			counts[kind] += 1
			material.set_pixel(x, y, Color8(kind + 1, kind + 1, kind + 1))
			rows_image.set_pixel(x, y, CONTENT_COLORS[kind])
	return {"rows": rows_image, "material": material, "counts": counts}


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
		for node_v in nodes:
			# 节点区压平（12.8.4「白旗点周边的掩体」的自动近似）
			JieyuMapPainter.flatten_disc(doc, vec2((node_v as Dictionary)["pos"]),
					JieyuMapSpec.CORE_RADIUS_M * 2.0, 25.0, -1.0)
	doc.zones = build_zones(nodes, grid_w, grid_h, seed_value)
	if recipe.has("spawn_areas"):
		doc.zones["spawn_areas"] = (recipe["spawn_areas"] as Array).duplicate(true)
	if recipe.has("flags"):
		doc.zones["flags"] = (recipe["flags"] as Array).duplicate(true)
	doc.occluders = place_settlements(doc, doc.zones, recipe, seed_value)

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
