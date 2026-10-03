extends "res://ui/screens/ScreenBase.gd"

## 游戏设置（docx 4.15 与 20 章欠的两块界面 + 使用者 2026-10-03 拍板的设置项）
##
## 这一屏把工程里**早就留了 API 却没有界面**的两处补齐（可查证）：
##   · systems/audio/AudioSystem.gd 头部：「未做：…音量设置界面」
##   · ui/HudBuilder.gd set_tips_enabled：「docx 4.15「可在设置关闭」；设置界面后置，先给 API」
## 另外三块：AI 参谋开关与入口、对局默认值、本地数据与关于。
##
## 三列布局：每列一个面板，列宽 292 × 3 + 间距 = 900 <= 920（960 减去左右 20 边距）。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const RoleTableScript := preload("res://data/config/RoleTable.gd")
const SettingsScript := preload("res://systems/settings/GameSettings.gd")

const COLUMN_WIDTH := 292.0
const ACTION_SIZE := Vector2(260.0, 40.0)

var _volume: HSlider = null
var _mute: CheckBox = null
var _tips: CheckBox = null
var _competitive: CheckBox = null
var _advisor_note: Label = null
var _mode_option: OptionButton = null
var _role_option: OptionButton = null
var _vehicle_option: OptionButton = null
var _enemy_spin: SpinBox = null
var _seed_spin: SpinBox = null
var _data_note: Label = null

var _mode_ids: Array = []
var _role_ids: Array = []
var _vehicle_ids: Array = []


func screen_id() -> String:
	return "settings"


func screen_title() -> String:
	return "游戏设置"


