# enemy.gd
class_name Enemy
extends CharacterBody2D

## 敌方步兵（第二版）：巡逻 → 发现玩家 → 交火（用同一套 BallisticsSystem 还击）
## 通视显隐不变（docx 4.7 ①②级）：没通视不显示
## 碰撞体与视觉用代码创建，不手改 .tscn，不依赖美术资产
##
## 【候选 P · 2026-10-01】新增 BLIND_FIRE：玩家躲进烟幕后（4.12.5）
## AI 失去通视 → 不再锁定，但会朝「最后已知位置」盲射，命中率 −70%（4.12.8 ④）。
## 只有在「失去通视的原因确实是烟」时才进这个状态，别的情形（地形挡住 / 掩体挡住）行为一字不变。

## 烟雾判定用 preload（SmokeScreen 刻意无 class_name，见其文件头）
const SmokeScreenScript := preload("res://entities/smoke/SmokeScreen.gd")
## 表现层特效（候选 M：12.7.3 / 12.7.4）；无 class_name，preload 引用
const EffectSpawner := preload("res://systems/effects/EffectSpawner.gd")
const BlobShadowScript := preload("res://entities/effects/BlobShadow.gd")
## 12.7.1 上下半身分离的角色图（无 class_name，preload 引用）
const UnitFigureScript := preload("res://entities/visual/UnitFigure.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")

enum AIState { PATROL, COMBAT, BLIND_FIRE }

@export var hp: float = GameConfig.SOLDIER_HP
@export var body_radius: float = 0.4
@export var move_speed: float = 2.0           # m/s，比玩家慢
## m，发现玩家的距离。120 = 正式值（2026-10-02 恢复）。
## 🧪 想开「敌人近视」的测试态：改成 20.0（要贴脸才会被发现，方便测掩体 / 压制 / 潜行）。
@export var detection_range: float = 120.0
@export var fire_interval: float = 1.5        # s，开火间隔
## 每发伤害：20 = 正式值（玩家 100 血 ⇒ 5 枪毙命，2026-10-02 从调试态 0.0 恢复）。
## 🧪 想开「敌人打不死我」的测试态：改成 0.0（与 GameConfig.ENEMY_DAMAGE_SCALE 是两套开关，
## 这里是「每个敌人的单发伤害」，那边是「所有敌人伤害的总倍率」）。
@export var fire_damage: float = 20.0

var alive := true
## 倒地（候选 Q / 使用者 2026-10-02）：血打光先倒地（躺平、不能动不能打），被补刀或流血到点才阵亡
var downed := false
var downed_time_left := 0.0
var suppression := 0.0  # 压制值 0..1（7.3 反向）：被玩家火力推高 → 还击打不准、不敢露头

var _hold_fire_time := 0.0  # s，被压住时的犹豫计时（不敢露头）
var _suppression_drawn := false  # 上一帧是否画了压制弧（用于「从有到无」那一帧补一次重绘）

var _state: AIState = AIState.PATROL
var _patrol_origin := Vector2.ZERO
var _patrol_target := Vector2.ZERO
var _forced_target := false   # 被指定行进目标（候选 L4 穿插兵）时不再自动挑巡逻目标
var _fire_cooldown := 0.0
## 最后已知的玩家位置 + 距今时间（候选 P：4.12.5「朝最后已知位置盲射」的输入）
var _last_known := Vector2.ZERO
var _has_last_known := false
var _last_known_age := 0.0
## 盲射计数（集成冒烟 / 调试读它：无通视时靠它证明「还在打，只是打不准」）
var blind_shots := 0

var _visual = null            ## 12.7.1 起是 UnitFigure（Node2D），不再是 Sprite2D
## 12.3 Blob Shadow：脚下扁椭圆
var _shadow = null
## 12.7.4 受击闪白剩余时间
var _hit_flash_left := 0.0
var _flash_drawn := false
var _sight: SightSystem = null
var _player: Node2D = null
var _camera: Camera2D = null
var _grid: HeightGrid = null
var _visibility_timer := 0.0


func setup(sight: SightSystem, player: Node2D, camera: Camera2D, grid: HeightGrid) -> void:
	_sight = sight
	_player = player
	_camera = camera
	_grid = grid
	_patrol_origin = global_position
	_pick_patrol_target()


