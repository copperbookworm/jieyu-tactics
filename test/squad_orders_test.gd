@tool
extends EditorScript

## 编成命令层（docx 4.10.8）：主线下发给小队长，小队长按模板派发小队内子任务。

const OrdersScript := preload("res://systems/match/SquadOrders.gd")
const OrgScript := preload("res://systems/match/Organization.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_pvp_dispatch()
	_test_pvevp_no_squad()
	_test_zone_wrap_and_names()
	_test_empty()
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


func _test_pvp_dispatch() -> void:
	var org := OrgScript.of_friendly_total(20)      # 5 组 / 2 小队
	var d := OrdersScript.issue(org, 3, 0)
	_check("PVP：派发 5 条组任务", d["items"].size(), 5)
	_check("PVP：主线收件人是玩家（他就是 0 号小队长）", d["recipient"], 0)
	_check("PVP：有小队 ⇒ 文案认「小队长」", d["has_squad"], true)
	_check("PVP：玩家在第 0 组", d["my_group"], 0)
	_check("PVP：0 组拿主线那个节点「占领 A」", d["my_order"]["text"], "占领 A")
	_check("PVP：1 组「守住 B」", d["orders"][1]["text"], "守住 B")
	_check("PVP：2 组「侦察 C」", d["orders"][2]["text"], "侦察 C")
	_check("PVP：3 组节点不够就循环回 A ⇒ 侦察 A", d["orders"][3]["text"], "侦察 A")
	_check("PVP：一句话文案", OrdersScript.summary_text(d), "小队长：占领 A")


func _test_pvevp_no_squad() -> void:
	var org := OrgScript.of_friendly_total(4)       # 1 组 / 0 小队
	var d := OrdersScript.issue(org, 3, 0)
	_check("PVEVP：4P 只有 1 个组 ⇒ 1 条组任务", d["items"].size(), 1)
	_check("PVEVP：没有小队", d["has_squad"], false)
	_check("PVEVP：主线仍发玩家（㊸ 的工程默认 = 候选 A）", d["recipient"], 0)
	_check("PVEVP：文案区分「组长」而不是小队长", OrdersScript.summary_text(d), "组长（本局无小队）：占领 A")


func _test_zone_wrap_and_names() -> void:
	_check("节点名 A", OrdersScript.zone_name(0), "A")
	_check("节点名 C", OrdersScript.zone_name(2), "C")
	_check("节点名越界给坐标名", OrdersScript.zone_name(30), "节点 31")
	_check("负数保护", OrdersScript.zone_name(-1), "—")
	var org := OrgScript.of_friendly_total(20)
	var d := OrdersScript.issue(org, 3, 2)          # 主线指向 C
	_check("主线偏移：0 组占领 C", d["orders"][0]["text"], "占领 C")
	_check("主线偏移：1 组守住 A（循环）", d["orders"][1]["text"], "守住 A")


func _test_empty() -> void:
	var d := OrdersScript.issue({}, 3, 0)
	_check("没有编成时不崩、也没有任务", d["items"].size(), 0)
	_check("没有编成时文案兜底", OrdersScript.summary_text(d), "无组任务")
	var no_zone := OrdersScript.issue(OrgScript.of_friendly_total(8), 0, 0)
	_check("没有占领节点时也不崩（全指向 0）", no_zone["items"].size(), 2)
