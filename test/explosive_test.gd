@tool
extends EditorScript

## 炸药 / 工程兵自测：
##   弹种表（C4 1500 / TNT 2000）· 射程分档（贴放 ≤15 m / 投掷 ≤35 m）· 抛物线采样
##   · 安放读条常量 · 爆炸衰减（对人 / 对建筑）· 与间瞄共用同一条「弹种口径」内核 · 兵种携带量
## 用 preload 引用刻意不写 class_name 的模块（见 Cover.gd 头部说明）
##
## 2026-10-07 第八十三版（docx ㊺㊻㊼ 三条尾巴）：射程不再只有「≤15 m 可以、否则拒绝」——
##   >15 m 改走投掷（抛物线 + 落点预警），只有 >35 m 才是真拒绝。下面的断言跟着改了口径。

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")
const ExplosiveSystemScript := preload("res://systems/explosives/ExplosiveSystem.gd")
const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const RoleTableScript := preload("res://data/config/RoleTable.gd")
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table()
	_test_range()
	_test_throw_flight()
	_test_cast()
	_test_unit_blast()
	_test_structure_blast()
	_test_role_loadout()
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


func _test_table() -> void:
	_check("炸药表：2 种（C4 / TNT）", ChargeTableScript.ids().size(), 2)
	_check("默认装药 = C4", ChargeTableScript.default_charge_id(), "c4")
	_check("C4 结构伤害 = 1500（拍板值）", ChargeTableScript.structure_damage("c4"), 1500.0)
	_check("TNT 结构伤害 = 2000（拍板值）", ChargeTableScript.structure_damage("tnt"), 2000.0)
	_check_true("加固档建筑 3000：C4 两发拆掉（1500 × 2 ≥ 3000）",
			ChargeTableScript.structure_damage("c4") * 2.0 >= 3000.0)
	_check("未知 id 退回默认装药（绝不给空表）",
			ChargeTableScript.name_of("nope"), ChargeTableScript.name_of("c4"))
	_check_true("半径都是正的",
			ChargeTableScript.radius_m("c4") > 0.0 and ChargeTableScript.radius_m("tnt") > 0.0)
	_check_true("炸药比 155mm 间瞄（420）高一档",
			ChargeTableScript.structure_damage("c4") > GameConfig.INDIRECT_STRUCTURE_DAMAGE)


