class_name SuppressionSystem
extends RefCounted

## 压制机制（docx 7.3）：弹药从身边飞过或附近撞击才积累压制值
## 这里只放「一发子弹离目标多近」的纯函数，方便单测；压制值的累积/衰减在 Player 里
## 口径：正对命中 → 1.0（满）；擦过 → 0 ~ 1 之间按贴近程度打折；超出半径或背向 → 0

## 返回 0..1 的近失因子：弹道（origin + direction × t）到 target 的最近距离
## 越贴近越大；子弹背向目标（t < 0）不算近失，避免背后开枪把自己压住
static func near_miss_factor(origin: Vector2, direction: Vector2, target: Vector2,
		radius: float = GameConfig.SUPPRESSION_NEAR_MISS_RADIUS) -> float:
	if radius <= 0.0:
		return 0.0
	var dir := direction.normalized()
	if dir.length_squared() < 0.5:
		return 0.0
	var to_target := target - origin
	var along := to_target.dot(dir)
	if along <= 0.0:
		return 0.0
	var closest := origin + dir * along
	var miss := closest.distance_to(target)
	if miss >= radius:
		return 0.0
	return clampf(1.0 - miss / radius, 0.0, 1.0)


## 单发子弹造成的压制增量（近失因子 × 每发上限）
static func per_shot_amount(factor: float,
		per_shot: float = GameConfig.SUPPRESSION_PER_NEAR_MISS) -> float:
	return clampf(factor, 0.0, 1.0) * per_shot


## 衰减一步（供 Player 每帧调用）
static func decayed(value: float, delta: float,
		decay_per_second: float = GameConfig.SUPPRESSION_DECAY) -> float:
	return maxf(value - decay_per_second * delta, 0.0)


## 当前压制对散布的倍率：1.0（无压制）→ 1 + SCALE（满压制）
static func spread_multiplier(suppression: float) -> float:
	return 1.0 + GameConfig.SUPPRESSION_SPREAD_SCALE * clampf(suppression, 0.0, 1.0)


## 被压制方的还击散布（度）：0 → 0；满压制 → max_deg。
## 敌人原本是零散布直射，压制后必须让它的命中率明显掉下来（7.3 反向 + 4.12.5 的口径）
static func return_fire_spread_deg(suppression: float,
		max_deg: float = GameConfig.SUPPRESSION_AI_SPREAD_DEG) -> float:
	return max_deg * clampf(suppression, 0.0, 1.0)


## 压制够重时是否停火（「不敢露头」）：阈值见 SUPPRESSION_AI_HOLD_FIRE
static func holds_fire(suppression: float) -> bool:
	return suppression >= GameConfig.SUPPRESSION_AI_HOLD_FIRE
