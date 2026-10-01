# enemy.gd
class_name Enemy
extends CharacterBody2D

## 敌方步兵（第二版）：巡逻 → 发现玩家 → 交火（用同一套 BallisticsSystem 还击）
## 通视显隐不变（docx 4.7 ①②级）：没通视不显示
## 碰撞体与视觉用代码创建，不手改 .tscn，不依赖美术资产

enum AIState { PATROL, COMBAT }

@export var hp: float = GameConfig.SOLDIER_HP
@export var body_radius: float = 0.4
@export var move_speed: float = 2.0           # m/s，比玩家慢
@export var detection_range: float = 20.0    # m，发现玩家的距离
@export var fire_interval: float = 1.5        # s，开火间隔
@export var fire_damage: float = 0.0         # 每发伤害（玩家 100 血，5 枪毙命）

var alive := true
var suppression := 0.0  # 压制值 0..1（7.3 反向）：被玩家火力推高 → 还击打不准、不敢露头

var _hold_fire_time := 0.0  # s，被压住时的犹豫计时（不敢露头）
var _suppression_drawn := false  # 上一帧是否画了压制弧（用于「从有到无」那一帧补一次重绘）

var _state: AIState = AIState.PATROL
var _patrol_origin := Vector2.ZERO
var _patrol_target := Vector2.ZERO
var _fire_cooldown := 0.0

var _visual: Sprite2D = null
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


## 累积压制值（玩家子弹近失 / 命中时由 Main 调用；与 Player 同一套压制口径）
func add_suppression(amount: float) -> void:
	if not alive or amount <= 0.0:
		return
	suppression = clampf(suppression + amount, 0.0, 1.0)


func take_damage(amount: float) -> void:
	if not alive:
		return
	hp -= amount
	if hp <= 0.0:
		die()


func die() -> void:
	alive = false
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
	# 不能只在「有压制」时重绘：从「有」掉到「无」的那一帧必须再重绘一次，
	# 否则屏幕上会永久残留最后一帧的小橙弧（2026-09-28 真机 bug：停手 20 s 后弧还在）
	var drawing := suppression > GameConfig.SUPPRESSION_DRAW_THRESHOLD
	if drawing or _suppression_drawn:
		queue_redraw()
	_suppression_drawn = drawing


## AI：发现玩家（通视 + 距离内）→ 交战；否则巡逻
func _update_ai(delta: float) -> void:
	if _player == null or _grid == null:
		return
	var to_player := _player.global_position - global_position
	var distance := to_player.length()
	if _can_see_player() and distance <= detection_range:
		_state = AIState.COMBAT
		velocity = Vector2.ZERO
		_try_fire(delta, to_player)
	else:
		_state = AIState.PATROL
		_move_patrol()


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


## 交火：朝玩家方向弹道结算，命中则让玩家掉血；无论命中与否都出曳光
func _try_fire(delta: float, to_player: Vector2) -> void:
	_fire_cooldown -= delta
	if _fire_cooldown > 0.0 or to_player.length() < 0.001:
		return
	# 被压得太狠就不敢露头：进入犹豫，暂停还击（7.3 反向：压制造成功能障碍）
	if SuppressionSystem.holds_fire(suppression):
		_hold_fire_time = GameConfig.SUPPRESSION_AI_HOLD_TIME
	if _hold_fire_time > 0.0:
		_hold_fire_time -= delta
		return
	_fire_cooldown = fire_interval
	# 还击精度随压制下降：原本零散布直射，被压后必须明显打不准
	var direction := to_player.normalized()
	# 基础散布 + 压制散布：没有基础散布时敌人是零散布直射（必中），距离一远比玩家还准
	var spread_deg := GameConfig.ENEMY_BASE_MOA / 60.0 \
			+ SuppressionSystem.return_fire_spread_deg(suppression)
	if spread_deg > 0.001:
		direction = direction.rotated(deg_to_rad(randf_range(-spread_deg, spread_deg)))
	# 玩家姿态决定命中面积（C2：站/蹲/卧 = 1.0 / 0.7 / 0.5）——卧姿更难被打中
	var hit_radius := GameConfig.ENEMY_HIT_RADIUS
	var target_unit := _player as PlayerUnit
	if target_unit != null:
		hit_radius *= target_unit.hit_radius_scale()
	var result := BallisticsSystem.resolve_shot(
			global_position, direction, GameConfig.WEAPON_MAX_RANGE, [_player], hit_radius,
			_sight, GameConfig.SOLDIER_EYE_HEIGHT)
	var tracer := Tracer.new()
	tracer.setup(global_position, direction, result["distance"])
	get_tree().current_scene.add_child(tracer)
	if result.get("cover_hit", false):
		# 敌人的子弹同样能打坏掩体（否则玩家可以躲在沙袋后白嫖）
		var cover = result.get("cover")
		if cover != null and cover.has_method("take_damage"):
			cover.take_damage(fire_damage * GameConfig.ENEMY_DAMAGE_SCALE)
		return
	if result["hit"]:
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
	if _patrol_target == Vector2.ZERO or global_position.distance_to(_patrol_target) < 1.0:
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
	_visual = Sprite2D.new()
	_visual.texture = _make_dot_texture()
	_visual.scale = Vector2.ONE * (body_radius * 2.0 / 16.0)
	add_child(_visual)


## 程序生成的圆点贴图（红＝敌方）
static func _make_dot_texture() -> ImageTexture:
	var texture_size := 16
	var image := Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	var center := Vector2(texture_size, texture_size) * 0.5
	for y in texture_size:
		for x in texture_size:
			var distance := Vector2(x + 0.5, y + 0.5).distance_to(center)
			if distance <= 6.0:
				image.set_pixel(x, y, Color("d9534f"))
			elif distance <= 7.5:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.6))
			else:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.0))
	return ImageTexture.create_from_image(image)
