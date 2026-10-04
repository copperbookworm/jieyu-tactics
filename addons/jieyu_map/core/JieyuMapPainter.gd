class_name JieyuMapPainter
extends RefCounted

## 地形画笔：插件里所有「改高度」的原子操作都收在这里（纯逻辑，可无头单测）。
##
## 为什么单独一层：编辑器 dock 的每一次拖拽、CLI 的每一个雕刻步骤、一键生成里的
## 「节点压平 / 台地 / 道路」用的是同一批函数。笔刷半径、衰减、道路多宽这些口径
## 只在这里写一次，避免「插件里压平半径 30、脚本里 45」这种漂移。
##
## 边界约定：所有操作只在 [0, width) × [0, height) 内生效，越界静默跳过（不补零、不环绕）。


## ────────────── 笔刷 ──────────────

## 平顶笔刷：把圆盘内高度改成 value
static func paint_flat(doc: JieyuMapDoc, center: Vector2, radius: float, value: float) -> int:
	return _blend_disc(doc, center, radius, value, 1.0, 0.0)


## 抬升笔刷：圆盘内加 delta（负值即挖）。w = 归一化距离，做线性衰减
static func paint_raise(doc: JieyuMapDoc, center: Vector2, radius: float, delta: float) -> int:
	return _offset_disc(doc, center, radius, delta)


## 平滑笔刷：把圆盘内高度拉向圆盘均值（strength = 平滑强度 0–1，按距离衰减）
static func paint_smooth(doc: JieyuMapDoc, center: Vector2, radius: float, strength: float) -> int:
	if radius <= 0.0 or strength <= 0.0:
		return 0
	var average := _disc_average(doc, center, radius)
	if average < 0.0:
		return 0
	return _blend_disc(doc, center, radius, average, clampf(strength, 0.0, 1.0), 0.0)


## 压平圆盘：目标高度 = 圆内均值（target_m < 0）或指定值；边缘 falloff_m 米内平滑过渡
static func flatten_disc(doc: JieyuMapDoc, center: Vector2, radius: float,
		falloff_m: float = 0.0, target_m: float = -1.0) -> int:
	if radius <= 0.0:
		return 0
	var target := target_m
	if target < 0.0:
		target = _disc_average(doc, center, radius)
	if target < 0.0:
		return 0
	return _blend_disc(doc, center, radius + maxf(falloff_m, 0.0), target, 1.0, radius)


## 台地 / 丘陵：在圆内把高度拉到峰高，圆外 falloff_m 内平滑衰减回原高度
static func carve_plateau(doc: JieyuMapDoc, center: Vector2, radius: float,
		peak_m: float, falloff_m: float = 120.0) -> int:
	if radius <= 0.0:
		return 0
	var outer := radius + maxf(falloff_m, 0.0)
	var bounds := _disc_bounds(doc, center, outer)
	var touched := 0
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			var distance := Vector2(x, y).distance_to(center)
			if distance > outer:
				continue
			var weight := 1.0 if distance <= radius \
					else 1.0 - smoothstep(radius, outer, distance)
			var current := doc.height_at(x, y)
			doc.set_height(x, y, lerpf(current, peak_m, weight))
			touched += 1
	return touched


## ────────────── 道路 / 走廊 ──────────────

## 把折线走廊压成一条能跑车的带：先取每个采样点的目标高度（走廊内均值），
## 再把带内高度拉向它。max_slope_deg 是「两个相邻顶点之间的允许坡度」，
## 超过就抬高起点侧 —— 让走廊在山地上也能走通（六章：载具通道宽度 ≥ 8 m）。
static func carve_road(doc: JieyuMapDoc, points: Array[Vector2], width_m: float,
		max_slope_deg: float = 8.0) -> int:
	if points.size() < 2 or width_m <= 0.0:
		return 0
	var targets := _road_targets(doc, points, width_m, max_slope_deg)
	var half := width_m * 0.5
	var touched := 0
	for i in targets.size():
		var center: Vector2 = targets[i]["pos"]
		var target: float = targets[i]["height"]
		var bounds := _disc_bounds(doc, center, half)
		for y in range(bounds.position.y, bounds.end.y):
			for x in range(bounds.position.x, bounds.end.x):
				var distance := Vector2(x, y).distance_to(center)
				if distance > half:
					continue
				var weight := 1.0 - smoothstep(half * 0.6, half, distance)
				doc.set_height(x, y, lerpf(doc.height_at(x, y), target, weight))
				touched += 1
	return touched


