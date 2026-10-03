extends CanvasLayer

## AI 参谋面板（游戏内）—— 入口按钮 + 复盘 / 用量账单 / 设置
##
## 为什么独立 CanvasLayer（layer 90）而不挂进 HudBuilder：
##   ① HudBuilder 在 960x540 上已经很挤，几何门禁（tools/geom_assertions.gd）会逐对算重叠；
##   ② 这个面板是「跨场景」的（重开一局不该重建），挂在 AiAdvisor 这个 autoload 下面最自然；
##   ③ 几何门禁只从 Main.tscn 根往下扫，够不到这里 —— 所以本文件自带 tools/ai_panel_check.gd
##      跑一条等价断言（不出屏 / 点按目标 ≥32 px / 面板不出屏），别把「没门禁」当「不用管」。
##
## 入口按钮位置 (600,300) 80x44：来自 tools/hud_rects.gd 的实测空位（该矩形与全部 HUD
## 可见控件矩形无交集，最近的是 Role 标签底边 y=219 与 TipPanel 顶边 y=424）。
## 刻意不写 class_name：引用方 preload。

const CatalogScript := preload("res://systems/ai/AiProviderCatalog.gd")

## 全工程字体方案（2026-10-03 使用者拍板走 B：**随包塞一份 CJK 字体**）：
## 工程默认字体 = res://assets/fonts/JieyuCJK-Subset.otf（见 project.godot 的 gui/theme/custom_font），
## 于是所有 HUD / 面板控件天生就覆盖 CJK 与全角标点，不再依赖 Godot 的隐式系统回退。
##
## 背景（真机实测 · HUAWEI PCE-W30 / HarmonyOS）：本工程原先没有随包字体，
## ThemeDB.fallback_font 是只有拉丁的「Open Sans SemiBold」，CJK 全靠隐式系统回退；
## 那条路在同一段里混排「拉丁 + 全角标点」时不稳定，被选中的回退字体可能不含该标点 ⇒ 豆腐块
## （既有 ui/DownedOverlay.gd 的「剩余 57 s（第一版单机…」真机截图里就是）。
##
## 试过但不够的办法（留作教训，别改回去）：
##   · SystemFont + font_names=["HarmonyOS Sans SC"] —— 真机上解析成**不含 CJK 的拉丁版**
##     「HarmonyOS Sans」，has_char(（) 仍是 false，等于没修；
##   · 运行时读 /system/fonts/HarmonyOS_Sans_SC.ttf —— 能修，但那是**设备专有字体**，
##     不能随包分发，换台机器未必有。故最终改成本工程自带 OFL 字体（见 assets/fonts/）。
const UI_FONT_PATH := "res://assets/fonts/JieyuCJK-Subset.otf"

const BUTTON_POS := Vector2(600.0, 300.0)
const BUTTON_SIZE := Vector2(80.0, 44.0)
const WINDOW_POS := Vector2(48.0, 16.0)
const WINDOW_SIZE := Vector2(864.0, 508.0)
const VIEW := Vector2(960.0, 540.0)

var advisor = null
var _panel_theme: Theme = null
var _cjk_font: Font = null
var _theme_cache: Dictionary = {}
var _scroll: ScrollContainer = null
var _dragging := false
var _drag_last_y := 0.0

var _button: Button = null
var _modal: Control = null
var _enable_box: CheckBox = null
var _provider_box: OptionButton = null
var _model_edit: LineEdit = null
var _base_edit: LineEdit = null
var _key_edit: LineEdit = null
var _key_state: Label = null
var _auto_box: CheckBox = null
var _max_tokens_box: SpinBox = null
var _budget_match_box: SpinBox = null
var _budget_day_box: SpinBox = null
var _request_button: Button = null
## 「清除 key」要二次确认：真机上误触一次就把玩家的 key 删了（2026-10-03 实测踩到），
## 而 key 删了不可恢复（本机只有混淆串、玩家手里那份才是原文）。
var _clear_button: Button = null
var _clear_armed := false
var _status_label: Label = null
var _output: RichTextLabel = null
var _usage_label: Label = null
var _provider_ids: Array = []


func setup(owner_advisor) -> void:
	advisor = owner_advisor
	layer = 90
	_panel_theme = _theme_of(14)
	_build_button()
	_build_modal()
	_refresh()
	advisor.debrief_started.connect(_on_debrief_started)
	advisor.debrief_finished.connect(_on_debrief_finished)
	advisor.usage_changed.connect(_on_usage_changed)


