class_name BallisticsSystem
extends RefCounted

## 弹道与命中判定（docx 7.4.2 + 第十八章「直瞄射程口径」确认稿）
## 直瞄：不做弹道高度/重力下坠（俯视 2D 下坠不可见），命中 = 射线穿圆 + max_range 截断
## 重力/弹道高度（simulate）只保留给间瞄——高弹道越障是俯视 2D 里唯一必须逐点算高度的场景

const MAX_STEPS := 20000  # 防死循环


## 间瞄弹道采样（docx 7.4.2，高弹道越障用）：每 1m 水平距离一个点
## 直瞄不再调用——直瞄是纯水平射线（见 resolve_shot）
## 返回 Array[Dictionary]，每项 {x: 水平距离m, drop: 下坠量m(正值=低于枪口), time: 秒}
static func simulate(distance_m: float, muzzle_velocity: float,
		drag_decel: float = GameConfig.DEFAULT_DRAG_DECEL,
		drag_duration: float = GameConfig.DEFAULT_DRAG_DURATION,
		gravity: float = GameConfig.GRAVITY_EFFECTIVE) -> Array[Dictionary]:
	var points: Array[Dictionary] = []
	var velocity_x := muzzle_velocity
	var velocity_z := 0.0  # θ=0：无垂直初速
	var x := 0.0
	var z := 0.0
	var t := 0.0
	var next_sample := 1.0
	var dt := GameConfig.BALLISTICS_DT
	var step := 0
	while x < distance_m and step < MAX_STEPS:
		var prev_x := x
		var prev_z := z
		var prev_t := t
		# 半隐式欧拉：先速度后位置
		if t < drag_duration:
			velocity_x = maxf(velocity_x - drag_decel * dt, 0.0)
		velocity_z -= gravity * dt
		x += velocity_x * dt
		z += velocity_z * dt
		t += dt
		# 1m 采样：跨过整数米时线性插值记录
		while x >= next_sample and next_sample <= distance_m:
			var span := x - prev_x
			var ratio := 0.0
			if span > 0.0001:
				ratio = (next_sample - prev_x) / span
			var sample_z := lerpf(prev_z, z, ratio)
			var sample_t := prev_t + (t - prev_t) * ratio
			points.append({"x": next_sample, "drop": -sample_z, "time": sample_t})
			next_sample += 1.0
		if velocity_x <= 0.0:
			break
		step += 1
	if points.is_empty() and x > 0.0:
		points.append({"x": x, "drop": -z, "time": t})
	return points


