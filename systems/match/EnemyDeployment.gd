extends RefCounted

## 敌人驻守部署（2026-10-05 · 第六十三版 · 使用者拍板 **B**：按 RAAS 节点 + 东侧出生区分组驻守）
##
## 为什么改：原来敌人是「出生锚点前方 45~75 m」——出生 30 秒就能交火，但地图的五个节点形同虚设，
## 玩家一路推过去、后面全是空的；而且 20 v 20 时 19 名队友 ~10 s 就把 20 个敌人打光（第十九章 ㊹）。
## 拍板 B：敌人分驻 5 个节点 + 东侧出生区留一支预备队（玩家拿下节点后预备队向前支援）。
##
## 这个模块只管**怎么分**（纯算术 · 可无头单测）；坐标换算、实例化、支援指令都在 WorldSetup。

## 少于这个人数就不留预备队：2 个敌人的测试局也该能立刻碰上，而不是全堆在东侧发呆。
const MIN_FOR_RESERVE := 6
## 预备队占比（四舍五入，至少 1 人）。20 敌 ⇒ 5 人预备 ＋ 15 人分 5 个节点各 3 名。
const RESERVE_RATIO := 0.25


## 返回 {"per_node": Array[int], "reserve": int, "total": int}
## 规则：① 兵力 ≤ MIN_FOR_RESERVE 时不留预备队；② 否则预备队取 RESERVE_RATIO；
##       ③ 野战兵力按节点**轮转**分配 —— 余数落在前几个节点（前重后轻，第一版更容易打进去）。
static func plan(node_count: int, enemy_count: int) -> Dictionary:
	var nodes := maxi(node_count, 0)
	var total := maxi(enemy_count, 0)
	var per_node: Array[int] = []
	for i in nodes:
		per_node.append(0)
	if nodes == 0:
		return {"per_node": per_node, "reserve": total, "total": total}
	var reserve := 0
	if total >= MIN_FOR_RESERVE:
		reserve = maxi(int(round(float(total) * RESERVE_RATIO)), 1)
	var field := total - reserve
	for i in field:
		per_node[i % nodes] += 1
	return {"per_node": per_node, "reserve": reserve, "total": total}


## 第 index 个节点上的第 slot 名敌人的落点偏移（黄金角散开 + 一圈圈往外，避免叠在一起）
static func node_slot_offset(slot: int) -> Vector2:
	if slot <= 0:
		return Vector2(8.0, 0.0)
	var angle := float(slot) * 2.39996323
	var radius := 8.0 + 3.0 * float(slot)
	return Vector2(cos(angle), sin(angle)) * radius


## 东侧预备队的第 slot 个落点偏移（同上，半径更小 —— 预备队是集结待命，不是散兵）
static func reserve_slot_offset(slot: int) -> Vector2:
	if slot <= 0:
		return Vector2.ZERO
	var angle := float(slot) * 2.39996323
	var radius := 6.0 + 2.5 * float(slot)
	return Vector2(cos(angle), sin(angle)) * radius
