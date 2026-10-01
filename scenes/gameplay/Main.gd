extends Node2D

## 间瞄模块用 preload（这两个文件刻意不写 class_name，避免「新类未进全局类缓存」那套问题）
const IndirectFireScript := preload("res://systems/combat/IndirectFire.gd")
const IndirectOverlayScript := preload("res://ui/IndirectOverlay.gd")
## 2026-09-30 候选 N：按职责拆出的四个 Node 子模块（同样不写 class_name，统一 preload 引用）
const WorldSetupScript := preload("res://scenes/gameplay/WorldSetup.gd")
const VehicleControllerScript := preload("res://scenes/gameplay/VehicleController.gd")
const MarkControllerScript := preload("res://systems/marks/MarkController.gd")
const HudBuilderScript := preload("res://ui/HudBuilder.gd")

## 第一版主场景装配（挂在 Main.tscn 的根节点上）
## 地形、玩家、相机、敌人、HUD 全部在 _ready 里用代码创建——
## 场景文件只需要一个空 Node2D + 本脚本，避免手改 .tscn
##
## 【候选 N · 职责拆分（2026-09-30）】本文件从 968 行瘦到 400 行以内，只剩四件事：
##   ① 配置：@export 开关 ② 装配：new 出各系统与四个子模块 ③ 信号接线：全在 _wire_signals()
##   ④ 战局流程：分数 / 任务结算 / 占领胜负 / 间瞄 / 输入
## 分工：世界建场 → WorldSetup ｜ HUD 构建与刷新 → HudBuilder
##       载具（上下车·换座·操炮·开火）→ VehicleController ｜ 报点标记链 → MarkController
## 拆分时的字段改名（模块要读，所以从私有变公开）：_score → score、
##   _capture_zones → capture_zones、_terrain_sprite.texture → terrain_texture、_indirect → indirect
## 子模块一律用鸭子类型拿本节点（Main 没有 class_name），所以这里的字段就是模块的接口。

@export var map_seed: int = GameConfig.DEFAULT_MAP_SEED
@export var enemy_count: int = 2
## 自制高度图路径（工具链 A）：留空则用噪声地形；填 res:// 路径或绝对路径即导入
@export var map_height_image: String = GameConfig.MAP_HEIGHT_IMAGE
## 开局兵种（docx 3.1）：0 = 步枪兵，1 = 侦察兵（标记 90 s），2 = 精确射手
@export var player_role: int = RoleTable.Role.RIFLEMAN
## 开局载具（docx 第八章）：ifv_a 步兵战车 / mbt_t1 主战坦克
@export var vehicle_id: String = "ifv_a"
## 地图检测模式开关：勾上后只建地形 + 预览层，不建玩家/敌人/占领/任务
@export var map_preview_mode: bool = false

## 世界中转站：由 WorldSetup 建好后写回，各模块都从这里取
var grid: HeightGrid = null
var sight: SightSystem = null
var player: PlayerUnit = null
var camera: Camera2D = null
var camera_controller: AimCameraController = null
var terrain_texture: Texture2D = null
## 占领节点（HudBuilder 刷 HUD、TacticalMap / QuestSystem 都要读）
var capture_zones: Array = []

## 四个子模块（各自持有本节点引用）
var world = null            # WorldSetup
var vehicles = null         # VehicleController
var mark_ctl = null         # MarkController
var hud = null              # HudBuilder

## 各系统
var quests: QuestSystem = null
var marks: MarkSystem = null
var indirect = null         # IndirectFire（preload 脚本实例，动态类型：不标类型才不会卡未知成员）

var score := 0              # 战力分（HUD 由 HudBuilder 显示）
var _indirect_overlay = null
var _victory := false
var _defeat := false


