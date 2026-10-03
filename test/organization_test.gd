@tool
extends EditorScript

## 编成（docx 4.10.8 / 5.8 · 2026-10-03 使用者拍板）：组 4 人 · 一小队至少 2 组。

const OrgScript := preload("res://systems/match/Organization.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_rules()
	_test_group_splitting()
	_test_squad_splitting()
	_test_pvp_20()
	_test_pvevp_4()
	_test_mode_wiring()
	_test_quest_recipient()
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


func _test_rules() -> void:
	_check("4.10.8：组 = 4 人", OrgScript.group_size(), 4)
	_check("4.10.8：一小队至少 2 组", OrgScript.min_groups_per_squad(), 2)
	_check("口径单一来源：组的规模读 ModeTable，不写第二份", OrgScript.group_size(),
			ModeTableScript.GROUP_SIZE)


func _test_group_splitting() -> void:
	_check("0 人 → 0 组", OrgScript.build_groups(0), [])
	_check("4 人 → 1 组", OrgScript.build_groups(4).size(), 1)
	_check("5 人 → 2 组（最后一组不满）", OrgScript.build_groups(5).size(), 2)
	_check("20 人 → 5 组", OrgScript.build_groups(20).size(), 5)
	_check("最后一组装的是余数", OrgScript.build_groups(5)[1], [4])


func _test_squad_splitting() -> void:
	_check("1 组 → 编不成小队", OrgScript.build_squads(1), [])
	_check("2 组 → 1 队", OrgScript.build_squads(2), [2])
	_check("3 组 → 1 队（余数并入）", OrgScript.build_squads(3), [3])
	_check("4 组 → 2 队", OrgScript.build_squads(4), [2, 2])
	_check("5 组 → 2 队（2 + 3，官方算术）", OrgScript.build_squads(5), [2, 3])
	_check("7 组 → 3 队（2 + 2 + 3）", OrgScript.build_squads(7), [2, 2, 3])
	var total := 0
	for s in OrgScript.build_squads(9):
		_check_true("每队至少 %d 组" % OrgScript.min_groups_per_squad(),
				int(s) >= OrgScript.min_groups_per_squad())
		total += int(s)
	_check("切分不丢组（9 组切完仍是 9）", total, 9)


## 20 人 = 5 组 = 2 个小队（2 组 + 3 组）；玩家（索引 0）是组长也是小队长
func _test_pvp_20() -> void:
	var d := OrgScript.of_friendly_total(20)
	_check("PVP：20 人 = 5 组", d["group_count"], 5)
	_check("PVP：= 2 个小队", d["squad_count"], 2)
	_check("PVP：小队规模是 2 + 3", d["squads"], [[0, 1], [2, 3, 4]])
	_check("PVP：没有独立组", d["standalone_groups"], 0)
	_check("PVP：小队长 2 名（每队第一个组的组长）", d["squad_leaders"].size(), 2)
	_check("PVP：队长是名册里的首位", d["squad_leaders"], [0, 8])
	var me: Dictionary = d["member_of"][0]
	_check("PVP：玩家在第 0 组", me["group"], 0)
	_check("PVP：玩家在第 0 小队", me["squad"], 0)
	_check_true("PVP：玩家是组长", me["is_group_leader"])
	_check_true("PVP：玩家是小队长（4.10.8 主线发给他）", me["is_squad_leader"])
	_check("PVP：一句话文案", OrgScript.summary_text(d), "2 小队 / 5 组（组 4 人）")


## PVEVP 4P = 1 个组，不构成小队（docx 5.8 写明、㊸ 待拍板由谁收主线）
func _test_pvevp_4() -> void:
	var d := OrgScript.of_friendly_total(4)
	_check("PVEVP：4 人 = 1 组", d["group_count"], 1)
	_check("PVEVP：= 0 个小队", d["squad_count"], 0)
	_check("PVEVP：这 1 组是独立组", d["standalone_groups"], 1)
	_check("PVEVP：没有小队长", d["squad_leaders"], [])
	_check("PVEVP：玩家仍是组长", d["member_of"][0]["is_group_leader"], true)
	_check("PVEVP：一句话文案", OrgScript.summary_text(d), "1 组（不足 2 组，不构成小队）")


func _test_mode_wiring() -> void:
	_check("PVP 竞技（1 + 19 = 20 人）→ 5 组 / 2 小队",
			[OrgScript.of_mode(ModeTableScript.Mode.PVP_RANKED)["group_count"],
			OrgScript.of_mode(ModeTableScript.Mode.PVP_RANKED)["squad_count"]], [5, 2])
	_check("PVEVP（1 + 3 = 4 人）→ 1 组 / 0 小队",
			[OrgScript.of_mode(ModeTableScript.Mode.PVEVP)["group_count"],
			OrgScript.of_mode(ModeTableScript.Mode.PVEVP)["squad_count"]], [1, 0])
	_check("兵棋（人数未定）按 GameConfig.ALLY_SQUAD_SIZE 兜底 → 1 组",
			OrgScript.of_mode(ModeTableScript.Mode.WARGAME)["group_count"], 1)


func _test_quest_recipient() -> void:
	var pvp := OrgScript.of_friendly_total(20)
	var pvevp := OrgScript.of_friendly_total(4)
	_check("主线收件人＝玩家（PVP 里他是小队长）", OrgScript.main_quest_recipient(pvp), 0)
	_check("主线收件人＝玩家（PVEVP 没有小队，㊸ 的工程处置：直接发玩家）",
			OrgScript.main_quest_recipient(pvevp), 0)
	_check_true("PVP 有小队", OrgScript.has_squad(pvp))
	_check_true("PVEVP 没有小队（这个区别就是 ㊸ 要拍的东西）", not OrgScript.has_squad(pvevp))
