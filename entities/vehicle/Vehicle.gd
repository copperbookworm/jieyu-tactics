extends CharacterBody2D

## 载具（docx 第八章 / 8.1 舱室与座位 / 8.2 武器与装甲）
## 第一版只做验收要求的三件事：**能上车、能开炮、装甲能挡弹**。
## 刻意不写 class_name：引用方用 preload（见 Cover.gd 头部说明）

signal wrecked(vehicle: Node2D)
signal weapon_fired(origin: Vector2, direction: Vector2, distance: float)

const VehicleTable := preload("res://systems/vehicles/VehicleTable.gd")
## 表现层（候选 M：12.7.2 履带 / 残骸冒烟）
const EffectSpawner := preload("res://systems/effects/EffectSpawner.gd")
## 部件系统（docx 8.4 · 2026-10-05）：部件状态 / 瞄高档位 / 部位结算
const VehiclePartsScript := preload("res://systems/vehicles/VehicleParts.gd")

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

# —— 部件系统（docx 8.4 · 2026-10-05）——
## parts：部件 id → {hp, max_hp, state}；整车结构值 hp 同时就是「车体」这个部件的血量（8.4.3）
var parts: Dictionary = {}
## 武器位瞄高档位（8.4.2 四档：炮塔 / 车体 / 弹药架 / 机动件）
var aim_gear: int = VehiclePartsScript.Gear.HULL

# —— 敌方坦克乘员（候选 Q · 使用者 2026-10-02：坦克要有敌人士兵操控，快损坏时下车逃生）——
## 乘员是 Enemy（不是 PlayerUnit）：在车里时藏起来、脱离 enemy 组（不作为独立目标）、关掉自身 AI
var crew: Array = []
var _bailed := false

# —— 弹种（武器位一键切弹种：主炮 / 反坦克导弹）——
## 玩家步战车装 ATGM 的理由（使用者 2026-10-01 拍板）：IFV 的 30mm 机炮穿深 60 mm，
## 对敌方主战坦克（正面等效 700 ÷ cos30° ≈ 808 mm）任何一面都打不穿，会变成「只有未击穿效果」，
## 真机上手还没测完就被坦克两发打爆。所以给 IFV 加一个炮射反坦克导弹发射器。
enum AmmoType { GUN, ATGM }
var _ammo_type: int = AmmoType.GUN
var _atgm_ammo := 0

# —— 12.7.2 载具动画（候选 M · 第四轮）——
## 分图层：Hull / Turret / Track（第一版没有 Superstructure / FixedWeapon 的数据，所以只建三层）。
## 绘制仍集中在 _draw 里，但 rotation 挂在图层节点上（编辑器 / MCP 查得到）。
var hull_layer: Node2D = null
var turret_layer: Node2D = null
var track_layer: Node2D = null
## 履带滚动相位 ＝ 已经跑过的距离（m）：停车即冻结，报废后冻结并变黑（M-kill 的等效表现）
var track_phase := 0.0


func setup(vehicle_id: String, sight: SightSystem) -> void:
	data = VehicleTable.get_vehicle(vehicle_id)
	if data.is_empty():
		push_error("[载具] 表里没有 %s" % vehicle_id)
		return
	hp = VehicleTable.number(data, "hp", 800.0)
	max_hp = hp
	_ammo = int(VehicleTable.number(data, "ammo", 0.0))
	_atgm_ammo = int(VehicleTable.number(data, "atgm_ammo", 0.0))   # 没有这一列的载具就是 0（＝没装导弹）
	_sight = sight
	parts = VehiclePartsScript.init_parts(vehicle_id)
	add_to_group("vehicle")
	_build_layers()
	queue_redraw()


func vehicle_name() -> String:
	return String(data.get("name", "载具"))


func max_speed() -> float:
	# 部件效果（8.4.1）：发动机受损 / 断带 / 轮胎损坏都会压低速度上限
	return VehicleTable.number(data, "speed_kmh", 0.0) / 3.6 * speed_scale()


## 命中判定半径（m）：按车长折算——载具是大目标，别套用步兵的 0.25 m
func hit_radius() -> float:
	return VehicleTable.number(data, "length_m", 4.0) * GameConfig.VEHICLE_HIT_RADIUS_SCALE


## 数据表 id（部件表 / 装甲查询用）
func vehicle_id() -> String:
	return String(data.get("id", ""))


