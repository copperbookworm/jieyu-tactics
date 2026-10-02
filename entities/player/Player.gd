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
## 环境互动区查询（TerrainZones.gd 同样刻意不写 class_name）
const TerrainZones := preload("res://systems/terrain/TerrainZones.gd")
## 表现层特效（候选 M：12.7.3 枪口火光 / 12.7.4 命中特效）；无 class_name，preload 引用
const EffectSpawner := preload("res://systems/effects/EffectSpawner.gd")
## 12.3 阴影（EffectSpawner 已 preload 了另两个特效）
const BlobShadowScript := preload("res://entities/effects/BlobShadow.gd")
## 12.7.1 上下半身分离的角色图（无 class_name，preload 引用）
const UnitFigureScript := preload("res://entities/visual/UnitFigure.gd")
## 10 章音效入口（运行时找 autoload，调用点不依赖编译期全局名）
const Sfx := preload("res://systems/audio/Sfx.gd")

## 兵种引用走全局 class_name（RoleTable.gd 自带 class_name）

@export var move_speed: float = GameConfig.SOLDIER_SPEED
@export var body_radius: float = 0.4  # m，人形占位半径（视觉与碰撞共用）
@export var hp: float = GameConfig.SOLDIER_HP

var facing := Vector2.RIGHT
var alive := true
## 出生点（WorldSetup 放置玩家时写入；重生回这里）
var respawn_point := Vector2.ZERO
## 4.16 被击倒：血量归零不立刻阵亡 —— 先进倒地态，默认 60 s 无人扶起才转阵亡
var downed := false
var downed_time_left := 0.0

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

# —— 环境互动（docx 4.17，候选 O 第四轮）——
## 环境互动区（泥泞 / 雪地 / 草丛）：由 WorldSetup 建好后注入；移速倍率与隐蔽度都从这里查
var zones: Array = []
## 本帧是否贴着掩体（影响暴露面积）；由 tick_timers 刷新，测试可以直接置位
var hugging := false

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

var _visual = null            ## 12.7.1 起是 UnitFigure（Node2D），不再是 Sprite2D
var _joystick: TouchJoystick = null
## 12.3 Blob Shadow：脚底的扁椭圆（身体的子节点，show_behind_parent）
var _shadow = null
## 12.7.1 上半身（Upper）的朝向＝准星方向；由 HudBuilder 每帧推过来（它本来就算这个方向）
var aim_direction := Vector2.RIGHT
## 12.7.4 受击闪白剩余时间
var _hit_flash_left := 0.0
var _flash_drawn := false


func _ready() -> void:
	add_to_group("player")
	_build_collision()
	_build_visual()


func set_joystick(joystick: TouchJoystick) -> void:
	_joystick = joystick


## 当前移动输入（载具驾驶要读它——人在车上时自己的移动被锁，但摇杆方向依然有效）
func move_input() -> Vector2:
	if not alive or downed:
		return Vector2.ZERO
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
			if _visual != null:
				_visual.set_posture(posture)   # 12.7.1：姿态进角色图（站 / 蹲 / 卧三套身体形状）
	# 环境互动（4.17）：每帧刷新「是否贴着掩体」——与姿态、连发计时在同一处推进
	hugging = _compute_hugging()
	# 换枪计时（C3：1.04 s，到点才把武器换过去）
	if _switching:
		_switch_time_left -= delta
		if _switch_time_left <= 0.0:
			_switching = false
			if _weapon_index < weapons.size():
				apply_weapon(String(weapons[_weapon_index]))
	# 12.7.4 受击闪白衰减：与压制橙弧同一个坑 —— 「从有到无」那一帧也要重绘，
	# 否则白圈会永久留在屏幕上（_draw 的内容不会自己清）
	if _hit_flash_left > 0.0:
		_hit_flash_left = maxf(_hit_flash_left - delta, 0.0)
	var flashing := _hit_flash_left > 0.0
	if flashing or _flash_drawn:
		queue_redraw()
	_flash_drawn = flashing
	# 12.7.1：把朝向与实际速度喂给角色图（腿的相位随速度推进，站住就冻住）。
	# 用上一帧的 velocity 算相位，差一帧看不出来；好处是测试可以直接调 tick_timers 驱动。
	if _visual != null:
		_visual.set_move(facing.angle(), velocity.length() / maxf(move_speed, 0.001), delta)


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
	# 4.16 倒地：无法行动，只推进倒地计时；到点转阵亡（die 会发 player_died → 失败结算）
	if downed:
		downed_time_left -= delta
		if downed_time_left <= 0.0:
			die()
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
		velocity = facing * effective_move_speed()
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


