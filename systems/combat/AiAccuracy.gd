extends RefCounted

## 双方 AI 的射击精度（2026-10-07 第八十四版 · docx 19 ㊹「20 v 20 压队友强度」）
##
## 为什么单开一个纯模块：配平前**队友零散布（必中）、敌人有 3 MOA** —— 两个阵营两套口径，
## 这是「20 v 20 一边倒」里最大的一条不对称。把公式收成一处、双方 preload 同一个函数之后，
## 「双方共用同一条精度基线」就不再是注释里的承诺，而是能被单测钉住的事实。
##
## 抑制散布**不在这里**：那是 SuppressionSystem 的事，且第一版只有敌人有压制状态。
##
## 刻意不写 class_name：引用方 preload（与其它 systems 模块一致）。

const GameConfigScript := preload("res://data/config/GameConfig.gd")


## 基础散布的度数（AI_BASE_MOA 是角分，1° = 60′）
static func base_spread_deg() -> float:
	return GameConfigScript.AI_BASE_MOA / 60.0


## 把方向按 level（−1..1）偏转一个基础散布：level = 0 不偏，±1 偏到最大。
## 退化输入（零向量 / 散布为 0）原样返回，绝不产生 NaN。
static func apply_base_spread(direction: Vector2, level: float) -> Vector2:
	var spread_deg := base_spread_deg()
	if spread_deg <= 0.001 or direction.length_squared() < 0.000001:
		return direction
	return direction.rotated(deg_to_rad(clampf(level, -1.0, 1.0) * spread_deg))


## 最大横向偏差（m）：给「这个散布在某距离上到底打不打得中」一个可算的数。
## 命中判定半径是 ENEMY_HIT_RADIUS（0.25 m），所以偏差超过它就真的会 miss。
static func max_lateral_m(distance: float) -> float:
	return distance * tan(deg_to_rad(base_spread_deg()))
