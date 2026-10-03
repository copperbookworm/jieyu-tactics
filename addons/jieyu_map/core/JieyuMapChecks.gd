class_name JieyuMapChecks
extends RefCounted

## 地图约束校验：把文档口径里「能机器判的」指标全变成可复现的断言。
##
## 依据：12.8.5 ⑥「生成后自动校验占领点间距、掩体密度、视线打断距离」+
##       六章 关键量化指标 + 4.3 判断地图是否失衡的 5 项非主观指标 + 4.2 白旗点五结构。
##
## 三级结论：ERROR（这条不过这张图就不该进对局）/ WARN（能跑但会挨骂）/ INFO（供人判断）。
## 用法：`JieyuMapChecks.run(doc)` → 报告数组；`JieyuMapChecks.summary(report)` → 一行字符串。

const SEV_ERROR := "ERROR"
const SEV_WARN := "WARN"
const SEV_INFO := "INFO"

## 通视采样步长（米）。与工程项目口径一致：1 m 网格 + SIGHT_MARGIN 容差
const SIGHT_SAMPLE_STEP_M := 1.0
## 制高点扫描用的粗步长：它要对全图几万个候选点各投 9 条线，1 m 步长会跑几十秒
const OVERWATCH_SIGHT_STEP_M := 4.0
const SIGHT_MAX_SAMPLES := 900


## ────────────── 入口 ──────────────

## 跑全部检查，返回 [{level, code, message, data}, ...]
static func run(doc: JieyuMapDoc) -> Array:
	var report: Array = []
	if doc == null or not doc.is_valid():
		report.append(_item(SEV_ERROR, "doc.invalid", "文档为空或尺寸与高度数据不匹配", {}))
		return report
	_check_grid(doc, report)
	_check_meta(doc, report)
	var node_report := _check_nodes(doc, report)
	_check_flags(doc, report, node_report)
	_check_naming(doc, report)
	_check_occluders(doc, report, node_report)
	_check_passability(doc, report)
	_check_terrain_raster(doc, report, _build_raster(doc, 10))
	_check_overwatch(doc, report)
	_check_runs(report)
	return report


## 一行摘要（CLI / dock 都显示这一行）
static func summary(report: Array) -> String:
	var errors := count_level(report, SEV_ERROR)
	var warns := count_level(report, SEV_WARN)
	var infos := count_level(report, SEV_INFO)
	var verdict := "通过" if errors == 0 else "未通过"
	return "%s：错误 %d / 警告 %d / 提示 %d" % [verdict, errors, warns, infos]


static func count_level(report: Array, level: String) -> int:
	var count := 0
	for item_v in report:
		if str((item_v as Dictionary).get("level", "")) == level:
			count += 1
	return count


static func _item(level: String, code: String, message: String, data: Dictionary) -> Dictionary:
	return {"level": level, "code": code, "message": message, "data": data}


## ────────────── 尺寸 / metadata ──────────────

static func _check_grid(doc: JieyuMapDoc, report: Array) -> void:
	var expected_w := int(doc.meta.get("grid", doc.width))
	if expected_w != doc.width:
		report.append(_item(SEV_ERROR, "grid.mismatch",
				"meta.grid=%d 与高度图宽度 %d 不一致" % [expected_w, doc.width], {}))
	if doc.width != GameConfig.GRID_WIDTH or doc.height_px != GameConfig.GRID_HEIGHT:
		report.append(_item(SEV_WARN, "grid.size",
				"尺寸 %d×%d 不是工程约定的 %d×%d（%s 会直接拒绝导入，不缩放）"
				% [doc.width, doc.height_px, GameConfig.GRID_WIDTH, GameConfig.GRID_HEIGHT,
				"HeightGrid.fill_from_image"], {}))
	if doc.height.size() != doc.width * doc.height_px:
		report.append(_item(SEV_ERROR, "grid.data_length",
				"高度数据 %d 字节 ≠ %d×%d" % [doc.height.size(), doc.width, doc.height_px], {}))


static func _check_meta(doc: JieyuMapDoc, report: Array) -> void:
	if absf(doc.max_elevation() - GameConfig.MAX_ELEVATION) > 0.001:
		report.append(_item(SEV_WARN, "meta.max_elevation",
				"max_elevation_m=%.1f 与 GameConfig.MAX_ELEVATION=%.1f 不一致（导入时按 %.1f 解码，"
				% [doc.max_elevation(), GameConfig.MAX_ELEVATION, GameConfig.MAX_ELEVATION]
				+ "图上的高度会被整体缩放）", {}))
	if str(doc.meta.get("terrain_type", "")).is_empty():
		report.append(_item(SEV_WARN, "meta.terrain_type", "meta 缺 terrain_type", {}))
	var noise: Variant = doc.meta.get("noise", null)
	if not (noise is Dictionary):
		report.append(_item(SEV_WARN, "meta.noise", "meta 缺 noise 块（这张图不可复现）", {}))
	elif int((noise as Dictionary).get("seed", 0)) <= 0:
		report.append(_item(SEV_WARN, "meta.noise_seed", "noise.seed 非法（应为正整数）", {}))
	var modes: Variant = doc.meta.get("modes", null)
	if modes is Array:
		for mode_v in modes:
			if not JieyuMapSpec.MODE_IDS.has(str(mode_v)):
				report.append(_item(SEV_WARN, "meta.mode_unknown",
						"modes 里有未知模式 id：%s" % str(mode_v), {}))
	elif modes != null:
		report.append(_item(SEV_WARN, "meta.modes", "meta.modes 必须是数组", {}))