## 机动型式（tracked / wheeled / rotary）
func mobility() -> String:
	return VehiclePartsScript.mobility_of(vehicle_id())


# —— 部件效果（8.4.1，全部走 VehicleParts 的纯函数）——

func speed_scale() -> float:
	return VehiclePartsScript.speed_scale(parts, mobility())


func turn_scale() -> float:
	return VehiclePartsScript.turn_scale(parts, mobility())


func turret_rotate_scale() -> float:
	return VehiclePartsScript.turret_rotate_scale(parts)


func main_gun_blocked() -> bool:
	return VehiclePartsScript.main_gun_blocked(parts)


## 一发炮弹该落到哪个部位（8.4.2 / 8.4.6）：gear 由武器位给（玩家瞄高），
## roll 由调用方给（生产传 randf()、测试传定值 ⇒ 可复现）。
func resolve_hit_part(side: String, gear: int, roll: float) -> String:
	return VehiclePartsScript.roll_part(vehicle_id(), side, gear, roll)


## 整车结构值挨打（打中车体 / 未击穿的零头 / 起火持续掉血都走这条）
func _hull_damage(amount: float) -> bool:
	hp = maxf(hp - maxf(amount, 0.0), 0.0)
	_maybe_bail_out()
	var wrecked_now := hp <= 0.0
	if wrecked_now and not destroyed:
		_wreck()
	return wrecked_now


## 报废（K-kill 的统一出口：结构值归零与弹药架殉爆都走这里）
func _wreck() -> void:
	destroyed = true
	exit_vehicle()
	wrecked.emit(self)
	EffectSpawner.wreck_smoke_on(self)   # 12.7.2：残骸持续冒烟（K-kill 的等效表现）
	queue_redraw()


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
## 报废车不许上：否则玩家会坐上「永远开不了炮、也没有任何提示」的座位（2026-10-01 修，见 fire_block_reason）
func enter(player) -> void:
	if player == null or destroyed:
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


## 乘员跟着车走（2026-10-02 真机修）。原来 enter() 只把人藏起来、坐标留在上车点 ⇒
## 相机（跟玩家）、开发用黄箭头、载具发烟器读到的全是**过期坐标**，真机表现就是：
## 黄箭头停在上车点且指向不变 / 镜头不跟车 / 烟放在原地 / 准心被自己的烟钳死在原地。
## 物理上乘员就坐在车里，坐标必须跟车。（Vehicle 没有碰撞体，不用担心和乘员互相卡住。）
## 乘员登车（候选 Q）：藏起来 + 脱离 enemy 组（在车里不该被当成独立目标打）+ 关掉自身 AI
func add_crew(unit) -> void:
	if unit == null:
		return
	crew.append(unit)
	unit.visible = false
	if unit.has_method("set_ai_enabled"):
		unit.set_ai_enabled(false)
	if unit.has_method("remove_from_group"):
		unit.remove_from_group("enemy")


## 弃车逃生（结构值跌破 GameConfig.VEHICLE_CREW_BAILOUT_FRACTION 时由 _maybe_bail_out 调用）：
## 乘员落到车旁、重新可见可打（回到 enemy 组）、AI 打开；车没人操炮 ⇒ 停火。
func _bail_out() -> void:
	_bailed = true
	ai_enabled = false
	for unit in crew:
		if unit == null or not is_instance_valid(unit):
			continue
		unit.global_position = global_position + hull_facing.rotated(PI * 0.5) * 6.0
		unit.visible = true
		if unit.has_method("add_to_group"):
			unit.add_to_group("enemy")
		if unit.has_method("set_ai_enabled"):
			unit.set_ai_enabled(true)
	crew.clear()


func _maybe_bail_out() -> void:
	if _bailed or crew.is_empty() or max_hp <= 0.0:
		return
	if hp / max_hp <= GameConfig.VEHICLE_CREW_BAILOUT_FRACTION:
		_bail_out()


func _carry_crew() -> void:
	for unit in crew:
		if unit != null and is_instance_valid(unit):
			unit.global_position = global_position


func _carry_occupants() -> void:
	for occupant in [driver, operator]:
		if occupant != null and is_instance_valid(occupant):
			occupant.global_position = global_position


