extends RefCounted

## 出生点挑选（2026-10-05 · 「出生区也读地图」）
##
## 为什么要它：zones.json 只给**出生区多边形**，不给出生点。取质心最省事，但实测正式图「青岭走廊」
## 的 west 出生区质心是 **60.5°** 的坡（demo 出生点也有 45.8°）—— 因为地图生成器只压平节点核心，
## **不压平出生区**（这条盲点已登记在案）。所以出生点必须现挑：在多边形里找
## 「站得住 + 不贴掩体 + 离占领点够远」的点。
##
## 判据全部来自既有口径，不新开数字：
##   · 坡度：双尺度（8 m 与 4 m）都不超过 GameConfig.MAX_SLOPE_DEG（12.8.5 ⑤）
##   · 掩体：离最近遮挡体多边形 ≥ MIN_COVER_DIST（别出生就卡在楼里）
##   · 离占领点：12.8.4「续航区在点外 100~200 m」—— 100 起，挑不出逐级放宽 60 / 30 / 0
##     （某张图的出生区本来就贴着节点时，不至于挑不出点）
##   · 并列时依次比：step8 坡度 → step4 坡度 → 离掩体更远 → 离出生区边界更远（别贴着边界刷）
##
## 只吃 HeightGrid / 多边形 / 点集，不碰场景树 ⇒ 可无头单测（test/spawn_picker_test.gd）。

const SAMPLE_STEP := 3.0          # m，多边形内的采样步长
const EDGE_MARGIN := 4.0          # m，离出生区边界至少留这么多
const MIN_COVER_DIST := 5.0       # m，与遮挡体多边形的最小距离
const SLOPE_STEPS := [8, 4]       # 双尺度坡度（1 灰度的量化台阶在 4 m 尺度上仍有意义）
const NODE_DIST_TIERS := [100.0, 60.0, 30.0, 0.0]   # 12.8.4 的点外距离，逐级放宽
const NUDGE_RADIUS := 15.0        # m，局部微调（敌人 / 载具的偏移点用）
const NUDGE_STEP := 2.0


