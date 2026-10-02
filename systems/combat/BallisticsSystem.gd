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
## 返回 {hit, target, distance, point, ground_hit, cover_hit}
static func resolve_shot(origin: Vector2, direction: Vector2, max_range: float,
		enemies: Array, hit_radius: float = GameConfig.ENEMY_HIT_RADIUS,
		sight: SightSystem = null,
		shooter_eye_height: float = GameConfig.SOLDIER_EYE_HEIGHT) -> Dictionary:
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
			var cover_info := sight.first_cover(origin, ray_end)
			var hit: Vector2 = cover_info["point"]
			if hit != Vector2.INF:
				cover_distance = origin.distance_to(hit)
				cover_point = hit
				cover_node = cover_info["node"]
	if cover_distance < best_distance:
		# 把 cover 节点带回去：调用方据此扣掩体耐久（可破坏掩体）
		return {"hit": false, "target": null, "distance": cover_distance,
				"point": cover_point, "ground_hit": false, "cover_hit": true,
				"cover": cover_node}
	if best != null:
		return {"hit": true, "target": best, "distance": best_distance,
				"point": origin + dir * best_distance, "ground_hit": false,
				"cover_hit": false, "cover": null}
	return {"hit": false, "target": null, "distance": max_range,
			"point": origin + dir * max_range, "ground_hit": false, "cover_hit": false,
			"cover": null}


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
		points.append({"x": x, "height": z, "time": t})
		step += 1
	return points


## 某仰角下的落点水平距离（打不到就很小）
static func trajectory_range(muzzle_velocity: float, elevation: float,
		max_distance: float = 600.0) -> float:
	var points := trajectory(muzzle_velocity, elevation, max_distance)
	if points.size() <= 1:
		return 0.0
	var last: Dictionary = points[points.size() - 1]
	return float(last["x"])


## 带阻力反解仰角：0~45° 内二分（低伸解，射程在 45° 以下随仰角单调增）。
## 正式做法是 7.4.1 的离线弹道表，第一版先用数值迭代——发射时才跑一次，代价可忽略。
static func solve_elevation_dragged(distance: float, muzzle_velocity: float,
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
