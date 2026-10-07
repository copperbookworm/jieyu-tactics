extends RefCounted

## 掩体空间网格索引（2026-10-06 第七十九版·三 · 使用者拍板 Q3）
##
## 要解决的问题：`JieyuMapGen.nearest_occluder_distance(occluders, point)` 是「逐点 × 全表掩体」，
## 而校验器的出生区落脚地判据会对**每个采样点**调一次（5 m 步长）⇒ 1076 块掩体时要 24.5 s。
## 这个索引把它降到"只看点附近几格里的掩体"，且**结果与原实现逐位相同**。
##
## 用法（实例方法，不用 static 工厂 —— 静态里 new() 的写法在无 class_name 的模块里容易踩坑）：
##   const OccluderIndexScript := preload("res://addons/jieyu_map/core/JieyuOccluderIndex.gd")
##   var idx = OccluderIndexScript.new()
##   idx.build(doc.occluders, 25.0)
##   var d: float = idx.nearest_distance(point)
##
## 为什么这次不会重演第十六节那次回滚（掩体空间索引做了又回滚）：
##   · **没有共享缓冲**：查询只用局部变量 + 只读索引，不存在"上一次查询把候选缓冲清空"的耦合；
##   · **早停判据是可证明保守的**（下面注释给了推导），不是"看起来差不多"；
##   · 等价性有专门测试逐点对拍（test/jieyu_occluder_index_test.gd），并且校验器/生成器整轮对拍。
##
## 只在**编辑器侧**（地图生成 / 校验）用，不进运行时热路径。

## 默认格边长（m）。取 25 m 的理由：真图 235 块掩体 / 1 km² ⇒ 平均每格 0.15 块；
## 查询通常只需扩 1~3 圈（25~75 m）就能盖住最近掩体 ⇒ 候选从 235 降到个位数。
const DEFAULT_CELL_M := 25.0

var cell_m := DEFAULT_CELL_M
var _cols := 0
var _rows := 0
var _origin := Vector2.ZERO
## 格号 → 掩体下标数组（只建非空格，省内存也省建表时间）
var _buckets: Dictionary = {}
## 可行掩体的多边形（顶点数 >= 3 的才收，与原实现同一门槛）
var _polygons: Array = []


func is_empty() -> bool:
	return _polygons.is_empty()


func count() -> int:
	return _polygons.size()


## 建索引。occluders 是 doc.occluders 那样的字典数组（只读，不复制多边形）。
func build(occluders: Array, cell_size: float = DEFAULT_CELL_M) -> void:
	cell_m = maxf(cell_size, 1.0)
	_buckets.clear()
	_polygons.clear()
	if occluders.is_empty():
		_cols = 0
		_rows = 0
		return
	var low := Vector2(INF, INF)
	var high := Vector2(-INF, -INF)
	for item_v in occluders:
		if not (item_v is Dictionary):
			continue
		var polygon: Variant = (item_v as Dictionary).get("polygon", [])
		if not (polygon is Array) or (polygon as Array).size() < 3:
			continue
		var bounds := _bounds_of(polygon as Array)
		low = Vector2(minf(low.x, bounds.position.x), minf(low.y, bounds.position.y))
		high = Vector2(maxf(high.x, bounds.end.x), maxf(high.y, bounds.end.y))
		_polygons.append(polygon)
	if _polygons.is_empty():
		_cols = 0
		_rows = 0
		return
	_origin = low
	_cols = maxi(int(floor((high.x - low.x) / cell_m)) + 1, 1)
	_rows = maxi(int(floor((high.y - low.y) / cell_m)) + 1, 1)
	# 每块掩体登记进**它外接矩形覆盖的所有格**（不是"中心点所在格"）：
	# 这是第十六节那次踩过的坑 —— 只按中心登记会漏掉"中心不在线段经过的格里、但 AABB 与线段相交"的掩体。
	for i in _polygons.size():
		var bounds := _bounds_of(_polygons[i] as Array)
		var gx0 := clampi(int(floor((bounds.position.x - _origin.x) / cell_m)), 0, _cols - 1)
		var gy0 := clampi(int(floor((bounds.position.y - _origin.y) / cell_m)), 0, _rows - 1)
		var gx1 := clampi(int(floor((bounds.end.x - _origin.x) / cell_m)), 0, _cols - 1)
		var gy1 := clampi(int(floor((bounds.end.y - _origin.y) / cell_m)), 0, _rows - 1)
		for gy in range(gy0, gy1 + 1):
			for gx in range(gx0, gx1 + 1):
				var key := gy * _cols + gx
				var bucket: PackedInt32Array = _buckets.get(key, PackedInt32Array())
				bucket.append(i)
				_buckets[key] = bucket


