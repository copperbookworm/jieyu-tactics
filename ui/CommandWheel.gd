extends Control

## 快捷指令轮盘（docx 4.13「局内对话设置」，候选 O 第二轮）
## 交互：点「指令」展开 6 条预设指令的环形菜单，选一条即发送（冷却在 CommandBook 里）。
## 位置：左侧第三列（x=192 / y=186）——右侧已被小地图、地图键、报点轮盘占满，这里是唯一空位。
## 环形几何复用 MarkWheel.item_offset()，但**把 x 镜像成正的 ⇒ 只向右半圈展开**：
## 使用者 2026-10-02 真机指出「向左展开会挡住其他按钮」—— 指令键本身就在第三列（x=192），
## 往左铺正好压住中间那列（换枪 / 上车 / 换座）。同一高度的右侧是空的，往右铺不压任何东西。
## 仍保留一次 clamp 兜底（贴屏幕边时把菜单项拉回屏内）。
## 第一版用 Button 承载触摸与中文文字，不自绘（与 MarkWheel 同一套做法）。
##
## 刻意不写 class_name：新 class_name 在 --script 模式下不在全局类缓存里，引用方会解析失败
## （2026-10-01 实测踩到）——所以引用方 preload（同 Cover.gd 头部说明）。

signal command_requested(id: String)

const CommandBookScript := preload("res://systems/comm/CommandBook.gd")

var _items: Array[Button] = []
var _expanded := false
var _center := Vector2.ZERO


func _ready() -> void:
	size = Vector2(GameConfig.COMMAND_BUTTON_WIDTH, GameConfig.COMMAND_BUTTON_HEIGHT)
	position = Vector2(GameConfig.COMMAND_BUTTON_X, GameConfig.COMMAND_BUTTON_Y)
	_center = size * 0.5
	_build_open_button()
	_build_items()
	_set_expanded(false)


func _build_open_button() -> void:
	var button := Button.new()
	button.name = "CommandButton"
	button.text = "指令"
	button.size = size
	button.position = Vector2.ZERO
	button.pressed.connect(_toggle)
	add_child(button)


func _build_items() -> void:
	var count := CommandBookScript.count()
	for i in count:
		var command: Dictionary = CommandBookScript.command(i)
		var item := Button.new()
		item.name = "Command_%s" % String(command["id"])
		item.text = String(command["label"])
		item.size = Vector2(GameConfig.MARK_ITEM_WIDTH, GameConfig.MARK_ITEM_HEIGHT)
		# x 取绝对值 ⇒ 镜像成右半圈（见文件头：向左会盖住中间那列按钮）
		var offset := MarkWheel.item_offset(i, count)
		offset.x = absf(offset.x)
		item.position = _center + offset - item.size * 0.5
		item.position = item.position.clamp(-position,
				Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT)
				- position - item.size)
		item.pressed.connect(_choose.bind(String(command["id"])))
		add_child(item)
		_items.append(item)


func _toggle() -> void:
	_set_expanded(not _expanded)


func _set_expanded(expanded: bool) -> void:
	_expanded = expanded
	for item in _items:
		item.visible = expanded


func _choose(id: String) -> void:
	command_requested.emit(id)
	_set_expanded(false)


func is_expanded() -> bool:
	return _expanded


func item_count() -> int:
	return _items.size()