## ────────────── 节点 ──────────────

static func _check_nodes(doc: JieyuMapDoc, report: Array) -> Dictionary:
	var nodes: Array = doc.zones.get("raas_nodes", [])
	var result := {"count": nodes.size(), "spacing_min": INF, "spacing_max": 0.0}
	if nodes.size() != 5:
		report.append(_item(SEV_WARN, "nodes.count",
				"RAAS 节点 %d 个（12.8.4 五节点推进链是 5 个）" % nodes.size(),
				{"count": nodes.size()}))
	if nodes.is_empty():
		report.append(_item(SEV_ERROR, "nodes.empty", "zones.json 里没有任何 RAAS 节点", {}))
		return result

	var spacing_min := INF
	var spacing_max := 0.0
	var positions: Array[Vector2] = []
	for i in nodes.size():
		var a: Dictionary = nodes[i]
		var pos_a := JieyuMapGen.vec2(a.get("pos", [0, 0]))
		positions.append(pos_a)
		if pos_a.x < 0.0 or pos_a.y < 0.0 \
				or pos_a.x > float(doc.width) or pos_a.y > float(doc.height_px):
			report.append(_item(SEV_ERROR, "nodes.out_of_bounds",
					"节点 %s 在地图外：%s" % [str(a.get("id", "?")), str(pos_a)], {}))
	# 六章的「占领点间距 200–500 m」是**相邻两点**的口径（点间移动步兵 30–60 s / 载具 15–30 s），
	# 不是全图任意两点的最小距离 —— 1 km 图上的 N1↔N5 本来就超过 500 m。
	for i in range(nodes.size() - 1):
		var step := positions[i].distance_to(positions[i + 1])
		spacing_min = minf(spacing_min, step)
		spacing_max = maxf(spacing_max, step)
		var id_a := str((nodes[i] as Dictionary).get("id", "?"))
		var id_b := str((nodes[i + 1] as Dictionary).get("id", "?"))
		if step < JieyuMapSpec.NODE_SPACING_MIN_M:
			report.append(_item(SEV_ERROR, "nodes.spacing_min",
					"相邻节点 %s—%s 间距 %.0f m < 下限 %.0f m（这一跳撑不起 30–60 s 的推进节奏）"
					% [id_a, id_b, step, JieyuMapSpec.NODE_SPACING_MIN_M], {"pair": [i, i + 1]}))
		if step > JieyuMapSpec.NODE_SPACING_MAX_M:
			report.append(_item(SEV_WARN, "nodes.spacing_max",
					"相邻节点 %s—%s 间距 %.0f m > 上限 %.0f m（点间移动会拖成跑图）"
					% [id_a, id_b, step, JieyuMapSpec.NODE_SPACING_MAX_M], {"pair": [i, i + 1]}))
	# 非相邻的两点也不该挤在一起（推进链会自相重叠），但这不是「间距」口径
	for i in nodes.size():
		for j in range(i + 2, nodes.size()):
			var far := positions[i].distance_to(positions[j])
			if far < JieyuMapSpec.NODE_SPACING_MIN_M:
				report.append(_item(SEV_WARN, "nodes.non_adjacent_close",
						"非相邻节点 %s 与 %s 只隔 %.0f m（推进链会自相重叠）"
						% [str((nodes[i] as Dictionary).get("id", "?")),
						str((nodes[j] as Dictionary).get("id", "?")), far], {}))
	result["spacing_min"] = spacing_min if not is_inf(spacing_min) else 0.0
	result["spacing_max"] = spacing_max
	# 小图上摆满 5 个点是几何上做不到的（五节点要 800 m 以上跨度），这时报出来的
	# 间距必然超标 —— 与其刷一屏 ERROR，不如明说「这张图不该按五节点口径验」。
	if nodes.size() > 1 and result["spacing_min"] < JieyuMapSpec.NODE_SPACING_MIN_M \
			and maxf(float(doc.width), float(doc.height_px)) \
			< JieyuMapSpec.NODE_SPACING_MIN_M * float(nodes.size()) * 0.9:
		report.append(_item(SEV_WARN, "nodes.map_too_small",
				"地图只有 %d×%d，装不下 %d 个节点按 200–500 m 间距铺开 —— "
				% [doc.width, doc.height_px, nodes.size()]
				+ "间距类结论对这张图不成立（仅测试地图会这样）", {}))
	if nodes.size() > 1 and not _spacing_suppressed(report):
		report.append(_item(SEV_INFO, "nodes.spacing",
				"相邻节点间距 %.0f–%.0f m（六章要求 %.0f–%.0f m）"
				% [result["spacing_min"], result["spacing_max"],
				JieyuMapSpec.NODE_SPACING_MIN_M, JieyuMapSpec.NODE_SPACING_MAX_M],
				{"min": result["spacing_min"], "max": result["spacing_max"]}))
	return result


