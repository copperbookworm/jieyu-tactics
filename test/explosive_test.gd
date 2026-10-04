@tool
extends EditorScript

## 炸药 / 工程兵（2026-10-04 使用者拍板）自测：
##   弹种表（C4 1500 / TNT 2000）· 放置校验（≤15 m）· 爆炸衰减（对人 / 对建筑）
##   · 与间瞄共用同一条「弹种口径」内核 · 兵种携带量
## 用 preload 引用刻意不写 class_name 的模块（见 Cover.gd 头部说明）

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")
const ExplosiveSystemScript := preload("res://systems/explosives/ExplosiveSystem.gd")
const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const RoleTableScript := preload("res://data/config/RoleTable.gd")
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table()
	_test_placement()
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


func _test_placement() -> void:
	var origin := Vector2(100.0, 100.0)
	_check("放置：贴脚放可以（0 m）", ExplosiveSystemScript.can_place(origin, origin), true)
	_check("放置：上限处可以（15 m）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(15.0, 0.0)), true)
	_check("放置：刚过上限拒绝（15.1 m）",
			ExplosiveSystemScript.can_place(origin, origin + Vector2(15.1, 0.0)), false)
	_check_true("放置：拒绝时给得出原因",
			not ExplosiveSystemScript.placement_error(origin, origin + Vector2(40.0, 0.0)).is_empty())
	_check("放置：可以放时没有原因",
			ExplosiveSystemScript.placement_error(origin, origin + Vector2(5.0, 0.0)), "")
	_check("放置：上限常量 = 15 m", ExplosiveSystemScript.PLACE_MAX_M, 15.0)


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
