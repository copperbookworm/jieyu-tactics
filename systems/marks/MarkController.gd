extends Node

## 报点 / 标记链（2026-09-30 候选 N：从 Main.gd 拆出）
## 负责：轮盘报点（落点＝准心）、地图选点报点、通视与距离红线（4.11.2）、把事件喂给任务系统。
## 提示文字统一走 main.hud.show_hint()（HUD 归 HudBuilder）；标记存在于 main.marks。
##
## 2026-10-01 候选 O 第二轮：本模块同时是「局内沟通链」的宿主 —— 快捷指令（docx 4.13）的执行体
## commands 由这里创建（4.13 原文里「报点标记」与「快捷指令」本来就是并列的两条沟通路径），
## 这样 Main 不必再多一个子模块（Main 的 ≤400 行是硬验收线）。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const CommandControllerScript := preload("res://systems/comm/CommandController.gd")

var main = null
var marks: MarkSystem = null
var commands = null     ## CommandController（4.13 快捷指令）


func setup(main_node, marks_system: MarkSystem) -> void:
	main = main_node
	marks = marks_system
	commands = CommandControllerScript.new()
	commands.name = "CommandController"
	add_child(commands)
	commands.setup(main_node)


## 快捷指令入口（Main._wire_signals 把 CommandWheel.command_requested 接到这里）
func send_command(id: String) -> bool:
	return commands != null and commands.send(id)


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


## 从玩家到落点：距离在拖拽上限内 + 完整通视（地形 + 掩体 + 烟，与准心同一口径；2026-10-07 拍板 docx 19 ⑮）
func is_reachable(position: Vector2) -> bool:
	if main.sight == null or main.player == null:
		return false
	if main.player.global_position.distance_to(position) \
			> GameConfig.SIGHT_MAX_DISTANCE_INFANTRY:
		return false
	# main 是鸭子类型（Variant）：这里必须显式标 float，:= 推断不出来
	var origin_height: float = main.sight.eye_height_at(main.player.global_position)
	var target_height: float = main.sight.eye_height_at(position)
	# 2026-10-07 拍板（docx 19 ⑮）：与准心报点同口径 —— 地形 + 掩体 + 烟三层都算。
	# 原实现只查地形层（terrain_first_blocker），隔着掩体或烟在地图上能点进去，
	# 违反 4.11.2「报点需通视前提」的红线。
	return main.sight.has_sight(main.player.global_position, origin_height,
			position, target_height, GameConfig.CROSSHAIR_SIGHT_MARGIN_PER_METER)


## 落标记 + 通知任务系统（支线「侦察标记」靠它推进）
func _add(type: int, position: Vector2) -> void:
	marks.add_mark(type, position, RoleTable.mark_duration(main.player_role))
	if main.quests != null:
		main.quests.notify_mark_placed(position)
	main.hud.show_hint("已报点：%s（%.0f s）" % [MarkSystem.type_label(type),
			RoleTable.mark_duration(main.player_role)])
