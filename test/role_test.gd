@tool
extends EditorScript

## 兵种表测试（docx 3.1 兵种表 / 4.11.4 侦察兵标记差异）：表结构、侦察兵 90 s、apply_role、换弹跟随弹匣
## 运行：脚本编辑器打开本文件 → 文件 → 运行

## 2026-10-01 候选 T ②：弹匣 / 备弹的期望值现在从武器表取，而 WeaponTable.gd 刻意无 class_name
## （引用方 preload，见其文件头），所以这里必须自己 preload —— 漏了就是「整脚本编译失败」
const WeaponTableScript := preload("res://systems/weapons/WeaponTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_table()
	_test_scout_mark_duration()
	_test_apply_role()
	_test_reload_follows_role()
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
	_check("兵种表：3 个兵种", RoleTable.count(), 3)
	_check("兵种表：默认兵种名", RoleTable.role_name(RoleTable.Role.RIFLEMAN), "步枪兵")
	_check("兵种表：循环切换回到起点", RoleTable.next_role(RoleTable.Role.MARKSMAN),
			RoleTable.Role.RIFLEMAN)
	_check_true("兵种表：每个兵种都带主武器 + 副武器，且武器 id 在武器表里查得到",
			RoleTable.weapon_ids(RoleTable.Role.SCOUT).size() >= 2
			and not WeaponTableScript.get_weapon(String(
					RoleTable.weapon_ids(RoleTable.Role.SCOUT)[0])).is_empty()
			and not WeaponTableScript.get_weapon(String(
					RoleTable.weapon_ids(RoleTable.Role.MARKSMAN)[0])).is_empty())
	# 2026-10-01 候选 T ②：兵种表原来镜像了 mag_size / reserve，已删——这里钉住「不许再抄一份」
	_check_true("候选 T ②：兵种表不再镜像弹匣 / 备弹（唯一数据源＝武器表）",
			not RoleTable.get_role(RoleTable.Role.SCOUT).has("mag_size")
			and not RoleTable.get_role(RoleTable.Role.SCOUT).has("reserve")
			and not RoleTable.get_role(RoleTable.Role.RIFLEMAN).has("mag_size"))


func _test_scout_mark_duration() -> void:
	_check("侦察兵标记时效 = 90 s（4.11.4）",
			RoleTable.mark_duration(RoleTable.Role.SCOUT), 90.0)
	_check("普通兵种标记时效 = 30 s",
			RoleTable.mark_duration(RoleTable.Role.RIFLEMAN), 30.0)
	_check_true("侦察兵标记是普通的 3 倍",
			RoleTable.mark_duration(RoleTable.Role.SCOUT)
			== RoleTable.mark_duration(RoleTable.Role.RIFLEMAN) * 3.0)


func _test_apply_role() -> void:
	var player := PlayerUnit.new()
	player.apply_role(RoleTable.Role.SCOUT)
	_check("apply_role：兵种 id 生效", player.role_id, RoleTable.Role.SCOUT)
	# 候选 T ②（2026-10-01）：弹匣 / 备弹的唯一数据源是武器表，期望值也从武器表取 ——
	# 哪天兵种表又偷偷抄一份、或者玩家不再读武器表，这里立刻红。
	var main_weapon := String(RoleTable.weapon_ids(RoleTable.Role.SCOUT)[0])
	var weapon_data := WeaponTableScript.get_weapon(main_weapon)
	_check_true("apply_role：侦察兵主武器 %s 在武器表里" % main_weapon,
			not weapon_data.is_empty())
	_check("apply_role：弹匣容量来自武器表（%s）" % main_weapon, player.mag_size,
			int(WeaponTableScript.number(weapon_data, "mag_size", GameConfig.WEAPON_MAG_SIZE)))
	_check("apply_role：开局满弹匣", player.ammo_in_mag, player.mag_size)
	_check("apply_role：备弹来自武器表（%s）" % main_weapon, player.reserve_ammo,
			int(WeaponTableScript.number(weapon_data, "reserve", GameConfig.WEAPON_RESERVE)))
	player.apply_role(RoleTable.Role.MARKSMAN)
	_check("apply_role：再切一次仍满匣", player.ammo_in_mag, player.mag_size)
	player.free()


## 换弹必须跟「实例弹匣」走：原实现写死 GameConfig.WEAPON_MAG_SIZE，换武器就会填错。
## 2026-09-30 修：原来这里写死「精确射手 10 发」——那是第六版手工兵种表的数；第十二版起弹匣容量
## 以官方武器表（data/weapons_data.txt）为准，QBU-191 官方就是 30 发，所以「10 发」的断言必然失败。
## 现改用副武器 M17（17 发 ≠ GameConfig 默认 30 发）来测：既守住「跟实例弹匣走」，
## 又保留「哪天有人再写死常量就会被抓出来」的判别力。
func _test_reload_follows_role() -> void:
	var player := PlayerUnit.new()
	player.apply_weapon("m17")
	_check_true("换弹：测试武器弹匣 %d 发 ≠ GameConfig 默认 %d 发（能抓住写死常量的回归）"
			% [player.mag_size, GameConfig.WEAPON_MAG_SIZE],
			player.mag_size != GameConfig.WEAPON_MAG_SIZE)
	player.ammo_in_mag = 1
	player.reserve_ammo = 50
	player.start_reload()
	_check_true("换弹：残弹时开始换弹", player._reloading)
	player._finish_reload()
	_check("换弹：填到实例弹匣容量 %d 发" % player.mag_size, player.ammo_in_mag, player.mag_size)
	_check("换弹：备弹扣掉实际拿走的 %d 发" % (player.mag_size - 1),
			player.reserve_ammo, 50 - (player.mag_size - 1))
	player.start_reload()
	_check("换弹：满匣不再触发换弹", player._reloading, false)
	player.free()