## 切弹种的权限（2026-10-02 真机修）：原来只要 vehicle 非空就能切，于是**没上车也能切车上弹种**。
## 弹种是武器位的操作，与开炮同一条权限。player 传 null 表示不做座位校验（内部 / 测试用）。
func can_switch_ammo(player) -> bool:
	return has_atgm() and (player == null or seat_of(player) == "gunner")


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
			GameConfig.TURRET_ROTATE_SPEED * turret_rotate_scale(), delta)


## 炮塔回正（8.2.6 弹簧模型）：没人操炮时缓慢回到车体朝向，越接近末速越慢
func recenter_turret(delta: float) -> void:
	if operator != null or destroyed:
		return
	var stiffness := GameConfig.TURRET_RECENTER_STIFFNESS
	var damping := clampf(GameConfig.TURRET_RECENTER_DAMPING * 0.1, 0.0, 0.5)
	turret_facing = _rotate_towards(turret_facing, hull_facing,
			GameConfig.TURRET_ROTATE_SPEED * stiffness * turret_rotate_scale(),
			delta * (1.0 - damping))


## 12.7.2：建图层节点（Hull / Turret / Track）。绘制仍集中在 _draw，节点只承载 rotation 与相位。
func _build_layers() -> void:
	if hull_layer != null:
		return
	hull_layer = Node2D.new()
	hull_layer.name = "Hull"
	add_child(hull_layer)
	turret_layer = Node2D.new()
	turret_layer.name = "Turret"
	add_child(turret_layer)
	track_layer = Node2D.new()
	track_layer.name = "Track"
	add_child(track_layer)


## 12.7.2：把图层节点的变换同步到当前车体 / 炮塔朝向
func _sync_layers() -> void:
	if hull_layer != null:
		hull_layer.rotation = 0.0   # 根节点自己已经按 hull_facing 转了
	if turret_layer != null:
		turret_layer.rotation = wrapf(turret_facing.angle() - hull_facing.angle(), -PI, PI)
	if track_layer != null:
		track_layer.rotation = 0.0


## 12.7.2 履带滚动：相位按**实际位移**推进（速度 × 时间，单位是米）。
## 停车（速度低于阈值）不推进；报废后也冻结 —— 这就是 M-kill「履带停转」的等效表现。
static func track_phase_advance(phase: float, speed_mps: float, delta: float) -> float:
	if speed_mps <= GameConfig.MOVE_SPEED_EPSILON:
		return phase
	return phase + speed_mps * delta


## 履带齿在车体局部的 x 位置：等间距平铺，整体按 phase 反向滚动（滚过的距离＝相位）
static func tread_positions(phase: float, count: int, spacing: float) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	if count <= 0 or spacing <= 0.0:
		return out
	var span := float(count) * spacing
	for i in count:
		out.append(fposmod(float(i) * spacing - phase, span) - span * 0.5)
	return out


func _update_track(delta: float) -> void:
	if destroyed:
		return
	track_phase = track_phase_advance(track_phase, velocity.length(), delta)


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
				clampf(2.5 * turn_scale() * delta, 0.0, 1.0)).normalized()
	else:
		velocity = velocity.lerp(Vector2.ZERO, clampf(2.0 * delta, 0.0, 1.0))
	rotation = hull_facing.angle()
	move_and_slide()
	queue_redraw()


