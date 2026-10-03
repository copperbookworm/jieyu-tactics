extends RefCounted

## 本局模式规则（静态只读查询）
##
## 为什么用静态字段而不是「Main 把模式传给 Player / Ally / MatchFlow」：
##   Main.gd 是 398/400 的硬线，再加一条「把模式一路传下去」的接线就破了硬线；
##   而 Player.shoot（友伤）与 MatchFlow（胜负口径）都在很深处，需要知道本局开不开友伤。
##   工程既有的同类做法是「运行时可解析的共享查询」（见 systems/audio/Sfx.gd），
##   这里模式是**一局的全局事实**，静态字段比一路传参更直接，也好单测。
##
## 默认 = 模式表的默认模式（休闲：关友伤 / AI 参谋开放）——**与今天的工程行为一致**，
## 所以任何没显式 set_mode 的路径（单测、集成冒烟、几何门禁）回归面为零。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")

## -1 = 未设定，按 ModeTable 的默认模式解释（避免静态初始化期就去读 preload 的枚举）
static var _mode_id: int = -1


static func set_mode(mode_id: int) -> void:
	_mode_id = mode_id


static func mode_id() -> int:
	return _mode_id if _mode_id >= 0 else ModeTableScript.default_mode_id()


## 未设定过任何模式时为 true —— 界面用它判断「这是玩家选的，还是引擎默认」
static func is_default() -> bool:
	return _mode_id < 0


static func reset() -> void:
	_mode_id = -1


static func mode() -> Dictionary:
	return ModeTableScript.get_mode(mode_id())


static func name_of_mode() -> String:
	return ModeTableScript.name_of(mode_id())


static func friendly_fire() -> bool:
	return ModeTableScript.friendly_fire(mode_id())


static func competitive() -> bool:
	return ModeTableScript.competitive(mode_id())


static func win_rule() -> String:
	return ModeTableScript.win_rule(mode_id())


static func duration_s() -> float:
	return ModeTableScript.duration_s(mode_id())


static func overtime_s() -> float:
	return ModeTableScript.overtime_s(mode_id())


static func uses_overtime() -> bool:
	return ModeTableScript.uses_overtime(mode_id())


## 友伤目标：本局开友伤时，把 friendly 组里除自己以外的单位并进射击目标。
## 纯函数（不碰场景树），供 Player.shoot 调用，因此可以直接单测。
static func with_friendly_targets(shooter: Node, targets: Array, friendly_nodes: Array) -> Array:
	if not friendly_fire():
		return targets
	var merged := targets.duplicate()
	for node in friendly_nodes:
		if node == null or node == shooter:
			continue
		if merged.has(node):
			continue
		merged.append(node)
	return merged
