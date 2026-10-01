class_name PlayerUnit
extends CharacterBody2D

## 玩家步兵（第一版）：移动 + 视线起点（眼高）
## 碰撞体与视觉都在 _ready 里用代码创建——不手改 .tscn，也不依赖美术资产
## 移动输入先用内置 ui_* 动作（免去项目输入映射配置）；触屏摇杆后续接入
## 朝向不旋转视角（docx：视角恒定不旋转），所以屏幕方向＝世界方向，直接映射

# 弹药/换弹状态变化（供 HUD 刷新）。
signal ammo_changed(mag: int, reserve: int)
signal reload_started
signal reload_finished

## 姿态三态（C2）：站 / 蹲 / 卧
enum Posture { STAND, CROUCH, PRONE }

## 武器表用 preload 常量引用（WeaponTable.gd 刻意不写 class_name，见其文件头说明）
const WeaponTable := preload("res://systems/weapons/WeaponTable.gd")

## 兵种引用走全局 class_name（RoleTable.gd 自带 class_name）

@export var move_speed: float = GameConfig.SOLDIER_SPEED
@export var body_radius: float = 0.4  # m，人形占位半径（视觉与碰撞共用）
@export var hp: float = GameConfig.SOLDIER_HP

var facing := Vector2.RIGHT
var alive := true

# —— 散布与聚焦（第十八章 步兵武器操纵性 + 聚焦模式确认稿）——
var is_moving := false    # 移动中散布放大，站定收紧（动静二分）
var focusing := false     # 聚焦模式：按住收窄准心、降散布
var suppression := 0.0    # 压制值 0..1（docx 7.3），被子弹近失/命中推高，随时间衰减
var input_locked := false  # 冻结移动输入（战术地图打开时由 Main 置位，docx 4.11.7 ①）

# —— 兵种（docx 3.1 兵种表）——
## 兵种只影响弹匣 / 备弹 / 伤害倍率 / 标记时效；散布与射速不动（手感基线先别搅）
var role_id := RoleTable.Role.RIFLEMAN
## 姿态（C2：站/蹲/卧三态）：影响散布精度档、命中面积系数与移动速度
var posture := Posture.STAND
## 通视系统（由 Main 注入）：子弹挡掩体要用它与通视同一套口径
var sight: SightSystem = null

# —— 弹药与射击状态（7.2 确认稿）——
var mag_size := GameConfig.WEAPON_MAG_SIZE  # 发，弹匣容量（按兵种覆盖）
var ammo_in_mag := GameConfig.WEAPON_MAG_SIZE
var reserve_ammo := GameConfig.WEAPON_RESERVE

# —— 武器（docx 7.5 CSV 驱动：data/weapons.csv）——
var weapon: Dictionary = {}   # 当前武器整行数据；空字典表示还没装备
var weapons: Array = []       # 携带的武器 id 列表（兵种决定，第一版主武器 + 副武器）
var _fire_cooldown := 0.0
var _reloading := false
var _reload_time_left := 0.0

# —— 连发与姿态切换计时 ——
var _burst_shots := 0          # 当前连发计数（第 1 发算 1）
var _since_last_shot := 99.0   # s，距上次开火
var _burst_decay_timer := 0.0
var _pending_posture := Posture.STAND  # 切换中的目标姿态
var _posture_timer := 0.0              # 切换剩余时间（C2：0.45 / 0.65 s）
var _weapon_index := 0                 # 携带武器里的当前索引
var _switching := false                # 换枪中（C3：切枪 1.04 s，期间不能开火）
var _switch_time_left := 0.0

var _visual: Sprite2D = null
var _joystick: TouchJoystick = null


func _ready() -> void:
	add_to_group("player")
	_build_collision()
	_build_visual()


func set_joystick(joystick: TouchJoystick) -> void:
	_joystick = joystick


## 当前移动输入（载具驾驶要读它——人在车上时自己的移动被锁，但摇杆方向依然有效）
func move_input() -> Vector2:
	if _joystick == null:
		return Vector2.ZERO
	return _joystick.move_vector


## 丢掉摇杆当前触点（由 Main 在开关地图等切换时机调用，避免触点卡死）
func release_joystick() -> void:
	if _joystick != null:
		_joystick.reset()


