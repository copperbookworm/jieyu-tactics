extends Node

## 载具交互（2026-09-30 候选 N：从 Main.gd 拆出）
## 负责：建车（我方 IFV + 敌方坦克 AI）、上车 / 下车、换座、武器位操炮塔、驾驶、开炮与击穿提示。
## 装甲判定与 AI 细节在 entities/vehicle/Vehicle.gd，本模块只管「玩家怎么用它」。
##
## 约定：两辆车都 add_child 到 Main 上（不是本模块），保持场景树与拆分前一致；
## 提示文字统一走 main.hud.show_hint()。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const VehicleScript := preload("res://entities/vehicle/Vehicle.gd")
## 载具数据表（同样无 class_name）：HUD 提示要读装甲面名与等效厚度
const VehicleTable := preload("res://systems/vehicles/VehicleTable.gd")

var main = null             # Main（不标类型：Main 无 class_name，用鸭子类型）
var vehicle = null          # 我方载具
var enemy_vehicle = null    # 敌方载具（候选 K：AI 驾驶）


func setup(main_node, player, sight, vehicle_id: String) -> void:
	main = main_node
	var points := MapGenerator.demo_vehicle_points()
	# 载具（docx 第八章）：先放一辆在出生点旁边，用来验证「上车 / 开炮 / 装甲挡弹」
	vehicle = VehicleScript.new()
	vehicle.name = "Vehicle"
	vehicle.global_position = points[0]
	main.add_child(vehicle)
	vehicle.setup(vehicle_id, sight)
	# 敌方载具（候选 K）：坦克 + AI——「敌人也开车」这条验收靠它
	enemy_vehicle = VehicleScript.new()
	enemy_vehicle.name = "EnemyVehicle"
	enemy_vehicle.global_position = points[1]
	enemy_vehicle.friendly = false
	enemy_vehicle.ai_enabled = true
	main.add_child(enemy_vehicle)
	enemy_vehicle.setup("mbt_t1", sight)
	enemy_vehicle.set_target(player)
	# 敌方载具开炮也要画曳光：玩家原先看不见炮弹从哪来，只看到血量突然掉一截
	# （400 伤害一炮打在 100 血步兵身上＝HUD 显示 -300，会被误当成换座按钮的锅）
	enemy_vehicle.weapon_fired.connect(main.spawn_tracer)


## 上车 / 下车（docx 8.1 舱室与座位）
func toggle() -> void:
	if vehicle == null or main.player == null:
		return
	if vehicle.is_occupied():
		vehicle.exit_vehicle()
		main.hud.set_vehicle_button_text("上车")
		main.hud.show_hint("已下车")
		return
	if main.player.global_position.distance_to(vehicle.global_position) \
			> GameConfig.VEHICLE_BOARD_RANGE:
		main.hud.show_hint("离载具太远（%.0f m 内才能上车）" % GameConfig.VEHICLE_BOARD_RANGE)
		return
	vehicle.enter(main.player)
	main.hud.set_vehicle_button_text("下车")
	main.hud.show_hint("已上车：%s" % vehicle.vehicle_name())


## 换座位（8.1 舱室与座位：驾驶位 ⇄ 武器位）——8.2 载具 UI 三原则：不同座位 UI 不同
func switch_seat() -> void:
	if vehicle == null or main.player == null:
		return
	if vehicle.seat_of(main.player).is_empty():
		main.hud.show_hint("不在载具里")
		return
	var new_seat = vehicle.switch_seat(main.player)
	if new_seat == "gunner":
		main.hud.show_hint("已换到武器位：拖动准心操炮塔，开火键开炮")
	else:
		main.hud.show_hint("已换到驾驶位：推摇杆开车")
	main.hud.update_role()


## 玩家是否坐在武器位（只有武器位能开炮，8.1 座位分工）
func is_gunner(player) -> bool:
	if vehicle == null or player == null:
		return false
	return vehicle.seat_of(player) == "gunner"


## 每帧：驾驶（摇杆喂给载具）＋ 武器位用准心操炮塔（转速受限，8.2.6）
func tick(delta: float) -> void:
	if vehicle == null or main.player == null:
		return
	if not vehicle.is_occupied():
		return
	vehicle.drive(main.player.move_input(), delta)
	if main.camera_controller != null and is_gunner(main.player):
		vehicle.aim_at(main.camera_controller.crosshair_world, delta)


## 载具开火（8.2 武器索引：第一版只做主武器）；敌方载具也在目标列表里，能互相击穿
func fire() -> void:
	# main 是鸭子类型（Variant），这里不能用 := 推断类型，得显式标注
	var targets: Array = main.get_tree().get_nodes_in_group("enemy")
	if enemy_vehicle != null and not bool(enemy_vehicle.destroyed):
		targets.append(enemy_vehicle)
	var result: Dictionary = vehicle.fire(targets)
	if not result.get("fired", false):
		return
	main.spawn_tracer(vehicle.muzzle_position(), vehicle.turret_facing,
			float(result["distance"]))
	if not result["hit"]:
		return
	var target = result["target"]
	if target == enemy_vehicle:
		var armor: Dictionary = enemy_vehicle.take_hit(float(result["damage"]),
				float(result["penetration_mm"]), vehicle.turret_facing)
		var side_text := VehicleTable.side_label(String(armor["side"]))
		var armor_text := "%s等效 %d mm" % [side_text, int(float(armor["armor_mm"]))]
		var pen_text := "%d mm 穿深" % int(float(armor["penetration_mm"]))
		if bool(armor["penetrated"]):
			main.hud.show_hint("击穿！%s ＜ 我 %s" % [armor_text, pen_text])
		else:
			main.hud.show_hint("未击穿：%s ＞ 我 %s" % [armor_text, pen_text])
		return
	var enemy := target as Enemy
	if enemy != null:
		enemy.take_damage(float(result["damage"]))
	main.hud.show_hint("载具开火（余弹 %d）" % vehicle.ammo())
