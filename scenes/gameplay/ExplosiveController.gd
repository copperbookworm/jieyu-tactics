extends Node

## 炸药 / 工程兵（2026-10-04 使用者拍板）
##
## 输入：HUD「爆破」键（Main._wire_signals 接到 ExplosiveController.toggle）
## 状态机（一次只允许一枚待爆，避免「放一地、一起炸」这种第一版没有的表现）：
##   无待爆 + 按 → 在准心落点放一枚（消耗 1；超距 / 非工程兵 / 用完 都拒绝并给提示，不消耗）
##   有待爆 + 按 → 遥控起爆（结算 + 清掉）
## 结算（与间瞄同一套「弹种口径」，**不看开口**）：occluder 组扣结构值；enemy 组与敌方 FOB 扣爆炸伤害。
##   **不打自己人**（第一版有意）：与间瞄只打 enemy 组一致 —— 相反的做法会让「贴脸放」等于自杀，
##   而第一版没有救治链。要不要给自己人吃爆炸伤害，已登记为待拍板项。
##
## 刻意不写 class_name：Main 用 preload 引用、持 Main 引用走鸭子类型（与其它子模块一致）。

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")
const ExplosiveSystemScript := preload("res://systems/explosives/ExplosiveSystem.gd")
const ChargeScript := preload("res://entities/explosive/Charge.gd")
const EffectSpawnerScript := preload("res://systems/effects/EffectSpawner.gd")
const SfxScript := preload("res://systems/audio/Sfx.gd")

var main = null
## 当前待爆的那一枚（untyped：它是 Charge 实例，判型交给运行时，避免和 preload 类型打架）
var placed = null
## 本局已消耗发数（剩余 = 兵种携带 − used；所以中途切到工程兵也能立刻拿到 2 发）
var used := 0


func setup(main_node) -> void:
	main = main_node


## 兵种携带量（工程兵 2 发，其余 0）——唯一来源是 RoleTable
func total() -> int:
	if main == null:
		return 0
	return RoleTable.charges_for(main.player_role)


func remaining() -> int:
	return maxi(total() - used, 0)


func is_armed() -> bool:
	return placed != null


func charge_name() -> String:
	return ChargeTableScript.name_of(ChargeTableScript.DEFAULT_CHARGE_ID)


func toggle() -> void:
	if main == null or main.player == null:
		return
	if placed != null:
		detonate()
		return
	_place()


func _place() -> void:
	if main.camera_controller == null:
		return
	var carried := total()
	if carried <= 0:
		main.hud.show_hint("只有工程兵带炸药（%s 没有）" % RoleTable.role_name(main.player_role))
		return
	if remaining() <= 0:
		main.hud.show_hint("炸药已用完（%d 发都放出去了）" % carried)
		return
	var target: Vector2 = main.camera_controller.crosshair_world
	var reason: String = ExplosiveSystemScript.placement_error(
			main.player.global_position, target)
	if not reason.is_empty():
		main.hud.show_hint(reason)
		return
	var charge = ChargeScript.new()
	charge.name = "Charge"
	add_child(charge)
	charge.setup(ChargeTableScript.DEFAULT_CHARGE_ID, target)
	placed = charge
	used += 1
	main.hud.show_hint("已放置 %s（余 %d）：再按一次「爆破」遥控起爆" % [charge_name(), remaining()])
	main.hud.update_role()


func detonate() -> void:
	if placed == null:
		return
	var center: Vector2 = placed.global_position
	var charge_id: String = String(placed.charge_id)
	placed.queue_free()
	placed = null
	var tree: SceneTree = main.get_tree()
	if tree != null:
		for node in tree.get_nodes_in_group(GameConfig.OCCLUDER_GROUP):
			_damage_cover(node, center, charge_id)
		for node in tree.get_nodes_in_group("enemy"):
			_damage_unit(node, center, charge_id)
		for node in tree.get_nodes_in_group("fob_enemy"):
			_damage_unit(node, center, charge_id)
	SfxScript.play("explosion")
	EffectSpawnerScript.impact_at(main, center, EffectSpawnerScript.IMPACT_GROUND)
	main.hud.show_hint("%s 起爆：半径 %.0f m" % [ChargeTableScript.name_of(charge_id),
			ChargeTableScript.radius_m(charge_id)])
	main.hud.update_role()


## 掩体 / 建筑：走「弹种口径」的结构伤害（炸药不看开口 —— 贴在墙上就是满值）
func _damage_cover(cover: Node, center: Vector2, charge_id: String) -> void:
	if cover == null or not (cover is Node2D) or not cover.has_method("take_structure_damage"):
		return
	var distance := center.distance_to((cover as Node2D).global_position)
	var structure: float = ExplosiveSystemScript.structure_blast_at(distance, charge_id)
	if structure > 0.0:
		cover.take_structure_damage(structure)


## 单位 / 工事：爆炸伤害按距离衰减；已经倒下或已报废的不再吃第二遍
func _damage_unit(unit: Node, center: Vector2, charge_id: String) -> void:
	if unit == null or not (unit is Node2D) or not unit.has_method("take_damage"):
		return
	var alive = unit.get("alive")
	if alive != null and not bool(alive):
		return
	var destroyed = unit.get("destroyed")
	if destroyed != null and bool(destroyed):
		return
	var damage: float = ExplosiveSystemScript.unit_blast_at(
			center.distance_to((unit as Node2D).global_position), charge_id)
	if damage > 0.0:
		unit.take_damage(damage)