func _build_content(body: VBoxContainer) -> void:
	var s = ctx.settings if ctx != null else null

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(row)

	# ── 列 1：音频 / 界面 / 关于 ──────────────────────────────────
	var col1_panel := UiKit.panel_box()
	col1_panel.custom_minimum_size = Vector2(COLUMN_WIDTH, 0.0)
	col1_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col1_panel)
	var col1 := UiKit.content_of(col1_panel)

	col1.add_child(UiKit.label("音频", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))
	_volume = UiKit.slider(0.0, 1.0, s.master_volume if s != null else 1.0)
	_volume.name = "VolumeSlider"
	_volume.value_changed.connect(_on_volume_changed)
	col1.add_child(UiKit.control_row("音量", _volume))
	_mute = UiKit.check_box("静音", s.muted if s != null else false)
	_mute.name = "MuteCheck"
	_mute.toggled.connect(_on_mute_toggled)
	col1.add_child(_mute)

	col1.add_child(UiKit.divider())
	col1.add_child(UiKit.label("界面", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))
	_tips = UiKit.check_box("对局操作提示（4.15）", s.tips_enabled if s != null else true)
	_tips.name = "TipsCheck"
	_tips.toggled.connect(_on_tips_toggled)
	col1.add_child(_tips)

	col1.add_child(UiKit.divider())
	col1.add_child(UiKit.label("关于", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))
	col1.add_child(UiKit.row("版本", ctx.version_text() if ctx != null else "未知"))
	col1.add_child(UiKit.row("引擎", String(Engine.get_version_info().get("string", ""))))
	col1.add_child(UiKit.row("分辨率", "%d × %d" % [int(UiKit.VIEW.x), int(UiKit.VIEW.y)]))
	col1.add_child(UiKit.spacer(0.0, true))

	# ── 列 2：AI 参谋 ────────────────────────────────────────────
	var col2_panel := UiKit.panel_box()
	col2_panel.custom_minimum_size = Vector2(COLUMN_WIDTH, 0.0)
	col2_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col2_panel)
	var col2 := UiKit.content_of(col2_panel)

	col2.add_child(UiKit.label("AI 参谋", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))
	_competitive = UiKit.check_box("竞技模式（关闭 AI 参谋）",
			ctx.advisor_competitive() if ctx != null else false)
	_competitive.name = "CompetitiveCheck"
	_competitive.toggled.connect(_on_competitive_toggled)
	col2.add_child(_competitive)
	_advisor_note = UiKit.wrapped("", UiKit.SMALL_SIZE)
	col2.add_child(_advisor_note)

	var open_panel := UiKit.button("打开 AI 参谋面板", ACTION_SIZE)
	open_panel.name = "OpenAdvisorButton"
	open_panel.pressed.connect(_on_open_advisor)
	col2.add_child(open_panel)

	col2.add_child(UiKit.divider())
	col2.add_child(UiKit.wrapped(
			"AI 参谋在局后复盘。不填 API key 就完全不联网、不花 token。",
			UiKit.SMALL_SIZE, UiKit.COLOR_DIM))
	col2.add_child(UiKit.spacer(0.0, true))

	# ── 列 3：对局默认 / 本地数据 ─────────────────────────────────
	var col3_panel := UiKit.panel_box()
	col3_panel.custom_minimum_size = Vector2(COLUMN_WIDTH, 0.0)
	col3_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col3_panel)
	var col3 := UiKit.content_of(col3_panel)

	col3.add_child(UiKit.label("对局默认值", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))

	var mode_names: Array = []
	_mode_ids.clear()
	for mode_id in ModeTableScript.available_ids():
		_mode_ids.append(mode_id)
		mode_names.append(ModeTableScript.name_of(mode_id))
	_mode_option = UiKit.option_button(mode_names,
			_mode_ids.find(s.default_mode if s != null else -1))
	_mode_option.name = "ModeOption"
	_mode_option.item_selected.connect(_on_mode_selected)
	col3.add_child(UiKit.control_row("模式", _mode_option))

	var role_names: Array = []
	_role_ids.clear()
	for entry in RoleTableScript.ROLES:
		_role_ids.append(int(entry["id"]))
		role_names.append(String(entry["name"]))
	_role_option = UiKit.option_button(role_names,
			_role_ids.find(s.default_role if s != null else -1))
	_role_option.name = "RoleOption"
	_role_option.item_selected.connect(_on_role_selected)
	col3.add_child(UiKit.control_row("兵种", _role_option))

	var vehicle_labels: Array = []
	_vehicle_ids = ctx.vehicle_ids() if ctx != null else []
	if _vehicle_ids.is_empty():
		_vehicle_ids = ["ifv_a"]
	for vehicle_id in _vehicle_ids:
		vehicle_labels.append(ctx.vehicle_name(String(vehicle_id)) if ctx != null else String(vehicle_id))
	_vehicle_option = UiKit.option_button(vehicle_labels,
			_vehicle_ids.find(s.default_vehicle if s != null else ""))
	_vehicle_option.name = "VehicleOption"
	_vehicle_option.item_selected.connect(_on_vehicle_selected)
	col3.add_child(UiKit.control_row("载具", _vehicle_option))

	_enemy_spin = UiKit.spin(1, SettingsScript.ENEMY_MAX, s.default_enemy_count if s != null else 2)
	# 模式已规定人数时（PVP 20 / PVEVP 30）这里只是回退值 —— 兵棋等未定模式才用它
	_enemy_spin.name = "EnemySpin"
	_enemy_spin.value_changed.connect(_on_enemy_changed)
	col3.add_child(UiKit.control_row("敌人数", _enemy_spin))

	_seed_spin = UiKit.spin(0, 2147483647, s.default_map_seed if s != null else 0)
	_seed_spin.name = "SeedSpin"
	_seed_spin.value_changed.connect(_on_seed_changed)
	col3.add_child(UiKit.control_row("地图种子", _seed_spin))

	col3.add_child(UiKit.divider())
	col3.add_child(UiKit.label("本地数据", UiKit.HEADING_SIZE, UiKit.COLOR_ACCENT))
	var clear_ledger := UiKit.button("清空 AI 用量账本", ACTION_SIZE)
	clear_ledger.name = "ClearLedgerButton"
	clear_ledger.pressed.connect(_on_clear_ledger)
	col3.add_child(clear_ledger)
	var clear_key := UiKit.button("清除 API key", ACTION_SIZE)
	clear_key.name = "ClearKeyButton"
	clear_key.pressed.connect(_on_clear_key)
	col3.add_child(clear_key)
	_data_note = UiKit.wrapped("", UiKit.SMALL_SIZE)
	col3.add_child(_data_note)
	col3.add_child(UiKit.spacer(0.0, true))

	_refresh_notes()


