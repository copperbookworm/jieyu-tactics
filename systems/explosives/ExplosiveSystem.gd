extends RefCounted

## 炸药的纯逻辑：放置校验 + 爆炸衰减。不碰场景树，全部可无头单测。
##
## 与间瞄的关系：**共用同一条「弹种口径」的数学核**（IndirectFire.structure_blast_at）——
## 炸药和炮弹一样**不看开口**（2026-10-03 拍板：开口只约束直射弹道），不抄第二份衰减公式。
##
## 刻意不写 class_name：引用方 preload。

const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const ChargeTableScript := preload("res://data/config/ChargeTable.gd")

## 放置距离：可以贴脚放（0），最远 15 m。
## 为什么不是「扔出去」：工程兵是**贴上去放**的，15 m 已经是隔着一间屋子；
## 再远就变成手雷，与 4.12 的烟雾弹 / 后续投掷物重复。
const PLACE_MIN_M := 0.0
const PLACE_MAX_M := 15.0


## 可以放就返回空串；否则返回给玩家看的原因（调用方直接 show_hint）
static func placement_error(from: Vector2, to: Vector2) -> String:
	var distance := from.distance_to(to)
	if distance < PLACE_MIN_M:
		return "落点不合法"
	if distance > PLACE_MAX_M:
		return "太远了：炸药要贴上去放（上限 %.0f m，现在 %.0f m）" % [PLACE_MAX_M, distance]
	return ""


static func can_place(from: Vector2, to: Vector2) -> bool:
	return placement_error(from, to).is_empty()


## 对人：爆心给满，半径**内缘**趋近 unit_min_damage，到半径处就是 0（与间瞄 blast_damage_at 同形状：区间 [0, radius)）
static func unit_blast_at(distance: float, charge_id: String) -> float:
	var radius := ChargeTableScript.radius_m(charge_id)
	if radius <= 0.0 or distance >= radius:
		return 0.0
	return lerpf(ChargeTableScript.unit_damage(charge_id),
			ChargeTableScript.unit_min_damage(charge_id),
			clampf(distance / radius, 0.0, 1.0))


## 对建筑 / 工事：走间瞄那条「弹种口径」内核（爆心满、半径处 BLAST_STRUCTURE_FALLOFF 收尾）
static func structure_blast_at(distance: float, charge_id: String) -> float:
	return IndirectFireScript.structure_blast_at(distance,
			ChargeTableScript.structure_damage(charge_id), ChargeTableScript.radius_m(charge_id))
