@tool
extends EditorScript

## 敌人驻守部署（systems/match/EnemyDeployment.gd）自测：
## 拍板 B 的口径 —— 20 敌 = 5 个节点 3/3/3/2/2 + 东侧 7 名预备；人少时不留预备队；合计数守恒。
## 2026-10-07 第八十五版（docx 19 ㊹ 第二根杠杆）：预备队占比 0.25 → 0.35，并新增**受攻增援**编成。

const DeploymentScript := preload("res://systems/match/EnemyDeployment.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_pvp_20()
	_test_pvevp_30()
	_test_small_matches()
	_test_edges()
	_test_reinforcement()
	_test_offsets()
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


func _test_pvp_20() -> void:
	var plan := DeploymentScript.plan(5, 20)
	_check("20 敌 · 预备队 7 人（20 × 0.35，第八十五版加大）", int(plan["reserve"]), 7)
	_check("20 敌 · 五节点 3/3/3/2/2（前重后轻）", plan["per_node"], [3, 3, 3, 2, 2] as Array[int])
	_check("20 敌 · 总数守恒", int(plan["reserve"]) + _sum(plan["per_node"]), 20)


func _test_pvevp_30() -> void:
	var plan := DeploymentScript.plan(5, 30)
	_check("30 敌 · 预备队 11 人（30 × 0.35 四舍五入）", int(plan["reserve"]), 11)
	_check("30 敌 · 余数落在前几个节点（前重后轻）", plan["per_node"], [4, 4, 4, 4, 3] as Array[int])
	_check("30 敌 · 总数守恒", int(plan["reserve"]) + _sum(plan["per_node"]), 30)


func _test_small_matches() -> void:
	var two := DeploymentScript.plan(5, 2)
	_check("2 敌 · 不留预备队（人少时全铺前几个节点）", int(two["reserve"]), 0)
	_check("2 敌 · 铺在 N1 / N2", two["per_node"], [1, 1, 0, 0, 0] as Array[int])
	var five := DeploymentScript.plan(5, 5)
	_check("5 敌 · 仍在阈值以下，不留预备队", int(five["reserve"]), 0)
	_check("5 敌 · 五节点各 1 名", five["per_node"], [1, 1, 1, 1, 1] as Array[int])
	var six := DeploymentScript.plan(5, 6)
	_check("6 敌（刚够阈值）· 预备队 2 人", int(six["reserve"]), 2)


func _test_edges() -> void:
	var none := DeploymentScript.plan(5, 0)
	_check("0 敌 · 预备队 0", int(none["reserve"]), 0)
	_check("0 敌 · 节点全 0", _sum(none["per_node"]), 0)
	var one_node := DeploymentScript.plan(1, 20)
	_check("只有 1 个节点 · 其余全在节点上", one_node["per_node"], [13] as Array[int])
	_check("只有 1 个节点 · 预备队仍是 7", int(one_node["reserve"]), 7)
	var no_nodes := DeploymentScript.plan(0, 20)
	_check("没有节点 · 全部算预备队（不丢人）", int(no_nodes["reserve"]), 20)


## 受攻增援编成（2026-10-07 第八十五版 · docx 19 ㊹ 第二根杠杆）
## 目的：把「19 名队友打 3 名守军」的局部 6:1 压到 ~2:1 —— 靠集中兵力，不靠改单兵数值。
func _test_reinforcement() -> void:
	var per_node := [3, 3, 3, 2, 2]
	var plan := DeploymentScript.reinforcement_plan(per_node, 7, 0)
	var from_nodes: Dictionary = plan["from_nodes"]
	_check("增援：被攻节点自己不动", from_nodes.has(0), false)
	_check("增援：邻近三个 3 人节点各派 1 人", [int(from_nodes.get(1, 0)),
			int(from_nodes.get(2, 0)), int(from_nodes.get(3, 0)), int(from_nodes.get(4, 0))],
			[1, 1, 1, 1])
	_check("增援：预备队出 3 人（7 × 0.5 向下取整）", int(plan["from_reserve"]), 3)
	_check("增援：合计 7 人（4 邻近 + 3 预备）", int(plan["total"]), 7)
	_check("增援：被攻节点 3 + 增援 7 = 10 人应战（对 19 名队友 ≈ 2:1）",
			3 + int(plan["total"]), 10)

	# 换一个被攻节点：结论必须跟着换（不能写死节点 0）
	var other := DeploymentScript.reinforcement_plan(per_node, 7, 3)
	_check("增援：换被攻节点 ⇒ 该节点不派人", (other["from_nodes"] as Dictionary).has(3), false)
	_check("增援：换被攻节点后合计仍 7 人", int(other["total"]), 7)

	# 后方不能被抽空：驻军 ≤ 1 的节点一个人都不派
	var thin := DeploymentScript.reinforcement_plan([3, 1, 1, 1, 1], 0, 0)
	_check("增援：驻军 ≤ 1 的节点不派人（后方不留空门）",
			(thin["from_nodes"] as Dictionary).size(), 0)
	_check("增援：没人可派时合计 0", int(thin["total"]), 0)
	_check("增援：驻军 2 的节点只派 1 人（至少留 1）",
			int((DeploymentScript.reinforcement_plan([3, 2], 0, 0)["from_nodes"] as Dictionary).get(1, 0)), 1)
	_check("增援：驻军 10 的节点派 5 人（× 0.5）",
			int((DeploymentScript.reinforcement_plan([3, 10], 0, 0)["from_nodes"] as Dictionary).get(1, 0)), 5)

	# 预备队边界
	_check("增援：预备队 1 人时全出", int(DeploymentScript.reinforcement_plan([3], 1, 0)["from_reserve"]), 1)
	_check("增援：预备队 0 人时不派", int(DeploymentScript.reinforcement_plan([3], 0, 0)["from_reserve"]), 0)
	_check("增援：没有节点时只出预备队",
			int(DeploymentScript.reinforcement_plan([], 10, 0)["total"]), 5)
	_check("增援：比例可覆盖（0.5 → 1.0 时全出，但被攻节点仍不动）",
			int((DeploymentScript.reinforcement_plan([3, 3], 0, 0, 1.0)["from_nodes"] as Dictionary).get(1, 0)), 2)


func _test_offsets() -> void:
	var first := DeploymentScript.node_slot_offset(0)
	_check("节点首位固定落在 (+8, 0)（确定性）", first, Vector2(8, 0))
	var apart := true
	for slot in range(1, 8):
		if DeploymentScript.node_slot_offset(slot).distance_to(
				DeploymentScript.node_slot_offset(slot - 1)) < 3.0:
			apart = false
	_check("相邻 slot 不叠在一起（间距 ≥ 3 m）", apart, true)
	_check("预备队首位落在中心点", DeploymentScript.reserve_slot_offset(0), Vector2.ZERO)


func _sum(values: Array) -> int:
	var total := 0
	for value in values:
		total += int(value)
	return total