## 直瞄命中判定（docx 第十八章「直瞄射程口径」确认稿）：
## 直瞄不做弹道高度/重力下坠——俯视 2D 下坠不可见、退化成射程上限。
## 命中 = 枪口沿 direction 的水平射线穿过的第一个敌人圆 + max_range 截断。
## 掩体层（docx 4.7 第③级 / C2 矮掩体）：传入 sight 后子弹会被沙袋截断——
## 站姿眼高 1.6 m 能打过 1.1 m 的沙袋，趴下 0.6 m 就打不过，与通视同一套高度规则。
## 返回 {hit, target, distance, point, ground_hit, cover_hit, cover, structure_damage}
## 【2026-10-03 拍板】加了 structure_damage（对建筑 / 工事的伤害）参数：
##   -1 = 用缺省（0，即「打不动建筑」）——**普通子弹恒为 0**，所以小口径武器拆不了楼；
##   调用方按自己的弹种传（步兵查 weapons_data.txt 的 structure_damage，
##   载具查 vehicles_data.txt 的 gun_structure_damage / atgm_structure_damage）。
## 返回值里带上它，结算方不必再查一次表。
static func resolve_shot(origin: Vector2, direction: Vector2, max_range: float,
		enemies: Array, hit_radius: float = GameConfig.ENEMY_HIT_RADIUS,
		sight: SightSystem = null,
		shooter_eye_height: float = GameConfig.SOLDIER_EYE_HEIGHT,
		structure_damage: float = -1.0) -> Dictionary:
	var dir := direction.normalized()
	var best: Node2D = null
	var best_distance := max_range
	for enemy in enemies:
		var enemy_node := enemy as Node2D
		if enemy_node == null or enemy_node.is_queued_for_deletion():
			continue
		# 大目标自带命中半径（载具 / FOB 都有 hit_radius()）；没有该方法的（步兵）用调用方给的半径
		var radius := hit_radius
		if enemy_node.has_method("hit_radius"):
			radius = float(enemy_node.hit_radius())
		var t := _ray_hit_circle(origin, dir, enemy_node.global_position, radius)
		if t >= 0.0 and t <= best_distance:
			best_distance = t
			best = enemy_node
	# 掩体截断：不传 sight 就退化成原来的纯地形弹道（老调用方不受影响）
	var cover_distance := INF
	var cover_point := Vector2.INF
	var cover_node = null
	if sight != null and sight.grid != null:
		var ray_end := origin + dir * max_range
		var origin_height := sight.grid.sample_bilinear(origin) + shooter_eye_height
		var end_height := sight.grid.sample_bilinear(ray_end) + shooter_eye_height
		if sight.occluder_blocks(origin, origin_height, ray_end, end_height):
			# 交点的视线高度（**相对地面**）—— 开口（窗 / 门洞）判据要用它，与 SightSystem 同一口径；
			# 射手眼高本身就是相对地面的，所以直接传它。
			var cover_info := sight.first_cover(origin, ray_end, shooter_eye_height)
			var hit: Vector2 = cover_info["point"]
			if hit != Vector2.INF:
				cover_distance = origin.distance_to(hit)
				cover_point = hit
				cover_node = cover_info["node"]
	var resolved_structure := maxf(structure_damage, 0.0)
	if cover_distance < best_distance:
		# 把 cover 节点带回去：调用方据此扣掩体耐久（可破坏掩体）
		return {"hit": false, "target": null, "distance": cover_distance,
				"point": cover_point, "ground_hit": false, "cover_hit": true,
				"cover": cover_node, "structure_damage": resolved_structure}
	if best != null:
		return {"hit": true, "target": best, "distance": best_distance,
				"point": origin + dir * best_distance, "ground_hit": false,
				"cover_hit": false, "cover": null, "structure_damage": resolved_structure}
	return {"hit": false, "target": null, "distance": max_range,
			"point": origin + dir * max_range, "ground_hit": false, "cover_hit": false,
			"cover": null, "structure_damage": resolved_structure}


## 7.4 的闭式解（无阻力基准，g = 重力）：
##   A = v0²；B = √(A² − g(gD² + 2HA))；低弹道 T = (A − B)/(gD)；C = g/(2v0²)
##   h(d) = d·T − C(1 + T²)d²
## 返回低弹道仰角（rad）；打不到（判别式 < 0）返回 -1。
## 俯视 2D 里低弹道更符合「直接砸过去」的直觉，高弹道解留给后续深化。
static func solve_elevation(distance: float, muzzle_velocity: float,
		height_diff: float = 0.0,
		gravity: float = GameConfig.GRAVITY_EFFECTIVE) -> float:
	if distance <= 0.001 or muzzle_velocity <= 0.0:
		return -1.0
	var a := muzzle_velocity * muzzle_velocity
	var discriminant := a * a \
			- gravity * (gravity * distance * distance + 2.0 * height_diff * a)
	if discriminant < 0.0:
		return -1.0
	var b := sqrt(discriminant)
	var tan_theta := (a - b) / (gravity * distance)
	return atan(tan_theta)


## ────────────── 离线弹道表（Q2 · 2026-10-06 第七十九版·三）──────────────
## 表由 tools/build_ballistics_table.gd 生成、并**入库**（res://data/config/ballistics_table.json）。
## 只在初速匹配、距离落在表内时使用；其余情况一律退回数值二分 ⇒ 老调用方与单测行为不变。
## 表头写了生成时的"最大落点误差"（线性插值的代价），精度由 test/ballistics_table_test.gd 复核。
const TABLE_PATH := "res://data/config/ballistics_table.json"
static var _table_rows := PackedFloat64Array()
static var _table_v0 := 0.0
static var _table_step := 0.0
static var _table_max := 0.0
static var _table_error := -1.0
static var _table_loaded := false