## 点 → 最近掩体多边形的距离（在里面 = 0，在外面 = 到边界距离；没有掩体 = INF）。
## 与 `JieyuMapGen.nearest_occluder_distance` 同口径、同结果。
##
## 早停推导（保守性）：点在第 c 格，搜完"以 c 为中心、切比雪夫半径 k"的整块格子后，
## 块的世界范围是 [(cx-k)·s, (cx+k+1)·s) × …；点本身在 [cx·s, (cx+1)·s) 内，
## 所以点离块外任意一点的距离 ≥ k·s。掩体整体位于它自己的 AABB 内、而 AABB 覆盖的每一格都登记过，
## 因此"还没被搜到的掩体"离点必 ≥ k·s ⇒ 只要当前最优 best ≤ k·s 就可以停。
func nearest_distance(point: Vector2) -> float:
	if _polygons.is_empty():
		return INF
	var cx := int(floor((point.x - _origin.x) / cell_m))
	var cy := int(floor((point.y - _origin.y) / cell_m))
	var best := INF
	var max_rings := _cols + _rows + 2
	var k := 0
	while k <= max_rings:
		var gx0 := cx - k
		var gx1 := cx + k
		var gy0 := cy - k
		var gy1 := cy + k
		# 只走"这一圈"的格子（内层已被上一圈搜过）
		for gy in range(gy0, gy1 + 1):
			var is_edge_row := gy == gy0 or gy == gy1
			if not is_edge_row and k > 0:
				# 非首末行的中间行只有两个端点格是新的
				best = minf(best, _scan_cell(point, gx0, gy))
				best = minf(best, _scan_cell(point, gx1, gy))
				continue
			for gx in range(gx0, gx1 + 1):
				best = minf(best, _scan_cell(point, gx, gy))
		# k = 0 时 lower_bound = 0：只有 best 恰好为 0（点在掩体内）才会停，那也是正确的最优
		if best <= float(k) * cell_m:
			break
		k += 1
	return best


## 扫一格；越界返回 INF（等价于"这格没有掩体"）
func _scan_cell(point: Vector2, gx: int, gy: int) -> float:
	if gx < 0 or gy < 0 or gx >= _cols or gy >= _rows:
		return INF
	var bucket: Variant = _buckets.get(gy * _cols + gx, null)
	if bucket == null:
		return INF
	var best := INF
	var indices: PackedInt32Array = bucket
	for i in indices:
		var polygon: Array = _polygons[i]
		if _inside(polygon, point):
			return 0.0
		best = minf(best, _edge_distance(polygon, point))
	return best


## ── 以下三个几何判据与 JieyuMapGen 的同名实现逐字同口径（避免两套口径漂移）──

func _bounds_of(polygon: Array) -> Rect2:
	if polygon.is_empty():
		return Rect2()
	var low := _pt(polygon[0])
	var high := _pt(polygon[0])
	for point_v in polygon:
		var p := _pt(point_v)
		low = Vector2(minf(low.x, p.x), minf(low.y, p.y))
		high = Vector2(maxf(high.x, p.x), maxf(high.y, p.y))
	return Rect2(low, high - low)


func _pt(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Array and (value as Array).size() >= 2:
		var a: Array = value
		return Vector2(float(a[0]), float(a[1]))
	return Vector2.ZERO


## 射线法（与 JieyuMapGen.point_in_polygon 同口径）
func _inside(polygon: Array, point: Vector2) -> bool:
	var inside := false
	var count := polygon.size()
	var j := count - 1
	for i in count:
		var a := _pt(polygon[i])
		var b := _pt(polygon[j])
		if ((a.y > point.y) != (b.y > point.y)) \
				and (point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x):
			inside = not inside
		j = i
	return inside


## 点到多边形边界的最短距离
func _edge_distance(polygon: Array, point: Vector2) -> float:
	var best := INF
	var count := polygon.size()
	for i in count:
		var a := _pt(polygon[i])
		var b := _pt(polygon[(i + 1) % count])
		best = minf(best, _point_segment_distance(a, b, point))
	return best


func _point_segment_distance(a: Vector2, b: Vector2, point: Vector2) -> float:
	var span := b - a
	var length_squared := span.length_squared()
	if length_squared <= 0.000001:
		return point.distance_to(a)
	return point.distance_to(a + span * clampf((point - a).dot(span) / length_squared, 0.0, 1.0))
