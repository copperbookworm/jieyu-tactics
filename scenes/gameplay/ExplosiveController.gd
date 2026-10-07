extends Node

## 炸药 / 工程兵（2026-10-04 拍板；2026-10-07 第八十三版补齐 docx ㊺㊻㊼ 三条尾巴）
##
## 输入：HUD「爆破」键（Main._wire_signals 接到 ExplosiveController.toggle）
## 状态机（一次只允许一枚待爆，避免「放一地、一起炸」这种第一版没有的表现）：
##   空闲 + 按 → 按距离自动分档：≤15 m 走**贴放读条**（㊼）/ >15 m 走**投掷**（㊻）
##   读条 + 按 → 取消安放（不消耗）；移动 / 开火 / 受击 / 开图 / 上车 也会打断
##   飞行 + 按 → 拒绝（等它落地）
##   待爆 + 按 → 遥控起爆（结算 + 清掉）
##
## 结算（与间瞄同一套「弹种口径」，**不看开口**）：occluder 组扣结构值；enemy / 敌方 FOB 扣爆炸伤害。
## ㊺ 自伤（2026-10-07 使用者选择题 A）：**跟本局模式走** —— MatchRules.friendly_fire() 为真时
##   把 player / friendly / 我方 FOB 一起并进结算（竞技 / 困难：贴脸 ＝ 自杀）；为假时只打敌人
##   （休闲 / PVEVP）。与枪械友伤同一条规则，不新开一套口径，模式表一个字都不用改。
##   载具**不吃**爆炸伤害（第一版：载具的爆炸毁伤要接 8.4 的部位模型，登记为欠账）。
##
## 时间只有**一个时钟**：_process(delta) → tick(delta)，读条与抛物线都在这里推进
## （Charge 自己不 _process）⇒ 集成冒烟也只用 tick 一个入口。
##
## 刻意不写 class_name：Main 用 preload 引用、持 Main 引用走鸭子类型（与其它子模块一致）。

