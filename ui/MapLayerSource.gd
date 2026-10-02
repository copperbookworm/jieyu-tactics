extends RefCounted

## 地图「世界图层」的数据源（2026-10-01 候选 T/L 遗留 + 本轮 ④）
##
## 小地图与战术地图都要画三样东西：己方补给车 / 侧翼通路 / 敌方 FOB。
## 两边各写一份取数逻辑迟早对不上（也会让「敌方能上地图吗」这种口径出现两个答案），
## 所以取数与几何统一收在这里，两张地图只负责按自己的坐标系画。
##
## 取数只用两样东西：① 组查询（fob_enemy）② Main 的公开字段（supply_ctl / lane_ctl）。
## 不反向引用任何模块，也不给它们加接口——沿用候选 N 的分工。
## 刻意不写 class_name：引用方 preload（与项目其它无 class_name 模块一致）


## 侧翼通路（Lane）：地图级地形要素，不是「单位」，也不分敌我 → 一直画（只是激活时画亮）
static func lane(main) -> Node2D:
	if main == null or main.lane_ctl == null:
		return null
	var node = main.lane_ctl.lane
	if node == null or not is_instance_valid(node):
		return null
	return node as Node2D


## 己方补给车（Supply）：docx 4.11.1 ④「己方……补给点全显」
static func convoy(main) -> Node2D:
	if main == null or main.supply_ctl == null:
		return null
	var node = main.supply_ctl.convoy
	if node == null or not is_instance_valid(node):
		return null
	return node as Node2D


## 通路四角：[左入, 右入, 左出, 右出]。两张地图共用，免得各推一次法线。
## 退化（入口＝出口）返回空数组。
static func lane_edges(entry: Vector2, exit_point: Vector2, half_width: float) -> Array:
	var span := exit_point - entry
	var length := span.length()
	if length < 0.001:
		return []
	var direction := span / length
	var normal := Vector2(-direction.y, direction.x) * half_width
	return [entry + normal, entry - normal, exit_point + normal, exit_point - normal]


## 可以画到地图上的敌方 FOB：查 fob_enemy 组后过一遍 known_fobs。
## 入参是 SceneTree（地图从 get_tree() 拿）。
static func visible_fobs(tree) -> Array:
	if tree == null:
		return []
	var loop := tree as SceneTree
	if loop == null:
		return []
	return known_fobs(loop.get_nodes_in_group("fob_enemy"))


## 纯过滤（单测入口，不需要场景树）：docx 4.11.2 红线——敌方默认不显，
## 被己方目击并报点之后才出现，所以判据是 is_known_to_player()。
## 它由 QuestSystem 判「FOB 被标记暴露」时调 Fob.mark_revealed() 置位（工事不会移动，暴露一次就长显）。
static func known_fobs(nodes: Array) -> Array:
	var result: Array = []
	for node in nodes:
		if node == null or not is_instance_valid(node):
			continue
		if node.has_method("is_known_to_player") and not node.is_known_to_player():
			continue
		result.append(node)
	return result