## 连发收敛 + 姿态切换计时（抽成公开方法：测试可以直接驱动，不必进场景树跑物理）
func tick_timers(delta: float) -> void:
	# 连发收敛（点射纪律）：停火超过 BURST_RESET_TIME 后按节拍逐发收敛
	if _burst_shots > 0:
		_since_last_shot += delta
		if _since_last_shot > GameConfig.BURST_RESET_TIME:
			_burst_decay_timer += delta
			if _burst_decay_timer >= GameConfig.BURST_DECAY_INTERVAL:
				_burst_decay_timer = 0.0
				_burst_shots -= 1
	# 姿态切换计时（C2：站→蹲 0.45 s、切到卧 0.65 s，到点才生效）
	if _posture_timer > 0.0:
		_posture_timer -= delta
		if _posture_timer <= 0.0:
			posture = _pending_posture
	# 换枪计时（C3：1.04 s，到点才把武器换过去）
	if _switching:
		_switch_time_left -= delta
		if _switch_time_left <= 0.0:
			_switching = false
			if _weapon_index < weapons.size():
				apply_weapon(String(weapons[_weapon_index]))


func _physics_process(delta: float) -> void:
	# 射速冷却递减。
	if _fire_cooldown > 0.0:
		_fire_cooldown -= delta
	# 压制值随时间衰减（docx 7.3：压制效果随时间衰减）
	suppression = SuppressionSystem.decayed(suppression, delta)
	tick_timers(delta)
	# 换弹计时。
	if _reloading:
		_reload_time_left -= delta
		if _reload_time_left <= 0.0:
			_finish_reload()
	if not alive:
		velocity = Vector2.ZERO
		is_moving = false
		return
	# 触屏摇杆输出 → 世界方向（俯视固定视角，不随相机旋转）
	var input_vector := Vector2.ZERO
	# 开图期间冻结移动（docx 4.11.7 ①：地图不暂停游戏，但玩家不能移动/开火）
	if _joystick != null and not input_locked:
		input_vector = _joystick.move_vector
	if input_vector.length() > 0.05:
		facing = input_vector.normalized()
		velocity = facing * move_speed * posture_speed_scale()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	# 动静二分输入：实际速度超过阈值才算"在移动"。
	is_moving = velocity.length() > GameConfig.MOVE_SPEED_EPSILON


## 聚焦模式开关（4 号确认稿：取消开镜，改为按住聚焦）。
func set_focus(on: bool) -> void:
	focusing = on


## 当前有效散布（MOA）：基础 MOA × 动静倍率 × 聚焦倍率。
## 步兵不做后坐力/四姿态晃动，只做"动/静二分 + 聚焦收紧"（第十八章确认稿）。
func effective_spread_moa() -> float:
	var scale := GameConfig.WEAPON_SPREAD_MOVE if is_moving else GameConfig.WEAPON_SPREAD_STILL
	if focusing:
		scale *= GameConfig.FOCUS_SPREAD_SCALE
	# 压制恶化散布——这是压制唯一的「手感惩罚」出口（docx 7.3 功能障碍）
	scale *= SuppressionSystem.spread_multiplier(suppression)
	# 连发扩大 / 点射收敛（7.3）+ 姿态精度档（C3：腰射 / 依托 / 卧姿）
	scale *= burst_spread_multiplier() * posture_spread_multiplier() * support_spread_scale()
	return weapon_moa() * scale


## 当前视线相对地面的高度：卧姿按 C2「矮掩体」降到 0.6 m
## （由 SightSystem.unit_sight_height 通过鸭子类型调用，统一玩家侧的视线口径）
func sight_eye_height() -> float:
	if posture == Posture.PRONE:
		return GameConfig.PRONE_SIGHT_HEIGHT
	return GameConfig.SOLDIER_EYE_HEIGHT


## 当前连发计数（HUD 用）
func burst_shots() -> int:
	return _burst_shots


## 连发散布倍率：第 1 发 ×1.0，之后每多发一发 +BURST_SPREAD_PER_SHOT，封顶 BURST_SPREAD_MAX
func burst_spread_multiplier() -> float:
	var extra := GameConfig.BURST_SPREAD_PER_SHOT * float(maxi(_burst_shots - 1, 0))
	return minf(1.0 + extra, GameConfig.BURST_SPREAD_MAX)


## 姿态散布倍率（C3 精度档）：站 1.0、蹲 0.75、卧 0.5
func posture_spread_multiplier() -> float:
	if posture == Posture.CROUCH:
		return GameConfig.POSTURE_SPREAD_CROUCH
	if posture == Posture.PRONE:
		return GameConfig.POSTURE_SPREAD_PRONE
	return 1.0


