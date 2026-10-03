extends "res://ui/screens/ScreenBase.gd"

## 对局结算屏 —— 打完一局之后「回大厅 / 再来一局」的落点
##
## 走 EventBus.match_finished（winner 由 MatchFlow 判定），所以三个模式共用这一屏：
## 竞技/休闲是占领数口径，PVEVP 是战术目标口径，这里只显示结论与理由。
##
## 刻意不写 class_name：引用方 preload。


const PANEL_WIDTH := 520.0

var _info: VBoxContainer = null
var _headline: Label = null


func screen_id() -> String:
	return "result"


func screen_title() -> String:
	return "对局结束"


func _build_content(body: VBoxContainer) -> void:
	var center := HBoxContainer.new()
	center.add_theme_constant_override("separation", 16)
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(center)
	center.add_child(UiKit.spacer(0.0, true))

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	center.add_child(column)

	var head_panel := UiKit.panel_box()
	head_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	column.add_child(head_panel)
	var head := UiKit.content_of(head_panel)
	_headline = UiKit.label("—", 26, UiKit.COLOR_TEXT)
	head.add_child(_headline)

	var info_panel := UiKit.panel_box("战报")
	info_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	column.add_child(info_panel)
	_info = UiKit.content_of(info_panel)

	var action_panel := UiKit.panel_box()
	action_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	column.add_child(action_panel)
	var actions := UiKit.content_of(action_panel)
	var again := UiKit.button("再来一局")
	again.name = "AgainButton"
	again.pressed.connect(_on_again)
	actions.add_child(again)
	var lobby := UiKit.button("返回大厅")
	lobby.name = "ResultBackToLobbyButton"
	lobby.pressed.connect(_on_back_to_lobby)
	actions.add_child(lobby)

	center.add_child(UiKit.spacer(0.0, true))


func on_enter() -> void:
	_refresh()
	refresh_navigation()


func _refresh() -> void:
	if ctx == null or _info == null:
		return
	var summary: Dictionary = ctx.match_summary()
	var outcome := String(summary.get("outcome", ""))
	if _headline != null:
		if outcome == "player":
			_headline.text = "胜利"
			_headline.add_theme_color_override("font_color", UiKit.COLOR_ACCENT)
		elif outcome == "enemy":
			_headline.text = "失败"
			_headline.add_theme_color_override("font_color", UiKit.COLOR_DANGER)
		elif outcome == "draw":
			_headline.text = "平局"
			_headline.add_theme_color_override("font_color", UiKit.COLOR_DIM)
		else:
			_headline.text = "对局已结束"

	for child in _info.get_children():
		_info.remove_child(child)
		child.queue_free()
	_info.add_child(UiKit.row("模式", String(summary.get("mode_name", "-"))))
	_info.add_child(UiKit.row("结束原因", String(summary.get("reason", "-"))))
	_info.add_child(UiKit.row("占领", String(summary.get("holds", "-"))))
	_info.add_child(UiKit.row("战力分", str(summary.get("score", 0))))
	_info.add_child(UiKit.row("主线任务", String(summary.get("quest", "无"))))


func _on_again() -> void:
	if ctx != null:
		ctx.restart_match()


func _on_back_to_lobby() -> void:
	if ctx != null:
		ctx.return_to_lobby()
