extends RefCounted

## 炸药的纯逻辑：射程分档（贴放 / 投掷）+ 抛物线采样 + 放置校验 + 爆炸衰减。不碰场景树，全部可无头单测。
##
## 与间瞄的关系：**共用同一条「弹种口径」的数学核**（IndirectFire.structure_blast_at）——
## 炸药和炮弹一样**不看开口**（2026-10-03 拍板：开口只约束直射弹道），不抄第二份衰减公式。
##
## 2026-10-07 第八十三版（docx ㊺㊻㊼ 三条尾巴全部进第一版）：
##   · ㊻ **投掷**：> PLACE_MAX_M 自动改走抛物线投掷（飞行 + 落点预警），上限 THROW_MAX_M。
##     「投掷」不是新按键，是同一个按键按距离自动分档（使用者的选择题选 A）。
##   · ㊼ **安放读条**：贴放要读完 PLACE_CAST_S 才落地；读条中移动 / 开火 / 受击 ⇒ 打断且不消耗。
##     注：㊻ 的选项文案里写的是「瞬时贴放」，被本条覆盖 —— 两条拍板冲突时以「安放倒计时」为准。
##
## 刻意不写 class_name：引用方 preload。

const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const ChargeTableScript := preload("res://data/config/ChargeTable.gd")

## 贴放距离：可以贴脚放（0），最远 15 m。**这也是投掷的下限**（分档见 action_at）。
const PLACE_MIN_M := 0.0
const PLACE_MAX_M := 15.0
## 投掷上限（docx ㊻）：再远就够不着 —— 不是沉默失败，会把原因返给玩家看。
const THROW_MIN_M := 15.0
const THROW_MAX_M := 35.0
## 安放读条（docx ㊼）：读条走完才落地；读条中被打断不消耗发数。
const PLACE_CAST_S := 1.5
## 打断的位移容差：读条起点挪出这么多米才算「移动了」（操作抖动不算）
const CAST_MOVE_TOLERANCE_M := 0.75
## 投掷飞行时间 T = BASE + PER_M × 距离（15 m → 0.95 s、35 m → 1.55 s）
const THROW_FLIGHT_BASE_S := 0.5
const THROW_FLIGHT_PER_M := 0.03
## 抛物线在**屏幕上**抬多少像素 —— 纯表现层参数，与米制解耦（俯视 2D 没有真实高度轴）
const THROW_ARC_MIN_PX := 12.0
const THROW_ARC_MAX_PX := 40.0
const THROW_ARC_PX_PER_M := 1.2


## 这一下走哪条路："" = 够不着 / "place" = 贴放 / "throw" = 投掷
static func action_at(from: Vector2, to: Vector2) -> String:
	var distance := from.distance_to(to)
	if distance > THROW_MAX_M:
		return ""
	return "place" if distance <= PLACE_MAX_M else "throw"


## 够不着时给玩家看的原因（能到达就返回空串）——调用方直接 show_hint
static func range_error(from: Vector2, to: Vector2) -> String:
	var distance := from.distance_to(to)
	if distance > THROW_MAX_M:
		return "太远了：炸药贴放 ≤%.0f m / 投掷 ≤%.0f m（现在 %.0f m）" % [
				PLACE_MAX_M, THROW_MAX_M, distance]
	return ""


## 兼容 2026-10-04 的旧入口名：语义已随 ㊻ 变化 ——「>15 m」不再算错，改走投掷；
## 只有 >35 m 才是真失败。调用方（ExplosiveController / 测试）一个都不用改名。
static func placement_error(from: Vector2, to: Vector2) -> String:
	return range_error(from, to)


static func can_place(from: Vector2, to: Vector2) -> bool:
	return range_error(from, to).is_empty()


static func is_throw(from: Vector2, to: Vector2) -> bool:
	return action_at(from, to) == "throw"


## 投掷飞行时间（s）：距离越远飞得越久
static func throw_flight_time(distance: float) -> float:
	return THROW_FLIGHT_BASE_S + THROW_FLIGHT_PER_M * maxf(distance, 0.0)


## 抛物线采样 —— **地面平面**上的位置（线性插值）；高度轴由 throw_lift_px 单独表达。
static func throw_position_at(from: Vector2, to: Vector2, elapsed: float, flight_s: float) -> Vector2:
	if flight_s <= 0.0:
		return to
	var u := clampf(elapsed / flight_s, 0.0, 1.0)
	return from.lerp(to, u)


## 抛物线抬升（屏幕像素）：4u(1−u) ⇒ 两端 0、中点最高；峰值随距离增长但有上下限。
static func throw_lift_px(distance: float, elapsed: float, flight_s: float) -> float:
	if flight_s <= 0.0:
		return 0.0
	var u := clampf(elapsed / flight_s, 0.0, 1.0)
	var peak := clampf(distance * THROW_ARC_PX_PER_M, THROW_ARC_MIN_PX, THROW_ARC_MAX_PX)
	return peak * 4.0 * u * (1.0 - u)


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
