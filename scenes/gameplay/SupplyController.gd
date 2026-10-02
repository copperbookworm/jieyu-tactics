extends Node

## 补给护送控制器（候选 L3，docx 4.10.11 T-S5「护送补给至前线」）
##
## 职责很小：任务系统发出护送任务（T-S5）时派一辆补给车，车抵达目标节点后再回告任务系统。
## 这样任务系统不必知道「车」这种世界实体，补给车也不必知道「任务」——两边都只跟本模块打交道。
## 约定：一局只送一趟（第一版）；补给车 add_child 到 Main 上，保持场景树与其它实体一致。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const SupplyScript := preload("res://entities/supply/Supply.gd")

var main = null            # Main（鸭子类型）
var convoy = null          # 当前补给车（Supply，动态类型）


func setup(main_node) -> void:
	main = main_node
	# 任务列表一变就看看有没有护送任务（任务系统在「战局事件」上会重发列表）
	if main.quests != null and not main.quests.quest_list_changed.is_connected(_on_quests_changed):
		main.quests.quest_list_changed.connect(_on_quests_changed)


## 任务列表变化：有 T-S5 且还没派车 → 按任务给的「指定节点」派车
func _on_quests_changed(quest_list: Array) -> void:
	if main == null or main.quests == null or convoy != null:
		return
	for quest in quest_list:
		if String(quest["id"]) != "T-S5":
			continue
		var zone = quest.get("zone")
		if zone == null:
			continue
		_dispatch(zone.global_position)
		return


func _dispatch(target_position: Vector2) -> void:
	convoy = SupplyScript.new()
	convoy.name = "SupplyConvoy"
	convoy.global_position = MapGenerator.demo_spawn_point()  # 从后方续航区出发
	main.add_child(convoy)
	convoy.setup(target_position, GameConfig.SUPPLY_SPEED)
	convoy.arrived.connect(_on_arrived)
	main.hud.show_hint("补给车已出发：护送它抵达前线节点（%.0f m）"
			% convoy.distance_left())


## 补给车抵达指定节点：回告任务系统（推进 T-S5），并提示玩家
func _on_arrived(_supply) -> void:
	if main == null:
		return
	if main.quests != null:
		main.quests.notify_supply_arrived()
	if main.hud != null:
		main.hud.show_hint("补给已抵达前线")
		main.hud.push_feed("supply", "补给已抵达前线", Color(0.5, 0.9, 1.0))
