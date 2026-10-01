class_name QuestCard
extends Control

## 任务卡片 HUD（docx 4.10 SMEAC）：显示**进行中的任务列表**（1 主线 + ≤2 支线）
## 每行：类型 ｜ 名称 ｜ 进度 ｜ 剩余时限 ｜ 奖励；完成/失败时整卡高亮并提示
## 第一版只用 Label 文本，不依赖美术资源

var _quests: Array = []
var _flash_time := 0.0
var _flash_text := ""

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
	_label.text = "\n".join(lines)


func _process(delta: float) -> void:
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
