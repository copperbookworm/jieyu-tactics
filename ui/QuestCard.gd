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
	# 放进 Container（左上信息列）时位置由布局器给，自己只管**最小尺寸**；
	# 独立摆放时才用 TASK_CARD_POS_* —— 见 GameConfig 里「左上信息列」那段说明。
	custom_minimum_size = Vector2(GameConfig.TASK_CARD_WIDTH, GameConfig.TASK_CARD_HEIGHT)
	size = custom_minimum_size
	if not (get_parent() is Container):
		position = Vector2(GameConfig.TASK_CARD_POS_X, GameConfig.TASK_CARD_POS_Y)
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	_label = Label.new()
	_label.position = Vector2(GameConfig.TASK_CARD_PAD_X, GameConfig.TASK_CARD_PAD_Y)
	# ⚠ 尺寸必须给死 + 裁切：不给的话 Label 按文本自动撑到 320×105，越出 300×96 的卡片
	#（2026-10-07 真机验收抓到：第 4 行压在下方按钮行上、第 3 行右侧被切）。
	# 硬约束由几何门禁第 ⑤ 条「子控件不越出父容器」守着。
	_label.size = Vector2(GameConfig.TASK_CARD_WIDTH - GameConfig.TASK_CARD_PAD_X * 2.0,
			GameConfig.TASK_CARD_HEIGHT - GameConfig.TASK_CARD_PAD_Y * 2.0)
	_label.clip_text = true
	_label.add_theme_font_size_override("font_size", GameConfig.TASK_CARD_FONT_SIZE)
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
		# 时限与奖励压缩写法（2026-10-07 真机验收）：改成「105s +10」，
		# 让最长的支线行（侦察并标记敌方阵地 0/2 105s +10）在 284 px 内放得下 ——
		# 卡片只有 300 px 宽，中文全角字符一多就会被裁掉。
		if float(quest["time_limit"]) > 0.0:
			line += " %ds" % int(float(quest["time_left"]))
		line += " +%d" % int(quest["reward"])
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
