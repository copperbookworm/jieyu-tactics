extends RefCounted

## 游戏外壳界面的公共控件工厂（大厅 / 模式 / 设置 / 暂停 / 结算 / 说明 共用一套尺寸与配色）
##
## 为什么要有它：五个屏幕各写一遍 Button.new() + 字号 + 配色，必然长歪；而几何门禁要求
## 「点按目标 >= 32 px」「控件不出 960x540」——尺寸集中在一处才守得住，也才改得动。
##
## 字体：工程默认字体已是随包 CJK 字体（project.godot 的 gui/theme/custom_font），
## 这里再显式建一个 Theme 并挂到屏幕根上，是为了让「外壳用什么字号」在代码里一眼可见，
## 不依赖父节点的主题被谁悄悄换掉（同 ui/AiAdvisorPanel.gd 的理由）。
##
## 刻意不写 class_name：引用方 preload。

const UI_FONT_PATH := "res://assets/fonts/JieyuCJK-Subset.otf"

## 逻辑视口（与 project.godot 的 960x540 + canvas_items 拉伸一致）
const VIEW := Vector2(960.0, 540.0)

## 配色：整体暗色军事风，强调色沿用 HUD 的蓝（GameConfig.UNIT_COLOR_PLAYER）
const COLOR_BG := Color(0.055, 0.065, 0.085, 1.0)
const COLOR_PANEL := Color(0.115, 0.130, 0.160, 1.0)
const COLOR_PANEL_HI := Color(0.160, 0.180, 0.215, 1.0)
const COLOR_ACCENT := Color(0.310, 0.616, 0.878)
const COLOR_TEXT := Color(0.905, 0.922, 0.945)
const COLOR_DIM := Color(0.620, 0.660, 0.720)
const COLOR_LOCKED := Color(0.400, 0.430, 0.480)
const COLOR_DANGER := Color(0.851, 0.326, 0.310)

const TITLE_SIZE := 32
const HEADING_SIZE := 18
const BODY_SIZE := 14
const SMALL_SIZE := 12

## 主按钮尺寸：高 48 >= 门禁的 32 px 下限；宽 260 是横屏上拇指够得着的既有取值
const BUTTON_SIZE := Vector2(260.0, 48.0)
const BUTTON_SIZE_SMALL := Vector2(120.0, 40.0)
const ROW_HEIGHT := 34

static var _theme: Theme = null


## 外壳统一主题：默认字体（随包 CJK）+ 默认字号
static func base_theme() -> Theme:
	if _theme == null:
		_theme = Theme.new()
		var f = load(UI_FONT_PATH)
		if f != null:
			_theme.default_font = f
		_theme.default_font_size = BODY_SIZE
	return _theme