func attack() -> void:
	pass


## 指定行进目标（候选 L4：穿插兵沿侧翼通路推进时由 LaneController 调用）
## 指定之后巡逻不再自动挑目标，直到 clear_move_target()
func set_move_target(target: Vector2) -> void:
	_patrol_target = target
	_forced_target = true


## 解除指定目标，回到自动巡逻（挑最近的未被敌方占领的节点）
func clear_move_target() -> void:
	_forced_target = false
	_pick_patrol_target()


## 累积压制值（玩家子弹近失 / 命中时由 Main 调用；与 Player 同一套压制口径）
func add_suppression(amount: float) -> void:
	if not alive or amount <= 0.0:
		return
	suppression = clampf(suppression + amount, 0.0, 1.0)


func take_damage(amount: float) -> void:
	if not alive:
		return
	if downed:
		# 补刀（与玩家同一口径）：对倒地的敌人再打中一发 = 直接阵亡
		die()
		return
	hp -= amount
	# 12.7.4 受击闪白：命中反馈要看得见（闪白由 _draw 叠在身体上）
	_hit_flash_left = GameConfig.HIT_FLASH_TIME
	queue_redraw()
	Sfx.play("impact")          # 10 章：命中音（在「真的扣了血」的地方放，脱靶不会响）
	if hp <= 0.0:
		_go_down()


## 血打光 → 倒地（不是立刻阵亡）：躺平、不能动不能打，等被补刀或流血到点
func _go_down() -> void:
	if downed or not alive:
		return
	downed = true
	downed_time_left = GameConfig.ENEMY_DOWNED_TIMEOUT
	velocity = Vector2.ZERO
	if _visual != null:
		_visual.set_downed(true)
	queue_redraw()


func die() -> void:
	alive = false
	downed = false
	if _visual != null:
		_visual.set_downed(true)   # 尸体保持躺平
	queue_redraw()
	# @tool 测试环境 autoload 信号可能未注册，防御式发信号（同 CaptureZone）。
	if EventBus != null and EventBus.has_signal("enemy_killed"):
		EventBus.emit_signal("enemy_killed", self)
	queue_free()


func _ready() -> void:
	add_to_group("enemy")
	_build_collision()
	_build_visual()
	visible = false


func _physics_process(delta: float) -> void:
	if not alive:
		return
	_update_ai(delta)
	move_and_slide()
	# 12.7.1：下半身随移动方向；速度太小时保持上一个朝向（站住时腿停在原地不抽）
	if _visual != null:
		var speed := velocity.length()
		var angle: float = _visual.lower_angle()
		if speed > 0.05:
			angle = velocity.angle()
		_visual.set_move(angle, speed / maxf(move_speed, 0.001), delta)


func _process(delta: float) -> void:
	_visibility_timer += delta
	if _visibility_timer >= 0.1:
		_visibility_timer = 0.0
		_update_visibility()
	# 压制随时间衰减（与玩家同一套衰减，docx 7.3）
	suppression = SuppressionSystem.decayed(suppression, delta)
	if _visual != null:
		# 被压住的敌人压暗偏橙——幅度必须够大，真机反馈「几乎看不出变化」（2026-09-28）
		_visual.modulate = Color(1.0, 1.0 - 0.6 * suppression, 1.0 - 0.8 * suppression)
	# 12.7.4 受击闪白衰减（与压制同一条每帧路径）
	if _hit_flash_left > 0.0:
		_hit_flash_left = maxf(_hit_flash_left - delta, 0.0)
	var flashing := _hit_flash_left > 0.0
	# 不能只在「有压制」时重绘：从「有」掉到「无」的那一帧必须再重绘一次，
	# 否则屏幕上会永久残留最后一帧的小橙弧（2026-09-28 真机 bug：停手 20 s 后弧还在）。
	# 受击闪白是同一类坑（_draw 的内容不会自己清），所以两个状态一起判。
	var drawing := suppression > GameConfig.SUPPRESSION_DRAW_THRESHOLD
	if drawing or _suppression_drawn or flashing or _flash_drawn:
		queue_redraw()
	_suppression_drawn = drawing
	_flash_drawn = flashing


