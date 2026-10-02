@tool
extends EditorScript

## 载具系统测试（docx 第八章：8.1 舱室与座位 / 8.2 装甲与武器 / 8.2.6 炮塔手感）
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 覆盖：表字段、装甲等效厚度与击穿、炮塔转速上限、炮塔回正收敛、座位与开炮权限、AI 开火闸门

const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const VehicleScript := preload("res://entities/vehicle/Vehicle.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table()
	_test_armor_math()
	_test_penetration()
	_test_turret_rotation()
	_test_turret_recenter()
	_test_seats()
	_test_ai_gate()
	_test_enemy_vehicle_damage()
	_test_occupant_carried()
	_test_fire_block_reason()
	_test_wreck_refuses_boarding()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


## 乘员跟着车走（2026-10-02 真机修）：相机 / 开发用黄箭头 / 载具发烟器都读乘员坐标，
## 以前上车后坐标冻在上车点，所以「黄箭头停在上车点、镜头不跟车、烟放在原地」。
func _test_occupant_carried() -> void:
	var vehicle = VehicleScript.new()
	vehicle.setup("ifv_a", null)
	var player := PlayerUnit.new()
	vehicle.enter(player)
	_check("上车：坐进驾驶位", vehicle.seat_of(player), "driver")
	_check_true("上车：人被藏起来 + 输入锁住", not player.visible and player.input_locked)
	vehicle.global_position = Vector2(120.0, -40.0)
	vehicle._process(0.016)
	_check("乘员坐标跟着车走（相机 / 箭头 / 发烟器读的就是它）",
			player.global_position, vehicle.global_position)
	vehicle.switch_seat(player)
	vehicle.global_position = Vector2(-8.0, 33.0)
	vehicle._process(0.016)
	_check("换到武器位后照样跟着走", player.global_position, vehicle.global_position)
	vehicle.exit_vehicle()
	_check_true("下车：人重新可见 + 输入解锁", player.visible and not player.input_locked)
	_check("下车：人落在车旁 5 m（不是上车点）",
			int(player.global_position.distance_to(vehicle.global_position)), 5)
	vehicle.free()
	player.free()


## 敌人载具主炮的伤害出口：表值 × ENEMY_DAMAGE_SCALE × ENEMY_VEHICLE_DAMAGE_SCALE。
## 期望值从常量派生 ⇒ 调试倍率是 0.0 还是 1.0 这条都通过（不会把调试态锁进测试里）。
func _test_enemy_vehicle_damage() -> void:
	var tank = VehicleScript.new()
	tank.setup("mbt_t1", null)
	tank.turret_facing = Vector2.RIGHT
	var player := PlayerUnit.new()
	player.position = Vector2(200.0, 0.0)     # 正对炮口、在射程内
	player.hp = GameConfig.SOLDIER_HP
	tank._player_ref = player
	tank._ammo = 10
	tank._fire_ai()
	var table_damage := VehicleTableScript.number(tank.data, "gun_damage", 0.0)
	# 注意血量下限：一发 400 打在 100 血的步兵身上，PlayerUnit.take_damage 会夹到 0（不会出现 -300），
	# 所以期望值要取 min(伤害, 满血)。调试倍率是 0 时两者都是 0，这条依旧成立。
	var expected := minf(table_damage * GameConfig.ENEMY_DAMAGE_SCALE \
			* GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE, GameConfig.SOLDIER_HP)
	_check("主炮消耗 1 发（表里有弹药）", tank._ammo, 9)
	_check_true("主炮伤害 = min(表值 %.0f × 两个开关, 满血 %.0f) = %.0f"
			% [table_damage, GameConfig.SOLDIER_HP, expected],
			is_equal_approx(GameConfig.SOLDIER_HP - player.hp, expected))
	tank.free()
	player.free()


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _make_vehicle():
	var vehicle = VehicleScript.new()
	vehicle.setup("ifv_a", null)
	return vehicle


func _test_table() -> void:
	var table := VehicleTableScript.load_table()
	# 候选 R（2026-10-02）：表已扩到官方全量 18 辆，且已校准的两辆数值不能被扩表改动
	# 名字加 _r 后缀：本函数上面已经有 ifv / tank 两个局部变量了（重复声明会编译失败）
	var ifv_r := VehicleTableScript.get_vehicle("ifv_a")
	var tank_r := VehicleTableScript.get_vehicle("mbt_t1")
	_check("载具表：18 辆（官方全量）", table.size(), 18)
	_check_true("扩表后 ifv_a 数值没动（800 结构 / 600 弹药 / 2 发导弹）",
			VehicleTableScript.number(ifv_r, "hp", 0.0) == 800.0
			and VehicleTableScript.number(ifv_r, "ammo", 0.0) == 600.0
			and VehicleTableScript.number(ifv_r, "atgm_ammo", 0.0) == 2.0)
	_check_true("扩表后 mbt_t1 数值没动（2000 结构 / 42 发 / 700 穿深）",
			VehicleTableScript.number(tank_r, "hp", 0.0) == 2000.0
			and VehicleTableScript.number(tank_r, "ammo", 0.0) == 42.0
			and VehicleTableScript.number(tank_r, "gun_penetration_mm", 0.0) == 700.0)
	var ifv: Dictionary = VehicleTableScript.get_vehicle("ifv_a")
	_check("载具表：IFV 车长 7.2 m", VehicleTableScript.number(ifv, "length_m", 0.0), 7.2)
	_check("载具表：IFV 侧甲 45 mm", VehicleTableScript.number(ifv, "armor_side_mm", 0.0), 45.0)
	_check("载具表：IFV 结构值 800", VehicleTableScript.number(ifv, "hp", 0.0), 800.0)
	_check_true("载具表：不存在的车返回 false",
			not VehicleTableScript.has_vehicle("nope"))


func _test_armor_math() -> void:
	var tank: Dictionary = VehicleTableScript.get_vehicle("mbt_t1")
	var flat := VehicleTableScript.effective_armor_mm(tank, "front", 0.0)
	var angled := VehicleTableScript.effective_armor_mm(tank, "front", 30.0)
	_check_true("装甲：坦克首上 700 mm + 基础倾角 30° ⇒ 等效 %.0f mm ≥ 700" % flat,
			flat >= 700.0)
	_check_true("装甲：再叠 30° 入射角 ⇒ 等效更大（%.0f mm）" % angled, angled > flat)
	_check_true("装甲：同一辆车侧面比正面薄",
			VehicleTableScript.effective_armor_mm(tank, "side", 0.0)
			< VehicleTableScript.effective_armor_mm(tank, "front", 0.0))


func _test_penetration() -> void:
	var ifv: Dictionary = VehicleTableScript.get_vehicle("ifv_a")
	_check("击穿：5.8mm 步枪弹打不穿 IFV 侧甲（45 mm）",
			VehicleTableScript.is_penetrated(ifv, "side", 0.0,
					GameConfig.SOLDIER_BULLET_PENETRATION_MM), false)
	_check("击穿：30mm 机炮（60 mm）能打穿 IFV 侧甲",
			VehicleTableScript.is_penetrated(ifv, "side", 0.0, 60.0), true)
	var tank: Dictionary = VehicleTableScript.get_vehicle("mbt_t1")
	# 首上 700 mm 是「法向厚度 @ 30° 基础倾角」⇒ 等效 808 mm：700 mm 穿深的主炮正面本就打不穿
	# （§七「载具反装甲路径」待拍板就是因为这条数据必然性，不是判定 bug）；侧面 260 mm 能穿。
	_check("击穿：125mm 主炮（700 mm）打不穿坦克首上（等效 808 mm）",
			VehicleTableScript.is_penetrated(tank, "front", 0.0, 700.0), false)
	_check("击穿：同一门炮（700 mm）能打穿坦克侧面（260 mm）",
			VehicleTableScript.is_penetrated(tank, "side", 0.0, 700.0), true)
	_check("击穿：步枪弹打坦克侧面（260 mm）也白打",
			VehicleTableScript.is_penetrated(tank, "side", 0.0,
					GameConfig.SOLDIER_BULLET_PENETRATION_MM), false)


## 8.2.6：炮塔转速有上限（45°/s），不是瞬间对准
func _test_turret_rotation() -> void:
	var vehicle = _make_vehicle()
	vehicle.turret_facing = Vector2.RIGHT
	vehicle.aim_at(vehicle.global_position + Vector2.UP, 0.1)
	var turned := absf(rad_to_deg(wrapf(vehicle.turret_facing.angle()
			- Vector2.RIGHT.angle(), -PI, PI)))
	_check_true("炮塔：0.1 s 内只转 %.1f°（受 45°/s 限制，≤ 4.6°）" % turned, turned <= 4.6)
	_check_true("炮塔：确实在转（> 4°）", turned > 4.0)
	# 连续转够时间后应能对准
	for i in 40:
		vehicle.aim_at(vehicle.global_position + Vector2.UP, 0.1)
	var aligned := absf(rad_to_deg(wrapf(vehicle.turret_facing.angle()
			- Vector2.UP.angle(), -PI, PI)))
	_check_true("炮塔：给足时间能对准目标（偏差 %.1f°）" % aligned, aligned < 1.0)
	vehicle.free()


## 8.2.6：没人操炮时炮塔回正到车体朝向
func _test_turret_recenter() -> void:
	var vehicle = _make_vehicle()
	vehicle.hull_facing = Vector2.RIGHT
	vehicle.turret_facing = Vector2.UP
	var before := absf(wrapf(vehicle.turret_facing.angle() - vehicle.hull_facing.angle(),
			-PI, PI))
	for i in 20:
		vehicle.recenter_turret(0.1)
	var after := absf(wrapf(vehicle.turret_facing.angle() - vehicle.hull_facing.angle(),
			-PI, PI))
	_check_true("回正：偏离从 %.0f° 收到 %.0f°" % [rad_to_deg(before), rad_to_deg(after)],
			after < before)
	_check_true("回正：收敛过半", after < before * 0.5)
	vehicle.free()


## 8.1：两个座位，且只有武器位能开炮
func _test_seats() -> void:
	var vehicle = _make_vehicle()
	var player := PlayerUnit.new()
	vehicle.enter(player)
	_check("座位：上车默认坐驾驶位", vehicle.seat_of(player), "driver")
	_check("座位：驾驶位不能开炮", vehicle.can_fire(), false)
	_check("座位：换座后到武器位", vehicle.switch_seat(player), "gunner")
	_check_true("座位：武器位能开炮", vehicle.can_fire())
	_check("座位：驾驶位已空出", vehicle.driver, null)
	vehicle.free()
	player.free()


## 敌方载具：AI 打开后无人操炮也能开火
func _test_ai_gate() -> void:
	var vehicle = _make_vehicle()
	_check("AI：普通载具没人操炮时不能开火", vehicle.can_fire(), false)
	vehicle.ai_enabled = true
	_check("AI：AI 车可自主开火", vehicle.can_fire(), true)
	vehicle.free()


## 开不了炮时必须说得出原因（2026-10-01 修：原来 can_fire() 为假就静默返回，
## 玩家在报废车的武器位上按开火键完全没反馈，看起来就是「开火键坏了」）
func _test_fire_block_reason() -> void:
	var vehicle = _make_vehicle()
	_check("原因：空车（没人操炮、也不是 AI 车）⇒ 说得出原因",
			vehicle.fire_block_reason(), "没人操炮")

	var player := PlayerUnit.new()
	vehicle.enter(player)
	vehicle.switch_seat(player)
	_check("原因：武器位 + 有弹 ⇒ 无原因（能开）", vehicle.fire_block_reason(), "")

	vehicle._fire_cooldown = 1.0
	_check("原因：冷却中", vehicle.fire_block_reason(), "装填中")
	vehicle._fire_cooldown = 0.0

	var ammo_backup: int = vehicle.ammo()
	vehicle._ammo = 0
	_check("原因：没弹", vehicle.fire_block_reason(), "车载弹药耗尽")
	_check("原因：没弹时 can_fire 为假", vehicle.can_fire(), false)
	vehicle._ammo = ammo_backup

	vehicle.take_hit(99999.0, 99999.0, Vector2.RIGHT)
	_check("原因：报废", vehicle.fire_block_reason(), "载具已报废")
	_check("报废：can_fire 为假", vehicle.can_fire(), false)
	_check_true("报废：take_hit 会把乘员请下车", not vehicle.is_occupied())
	vehicle.free()
	player.free()


## 报废车不许再上（2026-10-01 修）：否则玩家会坐上「永远打不出炮、也没有提示」的座位
func _test_wreck_refuses_boarding() -> void:
	var vehicle = _make_vehicle()
	vehicle.take_hit(99999.0, 99999.0, Vector2.RIGHT)
	_check_true("报废：destroyed 为真", vehicle.destroyed)
	var player := PlayerUnit.new()
	vehicle.enter(player)
	_check("报废车：enter() 拒绝载人（驾驶位仍空）", vehicle.driver, null)
	_check("报废车：整辆车没人占用", vehicle.is_occupied(), false)
	vehicle.free()
	player.free()
