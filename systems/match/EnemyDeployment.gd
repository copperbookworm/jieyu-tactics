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
## 预备队占比（四舍五入，至少 1 人）。
## 2026-10-07 第八十五版（docx 19 ㊹ 第二根杠杆）：**0.25 → 0.35**。
## 为什么加大：实测 19 名队友集团推进时每个节点只有 3 名守军（局部 19:3），
## 单兵数值怎么调都是秒清（见 本项目开发进度.txt 第八十四版）—— 要靠**集中兵力**才能把局部比压回来。
## 20 敌 ⇒ **7 人预备 ＋ 13 人分 5 个节点（3/3/3/2/2）**。
const RESERVE_RATIO := 0.35
## 增援比例：邻近节点按「驻军 × 它」派人（每个节点至少 1 人、且至少留 1 人）
const REINFORCE_RATIO := 0.5


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


## 增援编成（纯算术 · 可无头单测）：某个节点**正在被打**时，从哪儿抽多少人过去。
##
## 规则（每条都有理由）：
##   ① 被攻节点自己不动 —— 它已经在打；
##   ② 驻军 ≤ 1 的节点**不派人** —— 不能让后方变成空门，否则玩家绕后一路白拿；
##   ③ 每个节点派 max(1, floor(驻军 × ratio))，但**至少留 1 人**（同上）；
##   ④ 东侧预备队出一半（floor(预备队 × ratio)，至少 1）；只剩 1 人时全出。
##
## 为什么这是「第二根杠杆」而不是数值：第八十四版实测证明，20 v 20 打不成对抗的瓶颈是
## **局部兵力比**（19 打 3），不是单兵 DPS。把邻近守军与预备队压向交火点，才能把 6:1 压到 2:1。
##
## 返回 {"from_nodes": {节点序号: 人数}, "from_reserve": int, "total": int}
static func reinforcement_plan(per_node: Array, reserve: int, attacked_index: int,
		ratio: float = REINFORCE_RATIO) -> Dictionary:
	var from_nodes := {}
	var total := 0
	for i in per_node.size():
		if i == attacked_index:
			continue
		var garrison := maxi(int(per_node[i]), 0)
		if garrison <= 1:
			continue
		var take := maxi(int(floor(float(garrison) * ratio)), 1)
		take = mini(take, garrison - 1)
		if take <= 0:
			continue
		from_nodes[i] = take
		total += take
	var from_reserve := 0
	if reserve >= 2:
		from_reserve = maxi(int(floor(float(reserve) * ratio)), 1)
	elif reserve == 1:
		from_reserve = 1
	total += from_reserve
	return {"from_nodes": from_nodes, "from_reserve": from_reserve, "total": total}


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
