extends CharacterBody2D

## 玩家的小队队友（3 名，强力版）—— 使用者 2026-10-02 要求
## 职责：编队跟随玩家；视野内出现敌人就自动交火（比敌人强一档：血 200 / 一发 45 / 0.35 s 一发）。
## 复用现成的模块：UnitFigure（角色图）、BlobShadow（影子）、BallisticsSystem（命中判定）、Sfx、EffectSpawner。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const UnitFigureScript := preload("res://entities/visual/UnitFigure.gd")
const BlobShadowScript := preload("res://entities/effects/BlobShadow.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")
const EffectSpawnerScript := preload("res://systems/effects/EffectSpawner.gd")

var main = null
var hp := 200.0                 ## 血的 2 倍（敌人 100）
var max_hp := 200.0
var alive := true
var downed := false
var downed_time_left := 0.0
var move_speed := 3.4           ## m/s（敌人 2.0）
var fire_damage := 45.0         ## 一发 45：敌人 100 血 ⇒ 3 发带走
var fire_interval := 0.35       ## s，比敌人 1.5 s 快得多
var engage_range := 220.0       ## m，开火距离
var follow_distance := 6.0      ## m，跟随时与玩家的间距
var body_radius := 0.4
var facing := Vector2.RIGHT
var is_moving := false
var index := 0                  ## 编队位（0/1/2）
## 编成（docx 4.10.8 / 5.8 · 2026-10-03 拍板：组 4 人 · 一小队至少 2 组）
## 由 WorldSetup 按 Organization 的结果写入；-1 = 不在任何组 / 小队
var group_index := -1
var squad_index := -1
var is_group_leader := false
var is_squad_leader := false

var _fire_cooldown := 0.0
## 目标重挑计时（s）：原来每物理帧都遍历敌组、逐候选查通视；现在 0.1 s 才重挑一次
var _pick_timer := 0.0
## 组任务（docx 4.10.8 的「执行层」）：本组被派到的占领节点坐标。
## 由 WorldSetup 在派发完组任务后写入；order_active = false 时退回「跟随玩家」的旧行为。
var order_target := Vector2.ZERO
var order_active := false
var order_text := ""
## 组内站位半径（组任务时 4 个人围着节点错开，不叠在一起）
var order_slot_radius := 4.0
var _sight = null
var _player = null
var _grid = null
var _visual = null
var _target = null


func setup(main_node, player, sight, grid, formation_index: int = 0) -> void:
	main = main_node
	_player = player
	_sight = sight
	_grid = grid
	index = formation_index
	add_to_group("friendly")
	_build_visual()
	if player != null:
		global_position = player.global_position + formation_offset(index, follow_distance)


## 编队偏移（纯函数，测试直接调）：前 3 人分布在玩家后方的左右与正后（与旧实现逐字一致），
## 第 4 名之后挂到「后方的同心弧」上 —— 原来是把角度取模 3，于是 19 名队友会叠成 3 堆：
## 既难看，也让性能采样失真（叠在一起的单位通视距离几乎为零）。
## PVP 20 v 20 要 19 名队友（docx 5.8），所以必须铺开。
static func formation_offset(formation_index: int, distance: float) -> Vector2:
	var angles := [PI * 0.75, PI * 1.25, PI]      # 左后 / 右后 / 正后
	if formation_index < angles.size():
		return Vector2.RIGHT.rotated(float(angles[formation_index])) * distance
	var k := formation_index - angles.size()
	var per_ring := 8
	var ring := k / per_ring
	var slot := k % per_ring
	var t := (float(slot) + 0.5) / float(per_ring)        # 0..1
	var angle := PI + (t - 0.5) * 1.6                     # 正后方 ±0.8 rad
	return Vector2.RIGHT.rotated(angle) * (distance + 5.0 * float(ring + 1))


func _build_visual() -> void:
	var shadow = BlobShadowScript.new()
	shadow.name = "BlobShadow"
	shadow.fit_body(body_radius)
	add_child(shadow)
	_visual = UnitFigureScript.new()
	_visual.name = "Figure"
	_visual.show_behind_parent = true
	add_child(_visual)
	_visual.setup_figure(body_radius, GameConfig.UNIT_COLOR_PLAYER)