static func _spacing_suppressed(report: Array) -> bool:
	for item_v in report:
		if str((item_v as Dictionary).get("code", "")) == "nodes.map_too_small":
			return true
	return false


## ────────────── 白旗点五结构（flags）──────────────

static func _check_flags(doc: JieyuMapDoc, report: Array, node_report: Dictionary) -> void:
	var flags: Array = doc.zones.get("flags", [])
	var nodes: Array = doc.zones.get("raas_nodes", [])
	var node_ids := {}
	for node_v in nodes:
		node_ids[str((node_v as Dictionary).get("id", ""))] = true
	var seen := {}
	for flag_v in flags:
		if not (flag_v is Dictionary):
			report.append(_item(SEV_ERROR, "flags.item", "flags 里有非对象项", {}))
			continue
		var flag: Dictionary = flag_v
		var node_id := str(flag.get("node", ""))
		if seen.has(node_id):
			report.append(_item(SEV_ERROR, "flags.duplicate",
					"节点 %s 有多条 flag 记录" % node_id, {}))
		seen[node_id] = true
		if not node_ids.has(node_id):
			report.append(_item(SEV_ERROR, "flags.dangling",
					"flag 指向不存在的节点：%s" % node_id, {}))
		var core := float(flag.get("core_radius_m", JieyuMapSpec.CORE_RADIUS_M))
		if core <= 0.0:
			report.append(_item(SEV_ERROR, "flags.core_radius",
					"节点 %s 的 core_radius_m=%.1f 必须为正" % [node_id, core], {}))
		var ring: Variant = flag.get("pressure_ring_m", null)
		if not (ring is Array) or (ring as Array).size() != 2:
			report.append(_item(SEV_ERROR, "flags.pressure_ring",
					"节点 %s 的 pressure_ring_m 必须是 [内半径, 外半径]" % node_id, {}))
		else:
			var inner := float((ring as Array)[0])
			var outer := float((ring as Array)[1])
			if inner <= core:
				report.append(_item(SEV_ERROR, "flags.ring_overlap",
						"节点 %s 外围压制圈内径 %.0f m ≤ 核心半径 %.0f m（叠在一起，主战场会被吃掉）"
						% [node_id, inner, core], {}))
			if outer <= inner:
				report.append(_item(SEV_ERROR, "flags.ring_order",
						"节点 %s 压制圈外径 %.0f m ≤ 内径 %.0f m" % [node_id, outer, inner], {}))
			if outer < JieyuMapSpec.PRESSURE_RING_M[1] * 0.6:
				report.append(_item(SEV_WARN, "flags.ring_narrow",
						"节点 %s 压制圈只到 %.0f m（文档 30–150 m，圈太薄会变成纯点内互殴）"
						% [node_id, outer], {}))
		var routes := int(flag.get("approach_routes", 0))
		if routes < JieyuMapSpec.MIN_APPROACH_ROUTES:
			report.append(_item(SEV_ERROR, "flags.approach_routes",
					"节点 %s 进入通道 %d 条 < 4.2 下限 %d 条（只有一条枪线的点＝单点瓶颈）"
					% [node_id, routes, JieyuMapSpec.MIN_APPROACH_ROUTES], {}))
		elif routes < JieyuMapSpec.RECOMMENDED_APPROACH_ROUTES:
			report.append(_item(SEV_WARN, "flags.approach_routes_rec",
					"节点 %s 进入通道 %d 条 < 六章建议 %d 条"
					% [node_id, routes, JieyuMapSpec.RECOMMENDED_APPROACH_ROUTES], {}))
		var offset: Variant = flag.get("spawn_offset_m", null)
		if offset is Array and (offset as Array).size() == 2:
			var low := float((offset as Array)[0])
			var high := float((offset as Array)[1])
			if low < JieyuMapSpec.SPAWN_OFFSET_M[0] * 0.5:
				report.append(_item(SEV_WARN, "flags.spawn_too_close",
						"节点 %s 续航区最近 %.0f m（4.4：出生点是心脏，不能长在枪口下）"
						% [node_id, low], {}))
			if high > JieyuMapSpec.SPAWN_OFFSET_M[1] * 1.5:
				report.append(_item(SEV_WARN, "flags.spawn_too_far",
						"节点 %s 续航区最远 %.0f m（回场时间会超 90 s 上限）" % [node_id, high], {}))
		else:
			report.append(_item(SEV_ERROR, "flags.spawn_offset",
					"节点 %s 缺 spawn_offset_m [近, 远]" % node_id, {}))
	if not nodes.is_empty() and flags.size() != nodes.size():
		report.append(_item(SEV_ERROR, "flags.count",
				"节点 %d 个但有 %d 条 flag 记录（每个节点都必须有完整五结构）"
				% [nodes.size(), flags.size()], {}))

	var rally: Array = doc.zones.get("rally_zones", [])
	for rally_v in rally:
		if not (rally_v is Dictionary):
			continue
		var item: Dictionary = rally_v
		var node_id := str(item.get("node", ""))
		if not node_ids.has(node_id):
			report.append(_item(SEV_ERROR, "rally.dangling",
					"集结点区指向不存在的节点：%s" % node_id, {}))
		var min_dist := float(item.get("min_dist_to_core_m", JieyuMapSpec.MIN_DIST_TO_CORE_M))
		if min_dist < JieyuMapSpec.MIN_DIST_TO_CORE_M:
			report.append(_item(SEV_WARN, "rally.min_dist",
					"节点 %s 集结点最小距核心 %.0f m < 文档 %.0f m"
					% [node_id, min_dist, JieyuMapSpec.MIN_DIST_TO_CORE_M], {}))
	if rally.size() != nodes.size() and not nodes.is_empty():
		report.append(_item(SEV_WARN, "rally.count",
				"集结点可用区 %d 个 ≠ 节点 %d 个" % [rally.size(), nodes.size()], {}))

	var spawns: Array = doc.zones.get("spawn_areas", [])
	if spawns.is_empty():
		report.append(_item(SEV_WARN, "spawn.empty", "没有出生区（spawn_areas 为空）", {}))
	for spawn_v in spawns:
		if not (spawn_v is Dictionary):
			continue
		var spawn: Dictionary = spawn_v
		var polygon: Variant = spawn.get("polygon", null)
		if not (polygon is Array) or (polygon as Array).size() < 3:
			report.append(_item(SEV_ERROR, "spawn.polygon",
					"出生区 %s 的多边形少于 3 个顶点" % str(spawn.get("side", "?")), {}))