## 实际移动速度：基础速度 × 姿态档 × 地形档（4.17：泥泞 / 雪地减速）
func effective_move_speed() -> float:
	return move_speed * posture_speed_scale() * terrain_speed_scale()


## 当前位置的地形移速倍率（4.17：泥 0.70 / 雪 0.55 / 其余 1.0；多片重叠取最慢的那片）
func terrain_speed_scale() -> float:
	return TerrainZones.speed_scale_at(zones, global_position)


## 当前位置的隐蔽度（4.17：草丛 0.35、卧姿再 +0.20、封顶 0.60）——Enemy 据此缩短发现距离
func terrain_concealment() -> float:
	return TerrainZones.concealment_at(zones, global_position, posture == Posture.PRONE)


## 4.17 掩体互动：贴着掩体但不聚焦＝缩在掩体后（命中面积打折）；
## 按住聚焦＝探头（暴露回满，换来聚焦那档散布收紧）。第一版不做「探头的视野限制」。
func exposure_scale() -> float:
	if hugging and not focusing:
		return GameConfig.COVER_HUG_EXPOSURE
	return 1.0


## 是否贴着掩体（与 is_supported 同一套组查询，半径不同；测试环境没有掩体则为假）
func _compute_hugging() -> bool:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null:
		return false
	for node in loop.get_nodes_in_group(GameConfig.OCCLUDER_GROUP):
		var cover = node
		if cover == null or not cover.has_method("distance_to_edge"):
			continue
		if cover.distance_to_edge(global_position) <= GameConfig.COVER_HUG_RANGE:
			return true
	return false


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
	return alive and not downed and not _reloading and not _switching \
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
	# 12.7.3 / 12.7.4：枪口火光 + 弹着点特效 —— 由开枪的人自己放，Main 一行都不用加（≤400 是硬线）
	EffectSpawner.muzzle_at(self, global_position + dir * GameConfig.MUZZLE_OFFSET, dir)
	var impact_kind := EffectSpawner.IMPACT_GROUND
	if result.get("hit", false):
		impact_kind = EffectSpawner.IMPACT_UNIT
	elif result.get("cover_hit", false):
		impact_kind = EffectSpawner.IMPACT_COVER
	EffectSpawner.impact_at(self, result.get("point", global_position), impact_kind)
	Sfx.play("shot")            # 10 章：枪声
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
	if downed or weapons.size() <= 1 or _switching:
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


## 伤害随距离线性衰减（7.2 / 武器表口径：起点内满伤、终点外最低伤）
## 2026-10-01 从 Main.gd 搬来（候选 L2）：读的是本玩家的武器行，本来就该由玩家自己答。
func damage_at(distance: float) -> float:
	var base := weapon_field("dmg_base", GameConfig.WEAPON_DAMAGE_BASE)
	var lowest := weapon_field("dmg_min", GameConfig.WEAPON_DAMAGE_MIN)
	var start := weapon_field("falloff_start", GameConfig.WEAPON_DAMAGE_FALLOFF_START)
	var end := weapon_field("falloff_end", GameConfig.WEAPON_DAMAGE_FALLOFF_END)
	if distance <= start:
		return base
	if distance >= end:
		return lowest
	var t := (distance - start) / maxf(end - start, 0.001)
	return lerpf(base, lowest, t)


## 换弹：有备弹且弹匣未满才开始。
func start_reload() -> void:
	if not alive or downed or _reloading:
		return
	if reserve_ammo <= 0 or ammo_in_mag >= mag_size:
		return
	_reloading = true
	Sfx.play("reload")          # 10 章：换弹
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
## 4.16 起：血量归零进「倒地」而不是立刻阵亡。
func take_damage(amount: float) -> void:
	if not alive:
		return
	if downed:
		if GameConfig.ENEMY_FINISH_OFF_ENABLED:
			# 补刀（2026-10-02 拍板：更硬核）：倒地再中一发 = 直接阵亡 → 扣 1 次预算立刻重生。
			# die() 发 player_died → MatchFlow 扣预算 → 立刻重生；预算耗尽才判负。
			die()
		# 关掉时（🧪 测试态）：倒地期间免伤（流弹 / 爆炸也不算补刀），可安稳等 60 s 流血结算
		return
	hp = maxf(hp - amount, 0.0)
	# 12.7.4 受击反馈：闪白（本体画白圈）+ 广播给相机做轻微屏幕震动
	_hit_flash_left = GameConfig.HIT_FLASH_TIME
	queue_redraw()
	Sfx.play("hit")             # 10 章：自己挨打的反馈音
	if EventBus != null and EventBus.has_signal("player_hit"):
		EventBus.emit_signal("player_hit", amount)
	if hp <= 0.0:
		down()