const ChargeTableScript := preload("res://data/config/ChargeTable.gd")
const ExplosiveSystemScript := preload("res://systems/explosives/ExplosiveSystem.gd")
const ChargeScript := preload("res://entities/explosive/Charge.gd")
const EffectSpawnerScript := preload("res://systems/effects/EffectSpawner.gd")
const SfxScript := preload("res://systems/audio/Sfx.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

var main = null
## 当前待爆的那一枚（含飞行中；untyped：它是 Charge 实例，判型交给运行时，避免和 preload 类型打架）
var placed = null
## 本局已消耗发数（剩余 = 兵种携带 − used；所以中途切到工程兵也能立刻拿到 2 发）
var used := 0

# 安放读条（㊼）的现场：起点、落点、以及「挨打前」的血量都记下来，用来判打断
var _casting := false
var _cast_left := 0.0
var _cast_origin := Vector2.ZERO
var _cast_target := Vector2.ZERO
var _cast_hp := 0.0


func setup(main_node) -> void:
	main = main_node


## 兵种携带量（工程兵 2 发，其余 0）——唯一来源是 RoleTable
func total() -> int:
	if main == null:
		return 0
	return RoleTable.charges_for(main.player_role)


func remaining() -> int:
	return maxi(total() - used, 0)


## 场上有待爆药（含飞行中）
func is_armed() -> bool:
	return placed != null


func is_flying() -> bool:
	return placed != null and placed.is_flying()


## 「现在就能起爆」＝有待爆药且已经落地
func is_ready() -> bool:
	return placed != null and not placed.is_flying()


func is_casting() -> bool:
	return _casting


func cast_left() -> float:
	return _cast_left


func cast_progress() -> float:
	if not _casting or ExplosiveSystemScript.PLACE_CAST_S <= 0.0:
		return 0.0
	return clampf(1.0 - _cast_left / ExplosiveSystemScript.PLACE_CAST_S, 0.0, 1.0)


func charge_name() -> String:
	return ChargeTableScript.name_of(ChargeTableScript.DEFAULT_CHARGE_ID)


## 一个时钟：读条 + 抛物线飞行。_process 与集成冒烟共用这一个入口。
func tick(delta: float) -> void:
	if _casting:
		if _cast_interrupted():
			return
		_cast_left = maxf(_cast_left - delta, 0.0)
		if _cast_left <= 0.0:
			_finish_cast()
		return
	if placed != null and placed.is_flying():
		placed.tick(delta)


func _process(delta: float) -> void:
	tick(delta)


func toggle() -> void:
	if main == null or main.player == null:
		return
	if _casting:
		cancel_cast("手动取消")
		return
	if placed != null:
		if placed.is_flying():
			main.hud.show_hint("%s 还在飞：落地后再按起爆" % charge_name())
			return
		detonate()
		return
	_begin()


## 玩家开了火 ⇒ 安放读条打断（㊼「安放中被打断怎么办」的答案：打断，且不消耗发数）。
## 由 Main._wire_signals 把 HUD 开火键的 fired 信号一并接到这里。
func notify_fired() -> void:
	if _casting:
		cancel_cast("开了火")


func cancel_cast(reason: String) -> void:
	if not _casting:
		return
	_casting = false
	main.hud.show_hint("安放打断（%s）：不消耗发数" % reason)
	main.hud.update_role()


## 「载具里不能放炸药」——第一版口径：先下车。发烟器那条链（8.3）是载具自己的，与步兵炸药无关。
func in_vehicle() -> bool:
	return main.vehicles != null and main.vehicles.vehicle != null \
			and main.vehicles.vehicle.is_occupied()


# ────────────── 内部：下按下这一下 ──────────────

func _begin() -> void:
	if main.camera_controller == null:
		return
	if main.hud.is_map_open():
		main.hud.show_hint("战术地图开着：先关图再放炸药")
		return
	if in_vehicle():
		main.hud.show_hint("载具里不能放炸药（第一版：下车再放）")
		return
	var carried := total()
	if carried <= 0:
		main.hud.show_hint("只有工程兵带炸药（%s 没有）" % RoleTable.role_name(main.player_role))
		return
	if remaining() <= 0:
		main.hud.show_hint("炸药已用完（%d 发都放出去了）" % carried)
		return
	var target: Vector2 = main.camera_controller.crosshair_world
	var reason: String = ExplosiveSystemScript.range_error(main.player.global_position, target)
	if not reason.is_empty():
		main.hud.show_hint(reason)
		return
	if ExplosiveSystemScript.is_throw(main.player.global_position, target):
		_throw(target)
	else:
		_start_cast(target)


## 贴放（㊼）：先读条，读条走完才真落地
func _start_cast(target: Vector2) -> void:
	_casting = true
	_cast_left = ExplosiveSystemScript.PLACE_CAST_S
	_cast_origin = main.player.global_position
	_cast_target = target
	_cast_hp = float(main.player.hp)
	main.hud.show_hint("安放 %s 中… %.1f s（别移动 / 别开火 / 别挨打）" % [
			charge_name(), ExplosiveSystemScript.PLACE_CAST_S])
	main.hud.update_role()


func _finish_cast() -> void:
	_casting = false
	used += 1
	var charge = _spawn_charge()
	charge.setup(ChargeTableScript.DEFAULT_CHARGE_ID, _cast_target)
	placed = charge
	main.hud.show_hint("已安放 %s（余 %d）：再按一次「爆破」遥控起爆" % [charge_name(), remaining()])
	main.hud.update_role()


## 投掷（㊻）：瞬时出手（不需要读条 —— 读条是「安放」的代价），落地后才可遥控起爆
func _throw(target: Vector2) -> void:
	var from: Vector2 = main.player.global_position
	used += 1
	var charge = _spawn_charge()
	charge.launch(ChargeTableScript.DEFAULT_CHARGE_ID, from, target)
	placed = charge
	main.hud.show_hint("投出 %s（%.0f m）：落点已预警，落地后再按起爆" % [
			charge_name(), from.distance_to(target)])
	main.hud.update_role()


func _spawn_charge():
	var charge = ChargeScript.new()
	charge.name = "Charge"
	add_child(charge)
	return charge


## 读条打断判定（㊼）：倒下 / 开图 / 上车 / 挨打 / 走开 都算。返回 true 表示本帧已打断。
func _cast_interrupted() -> bool:
	if main.player == null or not bool(main.player.alive) or bool(main.player.downed):
		cancel_cast("倒下了")
		return true
	if main.hud.is_map_open():
		cancel_cast("打开了地图")
		return true
	if in_vehicle():
		cancel_cast("上了车")
		return true
	if float(main.player.hp) < _cast_hp - 0.01:
		cancel_cast("挨了打")
		return true
	var moved: float = main.player.global_position.distance_to(_cast_origin)
	if moved > ExplosiveSystemScript.CAST_MOVE_TOLERANCE_M:
		cancel_cast("移动了 %.1f m" % moved)
		return true
	return false


func detonate() -> void:
	if placed == null or placed.is_flying():
		return
	var center: Vector2 = placed.global_position
	var charge_id: String = String(placed.charge_id)
	placed.queue_free()
	placed = null
	_apply_blast(center, charge_id)
	SfxScript.play("explosion")
	EffectSpawnerScript.impact_at(main, center, EffectSpawnerScript.IMPACT_GROUND)
	main.hud.show_hint("%s 起爆：半径 %.0f m%s" % [
			ChargeTableScript.name_of(charge_id), ChargeTableScript.radius_m(charge_id),
			"（本局开友伤：自己也在范围内）" if MatchRulesScript.friendly_fire() else ""])
	main.hud.update_role()


## 结算：掩体扣结构值；单位按 ㊺ 的口径决定打谁（开友伤 ⇒ 连自己人一起结算）
func _apply_blast(center: Vector2, charge_id: String) -> void:
	var tree: SceneTree = main.get_tree()
	if tree == null:
		return
	for node in tree.get_nodes_in_group(GameConfig.OCCLUDER_GROUP):
		_damage_cover(node, center, charge_id)
	var groups: Array = ["enemy", "fob_enemy"]
	if MatchRulesScript.friendly_fire():
		groups.append_array(["player", "friendly", "fob"])
	for group_name in groups:
		for node in tree.get_nodes_in_group(String(group_name)):
			_damage_unit(node, center, charge_id)


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
