class_name SightSystem
extends RefCounted

## 通视检测（docx 4.7 三级递进）——决定敌人是否显示，不是隐身而是没通视
##   ① 框检测：目标不在屏幕框内，一律不显示
##   ② 地形连线检测：1 m 网格 DDA 逐格，地面比视线高 SIGHT_MARGIN(0.3 m) 以上判遮挡
##   ③ 掩体连线检测：点-多边形 / Occluder 层（见 occluder_blocks）
##   ④ 烟雾层（docx 4.12.1，候选 P）：烟雾＝临时 Occluder，只挡视线不挡子弹（见 smoke_blocks）
## 视线起点取被控单位中心（docx 4.7 / 12.2 补充）
## 数学内核：高度差 ÷ 水平距离 = 坡度（tanθ）——与仰视极限、障碍物阻挡共用

var grid: HeightGrid = null

## 【2026-10-06 第七十九版 · 并行计算整改：本类**不可并行查询**，已实测】
## 结论（取证工具：tools/probe_sight_parallel.gd，真实 Main.tscn，400 条查询）：
##   ① 完整 has_sight：顺序 154.7 µs/条；改成"每个 worker 一个实例 + 11 块并行"后
##      **14258 µs/条（0.01×）**，引擎打 **62980 行**
##      「The function `get_global_position()` on this node can only be accessed from either
##      the main thread or a thread group」—— 掩体层要读 Node2D 的 global_position，
##      而 Godot 的线程安全检查禁止主线程之外访问 Node。
##      （逃生门 Thread.set_thread_safety_checks_enabled(false) 是"后果自负"，不采用。）
##   ② 只并行**地形层**（纯网格、不碰 Node）：44.6 → 14.5 µs/条（3.08×，400/400 逐条一致）。
##      但它只占 has_sight 的 29%，而并行化要引入"每个 worker 一个实例 + 跨线程回传"的复杂度。
## ⇒ 本轮结论：**通视层不并行**。要真并行必须先做架构改造：把掩体几何/开口在装配期烘成
##   只读数组（查询走数组、不碰节点）—— 那也正是 docs/性能预算.md 第十六节登记的欠账。
##
## 另一条硬约束（与线程无关）：本类有实例级共享寄存器，**同一实例不可重入** ——
##   · _dda_cells（DDA 复用缓冲）
##   · _occluder_cache / _occluder_frame（掩体组帧级缓存）
## 所以任何多线程形态都必须"一个查询者一个实例"，不能共用 WorldSetup 建的那一个。

## DDA 复用缓冲（见 HeightGrid.cells_on_segment_into）：只在本文件的热路径用
var _dda_cells: Array[Vector2i] = []
## 掩体组的帧级缓存：get_nodes_in_group 每次都新分配一个 Array，
## 而一次 has_sight 里 occluder_blocks / first_cover 会把掩体组取好几遍。
## ⚠ 烟雾组**不能**这样缓存（见 _smokes() 的注释）。
var _occluder_cache: Array = []
var _occluder_frame := -1


func _init(height_grid: HeightGrid = null) -> void:
	grid = height_grid


func set_grid(height_grid: HeightGrid) -> void:
	grid = height_grid


## ① 框检测（docx 4.7 第①级）：屏幕框外无论有没有通视都不显示
func in_screen_box(target_screen: Vector2, viewport_size: Vector2,
		margin: float = GameConfig.SCREEN_BOX_MARGIN) -> bool:
	var box := Rect2(-Vector2(margin, margin), viewport_size + Vector2(margin, margin) * 2.0)
	return box.has_point(target_screen)


## ① 框检测（世界坐标版，敌人显隐直接用这个，省一次坐标换算）
## camera_center 就是准心（准心 = 屏幕中心 = 相机中心）
func in_world_view(target_world: Vector2, camera_center: Vector2, zoom: float,
		viewport_size: Vector2 = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT),
		margin_px: float = 0.0) -> bool:
	var pixels_per_meter := maxf(zoom, 0.001)
	var half := viewport_size * 0.5 / pixels_per_meter
	var margin := margin_px / pixels_per_meter
	var box := Rect2(camera_center - half - Vector2(margin, margin),
			half * 2.0 + Vector2(margin, margin) * 2.0)
	return box.has_point(target_world)


