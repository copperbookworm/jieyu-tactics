extends "res://ui/screens/ScreenBase.gd"

## 游戏大厅（docx 11.4 对局外界面：大厅 = 模式选择 + 匹配 + 阵营选择 + 高光录像入口）
##
## 第一版落地范围（刻意收窄，写在界面上不假装）：
##   · 模式选择 → 真做（左转 modes 屏）
##   · 设置 / 玩法说明 / 关于 → 真做
##   · 匹配按钮 → 第一版无服务器（22.7 ① 不写任何网络代码），所以这里是「单机 + AI 填充」，
##     界面上写明，不做假的匹配动画
##   · 阵营选择 / 组队 / 好友 / 仓库 / 高光录像 → 未做，首页不列（列了就是空壳按钮）
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const RoleTableScript := preload("res://data/config/RoleTable.gd")

var _config_box: VBoxContainer = null
var _hint: Label = null


func screen_id() -> String:
	return "lobby"


func screen_title() -> String:
	return "解域 · JIEYU"


func _build_content(body: VBoxContainer) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(row)

	# ── 左：主菜单 ──────────────────────────────────────────────
	var left := UiKit.panel_box()
	left.custom_minimum_size = Vector2(300.0, 0.0)
	row.add_child(left)
	var menu := UiKit.content_of(left)

	menu.add_child(UiKit.wrapped("第一版垂直切片：占领节点、任务、载具、报点、烟雾、AI 参谋。", UiKit.SMALL_SIZE))
	menu.add_child(UiKit.spacer(6.0))

	var start := UiKit.button("开始游戏")
	start.name = "StartButton"
	start.pressed.connect(_on_start)
	menu.add_child(start)

	var settings := UiKit.button("设置")
	settings.name = "SettingsButton"
	settings.pressed.connect(_on_settings)
	menu.add_child(settings)

	var help := UiKit.button("玩法说明")
	help.name = "HelpButton"
	help.pressed.connect(_on_help)
	menu.add_child(help)

	var about := UiKit.button("关于")
	about.name = "AboutButton"
	about.pressed.connect(_on_about)
	menu.add_child(about)

	menu.add_child(UiKit.spacer(0.0, true))
	_hint = UiKit.wrapped("", UiKit.SMALL_SIZE, UiKit.COLOR_DIM)
	menu.add_child(_hint)

	# ── 右：本机配置（一屏说清「下一局会怎么开」）────────────────
	var right := UiKit.panel_box("下一局配置")
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(right)
	_config_box = UiKit.content_of(right)
	_refresh_config()


func on_enter() -> void:
	_refresh_config()


func _refresh_config() -> void:
	if _config_box == null:
		return
	_clear(_config_box)
	if ctx == null or ctx.settings == null:
		_config_box.add_child(UiKit.label("设置未就绪", UiKit.BODY_SIZE, UiKit.COLOR_DANGER))
		return
	var s = ctx.settings
	var mode_id: int = s.default_mode
	_config_box.add_child(UiKit.row("模式", ModeTableScript.name_of(mode_id)))
	_config_box.add_child(UiKit.row("规则", ModeTableScript.tag_of(mode_id)))
	_config_box.add_child(UiKit.divider())
	_config_box.add_child(UiKit.row("兵种", RoleTableScript.role_name(s.default_role)))
	_config_box.add_child(UiKit.row("载具", ctx.vehicle_name(s.default_vehicle)))
	# 模式已规定人数时显示模式值（2026-10-03 口径：PVP 20 / PVEVP 30），否则显示玩家设置
	var mode_enemies := ModeTableScript.enemy_count(mode_id)
	_config_box.add_child(UiKit.row("敌人数",
		("%d（模式）" % mode_enemies) if mode_enemies > 0 else ("%d（设置）" % s.default_enemy_count)))
	_config_box.add_child(UiKit.row("地图种子", str(s.default_map_seed)))
	_config_box.add_child(UiKit.divider())
	_config_box.add_child(UiKit.row("操作提示",
			"开" if s.tips_enabled else "关"))
	_config_box.add_child(UiKit.row("AI 参谋",
			"竞技模式会关闭" if ModeTableScript.competitive(mode_id) else "开放"))
	_config_box.add_child(UiKit.spacer(0.0, true))
	_config_box.add_child(UiKit.wrapped(
			"第一版没有服务器：对局由 AI 填充，选完模式直接开局。", UiKit.SMALL_SIZE))
	if _hint != null:
		_hint.text = "版本 %s" % ctx.version_text()


func _clear(box: Node) -> void:
	# 立刻摘出场景树再 queue_free：否则旧行会在本帧继续参与布局（几何门禁按可见性采集）
	for child in box.get_children():
		box.remove_child(child)
		child.queue_free()


# ── 菜单动作 ──────────────────────────────────────────────────────

func _on_start() -> void:
	if router != null:
		router.push("modes")


func _on_settings() -> void:
	if ctx != null:
		ctx.open_settings()


func _on_help() -> void:
	if ctx != null:
		ctx.open_info("controls")


func _on_about() -> void:
	if ctx != null:
		ctx.open_info("about")
