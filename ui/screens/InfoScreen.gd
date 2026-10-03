extends "res://ui/screens/ScreenBase.gd"

## 说明屏（玩法说明 / 关于共用一屏）——「其他 UI 界面」的最小落地
##
## 为什么不各开一屏：内容都是纯文本，开两屏等于多两份布局要守几何门禁。
## 题材用 set_topic() 切换，进栈之前调一次即可。
##
## 刻意不写 class_name：引用方 preload。


const TOPICS := {
	"controls": {
		"title": "玩法说明",
		"intro": "横屏单手操作：左手摇杆走动，右手点按开火；报点与指令在右下轮盘展开。",
		"lines": [
			"摇杆：移动。聚焦键按住＝收窄散布（桌面按 Shift）。",
			"开火：步兵开枪；坐进武器位则开炮。驾驶位不能开炮，先按「换座」。",
			"地图：右侧「地图」按钮或桌面 M 键。开图期间不能移动与开火。",
			"报点：「报点」轮盘展开选类型，落点要在通视范围内（地形/烟雾挡住不许报）。",
			"指令：指令轮盘发快捷指令，落点类指令（集结点等）会在地图上画出来。",
			"烟幕：步兵投烟雾弹、载具放发烟器；烟能断开敌方通视，AI 改盲射。",
			"间瞄：「间瞄」键一步开图并切选点模式，落点会吸附到附近的报点标记。",
			"任务：左上任务卡是主线与支线；主线完成有战力分奖励。",
			"载具：靠近按「上车」，8.1 座位分工；车被打爆会被请下车。",
			"AI 参谋：局后复盘。默认不填 API key 就完全不联网。",
		],
	},
	"about": {
		"title": "关于",
		"intro": "《解域》第一版垂直切片（Godot 4.7.1 · 纯 2D 俯视）。",
		"lines": [
			"玩法：2 阵营 / 1 张地图 / 3 个模式（22.10 第一版范围）。",
			"本版已做：占领与任务、载具与炮塔、报点与指令、烟雾、间瞄、AI 参谋、战斗播报。",
			"未做（文档里有、这版没有）：联机、建筑毁伤、兵棋模式、装甲对抗、困难模式、",
			"        第二张地图、阵营与皮肤资产、高光录像回放、匹配与好友。",
			"工程纪律：三个模式共用一套对局规则，差别在胜负口径 / 时长 / 友伤 / AI 参谋开关。",
		],
	},
}

var _topic := "about"
var _intro: Label = null


func screen_id() -> String:
	return "info"


func screen_title() -> String:
	return _topic_title()


func set_topic(topic: String) -> void:
	_topic = topic if TOPICS.has(topic) else "about"


func _topic_title() -> String:
	return String(TOPICS[_topic]["title"]) if TOPICS.has(_topic) else "说明"


func _build_content(body: VBoxContainer) -> void:
	_refresh()


func on_enter() -> void:
	_refresh()
	refresh_navigation()


func _refresh() -> void:
	set_title(_topic_title())
	if body() == null:
		return
	for child in body().get_children():
		body().remove_child(child)
		child.queue_free()

	var panel := UiKit.panel_box()
	body().add_child(panel)
	var content := UiKit.content_of(panel)
	var data: Dictionary = TOPICS.get(_topic, {})
	content.add_child(UiKit.wrapped(String(data.get("intro", "")), UiKit.BODY_SIZE, UiKit.COLOR_TEXT))
	content.add_child(UiKit.divider())
	for line in data.get("lines", []):
		content.add_child(UiKit.wrapped("· " + String(line), UiKit.BODY_SIZE))
	content.add_child(UiKit.spacer(0.0, true))
	if ctx != null:
		content.add_child(UiKit.wrapped("版本 %s ｜ 引擎 %s" % [
				ctx.version_text(), Engine.get_version_info().get("string", "")],
				UiKit.SMALL_SIZE, UiKit.COLOR_LOCKED))