## 沿折线按 1 m 步长取采样点 + 目标高度（沿程爬升不超过 max_slope_deg）
static func _road_targets(doc: JieyuMapDoc, points: Array[Vector2], width_m: float,
		max_slope_deg: float) -> Array:
	var samples: Array = []
	var centers: Array[Vector2] = []
	for i in range(1, points.size()):
		var a := points[i - 1]
		var b := points[i]
		var length := a.distance_to(b)
		var steps := maxi(1, int(ceil(length)))
		for s in range(0 if i == 1 else 1, steps + 1):
			centers.append(a.lerp(b, float(s) / float(steps)))
	var slope_tan := tan(deg_to_rad(maxf(max_slope_deg, 0.1)))
	var previous := -1.0
	for center in centers:
		var sample := _disc_average(doc, center, width_m * 0.5)
		if sample < 0.0:
			continue
		if previous >= 0.0:
			var step := center.distance_to(samples[samples.size() - 1]["pos"])
			var allowed := slope_tan * maxf(step, 1.0)
			sample = clampf(sample, previous - allowed, previous + allowed)
		previous = sample
		samples.append({"pos": center, "height": sample})
	return samples


## ────────────── 工具 ──────────────

static func _disc_average(doc: JieyuMapDoc, center: Vector2, radius: float) -> float:
	if radius <= 0.0:
		return -1.0
	var bounds := _disc_bounds(doc, center, radius)
	var total := 0.0
	var count := 0
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			if Vector2(x, y).distance_to(center) > radius:
				continue
			total += doc.height_at(x, y)
			count += 1
	return -1.0 if count == 0 else total / float(count)


static func _disc_bounds(doc: JieyuMapDoc, center: Vector2, radius: float) -> Rect2i:
	var min_x := maxi(floori(center.x - radius), 0)
	var min_y := maxi(floori(center.y - radius), 0)
	var max_x := mini(ceili(center.x + radius) + 1, doc.width)
	var max_y := mini(ceili(center.y + radius) + 1, doc.height_px)
	return Rect2i(min_x, min_y, maxi(max_x - min_x, 0), maxi(max_y - min_y, 0))


## 叠加模式：圆盘内每个格加上 delta × (1 − 归一化距离)（中心满、边缘 0）
static func _offset_disc(doc: JieyuMapDoc, center: Vector2, radius: float, delta: float) -> int:
	if radius <= 0.0:
		return 0
	var bounds := _disc_bounds(doc, center, radius)
	var touched := 0
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			var distance := Vector2(x, y).distance_to(center)
			if distance > radius:
				continue
			var weight := 1.0 - clampf(distance / radius, 0.0, 1.0)
			doc.set_height(x, y, doc.height_at(x, y) + delta * weight)
			touched += 1
	return touched


## 目标模式：把圆盘内高度按 amount 拉向 target。
## flat_radius > 0 时是「平顶 + 外圈 smoothstep 衰减」（压平笔刷的口径）；
## flat_radius = 0 时整个圆盘按 smoothstep 衰减（平滑笔刷的口径）。
static func _blend_disc(doc: JieyuMapDoc, center: Vector2, radius: float, target: float,
		amount: float, flat_radius: float) -> int:
	if radius <= 0.0:
		return 0
	var bounds := _disc_bounds(doc, center, radius)
	var touched := 0
	var clamped_amount := clampf(amount, 0.0, 1.0)
	for y in range(bounds.position.y, bounds.end.y):
		for x in range(bounds.position.x, bounds.end.x):
			var distance := Vector2(x, y).distance_to(center)
			if distance > radius:
				continue
			var blend := clamped_amount
			if distance > flat_radius:
				blend *= 1.0 - smoothstep(flat_radius, radius, distance)
			doc.set_height(x, y, lerpf(doc.height_at(x, y), target, blend))
			touched += 1
	return touched


## ────────────── 掩体 / 区域编辑（zones.json / occluders.json）──────────────

