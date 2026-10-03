extends Control

## 屏幕基类（游戏外壳的每一屏都继承它）
##
## 统一负责：全屏尺寸、主题、背景（自己 _draw，不额外挂 ColorRect —— 少一个同级 Control
## 就少一对几何门禁要算的重叠）、页眉（标题 + 返回）、内容区、进出场钩子。
## 子类只需要实现 screen_id() / screen_title() / _build_content(body)。
##
## 布局纪律（几何门禁直接约束这三条，别绕）：
##   ① 屏幕根之下只有一个 MarginContainer 子节点 ⇒ 同级不可能重叠；
##   ② 里面全部用 Container（VBox / HBox / PanelContainer）⇒ 门禁跳过 Container 的子节点；
##   ③ 每个可点控件最短边 >= 32 px（UiKit 的尺寸常量已守住）。
##
## 刻意不写 class_name：引用方 preload。

const UiKit := preload("res://ui/UiKit.gd")

const MARGIN := 20.0

var router = null      ## ScreenRouter（跳转出口；屏幕自己不直接改父节点的可见性）
var ctx = null         ## App（读设置、发起对局、查对战状态）

var _body: VBoxContainer = null
var _header: HBoxContainer = null
var _back_button: Button = null
var _title_label: Label = null


func screen_id() -> String:
	return ""


func screen_title() -> String:
	return ""


## 进场（每次成为栈顶都会调，不是只调一次）
func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func setup(router_node, context) -> void:
	router = router_node
	ctx = context
	name = screen_id()
	size = UiKit.VIEW
	theme = UiKit.base_theme()
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


func _draw() -> void:
	# 背景画在自己身上：不额外挂 ColorRect，屏幕根就只有一个可见子节点
	draw_rect(Rect2(Vector2.ZERO, size), UiKit.COLOR_BG, true)


func _build() -> void:
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", int(MARGIN))
	margin.add_theme_constant_override("margin_top", int(MARGIN))
	margin.add_theme_constant_override("margin_right", int(MARGIN))
	margin.add_theme_constant_override("margin_bottom", int(MARGIN))
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)

	var column := VBoxContainer.new()
	column.name = "Column"
	column.add_theme_constant_override("separation", 12)
	margin.add_child(column)

	_header = HBoxContainer.new()
	_header.name = "Header"
	_header.add_theme_constant_override("separation", 12)
	column.add_child(_header)

	_title_label = UiKit.label(screen_title(), UiKit.TITLE_SIZE, UiKit.COLOR_TEXT)
	_header.add_child(_title_label)
	_header.add_child(UiKit.spacer(0.0, true))

	_back_button = UiKit.button("返回", UiKit.BUTTON_SIZE_SMALL)
	_back_button.name = "BackButton"
	_back_button.pressed.connect(_on_back_pressed)
	_header.add_child(_back_button)

	column.add_child(UiKit.divider())

	_body = VBoxContainer.new()
	_body.name = "Body"
	_body.add_theme_constant_override("separation", 12)
	_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(_body)

	_build_content(_body)
	refresh_navigation()


func _build_content(_body_box: VBoxContainer) -> void:
	pass


func _on_back_pressed() -> void:
	if router != null:
		router.back()


## 返回按钮只在「还有上一层」时出现（栈底屏幕不显示，避免点了没反应）
func refresh_navigation() -> void:
	if _back_button != null:
		_back_button.visible = router != null and router.can_pop()


func body() -> VBoxContainer:
	return _body


func set_title(text: String) -> void:
	if _title_label != null:
		_title_label.text = text
