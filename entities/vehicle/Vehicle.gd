extends CharacterBody2D

## 载具（docx 第八章 / 8.1 舱室与座位 / 8.2 武器与装甲）
## 第一版只做验收要求的三件事：**能上车、能开炮、装甲能挡弹**。
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

signal wrecked(vehicle: Node2D)
signal weapon_fired(origin: Vector2, direction: Vector2, distance: float)

const VehicleTable := preload("res://systems/vehicles/VehicleTable.gd")

var data: Dictionary = {}
var driver = null                    # 驾驶位占用的玩家单位（PlayerUnit）
var operator = null                  # 武器位占用的玩家单位（8.1：第一版两个座位）
var hull_facing := Vector2.RIGHT     # 车体朝向
var turret_facing := Vector2.RIGHT   # 炮塔朝向（8.2.6：与车体分离，可独立转向与回正）
var ai_enabled := false              # 敌方载具由 AI 驾驶（第一版）
var friendly := true                 # 阵营：只影响自绘颜色（我方蓝绿 / 敌方暗红）
var hp := 0.0
var max_hp := 0.0                    # 初始结构值（HUD 显示用）
var destroyed := false

var _fire_cooldown := 0.0
var _ammo := 0
var _sight: SightSystem = null
var _player_ref = null               # AI 的目标
var _turret_recoil := 0.0            # 0..1，开火时的后坐视觉量


func setup(vehicle_id: String, sight: SightSystem) -> void:
	data = VehicleTable.get_vehicle(vehicle_id)
	if data.is_empty():
		push_error("[载具] 表里没有 %s" % vehicle_id)
		return
	hp = VehicleTable.number(data, "hp", 800.0)
	max_hp = hp
	_ammo = int(VehicleTable.number(data, "ammo", 0.0))
	_sight = sight
	add_to_group("vehicle")
	queue_redraw()


func vehicle_name() -> String:
	return String(data.get("name", "载具"))


func max_speed() -> float:
	return VehicleTable.number(data, "speed_kmh", 0.0) / 3.6  # km/h → m/s


## 命中判定半径（m）：按车长折算——载具是大目标，别套用步兵的 0.25 m
func hit_radius() -> float:
	return VehicleTable.number(data, "length_m", 4.0) * GameConfig.VEHICLE_HIT_RADIUS_SCALE


func is_occupied() -> bool:
	return driver != null or operator != null


## 乘客坐的是哪个座位（8.1 舱室与座位）——不同座位的战斗 UI 不同（8.2 载具 UI 三原则）
func seat_of(player) -> String:
	if player == null:
		return ""
	if player == driver:
		return "driver"
	if player == operator:
		return "gunner"
	return ""


## 上车：先坐驾驶位，驾驶位有人就坐武器位，都满了拒绝
func enter(player) -> void:
	if player == null:
		return
	if driver == null:
		driver = player
	elif operator == null:
		operator = player
	else:
		return
	player.visible = false
	player.input_locked = true
	queue_redraw()


## 换座位（驾驶位 ⇄ 武器位）；没有空位可换时返回原座位
func switch_seat(player) -> String:
	if player == driver and operator == null:
		driver = null
		operator = player
	elif player == operator and driver == null:
		operator = null
		driver = player
	queue_redraw()
	return seat_of(player)


## 下车：两个座位的人一起下来（第一版不做逐人下车）
func exit_vehicle() -> void:
	for occupant in [driver, operator]:
		if occupant != null:
			occupant.visible = true
			occupant.input_locked = false
			occupant.global_position = global_position + hull_facing.rotated(PI * 0.5) * 5.0
	driver = null
	operator = null
	velocity = Vector2.ZERO
	queue_redraw()


## 炮塔瞄准（武器位用）：朝目标点转向，但受 TURRET_ROTATE_SPEED 限制（8.2.6：转不快）
func aim_at(target_point: Vector2, delta: float) -> void:
	var desired := target_point - global_position
	if desired.length() < 0.001:
		return
	turret_facing = _rotate_towards(turret_facing, desired.normalized(),
			GameConfig.TURRET_ROTATE_SPEED, delta)


## 炮塔回正（8.2.6 弹簧模型）：没人操炮时缓慢回到车体朝向，越接近末速越慢
func recenter_turret(delta: float) -> void:
	if operator != null or destroyed:
		return
	var stiffness := GameConfig.TURRET_RECENTER_STIFFNESS
	var damping := clampf(GameConfig.TURRET_RECENTER_DAMPING * 0.1, 0.0, 0.5)
	turret_facing = _rotate_towards(turret_facing, hull_facing,
			GameConfig.TURRET_ROTATE_SPEED * stiffness, delta * (1.0 - damping))