func _ready() -> void:
	world = WorldSetupScript.new()
	world.name = "WorldSetup"
	add_child(world)
	world.setup(self, map_height_image, map_seed, enemy_count)
	if map_preview_mode:
		return
	# 载具（docx 第八章）：我方 IFV 在出生点旁，敌方坦克带 AI
	vehicles = VehicleControllerScript.new()
	vehicles.name = "VehicleController"
	add_child(vehicles)
	vehicles.setup(self, player, sight, vehicle_id)
	# 报点 / 标记（docx 4.11.2）：标记系统要在建 HUD 之前建好（小地图要引用它）
	marks = MarkSystem.new()
	marks.name = "MarkSystem"
	add_child(marks)
	mark_ctl = MarkControllerScript.new()
	mark_ctl.name = "MarkController"
	add_child(mark_ctl)
	mark_ctl.setup(self, marks)
	var mark_overlay := MarkOverlay.new()
	mark_overlay.name = "MarkOverlay"
	mark_overlay.setup(marks)
	add_child(mark_overlay)
	# 间瞄火力（docx 7.4 / 4.11.3）：先于 HUD 创建（HUD 标签要读它的弹药数）
	indirect = IndirectFireScript.new()
	indirect.name = "IndirectFire"
	add_child(indirect)
	indirect.setup(player, sight)
	indirect.shell_landed.connect(_on_indirect_landed)
	_indirect_overlay = IndirectOverlayScript.new()
	_indirect_overlay.name = "IndirectOverlay"
	_indirect_overlay.setup(indirect)
	add_child(_indirect_overlay)
	# HUD（含战术地图图层 / 小地图 / 任务卡片 / 报点轮盘）
	hud = HudBuilderScript.new()
	hud.name = "HudBuilder"
	add_child(hud)
	hud.setup(self, terrain_texture)
	_wire_signals()
	# 任务系统（docx 4.10）：第一版只做主线「占领节点」，开局即下发第一个
	quests = QuestSystem.new()
	quests.name = "QuestSystem"
	add_child(quests)
	quests.quest_list_changed.connect(_on_quest_list_changed)
	quests.quest_completed.connect(_on_quest_completed)
	quests.quest_failed.connect(_on_quest_failed)
	quests.start(capture_zones, marks, player_role)


## 信号接线表：控件、战术地图、事件总线、玩家的回调全部集中在这一处，便于以后查「谁接了谁」
func _wire_signals() -> void:
	# HUD 控件
	hud.fire_button.fired.connect(_on_fire)
	hud.focus_button.focus_changed.connect(hud.apply_focus)
	hud.mark_wheel.mark_requested.connect(mark_ctl.place_at_crosshair)
	hud.map_button.pressed.connect(hud.toggle_map)   # 地图开合归 HUD（含玩家输入冻结）
	hud.role_button.pressed.connect(_cycle_role)
	hud.posture_button.pressed.connect(_cycle_posture)
	hud.indirect_button.pressed.connect(_request_indirect)
	hud.weapon_button.pressed.connect(_switch_weapon)
	hud.vehicle_button.pressed.connect(vehicles.toggle)
	hud.seat_button.pressed.connect(vehicles.switch_seat)
	# 战术地图
	hud.tactical_map.mark_placed.connect(mark_ctl.place_at)
	hud.tactical_map.closed.connect(hud.close_map)
	hud.tactical_map.indirect_target_selected.connect(_on_indirect_target)
	# 事件总线 / 玩家
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.flag_state_changed.connect(_on_flag_state_changed)
	EventBus.player_died.connect(_on_player_died)
	player.ammo_changed.connect(_on_ammo_changed)
	player.reload_started.connect(_on_reload_started)
	player.reload_finished.connect(_on_reload_finished)


# 弹药变化 → 刷新 HUD。
func _on_ammo_changed(_mag: int, _reserve: int) -> void:
	hud.update_ammo()


# 开始换弹 → 显示换弹中。
func _on_reload_started() -> void:
	hud.mark_reloading()


# 换弹完成 → 刷新 HUD。
func _on_reload_finished() -> void:
	hud.update_ammo()


