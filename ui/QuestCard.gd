class_name QuestCard
extends Control

## 任务卡片 HUD（docx 4.10 SMEAC）：显示**进行中的任务列表**（1 主线 + ≤2 支线）
## 每行：类型 ｜ 名称 ｜ 进度 ｜ 剩余时限 ｜ 奖励；完成/失败时整卡高亮并提示
## 第一版只用 Label 文本，不依赖美术资源

var _quests: Array = []
var _flash_time := 0.0
var _flash_text := ""
## 组任务（docx 4.10.8 执行层）：显示「你所在组被派到了什么」。
## 只往**已有的那一个 Label** 里多拼一行 —— 不新增控件，所以两条几何门禁都不受影响。
## 每帧从 world.squad_orders 同步（HudBuilder 注入 main），因此不必改 Main.gd（它守着 ≤400 行）。
const SquadOrdersScript := preload("res://systems/match/SquadOrders.gd")

var main = null
var _squad_order := ""

var _label: Label = null


func _ready() -> void:
	size = Vector2(GameConfig.TASK_CARD_WIDTH, GameConfig.TASK_CARD_HEIGHT)
	position = Vector2(GameConfig.TASK_CARD_POS_X, GameConfig.TASK_CARD_POS_Y)
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	_label = Label.new()
	_label.position = Vector2(8.0, 4.0)
	add_child(_label)
	visible = false


## 刷新任务列表（直接接 QuestSystem.quest_list_changed）
func set_quests(quest_list: Array) -> void:
	_quests = quest_list
	visible = not quest_list.is_empty()
	_refresh_label()
	queue_redraw()


## 组任务行（空串 = 不显示）
func set_squad_order(text: String) -> void:
	if text == _squad_order:
		return
	_squad_order = text
	_refresh_label()
	queue_redraw()


func show_completed(reward: int, quest_name: String) -> void:
	_flash_time = GameConfig.TASK_COMPLETE_FLASH
	_flash_text = "完成：%s  +%d 战力分" % [quest_name, reward]
	if _label != null:
		_label.text = _flash_text
	queue_redraw()


func show_failed(quest_name: String) -> void:
	_flash_time = GameConfig.TASK_COMPLETE_FLASH
	_flash_text = "失败（不扣分）：%s" % quest_name
	if _label != null:
		_label.text = _flash_text
	queue_redraw()


## 每帧从世界的编成命令层同步组任务文本（找不到就什么都不做）
func _sync_squad_order() -> void:
	var world = main.world if main != null else null
	if world == null:
		return
	var data: Dictionary = world.squad_orders
	if data.is_empty():
		return
	set_squad_order(SquadOrdersScript.summary_text(data))


func _refresh_label() -> void:
	if _label == null or _flash_time > 0.0:
		return
	var lines: Array[String] = []
	for quest in _quests:
		var tag := "主线" if bool(quest["main"]) else "支线"
		var line := "[%s] %s" % [tag, String(quest["name"])]
		if String(quest["goal_kind"]) == "capture_zone":
			line += "  %d%%" % int(float(quest["progress"]) * 100.0)
		else:
			line += "  %d/%d" % [int(float(quest["progress"])),
					int(quest["goal_count"])]
		if float(quest["time_limit"]) > 0.0:
			line += "  剩 %d s" % int(float(quest["time_left"]))
		line += "  +%d" % int(quest["reward"])
		lines.append(line)
	# 组任务（docx 4.10.8）：主线到了小队长手里，他按模板派给每个组；
	# 玩家看自己那一组的任务就够了（其余组的任务由各自的组长执行，不塞进卡片）
	if _squad_order != "":
		lines.append("[组任务] %s" % _squad_order)
	_label.text = "\n".join(lines)


func _process(delta: float) -> void:
	_sync_squad_order()
	if _flash_time <= 0.0:
		return
	_flash_time = maxf(_flash_time - delta, 0.0)
	if _flash_time <= 0.0:
		_refresh_label()
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.07, 0.10, 0.55))
	if _flash_time > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.48, 0.85, 0.56, 0.25))