## AI：发现玩家（通视 + 距离内）→ 交战；只被烟挡住 → 朝最后已知位置盲射；否则巡逻
func _update_ai(delta: float) -> void:
	# 自己倒地：不能动也不能打，只走流血计时（到点阵亡）。补刀在 take_damage 里 ——
	# 使用者 2026-10-02 拍板「倒地可被补刀（更硬核）」，所以这里不再阻止 AI 打倒地目标。
	if downed:
		downed_time_left -= delta
		velocity = Vector2.ZERO
		if downed_time_left <= 0.0:
			die()
		return
	if _player == null or _grid == null:
		return
	_last_known_age += delta
	var to_player := _player.global_position - global_position
	var distance := to_player.length()
	var sees_player := _can_see_player()
	if sees_player:
		_last_known = _player.global_position
		_has_last_known = true
		_last_known_age = 0.0
	if sees_player and distance <= effective_detection_range():
		_state = AIState.COMBAT
		velocity = Vector2.ZERO
		_try_fire(delta, _player.global_position, false)
	elif distance <= effective_detection_range() and _blind_fire_ready() \
			and _smoke_blocks_player():
		# 4.12.5：无通视即无目标，但可以朝最后已知位置盲射（命中率 −70%）
		_state = AIState.BLIND_FIRE
		velocity = Vector2.ZERO
		_try_fire(delta, _last_known, true)
	else:
		_state = AIState.PATROL
		_move_patrol()
	# 12.7.1：上半身（Upper）朝目标 —— 交火 / 盲射时朝目标方向，巡逻时朝移动方向
	if _visual != null:
		var look := Vector2.ZERO
		if sees_player:
			look = _player.global_position - global_position
		elif _state == AIState.BLIND_FIRE:
			look = _last_known - global_position
		elif velocity.length() > 0.05:
			look = velocity
		if look.length() > 0.05:
			_visual.set_aim(look.angle())


## 4.17 草丛隐蔽：玩家在草丛里（卧姿更隐蔽）时，被发现的距离按隐蔽度打折。
## 注意这是「发现距离」，不是通视——通视仍走 _can_see_player（地形 / 掩体 / 烟三层）。
func effective_detection_range() -> float:
	var concealment := 0.0
	if _player != null and _player.has_method("terrain_concealment"):
		concealment = clampf(float(_player.terrain_concealment()), 0.0,
				GameConfig.TERRAIN_CONCEAL_MAX)
	return detection_range * (1.0 - concealment)


## 是否还有可用的「最后已知位置」（见过，且没过 SMOKE_BLIND_FIRE_WINDOW）
func _blind_fire_ready() -> bool:
	return _has_last_known and _last_known_age <= GameConfig.SMOKE_BLIND_FIRE_WINDOW


## 玩家是否被烟挡住（只问烟这一层：地形 / 掩体挡住时 AI 照旧巡逻，不进盲射）
func _smoke_blocks_player() -> bool:
	if _sight == null or _player == null or _sight.grid == null:
		return false
	return _sight.smoke_blocks(global_position, _sight.eye_height_at(global_position),
			_player.global_position, _target_sight_height())


## 当前是否在盲射（表现 / 集成冒烟读它）
func is_blind_firing() -> bool:
	return _state == AIState.BLIND_FIRE


## 盲射瞄的是哪儿（＝最后已知位置，不是玩家实时位置——4.11.2「最后目击位置」红线）
func blind_aim_target() -> Vector2:
	return _last_known


## 能否看到玩家：地形通视（容差在 SightSystem 里）
func _can_see_player() -> bool:
	if _sight == null or _player == null or _sight.grid == null:
		return false
	# 通视统一用眼高（1.6），与玩家准心钳制一致——否则敌人(身体0.9)和玩家准心(眼1.6)
	# 口径不同，会在起伏地形产生「敌能打我、我瞄不到敌」的单向通视。
	var origin_height := _sight.eye_height_at(global_position)
	# 玩家卧姿时目标高度降到 0.6 m（C2 矮掩体）：卧下更容易被地形与沙袋挡住
	return _sight.has_sight(global_position, origin_height,
			_player.global_position, _target_sight_height())


