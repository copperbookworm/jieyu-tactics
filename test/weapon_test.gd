@tool
extends EditorScript

## 武器系统测试（docx 7.5 CSV 表 + C3 切枪时间基线）：表加载、apply_weapon、
## 兵种绑定、切枪期间禁止开火、切枪后数值随之变化
## 运行：脚本编辑器打开本文件 → 文件 → 运行

const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table_loaded()
	_test_apply_weapon()
	_test_role_binding()
	_test_switch_blocks_fire()
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


func _test_table_loaded() -> void:
	var table := WeaponTableScript.load_table()
	# 候选 R（2026-10-02）：表已扩到官方全量 25 把
	_check("武器表：25 把（官方全量）", table.size(), 25)
	var qbz: Dictionary = WeaponTableScript.get_weapon("qbz191")
	_check("武器表：QBZ-191 射速 750", WeaponTableScript.number(qbz, "rpm", 0.0), 750.0)
	_check("武器表：QBZ-191 MOA 3", WeaponTableScript.number(qbz, "moa", 0.0), 3.0)
	_check("武器表：QBZ-191 游戏射程 400",
			WeaponTableScript.number(qbz, "game_range", 0.0), 400.0)
	_check("武器表：QBZ-191 基础伤害 62",
			WeaponTableScript.number(qbz, "dmg_base", 0.0), 62.0)
	_check("武器表：切枪 1.04 s（C3 基线）",
			WeaponTableScript.number(qbz, "switch_time", 0.0), 1.04)
	_check_true("武器表：不存在的枪返回 false", not WeaponTableScript.has_weapon("nope"))


func _test_apply_weapon() -> void:
	var player := PlayerUnit.new()
	player.apply_weapon("qbu191")
	_check("装备：武器名来自表", player.weapon_name(), "5.8mm 精确射手步枪")
	_check("装备：弹匣 30", player.mag_size, 30)
	_check("装备：开局满匣", player.ammo_in_mag, player.mag_size)
	_check("装备：射速来自表（220）", player.weapon_rpm(), 220.0)
	_check("装备：MOA 来自表（1.5）", player.weapon_moa(), 1.5)
	_check("装备：射程来自表（500）", player.weapon_range(), 500.0)
	_check("装备：散布跟着 MOA 走（1.5 × 站定）", player.effective_spread_moa(),
			1.5 * GameConfig.WEAPON_SPREAD_STILL)
	player.free()


func _test_role_binding() -> void:
	var player := PlayerUnit.new()
	player.apply_role(RoleTable.Role.RIFLEMAN)
	_check("兵种：步枪兵主武器", player.weapon_name(), "5.8mm 制式步枪 A")
	_check("兵种：携带 2 把（主武器 + 副武器）", player.weapons.size(), 2)
	player.apply_role(RoleTable.Role.MARKSMAN)
	_check("兵种：精确射手主武器", player.weapon_name(), "5.8mm 精确射手步枪")
	player.free()


## C3：切枪 1.04 s，期间不能开火；到点才真正换过去（弹匣也跟过去）
func _test_switch_blocks_fire() -> void:
	var player := PlayerUnit.new()
	player.apply_role(RoleTable.Role.RIFLEMAN)
	_check_true("换枪前：能开火", player.can_fire())
	player.switch_weapon()
	_check_true("换枪中：不能开火", not player.can_fire())
	_check_true("换枪中：处于换枪状态", player.is_switching_weapon())
	_check("换枪中：手里还是旧枪", player.weapon_name(), "5.8mm 制式步枪 A")
	player.tick_timers(0.5)
	_check_true("0.5 s 后仍在换枪（要 1.04 s）", player.is_switching_weapon())
	player.tick_timers(0.6)
	_check_true("1.1 s 后换枪完成", not player.is_switching_weapon())
	_check("换枪完成：换成副武器", player.weapon_name(), "9mm 手枪")
	_check("换枪完成：弹匣跟随新枪（17 发）", player.mag_size, 17)
	_check_true("换枪完成：恢复开火", player.can_fire())
	player.free()