## ② 地形连线检测：返回第一个挡住的格；没挡住返回 blocked = false
## origin_height / target_height 都是绝对高度（米），一般 = 地面高 + 眼高
## margin_per_meter：容差随距离放宽的斜率（m 容差 / m 距离）。
##   现为 GameConfig.CROSSHAIR_SIGHT_MARGIN_PER_METER = 0 —— 即文档 12.2 的严格口径；
##   之前为缓解「准心老是被挡住」临时放过 0.02，2026-09-28 按用户要求收回。
##   敌人探测等调用方不传本参数，行为不受影响。
func terrain_first_blocker(origin: Vector2, origin_height: float,
		target: Vector2, target_height: float,
		margin_per_meter: float = 0.0) -> Dictionary:
	var result := {"blocked": false, "cell": Vector2i.ZERO, "height": 0.0}
	if grid == null:
		return result

	var cells := grid.cells_on_segment_into(_dda_cells, origin, target)
	if cells.is_empty():
		return result

	var delta := target - origin
	var length_squared := delta.length_squared()
	var seg_length := delta.length()
	# 容差的基础项只读一次（原来每格都去查一遍 GameConfig 的常量）
	var margin_base := GameConfig.SIGHT_MARGIN
	# 快速排除阈值：sight_height = lerp(oh, th, t) ≥ min(oh, th)，而 margin ≥ margin_base，
	# 所以 ground ≤ min(oh, th) + margin_base 的格子**无论 t 取多少都不可能挡住** ——
	# 这一条跳过的只是「投影点积 + 两次向量运算」，判定结果与逐格法完全一致。
	# 2026-10-03 实测：地形层 223 µs 里绝大部分花在每格的 cell_to_world_center 与点积上，
	# 而绝大多数格子本来就远低于两端眼高。
	var floor_skip := minf(origin_height, target_height) + margin_base
	# 起点格的处理（2026-10-06 修正方向不对称）：
	# 旧实现从下标 1 开始 = **跳过起点格**（注释说是为了逐字沿袭更早的 remove_at(0) 版本）。
	# 但"起点格"是**跟方向走的**：`terrain_first_blocker(P→E)` 跳玩家所在格、`(E→P)` 跳敌人所在格
	# ⇒ 两个方向跳的不是同一个格子，端点那两格是否参与判定会随方向翻转。
	# 实测（`scenes/_probe_sight_symmetry.gd`，14.4 万组随机对）：可达状态里有 5 组、含虚构输入共 15 组
	# 因此给出**相反**的答案，即" A 能看见 B" ≠ "B 能看见 A"。判据与机制见 docs/性能预算.md 第十九节。
	# 现在改成**两端都不跳**：
	#   · 起点格本来就几乎总被上面的 floor_skip 快速路径跳过（该格地面通常在起点眼高之下），
	#     所以"把起点格加回来"的实际行为变更极小；
	#   · 而"跳掉终点格"会删掉**目标所在格自己的遮挡判定**，那才是更大的改动 —— 所以不选那条路。
	#   · 结果：地形层判定与射线方向无关（对称），这是"通视"作为物理关系应有的性质。
	for i in range(0, cells.size()):
		var cell: Vector2i = cells[i]
		var ground_height := grid.height_at_cell(cell.x, cell.y)
		if ground_height <= floor_skip:
			continue
		var t := 0.0
		if length_squared > 0.0:
			var to_center := grid.cell_to_world_center(cell) - origin
			t = clampf(to_center.dot(delta) / length_squared, 0.0, 1.0)
		# 视线在该处的高度：两端线性插值（与 docx 12.2 补充的逐格法口径一致）
		var sight_height := lerpf(origin_height, target_height, t)
		# 容差 = 基础容差 + 该处离起点的距离 × 斜率（越远越宽容）
		var margin := margin_base + margin_per_meter * (t * seg_length)
		if ground_height > sight_height + margin:
			result["blocked"] = true
			result["cell"] = cell
			result["height"] = ground_height
			return result
	return result


## ③·补充 烟雾层（docx 4.12.1：烟雾 = 临时 Occluder）
## 与掩体同一套高度规则（blocks_sight），但走**独立的 SMOKE_GROUP**——因为 occluder 组
## 同时被子弹截断（first_cover）使用，烟雾混进去就会挡子弹，违反 4.12.6。
## 只要线段穿过任一活着的烟饼、且穿越点的视线高度低于烟顶（地面 + 3 m），就判被遮挡。
func smoke_blocks(origin: Vector2, origin_height: float,
		target: Vector2, target_height: float) -> bool:
	var total := origin.distance_to(target)
	if total <= 0.001:
		return false
	for node in _smokes():
		var smoke = node
		if smoke == null or not smoke.has_method("segment_crossing"):
			continue
		if smoke.has_method("is_active") and not smoke.is_active():
			continue
		var hit: Vector2 = smoke.segment_crossing(origin, target)
		if hit == Vector2.INF:
			continue
		var t := clampf(origin.distance_to(hit) / total, 0.0, 1.0)
		var sight_height := lerpf(origin_height, target_height, t)
		var ground := 0.0
		if grid != null:
			ground = grid.sample_bilinear(smoke.global_position)
		if blocks_sight(sight_height, smoke.top_height_at(ground)):
			return true
	return false


