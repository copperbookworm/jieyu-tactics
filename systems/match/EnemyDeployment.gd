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


## 防御环（2026-10-07 第八十九版 · 真机验收后 · 使用者选择题 A「AI 分批推进」）
##
## 为什么必须把「驻守」和「占点」分开：驻军原先全部落在节点中心 8~14 m，
## 而 CAPTURE_ZONE_RADIUS = 15 m ⇒ 三个白旗点**同时**被判「敌方在圈内」，
## 首占 15 s/点、进局 ~20 s 就「全部节点失守」结算（真机实测，玩家刚进局就面对失败）。
##
## 现在：同一时刻**只有一个节点**的守军进圈去真占点（assault_split），其余留在防御环上 ——
## 他们照样守着节点、玩家进圈就会被交火，但不会替敌人把点自动占下来。
##
## ⚠ 环半径为什么定 32 m：SpawnPicker.NUDGE_RADIUS = 15 m，落地前还会找平地微调，
##    最坏情况会朝圆心拉近 15 m ⇒ 32 − 15 = 17 m 仍在 15 m 的占领圈外（留 2 m 余量）。
const DEFENSE_RING_BASE := 32.0
const DEFENSE_RING_STEP := 3.0
## 同一时刻进圈「真占点」的人数上限（按进攻节点算）
const ASSAULT_SIZE := 3


## 防御环落点：节点中心外的第 slot 个位置（黄金角散开，只守不占）
static func defense_slot_offset(slot: int) -> Vector2:
	var angle := float(slot) * 2.39996323
	var radius := DEFENSE_RING_BASE + DEFENSE_RING_STEP * float(slot)
	return Vector2(cos(angle), sin(angle)) * radius


## 分批推进的编成（纯算术）：每个节点有几个守军进占领圈。
## 只有 assault_index 那个节点会派人进圈，其余一律 0（留在防御环）。返回 Array[int]。
static func assault_split(per_node: Array, assault_index: int,
		take: int = ASSAULT_SIZE) -> Array[int]:
	var inside: Array[int] = []
	for i in per_node.size():
		inside.append(0)
	if assault_index >= 0 and assault_index < per_node.size():
		var garrison := maxi(int(per_node[assault_index]), 0)
		inside[assault_index] = mini(maxi(take, 0), garrison)
	return inside


## 进攻次序（纯算术）：从 from_point 出发**由近到远**的节点序号。
## 敌人从自己的东侧出生区推进 ⇒ 离它最近的节点是它第一个要拿的点，拿下才轮到下一个。
## limit > 0 时只考虑前 limit 个节点 —— 地图的 RAAS 推进链有 5 个节点，但**可占领的白旗点只有前 3 个**；
## 让敌人去「打」一个占不下来的节点是白费兵力（2026-10-07 真机日志实测：把下一梯队派去了节点 5）。
static func advance_order(node_positions: Array, from_point: Vector2,
		limit: int = -1) -> Array[int]:
	var pairs: Array = []
	var count := node_positions.size()
	if limit > 0:
		count = mini(limit, count)
	for i in count:
		var p: Vector2 = node_positions[i]
		pairs.append({"i": i, "d": from_point.distance_to(p)})
	pairs.sort_custom(func(a, b): return float(a["d"]) < float(b["d"]))
	var order: Array[int] = []
	for item in pairs:
		order.append(int((item as Dictionary)["i"]))
	return order


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