func on_enter() -> void:
	refresh_navigation()
	_sync_from_settings()
	_refresh_notes()


## 界面上的值跟着当前设置走（从别的屏回来时可能已经被改过）
func _sync_from_settings() -> void:
	if ctx == null or ctx.settings == null:
		return
	var s = ctx.settings
	if _volume != null:
		_volume.set_value_no_signal(s.master_volume)
	if _mute != null:
		_mute.set_pressed_no_signal(s.muted)
	if _tips != null:
		_tips.set_pressed_no_signal(s.tips_enabled)
	if _competitive != null:
		_competitive.set_pressed_no_signal(ctx.advisor_competitive())
	if _mode_option != null:
		_mode_option.select(maxi(_mode_ids.find(s.default_mode), 0))
	if _role_option != null:
		_role_option.select(maxi(_role_ids.find(s.default_role), 0))
	if _vehicle_option != null:
		_vehicle_option.select(maxi(_vehicle_ids.find(s.default_vehicle), 0))
	if _enemy_spin != null:
		_enemy_spin.set_value_no_signal(s.default_enemy_count)
	if _seed_spin != null:
		_seed_spin.set_value_no_signal(s.default_map_seed)


func _refresh_notes() -> void:
	if _advisor_note != null and ctx != null and ctx.settings != null:
		var forced := ModeTableScript.competitive(ctx.settings.default_mode)
		_advisor_note.text = "当前默认模式「%s」在开局时会把开关设为：%s" % [
			ModeTableScript.name_of(ctx.settings.default_mode),
			"关闭" if forced else "开放"]
	if _data_note != null and _data_note.text == "":
		_data_note.text = "账本与密钥都只在这台设备上（user://）。"


## 每次改动都立刻应用 + 落盘：设置项没有「取消」，改了就是改了
func _commit() -> void:
	if ctx != null:
		ctx.apply_settings()
	_refresh_notes()


func _on_volume_changed(value: float) -> void:
	ctx.settings.set_volume(value)
	_commit()


func _on_mute_toggled(pressed: bool) -> void:
	ctx.settings.set_muted(pressed)
	_commit()


func _on_tips_toggled(pressed: bool) -> void:
	ctx.settings.set_tips_enabled(pressed)
	_commit()


func _on_competitive_toggled(pressed: bool) -> void:
	if ctx != null:
		ctx.set_advisor_competitive(pressed)
	_refresh_notes()


func _on_mode_selected(index: int) -> void:
	if index >= 0 and index < _mode_ids.size():
		ctx.settings.default_mode = int(_mode_ids[index])
		_commit()


func _on_role_selected(index: int) -> void:
	if index >= 0 and index < _role_ids.size():
		ctx.settings.default_role = int(_role_ids[index])
		_commit()


func _on_vehicle_selected(index: int) -> void:
	if index >= 0 and index < _vehicle_ids.size():
		ctx.settings.default_vehicle = String(_vehicle_ids[index])
		_commit()


func _on_enemy_changed(value: float) -> void:
	ctx.settings.default_enemy_count = int(round(value))
	_commit()


func _on_seed_changed(value: float) -> void:
	ctx.settings.default_map_seed = int(round(value))
	_commit()


func _on_open_advisor() -> void:
	if ctx != null:
		ctx.open_advisor_panel()


func _on_clear_ledger() -> void:
	if ctx == null:
		return
	var cleared: int = ctx.clear_usage_records()
	if _data_note != null:
		_data_note.text = "已清空 %d 条用量记录。" % cleared


func _on_clear_key() -> void:
	if ctx == null:
		return
	var cleared: bool = ctx.clear_api_key()
	if _data_note != null:
		_data_note.text = "已清除本机 API key。" if cleared else "本机没有存 key。"
