extends Node

## 报点 / 标记链（2026-09-30 候选 N：从 Main.gd 拆出）
## 负责：轮盘报点（落点＝准心）、地图选点报点、通视与距离红线（4.11.2）、把事件喂给任务系统。
## 提示文字统一走 main.hud.show_hint()（HUD 归 HudBuilder）；标记存在于 main.marks。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

var main = null
var marks: MarkSystem = null


func setup(main_node, marks_system: MarkSystem) -> void:
	main = main_node
	marks = marks_system


## 轮盘报点：落点＝准心世界坐标（准心已被地形钳制，天然满足 4.11.2 的「通视前提」）
func place_at_crosshair(type: int) -> void:
	if main.camera_controller == null or marks == null:
		return
	if main.camera_controller.blocked_by_terrain:
		# 红线：报点需通视——看不见的地方不许标（docx 4.11.2）
		main.hud.show_hint("视线被地形挡住，无法报点")
		return
	_add(type, main.camera_controller.crosshair_world)


## 地图上落报点（docx 4.11.3：选类型 → 点位置 → 广播）
## 红线同样是「通视前提」：落点必须从玩家位置看得见，否则拒绝
func place_at(type: int, position: Vector2) -> void:
	if marks == null:
		return
	if not is_reachable(position):
		if main.hud.tactical_map != null:
			main.hud.tactical_map.show_hint("没有通视或被地形挡住，无法报点")
		return
	_add(type, position)
	if main.hud.tactical_map != null:
		main.hud.tactical_map.show_hint("已报点：%s（%.0f s）" % [MarkSystem.type_label(type),
				RoleTable.mark_duration(main.player_role)])


## 从玩家到落点：距离在拖拽上限内 + 地形通视（与准心同一口径）
func is_reachable(position: Vector2) -> bool:
	if main.sight == null or main.player == null:
		return false
	if main.player.global_position.distance_to(position) \
			> GameConfig.SIGHT_MAX_DISTANCE_INFANTRY:
		return false
	# main 是鸭子类型（Variant）：这里必须显式标 float，:= 推断不出来
	var origin_height: float = main.sight.eye_height_at(main.player.global_position)
	var target_height: float = main.sight.eye_height_at(position)
	return not main.sight.terrain_first_blocker(main.player.global_position, origin_height,
			position, target_height, GameConfig.CROSSHAIR_SIGHT_MARGIN_PER_METER)["blocked"]


## 落标记 + 通知任务系统（支线「侦察标记」靠它推进）
func _add(type: int, position: Vector2) -> void:
	marks.add_mark(type, position, RoleTable.mark_duration(main.player_role))
	if main.quests != null:
		main.quests.notify_mark_placed(position)
	main.hud.show_hint("已报点：%s（%.0f s）" % [MarkSystem.type_label(type),
			RoleTable.mark_duration(main.player_role)])