## ────────────── 命名（《给地图不同区域命名》）──────────────

static func _check_naming(doc: JieyuMapDoc, report: Array) -> void:
	var names := {}
	for node_v in doc.zones.get("raas_nodes", []):
		var node: Dictionary = node_v
		var name := str(node.get("name", "")).strip_edges()
		var node_id := str(node.get("id", "?"))
		if name.is_empty():
			report.append(_item(SEV_INFO, "naming.empty",
					"节点 %s 还没有名字（报点要用：短 / 唯一 / 可想象 / 可战术化）" % node_id, {}))
			continue
		if name.length() > JieyuMapSpec.NAME_MAX_CHARS:
			report.append(_item(SEV_WARN, "naming.too_long",
					"节点 %s 名字「%s」%d 字符 > %d（听到要能瞬间定位，别写句子）"
					% [node_id, name, name.length(), JieyuMapSpec.NAME_MAX_CHARS], {}))
		if names.has(name):
			report.append(_item(SEV_ERROR, "naming.duplicate",
					"地名重复：「%s」（%s 与 %s）—— 全图不重复是硬要求"
					% [name, str(names[name]), node_id], {}))
		else:
			names[name] = node_id


## ────────────── 掩体 / 建筑（12.8.7 occluders + 六章掩体密度）──────────────

static func _check_occluders(doc: JieyuMapDoc, report: Array, node_report: Dictionary) -> void:
	var centers: Array[Vector2] = []
	var inside_core := 0
	var buildings := 0
	var node_positions: Array[Vector2] = []
	for node_v in doc.zones.get("raas_nodes", []):
		node_positions.append(JieyuMapGen.vec2((node_v as Dictionary).get("pos", [0, 0])))
	var core_radius := JieyuMapSpec.CORE_RADIUS_M
	for flag_v in doc.zones.get("flags", []):
		if flag_v is Dictionary and (flag_v as Dictionary).has("core_radius_m"):
			core_radius = float((flag_v as Dictionary)["core_radius_m"])
			break

	for item_v in doc.occluders:
		if not (item_v is Dictionary):
			report.append(_item(SEV_ERROR, "occluders.item", "occluders 里有非对象项", {}))
			continue
		var item: Dictionary = item_v
		var polygon: Variant = item.get("polygon", null)
		if not (polygon is Array) or (polygon as Array).size() < 3:
			report.append(_item(SEV_ERROR, "occluders.polygon",
					"遮挡体 %s 的多边形少于 3 个顶点" % str(item.get("id", "?")), {}))
			continue
		var h_low := float(item.get("h_low", 0.0))
		var h_top := float(item.get("h_top", 0.0))
		if h_low > h_top:
			report.append(_item(SEV_ERROR, "occluders.height_range",
					"遮挡体 %s 的 h_low %.1f > h_top %.1f" % [str(item.get("id", "?")), h_low, h_top],
					{}))
		if h_top >= JieyuMapSpec.BUILDING_H_LOW_M and str(item.get("type", "")) == "building":
			buildings += 1
		for point_v in polygon:
			var point := JieyuMapGen.vec2(point_v)
			if point.x < -0.5 or point.y < -0.5 \
					or point.x > float(doc.width) + 0.5 or point.y > float(doc.height_px) + 0.5:
				report.append(_item(SEV_ERROR, "occluders.out_of_bounds",
						"遮挡体 %s 有顶点在地图外：%s" % [str(item.get("id", "?")), str(point)], {}))
				break
		var center := _polygon_center(polygon)
		centers.append(center)
		for node_pos in node_positions:
			if center.distance_to(node_pos) < core_radius:
				inside_core += 1
				break

	if doc.occluders.is_empty():
		report.append(_item(SEV_WARN, "occluders.empty",
				"没有任何掩体 / 建筑（点内掩体是白旗点五结构第②项，没有它占领区是「假点」）", {}))
	if inside_core > 0:
		report.append(_item(SEV_ERROR, "occluders.in_core",
				"有 %d 个遮挡体落在核心占领区内（六章铁律：核心区是判定器不是迷宫）" % inside_core,
				{"count": inside_core}))

	# 掩体间距：建筑群口径 5–15 m；全图最小间距小于 5 m 说明叠在一起
	var min_gap := INF
	var pairs := 0
	for i in centers.size():
		for j in range(i + 1, centers.size()):
			var gap := centers[i].distance_to(centers[j])
			if gap < min_gap:
				min_gap = gap
			if gap < JieyuMapSpec.URBAN_SPACING_MIN_M:
				pairs += 1
	if pairs > 0:
		report.append(_item(SEV_WARN, "occluders.overlap",
				"有 %d 对遮挡体间距 < %.0f m（建筑会穿模，也会把枪线堵死）"
				% [pairs, JieyuMapSpec.URBAN_SPACING_MIN_M], {"pairs": pairs}))
	if buildings > 0:
		report.append(_item(SEV_INFO, "occluders.density",
				"建筑 %d 座 / 遮挡体共 %d 个；建筑群口径间距 %.0f–%.0f m、高 %.1f–%.1f m"
				% [buildings, doc.occluders.size(), JieyuMapSpec.URBAN_SPACING_MIN_M,
				JieyuMapSpec.URBAN_SPACING_MAX_M, JieyuMapSpec.BUILDING_H_LOW_M,
				JieyuMapSpec.BUILDING_H_TOP_M], {"buildings": buildings}))