## 查表（未命中返回 -1 ⇒ 调用方退回二分）
static func _table_elevation(distance: float, muzzle_velocity: float) -> float:
	if not _table_loaded:
		_load_table()
	if _table_step <= 0.0 or _table_rows.is_empty():
		return -1.0
	if absf(muzzle_velocity - _table_v0) > 0.001:
		return -1.0
	if distance < 0.0 or distance > _table_max:
		return -1.0
	var pos := distance / _table_step
	var i0 := int(floor(pos))
	if i0 + 1 >= _table_rows.size():
		return -1.0
	var a := _table_rows[i0]
	var b := _table_rows[i0 + 1]
	if a < 0.0 or b < 0.0:
		return -1.0     # 该格在 45° 射程之外（生成器写 -1）
	return lerpf(a, b, pos - float(i0))


static func _load_table() -> void:
	_table_loaded = true        # 失败也只试一次（没有表的包 ⇒ 永久退回现算）
	var file := FileAccess.open(TABLE_PATH, FileAccess.READ)
	if file == null:
		return
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		push_warning("[弹道表] %s 解析失败，退回数值二分" % TABLE_PATH)
		return
	var d: Dictionary = parsed
	_table_v0 = float(d.get("v0", 0.0))
	_table_step = float(d.get("step_m", 0.0))
	_table_max = float(d.get("max_m", 0.0))
	_table_error = float(d.get("measured_max_error_m", -1.0))
	_table_rows = PackedFloat64Array()
	for v in d.get("rows", []):
		_table_rows.append(float(v))


## 自检 / 测试用：表的元信息（没装载时 loaded=false）
static func table_info() -> Dictionary:
	if not _table_loaded:
		_load_table()
	return {
		"loaded": not _table_rows.is_empty(),
		"v0": _table_v0,
		"step_m": _table_step,
		"max_m": _table_max,
		"rows": _table_rows.size(),
		"measured_max_error_m": _table_error,
	}


## 飞行时间：t = D / (v0·cosθ)
static func solve_flight_time(distance: float, muzzle_velocity: float,
		elevation: float) -> float:
	var horizontal_speed := muzzle_velocity * cos(elevation)
	if horizontal_speed <= 0.001:
		return GameConfig.INDIRECT_FLIGHT_MAX
	return clampf(distance / horizontal_speed, 0.05, GameConfig.INDIRECT_FLIGHT_MAX)


## 弹道高度采样（h(d) 公式）——间瞄弧线与落点预警的可视化数据
static func solve_arc(distance: float, muzzle_velocity: float, elevation: float,
		samples: int = 24, gravity: float = GameConfig.GRAVITY_EFFECTIVE) -> Array:
	var c := gravity / (2.0 * muzzle_velocity * muzzle_velocity)
	var t := tan(elevation)
	var points: Array = []
	for i in samples + 1:
		var d := distance * float(i) / float(samples)
		points.append({"x": d, "height": d * t - c * (1.0 + t * t) * d * d})
	return points


## 间瞄弹道积分（docx 7.4.2 定标）：常数减速度阻力 −30 m/s² 持续 2 s + g_eff 9.81×2.8
## 与 simulate() 的区别：simulate 是 θ=0 的平射下坠（旧口径），这里是任意仰角、积到落地为止。
## 阻力沿速度反方向作用（比旧口径只减水平分量更物理）；2 s 后阻力消失、余速继续飞。
## 返回 Array[Dictionary]：{x 水平距离, height 相对枪口高度, time}
static func trajectory(muzzle_velocity: float, elevation: float,
		max_distance: float = 600.0,
		drag_decel: float = GameConfig.DEFAULT_DRAG_DECEL,
		drag_duration: float = GameConfig.DEFAULT_DRAG_DURATION,
		gravity: float = GameConfig.GRAVITY_EFFECTIVE) -> Array[Dictionary]:
	var points: Array[Dictionary] = [{"x": 0.0, "height": 0.0, "time": 0.0}]
	_integrate(muzzle_velocity, elevation, max_distance, drag_decel, drag_duration, gravity, points)
	return points