func _on_fire() -> void:
	if player == null or grid == null or camera_controller == null:
		return
	# 开图期间不能开火（docx 4.11.7 ①）
	if hud != null and hud.is_map_open():
		return
	# 人在载具里：步兵的枪收起来；只有武器位能开炮（8.1 座位分工）
	if vehicles.vehicle != null and vehicles.vehicle.is_occupied():
		if vehicles.is_gunner(player):
			vehicles.fire()
		else:
			hud.show_hint("驾驶位不能开炮——先按「换座」到武器位")
		return
	var direction := camera_controller.crosshair_world - player.global_position
	if direction.length() < 0.001:
		direction = player.facing
	else:
		direction = direction.normalized()
	var enemies := get_tree().get_nodes_in_group("enemy")
	var result := player.shoot(direction, enemies)
	# 被射速冷却 / 换弹拦下时什么都不做：触屏会把一次点按变成 touch + 模拟鼠标两次调用，
	# 第二次本来就该被拦（原来是继续打印 0.0 m 并画一条零长曳光，纯噪音）
	if not result.get("fired", false):
		return
	print("[开火] 距离=%.1fm 命中=%s" % [result["distance"], str(result["hit"])])
	spawn_tracer(player.global_position, direction, result["distance"])
	if result.get("cover_hit", false):
		# 子弹打在掩体上：扣掩体耐久（打光就破，之后不再挡通视与子弹）
		var cover = result.get("cover")
		if cover != null and cover.has_method("take_damage"):
			cover.take_damage(_damage_at(result["distance"])
					* RoleTable.damage_scale(player_role))
	elif result["hit"]:
		var enemy := result["target"] as Enemy
		if enemy != null:
			# 先记压制再结算伤害：被打死时 alive=false，add_suppression 会直接返回（2026-09-28 修）
			enemy.add_suppression(GameConfig.SUPPRESSION_HIT_BONUS)
			enemy.take_damage(_damage_at(result["distance"])
					* RoleTable.damage_scale(player_role))
	_suppress_enemies(enemies, direction)


## 玩家火力对敌人的压制（docx 7.3 反向）：命中额外叠加，未命中按「弹道离它多近」计算
func _suppress_enemies(enemies: Array, direction: Vector2) -> void:
	if player == null:
		return
	for node in enemies:
		var enemy := node as Enemy
		if enemy == null or not enemy.alive:
			continue
		var factor := SuppressionSystem.near_miss_factor(player.global_position, direction,
				enemy.global_position)
		if factor <= 0.0:
			continue
		enemy.add_suppression(SuppressionSystem.per_shot_amount(factor))


## 伤害随距离线性衰减（7.2 / 武器表：起点内满伤，终点外最低伤）
func _damage_at(distance: float) -> float:
	if player == null:
		return 0.0
	var base := player.weapon_field("dmg_base", GameConfig.WEAPON_DAMAGE_BASE)
	var lowest := player.weapon_field("dmg_min", GameConfig.WEAPON_DAMAGE_MIN)
	var start := player.weapon_field("falloff_start", GameConfig.WEAPON_DAMAGE_FALLOFF_START)
	var end := player.weapon_field("falloff_end", GameConfig.WEAPON_DAMAGE_FALLOFF_END)
	if distance <= start:
		return base
	if distance >= end:
		return lowest
	var t := (distance - start) / maxf(end - start, 0.001)
	return lerpf(base, lowest, t)


## 画一条曳光（步兵与载具共用；敌方载具开炮也接在这里）
func spawn_tracer(origin: Vector2, direction: Vector2, distance: float) -> void:
	var tracer := Tracer.new()
	tracer.setup(origin, direction, distance)
	add_child(tracer)


func _on_enemy_killed(_enemy) -> void:
	score += GameConfig.SCORE_KILL
	hud.update_score(score)
	if quests != null:
		quests.notify_enemy_killed()


func _on_quest_list_changed(quest_list: Array) -> void:
	if hud.quest_card != null:
		hud.quest_card.set_quests(quest_list)


## 任务完成结算（4.10.10：主线 +40，支线按难度 +10 / +15 / +20）
func _on_quest_completed(quest_data: Dictionary) -> void:
	var reward := int(quest_data.get("reward", 0))
	score += reward
	hud.update_score(score)
	if hud.quest_card != null:
		hud.quest_card.show_completed(reward, String(quest_data.get("name", "")))


## 支线失败 / 超时：不扣分（4.10.10 口径），只提示
func _on_quest_failed(quest_data: Dictionary) -> void:
	if hud.quest_card != null:
		hud.quest_card.show_failed(String(quest_data.get("name", "")))


## 切换兵种（docx 3.1）：弹匣 / 备弹 / 伤害倍率 / 标记时效；武器随兵种装载（第十二版）
func _cycle_role() -> void:
	player_role = RoleTable.next_role(player_role)
	if player != null:
		player.apply_role(player_role)
	hud.update_role()
	hud.show_hint("兵种：%s（%s）" % [RoleTable.role_name(player_role),
			RoleTable.weapon_name(player_role)])