## 炮口世界坐标（开火射线起点）
func muzzle_position() -> Vector2:
	var reach := VehicleTable.number(data, "length_m", 6.0) * 0.5 + 2.0
	return global_position + turret_facing * reach


## 把方向按最大角速度向目标方向转一步（返回新方向）
static func _rotate_towards(from: Vector2, to: Vector2, speed_deg: float,
		delta: float) -> Vector2:
	var max_step := deg_to_rad(speed_deg) * maxf(delta, 0.0)
	var diff := wrapf(to.angle() - from.angle(), -PI, PI)
	return from.rotated(clampf(diff, -max_step, max_step))


## 敌方载具 AI 的目标
func set_target(player) -> void:
	_player_ref = player


## 驾驶：加速 / 减速 / 缓慢转向（第一版不做档位与惯性细节）
func drive(input_vector: Vector2, delta: float) -> void:
	if destroyed:
		return
	if input_vector.length() > 0.05:
		var target := input_vector.normalized() * max_speed()
		velocity = velocity.lerp(target, clampf(3.0 * delta, 0.0, 1.0))
		hull_facing = hull_facing.lerp(input_vector.normalized(),
				clampf(2.5 * delta, 0.0, 1.0)).normalized()
	else:
		velocity = velocity.lerp(Vector2.ZERO, clampf(2.0 * delta, 0.0, 1.0))
	rotation = hull_facing.angle()
	move_and_slide()
	queue_redraw()


## 挨打：命中面 → 有效厚度 → 击穿判定 → 伤害（未击穿只吃零头，这就是「装甲挡弹」）
## 第一版不算法线偏角，只用该面的基础倾角（首上 30° 这类）
func take_hit(raw_damage: float, penetration_mm: float,
		hit_direction: Vector2) -> Dictionary:
	if destroyed:
		return {"penetrated": false, "damage": 0.0, "side": "side",
				"armor_mm": 0.0, "penetration_mm": penetration_mm, "destroyed": true}
	var side := VehicleTable.hit_side(hull_facing, hit_direction)
	# 把该面等效厚度也带出去：HUD 才能说清「为什么没穿」，而不是只丢一句「未击穿」
	var armor_mm := VehicleTable.effective_armor_mm(data, side, 0.0)
	var penetrated := VehicleTable.is_penetrated(data, side, 0.0, penetration_mm)
	var damage := raw_damage
	if not penetrated:
		damage *= GameConfig.VEHICLE_NON_PEN_DAMAGE_SCALE
	hp = maxf(hp - damage, 0.0)
	var wrecked_now := hp <= 0.0
	if wrecked_now:
		destroyed = true
		exit_vehicle()
		wrecked.emit(self)
	queue_redraw()
	return {"penetrated": penetrated, "damage": damage, "side": side,
			"armor_mm": armor_mm, "penetration_mm": penetration_mm, "destroyed": wrecked_now}


## 能开炮的前提：有人操炮（武器位）或这辆是 AI 车——驾驶位不能开炮（8.1 座位分工）
func can_fire() -> bool:
	if destroyed or _fire_cooldown > 0.0 or _ammo <= 0:
		return false
	return operator != null or ai_enabled


func ammo() -> int:
	return _ammo


func armor_summary(side: String) -> float:
	return VehicleTable.effective_armor_mm(data, side, 0.0)


## 车载武器开火（命中判定复用 BallisticsSystem；目标数组由调用方给）
func fire(targets: Array) -> Dictionary:
	if not can_fire():
		return {"fired": false, "hit": false, "distance": 0.0, "target": null}
	_fire_cooldown = VehicleTable.number(data, "gun_interval", 1.0)
	_ammo -= 1
	_turret_recoil = 1.0
	var range_m := VehicleTable.number(data, "main_range", 800.0)
	# 从炮口沿「炮塔朝向」打——炮塔与车体分离后，射击方向不再等于车体朝向（8.2.6）
	var result := BallisticsSystem.resolve_shot(muzzle_position(), turret_facing, range_m,
			targets, GameConfig.ENEMY_HIT_RADIUS, _sight, GameConfig.SOLDIER_EYE_HEIGHT)
	result["fired"] = true
	result["damage"] = VehicleTable.number(data, "gun_damage", 30.0)
	result["penetration_mm"] = VehicleTable.number(data, "gun_penetration_mm", 20.0)
	weapon_fired.emit(muzzle_position(), turret_facing, float(result["distance"]))
	return result