## 视线目标高度：直接走 SightSystem 的统一口径（卧姿 0.6 m 矮掩体）
func _target_sight_height() -> float:
	return _sight.unit_sight_height(_player.global_position, _player)


## 交火：朝 aim_at（玩家实际位置，或盲射时的最后已知位置）方向弹道结算，
## 命中则让玩家掉血；无论命中与否都出曳光。
## blind = true 时按 4.12.8 ④ 把命中率打到 30%（无通视即无目标，只允许压制性盲射）
func _try_fire(delta: float, aim_at: Vector2, blind: bool = false) -> void:
	_fire_cooldown -= delta
	var to_target := aim_at - global_position
	if _fire_cooldown > 0.0 or to_target.length() < 0.001:
		return
	# 被压得太狠就不敢露头：进入犹豫，暂停还击（7.3 反向：压制造成功能障碍）
	if SuppressionSystem.holds_fire(suppression):
		_hold_fire_time = GameConfig.SUPPRESSION_AI_HOLD_TIME
	if _hold_fire_time > 0.0:
		_hold_fire_time -= delta
		return
	_fire_cooldown = fire_interval
	if blind:
		blind_shots += 1
	# 还击精度随压制下降：原本零散布直射，被压后必须明显打不准
	var direction := to_target.normalized()
	# 基础散布 + 压制散布：没有基础散布时敌人是零散布直射（必中），距离一远比玩家还准
	var spread_deg := GameConfig.ENEMY_BASE_MOA / 60.0 \
			+ SuppressionSystem.return_fire_spread_deg(suppression)
	if spread_deg > 0.001:
		direction = direction.rotated(deg_to_rad(randf_range(-spread_deg, spread_deg)))
	# 玩家姿态决定命中面积（C2：站/蹲/卧 = 1.0 / 0.7 / 0.5）——卧姿更难被打中
	var hit_radius := GameConfig.ENEMY_HIT_RADIUS
	var target_unit := _player as PlayerUnit
	if target_unit != null:
		# 4.17：贴掩体不聚焦＝缩在掩体后，命中面积再打折；探头（聚焦）＝暴露回满
		hit_radius *= target_unit.hit_radius_scale() * target_unit.exposure_scale()
	var result := BallisticsSystem.resolve_shot(
			global_position, direction, GameConfig.WEAPON_MAX_RANGE, [_player], hit_radius,
			_sight, GameConfig.SOLDIER_EYE_HEIGHT)
	var tracer := Tracer.new()
	tracer.setup(global_position, direction, result["distance"])
	get_tree().current_scene.add_child(tracer)
	# 12.7.3 / 12.7.4：敌人开枪同样有枪口火光与弹着特效（双方一致，玩家才看得出「它在打哪」）
	EffectSpawner.muzzle_at(self, global_position, direction)
	var impact_kind := EffectSpawner.IMPACT_GROUND
	if result.get("cover_hit", false):
		impact_kind = EffectSpawner.IMPACT_COVER
	elif result.get("hit", false):
		impact_kind = EffectSpawner.IMPACT_UNIT
	EffectSpawner.impact_at(self, result.get("point", global_position), impact_kind)
	Sfx.play("shot_enemy")      # 10 章：敌人枪声（音量配方比玩家小一档，能分敌我）
	if result.get("cover_hit", false):
		# 敌人的子弹同样能打坏掩体（否则玩家可以躲在沙袋后白嫖）
		var cover = result.get("cover")
		if cover != null and cover.has_method("take_damage"):
			cover.take_damage(fire_damage * GameConfig.ENEMY_DAMAGE_SCALE)
		return
	if result["hit"]:
		# 盲射：命中判定成立后再按 −70% 抽一次（4.12.5 / 4.12.8 ④）
		if blind and not SmokeScreenScript.keeps_blind_hit(randf()):
			result["hit"] = false
		else:
			var target := result["target"] as PlayerUnit
			if target != null:
				target.take_damage(fire_damage * GameConfig.ENEMY_DAMAGE_SCALE)
				target.add_suppression(GameConfig.SUPPRESSION_HIT_BONUS)
				return
	# 未命中：看弹道离玩家多近——够近才算压制（docx 7.3「弹药从身边飞过」）
	_suppress_near_miss(direction)