## 4.16 被击倒：血量归零 → 倒地。期间无法移动 / 开火 / 换弹 / 换枪，相机锁死在身体上，
## 画面去色 + 暗角 + 倒计时；DOWNED_TIMEOUT 秒无人扶起才转阵亡。
func down() -> void:
	if downed or not alive:
		return
	downed = true
	downed_time_left = GameConfig.DOWNED_TIMEOUT
	velocity = Vector2.ZERO
	is_moving = false
	focusing = false
	if _visual != null:
		_visual.set_downed(true)   # 倒地就躺下（不再是站姿）
	release_joystick()   # 丢掉还按在摇杆上的触点，倒地瞬间不会卡住
	if EventBus != null and EventBus.has_signal("player_downed"):
		EventBus.emit_signal("player_downed")


## 被扶起（4.16 的队友救援路径：医疗兵优先）。第一版单机没有队友，
## 这个接口留给后续的小队系统与测试；扶起后的血量取 GameConfig.DOWNED_REVIVE_HP。
func revive() -> void:
	if not downed:
		return
	downed = false
	downed_time_left = 0.0
	hp = maxf(hp, GameConfig.DOWNED_REVIVE_HP)
	if _visual != null:
		_visual.set_downed(false)


## 失去战斗能力（倒地或已阵亡）：敌人 AI 与重生流程都看这个，别再对它开火
func is_incapacitated() -> bool:
	return downed or not alive


## 重生（候选 Q 的战局流程用）。与上面的 revive() 是**两件事**，别混：
##   revive()  = 被队友扶起：只在倒地态有效，血量只补到 DOWNED_REVIVE_HP，位置不动；
##   respawn() = 消耗一次重生预算后的重新进场：满血 + 回出生点 + 状态清零 + 补满弹匣。
## 省略 at（INF）时用 respawn_point（WorldSetup 放置玩家时记下的出生点）。
func respawn(at: Vector2 = Vector2.INF) -> void:
	alive = true
	downed = false
	downed_time_left = 0.0
	hp = GameConfig.SOLDIER_HP
	suppression = 0.0
	_hit_flash_left = 0.0
	_flash_drawn = false
	focusing = false
	_reloading = false
	_reload_time_left = 0.0
	velocity = Vector2.ZERO
	is_moving = false
	input_locked = false
	visible = true
	ammo_in_mag = mag_size
	if _visual != null:
		_visual.set_downed(false)
	if at != Vector2.INF:
		global_position = at
	elif respawn_point != Vector2.ZERO:
		global_position = respawn_point
	release_joystick()
	queue_redraw()


func die() -> void:
	if not alive:
		return
	downed = false
	downed_time_left = 0.0
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


## 12.7.4 受击闪白：受击后短暂叠一圈白（12.3 的阴影挂在 z_index -1，白圈画在本体上）
func _draw() -> void:
	if _hit_flash_left <= 0.0:
		return
	draw_circle(Vector2.ZERO, body_radius * 1.15,
			Color(1.0, 1.0, 1.0, GameConfig.HIT_FLASH_ALPHA
					* (_hit_flash_left / GameConfig.HIT_FLASH_TIME)))


func _build_visual() -> void:
	# 12.3：阴影先建（show_behind_parent + z_index -1），永远压在身体下面
	_shadow = BlobShadowScript.new()
	_shadow.name = "BlobShadow"
	_shadow.fit_body(body_radius)
	add_child(_shadow)
	# 12.7.1：上下半身分离（第一版用程序绘制替代帧资源）。
	# 图是子节点：让它画在父节点（受击闪白那一圈白）之下，闪白才能盖在图上。
	_visual = UnitFigureScript.new()
	_visual.name = "Figure"
	_visual.show_behind_parent = true
	add_child(_visual)
	_visual.setup_figure(body_radius, GameConfig.UNIT_COLOR_PLAYER)
	_visual.set_posture(posture)
	_visual.set_aim(aim_direction.angle())


## 12.7.1：上半身（Upper）随准星方向 —— 方向由 HudBuilder 每帧算好推过来，Main 不必插一行
func set_aim_direction(direction: Vector2) -> void:
	if direction.length_squared() <= 0.000001:
		return
	aim_direction = direction.normalized()
	if _visual != null:
		_visual.set_aim(aim_direction.angle())