## 积分内核（2026-10-06 第七十九版）：trajectory() 与 trajectory_range() 共用同一段积分，
## 免得"两份实现慢慢漂移"。collect 传数组就逐点收集，传 null 就只算落点。
##
## 为什么要单独给"只算落点"留一条：solve_elevation_dragged() 一次发射要跑 13 次弹道
## （1 次 45° 射程预判 + 12 次二分），每次 200~500 步、每步一个 Dictionary +
## Array[Dictionary] 追加 —— 旧实现实测每次发射要造 ~3000~6500 个 Dictionary。
## 不收集时一步都不分配，数值与收集版**逐位相同**（同一段代码、同一顺序）。
static func _integrate(muzzle_velocity: float, elevation: float, max_distance: float,
		drag_decel: float, drag_duration: float, gravity: float,
		collect) -> float:
	var velocity_x := muzzle_velocity * cos(elevation)
	var velocity_z := muzzle_velocity * sin(elevation)
	var x := 0.0
	var z := 0.0
	var t := 0.0
	var dt := GameConfig.BALLISTICS_DT
	var step := 0
	while z >= 0.0 and x <= max_distance and step < MAX_STEPS:
		if t < drag_duration:
			var speed := sqrt(velocity_x * velocity_x + velocity_z * velocity_z)
			if speed > 0.0001:
				velocity_x = maxf(velocity_x - drag_decel * dt * (velocity_x / speed), 0.0)
				velocity_z -= drag_decel * dt * (velocity_z / speed)
		velocity_z -= gravity * dt
		x += velocity_x * dt
		z += velocity_z * dt
		t += dt
		if collect != null:
			collect.append({"x": x, "height": z, "time": t})
		step += 1
	return x


## 某仰角下的落点水平距离（打不到就很小）
## 【2026-10-06 第七十九版】不再建 points 数组：直接走 _integrate 的"只算落点"路径。
## 与旧实现（trajectory() 取最后一个点）数值逐位相同，等价性由 test/indirect_test.gd 钉住。
static func trajectory_range(muzzle_velocity: float, elevation: float,
		max_distance: float = 600.0) -> float:
	return _integrate(muzzle_velocity, elevation, max_distance,
			GameConfig.DEFAULT_DRAG_DECEL, GameConfig.DEFAULT_DRAG_DURATION,
			GameConfig.GRAVITY_EFFECTIVE, null)


## 带阻力反解仰角：0~45° 内二分（低伸解，射程在 45° 以下随仰角单调增）。
## 正式做法是 7.4.1 的离线弹道表，第一版先用数值迭代——发射时才跑一次，代价可忽略。
## 对外入口（Q2 · 2026-10-06 第七十九版·三）：**先查离线弹道表**（设计 7.4.1），
## 表里没有这个初速 / 超出表的距离范围 ⇒ 退回下面的数值二分（行为与改前完全一致）。
## 表由 tools/build_ballistics_table.gd 并行生成（res://data/config/ballistics_table.json），
## 精度由 test/ballistics_table_test.gd 钉住。
static func solve_elevation_dragged(distance: float, muzzle_velocity: float,
		iterations: int = 12) -> float:
	var from_table := _table_elevation(distance, muzzle_velocity)
	if from_table >= 0.0:
		return from_table
	return solve_elevation_bisection(distance, muzzle_velocity, iterations)


## 数值二分反解（改前的实现原样保留）：0~45° 内二分，低伸解。
## 离线表的每一格都是用它算出来的 —— 所以"表"与"现算"同源，只是精度按表步长插值。
static func solve_elevation_bisection(distance: float, muzzle_velocity: float,
		iterations: int = 12) -> float:
	if distance <= 0.001 or muzzle_velocity <= 0.0:
		return -1.0
	if trajectory_range(muzzle_velocity, deg_to_rad(45.0)) < distance:
		return -1.0  # 45° 都够不到 ⇒ 超出射程
	var low := 0.0
	var high := deg_to_rad(45.0)
	for i in iterations:
		var mid := (low + high) * 0.5
		if trajectory_range(muzzle_velocity, mid) < distance:
			low = mid
		else:
			high = mid
	return high


## 射线与圆的最近交点距离（direction 须为单位向量）；无交点返回 -1。
static func _ray_hit_circle(origin: Vector2, direction: Vector2, center: Vector2,
		radius: float) -> float:
	var to_center := center - origin
	var proj := to_center.dot(direction)
	var dist_sq := to_center.length_squared() - proj * proj
	var r2 := radius * radius
	if dist_sq > r2:
		return -1.0
	var half_chord := sqrt(r2 - dist_sq)
	var enter := proj - half_chord
	if enter < 0.0:
		# 起点在圆内：取出口（避免把「自己就在圆里」当命中）。
		enter = proj + half_chord
		if enter < 0.0:
			return -1.0
	return enter