## 近失压制：弹道到玩家的最近距离决定积累量，越贴近压得越狠
func _suppress_near_miss(direction: Vector2) -> void:
	var target := _player as PlayerUnit
	if target == null:
		return
	var factor := SuppressionSystem.near_miss_factor(global_position, direction,
			target.global_position)
	if factor <= 0.0:
		return
	target.add_suppression(SuppressionSystem.per_shot_amount(factor))


func _move_patrol() -> void:
	# 被指定了行进目标（候选 L4：穿插兵沿侧翼通路推进）时不再自动挑目标
	if not _forced_target and (_patrol_target == Vector2.ZERO
			or global_position.distance_to(_patrol_target) < 1.0):
		_pick_patrol_target()
	var direction := _patrol_target - global_position
	if direction.length() > 0.001:
		velocity = direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO


## 巡逻目标：优先走向最近的"未被敌方占领"的节点（占领行为，docx 4.2）；
## 没有可用节点才退化为出生点附近随机游走
func _pick_patrol_target() -> void:
	if is_inside_tree():
		var best: Node2D = null
		var best_distance := INF
		for node in get_tree().get_nodes_in_group("capture_zone"):
			var zone := node as CaptureZone
			if zone == null or zone.state == CaptureZone.State.RED:
				continue
			var distance := global_position.distance_to(zone.global_position)
			if distance < best_distance:
				best_distance = distance
				best = zone
		if best != null:
			_patrol_target = best.global_position
			return
	var offset := Vector2(randf_range(-30.0, 30.0), randf_range(-30.0, 30.0))
	_patrol_target = _patrol_origin + offset


## ① 框检测 → ② 地形通视（③ 掩体层第一版未接入）
func _update_visibility() -> void:
	if not alive or _sight == null or _player == null or _sight.grid == null:
		visible = false
		return
	var center: Vector2 = _player.global_position
	var zoom: float = 1.0
	if _camera != null:
		center = _camera.global_position
		zoom = _camera.zoom.x
	if not _sight.in_world_view(global_position, center, zoom):
		visible = false
		return

	# 玩家侧视线高度按其姿态（卧姿 0.6 m）：趴在沙袋后应该「看不见」，而不是「看得见但打不到」
	var origin_height := _sight.unit_sight_height(_player.global_position, _player)
	var target_height := _sight.eye_height_at(global_position)
	# 掩体层也要算：躲在沙袋后的敌人不该被看见（docx 4.7 第③级）
	visible = _sight.has_sight(_player.global_position, origin_height,
			global_position, target_height)


## 压制指示：脚下画一圈橙色弧，弧长＝压制值。
## 只靠「压暗」在真机上看不出来（红色圆点本来就暗），必须给个形状量
func _draw() -> void:
	# 12.7.4 受击闪白：先画白圈（不挡下面的压制弧，形状量优先）
	if _hit_flash_left > 0.0:
		draw_circle(Vector2.ZERO, body_radius * 1.15,
				Color(1.0, 1.0, 1.0, GameConfig.HIT_FLASH_ALPHA
						* (_hit_flash_left / GameConfig.HIT_FLASH_TIME)))
	if not _suppression_drawn:
		return
	draw_arc(Vector2.ZERO, body_radius * 3.0, -PI * 0.5, -PI * 0.5 + TAU * suppression,
			24, Color(1.0, 0.55, 0.15, 0.95), 3.0)


func _build_collision() -> void:
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = body_radius
	shape.shape = circle
	add_child(shape)


func _build_visual() -> void:
	# 12.3：阴影先建，永远压在身体下面
	_shadow = BlobShadowScript.new()
	_shadow.name = "BlobShadow"
	_shadow.fit_body(body_radius)
	add_child(_shadow)
	# 12.7.1：与玩家同一套角色图（Lower / Upper 分离），只是配色不同 —— 24 兵种共用动作的意思
	_visual = UnitFigureScript.new()
	_visual.name = "Figure"
	_visual.show_behind_parent = true
	add_child(_visual)
	_visual.setup_figure(body_radius, GameConfig.UNIT_COLOR_ENEMY)
