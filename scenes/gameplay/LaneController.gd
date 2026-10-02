extends Node

## 侧翼通路控制器（候选 L4，docx 4.10.11 T-S6「守住侧翼通路」）
##
## 三件事：
##   ① 建一条侧翼通路（Lane，画在地图上；没发任务时画淡一层，让玩家认得这条侧翼）
##   ② 任务系统发出 T-S6 时，在通路入口放一队穿插兵，命令他们沿通路推进到出口
##   ③ 每帧看：有人穿过走廊 → 任务失败；穿插兵全被清掉 → 任务提前达成
## 沿用候选 N 的分工：任务系统只认事件（notify_lane_breached / notify_lane_secured），
## 世界实体与流程都在本模块。
## 第一版不做寻路（直线推进）——地图上没有阻挡体，NavigationAgent2D 等有障碍再上。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const LaneScript := preload("res://entities/lane/Lane.gd")

var main = null
var lane = null                 # Lane
var infiltrators: Array = []    # 本次派出的穿插兵（Enemy）
var _resolved := false          # 本次已经出结果（失败 / 达成），不重复上报


func setup(main_node) -> void:
	main = main_node
	var points := MapGenerator.demo_flank_lane()
	lane = LaneScript.new()
	lane.name = "FlankLane"
	main.add_child(lane)
	lane.setup(points[0], points[1])
	# 任务列表一变就看看有没有「守住侧翼通路」（任务系统在战局事件上会重发列表）
	if main.quests != null and not main.quests.quest_list_changed.is_connected(_on_quests_changed):
		main.quests.quest_list_changed.connect(_on_quests_changed)


func _on_quests_changed(quest_list: Array) -> void:
	if _resolved or not infiltrators.is_empty():
		return
	for quest in quest_list:
		if String(quest["id"]) == "T-S6":
			_dispatch()
			return


## 在通路入口放穿插兵：沿通路推进到出口（进了「发现距离」还是会跟玩家交火，见 Enemy AI）
func _dispatch() -> void:
	if lane == null:
		return
	for i in GameConfig.LANE_INFILTRATORS:
		var enemy := Enemy.new()
		enemy.name = "Infiltrator%d" % (i + 1)
		enemy.global_position = lane.entry_position + Vector2(0.0, (i - 1) * 14.0)
		enemy.move_speed = GameConfig.LANE_INFILTRATOR_SPEED
		main.add_child(enemy)
		enemy.setup(main.sight, main.player, main.camera, main.grid)
		enemy.set_move_target(lane.exit_position)
		infiltrators.append(enemy)
	lane.set_active(true)
	main.hud.show_hint("侧翼有穿插小队摸过来：拦在通路里别让他们过去（%d 人）"
			% infiltrators.size())


## 每帧：有人穿过走廊 → 失败；穿插兵全被清掉 → 提前达成
func _process(_delta: float) -> void:
	if _resolved or infiltrators.is_empty() or lane == null:
		return
	var alive_count := 0
	for enemy in infiltrators:
		if enemy == null or not is_instance_valid(enemy):
			continue
		if not bool(enemy.alive):
			continue
		alive_count += 1
		if lane.is_crossed(enemy.global_position):
			_resolve(true)
			return
	if alive_count == 0:
		_resolve(false)


func _resolve(breached: bool) -> void:
	_resolved = true
	if lane != null:
		lane.set_active(false)
	if main == null or main.quests == null:
		return
	if breached:
		main.hud.show_hint("敌人穿过了侧翼通路——任务失败")
		main.hud.push_feed("lane", "侧翼通路被突破", Color(1.0, 0.45, 0.4))
		main.quests.notify_lane_breached()
	else:
		main.hud.show_hint("穿插小队被清光——侧翼通路守住了")
		main.hud.push_feed("lane", "侧翼通路守住了", Color(0.55, 1.0, 0.6))
		main.quests.notify_lane_secured()