## 挨打：命中面 → 定部位 → 部位/车体装甲 → 击穿判定 → 按部位结算（docx 8.4.3）
## part 缺省 "hull" = 老口径（只打整车结构值），既有调用方与测试不受影响；
## 武器位 / AI / 间爆各自把部位算好再传进来（Vehicle.resolve_hit_part）。
func take_hit(raw_damage: float, penetration_mm: float,
		hit_direction: Vector2, part: String = "hull") -> Dictionary:
	if destroyed:
		return {"penetrated": false, "damage": 0.0, "side": "side",
				"armor_mm": 0.0, "penetration_mm": penetration_mm, "destroyed": true,
				"part": part, "part_state": VehiclePartsScript.STATE_OK,
				"part_destroyed": false}
	var side := VehicleTable.hit_side(hull_facing, hit_direction)
	# 炮塔环走炮塔装甲面（8.4.3）；其余部位仍套车体同一面
	var armor_mm := (VehiclePartsScript.effective_turret_armor_mm(vehicle_id(), side)
			if part == VehiclePartsScript.PART_TURRET_RING
			else VehicleTable.effective_armor_mm(data, side, 0.0))
	var penetrated := penetration_mm >= armor_mm
	var damage := raw_damage
	var part_state := VehiclePartsScript.state_of(parts, part)
	var part_destroyed := false
	if penetrated:
		if part == VehiclePartsScript.PART_HULL or part.is_empty():
			_hull_damage(damage)
		else:
			var outcome: Dictionary = VehiclePartsScript.damage_part(parts, part, damage)
			part_state = int(outcome["state"])
			part_destroyed = bool(outcome["destroyed"])
			# 弹药架被击穿 = 殉爆（K-kill，确定触发、不做概率，8.4.1）
			if part == VehiclePartsScript.PART_AMMO_RACK:
				_hull_damage(hp)
	else:
		# 未击穿只吃 5% 零头，且不伤部件（8.4.3）
		damage *= GameConfig.VEHICLE_NON_PEN_DAMAGE_SCALE
		_hull_damage(damage)
	queue_redraw()
	return {"penetrated": penetrated, "damage": damage, "side": side,
			"armor_mm": armor_mm, "penetration_mm": penetration_mm,
			"destroyed": destroyed, "part": part, "part_state": part_state,
			"part_destroyed": part_destroyed}


## 能开炮的前提：有人操炮（武器位）或这辆是 AI 车——驾驶位不能开炮（8.1 座位分工）
func can_fire() -> bool:
	if destroyed or _fire_cooldown > 0.0:
		return false
	if main_gun_blocked():
		return false          # F-kill（8.4.1：炮塔环损坏 ⇒ 主炮不能开）
	if operator == null and not ai_enabled:
		return false
	return selected_ammo() > 0


## 开不了炮的原因（能开返回空串）。
## 为什么要有它（2026-10-01）：原来 can_fire() 为假时 VehicleController.fire() 直接静默 return——
## 玩家坐在报废车的武器位上按开火键，炮弹数不变、没有曳光、一句提示都没有，看起来就是「开火键坏了」。
## 现在把原因交出来，让控制器能照实回话。冷却中算正常节奏，调用方可以不提示。
func fire_block_reason() -> String:
	if destroyed:
		return "载具已报废"
	if main_gun_blocked():
		return "火炮已损毁"
	if selected_ammo() <= 0:
		return "反坦克导弹打光" if _ammo_type == AmmoType.ATGM else "车载弹药耗尽"
	if _fire_cooldown > 0.0:
		return "装填中"
	if operator == null and not ai_enabled:
		return "没人操炮"
	return ""


func ammo() -> int:
	return _ammo


# —— 弹种接口（HUD 与控制器用）——
## 当前弹种的可用弹数（主炮 / 反坦克导弹）
func selected_ammo() -> int:
	return _atgm_ammo if _ammo_type == AmmoType.ATGM else _ammo


## 当前弹种的总基数
func selected_total() -> int:
	return (atgm_total() if _ammo_type == AmmoType.ATGM
			else int(VehicleTable.number(data, "ammo", 0.0)))


func ammo_type() -> int:
	return _ammo_type


func is_atgm_selected() -> bool:
	return _ammo_type == AmmoType.ATGM


func atgm_ammo() -> int:
	return _atgm_ammo


## 表里给的反坦克导弹基数（0 ＝ 这辆车没装导弹）
func atgm_total() -> int:
	return int(VehicleTable.number(data, "atgm_ammo", 0.0))


func has_atgm() -> bool:
	return atgm_total() > 0


func atgm_value(key: String, fallback: float) -> float:
	return VehicleTable.number(data, key, fallback)


## 当前弹种名字（HUD 用）：主炮取表里的主武器名，导弹固定叫「反坦克导弹」
func ammo_type_name() -> String:
	if _ammo_type == AmmoType.ATGM:
		return "反坦克导弹"
	return String(data.get("main_weapon", "主炮"))


## 武器位一键切弹种；这辆车没装导弹就切不动（返回 false）
func switch_ammo() -> bool:
	if not has_atgm():
		return false
	_ammo_type = (AmmoType.GUN if _ammo_type == AmmoType.ATGM else AmmoType.ATGM)
	queue_redraw()
	return true


func armor_summary(side: String) -> float:
	return VehicleTable.effective_armor_mm(data, side, 0.0)


