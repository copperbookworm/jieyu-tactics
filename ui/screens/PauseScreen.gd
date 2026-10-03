extends "res://ui/screens/ScreenBase.gd"

## 局内暂停菜单 —— 「界面跳转」在对局里的那一半
##
## 为什么暂停要**隐藏 HUD**而不是叠在上面：
##   HUD 的 22 个按钮与信息条平铺在同一层，暂停面板若叠上去，几何门禁会算出一堆
##   真实存在的重叠（暂停面板确实盖住了它们），那些重叠既不是 bug 也没法「修」。
##   把 HUD 收起来＝暂停时玩家本来也不该点那些战斗键，画面也更干净。
##   世界仍在渲染（Node2D 不是 HUD 的子节点），所以看起来是「冻结的战场 + 暂停菜单」。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")

const PANEL_WIDTH := 420.0

var _info: VBoxContainer = null


func screen_id() -> String:
	return "pause"


func screen_title() -> String:
	return "已暂停"


func _build_content(body: VBoxContainer) -> void:
	var center := HBoxContainer.new()
	center.add_theme_constant_override("separation", 16)
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(center)
	center.add_child(UiKit.spacer(0.0, true))

	var left := VBoxContainer.new()
	left.add_theme_constant_override("separation", 12)
	center.add_child(left)

	var info_panel := UiKit.panel_box("战局")
	info_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	left.add_child(info_panel)
	_info = UiKit.content_of(info_panel)

	var action_panel := UiKit.panel_box()
	action_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	left.add_child(action_panel)
	var actions := UiKit.content_of(action_panel)

	var resume := UiKit.button("继续对局")
	resume.name = "ResumeButton"
	resume.pressed.connect(_on_resume)
	actions.add_child(resume)

	var settings := UiKit.button("设置")
	settings.name = "PauseSettingsButton"
	settings.pressed.connect(_on_settings)
	actions.add_child(settings)

	var quit_to_lobby := UiKit.button("返回大厅")
	quit_to_lobby.name = "BackToLobbyButton"
	quit_to_lobby.pressed.connect(_on_back_to_lobby)
	actions.add_child(quit_to_lobby)

	center.add_child(UiKit.spacer(0.0, true))


func on_enter() -> void:
	refresh_navigation()
	_refresh_info()


func _refresh_info() -> void:
	if _info == null:
		return
	for child in _info.get_children():
		_info.remove_child(child)
		child.queue_free()
	if ctx == null:
		return
	var summary: Dictionary = ctx.match_summary()
	_info.add_child(UiKit.row("模式", String(summary.get("mode_name", "-"))))
	_info.add_child(UiKit.row("规则", String(summary.get("mode_tag", "-"))))
	_info.add_child(UiKit.row("剩余时间", String(summary.get("time_text", "-"))))
	_info.add_child(UiKit.row("占领", String(summary.get("holds", "-"))))
	_info.add_child(UiKit.row("重生预算", str(summary.get("budget", 0))))
	_info.add_child(UiKit.divider())
	_info.add_child(UiKit.wrapped("返回大厅会结束本局，进度不保留。", UiKit.SMALL_SIZE,
			UiKit.COLOR_DIM))


func _on_resume() -> void:
	if ctx != null:
		ctx.resume_match()


func _on_settings() -> void:
	if ctx != null:
		ctx.open_settings()


func _on_back_to_lobby() -> void:
	if ctx != null:
		ctx.return_to_lobby()