## 是否依托掩体（C3：「架枪 / 依托」＝ 蹲或卧 + 贴着掩体，不是第四种姿态）
func is_supported() -> bool:
	if posture == Posture.STAND:
		return false
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return false
	for node in loop.get_nodes_in_group(GameConfig.OCCLUDER_GROUP):
		var cover = node
		if cover == null or not cover.has_method("distance_to_edge"):
			continue
		if cover.distance_to_edge(global_position) <= GameConfig.SUPPORT_RANGE:
			return true
	return false


## 依托精度档（C3）：蹲/卧且贴着掩体时再收一档
func support_spread_scale() -> float:
	return GameConfig.SUPPORT_SPREAD_SCALE if is_supported() else 1.0


## 姿态移动速度倍率：卧姿爬得慢（数值待实测）
func posture_speed_scale() -> float:
	if posture == Posture.CROUCH:
		return GameConfig.POSTURE_SPEED_CROUCH
	if posture == Posture.PRONE:
		return GameConfig.POSTURE_SPEED_PRONE
	return 1.0


## 命中面积系数（C2 确认值）：站 1.0、蹲 0.7、卧 0.5——敌人打卧姿的你更难中
func hit_radius_scale() -> float:
	if posture == Posture.CROUCH:
		return GameConfig.POSTURE_HIT_CROUCH
	if posture == Posture.PRONE:
		return GameConfig.POSTURE_HIT_PRONE
	return GameConfig.POSTURE_HIT_STAND


## 切姿态（C2：站→蹲 0.45 s、切到卧 0.65 s；到时才生效，防止连点刷精度）
func switch_posture(target: int) -> void:
	if target == _pending_posture:
		return
	_pending_posture = target
	_posture_timer = (GameConfig.POSTURE_SWITCH_CROUCH if target == Posture.CROUCH
			else GameConfig.POSTURE_SWITCH_PRONE)


## 循环切姿态：站 → 蹲 → 卧 → 站（触屏一个按钮够用）
func cycle_posture() -> void:
	switch_posture((int(_pending_posture) + 1) % 3)


func posture_name() -> String:
	match posture:
		Posture.CROUCH:
			return "蹲姿"
		Posture.PRONE:
			return "卧姿"
		_:
			return "站姿"


## 累积压制值（被子弹近失或命中时由开火方调用，docx 7.3）
func add_suppression(amount: float) -> void:
	if not alive or amount <= 0.0:
		return
	suppression = clampf(suppression + amount, 0.0, 1.0)


## 当前能否开火（活着、没换弹、没换枪、冷却结束、有弹药）。
func can_fire() -> bool:
	return alive and not _reloading and not _switching \
			and _fire_cooldown <= 0.0 and ammo_in_mag > 0


## 开火：状态检查 → 消耗弹药 → MOA 散布 → 弹道结算（直瞄：射线穿圆 + 射程截断）。
## 返回的 Dictionary 带 fired=true 表示真的打出去了；fired=false 表示被状态拦下。
func shoot(direction: Vector2, enemies: Array) -> Dictionary:
	if not can_fire():
		return {"hit": false, "target": null, "distance": 0.0, "point": global_position,
				"ground_hit": false, "fired": false}
	# 消耗一发 + 设射速冷却（60 / 该枪 RPM 秒）+ 连发计数（连发越久散布越大）
	ammo_in_mag -= 1
	_fire_cooldown = 60.0 / weapon_rpm()
	_burst_shots = mini(_burst_shots + 1, GameConfig.BURST_MAX_SHOTS)
	_since_last_shot = 0.0
	_burst_decay_timer = 0.0
	ammo_changed.emit(ammo_in_mag, reserve_ammo)
	# MOA 散布：方向加一个随机小角度（3 MOA ≈ 0.05°），倍率由 effective_spread_moa() 给出。
	var spread_rad := deg_to_rad(effective_spread_moa() / 60.0)
	var dir := direction.rotated(randf_range(-spread_rad, spread_rad))
	# 弹道结算（直瞄不做弹道高度，见 BallisticsSystem）。
	var result := BallisticsSystem.resolve_shot(
			global_position, dir, weapon_range(), enemies,
			GameConfig.ENEMY_HIT_RADIUS, sight, sight_eye_height())
	result["fired"] = true
	# 打空自动触发换弹。
	if ammo_in_mag <= 0:
		start_reload()
	return result