## 射程分档（docx ㊻）：≤15 m 贴放 / >15 m 投掷 / >35 m 拒绝。三条线都要钉住。
func _test_range() -> void:
	var origin := Vector2(100.0, 100.0)
	_check("射程：贴脚放可以（0 m）", ExplosiveSystemScript.can_place(origin, origin), true)
	_check("射程：贴放上限处可以（15 m）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(15.0, 0.0)), true)
	_check("射程：刚过贴放上限不再拒绝（15.1 m 改走投掷）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(15.1, 0.0)), true)
	_check("射程：投掷上限处可以（35 m）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(35.0, 0.0)), true)
	_check("射程：刚过投掷上限拒绝（35.1 m）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(35.1, 0.0)), false)
	_check_true("射程：拒绝时给得出原因（500 m）",
			not ExplosiveSystemScript.placement_error(origin, origin + Vector2(500.0, 0.0)).is_empty())
	_check("射程：可以放时没有原因",
			ExplosiveSystemScript.placement_error(origin, origin + Vector2(5.0, 0.0)), "")

	_check("分档：0 m = 贴放", ExplosiveSystemScript.action_at(origin, origin), "place")
	_check("分档：15 m = 贴放",
			ExplosiveSystemScript.action_at(origin, origin + Vector2(15.0, 0.0)), "place")
	_check("分档：15.1 m = 投掷",
			ExplosiveSystemScript.action_at(origin, origin + Vector2(15.1, 0.0)), "throw")
	_check("分档：35 m = 投掷",
			ExplosiveSystemScript.action_at(origin, origin + Vector2(35.0, 0.0)), "throw")
	_check("分档：35.1 m = 够不着",
			ExplosiveSystemScript.action_at(origin, origin + Vector2(35.1, 0.0)), "")
	_check_true("分档：is_throw 与 action_at 同口径（15.1 m）",
			ExplosiveSystemScript.is_throw(origin, origin + Vector2(15.1, 0.0)))
	_check_true("分档：is_throw 对贴放为假",
			not ExplosiveSystemScript.is_throw(origin, origin + Vector2(14.9, 0.0)))

	_check("射程：贴放上限常量 = 15 m", ExplosiveSystemScript.PLACE_MAX_M, 15.0)
	_check("射程：投掷上限常量 = 35 m", ExplosiveSystemScript.THROW_MAX_M, 35.0)
	_check("射程：贴放上限就是投掷下限（分档不留缝）",
			ExplosiveSystemScript.THROW_MIN_M, ExplosiveSystemScript.PLACE_MAX_M)
	_check_true("射程：上限是递增的（贴放 < 投掷）",
			ExplosiveSystemScript.PLACE_MAX_M < ExplosiveSystemScript.THROW_MAX_M)


## 抛物线（docx ㊻）：飞行时间随距离单调增长；地面位置线性插值；屏幕抬升是 4u(1−u)。
func _test_throw_flight() -> void:
	var from := Vector2(0.0, 0.0)
	var to := Vector2(20.0, 0.0)
	var flight := ExplosiveSystemScript.throw_flight_time(20.0)

	_check_true("抛物：15 m 飞行时间 > 0（不是瞬时落地）",
			ExplosiveSystemScript.throw_flight_time(15.0) > 0.0)
	_check_true("抛物：距离越远飞得越久（35 m > 15 m）",
			ExplosiveSystemScript.throw_flight_time(35.0)
			> ExplosiveSystemScript.throw_flight_time(15.0))
	_check_true("抛物：15 m 大约 1 s（0.8~1.2）",
			absf(ExplosiveSystemScript.throw_flight_time(15.0) - 1.0) < 0.2)
	_check_true("抛物：上限 35 m 仍在 2 s 内",
			ExplosiveSystemScript.throw_flight_time(35.0) < 2.0)

	_check("抛物：起飞瞬间在地面起点",
			ExplosiveSystemScript.throw_position_at(from, to, 0.0, flight), from)
	_check("抛物：飞完精确落在落点",
			ExplosiveSystemScript.throw_position_at(from, to, flight, flight), to)
	_check("抛物：超时也不越过落点（clamp）",
			ExplosiveSystemScript.throw_position_at(from, to, flight * 3.0, flight), to)
	_check_true("抛物：半程在地面平面中点附近",
			ExplosiveSystemScript.throw_position_at(from, to, flight * 0.5, flight)
			.distance_to(Vector2(10.0, 0.0)) < 0.01)
	_check("抛物：飞行时间为 0 时不给 NaN（直接落到落点）",
			ExplosiveSystemScript.throw_position_at(from, to, 0.0, 0.0), to)

	_check("抛物：起点抬升为 0",
			ExplosiveSystemScript.throw_lift_px(20.0, 0.0, flight), 0.0)
	_check("抛物：落地抬升也为 0",
			ExplosiveSystemScript.throw_lift_px(20.0, flight, flight), 0.0)
	var peak: float = ExplosiveSystemScript.throw_lift_px(20.0, flight * 0.5, flight)
	_check_true("抛物：中点最高（> 起点）", peak > 0.0)
	_check_true("抛物：峰值在视觉上限内（≤ 40 px）",
			peak <= ExplosiveSystemScript.THROW_ARC_MAX_PX + 0.001)
	_check_true("抛物：近距离也不会贴地飞（峰值 ≥ 下限）",
			ExplosiveSystemScript.throw_lift_px(1.0, flight * 0.5, flight)
			>= ExplosiveSystemScript.THROW_ARC_MIN_PX - 0.001)
	_check_true("抛物：抬升对 u 对称（1/4 与 3/4 处相等）",
			absf(ExplosiveSystemScript.throw_lift_px(20.0, flight * 0.25, flight)
			- ExplosiveSystemScript.throw_lift_px(20.0, flight * 0.75, flight)) < 0.001)


## 安放读条（docx ㊼）
func _test_cast() -> void:
	_check("读条：安放时长 = 1.5 s", ExplosiveSystemScript.PLACE_CAST_S, 1.5)
	_check_true("读条：打断的位移容差是正数（否则站着不动也会自打断）",
			ExplosiveSystemScript.CAST_MOVE_TOLERANCE_M > 0.0)
	_check_true("读条：位移容差远小于贴放上限（别把「挪一步」当成没动）",
			ExplosiveSystemScript.CAST_MOVE_TOLERANCE_M < ExplosiveSystemScript.PLACE_MAX_M)


func _test_unit_blast() -> void:
	var c4_radius := ChargeTableScript.radius_m("c4")
	_check("对人：爆心 = unit_damage",
			ExplosiveSystemScript.unit_blast_at(0.0, "c4"),
			ChargeTableScript.unit_damage("c4"))
	# 区间是 [0, radius)：半径**内缘**趋近 unit_min_damage，到半径处就是 0
	# （与间瞄 blast_damage_at 同形状 —— indirect_test 也是按 `<= 最小值` 验的）
	_check_true("对人：半径内缘已衰减到 unit_min_damage 附近（±1）",
			ExplosiveSystemScript.unit_blast_at(c4_radius - 0.05, "c4")
			<= ChargeTableScript.unit_min_damage("c4") + 1.0)
	_check_true("对人：半径内缘仍为正（区间是 [0, radius)）",
			ExplosiveSystemScript.unit_blast_at(c4_radius - 0.05, "c4") > 0.0)
	_check("对人：半径处 0", ExplosiveSystemScript.unit_blast_at(c4_radius, "c4"), 0.0)
	_check("对人：半径外 0", ExplosiveSystemScript.unit_blast_at(c4_radius + 1.0, "c4"), 0.0)
	_check_true("对人：伤害随距离单调下降",
			ExplosiveSystemScript.unit_blast_at(1.0, "c4")
			> ExplosiveSystemScript.unit_blast_at(6.0, "c4"))


## 对建筑必须与间瞄**同一套内核**：同一个 (距离, 结构伤害, 半径) 下逐值相等 ——
## 哪天有人抄了第二份衰减公式，这条立刻红。
func _test_structure_blast() -> void:
	var tnt := ChargeTableScript.structure_damage("tnt")
	var radius := ChargeTableScript.radius_m("tnt")
	_check("对建筑：爆心 = 弹种结构伤害（贴上去就是满值）",
			ExplosiveSystemScript.structure_blast_at(0.0, "c4"), 1500.0)
	_check("对建筑：与 IndirectFire 同内核（爆心）",
			ExplosiveSystemScript.structure_blast_at(0.0, "tnt"),
			IndirectFireScript.structure_blast_at(0.0, tnt, radius))
	_check("对建筑：与 IndirectFire 同内核（半径一半）",
			ExplosiveSystemScript.structure_blast_at(radius * 0.5, "tnt"),
			IndirectFireScript.structure_blast_at(radius * 0.5, tnt, radius))
	_check("对建筑：半径外 0", ExplosiveSystemScript.structure_blast_at(radius + 1.0, "tnt"), 0.0)


func _test_role_loadout() -> void:
	_check("工程兵带 2 发炸药", RoleTableScript.charges_for(RoleTableScript.Role.ENGINEER), 2)
	_check("步枪兵带 0 发", RoleTableScript.charges_for(RoleTableScript.Role.RIFLEMAN), 0)
	_check("侦察兵带 0 发", RoleTableScript.charges_for(RoleTableScript.Role.SCOUT), 0)
	_check("精确射手带 0 发", RoleTableScript.charges_for(RoleTableScript.Role.MARKSMAN), 0)
	var engineer_weapon := String(RoleTableScript.weapon_ids(RoleTableScript.Role.ENGINEER)[0])
	_check_true("工程兵主武器 %s 在武器表里" % engineer_weapon,
			not WeaponTableScript.get_weapon(engineer_weapon).is_empty())
