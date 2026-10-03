extends SceneTree

## AI 参谋面板 · 几何自检（与 tools/geom_assertions.gd 同口径，针对独立 CanvasLayer）
##
## 为什么需要：面板挂在 AiAdvisor 这个 autoload 下面的 CanvasLayer(90) 里，
## 而 geom_assertions.gd 只从 Main.tscn 根往下扫 ⇒ 照不到它。
## 「没门禁」不等于「不用管」：这里补三条同口径断言 ——
##   ① 不出屏（视口 960x540）② 可点控件最短边 ≥ 32 px  ③ 入口按钮不压任何 HUD 实测矩形
## 第 ③ 条用的 HUD_RECTS 是 tools/hud_rects.gd 的实测输出；HUD 布局改了要同步这张表。
##
## 用法：godot --headless --path <proj> --log-file <可写路径> --script res://tools/ai_panel_check.gd

const AdvisorScript := preload("res://systems/ai/AiAdvisor.gd")
const PanelScript := preload("res://ui/AiAdvisorPanel.gd")

const VIEW_W := 960.0
const VIEW_H := 540.0
const MIN_TAP := 32.0
const SETTLE := 0.6
const CLICK_SIGNALS := ["pressed", "button_down", "button_up", "toggled"]

## name, x, y, w, h —— 来自 tools/hud_rects.gd 实测（2026-10-02）
const HUD_RECTS := [
	["Hint", 16, 12, 441, 23],
	["Joystick", 0, 340, 200, 200],
	["FireButton", 800, 380, 160, 160],
	["FocusButton", 680, 420, 120, 120],
	["Score", 802, 162, 71, 23],
	["MatchClock", 802, 210, 143, 23],
	["CaptureStatus", 16, 36, 156, 49],
	["QuestCard", 16, 60, 300, 96],
	["MarkWheel", 840, 188, 120, 120],
	["CommandWheel", 192, 208, 80, 40],
	["MarkHint", 360, 484, 414, 23],
	["CombatFeed", 300, 38, 360, 110],
	["TipPanel", 280, 424, 400, 40],
	["RoleButton", 16, 162, 80, 40],
	["Role", 280, 170, 500, 49],
	["PostureButton", 16, 208, 80, 40],
	["IndirectButton", 16, 254, 80, 40],
	["SmokeButton", 192, 254, 80, 40],
	["WeaponButton", 104, 162, 80, 40],
	["VehicleButton", 104, 208, 80, 40],
	["SeatButton", 104, 254, 80, 40],
	["AmmoTypeButton", 192, 162, 80, 40],
	["MapButton", 802, 234, 80, 44],
	["HP", 802, 186, 138, 23],
	["Ammo", 216, 510, 151, 23],
]

var _advisor = null
var _panel = null
var _passed := 0
var _failed := 0
var _elapsed := 0.0
var _stage := 0
var _done := false


func _initialize() -> void:
	print("===== AI 参谋面板 · 几何自检 =====")
	_advisor = AdvisorScript.new()
	_advisor.name = "AiAdvisorGeom"
	_advisor.models_cache_dir = "user://ai_usage_geom"
	root.add_child(_advisor)
	_panel = PanelScript.new()
	_panel.name = "AiAdvisorPanel"
	root.add_child(_panel)
	_panel.setup(_advisor)


func _process(delta: float) -> bool:
	if _done:
		return true
	_elapsed += delta
	if _elapsed < SETTLE:
		return false
	_elapsed = 0.0
	if _stage == 0:
		_stage = 1
		_check_closed()
		_panel._on_button_pressed()   # 打开面板
		return false
	_check_open()
	_check_model_row()
	_report()
	_done = true
	quit(0 if _failed == 0 else 1)
	return true


func _check_closed() -> void:
	var button: Button = _panel._button
	_check_true("入口按钮存在且可见", button != null and button.is_visible_in_tree())
	var r := button.get_global_rect()
	_check_true("入口按钮不出屏（%s）" % _rect_str(r), _inside(r))
	_check_true("入口按钮最短边 ≥ %.0f px" % MIN_TAP, minf(r.size.x, r.size.y) >= MIN_TAP)
	var hits := []
	for entry in HUD_RECTS:
		var hud := Rect2(float(entry[1]), float(entry[2]), float(entry[3]), float(entry[4]))
		if r.intersection(hud).size.x > 0.0 and r.intersection(hud).size.y > 0.0:
			hits.append("%s %s" % [entry[0], _rect_str(hud)])
	_check("入口按钮不压任何 HUD 控件（实测 %d 个矩形）" % HUD_RECTS.size(), hits, [])