## 车载武器开火（命中判定复用 BallisticsSystem；目标数组由调用方给）
func fire(targets: Array) -> Dictionary:
	if not can_fire():
		return {"fired": false, "hit": false, "distance": 0.0, "target": null}
	var atgm := _ammo_type == AmmoType.ATGM
	if atgm:
		_fire_cooldown = atgm_value("atgm_interval", 8.0)
		_atgm_ammo -= 1
	else:
		_fire_cooldown = VehicleTable.number(data, "gun_interval", 1.0)
		_ammo -= 1
	_turret_recoil = 1.0
	var range_m: float = (atgm_value("atgm_range", 1200.0) if atgm
			else VehicleTable.number(data, "main_range", 800.0))
	# 从炮口沿「炮塔朝向」打——炮塔与车体分离后，射击方向不再等于车体朝向（8.2.6）
	var result := BallisticsSystem.resolve_shot(muzzle_position(), turret_facing, range_m,
			targets, GameConfig.ENEMY_HIT_RADIUS, _sight, GameConfig.SOLDIER_EYE_HEIGHT,
			(atgm_value("atgm_structure_damage", 0.0) if atgm
			else VehicleTable.number(data, "gun_structure_damage", 0.0)))
	result["fired"] = true
	result["damage"] = (atgm_value("atgm_damage", 400.0) if atgm
			else VehicleTable.number(data, "gun_damage", 30.0))
	result["penetration_mm"] = (atgm_value("atgm_penetration_mm", 800.0) if atgm
			else VehicleTable.number(data, "gun_penetration_mm", 20.0))
	result["ammo_type"] = "atgm" if atgm else "gun"   # 供 HUD / 特效 / 音效区分
	weapon_fired.emit(muzzle_position(), turret_facing, float(result["distance"]))
	return result


## 敌方载具 AI（第一版）：发现玩家 → 车体慢慢转向、炮塔瞄准 → 对准后按更慢的节奏开火
func _ai_update(delta: float) -> void:
	if _player_ref == null:
		return
	# 🧪 补刀开关（关掉时不再朝倒地目标开炮）—— 使用者 2026-10-02 的测试态
	if not GameConfig.ENEMY_FINISH_OFF_ENABLED and _player_ref.has_method("is_incapacitated") \
			and _player_ref.is_incapacitated():
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


## 通视节流器（与 Enemy 同一套口径，见 GameConfig.SIGHT_THROTTLE_FRAMES）
var _sight_throttle := SightSystem.Throttle.new()


func _has_sight_to_player() -> bool:
	if _sight == null or _sight.grid == null or _player_ref == null:
		return true   # 没有通视系统时不拦（测试环境）
	var origin_height := _sight.grid.sample_bilinear(global_position) \
			+ GameConfig.SOLDIER_EYE_HEIGHT
	var target_height := _sight.eye_height_at(_player_ref.global_position)
	return _sight_throttle.sight(_sight, Engine.get_physics_frames(),
			global_position, origin_height,
			_player_ref.global_position, target_height)


## AI 开火：从炮口沿炮塔朝向打一轮
func _fire_ai() -> void:
	if _player_ref == null:
		return
	_ammo -= 1
	_turret_recoil = 1.0
	var result := BallisticsSystem.resolve_shot(muzzle_position(), turret_facing,
			VehicleTable.number(data, "main_range", 800.0), [_player_ref],
			GameConfig.ENEMY_HIT_RADIUS, _sight, GameConfig.SOLDIER_EYE_HEIGHT,
			VehicleTable.number(data, "gun_structure_damage", 0.0))
	weapon_fired.emit(muzzle_position(), turret_facing, float(result["distance"]))
	if result.get("cover_hit", false):
		# 载具炮弹砸在掩体 / 建筑上：结构值走弹种口径（坦克 280 ⇒ 4~5 发一栋标准建筑）
		var cover = result.get("cover")
		if cover != null and cover.has_method("take_damage"):
			cover.take_damage(VehicleTable.number(data, "gun_damage", 30.0)
					* GameConfig.ENEMY_DAMAGE_SCALE
					* GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE)
			var structure := float(result.get("structure_damage", 0.0))
			if structure > 0.0 and cover.has_method("take_structure_damage"):
				cover.take_structure_damage(structure * GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE)
		return
	if result["hit"]:
		var target = result["target"]
		if target != null and target.has_method("take_damage"):
			target.take_damage(VehicleTable.number(data, "gun_damage", 30.0)
					* GameConfig.ENEMY_DAMAGE_SCALE
					* GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE)   # 后者是 2026-10-01 加的测试用调试倍率