## 线段上第一个活烟饼的入射点（准心回退用，docx 4.12.4）；没有烟则返回 Vector2.INF
func first_smoke_hit(from: Vector2, to: Vector2) -> Vector2:
	var nearest := Vector2.INF
	var nearest_distance := INF
	for node in _smokes():
		var smoke = node
		if smoke == null or not smoke.has_method("segment_crossing"):
			continue
		if smoke.has_method("is_active") and not smoke.is_active():
			continue
		var hit: Vector2 = smoke.segment_crossing(from, to)
		if hit == Vector2.INF:
			continue
		var distance := from.distance_to(hit)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = hit
	return nearest


## ③ 掩体层（第一版未接入物理查询，保留接口避免后面挖坑）
## 期望实现：Occluder 组节点提供 [H_low, H_top] 高度区间，
## 用 intersect_ray 取 t，与地形结果取 t 小者（docx 4.7 第③级 / 12.2 补充职责收缩）
## ③ 掩体层（docx 4.7 第③级）：遍历 "occluder" 组的掩体，
## 视线穿过掩体、且交点处的视线高度没高出掩体顶（+COVER_SIGHT_SLACK）→ 判遮挡。
## 掩体顶高 = 掩体所在处地面高 + 掩体自身高度。用鸭子类型调用，不依赖 Cover 的类名。
##
## 【2026-10-03 拍板①】开口（窗 / 门洞）：交点若落在开口格内、且视线高度落在开口区间里，
## 这一条视线就从开口穿过去（不判遮挡）。所以在屋子里不再绝对安全 ——
## 站姿能透过窗看到屋里的人，卧姿（0.6 m）低于窗台（1.0 m）就看不到，与 C2 矮掩体同一套直觉。
func occluder_blocks(origin: Vector2, origin_height: float,
		target: Vector2, target_height: float) -> bool:
	# 粗筛（2026-10-05 性能修复）：正式图「青岭走廊」掩体很多，逐块做「本地空间变换 + 4 次线段求交」
	# 实测要 1.6 ms/次。先用「掩体包围圆 vs 线段」的距离测试挡掉绝大多数 —— 外接圆只可能多留，
	# 不会漏掉真正相交的块，所以判定结果与原来完全一致。
	var seg := target - origin
	var seg_len_sq := seg.length_squared()
	for node in _occluders():
		var cover = node
		if cover == null or not is_instance_valid(cover) or not cover.has_method("segment_hit"):
			continue
		if not circle_hits_segment(cover.global_position, cover_radius(cover),
				origin, seg, seg_len_sq):
			continue
		if cover_blocks(cover, origin, origin_height, target, target_height,
				_ground_under(cover)):
			return true
	return false

## 圆与线段是否可能相交（粗筛用）：圆心到线段的最近距离 ≤ 半径。
static func circle_hits_segment(center: Vector2, radius: float, from: Vector2,
		seg: Vector2, seg_len_sq: float) -> bool:
	if seg_len_sq <= 0.000001:
		return center.distance_squared_to(from) <= radius * radius
	var t := clampf((center - from).dot(seg) / seg_len_sq, 0.0, 1.0)
	return (from + seg * t).distance_squared_to(center) <= radius * radius


## 掩体粗筛半径 ＝ 矩形外接圆半径；取不到（非 Cover 的遮挡体）就给个大值 ⇒ 不粗筛、宁慢不漏。
static func cover_radius(cover) -> float:
	var half = cover.get("half_size")
	if half is Vector2:
		return (half as Vector2).length()
	return 100000.0