static func label(text: String, font_size: int = BODY_SIZE, color: Color = COLOR_TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	return l


## 会换行、会把容器撑开的多行说明
static func wrapped(text: String, font_size: int = BODY_SIZE, color: Color = COLOR_DIM) -> Label:
	var l := label(text, font_size, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l


static func panel_style(color: Color, border_color: Color = Color(0, 0, 0, 0)) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.corner_radius_top_left = 4
	sb.corner_radius_top_right = 4
	sb.corner_radius_bottom_left = 4
	sb.corner_radius_bottom_right = 4
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	if border_color.a > 0.0:
		sb.border_color = border_color
		sb.border_width_left = 1
		sb.border_width_right = 1
		sb.border_width_top = 1
		sb.border_width_bottom = 1
	return sb


## 带底色 / 内边距的面板容器（里面通常放一个 VBoxContainer）
static func panel(color: Color = COLOR_PANEL) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", panel_style(color))
	return p


## 面板 + 里面那个 VBox 一起建好（省掉每屏都写两遍）。
## 返回 PanelContainer（要加进容器的就是它），里面的 VBox 用 content_of() 取。
static func panel_box(title: String = "", color: Color = COLOR_PANEL) -> PanelContainer:
	var p := panel(color)
	var box := VBoxContainer.new()
	box.name = "Content"
	box.add_theme_constant_override("separation", 6)
	p.add_child(box)
	if title != "":
		box.add_child(label(title, HEADING_SIZE, COLOR_ACCENT))
	return p


static func content_of(panel_node: PanelContainer) -> VBoxContainer:
	return panel_node.get_node("Content") as VBoxContainer


## 右侧是控件的「标签：控件」一行（设置界面用；row() 的右侧只能是文本）
static func control_row(key: String, control: Control) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	var k := label(key, BODY_SIZE, COLOR_DIM)
	k.custom_minimum_size = Vector2(72.0, 0.0)
	h.add_child(k)
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(control)
	return h


static func button(text: String, size: Vector2 = BUTTON_SIZE) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = size
	b.add_theme_font_size_override("font_size", 16)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var bg := COLOR_PANEL
		if state == "hover":
			bg = COLOR_PANEL_HI
		elif state == "pressed":
			bg = COLOR_ACCENT.darkened(0.35)
		elif state == "disabled":
			bg = Color(0.090, 0.100, 0.120, 1.0)
		b.add_theme_stylebox_override(state, panel_style(bg))
	b.add_theme_color_override("font_color", COLOR_TEXT)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", COLOR_LOCKED)
	b.add_theme_color_override("font_focus_color", COLOR_TEXT)
	return b


## 紧凑样式：内边距从 10 收到 5。列表项用它 —— 一列 6 项的屏靠这 10 来省高度
## （Button 的最小高度 = 上下内边距 + 一行字，光设 custom_minimum_size 是压不下去的）
static func tight_style(color: Color) -> StyleBoxFlat:
	var sb := panel_style(color)
	sb.content_margin_top = 5
	sb.content_margin_bottom = 5
	return sb


## 紧凑按钮（列表项用）：字号 14 + 紧凑内边距 ⇒ 最小高度约 30，由 size.y 兜到 36。
## 36 >= 几何门禁的点按下限 32，别为了省高度压到 32 以下。
static func compact_button(text: String, size: Vector2) -> Button:
	var b := button(text, size)
	b.add_theme_font_size_override("font_size", 14)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var bg := COLOR_PANEL
		if state == "hover":
			bg = COLOR_PANEL_HI
		elif state == "pressed":
			bg = COLOR_ACCENT.darkened(0.35)
		elif state == "disabled":
			bg = Color(0.090, 0.100, 0.120, 1.0)
		b.add_theme_stylebox_override(state, tight_style(bg))
	return b


## 详情卡上的「标签：值」一行（值右对齐）
static func row(key: String, value: String, value_color: Color = COLOR_TEXT) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	var k := label(key, BODY_SIZE, COLOR_DIM)
	k.custom_minimum_size = Vector2(88.0, 0.0)
	h.add_child(k)
	var v := label(value, BODY_SIZE, value_color)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	v.clip_text = true
	h.add_child(v)
	return h


static func spacer(height: float = 0.0, expand: bool = false) -> Control:
	var c := Control.new()
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if expand:
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	else:
		c.custom_minimum_size = Vector2(0.0, height)
	return c


## 分隔线（用 ColorRect 而不是 HSeparator：尺寸可控，且不参与点按判定）
static func divider() -> ColorRect:
	var c := ColorRect.new()
	c.color = Color(1.0, 1.0, 1.0, 0.10)
	c.custom_minimum_size = Vector2(0.0, 1.0)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


static func check_box(text: String, pressed: bool) -> CheckBox:
	var c := CheckBox.new()
	c.text = text
	c.button_pressed = pressed
	c.add_theme_font_size_override("font_size", BODY_SIZE)
	c.add_theme_color_override("font_color", COLOR_TEXT)
	c.custom_minimum_size = Vector2(0.0, 32.0)
	return c


static func option_button(items: Array, selected_index: int) -> OptionButton:
	var o := OptionButton.new()
	for i in items.size():
		o.add_item(String(items[i]), i)
	if selected_index >= 0 and selected_index < items.size():
		o.select(selected_index)
	o.add_theme_font_size_override("font_size", BODY_SIZE)
	# 关掉「按最长项撑宽」：它会把最小宽度顶到最长的那条模型名上（既有教训，几何门禁抓到过）
	o.fit_to_longest_item = false
	o.custom_minimum_size = Vector2(140.0, 32.0)
	return o


static func slider(min_value: float, max_value: float, value: float) -> HSlider:
	var s := HSlider.new()
	s.min_value = min_value
	s.max_value = max_value
	s.step = 0.05
	s.value = value
	s.custom_minimum_size = Vector2(160.0, 32.0)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return s


static func spin(min_value: int, max_value: int, value: int) -> SpinBox:
	var s := SpinBox.new()
	s.min_value = min_value
	s.max_value = max_value
	s.value = value
	s.custom_minimum_size = Vector2(120.0, 32.0)
	s.get_line_edit().add_theme_font_size_override("font_size", BODY_SIZE)
	return s