## 装备一把枪（id 来自 data/weapons.csv）；弹药重置为满匣
func apply_weapon(weapon_id: String) -> void:
	var data := WeaponTable.get_weapon(weapon_id)
	if data.is_empty():
		push_error("[玩家] 武器表里没有 %s" % weapon_id)
		return
	weapon = data
	mag_size = int(WeaponTable.number(data, "mag_size", GameConfig.WEAPON_MAG_SIZE))
	reserve_ammo = int(WeaponTable.number(data, "reserve", GameConfig.WEAPON_RESERVE))
	ammo_in_mag = mag_size
	_reloading = false
	_reload_time_left = 0.0
	_fire_cooldown = 0.0
	_burst_shots = 0
	ammo_changed.emit(ammo_in_mag, reserve_ammo)


## 应用兵种（docx 3.1）：兵种决定携带武器（第一版主武器 + 副武器），数值全部来自武器表
func apply_role(role: int) -> void:
	role_id = role
	weapons = RoleTable.weapon_ids(role)
	_weapon_index = 0
	_switching = false
	_switch_time_left = 0.0
	if not weapons.is_empty():
		apply_weapon(String(weapons[0]))


## 换枪（C3 动作时间基线：切枪 1.04 s；切换期间不能开火，到点才真正换过去）
func switch_weapon() -> void:
	if weapons.size() <= 1 or _switching:
		return
	_weapon_index = (_weapon_index + 1) % weapons.size()
	_switching = true
	_switch_time_left = weapon_switch_time()


func is_switching_weapon() -> bool:
	return _switching


func weapon_switch_time() -> float:
	return WeaponTable.number(weapon, "switch_time", GameConfig.WEAPON_SWITCH_TIME)


## 当前武器数值取用（表里缺列就退回 GameConfig 常量，保证不会空指针式崩）
func weapon_name() -> String:
	return String(weapon.get("name", "无武器"))


func weapon_rpm() -> float:
	return WeaponTable.number(weapon, "rpm", GameConfig.WEAPON_RPM)


func weapon_moa() -> float:
	return WeaponTable.number(weapon, "moa", GameConfig.WEAPON_MOA)


func weapon_range() -> float:
	return WeaponTable.number(weapon, "game_range", GameConfig.WEAPON_MAX_RANGE)


func weapon_field(key: String, fallback: float) -> float:
	return WeaponTable.number(weapon, key, fallback)


## 换弹：有备弹且弹匣未满才开始。
func start_reload() -> void:
	if not alive or _reloading:
		return
	if reserve_ammo <= 0 or ammo_in_mag >= mag_size:
		return
	_reloading = true
	# 空仓换弹更久（7.5：战术 4.28 s / 空仓 4.85 s）。
	_reload_time_left = (weapon_field("reload_empty", GameConfig.WEAPON_RELOAD_EMPTY)
			if ammo_in_mag <= 0
			else weapon_field("reload_tactical", GameConfig.WEAPON_RELOAD_TACTICAL))
	reload_started.emit()


# 换弹完成：把备弹填进弹匣。
func _finish_reload() -> void:
	_reloading = false
	var need := mag_size - ammo_in_mag
	var take := mini(need, reserve_ammo)
	ammo_in_mag += take
	reserve_ammo -= take
	ammo_changed.emit(ammo_in_mag, reserve_ammo)
	reload_finished.emit()


## 受伤与死亡（血量下限 0：单发伤害高于剩余血量时，HUD 不该出现负血量——
## 载具主炮一发 400、步兵满血 100，原先会直接显示 -300）
func take_damage(amount: float) -> void:
	if not alive:
		return
	hp = maxf(hp - amount, 0.0)
	if hp <= 0.0:
		die()


func die() -> void:
	alive = false
	# @tool 测试环境 autoload 信号可能未注册，防御式发信号（同 CaptureZone）。
	if EventBus != null and EventBus.has_signal("player_died"):
		EventBus.emit_signal("player_died")


func _build_collision() -> void:
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = body_radius
	shape.shape = circle
	add_child(shape)


func _build_visual() -> void:
	_visual = Sprite2D.new()
	_visual.texture = _make_dot_texture()
	# 贴图 16 px，1 px = 1 世界单位，要缩到人形直径（1 m 网格下约 0.8 m）
	_visual.scale = Vector2.ONE * (body_radius * 2.0 / 16.0)
	add_child(_visual)


## 程序生成的圆点贴图（蓝＝我方），等比占位用
static func _make_dot_texture() -> ImageTexture:
	var texture_size := 16
	var image := Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8)
	var center := Vector2(texture_size, texture_size) * 0.5
	for y in texture_size:
		for x in texture_size:
			var distance := Vector2(x + 0.5, y + 0.5).distance_to(center)
			if distance <= 6.0:
				image.set_pixel(x, y, Color("4f9de0"))
			elif distance <= 7.5:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.6))
			else:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.0))
	return ImageTexture.create_from_image(image)
