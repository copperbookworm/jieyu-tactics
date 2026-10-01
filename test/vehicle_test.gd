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
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


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
	_check_true("载具表：至少 2 辆（实际 %d）" % table.size(), table.size() >= 2)
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
