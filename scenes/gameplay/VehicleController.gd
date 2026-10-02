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
## 表现层特效（候选 M：12.7.3 / 12.7.4）
const EffectSpawner := preload("res://systems/effects/EffectSpawner.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")

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
	# 候选 Q（使用者 2026-10-02）：敌方坦克至少一名敌人士兵操控；结构值跌破阈值会下车逃生
	var crew := Enemy.new()
	crew.name = "EnemyTankCrew"
	crew.global_position = enemy_vehicle.global_position
	crew.setup(main.sight, player, main.camera, main.grid)
	main.add_child(crew)
	enemy_vehicle.add_crew(crew)   # 必须在 add_child 之后（乘员 _ready 里才入 enemy 组）
	# 敌方载具开炮也要画曳光：玩家原先看不见炮弹从哪来，只看到血量突然掉一截
	# （400 伤害一炮打在 100 血步兵身上＝HUD 显示 -300，会被误当成换座按钮的锅）
	enemy_vehicle.weapon_fired.connect(main.spawn_tracer)
	# 击毁敌方载具 → 推进 T-S3 这条线不在这里接：任务系统 start() 时自己订阅战局事件源
	# （fob_enemy / 敌方载具的 wrecked 信号），见 QuestSystem._subscribe_event_sources()
	# 我方载具被打爆：Vehicle.take_hit 会自己把乘员请下车（exit_vehicle），但那条路不经过本模块，
	# HUD 上「下车」按钮文字会一直留着——玩家会以为自己还在车里。用 wrecked 信号把 HUD 复位。
	vehicle.wrecked.connect(_on_player_vehicle_wrecked)


## 我方载具报废：乘员已被 Vehicle 请下车，这里只负责把 HUD 与提示对齐（2026-10-01）
func _on_player_vehicle_wrecked(_vehicle) -> void:
	if main == null or main.hud == null:
		return
	main.hud.set_vehicle_button_text("上车")
	main.hud.show_hint("载具已报废：乘员已下车")
	main.hud.update_role()


## 上车 / 下车（docx 8.1 舱室与座位）
func toggle() -> void:
	if vehicle == null or main.player == null:
		return
	if vehicle.is_occupied():
		vehicle.exit_vehicle()
		main.hud.set_vehicle_button_text("上车")
		main.hud.show_hint("已下车")
		return
	# 报废车不许上（2026-10-01 修）：上去之后武器位永远打不出炮，而且原来一句提示都没有，
	# 玩家只会以为「开火键坏了」——这条是排查「上车换座后开不了火」时挖出来的洞。
	if bool(vehicle.destroyed):
		main.hud.show_hint("这辆车已经报废了，上不去也开不了炮")
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
## 武器位一键切弹种（主炮 ⇄ 反坦克导弹）。只有装了导弹的载具能切（IFV 装了，坦克没有）。
func switch_ammo() -> void:
	if vehicle == null or main.player == null:
		return
	if not vehicle.can_switch_ammo(main.player):
		# 2026-10-02 真机反馈：没上车时按「弹种」也把车上的弹种切了（vehicle 一直是那辆 IFV）
		main.hud.show_hint("不在武器位上：先点「上车」，再点「换座」" if vehicle.has_atgm()
				else "这辆车没装反坦克导弹（只有主炮）")
		return
	vehicle.switch_ammo()
	if vehicle.is_atgm_selected():
		main.hud.show_hint("已切到反坦克导弹（%d/%d 发 ｜ 穿深 %.0f mm）—— 正面能打穿主战坦克"
				% [vehicle.atgm_ammo(), vehicle.atgm_total(),
				vehicle.atgm_value("atgm_penetration_mm", 0.0)])
	else:
		main.hud.show_hint("已切回 %s（余弹 %d）" % [vehicle.ammo_type_name(), vehicle.ammo()])
	main.hud.update_role()


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


## 载具开火（8.2 武器索引：第一版只做主武器）；敌方载具与敌方 FOB 都在目标列表里，能互相击穿 / 砸工事
func fire() -> void:
	# main 是鸭子类型（Variant），这里不能用 := 推断类型，得显式标注
	var targets: Array = main.get_tree().get_nodes_in_group("enemy")
	# 候选 L2：敌方 FOB 也是可打目标（它自带 3 m 命中半径，见 BallisticsSystem 按 hit_radius() 取）
	targets.append_array(main.get_tree().get_nodes_in_group("fob_enemy"))
	# 残骸也进目标列表（2026-10-02 真机反馈「被击毁的敌人坦克不能被机炮命中」：
	# 以前这里把 destroyed 的车排除掉，子弹直接从残骸上穿过去，连命中提示都没有）
	if enemy_vehicle != null:
		targets.append(enemy_vehicle)
	var result: Dictionary = vehicle.fire(targets)
	if not result.get("fired", false):
		# 打不出来必须给原因（2026-10-01）：原来这里是静默 return，玩家在武器位上按开火键
		# 什么都看不到，只能归结成「开火键坏了」。冷却中算正常节奏，不刷提示。
		# main/vehicle 都是鸭子类型（Variant），这里不能用 := 推断
		var reason: String = vehicle.fire_block_reason()
		print("[开火] 载具打不出来：%s（炮弹 %d）" % [reason, vehicle.ammo()])
		if reason != "" and reason != "装填中":
			main.hud.show_hint("开不了炮：%s" % reason)
		return
	# 与步兵那条 [开火] 日志对称：按一次开火键就产出一行，真机用 logcat 能一眼看出「按了但没出声」还是「根本没收到按」
	var atgm: bool = String(result.get("ammo_type", "gun")) == "atgm"
	# 与步兵那条 [开火] 日志对称：按一次开火键就产出一行，真机一眼看出弹种、余弹与结果
	print("[开火] 载具出炮（%s）：余弹 %d ｜ 命中=%s"
			% [vehicle.ammo_type_name(), vehicle.selected_ammo(), str(result["hit"])])
	if atgm:
		# 反坦克导弹：暖红尾迹，与机炮曳光一眼分得开
		var missile := Tracer.new()
		missile.setup(vehicle.muzzle_position(), vehicle.turret_facing,
				float(result["distance"]), GameConfig.ATGM_TRACER_COLOR)
		main.add_child(missile)
	else:
		main.spawn_tracer(vehicle.muzzle_position(), vehicle.turret_facing,
				float(result["distance"]))
	# 12.7.3 / 12.7.4：枪口火光与弹着特效（导弹的火光更大）
	EffectSpawner.muzzle_at(vehicle, vehicle.muzzle_position(), vehicle.turret_facing,
			3.4 if atgm else 2.4)
	EffectSpawner.impact_at(vehicle, result.get("point", vehicle.global_position),
			EffectSpawner.IMPACT_UNIT if result["hit"] else EffectSpawner.IMPACT_GROUND)
	Sfx.play("missile" if atgm else "cannon")   # 10 章：导弹 / 主炮
	if not result["hit"]:
		return
	var target = result["target"]
	if target == enemy_vehicle:
		if bool(enemy_vehicle.destroyed):
			# 残骸：take_hit 对已报废目标是早退（等效厚度给 0），拿它算击穿提示会说假话 ⇒ 直接照实回话
			main.hud.show_hint("命中敌方载具残骸（已摧毁）")
			return
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
	elif target != null and target.has_method("take_damage"):
		target.take_damage(float(result["damage"]))  # FOB 等工事：直接吃炮弹伤害
	main.hud.show_hint("载具开火（余弹 %d）" % vehicle.ammo())