static func _polygon_center(polygon: Array) -> Vector2:
	if polygon.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for point_v in polygon:
		sum += JieyuMapGen.vec2(point_v)
	return sum / float(polygon.size())


## ────────────── 可通行性（12.8.5 ⑤ 坡度限制）──────────────

## 采样统计：超过坡度阈值的格占比；并报告出生区 / 节点核心区自己是否可通行
static func _check_passability(doc: JieyuMapDoc, report: Array) -> void:
	var limit := JieyuMapSpec.vehicle_slope_limit()
	var step := 10
	var steep := 0
	var total := 0
	for y in range(0, doc.height_px, step):
		for x in range(0, doc.width, step):
			total += 1
			if JieyuMapGen.slope_deg_at(doc.height, doc.width, doc.height_px,
					doc.max_elevation(), x, y, step) > limit:
				steep += 1
	if total == 0:
		return
	var ratio := float(steep) / float(total)
	var level := SEV_INFO
	if ratio > 0.45:
		level = SEV_WARN
	report.append(_item(level, "terrain.steep_ratio",
			"不可通行（>%.0f°）面积占比 %.1f%%（采样步长 %d m）" % [limit, ratio * 100.0, step],
			{"ratio": ratio}))

	for node_v in doc.zones.get("raas_nodes", []):
		var node: Dictionary = node_v
		var pos := JieyuMapGen.vec2(node.get("pos", [0, 0]))
		var cell := Vector2i(floori(pos.x), floori(pos.y))
		var slope := JieyuMapGen.slope_deg_at(doc.height, doc.width, doc.height_px,
				doc.max_elevation(), cell.x, cell.y, 4)
		if slope > limit:
			report.append(_item(SEV_ERROR, "node.core_not_passable",
					"节点 %s 核心格坡度 %.1f° > %.0f°（L1 验收：出生 / 占领格必须站得住）"
					% [str(node.get("id", "?")), slope, limit], {}))

	for spawn_v in doc.zones.get("spawn_areas", []):
		if not (spawn_v is Dictionary):
			continue
		var spawn: Dictionary = spawn_v
		var polygon: Variant = spawn.get("polygon", null)
		if not (polygon is Array):
			continue
		var blocked := 0
		var samples := 0
		for point_v in polygon:
			var point := JieyuMapGen.vec2(point_v)
			samples += 1
			if JieyuMapGen.slope_deg_at(doc.height, doc.width, doc.height_px,
					doc.max_elevation(), floori(point.x), floori(point.y), 4) > limit:
				blocked += 1
		if samples > 0 and blocked == samples:
			report.append(_item(SEV_ERROR, "spawn.not_passable",
					"出生区 %s 的所有顶点都在不可通行坡面上" % str(spawn.get("side", "?")), {}))


## ────────────── 开阔地 + 视线打断（共用一套采样栅格）──────────────

## 采样栅格：把地图按 step 米降采样成两通道
##   ① covered[]：该格 3×3 m 范围内有遮挡体多边形（含 5 m 缓冲）⇒ 视为「有掩体」
##   ② raster[]：地形能否挡住 1.6 m 眼高的平视视线（含 SIGHT_MARGIN 容差）
## 两个检查合用一个栅格，避免各扫一遍 100 万格（这是本文件最贵的一段）。
const RASTER_LEVEL_M := 1.6   # 眼高（与 GameConfig.SOLDIER_EYE_HEIGHT 同口径）

