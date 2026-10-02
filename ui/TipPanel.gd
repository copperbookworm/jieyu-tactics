extends Label

## 局内操作提示者的 HUD 出口（docx 4.15，候选 O 第一轮）
##
## 规则（一次性 / 限频 / 待弹位 / 总开关）在 systems/hud/TipBook.gd（纯逻辑，可单测）；
## 本文件只做两件事：① 读 Main / Player 的现场状态，在「上升沿」请求提示
## ② 把当前该显示的那条渲染到屏幕上（底部居中、带黑描边）。
##
## 为什么感知放在这里：触发条件都要读运行时状态（准心遮挡 / 烟雾 / 载具 / 压制 / 血量），
## 放在 UI 层就不必让 Player / Enemy 为「教程提示」反向接线。
##
## 未做（4.15 其余要求）：设置界面里的开关（目前只有 set_enabled + GameConfig 默认值）、
## 与 4.9「行动前队内交流」的系统建议打通。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const TipBookScript := preload("res://systems/hud/TipBook.gd")

var main = null
var tips = null

var _was_blocked := false
var _was_in_smoke := false
var _was_in_vehicle := false
var _was_suppressed := false
var _was_low_hp := false


func setup(main_node) -> void:
	main = main_node
	tips = TipBookScript.new()
	position = Vector2(GameConfig.VIEWPORT_WIDTH * 0.5 - 200.0, 424.0)
	size = Vector2(400.0, 40.0)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.85))
	add_theme_constant_override("outline_size", 4)
	text = ""
	visible = false
	if main != null and main.quests != null:
		main.quests.quest_list_changed.connect(_on_quest_list_changed)
	if main != null and main.player != null:
		main.player.reload_started.connect(_on_reload_started)


func set_enabled(value: bool) -> void:
	if tips != null:
		tips.set_enabled(value)


func tick(delta: float) -> void:
	if tips == null or main == null or main.player == null:
		return
	_sense()
	tips.tick(delta)
	text = tips.current_text()
	visible = tips.is_showing()


## 事件驱动的两类触发（有信号可挂的）
func _on_quest_list_changed(_quests) -> void:
	if tips != null:
		tips.request("quest_updated")


func _on_reload_started() -> void:
	# 空仓换弹才提示：战术换弹是常规操作，不值得打断（4.15 是「首次遇到某机制」）
	if tips != null and main != null and main.player != null and main.player.ammo_in_mag <= 0:
		tips.request("reload_empty")


## 现场状态的四类触发（上升沿：只在「刚发生」那一帧请求）
func _sense() -> void:
	if tips == null or main == null or main.player == null or not main.player.alive:
		return
	var player = main.player
	# ① 准星被地形遮挡
	var blocked: bool = main.camera_controller != null 			and bool(main.camera_controller.blocked_by_terrain)
	if blocked and not _was_blocked:
		tips.request("terrain_block")
	_was_blocked = blocked
	# ② 进入烟雾区
	var in_smoke := _in_smoke()
	if in_smoke and not _was_in_smoke:
		tips.request("smoke_enter")
	_was_in_smoke = in_smoke
	# ③ 上车（含 AI 车不算：只看玩家占用）
	var in_vehicle := main.vehicles != null and main.vehicles.vehicle != null 			and bool(main.vehicles.vehicle.is_occupied())
	if in_vehicle and not _was_in_vehicle:
		tips.request("vehicle_enter")
	_was_in_vehicle = in_vehicle
	# ④ 被压制
	var suppressed: bool = float(player.suppression) >= GameConfig.TIP_SUPPRESSION
	if suppressed and not _was_suppressed:
		tips.request("suppressed")
	_was_suppressed = suppressed
	# ⑤ 血量过低
	var low_hp: bool = float(player.hp) <= GameConfig.TIP_LOW_HP
	if low_hp and not _was_low_hp:
		tips.request("low_hp")
	_was_low_hp = low_hp


## 玩家是否站在任一烟饼里（烟走独立分组，几何口径与 SightSystem.smoke_blocks 一致）
func _in_smoke() -> bool:
	var player = main.player
	for node in get_tree().get_nodes_in_group(GameConfig.SMOKE_GROUP):
		var radius_value = node.get("radius")
		var radius: float = float(radius_value) if radius_value != null else GameConfig.SMOKE_RADIUS
		if node.global_position.distance_to(player.global_position) <= radius:
			return true
	return false
