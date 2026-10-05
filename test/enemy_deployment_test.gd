@tool
extends EditorScript

## 敌人驻守部署（systems/match/EnemyDeployment.gd）自测：
## 拍板 B 的口径 —— 20 敌 = 5 个节点各 3 名 + 东侧 5 名预备；人少时不留预备队；合计数守恒。

const DeploymentScript := preload("res://systems/match/EnemyDeployment.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_pvp_20()
	_test_pvevp_30()
	_test_small_matches()
	_test_edges()
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
	_check("20 敌 · 预备队 5 人（20 × 0.25）", int(plan["reserve"]), 5)
	_check("20 敌 · 五节点各 3 名", plan["per_node"], [3, 3, 3, 3, 3] as Array[int])
	_check("20 敌 · 总数守恒", int(plan["reserve"]) + _sum(plan["per_node"]), 20)


func _test_pvevp_30() -> void:
	var plan := DeploymentScript.plan(5, 30)
	_check("30 敌 · 预备队 8 人（30 × 0.25 四舍五入）", int(plan["reserve"]), 8)
	_check("30 敌 · 余数落在前几个节点（前重后轻）", plan["per_node"], [5, 5, 4, 4, 4] as Array[int])
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
	_check("只有 1 个节点 · 其余全在节点上", one_node["per_node"], [15] as Array[int])
	_check("只有 1 个节点 · 预备队仍是 5", int(one_node["reserve"]), 5)
	var no_nodes := DeploymentScript.plan(0, 20)
	_check("没有节点 · 全部算预备队（不丢人）", int(no_nodes["reserve"]), 20)


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