static func _build_raster(doc: JieyuMapDoc, step: int) -> Dictionary:
	var cols := maxi(int(ceil(float(doc.width) / float(step))), 1)
	var rows := maxi(int(ceil(float(doc.height_px) / float(step))), 1)
	var covered := PackedByteArray()
	covered.resize(cols * rows)
	covered.fill(0)
	var raster := PackedByteArray()
	raster.resize(cols * rows)
	for row in rows:
		for col in cols:
			var x := mini(col * step, doc.width - 1)
			var y := mini(row * step, doc.height_px - 1)
			if JieyuMapGen.slope_deg_at(doc.height, doc.width, doc.height_px,
					doc.max_elevation(), x, y, step) > GameConfig.MAX_SLOPE_DEG:
				raster[row * cols + col] = 1
	# 遮挡体投影（含缓冲，掩体成簇分布）
	var buffer := JieyuMapSpec.URBAN_SPACING_MIN_M
	for item_v in doc.occluders:
		if not (item_v is Dictionary):
			continue
		var polygon: Variant = (item_v as Dictionary).get("polygon", null)
		if not (polygon is Array) or (polygon as Array).size() < 3:
			continue
		var min_x := INF
		var min_y := INF
		var max_x := -INF
		var max_y := -INF
		for point_v in polygon:
			var point := JieyuMapGen.vec2(point_v)
			min_x = minf(min_x, point.x)
			min_y = minf(min_y, point.y)
			max_x = maxf(max_x, point.x)
			max_y = maxf(max_y, point.y)
		var col0 := maxi(int(floor((min_x - buffer) / float(step))), 0)
		var row0 := maxi(int(floor((min_y - buffer) / float(step))), 0)
		var col1 := mini(int(ceil((max_x + buffer) / float(step))) + 1, cols)
		var row1 := mini(int(ceil((max_y + buffer) / float(step))) + 1, rows)
		for row in range(row0, row1):
			for col in range(col0, col1):
				covered[row * cols + col] = 1
	return {"covered": covered, "raster": raster, "cols": cols, "rows": rows, "step": step}


## 高成本地形检查只跑一次：栅格 + 最长无掩体直线 + 相邻节点连线的通视段
static func _check_terrain_raster(doc: JieyuMapDoc, report: Array, raster: Dictionary) -> void:
	var cols: int = raster["cols"]
	var rows: int = raster["rows"]
	var step: int = raster["step"]
	var covered: PackedByteArray = raster["covered"]
	var blocked: PackedByteArray = raster["raster"]

	# 最长无掩体直线：只在「可通行」的采样带上找，不可通行的陡坡不算「开阔地」
	var longest := 0
	var longest_at := Vector2.ZERO
	var direction := "水平"
	for row in rows:
		var run := 0
		for col in cols:
			var index := row * cols + col
			if covered[index] == 1 or blocked[index] == 1:
				run = 0
				continue
			run += step
			if run > longest:
				longest = run
				longest_at = Vector2(float(col * step), float(row * step))
				direction = "水平"
	for col in cols:
		var run := 0
		for row in rows:
			var index := row * cols + col
			if covered[index] == 1 or blocked[index] == 1:
				run = 0
				continue
			run += step
			if run > longest:
				longest = run
				longest_at = Vector2(float(col * step), float(row * step))
				direction = "垂直"
	if longest > JieyuMapSpec.MAX_OPEN_GROUND_M:
		report.append(_item(SEV_WARN, "terrain.open_ground",
				"%s方向最长无掩体可通行直线 %.0f m > 六章上限 %.0f m（起点约 %s；会被狙击手控图）"
				% [direction, float(longest), JieyuMapSpec.MAX_OPEN_GROUND_M, str(longest_at)],
				{"length_m": longest, "at": [longest_at.x, longest_at.y]}))
	else:
		report.append(_item(SEV_INFO, "terrain.open_ground",
				"最长无掩体可通行直线 %.0f m（上限 %.0f m，%s向，采样步长 %d m）"
				% [float(longest), JieyuMapSpec.MAX_OPEN_GROUND_M, direction, step],
				{"length_m": longest}))

	# 相邻节点连线：按 step 相邻的采样格统计「连续通视」长度（六章：每 150–200 m 打断一次）
	var nodes: Array = doc.zones.get("raas_nodes", [])
	if nodes.size() < 2:
		return
	var worst := 0.0
	var worst_pair := ""
	for i in range(nodes.size() - 1):
		var a := JieyuMapGen.vec2((nodes[i] as Dictionary).get("pos", [0, 0]))
		var b := JieyuMapGen.vec2((nodes[i + 1] as Dictionary).get("pos", [0, 0]))
		var length := a.distance_to(b)
		var steps := maxi(1, int(round(length / float(step))))
		var run := 0.0
		var local_worst := 0.0
		for s in steps + 1:
			var point := a.lerp(b, float(s) / float(steps))
			var col := clampi(int(point.x) / step, 0, cols - 1)
			var row := clampi(int(point.y) / step, 0, rows - 1)
			var index := row * cols + col
			if covered[index] == 0 and blocked[index] == 0:
				run += float(length) / float(steps)
			else:
				local_worst = maxf(local_worst, run)
				run = 0.0
		local_worst = maxf(local_worst, run)
		if local_worst > worst:
			worst = local_worst
			worst_pair = "%s→%s" % [str((nodes[i] as Dictionary).get("id", "?")),
					str((nodes[i + 1] as Dictionary).get("id", "?"))]
	var level := SEV_INFO
	if worst > JieyuMapSpec.SIGHT_BREAK_MAX_M:
		level = SEV_WARN
	report.append(_item(level, "sight.breaks",
			"相邻节点连线最长无遮挡段 %.0f m（六章：每 %.0f–%.0f m 打断一次；最长段在 %s；"
			% [worst, JieyuMapSpec.SIGHT_BREAK_MIN_M, JieyuMapSpec.SIGHT_BREAK_MAX_M, worst_pair]
			+ "采样步长 %d m）" % step, {"longest_open_m": worst, "pair": worst_pair}))