## 敌方载具 AI（第一版）：发现玩家 → 车体慢慢转向、炮塔瞄准 → 对准后按更慢的节奏开火
func _ai_update(delta: float) -> void:
	if _player_ref == null:
		return
	var target_position: Vector2 = _player_ref.global_position
	var to_player := target_position - global_position
	var distance := to_player.length()
	if distance > GameConfig.VEHICLE_AI_RANGE or distance < 1.0:
		return
	if not _has_sight_to_player():
		return
	aim_at(_player_ref.global_position, delta)
	hull_facing = _rotate_towards(hull_facing, to_player.normalized(),
			GameConfig.TURRET_ROTATE_SPEED * 0.4, delta)
	velocity = velocity.lerp(to_player.normalized() * max_speed() * 0.5,
			clampf(1.0 * delta, 0.0, 1.0))
	rotation = hull_facing.angle()
	move_and_slide()
	if _fire_cooldown <= 0.0 and _ammo > 0:
		var aim_error := absf(wrapf(to_player.angle() - turret_facing.angle(), -PI, PI))
		if aim_error <= deg_to_rad(GameConfig.VEHICLE_AI_AIM_TOLERANCE_DEG):
			_fire_cooldown = VehicleTable.number(data, "gun_interval", 1.0) \
					* GameConfig.VEHICLE_AI_INTERVAL_SCALE
			_fire_ai()


func _has_sight_to_player() -> bool:
	if _sight == null or _sight.grid == null or _player_ref == null:
		return true   # 没有通视系统时不拦（测试环境）
	var origin_height := _sight.grid.sample_bilinear(global_position) \
			+ GameConfig.SOLDIER_EYE_HEIGHT
	var target_height := _sight.eye_height_at(_player_ref.global_position)
	return _sight.has_sight(global_position, origin_height,
			_player_ref.global_position, target_height)


## AI 开火：从炮口沿炮塔朝向打一轮
func _fire_ai() -> void:
	if _player_ref == null:
		return
	_ammo -= 1
	_turret_recoil = 1.0
	var result := BallisticsSystem.resolve_shot(muzzle_position(), turret_facing,
			VehicleTable.number(data, "main_range", 800.0), [_player_ref],
			GameConfig.ENEMY_HIT_RADIUS, _sight, GameConfig.SOLDIER_EYE_HEIGHT)
	weapon_fired.emit(muzzle_position(), turret_facing, float(result["distance"]))
	if result["hit"]:
		var target = result["target"]
		if target != null and target.has_method("take_damage"):
			target.take_damage(VehicleTable.number(data, "gun_damage", 30.0)
					* GameConfig.ENEMY_DAMAGE_SCALE)


## 每帧：冷却、后坐衰减、炮塔回正、AI
func _process(delta: float) -> void:
	if _fire_cooldown > 0.0:
		_fire_cooldown = maxf(_fire_cooldown - delta, 0.0)
	_turret_recoil = maxf(_turret_recoil - GameConfig.TURRET_RECOIL_DECAY * delta, 0.0)
	recenter_turret(delta)
	if ai_enabled and not destroyed:
		_ai_update(delta)
	queue_redraw()


func _draw() -> void:
	var length := VehicleTable.number(data, "length_m", 6.0)
	var width := VehicleTable.number(data, "width_m", 3.0)
	var body := Color(0.34, 0.39, 0.30, 0.95)
	if not friendly:
		body = Color(0.42, 0.28, 0.26, 0.95)
	if destroyed:
		body = Color(0.20, 0.17, 0.15, 0.85)
	var rect := Rect2(-length * 0.5, -width * 0.5, length, width)
	draw_rect(rect, body)
	draw_rect(rect, Color(0.78, 0.80, 0.72, 0.9), false, 1.5)
	# 炮塔与炮管：与车体分离（按相对角画），开火瞬间向后座——8.2.6 后坐力的视觉载体
	var turret_local := wrapf(turret_facing.angle() - hull_facing.angle(), -PI, PI)
	var recoil := _turret_recoil * GameConfig.TURRET_RECOIL_OFFSET
	# 后坐必须沿「炮管轴线」后退：本地 -X 是车体后方，炮塔转过角度后沿它退会变成横着滑
	# （表现就是炮管斜着后进——炮管转到侧面时甚至像是向左平移）
	var axis := Vector2.RIGHT.rotated(turret_local)
	var turret_origin := axis * -recoil
	var barrel_end := turret_origin + axis * (length * 0.5 + 2.0)
	draw_circle(turret_origin, width * 0.26, Color(0.42, 0.45, 0.36, 0.95))
	draw_line(turret_origin, barrel_end, Color(0.85, 0.85, 0.80, 0.95), 2.5)
	if is_occupied():
		draw_circle(Vector2.ZERO, 1.5, Color(1.0, 0.9, 0.35, 0.95))
