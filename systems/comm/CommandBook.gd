extends RefCounted

## 快捷指令目录 + 冷却（docx 4.13「局内对话设置」，候选 O 第二轮）
##
## 4.13 口径：取消局内全部麦之后，沟通只走「报点标记 + 快捷指令 + 小队标记链」，不做自由文字聊天
## （移动端打字成本高，也与「专注游戏」的初衷冲突）。本文件是快捷指令的纯逻辑层
## （目录 / 冷却 / 落点类型），UI 在 ui/CommandWheel.gd、执行在 systems/comm/CommandController.gd，
## 所以 test/command_test.gd 能直接实例化断言。
##
## 「显示在队友 HUD 与战术地图上」这条（4.13 原文）：第一版是单机单人，没有队友 HUD ——
## 落点类指令（发现敌人 / 集结点）走既有报点体系落成真实标记，小地图与战术地图天然会画；
## 口头类指令（跟我来 / 需要支援 / 掩护我 / 撤退）进 4.14 的战斗播报 + 主视图提示。
## 未做：小队标记链的权限分级（小队长 → 队员）、语音、被指令者可见提示 —— 都要等小队编制。
##
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

## 目录顺序＝轮盘顺序；mark 为 MARK_NONE 表示「不落点」，其余取值见下面两个常量。
const MARK_NONE := -1
const MARK_ENEMY := 0   ## ＝ MarkSystem.MarkType.ENEMY（command_test 有交叉断言钉住这个耦合）
const MARK_RALLY := 5   ## ＝ MarkSystem.MarkType.RALLY

const COMMANDS := [
	{"id": "follow", "label": "跟我来", "mark": MARK_NONE},
	{"id": "support", "label": "需要支援", "mark": MARK_NONE},
	{"id": "enemy", "label": "发现敌人", "mark": MARK_ENEMY},
	{"id": "cover", "label": "掩护我", "mark": MARK_NONE},
	{"id": "retreat", "label": "撤退", "mark": MARK_NONE},
	{"id": "rally", "label": "集结点", "mark": MARK_RALLY},
]

var _cooldowns := {}    ## id -> 剩余冷却（秒）
var _global := 0.0      ## 任意两条指令之间的公共冷却


static func count() -> int:
	return COMMANDS.size()


static func command(index: int) -> Dictionary:
	if index < 0 or index >= COMMANDS.size():
		return {}
	return COMMANDS[index]


static func index_of(id: String) -> int:
	for i in COMMANDS.size():
		if String(COMMANDS[i]["id"]) == id:
			return i
	return -1


static func has(id: String) -> bool:
	return index_of(id) >= 0


static func label_of(id: String) -> String:
	var index := index_of(id)
	return "" if index < 0 else String(COMMANDS[index]["label"])


## 这条指令要不要落点，落到哪一类标记（MARK_NONE ＝ 不落点）
static func mark_type_of(id: String) -> int:
	var index := index_of(id)
	return MARK_NONE if index < 0 else int(COMMANDS[index]["mark"])


func remaining(id: String) -> float:
	return float(_cooldowns.get(id, 0.0))


func global_remaining() -> float:
	return _global


func ready(id: String) -> bool:
	return has(id) and _global <= 0.0 and remaining(id) <= 0.0


## 发送：冷却中直接拒绝（返回 false），否则记两条冷却并返回 true
func send(id: String) -> bool:
	if not ready(id):
		return false
	_cooldowns[id] = GameConfig.COMMAND_COOLDOWN
	_global = GameConfig.COMMAND_GLOBAL_COOLDOWN
	return true


func tick(delta: float) -> void:
	_global = maxf(_global - delta, 0.0)
	for id in _cooldowns.keys():
		var left := maxf(float(_cooldowns[id]) - delta, 0.0)
		if left <= 0.0:
			_cooldowns.erase(id)
		else:
			_cooldowns[id] = left


func clear() -> void:
	_cooldowns.clear()
	_global = 0.0