# ────────────────────────────── 入口按钮 ──────────────────────────────

## 面板自己再显式取一次随包字体：工程默认字体已覆盖 CJK，这里是为了让「面板用什么字体」
## 在代码里一眼可见，也避免以后有人换掉面板父节点的主题时把字体悄悄带走。
func _ui_font() -> Font:
	if _cjk_font == null:
		_cjk_font = load(UI_FONT_PATH)
	return _cjk_font


## 每个字号一份主题（字号必须走 Theme，见下）。根因与教训见本文件顶部 UI_FONT_PATH 的注释。
func _theme_of(size: int) -> Theme:
	if _theme_cache.has(size):
		return _theme_cache[size]
	var t := Theme.new()
	t.default_font_size = size
	var font := _ui_font()
	if font != null:
		t.default_font = font
		for type_name in ["Label", "Button", "CheckBox", "OptionButton", "LineEdit", "TextEdit"]:
			t.set_font("font", type_name, font)
		t.set_font("normal_font", "RichTextLabel", font)
	_theme_cache[size] = t
	return t


## 每个工厂函数都给自己的控件显式挂 theme（不靠 _modal 往下继承）：
## 一是让「这个控件用什么字体」在代码里一眼可见，二是避免以后有人给面板某个父节点换 theme 时
## 子控件的字体被悄悄改掉。注意：这不是豆腐块的成因（成因见 _build_cjk_font 上方注释）。


## 面板翻页条（▲/▼）。**为什么不做拖拽滚动**：真机实测（2026-10-03）——
##   · `input swipe` 的拖拽事件根本没进 _input（打了诊断 print，滑动时一条都没有）；
##   · ScrollContainer 自己那套拖动依赖被关掉的 emulate_mouse_from_touch（工程设置）；
##   · 更坑的是：直接挂在 _modal 上的按钮**收不到点击**（矩形、层级都核对过，就是没反应），
##     而 ScrollContainer 箱体里的控件一直好使（勾选框、清除 key 都是这样被点到的）。
## 所以翻页按钮放在箱体内部，并且**顶部一行 + 底部一行**：滚到哪边都有一个够得着。
## BaseButton 走触摸本身，不依赖拖拽，也不依赖鼠标模拟。
func _pager_row() -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "Pager"
	row.add_theme_constant_override("separation", 8)
	var up := _action("▲ 上一页", _on_scroll_up)
	up.custom_minimum_size = Vector2(120.0, 36.0)
	row.add_child(up)
	var down := _action("▼ 下一页", _on_scroll_down)
	down.custom_minimum_size = Vector2(120.0, 36.0)
	row.add_child(down)
	return row


func _on_scroll_up() -> void:
	if _scroll != null:
		_scroll.scroll_vertical = maxi(_scroll.scroll_vertical - 300, 0)


func _on_scroll_down() -> void:
	if _scroll != null:
		_scroll.scroll_vertical += 300


func _build_button() -> void:
	_button = Button.new()
	_button.theme = _panel_theme
	_button.name = "AiAdvisorButton"
	_button.text = "参谋"
	_button.position = BUTTON_POS
	_button.size = BUTTON_SIZE
	_button.theme = _theme_of(16)
	_button.pressed.connect(_on_button_pressed)
	add_child(_button)


func _on_button_pressed() -> void:
	_modal.visible = not _modal.visible
	if _modal.visible:
		_refresh()


# ────────────────────────────── 面板骨架 ──────────────────────────────