func _physics_process(delta: float) -> void:
	if not alive:
		return
	if downed:
		downed_time_left -= delta
		velocity = Vector2.ZERO
		if downed_time_left <= 0.0:
			die()
		return
	if _fire_cooldown > 0.0:
		_fire_cooldown = maxf(_fire_cooldown - delta, 0.0)
	# 目标失效立刻重挑；否则按 AI_TARGET_RETRY_INTERVAL 节流（省的是逐候选通视查询）
	_pick_timer -= delta
	if _target == null or not is_instance_valid(_target) or _pick_timer <= 0.0:
		_target = _pick_target()
		_pick_timer = GameConfig.AI_TARGET_RETRY_INTERVAL
	if _target != null:
		velocity = Vector2.ZERO
		var aim: Vector2 = _target.global_position - global_position
		if aim.length() > 0.05:
			facing = aim.normalized()
			if _visual != null:
				_visual.set_aim(facing.angle())
		if _fire_cooldown <= 0.0:
			_fire()
	else:
		_follow(delta)


func _pick_target():
	var tree := get_tree()
	if tree == null:
		return null
	var best = null
	var best_distance := engage_range
	for node in tree.get_nodes_in_group("enemy"):
		if not (node is Node2D):
			continue
		var d: float = global_position.distance_to(node.global_position)
		if d >= best_distance:
			continue
		if _sight != null and _sight.grid != null and not _has_sight(node):
			continue
		best_distance = d
		best = node
	return best


func _has_sight(target) -> bool:
	var origin: float = _grid.sample_bilinear(global_position) + GameConfig.SOLDIER_EYE_HEIGHT
	var target_height: float = _sight.eye_height_at(target.global_position)
	return _sight.has_sight(global_position, origin, target.global_position, target_height)


## 本帧该去哪儿：有组任务就去组任务的节点（组内按序号错开，免得 4 个人叠成一个点），
## 没有就沿用「跟在玩家后方」的编队位（旧行为，order_active = false 时逐字不变）
func _goal_position() -> Vector2:
	if order_active:
		return order_target + formation_offset(index, order_slot_radius)
	if _player == null:
		return global_position
	return _player.global_position + formation_offset(index, follow_distance)


func _follow(delta: float) -> void:
	if _player == null and not order_active:
		return
	var goal: Vector2 = _goal_position()
	var to_goal := goal - global_position
	if to_goal.length() <= 1.5:
		velocity = Vector2.ZERO
		is_moving = false
	else:
		facing = to_goal.normalized()
		velocity = facing * move_speed
		is_moving = true
	move_and_slide()
	if _visual != null:
		_visual.set_move(facing.angle(), velocity.length() / maxf(move_speed, 0.001), delta)
		_visual.set_aim(facing.angle())


func _fire() -> void:
	if main == null or _target == null:
		return
	var targets: Array = get_tree().get_nodes_in_group("enemy")
	var result: Dictionary = BallisticsSystem.resolve_shot(global_position, facing,
			engage_range, targets, GameConfig.ENEMY_HIT_RADIUS, _sight,
			GameConfig.SOLDIER_EYE_HEIGHT)
	_fire_cooldown = fire_interval
	Sfx.play("shot_enemy")
	EffectSpawnerScript.muzzle_at(self, global_position + facing * GameConfig.MUZZLE_OFFSET, facing, 0.8)
	if result.get("hit", false) and result.get("target") != null:
		var victim = result["target"]
		if victim.has_method("take_damage"):
			victim.take_damage(fire_damage)
	elif result.get("cover_hit", false):
		# 队友的子弹同样能打坏掩体（与玩家/敌人一致）；建筑结构值要重武器才扣得动
		var cover = result.get("cover")
		if cover != null and cover.has_method("take_damage"):
			cover.take_damage(fire_damage)
			var structure := float(result.get("structure_damage", 0.0))
			if structure > 0.0 and cover.has_method("take_structure_damage"):
				cover.take_structure_damage(structure)


func take_damage(amount: float) -> void:
	if not alive:
		return
	if downed:
		die()          # 队友也吃补刀（与玩家/敌人同一口径）
		return
	hp -= amount
	if hp <= 0.0:
		downed = true
		downed_time_left = GameConfig.DOWNED_TIMEOUT
		if _visual != null:
			_visual.set_downed(true)
		queue_redraw()


func die() -> void:
	alive = false
	downed = false
	if _visual != null:
		_visual.set_downed(true)
	if is_in_group("friendly"):
		remove_from_group("friendly")
	queue_redraw()
