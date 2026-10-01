class_name MarkWheel
extends Control

## 报点轮盘（docx 4.11.3：选标记类型 → 点位置 → 广播）
## 位置：屏幕右下角、开火键上方——按文档「报点按钮必须最易触达」放在右手拇指区
## 交互：点「报点」展开 6 类标记的环形菜单，选一类即把标记落在准心位置
##      （准心已被地形钳制，天然满足 4.11.2 的「通视前提」）
## 第一版用 Button 承载触摸与中文文字，不自绘——少写代码，多点确定性

signal mark_requested(type: int)

var _items: Array[Button] = []
var _expanded := false
var _center := Vector2.ZERO


func _ready() -> void:
	size = Vector2(GameConfig.MARK_BUTTON_SIZE, GameConfig.MARK_BUTTON_SIZE)
	position = Vector2(GameConfig.VIEWPORT_WIDTH - GameConfig.MARK_BUTTON_SIZE,
			GameConfig.VIEWPORT_HEIGHT - 160.0 - GameConfig.MARK_BUTTON_SIZE * 1.6)
	_center = size * 0.5
	_build_report_button()
	_build_items()
	_set_expanded(false)


func _build_report_button() -> void:
	var button := Button.new()
	button.name = "ReportButton"
	button.text = "报点"
	button.size = size
	button.position = Vector2.ZERO
	button.pressed.connect(_toggle)
	add_child(button)


## 6 个类型按钮向左半圈展开（报点键贴着屏幕右侧，整圈会把右边两个按钮推出屏幕）
## 位置＝报点键中心 + item_offset()，最后再 clamp 一次兜底，防止改参数又跑出屏幕
func _build_items() -> void:
	var count := MarkSystem.TYPE_LABELS.size()
	for i in count:
		var item := Button.new()
		item.name = "Mark%d" % i
		item.text = MarkSystem.type_label(i)
		item.size = Vector2(GameConfig.MARK_ITEM_WIDTH, GameConfig.MARK_ITEM_HEIGHT)
		item.position = _center + item_offset(i, count) - item.size * 0.5
		item.position = item.position.clamp(-position,
				Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT) - position
				- item.size)
		item.add_theme_color_override("font_color", MarkSystem.type_color(i))
		item.pressed.connect(_choose.bind(i))
		add_child(item)
		_items.append(item)


## 菜单项相对报点键中心的偏移：只走左半圈（90° → 270°，经过左侧），首尾各内收半个间隔
static func item_offset(index: int, count: int) -> Vector2:
	if count <= 0:
		return Vector2.ZERO
	var angle := PI * 0.5 + (float(index) + 0.5) * PI / float(count)
	return Vector2.RIGHT.rotated(angle) * GameConfig.MARK_WHEEL_RADIUS


func _toggle() -> void:
	_set_expanded(not _expanded)


func _set_expanded(expanded: bool) -> void:
	_expanded = expanded
	for item in _items:
		item.visible = expanded


func _choose(type: int) -> void:
	mark_requested.emit(type)
	_set_expanded(false)


func is_expanded() -> bool:
	return _expanded