func _build_modal() -> void:
	_modal = Control.new()
	_modal.theme = _panel_theme
	_modal.name = "AiAdvisorModal"
	_modal.visible = false
	_modal.position = Vector2.ZERO
	_modal.size = VIEW
	add_child(_modal)

	# 遮罩：STOP 吃掉触屏事件。这一条同时解决「结束画面点哪都重开一局」的冲突 ——
	# 面板开着时触摸被这里消费，走不到 Main._unhandled_input 的重开分支。
	var dim := ColorRect.new()
	dim.name = "Dim"
	dim.color = Color(0.0, 0.0, 0.0, 0.62)
	dim.position = Vector2.ZERO
	dim.size = VIEW
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_modal.add_child(dim)

	var window := ColorRect.new()
	window.name = "Window"
	window.color = Color(0.07, 0.09, 0.11, 0.97)
	window.position = WINDOW_POS
	window.size = WINDOW_SIZE
	window.mouse_filter = Control.MOUSE_FILTER_STOP
	_modal.add_child(window)

	var scroll := ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.position = WINDOW_POS + Vector2(10.0, 10.0)
	# 底部让出 56 px 给「▲/▼ 翻页」按钮条：真机上 ScrollContainer 收不到拖拽事件（见下面的说明），
	# 所以滚动只能靠显式按钮；按钮与滚动区不能重叠，否则几何门禁会算成新的同级重叠。
	scroll.size = Vector2(WINDOW_SIZE.x - 20.0, WINDOW_SIZE.y - 20.0 - 56.0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_modal.add_child(scroll)
	_scroll = scroll

	var box := VBoxContainer.new()
	box.name = "Body"
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	scroll.add_child(box)

	var pager_top := _pager_row()
	box.add_child(pager_top)
	box.move_child(pager_top, 0)
	# 调试入口放最上面：它是真机回归用的，不该让人先翻两页才够得着
	_build_debug_row(box)
	box.add_child(_title("AI 参谋（局间顾问）"))
	_status_label = _body("")
	box.add_child(_status_label)
	box.add_child(_note("用你自己的 API key。不填就完全不联网、不花任何 token；" +
			"所有调用记录只存在这台手机上，不会上传到任何服务器。"))

	box.add_child(_separator())
	box.add_child(_heading("① 开关与供应商"))
	_enable_box = CheckBox.new()
	_enable_box.text = "启用 AI 参谋（不勾选时本游戏绝不发起网络请求）"
	_enable_box.custom_minimum_size = Vector2(0.0, 32.0)
	_enable_box.theme = _theme_of(14)
	_enable_box.toggled.connect(_on_enable_toggled)
	box.add_child(_enable_box)

	box.add_child(_field("供应商", _make_provider_box()))
	_model_edit = _make_line_edit("模型名（留空用该供应商默认）")
	_model_edit.text_changed.connect(_on_model_changed)
	box.add_child(_field("模型", _model_edit))
	_base_edit = _make_line_edit("base_url 覆盖（中转站 / 自建网关才需要填）")
	_base_edit.text_changed.connect(_on_base_changed)
	box.add_child(_field("base_url", _base_edit))

	_key_edit = _make_line_edit("粘贴 API key（只存本机；保存后只显示头尾）")
	_key_edit.secret = true
	box.add_child(_field("API key", _key_edit))
	var key_row := HBoxContainer.new()
	key_row.add_theme_constant_override("separation", 8)
	key_row.add_child(_action("保存 key", _on_save_key))
	_clear_button = _action("清除 key", _on_clear_key)
	key_row.add_child(_clear_button)
	_key_state = _body("")
	# _body 默认 800 px 最小宽度（面板是竖排），但这一个在横排里、后面还并排两个按钮 ——
	# 不改小的话整行最小宽度会被顶到 1124 px，外层 ScrollContainer 跟着跑出屏幕（ai_panel_check 抓到过）
	_key_state.custom_minimum_size = Vector2(140.0, 0.0)
	key_row.add_child(_key_state)
	box.add_child(key_row)

	box.add_child(_separator())
	box.add_child(_heading("② 预算闸门（超了就拒绝，绝不悄悄花你的钱）"))
	_max_tokens_box = _make_spin(16, 8192, 16, advisor.max_tokens_per_call)
	_max_tokens_box.value_changed.connect(_on_max_tokens_changed)
	box.add_child(_field("单次输出上限 token", _max_tokens_box))
	_budget_match_box = _make_spin(0, 2000000, 500, advisor.budget_tokens_per_match)
	_budget_match_box.value_changed.connect(_on_budget_match_changed)
	box.add_child(_field("单局 token 上限（0 = 不限）", _budget_match_box))
	_budget_day_box = _make_spin(0, 20000000, 1000, advisor.budget_tokens_per_day)
	_budget_day_box.value_changed.connect(_on_budget_day_changed)
	box.add_child(_field("单日 token 上限（0 = 不限）", _budget_day_box))
	_auto_box = CheckBox.new()
	_auto_box.text = "一局结束后自动复盘（会直接花你的 token，默认关闭）"
	_auto_box.custom_minimum_size = Vector2(0.0, 32.0)
	_auto_box.theme = _theme_of(14)
	_auto_box.toggled.connect(_on_auto_toggled)
	box.add_child(_auto_box)

	box.add_child(_separator())
	box.add_child(_heading("③ 本局复盘"))
	var run_row := HBoxContainer.new()
	run_row.add_theme_constant_override("separation", 8)
	_request_button = _action("请求本局复盘", _on_request_debrief)
	run_row.add_child(_request_button)
	run_row.add_child(_action("关闭面板", _on_close))
	box.add_child(run_row)
	_output = RichTextLabel.new()
	_output.bbcode_enabled = false
	# scroll_active 必须为 true：设 false 时 RichTextLabel 的最小尺寸会撑到「整段文字不换行」的宽度，
	# 于是外层 ScrollContainer 被顶到 1124 px、跑出 960 的屏幕（ai_panel_check 抓到的）。
	_output.scroll_active = true
	_output.fit_content = false
	_output.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_output.custom_minimum_size = Vector2(800.0, 90.0)
	_output.theme = _theme_of(15)
	box.add_child(_output)

	box.add_child(_separator())
	box.add_child(_heading("④ 用量账单（存在本机）"))
	_usage_label = _body("")
	box.add_child(_usage_label)
	var usage_row := HBoxContainer.new()
	usage_row.add_theme_constant_override("separation", 8)
	usage_row.add_child(_action("导出 CSV", _on_export_csv))
	usage_row.add_child(_action("清空本地记录", _on_clear_records))
	usage_row.add_child(_action("刷新", _refresh))
	box.add_child(usage_row)
	box.add_child(_pager_row())


# ────────────────────────────── 控件工厂 ──────────────────────────────

## 调试专用：立刻结束本局。**只在 debug 包出现**（正式包这段直接 return，连按钮都不建）。
## 为什么要它：复盘按设计只在一局结束后触发，真机回归要么真打完一局（8~15 分钟）、要么干等；
## 有了这个入口，真机验收可以「开面板 → 点它 → 局末自动复盘 → 看 ④ 账单」一次跑完。
## 实现走的是对局本来的结束路径（MatchFlow._finish → Main._on_defeat → EventBus.match_finished），
## 所以它顺带把「采集快照 → 自动复盘 → 落账本」整条链也一起验了，不是绕开逻辑的假入口。
func _build_debug_row(box: VBoxContainer) -> void:
	if not OS.is_debug_build():
		return
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.add_child(_action("立刻结束本局（仅调试包）", _on_debug_end_match))
	box.add_child(row)
	box.add_child(_note("调试入口：只出现在 debug 包（OS.is_debug_build()）；正式包没有这个按钮。"))


func _on_debug_end_match() -> void:
	var tree := get_tree()
	var scene: Node = tree.current_scene if tree != null else null
	if scene == null:
		_output.text = "调试：拿不到当前场景。"
		return
	# Main 没有 class_name，按它与子模块之间既有的字段名约定取 match_flow（同 AiAdvisor 的鸭子类型写法）
	var flow = null
	for p in scene.get_property_list():
		if String(p.get("name", "")) == "match_flow":
			flow = scene.get("match_flow")
			break
	if flow == null or not flow.has_method("_finish"):
		_output.text = "调试：当前场景不是对局（找不到 match_flow）。"
		return
	flow.call("_finish", "enemy", "调试：立刻结束本局")
	_output.text = "调试：已请求立刻结束本局 —— 局末会自动触发复盘（若已开启自动复盘）。"


func _title(text: String) -> Label:
	var l := _body(text)
	l.theme = _theme_of(20)
	return l


func _heading(text: String) -> Label:
	var l := _body(text)
	l.theme = _theme_of(16)
	l.add_theme_color_override("font_color", Color(0.62, 0.85, 1.0))
	return l


func _body(text: String) -> Label:
	var l := Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(800.0, 0.0)
	l.theme = _theme_of(14)
	return l


func _note(text: String) -> Label:
	var l := _body(text)
	l.add_theme_color_override("font_color", Color(0.72, 0.76, 0.8))
	return l


func _separator() -> HSeparator:
	var s := HSeparator.new()
	s.custom_minimum_size = Vector2(800.0, 6.0)
	return s


func _field(label_text: String, control: Control) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var l := Label.new()
	l.text = label_text
	l.custom_minimum_size = Vector2(210.0, 0.0)
	l.theme = _theme_of(14)
	row.add_child(l)
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(control)
	return row


func _make_line_edit(placeholder: String) -> LineEdit:
	var e := LineEdit.new()
	e.placeholder_text = placeholder
	e.custom_minimum_size = Vector2(560.0, 34.0)
	e.theme = _theme_of(14)
	_wire_touch_focus(e)
	return e


## 真机实测（2026-10-03，HUAWEI PCE-W30）：**触摸点输入框不聚焦、软键盘不弹，API key 敲不进去。**
## 根因：本工程 project.godot 里 emulate_mouse_from_touch = false，而 Godot 的 LineEdit 只在
## InputEventMouseButton 上取焦点、**不认 InputEventScreenTouch**；BaseButton 自己处理触摸，
## 所以按钮／复选框一直是好的，只有输入框坏（实机 dumpsys：mShowRequested=false，即从未请求 IME）。
## 这里给每个 LineEdit 补一次「触摸按下就 grab_focus()」，聚焦后 Godot 自己会弹软键盘。
## 真机实测（2026-10-03）：**触摸滑动不能滚面板** —— 于是 ③ 本局复盘 / ④ 用量账单 / 导出 CSV / 清空
## 全在屏幕外、手机上根本够不着。根因与输入框同一个：工程关了 emulate_mouse_from_touch，
## 而 ScrollContainer 的拖动滚动走鼠标事件那条路（BaseButton 自己处理触摸，所以按钮仍好使）。
##
## 修法：自己在 _input 里接管 ScreenTouch / ScreenDrag 来驱动 scroll_vertical。
## 为什么放 _input 而不是给 ScrollContainer 挂 gui_input：挂在 ScrollContainer 上时，
## 只要这一拖是从 SpinBox / CheckBox / Button 上起手的，事件就被那个控件吃掉了（真机实测：
## 从正文区起拖能动、从数字框起拖不动）。_input 在 GUI 之前，起点在哪都能滚；
## 只吞掉 ScreenDrag，按下/抬起照旧走 GUI，所以按钮与输入框不受影响。
func _input(event: InputEvent) -> void:
	if _modal == null or not _modal.visible or _scroll == null:
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		_dragging = touch.pressed
		_drag_last_y = touch.position.y
	elif event is InputEventScreenDrag and _dragging:
		var drag := event as InputEventScreenDrag
		_scroll.scroll_vertical -= int(drag.position.y - _drag_last_y)
		_drag_last_y = drag.position.y
		get_viewport().set_input_as_handled()


func _wire_touch_focus(field: Control) -> void:
	field.gui_input.connect(_on_field_gui_input.bind(field))


func _on_field_gui_input(event: InputEvent, field: Control) -> void:
	if event is InputEventScreenTouch and (event as InputEventScreenTouch).pressed:
		field.grab_focus()
		field.accept_event()


func _make_provider_box() -> OptionButton:
	_provider_box = OptionButton.new()
	_provider_ids = CatalogScript.ids()
	for i in _provider_ids.size():
		_provider_box.add_item(CatalogScript.label_of(String(_provider_ids[i])), i)
	_provider_box.custom_minimum_size = Vector2(560.0, 34.0)
	_provider_box.theme = _theme_of(14)
	_provider_box.item_selected.connect(_on_provider_selected)
	# 下拉列表是独立 Window，不继承 _modal 的主题，得单独挂一份，否则列表项还是豆腐块
	_provider_box.get_popup().theme = _panel_theme
	return _provider_box


func _make_spin(minimum: int, maximum: int, step: int, value: int) -> SpinBox:
	var s := SpinBox.new()
	s.min_value = minimum
	s.max_value = maximum
	s.step = step
	s.value = value
	s.custom_minimum_size = Vector2(180.0, 34.0)
	s.theme = _theme_of(14)
	return s


func _action(text: String, handler: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(150.0, 40.0)
	b.theme = _theme_of(14)
	b.pressed.connect(handler)
	return b


# ────────────────────────────── 交互 ──────────────────────────────

func _on_enable_toggled(pressed: bool) -> void:
	advisor.enabled = pressed
	advisor.save_config()
	_refresh()


func _on_provider_selected(index: int) -> void:
	if index < 0 or index >= _provider_ids.size():
		return
	advisor.provider_id = String(_provider_ids[index])
	# 换供应商时把模型名交还给「默认」——否则会拿 A 家的模型名去请求 B 家
	advisor.model = ""
	advisor.save_config()
	_refresh()


func _on_model_changed(text: String) -> void:
	advisor.model = text.strip_edges()
	advisor.save_config()
	_refresh_status()


func _on_base_changed(text: String) -> void:
	advisor.base_url_override = text.strip_edges()
	advisor.save_config()
	_refresh_status()


func _on_max_tokens_changed(value: float) -> void:
	advisor.max_tokens_per_call = int(value)
	advisor.save_config()
	_refresh_status()


func _on_budget_match_changed(value: float) -> void:
	advisor.budget_tokens_per_match = int(value)
	advisor.save_config()
	_refresh_status()


func _on_budget_day_changed(value: float) -> void:
	advisor.budget_tokens_per_day = int(value)
	advisor.save_config()
	_refresh_status()


func _on_auto_toggled(pressed: bool) -> void:
	advisor.auto_debrief = pressed
	advisor.save_config()


func _on_save_key() -> void:
	if advisor.set_api_key(_key_edit.text):
		_key_edit.text = ""
		_output.text = "已保存 API key（只存在本机，界面只显示头尾）。"
	else:
		_output.text = "保存失败：写不了本机文件。"
	_refresh()


func _on_clear_key() -> void:
	if not _clear_armed:
		_clear_armed = true
		_clear_button.text = "再点一次确认清除"
		_output.text = "清除 API key 需要再点一次确认（防误触）。"
		return
	_clear_armed = false
	_clear_button.text = "清除 key"
	advisor.clear_api_key()
	_key_edit.text = ""
	_output.text = "已清除 API key。"
	_refresh()


func _on_request_debrief() -> void:
	var blocked: String = advisor.request_debrief()
	if blocked != "":
		_output.text = "暂时不能复盘：%s" % blocked


func _on_close() -> void:
	_modal.visible = false


func _on_export_csv() -> void:
	var path: String = advisor.export_csv()
	if path == "":
		_output.text = "还没有用量记录可导出。"
		return
	_output.text = "已导出 CSV：%s\n（Android 上是应用私有目录，可用「文件」应用或 adb 取走）" % path


func _on_clear_records() -> void:
	var removed: int = advisor.clear_records()
	_output.text = "已清空本地记录（删除 %d 个账本文件）。" % removed
	_refresh()


func _on_debrief_started() -> void:
	_output.text = "正在请求复盘…（网络往返通常 2~8 秒）"
	_refresh()


func _on_debrief_finished(ok: bool, text: String, _entry: Dictionary) -> void:
	if ok:
		_output.text = text
	else:
		_output.text = "复盘失败：%s" % advisor.last_error()
	_refresh()


func _on_usage_changed() -> void:
	if _modal.visible:
		_refresh()


# ────────────────────────────── 刷新 ──────────────────────────────

func _refresh() -> void:
	if advisor == null:
		return
	_enable_box.set_pressed_no_signal(advisor.enabled)
	_auto_box.set_pressed_no_signal(advisor.auto_debrief)
	var idx: int = _provider_ids.find(advisor.provider_id)
	if idx >= 0:
		_provider_box.select(idx)
	if not _model_edit.has_focus():
		_model_edit.text = advisor.model
	if not _base_edit.has_focus():
		_base_edit.text = advisor.base_url_override
	_max_tokens_box.set_value_no_signal(advisor.max_tokens_per_call)
	_budget_match_box.set_value_no_signal(advisor.budget_tokens_per_match)
	_budget_day_box.set_value_no_signal(advisor.budget_tokens_per_day)
	_key_state.text = "当前 key：%s" % advisor.key_display()
	_refresh_status()
	_usage_label.text = advisor.usage_text()
	if _output.text == "":
		if not advisor.has_snapshot():
			_output.text = "还没有可复盘的战局 —— 先打完一局再回来。"
		else:
			_output.text = "本局已结束，可以请求复盘。"


func _refresh_status() -> void:
	if advisor == null:
		return
	var hint: String = "｜ 本次预计约 %d token" % advisor.estimated_call_tokens()
	_status_label.text = "状态：%s%s" % [advisor.status_text(), hint]
	_status_label.add_theme_color_override("font_color",
			Color(0.6, 0.95, 0.7) if advisor.can_request() == "" else Color(1.0, 0.75, 0.5))
	_request_button.disabled = advisor.can_request() != "" or advisor.is_busy()
