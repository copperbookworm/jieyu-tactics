@tool
extends EditorScript

## 载具部件系统测试（docx 8.4 / 第二十八章 · 2026-10-05）
## 覆盖：部件表完整性、mobility 与部件目录、血量派生与表内覆盖、炮塔装甲退化、
## 三态状态机、速度 / 转向 / 火力效果、方位权重兜底（显式 roll ⇒ 可复现、不依赖随机种子）。

const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const VehiclePartsScript := preload("res://systems/vehicles/VehicleParts.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table()
	_test_mobility()
	_test_catalog()
	_test_hp()
	_test_turret_armor()
	_test_state_machine()
	_test_effects_speed()
	_test_effects_firepower()
	_test_weights()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _test_table() -> void:
	var table := VehiclePartsScript.load_table()
	_check("部件表：18 行（与载具表一一对应）", table.size(), 18)
	var missing: Array[String] = []
	for id in VehicleTableScript.ids():
		if not VehiclePartsScript.has_row(String(id)):
			missing.append(String(id))
	_check("部件表：载具表里的每一辆都有部件行", missing.size(), 0)
	var extra: Array[String] = []
	for id in table.keys():
		if not VehicleTableScript.has_vehicle(String(id)):
			extra.append(String(id))
	_check("部件表：没有多余的载具 id", extra.size(), 0)


func _test_mobility() -> void:
	_check("机动：主战坦克 = tracked", VehiclePartsScript.mobility_of("mbt_t1"), "tracked")
	_check("机动：轮式突击炮 = wheeled", VehiclePartsScript.mobility_of("veh_mgsb"), "wheeled")
	_check("机动：武装皮卡 = wheeled", VehiclePartsScript.mobility_of("veh_18"), "wheeled")
	_check("机动：武装直升机 = rotary", VehiclePartsScript.mobility_of("heli_aha"), "rotary")
	var bad: Array[String] = []
	for id in VehicleTableScript.ids():
		if not VehiclePartsScript.MOBILITIES.has(VehiclePartsScript.mobility_of(String(id))):
			bad.append(String(id))
	_check("机动：18 辆的 mobility 都是三档之一", bad.size(), 0)


func _test_catalog() -> void:
	var tank := VehiclePartsScript.part_catalog_for("mbt_t1")
	_check_true("目录：坦克有左右履带", tank.has("track_l") and tank.has("track_r"))
	_check_true("目录：坦克有炮塔环", tank.has("turret_ring"))
	_check_true("目录：所有车都有发动机与油箱", tank.has("engine") and tank.has("fuel_tank"))
	_check_true("目录：坦克没有轮胎 / 旋翼",
			not tank.has("wheel_front") and not tank.has("rotor"))
	var truck := VehiclePartsScript.part_catalog_for("veh_18")
	_check_true("目录：皮卡是轮式（前 / 后轮组）",
			truck.has("wheel_front") and truck.has("wheel_rear"))
	_check_true("目录：皮卡没有炮塔环（非正规载具）", not truck.has("turret_ring"))
	_check_true("目录：皮卡有弹药架（备弹 600）", truck.has("ammo_rack"))
	var heli := VehiclePartsScript.part_catalog_for("heli_aha")
	_check_true("目录：直升机有旋翼与尾桨", heli.has("rotor") and heli.has("tail_rotor"))
	_check_true("目录：直升机没有炮塔环", not heli.has("turret_ring"))
	_check("档位：炮塔环 → 炮塔档", VehiclePartsScript.gear_of("turret_ring"),
			VehiclePartsScript.Gear.TURRET)
	_check("档位：弹药架 → 车体档", VehiclePartsScript.gear_of("ammo_rack"),
			VehiclePartsScript.Gear.HULL)
	_check("档位：履带 → 机动件档", VehiclePartsScript.gear_of("track_l"),
			VehiclePartsScript.Gear.MOBILE)
	_check("档位：循环 炮塔 → 车体 → 机动件 → 炮塔",
			[VehiclePartsScript.next_gear(VehiclePartsScript.Gear.TURRET),
			VehiclePartsScript.next_gear(VehiclePartsScript.Gear.HULL),
			VehiclePartsScript.next_gear(VehiclePartsScript.Gear.MOBILE)],
			[VehiclePartsScript.Gear.HULL, VehiclePartsScript.Gear.MOBILE,
			VehiclePartsScript.Gear.TURRET])


func _test_hp() -> void:
	var vehicle: Dictionary = VehicleTableScript.get_vehicle("mbt_t1")
	var hp := VehicleTableScript.number(vehicle, "hp", 0.0)
	_check("血量：坦克 2000 结构 ⇒ 发动机派生 500",
			VehiclePartsScript.derived_hp(hp, "engine"), hp * 0.25)
	_check("血量：弹药架派生 = 20% 结构值",
			VehiclePartsScript.derived_hp(hp, "ammo_rack"), hp * 0.20)
	_check("血量：油箱派生 = 15% 结构值",
			VehiclePartsScript.derived_hp(hp, "fuel_tank"), hp * 0.15)
	_check("血量：炮塔环派生 = 25% 结构值",
			VehiclePartsScript.derived_hp(hp, "turret_ring"), hp * 0.25)
	_check("血量：机动件派生 = 15% 结构值",
			VehiclePartsScript.derived_hp(hp, "track_l"), hp * 0.15)
	_check("血量：表内覆盖优先于派生（engine_hp=999）",
			VehiclePartsScript.hp_with_row({"engine_hp": "999"}, hp, "engine"), 999.0)
	_check("血量：表内空值退回派生",
			VehiclePartsScript.hp_with_row({"engine_hp": ""}, hp, "engine"), hp * 0.25)
	_check("血量：最小 1（结构值为 0 的车也不会出现 0 血部件）",
			VehiclePartsScript.derived_hp(0.0, "engine"), 1.0)
	var parts := VehiclePartsScript.init_parts("ifv_a")
	_check("血量：目录初始化后部件数与目录一致", parts.size(),
			VehiclePartsScript.part_catalog_for("ifv_a").size())
	var ok := true
	for part in parts.keys():
		if int(parts[part]["state"]) != VehiclePartsScript.STATE_OK:
			ok = false
	_check_true("血量：初始化状态全是 STATE_OK", ok)


func _test_turret_armor() -> void:
	var tank: Dictionary = VehicleTableScript.get_vehicle("mbt_t1")
	_check("炮塔装甲：表里为空 ⇒ 沿用同面车体装甲（正面 700）",
			VehiclePartsScript.turret_armor_mm("mbt_t1", "front"), 700.0)
	_check("炮塔装甲：表内覆盖优先（turret_armor_front_mm=850）",
			VehiclePartsScript.turret_armor_with_row({"turret_armor_front_mm": "850"},
			tank, "front"), 850.0)
	_check("炮塔装甲：侧面沿用车身侧面（260）",
			VehiclePartsScript.turret_armor_mm("mbt_t1", "side"), 260.0)


func _test_state_machine() -> void:
	_check("三态：满血 = 完好", VehiclePartsScript.state_from_ratio(1.0),
			VehiclePartsScript.STATE_OK)
	_check("三态：50% = 受损（边界含）", VehiclePartsScript.state_from_ratio(0.5),
			VehiclePartsScript.STATE_DAMAGED)
	_check("三态：40% = 受损", VehiclePartsScript.state_from_ratio(0.4),
			VehiclePartsScript.STATE_DAMAGED)
	_check("三态：0 = 损坏", VehiclePartsScript.state_from_ratio(0.0),
			VehiclePartsScript.STATE_DESTROYED)
	var parts := VehiclePartsScript.init_parts("mbt_t1")
	var engine_max := float(parts["engine"]["max_hp"])
	VehiclePartsScript.damage_part(parts, "engine", engine_max * 0.6)
	_check("三态：打掉 60%（剩 40%）⇒ 发动机受损",
			VehiclePartsScript.state_of(parts, "engine"), VehiclePartsScript.STATE_DAMAGED)
	VehiclePartsScript.damage_part(parts, "engine", engine_max)
	_check("三态：一次打空 ⇒ 直接损坏（不做两段式）",
			VehiclePartsScript.state_of(parts, "engine"), VehiclePartsScript.STATE_DESTROYED)
	_check("三态：打不存在于该车的部件 = 不生效",
			VehiclePartsScript.damage_part(parts, "rotor", 100.0)["applied"], false)
	_check("三态：损坏的部件血量夹到 0", float(parts["engine"]["hp"]), 0.0)


func _test_effects_speed() -> void:
	var mobility := "tracked"
	var fresh := VehiclePartsScript.init_parts("mbt_t1")
	_check("效果：完好时速度 / 转向都是 1.0",
			[VehiclePartsScript.speed_scale(fresh, mobility),
			VehiclePartsScript.turn_scale(fresh, mobility)], [1.0, 1.0])
	VehiclePartsScript.set_state(fresh, "track_l", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：断一条履带 ⇒ 速度 ×0.7",
			VehiclePartsScript.speed_scale(fresh, mobility),
			GameConfig.VEHICLE_TRACK_ONE_SPEED_SCALE)
	_check("效果：断一条履带 ⇒ 转向 ×0.5",
			VehiclePartsScript.turn_scale(fresh, mobility),
			GameConfig.VEHICLE_TRACK_ONE_TURN_SCALE)
	VehiclePartsScript.set_state(fresh, "track_r", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：双侧断带 ⇒ 截瘫（速度 0）",
			VehiclePartsScript.speed_scale(fresh, mobility), 0.0)
	_check_true("效果：双侧断带 = M-kill", VehiclePartsScript.is_immobilised(fresh, mobility))
	var engine_parts := VehiclePartsScript.init_parts("mbt_t1")
	VehiclePartsScript.set_state(engine_parts, "engine", VehiclePartsScript.STATE_DAMAGED)
	_check("效果：发动机受损 ⇒ 速度 ×0.6",
			VehiclePartsScript.speed_scale(engine_parts, mobility),
			GameConfig.VEHICLE_ENGINE_DAMAGED_SPEED_SCALE)
	VehiclePartsScript.set_state(engine_parts, "engine", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：发动机损坏 ⇒ 熄火（速度 0）",
			VehiclePartsScript.speed_scale(engine_parts, mobility), 0.0)
	var wheels := VehiclePartsScript.init_parts("veh_18")
	VehiclePartsScript.set_state(wheels, "wheel_front", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：轮式单组损坏 ⇒ 速度 ×0.85",
			VehiclePartsScript.speed_scale(wheels, "wheeled"),
			GameConfig.VEHICLE_WHEEL_ONE_SPEED_SCALE)
	VehiclePartsScript.set_state(wheels, "wheel_rear", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：轮式全部损坏 ⇒ M-kill",
			VehiclePartsScript.speed_scale(wheels, "wheeled"), 0.0)
	var heli := VehiclePartsScript.init_parts("heli_aha")
	VehiclePartsScript.set_state(heli, "rotor", VehiclePartsScript.STATE_DESTROYED)
	_check("效果：旋翼损坏 ⇒ 速度 0", VehiclePartsScript.speed_scale(heli, "rotary"), 0.0)


func _test_effects_firepower() -> void:
	var parts := VehiclePartsScript.init_parts("mbt_t1")
	_check("火力：完好时炮塔转速 1.0 + 主炮可开",
			[VehiclePartsScript.turret_rotate_scale(parts),
			VehiclePartsScript.main_gun_blocked(parts)], [1.0, false])
	VehiclePartsScript.set_state(parts, "turret_ring", VehiclePartsScript.STATE_DAMAGED)
	_check("火力：炮塔环受损 ⇒ 转速 ×0.3",
			VehiclePartsScript.turret_rotate_scale(parts),
			GameConfig.VEHICLE_TURRET_RING_DAMAGED_ROTATE_SCALE)
	_check_true("火力：炮塔环受损仍可开炮（只是转得慢）",
			not VehiclePartsScript.main_gun_blocked(parts))
	VehiclePartsScript.set_state(parts, "turret_ring", VehiclePartsScript.STATE_DESTROYED)
	_check("火力：炮塔环损坏 ⇒ 转速 0",
			VehiclePartsScript.turret_rotate_scale(parts), 0.0)
	_check_true("火力：炮塔环损坏 ⇒ F-kill（主炮不能开）",
			VehiclePartsScript.main_gun_blocked(parts))
	_check("起火：油箱完好时 0 dps", VehiclePartsScript.fire_dps(parts), 0.0)
	VehiclePartsScript.set_state(parts, "fuel_tank", VehiclePartsScript.STATE_DESTROYED)
	_check("起火：油箱被击穿 ⇒ 持续掉血（不蔓延）",
			VehiclePartsScript.fire_dps(parts), GameConfig.VEHICLE_FIRE_DPS)


func _test_weights() -> void:
	for side in ["front", "side", "rear"]:
		var total := 0.0
		for w in GameConfig.VEHICLE_PART_WEIGHTS[side].values():
			total += float(w)
		_check("权重：%s 面权重合计 = 1.0" % side, snappedf(total, 0.001), 1.0)
	_check("兜底：正面 + 炮塔档 ⇒ 只能落到炮塔环",
			VehiclePartsScript.roll_part("mbt_t1", "front",
			VehiclePartsScript.Gear.TURRET, 0.0), "turret_ring")
	_check("兜底：正面 + 机动档 ⇒ 落到履带（左）",
			VehiclePartsScript.roll_part("mbt_t1", "front",
			VehiclePartsScript.Gear.MOBILE, 0.0), "track_l")
	_check("兜底：后部 + 车体档 + roll 0 ⇒ 发动机（权重最高）",
			VehiclePartsScript.roll_part("mbt_t1", "rear",
			VehiclePartsScript.Gear.HULL, 0.0), "engine")
	_check("兜底：侧面 + 不限档 + roll 0.99 ⇒ 油箱（累计最后一段）",
			VehiclePartsScript.roll_part("mbt_t1", "side", -1, 0.99), "fuel_tank")
	_check("兜底：轮式车正面 + 机动档 ⇒ 前轮组",
			VehiclePartsScript.roll_part("veh_18", "front",
			VehiclePartsScript.Gear.MOBILE, 0.0), "wheel_front")
	_check("兜底：没炮塔的车选炮塔档 ⇒ 退回车体（不产生不存在的部件）",
			VehiclePartsScript.roll_part("veh_18", "front",
			VehiclePartsScript.Gear.TURRET, 0.0), "hull")
	var seen := {}
	for i in 20:
		seen[VehiclePartsScript.roll_part("mbt_t1", "side", -1, float(i) / 20.0)] = true
	_check_true("兜底：侧面 20 个采样点覆盖履带 / 车体 / 发动机 / 弹药架 / 油箱（%d 类）"
			% seen.size(), seen.size() >= 5)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if typeof(actual) == TYPE_FLOAT and typeof(expected) == TYPE_FLOAT:
		if is_equal_approx(float(actual), float(expected)):
			_passed += 1
			print("[OK]   %s" % title)
			return
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)
