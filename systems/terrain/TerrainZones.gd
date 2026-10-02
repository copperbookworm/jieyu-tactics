extends RefCounted

## 环境互动区的纯查询层（docx 4.17，候选 O 第四轮）
##
## 为什么单独一层：区域节点要进场景树才能做组查询，而「某点的移速倍率 / 隐蔽度是多少」是可单测的
## 纯规则 —— 规则放这里，Player 与 Enemy 都调它，测试也直接喂一个 Array 进来。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）


## 该点的移速倍率：取所有覆盖区域里**最慢**的那个（泥雪交界处按最慢的算，不叠加）
static func speed_scale_at(zones: Array, point: Vector2) -> float:
	var scale := 1.0
	for zone in zones:
		if zone == null or not zone.has_method("covers") or not zone.covers(point):
			continue
		scale = minf(scale, float(zone.speed_scale()))
	return scale


## 该点的隐蔽度：取所有覆盖区域里**最强**的那个（草叠草不叠加），并封顶 TERRAIN_CONCEAL_MAX
## （别让敌人彻底失明——隐蔽的语义是「更难被发现」，不是隐身）
static func concealment_at(zones: Array, point: Vector2, prone: bool) -> float:
	var value := 0.0
	for zone in zones:
		if zone == null or not zone.has_method("covers") or not zone.covers(point):
			continue
		value = maxf(value, float(zone.concealment(prone)))
	return minf(value, GameConfig.TERRAIN_CONCEAL_MAX)
