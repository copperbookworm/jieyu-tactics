extends CharacterBody2D

## 玩家的小队队友 —— 使用者 2026-10-02 要求
## 职责：编队跟随玩家 / 按组任务推进；视野内出现敌人就自动交火。
## 数值在 2026-10-07 第八十四版按 docx 19 ㊹ 重新配平（详见下面那一段注释）：
## 单兵战力从敌人的 ≈19 倍压到 ≈1.5 倍，并与敌人共用同一条射击精度基线（AiAccuracy）。
## 复用现成的模块：UnitFigure（角色图）、BlobShadow（影子）、BallisticsSystem（命中判定）、Sfx、EffectSpawner。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

const UnitFigureScript := preload("res://entities/visual/UnitFigure.gd")
const BlobShadowScript := preload("res://entities/effects/BlobShadow.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")
const EffectSpawnerScript := preload("res://systems/effects/EffectSpawner.gd")
const AiAccuracyScript := preload("res://systems/combat/AiAccuracy.gd")

var main = null
## ────────── 2026-10-07 第八十四版 · docx 19 ㊹「20 v 20 压队友强度」──────────
## 配平前（第六十五版口径）队友是「强力一档」，**实测 130 s 推进：敌 20 → 2、友 19 → 19（零阵亡）**。
## 四条不对称（都在这一屏）：
##   ① 有效 DPS：45 / 0.35 s = 128.6 vs 敌人 20 / 1.5 s = 13.3 ⇒ **9.6×**
##   ② 血量：200 vs 100 ⇒ **2×**；③ 速度：3.4 vs 2.0 ⇒ **1.7×**
##   ④ 交战距离 220 m **且零散布必中** vs 敌人 120 m 探测 + 3 MOA ⇒ 队友有约 100 m 白打窗口
## 综合战力比 ≈ 19×（单兵）⇒ 那不是「队友强一点」，是队友替玩家把整局打完了。
## 配平后（使用者 2026-10-07 选择题 A「同一套基线 + 轻微友军优势」）：单兵战力 ≈ 1.5×、总量 ≈ 1.45×。
## 保留一档小优势的理由：友军是**进攻方**，要吃敌人在占领节点上的防御优势。
var hp := 120.0                 ## 敌人 100 ⇒ 1.2×（原来 2×）
var max_hp := 120.0
var alive := true
var downed := false
var downed_time_left := 0.0
var move_speed := 2.4           ## m/s（敌人 2.0 ⇒ 1.2×；原来 3.4）
var fire_damage := 22.0         ## 一发 22：敌人 100 血 ⇒ 5 发带走（原来 45 / 3 发）
var fire_interval := 1.3        ## s（敌人 1.5 ⇒ 略快；原来 0.35）
var engage_range := 150.0       ## m，开火距离（敌人探测 120 ⇒ 留 30 m 的接敌窗口；原来 220）
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
## B1（施工单 §6）：AI 决策的累积计时（秒）。到 `1/GameConfig.AI_DECISION_HZ` 才跑一次
## 「重挑目标 + 开火判定」这两件贵的；目标失效判定、瞄准、移动都仍在每物理步（见 `_physics_process`）。
var _decision_accum := 0.0
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
	# 2026-10-05 轨 2（性能）：**重挑相位错开**。19 名队友原来相位完全一致（同一步里一起重挑），
	# 实测每 0.1 s 在同一个物理步里爆一次 10~50 ms 的卡顿（v4 探针：关掉 Ally 后 >10ms 卡顿 11→5 次、
	# p99 19.9→2.8 ms）。相位错开后这笔成本摊到各帧。
	_pick_timer = randf() * GameConfig.AI_TARGET_RETRY_INTERVAL
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


## 每次重挑最多对几个候选做**贵**的通视检查（与 Enemy.TARGET_SCAN_MAX 同一口径）。
## 2026-10-05 性能修复：队友原先没有这个上限 —— 按组顺序对每个更近的候选都查一次 DDA，
## 最坏一次选敌 20 次 × ~150 µs ≈ 3 ms，19 名队友每 0.1 s 重挑一次 ⇒ ~9.5 ms/帧（实测队友一帧 668 µs）。
const TARGET_SCAN_MAX := 3

## 敌组列表的帧级缓存：一帧内多个队友取同一份，避免每人每次选敌 / 开火都新分配一个 Array。
static var _enemy_cache: Array = []
static var _enemy_cache_frame := -1