func _check_open() -> void:
	var controls: Array = []
	_collect(_panel, controls)
	var offscreen := []
	var small := []
	for c in controls:
		var ctrl: Control = c
		var r := ctrl.get_global_rect()
		# ScrollContainer 里的内容本来就会超出可视区（靠滚动看）——只跳过位置检查，尺寸照查
		if not _inside(r) and not _inside_scroll(ctrl):
			offscreen.append("%s %s" % [ctrl.name, _rect_str(r)])
		if _is_clickable(ctrl) and minf(r.size.x, r.size.y) < MIN_TAP:
			small.append("%s %.0fx%.0f" % [ctrl.name, r.size.x, r.size.y])
	# 诊断线索：最小宽度超过滚动区（844）的控件，一定是把布局顶出屏幕的元凶
	var wide := []
	for c in controls:
		var m: Vector2 = (c as Control).get_combined_minimum_size()
		if m.x > 844.0:
			wide.append("%s min=%s" % [(c as Control).name, str(m)])
	if not wide.is_empty():
		print("— 最小宽度 > 844 的控件：" + " ｜ ".join(wide))
	_check("面板展开后：可见 Control %d 个，全部不出屏（滚动内容除外）" % controls.size(), offscreen, [])
	_check("面板展开后：可点控件最短边都 ≥ %.0f px" % MIN_TAP, small, [])
	var window: Control = _panel._modal.get_node("Window")
	_check_true("面板窗口不出屏（%s）" % _rect_str(window.get_global_rect()),
			_inside(window.get_global_rect()))


## 「可用模型」这一行的**行为**（几何之外）：按钮可用性必须跟着供应商走 ——
## 「选完供应商就自动填好」这件事如果按钮该灰的时候不灰，玩家会点了没反应还不知道为什么。
func _check_model_row() -> void:
	# ① 知名供应商：能同步 + 官方入口指向价格页
	_advisor.provider_id = "deepseek"
	_panel._refill_model_box()
	_check_true("deepseek：同步按钮可用", not (_panel._sync_button as Button).disabled)
	_check_true("deepseek：官方入口可用", not (_panel._official_button as Button).disabled)
	_check("deepseek：官方入口指向价格页", _panel._official_url,
			"https://api-docs.deepseek.com/zh-cn/quick_start/pricing")
	_check_true("deepseek：候选里有包内置的名字",
			(_panel._available_ids as Array).has("deepseek-flash"))
	_check_true("deepseek：提示行交代了可以同步",
			String((_panel._model_sync_note as Label).text).contains("同步"))

	# ② 自定义/中转站：没有统一的「列出模型」接口 ⇒ 两个按钮都置灰 + 文案说清要手填
	_advisor.provider_id = "custom"
	_panel._refill_model_box()
	_check_true("自定义：同步按钮置灰", (_panel._sync_button as Button).disabled)
	_check_true("自定义：官方入口也置灰", (_panel._official_button as Button).disabled)
	_check_true("自定义：提示行说要手动填",
			String((_panel._model_sync_note as Label).text).contains("手动填"))

	# ③ 玩家自己填的名字必须留在候选里 —— 否则同步一次就找不回手填的值（会被静默换掉）
	_advisor.provider_id = "deepseek"
	_advisor.model = "我自己填的-不在名单里"
	_panel._refill_model_box()
	_check_true("玩家自填的名字留在候选里",
			(_panel._available_ids as Array).has("我自己填的-不在名单里"))
	_advisor.model = ""
	_panel._refill_model_box()


func _collect(node: Node, out: Array) -> void:
	if node is Control:
		var c := node as Control
		if c.is_visible_in_tree():
			var r := c.get_global_rect()
			if r.size.x > 0.0 and r.size.y > 0.0:
				out.append(c)
	for child in node.get_children():
		_collect(child, out)


func _inside(r: Rect2) -> bool:
	return r.position.x >= -1.0 and r.position.y >= -1.0 \
			and (r.position.x + r.size.x) <= VIEW_W + 1.0 \
			and (r.position.y + r.size.y) <= VIEW_H + 1.0


func _inside_scroll(ctrl: Control) -> bool:
	var p := ctrl.get_parent()
	while p != null and p != _panel:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _is_clickable(ctrl: Control) -> bool:
	if ctrl is BaseButton:
		return true
	for sig in CLICK_SIGNALS:
		if ctrl.has_signal(sig):
			return true
	return false


func _rect_str(r: Rect2) -> String:
	return "(%.0f,%.0f %.0fx%.0f)" % [r.position.x, r.position.y, r.size.x, r.size.y]


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s\n       期望=%s\n       实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _report() -> void:
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