## 两点之间是否能直接看到（眼高用 GameConfig.SOLDIER_EYE_HEIGHT，容差 SIGHT_MARGIN）。
## sample_step_m 越大越快 —— 制高点扫描要跑几万条线，所以它用 4 m；单点判据用 1 m。
static func _is_open_line(doc: JieyuMapDoc, from_world: Vector2, to_world: Vector2,
		sample_step_m: float = SIGHT_SAMPLE_STEP_M) -> bool:
	var distance := from_world.distance_to(to_world)
	if distance < 1.0:
		return true
	var eye := GameConfig.SOLDIER_EYE_HEIGHT
	var margin := GameConfig.SIGHT_MARGIN
	var from_h := doc.sample_bilinear(from_world) + eye
	var to_h := doc.sample_bilinear(to_world) + eye
	var steps := mini(maxi(int(ceil(distance / sample_step_m)), 1), SIGHT_MAX_SAMPLES)
	for i in range(1, steps):
		var t := float(i) / float(steps)
		var point := from_world.lerp(to_world, t)
		var sight_height := lerpf(from_h, to_h, t)
		# 与工程项目同一条判据：视线高度低于地形高度 + 容差 ⇒ 被挡
		if doc.sample_bilinear(point) + margin > sight_height:
			return false
	return true


## ────────────── 制高点覆盖（4.3 第②项 / 12.8.4 约束）──────────────

## 播撒式可见集（viewshed）：从观察点向四周投射线，沿射线维护「已见最大仰角」，
## 某采样点的仰角大于它才可见 —— 等价于逐格 DDA，但一条射线就能判定整条线上的点。
## 掩体层一并判掉（穿到 covered 格里就停），这样调用方拿到就是「地形 + 掩体」两层结论。
## 返回 grid[]：1 = 从观察点可见。
static func _viewshed(doc: JieyuMapDoc, origin: Vector2, grid: PackedByteArray,
		cols: int, rows: int, raster_step: int, covered: PackedByteArray) -> void:
	var eye := GameConfig.SOLDIER_EYE_HEIGHT
	var origin_h := doc.sample_bilinear(origin) + eye
	var max_range := float(maxi(doc.width, doc.height_px))
	# 射线密度取「每格 1.4 条」：太稀会让细长的可见区出现漏格（漏格经腐蚀后变成
	# 「看不见任何节点」的假结论，反而更糟）。
	var ray_count := clampi(int(round(TAU * max_range / float(raster_step) * 0.7)), 128, 512)
	for ray in ray_count:
		var angle := TAU * float(ray) / float(ray_count)
		var direction := Vector2(cos(angle), sin(angle))
		var best_angle := -INF
		var distance := 0.0
		while distance < max_range:
			distance += float(raster_step)
			var point := origin + direction * distance
			if point.x < 0.0 or point.y < 0.0 \
					or point.x >= float(doc.width) or point.y >= float(doc.height_px):
				break
			var col := int(point.x) / raster_step
			var row := int(point.y) / raster_step
			if col < 0 or row < 0 or col >= cols or row >= rows:
				break
			var index := row * cols + col
			if covered[index] == 1:
				break   # 掩体挡死这条射线后面的所有点
			var terrain := doc.sample_bilinear(point)
			var angle_to_point := atan2(terrain - origin_h, distance)
			if angle_to_point >= best_angle:
				best_angle = angle_to_point
				grid[index] = 1
	_erode(grid, cols, rows)


## 3×3 腐蚀：把只有一两个采样格宽的「细可见条带」抹掉。
## 为什么必须做：射线是按栅格步长前进的，贴着射线的细条带会被算成可见，
## 于是地图角上会冒出「站在 (30,30) 能同时看到 4 个节点」这种假结论。
## 真正的制高点（一片连续高地）腐蚀之后仍然活着。
static func _erode(grid: PackedByteArray, cols: int, rows: int) -> void:
	var copy := grid.duplicate()
	grid.fill(0)
	for row in rows:
		for col in cols:
			if copy[row * cols + col] == 0:
				continue
			var solid := true
			for dy in [-1, 0, 1]:
				for dx in [-1, 0, 1]:
					var c: int = col + int(dx)
					var r: int = row + int(dy)
					if c < 0 or r < 0 or c >= cols or r >= rows \
							or copy[r * cols + c] == 0:
						solid = false
						break
				if not solid:
					break
			grid[row * cols + col] = 1 if solid else 0


