extends "res://ui/screens/ScreenBase.gd"

## 模式选择（docx 11.4 大厅的模式列表 + 22.10 第一版范围）
##
## 列表按 11.4 列全 6 个模式，但只有 22.10 拍板的第一版 3 个可选，其余置灰并写明理由——
## 置灰不是偷懒，是让玩家看得出「文档里有、这版还没做」，而不是以为按钮坏了。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const RoleTableScript := preload("res://data/config/RoleTable.gd")

## 6 个模式按钮：紧凑按钮高 36（门禁点按下限 32）+ 5 条间距。
## 这个高度是**量过**的：整屏可用 540-40(边距)-48(页眉)-12-1-12 = 427。
## 普通按钮的最小高度是 44（上下内边距各 10 + 一行 16 号字），6 项就是 264，
## 加上标签与内边距把 MarginContainer 顶到 546 —— 几何门禁直接报「出屏 6 px」。
## 所以这里必须用 compact_button（内边距收到 5），而不是把 size.y 改小。
const MODE_BUTTON_SIZE := Vector2(360.0, 36.0)

var _mode_id := 0
var _buttons: Dictionary = {}
var _detail: VBoxContainer = null
var _start_button: Button = null


func screen_id() -> String:
	return "modes"


func screen_title() -> String:
	return "模式选择"


func _build_content(body: VBoxContainer) -> void:
	_mode_id = ctx.settings.default_mode if ctx != null and ctx.settings != null \
			else ModeTableScript.default_mode_id()

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(row)

	var left := UiKit.panel_box("模式（11.4 大厅列表）")
	left.custom_minimum_size = Vector2(384.0, 0.0)
	row.add_child(left)
	var list := UiKit.content_of(left)

	for entry in ModeTableScript.all():
		var mode_id := int(entry["id"])
		var available := bool(entry["available"])
		var b := UiKit.compact_button(_mode_label(entry), MODE_BUTTON_SIZE)
		b.name = "Mode%d" % mode_id
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.disabled = not available
		if not available:
			b.tooltip_text = String(entry.get("locked_reason", "后续版本"))
		b.pressed.connect(_on_mode_pressed.bind(mode_id))
		list.add_child(b)
		_buttons[mode_id] = b
	list.add_child(UiKit.spacer(0.0, true))

	var right := UiKit.panel_box()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(right)
	_detail = UiKit.content_of(right)

	# ── 底部：本局配置一行 + 开始对局 ──────────────────────────────
	var bottom := UiKit.panel_box()
	body.add_child(bottom)
	var foot := UiKit.content_of(bottom)
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 12)
	foot.add_child(line)
	var s = ctx.settings if ctx != null else null
	var mode_enemies := ModeTableScript.enemy_count(_mode_id)
	var enemy_text := ("%d（模式）" % mode_enemies) if mode_enemies > 0 \
			else str(s.default_enemy_count if s != null else 0)
	var summary := "兵种：%s ｜ 载具：%s ｜ 敌人数：%s ｜ 时长：%d 分钟" % [
		RoleTableScript.role_name(s.default_role if s != null else RoleTableScript.Role.RIFLEMAN),
		ctx.vehicle_name(s.default_vehicle) if (ctx != null and s != null) else "默认",
		enemy_text,
		int(round(ModeTableScript.duration_s(_mode_id) / 60.0))]
	var info := UiKit.label(summary, UiKit.BODY_SIZE, UiKit.COLOR_DIM)
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.clip_text = true
	line.add_child(info)

	_start_button = UiKit.button("开始对局", Vector2(180.0, 48.0))
	_start_button.name = "StartMatchButton"
	_start_button.pressed.connect(_on_start_match)
	line.add_child(_start_button)

	_refresh_detail()


func on_enter() -> void:
	refresh_navigation()
	_refresh_detail()


func _mode_label(entry: Dictionary) -> String:
	var tag := String(entry.get("tag", ""))
	if bool(entry["available"]):
		return "%s   （%s）" % [String(entry["name"]), tag]
	return "%s   （%s · 不能选）" % [String(entry["name"]), tag]


func _on_mode_pressed(mode_id: int) -> void:
	if not ModeTableScript.is_available(mode_id):
		return
	_mode_id = mode_id
	_refresh_detail()


func _refresh_detail() -> void:
	if _detail == null:
		return
	for child in _detail.get_children():
		_detail.remove_child(child)
		child.queue_free()

	var available := ModeTableScript.is_available(_mode_id)
	if _start_button != null:
		_start_button.disabled = not available
		_start_button.text = "开始对局" if available else "该模式尚不可选"

	_detail.add_child(UiKit.label(ModeTableScript.name_of(_mode_id), UiKit.HEADING_SIZE))
	_detail.add_child(UiKit.row("规则", ModeTableScript.tag_of(_mode_id)))
	if not available:
		_detail.add_child(UiKit.row("状态", "后续版本（22.10 降级清单）", UiKit.COLOR_DANGER))
		_detail.add_child(UiKit.wrapped(ModeTableScript.locked_reason(_mode_id), UiKit.SMALL_SIZE,
				UiKit.COLOR_DANGER))
	_detail.add_child(UiKit.divider())
	# 说明与出处一律用 SMALL_SIZE：详情面板的高度要跟左侧 6 个模式按钮一起塞进整屏
	_detail.add_child(UiKit.wrapped(ModeTableScript.desc_of(_mode_id), UiKit.SMALL_SIZE,
			UiKit.COLOR_TEXT))
	_detail.add_child(UiKit.divider())
	_detail.add_child(UiKit.row("时长", "%d 分钟" % int(round(ModeTableScript.duration_s(_mode_id) / 60.0))))
	_detail.add_child(UiKit.row("加时",
			"%d 分钟" % int(round(ModeTableScript.overtime_s(_mode_id) / 60.0))
			if ModeTableScript.uses_overtime(_mode_id) else "无（无平局）"))
	_detail.add_child(UiKit.row("AI 参谋",
			"关闭" if ModeTableScript.competitive(_mode_id) else "开放",
			UiKit.COLOR_DANGER if ModeTableScript.competitive(_mode_id) else UiKit.COLOR_TEXT))
	_detail.add_child(UiKit.divider())
	_detail.add_child(UiKit.wrapped(ModeTableScript.flags_of(_mode_id), UiKit.SMALL_SIZE))
	_detail.add_child(UiKit.wrapped("出处：" + ModeTableScript.source_of(_mode_id),
			UiKit.SMALL_SIZE, UiKit.COLOR_LOCKED))


func _on_start_match() -> void:
	if not ModeTableScript.is_available(_mode_id):
		return
	if ctx != null:
		ctx.start_match(_mode_id)