static func _cached_enemies() -> Array:
	var frame := Engine.get_physics_frames()
	if frame != _enemy_cache_frame:
		var loop := Engine.get_main_loop() as SceneTree
		_enemy_cache = loop.get_nodes_in_group("enemy") if loop != null else []
		_enemy_cache_frame = frame
	# 组查询只保证「查的那一刻」有效：同一物理帧里单位还会被 die()/free()，缓存里就会留下已释放的引用。
	# 消费方（Ally._pick_target / ui/DebugEnemyArrow）要遍历它，而 `node as Node2D` 碰到已释放对象会报
	# "Trying to cast a freed object"（2026-10-06 集成冒烟实测 3 次；改前是每帧新查询所以看不出）。
	# 返回前剪掉失效项：常见情况（无失效）只多一次 n≈20 的 is_instance_valid 扫描。
	for n in _enemy_cache:
		if is_instance_valid(n):
			continue
		var kept: Array = []
		for m in _enemy_cache:
			if is_instance_valid(m):
				kept.append(m)
		_enemy_cache = kept
		break
	return _enemy_cache


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
	# B1（施工单 §6）：AI 决策与物理步解耦（`GameConfig.AI_DECISION_HZ`，拍板 10 Hz）。队友这一侧的切法比
	# 敌人细，因为三件事必须留在**每物理步**：
	#   ① **目标失效判定** —— 不每步查就会对已释放的目标取 `global_position`（会报错）；
	#   ② **瞄准** —— `facing` 是 `_fire()` 的射击方向，节流会让命中率**悄悄变差**（敌人那侧不受影响，
	#      因为 `_try_fire` 的方向是从位置现算的）；
	#   ③ **`_follow(delta)`（移动）** —— 它内含 `move_and_slide()`，而 `move_and_slide` 每次只推进
	#      一个物理步的距离 ⇒ 若跟着决策一起节流，队友会变成 1/6 速度。
	# 所以只有"贵的两件"（逐候选查通视的 `_pick_target`、弹道结算的 `_fire`）进决策周期。
	if _target != null and not is_instance_valid(_target):
		_target = null
	_decision_accum += delta
	var decision_period := 1.0 / maxf(GameConfig.AI_DECISION_HZ, 0.001)
	var decide := _decision_accum >= decision_period
	if decide:
		var ai_step := _decision_accum
		_decision_accum = 0.0
		# 目标失效立刻重挑；否则按 AI_TARGET_RETRY_INTERVAL 节流（省的是逐候选通视查询）
		_pick_timer -= ai_step
		if _target == null or _pick_timer <= 0.0:
			_target = _pick_target()
			_pick_timer = GameConfig.AI_TARGET_RETRY_INTERVAL
	if _target != null:
		velocity = Vector2.ZERO
		# 瞄准每步都更新（便宜，且射击方向用它）
		var aim: Vector2 = _target.global_position - global_position
		if aim.length() > 0.05:
			facing = aim.normalized()
			if _visual != null:
				_visual.set_aim(facing.angle())
		if decide and _fire_cooldown <= 0.0:
			_fire()
	else:
		_follow(delta)


func _pick_target():
	var enemies := _cached_enemies()
	if enemies.is_empty():
		return null
	# 按距离从近到远，最多对 TARGET_SCAN_MAX 个候选查通视（距离比较廉价、DDA 昂贵）。
	# 语义取舍与 Enemy._pick_target 一致：只在前 3 近的候选里找可见目标，不做全场扫描。
	var best = null
	var best_distance := engage_range
	var scanned := 0
	var floor_distance := 0.0
	while scanned < TARGET_SCAN_MAX:
		best = null
		best_distance = engage_range
		for node in enemies:
			if not (node is Node2D):
				continue
			var d: float = global_position.distance_to(node.global_position)
			if d >= best_distance or d <= floor_distance:
				continue
			best_distance = d
			best = node
		if best == null:
			return null
		scanned += 1
		if _sight == null or _sight.grid == null or _has_sight(best):
			return best
		floor_distance = best_distance
	return null


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
	var targets: Array = _cached_enemies()
	# 2026-10-07 ㊹ 配平：队友原先**零散布**（必中），敌人有 3 MOA —— 口径不同是最大的一条不对称。
	# 现在双方 preload 同一个 AiAccuracy：3 MOA 在 150 m 上约 0.13 m 横向偏差（命中半径 0.25 m），
	# 近距离仍然打得准、远距离才真的会飘 —— 与敌人一条基线。
	var direction := AiAccuracyScript.apply_base_spread(facing, randf_range(-1.0, 1.0))
	var result: Dictionary = BallisticsSystem.resolve_shot(global_position, direction,
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