## 加一条可破坏或不可破坏的遮挡体（12.8.7 occluders 口径 + 2026-10-03 的三段阈值）
## destructible=true 时按占地给结构值（拍板②），并带上完好 / 受损 / 摧毁三段阈值（拍板④）。
static func add_occluder(doc: JieyuMapDoc, center: Vector2, half_x: float, half_y: float,
		h_top: float, type_name: String = "building", destructible: bool = true,
		hp: float = 0.0) -> Dictionary:
	var is_building := type_name == "building"
	var item := {
		"id": "%s_%02d" % [type_name, doc.occluders.size() + 1],
		"type": type_name,
		"polygon": JieyuMapGen.rect_polygon(center, half_x, half_y),
		"h_low": 0.0,
		"h_top": roundf(h_top * 10.0) / 10.0,
		"destructible": destructible,
	}
	if destructible:
		if hp > 0.0:
			item["hp"] = hp
		elif is_building:
			item["hp"] = JieyuMapGen.building_hp_for_footprint(half_x * 2.0, half_y * 2.0)
		else:
			item["hp"] = JieyuMapSpec.SANDBAG_HP
		item["damage_profiles"] = JieyuMapGen.damage_profiles_for(is_building)
	# 拍板①开口：建筑默认一窗一门；半高墙默认留一条缝（4.6 铁律：不能完全封闭）
	item["openings"] = JieyuMapGen.default_openings_for(half_x, half_y) if is_building \
			else JieyuMapGen.default_openings_for_wall(half_x, half_y)
	doc.occluders.append(item)
	return item


## ────────────── 开口编辑（窗 / 门洞，拍板①）──────────────

## 往指定遮挡体的某一面墙上加一个开口（窗 / 门）。
## world_point 是落在该遮挡体附近的世界坐标：就近吸附到最近的一面墙，并沿墙夹到两端之内。
## 返回新开口字典；参数非法时返回空字典。
static func add_opening(doc: JieyuMapDoc, occluder_index: int, world_point: Vector2,
		kind: String = JieyuMapSpec.OPENING_WINDOW) -> Dictionary:
	if occluder_index < 0 or occluder_index >= doc.occluders.size():
		return {}
	var item: Dictionary = doc.occluders[occluder_index]
	var polygon: Array = item.get("polygon", [])
	if polygon.size() < 3:
		return {}
	var box := _polygon_bounds(polygon)
	var center := box.get_center()
	var half_x := maxf(box.size.x * 0.5, 0.5)
	var half_y := maxf(box.size.y * 0.5, 0.5)
	var local := world_point - center
	# 就近选面：比较「到四条边中线的距离」，哪条最近就挂哪条
	var distances := [
		absf(local.y + half_y),   # 上边（本地 -y）
		absf(local.y - half_y),   # 下边（本地 +y）
		absf(local.x + half_x),   # 左边（本地 -x）
		absf(local.x - half_x),   # 右边（本地 +x）
	]
	var side := 0
	for i in distances.size():
		if distances[i] < distances[side]:
			side = i
	var along_x := side < 2
	var span := half_x if along_x else half_y
	var want := JieyuMapSpec.WINDOW_HALF_WIDTH if kind == JieyuMapSpec.OPENING_WINDOW \
			else JieyuMapSpec.DOOR_HALF_WIDTH
	var half_w := minf(want, maxf(span - 0.3, 0.3))
	var slide := clampf((local.x if along_x else local.y), -span + half_w, span - half_w)
	var half_t := minf(JieyuMapSpec.OPENING_HALF_THICKNESS,
			maxf((half_y if along_x else half_x) * 0.5, 0.2))
	var opening := {
		"type": kind,
		"center": [0.0, slide] if along_x else [slide, 0.0],
		"half_size": [half_w, half_t] if along_x else [half_t, half_w],
		"h_low": JieyuMapSpec.DOOR_SILL_M if kind == JieyuMapSpec.OPENING_DOOR \
				else JieyuMapSpec.WINDOW_SILL_M,
		"h_top": 0.0,
	}
	# 贴到选中的那一面：-y / +y / -x / +x
	if along_x:
		opening["center"] = [0.0, -half_y if side == 0 else half_y]
	else:
		opening["center"] = [-half_x if side == 2 else half_x, slide]
	var openings: Array = item.get("openings", [])
	openings.append(opening)
	item["openings"] = openings
	return opening


## 删掉指定遮挡体上离 world_point 最近的开口（局部距离在 tolerance 内才删）
static func remove_opening_near(doc: JieyuMapDoc, occluder_index: int, world_point: Vector2,
		tolerance: float = 2.5) -> bool:
	if occluder_index < 0 or occluder_index >= doc.occluders.size():
		return false
	var item: Dictionary = doc.occluders[occluder_index]
	var polygon: Array = item.get("polygon", [])
	if polygon.size() < 3:
		return false
	var center := _polygon_bounds(polygon).get_center()
	var local := world_point - center
	var openings: Array = item.get("openings", [])
	var best := -1
	var best_distance := tolerance
	for i in openings.size():
		var opening_center := JieyuMapGen.vec2((openings[i] as Dictionary).get("center",
				Vector2.ZERO))
		var distance := opening_center.distance_to(local)
		if distance < best_distance:
			best_distance = distance
			best = i
	if best < 0:
		return false
	openings.remove_at(best)
	item["openings"] = openings
	return true