## 单块掩体挡不挡这条视线（**纯静态判定**，不查组、不需要场景树 —— 便于单测与复用）。
## origin_height / target_height / ground 都是**绝对高度**（米）；掩体开口区间是相对地面的，
## 所以这里把视线高度减去 ground，交给 Cover.segment_hit() 做开口判定（两套口径在这里对齐）。
## 判定链（拍板①开口）：
##   ① 入口高度 = 线段与掩体矩形的第一个几何交点处的高度
##   ② 若整条线都从开口（窗 / 门洞）穿过去 ⇒ 不挡
##   ③ 否则按「第一个非开口交点」的视线高度与掩体顶高比：没高出顶高（+容差）⇒ 挡
static func cover_blocks(cover, origin: Vector2, origin_height: float,
		target: Vector2, target_height: float, ground: float) -> bool:
	if cover == null or not cover.has_method("segment_hit"):
		return false
	var total := origin.distance_to(target)
	if total <= 0.001:
		return false
	var cover_top: float = cover.top_height_at(ground)
	# 入口处的高度：用「忽略开口」的第一个几何交点算
	var entry: Vector2 = cover.wall_hit(origin, target, INF, false) \
			if cover.has_method("wall_hit") else cover.segment_hit(origin, target)
	if entry == Vector2.INF:
		return false
	var entry_t := clampf(origin.distance_to(entry) / total, 0.0, 1.0)
	var entry_height := lerpf(origin_height, target_height, entry_t) - ground
	var hit: Vector2 = cover.segment_hit(origin, target, entry_height)
	if hit == Vector2.INF:
		return false   # 从窗 / 门洞穿过去了
	var t := clampf(origin.distance_to(hit) / total, 0.0, 1.0)
	var sight_height := lerpf(origin_height, target_height, t)
	return blocks_sight(sight_height, cover_top)


## 这个掩体脚下的地面高（掩体顶高与开口高度都是相对地面的）
func ground_under(cover) -> float:
	return _ground_under(cover)


func _ground_under(cover) -> float:
	if grid == null or cover == null:
		return 0.0
	return grid.sample_bilinear(cover.global_position)


## 高度规则（纯函数，便于测试）：视线高度没高出掩体顶（+容差）就判被挡
## 这就是 C2「卧姿矮掩体」的核心判定：站着能看过沙袋，趴下就看不出去
static func blocks_sight(sight_height: float, cover_top: float) -> bool:
	return sight_height < cover_top + GameConfig.COVER_SIGHT_SLACK


## 线段上第一个掩体：返回 {node, point}（没有掩体则 node 为 null、point 为 Vector2.INF）
## 准心回退用 point，子弹截断要把 node 带回去扣血（可破坏掩体）。
## 【2026-10-03 拍板①】判据全部收在 Cover.segment_hit() 里：从窗 / 门洞穿过去的交点不算「挡住」，
## 所以「看得见」与「打得着」自动是同一套开口口径，不会出现两套判定打架。
func first_cover(from: Vector2, to: Vector2, sight_height_at: float = INF) -> Dictionary:
	var nearest_node = null
	var nearest_point := Vector2.INF
	var nearest_distance := INF
	var seg := to - from
	var seg_len_sq := seg.length_squared()
	for node in _occluders():
		var cover = node
		if cover == null or not is_instance_valid(cover) or not cover.has_method("segment_hit"):
			continue
		if not circle_hits_segment(cover.global_position, cover_radius(cover),
				from, seg, seg_len_sq):
			continue
		var hit: Vector2 = cover.segment_hit(from, to, sight_height_at)
		if hit == Vector2.INF:
			continue
		var distance := from.distance_to(hit)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_point = hit
			nearest_node = cover
	return {"node": nearest_node, "point": nearest_point}


## 线段上第一个掩体交点（准心回退用）；没有掩体则返回 Vector2.INF
func first_cover_hit(from: Vector2, to: Vector2) -> Vector2:
	var info := first_cover(from, to)
	return info["point"]


## "occluder" 组（掩体）——通过 main loop 取，省得每个调用方都传一遍列表
func _occluders() -> Array:
	var frame := Engine.get_physics_frames()
	if frame == _occluder_frame:
		return _occluder_cache
	var loop := Engine.get_main_loop() as SceneTree
	_occluder_cache = loop.get_nodes_in_group(GameConfig.OCCLUDER_GROUP) if loop != null else []
	_occluder_frame = frame
	return _occluder_cache


## 烟雾组（与掩体分开取：烟只挡视线，见 smoke_blocks 注释）
## ⚠ 烟雾组**不做帧级缓存**（2026-10-05 实测被集成冒烟抓住）：4.12.5 要求「新放的烟当帧立刻生效」，
## 缓存会让同一帧内刚生成的烟查不到，投烟后那一条视线仍判通 ⇒ 候选 P 的 6 条检查全红。
## 烟雾层只要 ~1 µs，缓存它本来也省不到什么。
func _smokes() -> Array:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return []
	return loop.get_nodes_in_group(GameConfig.SMOKE_GROUP)


