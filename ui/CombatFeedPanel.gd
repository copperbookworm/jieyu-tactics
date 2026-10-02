extends RichTextLabel

## HUD 顶部战斗播报面板（docx 4.14，候选 O 第一轮）
##
## 视图 + 事件接线；规则在 systems/hud/CombatFeed.gd（纯逻辑，可单测）。
## 这里也是**播报的唯一订阅点**——各系统不用自己接线，具体来源：
##   ① 既有 EventBus 信号：击倒敌人 / 旗点易手 / 玩家阵亡 / 战局结束
##   ② main.quests 的 quest_completed / quest_failed（4.10 任务系统）
##   ③ 载具与工事的 wrecked 信号（Vehicle / Fob），在 setup 时按引用与组查询挂上
##   ④ 少数几个「没有信号可挂」的模块（间瞄 / 补给 / 侧翼通路）由它们自己调
##      main.hud.push_feed()——与既有的 main.hud.show_hint() 同一套写法
##
## 未做（4.14 其余要求）：音频提示（10 音频）、战术地图图标联动、VIP 自定义播报样式。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CombatFeedScript := preload("res://systems/hud/CombatFeed.gd")

const GREEN := Color(0.55, 1.0, 0.6)
const RED := Color(1.0, 0.45, 0.4)
const GOLD := Color(1.0, 0.85, 0.4)
const BLUE := Color(0.5, 0.75, 1.0)
const CYAN := Color(0.5, 0.9, 1.0)
const ORANGE := Color(1.0, 0.6, 0.3)
const GREY := Color(0.75, 0.75, 0.75)

var main = null
var feed = null


func setup(main_node) -> void:
	main = main_node
	feed = CombatFeedScript.new()
	bbcode_enabled = true
	scroll_active = false
	fit_content = false
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	# 位置：顶部中间那块空地（左有操作说明行、左下是占领 HUD 与任务卡片，右上是小地图）
	position = Vector2(GameConfig.VIEWPORT_WIDTH * 0.5 - 180.0, 34.0)
	size = Vector2(360.0, 110.0)
	add_theme_font_size_override("normal_font_size", 15)
	add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.85))
	add_theme_constant_override("outline_size", 4)
	_wire()


func _wire() -> void:
	if EventBus != null and EventBus.has_signal("enemy_killed"):
		EventBus.connect("enemy_killed", _on_enemy_killed)
	if EventBus != null and EventBus.has_signal("flag_state_changed"):
		EventBus.connect("flag_state_changed", _on_flag_state_changed)
	if EventBus != null and EventBus.has_signal("player_downed"):
		EventBus.connect("player_downed", _on_player_downed)
	if EventBus != null and EventBus.has_signal("player_died"):
		EventBus.connect("player_died", _on_player_died)
	if EventBus != null and EventBus.has_signal("match_finished"):
		EventBus.connect("match_finished", _on_match_finished)
	if main != null and main.quests != null:
		main.quests.quest_completed.connect(_on_quest_completed)
		main.quests.quest_failed.connect(_on_quest_failed)
	if main != null and main.vehicles != null:
		for node in [main.vehicles.vehicle, main.vehicles.enemy_vehicle]:
			if node != null and node.has_signal("wrecked"):
				node.wrecked.connect(_on_vehicle_wrecked)
	if main != null:
		for node in main.get_tree().get_nodes_in_group("fob_enemy"):
			if node.has_signal("wrecked"):
				node.wrecked.connect(_on_fob_wrecked)


## 外部入口：任何模块都能往播报里塞一条（供 main.hud.push_feed 转发）
func push(kind: String, text: String, color: Color = Color.WHITE) -> void:
	if feed != null:
		feed.push(kind, text, color)


func tick(delta: float) -> void:
	if feed == null:
		return
	feed.tick(delta)
	text = feed.to_bbcode()


func _on_enemy_killed(_enemy) -> void:
	push("kill", "击倒敌人", GREEN)


func _on_flag_state_changed(zone_name, state) -> void:
	# CaptureZone.State：NEUTRAL=0 / BLUE=1 / RED=2（不引类名，避免多一层编译期依赖）
	var side := int(state)
	if side == 1:
		push("flag:%s" % String(zone_name), "节点 %s 已控制" % String(zone_name), BLUE)
	elif side == 2:
		push("flag:%s" % String(zone_name), "节点 %s 失守" % String(zone_name), RED)
	else:
		push("flag:%s" % String(zone_name), "节点 %s 变成白旗" % String(zone_name), GREY)


## 4.16：倒地不再是「已阵亡」，播报里要说清还有机会（第一版单机没人来扶 = 60 s 后阵亡）
func _on_player_downed() -> void:
	push("downed", "你已倒地：%.0f s 内无人扶起将阵亡" % GameConfig.DOWNED_TIMEOUT, ORANGE)


func _on_player_died() -> void:
	push("death", "你已阵亡", RED)


func _on_match_finished(winner) -> void:
	var player_won := String(winner) == "player"
	push("match", "战斗结束：我方胜利" if player_won else "战斗结束：我方失败",
			GREEN if player_won else RED)


func _on_quest_completed(quest_data: Dictionary) -> void:
	push("quest_done", "任务完成：%s（+%d 战力分）" % [String(quest_data.get("name", "")),
			int(quest_data.get("reward", 0))], GOLD)


func _on_quest_failed(quest_data: Dictionary) -> void:
	push("quest_fail", "任务失败：%s" % String(quest_data.get("name", "")), ORANGE)


func _on_vehicle_wrecked(vehicle) -> void:
	var mine: bool = main != null and main.vehicles != null \
			and vehicle == main.vehicles.vehicle
	push("vehicle", "我方载具被摧毁" if mine else "击毁敌方载具", RED if mine else GREEN)


func _on_fob_wrecked(_fob) -> void:
	push("fob", "敌方 FOB 被摧毁（+20 战力分）", GOLD)