## 切姿态（C2 站/蹲/卧）：散布精度档、命中面积系数、移动速度都跟着变
func _cycle_posture() -> void:
	if player == null:
		return
	player.cycle_posture()
	hud.show_hint("姿态切换中：%s" % player.posture_name())


## 换枪（武器数值全部来自 data/weapons.txt；C3：切换期间不能开火）
func _switch_weapon() -> void:
	if player == null or player.weapons.size() <= 1:
		return
	player.switch_weapon()
	hud.show_hint("换枪中：%.2f s" % player.weapon_switch_time())


## 间瞄：开图 + 切到选点模式（docx 4.11.3）；落点由 TacticalMap 的信号回来
func _request_indirect() -> void:
	if hud.tactical_map == null or indirect == null:
		return
	if not hud.tactical_map.is_open():
		hud.toggle_map()
	hud.tactical_map.indirect_mode = true
	hud.show_hint("间瞄选点：在地图上点落点（剩余 %d 发）" % indirect.ammo)


## 地图选了落点 → 请求打一发
func _on_indirect_target(target: Vector2) -> void:
	if indirect == null:
		return
	if indirect.fire_at(target):
		hud.show_hint("间瞄已发射（剩余 %d 发）" % indirect.ammo)
		return
	if indirect.ammo <= 0:
		hud.show_hint("间瞄弹药耗尽")
	elif indirect.cooldown_left() > 0.0:
		hud.show_hint("间瞄冷却中：%.1f s" % indirect.cooldown_left())
	else:
		hud.show_hint("落点超出间瞄射程（%.0f~%.0f m）"
				% [GameConfig.INDIRECT_MIN_RANGE, GameConfig.INDIRECT_MAX_RANGE])


## 落弹：预警圈闪一下 + 提示
func _on_indirect_landed(target: Vector2) -> void:
	if _indirect_overlay != null:
		_indirect_overlay.flash_at(target)
	hud.show_hint("间瞄命中")


func _on_flag_state_changed(_zone_name, _state) -> void:
	hud.update_capture()
	if _all_zones_captured():
		_on_victory()
	elif _all_zones_lost():
		_on_defeat("防线失守")


func _all_zones_captured() -> bool:
	if capture_zones.is_empty():
		return false
	for zone in capture_zones:
		if zone.state != CaptureZone.State.BLUE:
			return false
	return true


func _all_zones_lost() -> bool:
	if capture_zones.is_empty():
		return false
	for zone in capture_zones:
		if zone.state != CaptureZone.State.RED:
			return false
	return true


func _on_victory() -> void:
	if _victory:
		return
	_victory = true
	EventBus.match_finished.emit("player")
	hud.show_victory()


func _on_player_died() -> void:
	_on_defeat("阵亡")


func _on_defeat(reason: String = "防线失守") -> void:
	if _victory or _defeat:
		return
	_defeat = true
	EventBus.match_finished.emit("enemy")
	hud.show_defeat(reason)


## 每帧：HUD（血量 / 准心 / 标签 / 提示）→ 载具（驾驶 / 操炮塔）
func _process(delta: float) -> void:
	if hud == null:
		return  # 地图预览模式：没有 HUD，也没有载具
	hud.tick(delta)
	vehicles.tick(delta)


func _unhandled_input(event: InputEvent) -> void:
	# 胜利/失败后点屏重开。
	if (_victory or _defeat) and event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			get_tree().reload_current_scene()
	# R 键换弹（桌面调试）。
	elif event is InputEventKey and event.pressed:
		var key := event as InputEventKey
		if key.keycode == KEY_R and player != null:
			player.start_reload()
		elif key.keycode == KEY_M:
			hud.toggle_map()  # 桌面调试用 M；触屏走右侧「地图」按钮
	# Shift 按住＝聚焦（桌面等价于触屏聚焦键）。
	elif event is InputEventKey:
		var shift := event as InputEventKey
		if shift.keycode == KEY_SHIFT and not shift.echo:
			hud.apply_focus(shift.pressed)