## 最强制高点：能覆盖 ≥70% 核心区采样点的节点数（12.8.4 上限 2 个）。
## 做法：每个节点先算一张「能看见该节点核心区的格」可见图（含地形与掩体），
## 再逐格数有几个节点可见。
## 为什么不用「逐格 × 逐节点各投一条线」：那是 O(格 × 节点 × 线长)，
## 1000×1000 上实测 4.5 分钟 —— 校验器不能比画地图还慢。
static func _check_overwatch(doc: JieyuMapDoc, report: Array) -> void:
	var nodes: Array = doc.zones.get("raas_nodes", [])
	if nodes.is_empty():
		return
	var raster := _build_raster(doc, 10)
	var cols: int = raster["cols"]
	var rows: int = raster["rows"]
	var step: int = raster["step"]
	var covered: PackedByteArray = raster["covered"]

	var visibility: Array = []
	for node_v in nodes:
		var pos := JieyuMapGen.vec2((node_v as Dictionary).get("pos", [0, 0]))
		var grid := PackedByteArray()
		grid.resize(cols * rows)
		grid.fill(0)
		_viewshed(doc, pos, grid, cols, rows, step, covered)
		visibility.append(grid)

	# 核心区采样点（3×3，半径的 70%）—— 每格问「有几个节点的可见图把这 9 个点都点亮了」
	var core_ratio := JieyuMapSpec.CORE_RADIUS_M * 0.7
	var offsets: Array[Vector2i] = []
	for oy in [-1, 0, 1]:
		for ox in [-1, 0, 1]:
			offsets.append(Vector2i(ox, oy))
	var sample_indices: Array = []
	for i in nodes.size():
		var node_pos := JieyuMapGen.vec2((nodes[i] as Dictionary).get("pos", [0, 0]))
		var indices: PackedInt32Array = PackedInt32Array()
		for offset in offsets:
			var sample := node_pos + Vector2(offset) * core_ratio
			var sample_col := clampi(int(sample.x) / step, 0, cols - 1)
			var sample_row := clampi(int(sample.y) / step, 0, rows - 1)
			indices.append(sample_row * cols + sample_col)
		sample_indices.append(indices)

	var best_count := 0
	var best_at := Vector2.ZERO
	var best_covered: Array = []
	# 离图边 3 个采样格以内不算「制高点」：地图边界没有战术意义，
	# 而且这里正是采样点被钳到边上的地方（过零点会给出「站在角落看四个点」的假结论）。
	var edge_guard := step * 3
	for row in rows:
		for col in cols:
			if col * step < edge_guard or row * step < edge_guard \
					or col * step > doc.width - edge_guard \
					or row * step > doc.height_px - edge_guard:
				continue
			if JieyuMapSpec.gray_to_height(doc.gray_at(col * step, row * step),
					doc.max_elevation()) < JieyuMapSpec.OVERWATCH_MIN_ELEV_M:
				continue
			var visible_nodes: Array = []
			for i in nodes.size():
				var node_pos := JieyuMapGen.vec2((nodes[i] as Dictionary).get("pos", [0, 0]))
				var here := Vector2(float(col * step) + 0.5, float(row * step) + 0.5)
				if here.distance_to(node_pos) < JieyuMapSpec.CORE_RADIUS_M:
					break   # 站在核心区里不算「制高点覆盖」，整格跳过
				var node_grid: PackedByteArray = visibility[i]
				var hits := 0
				for index in sample_indices[i]:
					if node_grid[index] == 1:
						hits += 1
				if float(hits) / float(offsets.size()) \
						>= JieyuMapSpec.OVERWATCH_CORE_COVER_RATIO:
					visible_nodes.append(i)
			if visible_nodes.size() > best_count:
				best_count = visible_nodes.size()
				best_at = Vector2(float(col * step) + 0.5, float(row * step) + 0.5)
				best_covered = visible_nodes
	if best_count > JieyuMapSpec.MAX_NODES_PER_OVERWATCH:
		var ids: Array = []
		for index in best_covered:
			ids.append(str((nodes[index] as Dictionary).get("id", "?")))
		report.append(_item(SEV_WARN, "overwatch.too_many",
				"存在制高点（约 %s）能覆盖 %d 个节点核心区（上限 %d 个）：%s"
				% [str(best_at), best_count, JieyuMapSpec.MAX_NODES_PER_OVERWATCH, str(ids)],
				{"covered": ids, "at": [best_at.x, best_at.y]}))
	else:
		report.append(_item(SEV_INFO, "overwatch.ok",
				"最强的制高点（约 %s）覆盖 %d 个节点核心区（上限 %d）"
				% [str(best_at), best_count, JieyuMapSpec.MAX_NODES_PER_OVERWATCH],
				{"count": best_count}))


## ────────────── 侧翼路线（六章：侧翼路径 ≤ 正面路径 ×1.5）──────────────

## 侧翼路线长度需要真实寻路（nav.json / NavigationRegion2D），当前只做提示。
## 硬凑一个近似会给出假结论 —— 宁可明说没做，也不给会误导的数字。
static func _check_runs(report: Array) -> void:
	report.append(_item(SEV_INFO, "runs.note",
			"侧翼绕后路径长度比未校验（需要 nav.json 或 NavigationRegion2D 才能算）；"
			+ "六章口径：侧翼 ≤ 正面路径 ×1.5", {}))