## [x, y] 数组或 Vector2 都收（zones.json 里是数组）
static func to_vec2(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Array and (value as Array).size() >= 2:
		return Vector2(float(value[0]), float(value[1]))
	return Vector2.ZERO


static func polygon_points(polygon: Array) -> Array:
	var points: Array = []
	for raw in polygon:
		points.append(to_vec2(raw))
	return points


static func polygon_bounds(polygon: Array) -> Rect2:
	var points := polygon_points(polygon)
	if points.is_empty():
		return Rect2()
	var min_point: Vector2 = points[0]
	var max_point: Vector2 = points[0]
	for point in points:
		min_point = Vector2(minf(min_point.x, point.x), minf(min_point.y, point.y))
		max_point = Vector2(maxf(max_point.x, point.x), maxf(max_point.y, point.y))
	return Rect2(min_point, max_point - min_point)


## 射线法内外判定（凸 / 凹多边形都对）
static func point_in_polygon(polygon: Array, point: Vector2) -> bool:
	var points := polygon_points(polygon)
	var count := points.size()
	if count < 3:
		return false
	var inside := false
	var j := count - 1
	for i in count:
		var a: Vector2 = points[i]
		var b: Vector2 = points[j]
		if ((a.y > point.y) != (b.y > point.y)) \
				and point.x < (b.x - a.x) * (point.y - a.y) / maxf(b.y - a.y, 0.00001) + a.x:
			inside = not inside
		j = i
	return inside


## 点到多边形边界的最小距离（点在里面时也给的是「离边界多远」）
static func edge_distance(polygon: Array, point: Vector2) -> float:
	var points := polygon_points(polygon)
	var count := points.size()
	if count == 0:
		return INF
	if count == 1:
		return point.distance_to(points[0])
	var best := INF
	for i in count:
		var a: Vector2 = points[i]
		var b: Vector2 = points[(i + 1) % count]
		best = minf(best, _segment_distance(a, b, point))
	return best


## 点与多边形的关系距离：在里面 = 0，在外面 = 到边界的距离
static func polygon_distance(polygon: Array, point: Vector2) -> float:
	if point_in_polygon(polygon, point):
		return 0.0
	return edge_distance(polygon, point)


static func _segment_distance(a: Vector2, b: Vector2, point: Vector2) -> float:
	var span := b - a
	var length_squared := span.length_squared()
	if length_squared <= 0.000001:
		return point.distance_to(a)
	var t := clampf((point - a).dot(span) / length_squared, 0.0, 1.0)
	return point.distance_to(a + span * t)


## 双尺度坡度都合格吗（12.8.5 ⑤）
static func slope_ok(grid: HeightGrid, point: Vector2) -> bool:
	if grid == null:
		return true
	for step in SLOPE_STEPS:
		if slope_at(grid, point, int(step)) > GameConfig.MAX_SLOPE_DEG:
			return false
	return true


## 世界点处、朝 +x / +y 走 step 米的坡度取大者（与 HeightGrid.slope_deg 同一条数学）
static func slope_at(grid: HeightGrid, point: Vector2, step: int) -> float:
	if grid == null:
		return 0.0
	var here := grid.world_to_cell(point)
	var right := grid.world_to_cell(point + Vector2(float(step), 0.0))
	var down := grid.world_to_cell(point + Vector2(0.0, float(step)))
	return maxf(grid.slope_deg(here, right), grid.slope_deg(here, down))


## 离最近遮挡体多边形的距离
static func cover_distance(occluders: Array, point: Vector2) -> float:
	var best := INF
	for entry in occluders:
		var polygon: Variant = entry.get("polygon") if entry is Dictionary else entry
		if polygon is Array and (polygon as Array).size() >= 3:
			best = minf(best, polygon_distance(polygon, point))
	return best


## 多边形里挑一个出生点：挑不出返回 Vector2.INF（调用方自己退回兜底点）。
## avoid_points 一般是地图的 RAAS 节点（12.8.4：续航区在点外 100~200 m）。
static func pick(grid: HeightGrid, polygon: Array, avoid_points: Array,
		occluders: Array) -> Vector2:
	if polygon.size() < 3:
		return Vector2.INF
	var bounds := polygon_bounds(polygon)
	for tier in NODE_DIST_TIERS:
		var best := Vector2.INF
		var best_key := [INF, INF, -INF, -INF]
		var cols := int(maxf(bounds.size.x - EDGE_MARGIN * 2.0, 0.0) / SAMPLE_STEP) + 1
		var rows := int(maxf(bounds.size.y - EDGE_MARGIN * 2.0, 0.0) / SAMPLE_STEP) + 1
		for col in cols:
			for row in rows:
				var point := bounds.position + Vector2(EDGE_MARGIN, EDGE_MARGIN) \
						+ Vector2(float(col), float(row)) * SAMPLE_STEP
				if not point_in_polygon(polygon, point):
					continue
				if edge_distance(polygon, point) < EDGE_MARGIN:
					continue
				if not _far_from_avoid(point, avoid_points, float(tier)):
					continue
				var cover := cover_distance(occluders, point)
				if cover < MIN_COVER_DIST:
					continue
				if not slope_ok(grid, point):
					continue
				var key := [slope_at(grid, point, 8), slope_at(grid, point, 4), -cover,
						-edge_distance(polygon, point)]
				if _key_better(key, best_key):
					best_key = key
					best = point
		if best != Vector2.INF:
			return best
	return Vector2.INF


## 局部微调：在 ideal 周围 radius 内找最平的点（敌人 / 载具的偏移点用）。
## 找不到合格点就返回 ideal 本身 —— 调用方要的是「尽量站得住」，不是「必须完美」。
static func nudge(grid: HeightGrid, ideal: Vector2, radius: float, occluders: Array) -> Vector2:
	if grid == null:
		return ideal
	var best := Vector2.INF
	var best_key := [INF, INF, -INF]
	var steps := int(maxf(radius, 0.0) / NUDGE_STEP)
	for dx in range(-steps, steps + 1):
		for dy in range(-steps, steps + 1):
			var point := ideal + Vector2(float(dx), float(dy)) * NUDGE_STEP
			if point.distance_to(ideal) > radius:
				continue
			if not slope_ok(grid, point):
				continue
			var cover := cover_distance(occluders, point)
			if cover < MIN_COVER_DIST:
				continue
			var key := [slope_at(grid, point, 8), slope_at(grid, point, 4), -cover]
			if _key_better(key, best_key):
				best_key = key
				best = point
	return ideal if best == Vector2.INF else best


static func _far_from_avoid(point: Vector2, avoid_points: Array, tier: float) -> bool:
	if tier <= 0.0:
		return true
	for raw in avoid_points:
		if point.distance_to(to_vec2(raw)) < tier:
			return false
	return true


## 字典序比较：**每一维都是越小越好**（所以想最大化的量在组 key 时就取负）。
## 遇到 nan（例如两边都没有掩体 ⇒ -INF 与 -INF 相减）当作相等，继续比下一维。
static func _key_better(candidate: Array, current: Array) -> bool:
	for i in candidate.size():
		var a: float = candidate[i]
		var b: float = current[i]
		if is_nan(a) or is_nan(b):
			continue
		if a < b - 0.001:
			return true
		if a > b + 0.001:
			return false
	return false