## 每帧：冷却、后坐衰减、炮塔回正、AI
func _process(delta: float) -> void:
	if _fire_cooldown > 0.0:
		_fire_cooldown = maxf(_fire_cooldown - delta, 0.0)
	_turret_recoil = maxf(_turret_recoil - GameConfig.TURRET_RECOIL_DECAY * delta, 0.0)
	recenter_turret(delta)
	# 起火（8.4.1：油箱被击穿）：持续掉血；docx 8.4.8 明确不蔓延、不烧到弹药架
	var burn := VehiclePartsScript.fire_dps(parts)
	if burn > 0.0 and not destroyed:
		_hull_damage(burn * delta)
	if ai_enabled and not destroyed:
		_ai_update(delta)
	_sync_layers()          # 12.7.2：图层跟着车体 / 炮塔
	_update_track(delta)    # 12.7.2：履带相位（按实际位移推进）
	_carry_occupants()      # 2026-10-02 真机修：乘员坐标跟车（见函数注释）
	_carry_crew()           # 候选 Q：敌方坦克乘员也跟着车
	queue_redraw()


func _draw() -> void:
	var length := VehicleTable.number(data, "length_m", 6.0)
	var width := VehicleTable.number(data, "width_m", 3.0)
	# 12.3 Blob Shadow：车体底下先铺一层扁椭圆影子（长轴沿车头 —— 车是长条，影子跟着走才像贴地）。
	# draw_set_transform 之后必须复位，否则后面画车体会被一起缩放。
	draw_set_transform(Vector2(GameConfig.BLOB_SHADOW_LIGHT_OFFSET,
			GameConfig.BLOB_SHADOW_LIGHT_OFFSET), 0.0,
			Vector2(length * 0.55, width * 0.62))
	draw_circle(Vector2.ZERO, 1.0,
			Color(GameConfig.BLOB_SHADOW_COLOR, GameConfig.BLOB_SHADOW_ALPHA * 0.9))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# 12.7.2 履带：两侧各一条，齿的位置由 track_phase 决定（停车 / 报废就冻住；报废变黑）
	var track_color := (GameConfig.VEHICLE_TRACK_WRECK_COLOR if destroyed
			else GameConfig.VEHICLE_TRACK_COLOR)
	var spacing := GameConfig.VEHICLE_TRACK_SPACING
	var teeth := maxi(int(ceil(length / spacing)), 2)
	for side in [1.0, -1.0]:
		var track_y: float = side * (width * 0.5 - GameConfig.VEHICLE_TRACK_WIDTH * 0.5)
		draw_rect(Rect2(-length * 0.5, track_y - GameConfig.VEHICLE_TRACK_WIDTH * 0.5,
				length, GameConfig.VEHICLE_TRACK_WIDTH), track_color)
		for x in tread_positions(track_phase, teeth, spacing):
			draw_line(Vector2(x, track_y - GameConfig.VEHICLE_TRACK_WIDTH * 0.5),
					Vector2(x, track_y + GameConfig.VEHICLE_TRACK_WIDTH * 0.5),
					GameConfig.VEHICLE_TRACK_TOOTH_COLOR, 1.0)
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
	# 12.7.2 F-kill（等效）：报废后炮管变黑 + 缩短。俯视 2D 画不出原文的「炮管下垂」，
	# 这个取舍登记在 docx 20.5（同 12.7.1 的「精灵帧 → 程序绘制」）。
	var full_reach := length * 0.5 + 2.0
	var barrel_reach := (full_reach * (1.0 - GameConfig.VEHICLE_WRECK_BARREL_SHRINK)
			if destroyed else full_reach)
	var barrel_end := turret_origin + axis * barrel_reach
	var barrel_color := (GameConfig.VEHICLE_WRECK_BARREL_COLOR if destroyed
			else Color(0.85, 0.85, 0.80, 0.95))
	draw_circle(turret_origin, width * 0.26, Color(0.42, 0.45, 0.36, 0.95))
	draw_line(turret_origin, barrel_end, barrel_color, 2.5)
	if is_occupied():
		draw_circle(Vector2.ZERO, 1.5, Color(1.0, 0.9, 0.35, 0.95))