## ② 与 ③ 合并：地形层 + 掩体层 + 烟雾层
## margin_per_meter 只作用于地形层（准心瞄准用，见 AimCameraController 的注释）
## 感知节流器（每个单位自己持一个实例）
##
## 为什么要「一个单位一个」而不是一张全局表：缓存里存的是「这个单位能不能看到它的目标」，
## 一旦把不同单位的查询塞进同一张表，就得给「单位 + 目标」拼复合键 —— 既慢又容易串味。
## 每个单位持一份，语义天然正确（队友换目标时 reset 一下即可）。
class Throttle extends RefCounted:
	var period := 4
	var calls := 0        ## 诊断：真查了几次
	var hits := 0         ## 诊断：命中缓存几次
	var _frame := -999999
	var _result := false
	var _valid := false

	func _init(frames: int = -1) -> void:
		period = maxi(frames if frames > 0 else GameConfig.SIGHT_THROTTLE_FRAMES, 1)

	## 换目标 / 换场景时清掉，免得把上一个目标的结果当成这个目标的
	func reset() -> void:
		_valid = false
		_frame = -999999

	func sight(sight, frame: int, origin: Vector2, origin_height: float,
		target: Vector2, target_height: float, margin_per_meter: float = 0.0) -> bool:
		if _valid and period > 1 and frame - _frame < period:
			hits += 1
			return _result
		_result = sight.has_sight(origin, origin_height, target, target_height, margin_per_meter)
		_frame = frame
		_valid = true
		calls += 1
		return _result

	## 只节流「地形 + 掩体」两层（见 SightSystem.sight_core）；烟雾层由调用方每帧新鲜查 —— 
	## docx 4.12.5「无通视 → 转入盲射」靠的就是烟雾那一下翻转，不能一起节流。
	func core(sight, frame: int, origin: Vector2, origin_height: float,
			target: Vector2, target_height: float, margin_per_meter: float = 0.0) -> bool:
		if _valid and period > 1 and frame - _frame < period:
			hits += 1
			return _result
		_result = sight.sight_core(origin, origin_height, target, target_height, margin_per_meter)
		_frame = frame
		_valid = true
		calls += 1
		return _result


func has_sight(origin: Vector2, origin_height: float,
		target: Vector2, target_height: float, margin_per_meter: float = 0.0) -> bool:
	if terrain_first_blocker(origin, origin_height, target, target_height,
			margin_per_meter)["blocked"]:
		return false
	if occluder_blocks(origin, origin_height, target, target_height):
		return false
	return not smoke_blocks(origin, origin_height, target, target_height)


## 只查**贵的两层**（地形 + 掩体），**不查烟雾**：
## 2026-10-03 实测（debug 构建）烟雾层只要 ~1 µs，而地形层 151 µs + 掩体层 43 µs。
## 所以「地形 + 掩体」可以节流，「烟雾」必须每帧新鲜 —— docx 4.12.5「无通视 → 转入盲射」就靠烟雾那一下翻转。
## has_sight = terrain ∧ occluder ∧ ¬smoke，这里给的是前两项的合取，拼起来的结果与 has_sight 完全一致。
func sight_core(origin: Vector2, origin_height: float,
	target: Vector2, target_height: float, margin_per_meter: float = 0.0) -> bool:
	if terrain_first_blocker(origin, origin_height, target, target_height,
			margin_per_meter)["blocked"]:
		return false
	return not occluder_blocks(origin, origin_height, target, target_height)


## 单位的视线绝对高度：带 sight_eye_height() 的单位（玩家）按姿态取值——
## 卧姿 0.6 m（C2「矮掩体」），其余用默认眼高 1.6 m。
## 所有「从玩家出发」的通视判定（敌人显隐、准心遮挡、探针）都必须走这里，口径才一致。
func unit_sight_height(world_pos: Vector2, unit: Node) -> float:
	var eye := GameConfig.SOLDIER_EYE_HEIGHT
	if unit != null and unit.has_method("sight_eye_height"):
		eye = unit.sight_eye_height()
	if grid == null:
		return eye
	return grid.sample_bilinear(world_pos) + eye


## 站在地面上的单位，视线起点高度 = 脚下地面高 + 眼高
func eye_height_at(world_pos: Vector2,
		eye_height: float = GameConfig.SOLDIER_EYE_HEIGHT) -> float:
	if grid == null:
		return eye_height
	return grid.sample_bilinear(world_pos) + eye_height


## 最高点（docx 12.6 图②）：供准心钳制与坡度校验复用
func highest_on_segment(from_world: Vector2, to_world: Vector2) -> Dictionary:
	if grid == null:
		return {"cell": Vector2i.ZERO, "height": 0.0}
	return grid.highest_cell_on_segment(from_world, to_world)