## 找 world_point 落在哪个遮挡体里（先按包围盒命中；margin 可以放宽一点）
## 没命中任何包围盒时返回最近的（便于「点建筑旁边一点」也能吸附）；空数组返回 -1
static func occluder_index_at(doc: JieyuMapDoc, world_point: Vector2, margin: float = 0.0) -> int:
	var best := -1
	var best_distance := INF
	for i in doc.occluders.size():
		var polygon: Array = (doc.occluders[i] as Dictionary).get("polygon", [])
		if polygon.size() < 3:
			continue
		var box := _polygon_bounds(polygon).grow(margin)
		if box.has_point(world_point):
			return i
		var distance := world_point.distance_to(box.get_center())
		if distance < best_distance:
			best_distance = distance
			best = i
	return best


static func _polygon_bounds(polygon: Array) -> Rect2:
	var min_point := Vector2(INF, INF)
	var max_point := Vector2(-INF, -INF)
	for point_v in polygon:
		var point := JieyuMapGen.vec2(point_v)
		min_point = Vector2(minf(min_point.x, point.x), minf(min_point.y, point.y))
		max_point = Vector2(maxf(max_point.x, point.x), maxf(max_point.y, point.y))
	return Rect2(min_point, max_point - min_point)


## 删掉所有多边形与 point 距离 ≤ radius 的遮挡体，返回删掉几个
static func remove_occluders_near(doc: JieyuMapDoc, point: Vector2, radius: float) -> int:
	var kept: Array = []
	var removed := 0
	for item_v in doc.occluders:
		if not (item_v is Dictionary):
			continue
		var item: Dictionary = item_v
		if _polygon_center(item.get("polygon", [])).distance_to(point) <= radius:
			removed += 1
			continue
		kept.append(item)
	doc.occluders = kept
	return removed


static func _polygon_center(polygon: Array) -> Vector2:
	if polygon.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for point_v in polygon:
		sum += JieyuMapGen.vec2(point_v)
	return sum / float(polygon.size())


## 加 / 替换一个 RAAS 节点。节点 id 必须唯一（同名就替换），保证 zones.json 不出现重名
static func upsert_node(doc: JieyuMapDoc, node_id: String, name: String,
		pos: Vector2) -> Dictionary:
	var entry := {"id": node_id, "name": name, "pos": [roundi(pos.x), roundi(pos.y)]}
	var nodes: Array = doc.zones.get("raas_nodes", [])
	var replaced := false
	for i in nodes.size():
		if str((nodes[i] as Dictionary).get("id", "")) == node_id:
			nodes[i] = entry
			replaced = true
			break
	if not replaced:
		nodes.append(entry)
	doc.zones["raas_nodes"] = nodes
	return entry


## 删节点：连同它的 flag / rally_zone 一起删（不然 zones.json 会留下悬空引用）
static func remove_node(doc: JieyuMapDoc, node_id: String) -> bool:
	var nodes: Array = doc.zones.get("raas_nodes", [])
	var kept_nodes: Array = []
	var found := false
	for node_v in nodes:
		if str((node_v as Dictionary).get("id", "")) == node_id:
			found = true
			continue
		kept_nodes.append(node_v)
	if not found:
		return false
	doc.zones["raas_nodes"] = kept_nodes
	doc.zones["flags"] = _filter_by_key(doc.zones.get("flags", []), "node", node_id)
	doc.zones["rally_zones"] = _filter_by_key(doc.zones.get("rally_zones", []), "node", node_id)
	return true


static func _filter_by_key(items: Array, key: String, value: String) -> Array:
	var kept: Array = []
	for item_v in items:
		if item_v is Dictionary and str((item_v as Dictionary).get(key, "")) == value:
			continue
		kept.append(item_v)
	return kept


## 把节点坐标周边的地形压平（节点微调之后要重跑，保证「出生点所属格坡度 < 30°」）
static func flatten_for_nodes(doc: JieyuMapDoc, radius_m: float = -1.0,
		falloff_m: float = 25.0) -> int:
	var radius := radius_m if radius_m > 0.0 else JieyuMapSpec.CORE_RADIUS_M * 2.0
	var touched := 0
	for node_v in doc.zones.get("raas_nodes", []):
		var pos := JieyuMapGen.vec2((node_v as Dictionary).get("pos", [0, 0]))
		touched += flatten_disc(doc, pos, radius, falloff_m, -1.0)
	return touched
