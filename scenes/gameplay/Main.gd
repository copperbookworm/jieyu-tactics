extends Node2D

## 间瞄链模块用 preload（刻意不写 class_name，避免「新类未进全局类缓存」那套问题）
const IndirectControllerScript := preload("res://scenes/gameplay/IndirectController.gd")
const MatchFlowScript := preload("res://systems/match/MatchFlow.gd")
## 2026-09-30 候选 N：按职责拆出的四个 Node 子模块（同样不写 class_name，统一 preload 引用）
const WorldSetupScript := preload("res://scenes/gameplay/WorldSetup.gd")
const VehicleControllerScript := preload("res://scenes/gameplay/VehicleController.gd")
const MarkControllerScript := preload("res://systems/marks/MarkController.gd")
const HudBuilderScript := preload("res://ui/HudBuilder.gd")
## 2026-10-01 候选 L3：补给护送控制器（任务系统发出 T-S5 时派车）
const SupplyControllerScript := preload("res://scenes/gameplay/SupplyController.gd")
## 2026-10-01 候选 L4：侧翼通路控制器（任务系统发出 T-S6 时派穿插兵）
const LaneControllerScript := preload("res://scenes/gameplay/LaneController.gd")
## 2026-10-01 候选 P：烟雾控制器（按烟雾键派发烟雾弹 / 载具发烟器）
const SmokeControllerScript := preload("res://scenes/gameplay/SmokeController.gd")
## 数据表健康自检（2026-10-01）：三张 .txt 表不在导出包里时，降级全是静默的 —— 见 BootCheck.gd
const BootCheckScript := preload("res://scenes/gameplay/BootCheck.gd")
## 玩家步兵射击链（2026-10-04 从 Main 拆出）：直接原因是 Main 被上一轮的结构值接线顶到 403 行、破了 ≤400 硬线
const PlayerFireControllerScript := preload("res://scenes/gameplay/PlayerFireController.gd")
## 炸药 / 工程兵（2026-10-04 拍板）：准心落点放置 + 遥控起爆
const ExplosiveControllerScript := preload("res://scenes/gameplay/ExplosiveController.gd")

## 第一版主场景装配（挂在 Main.tscn 的根节点上）
## 地形、玩家、相机、敌人、HUD 全部在 _ready 里用代码创建——
## 场景文件只需要一个空 Node2D + 本脚本，避免手改 .tscn
##
## 【候选 N · 职责拆分（2026-09-30）】本文件从 968 行瘦到 400 行以内，只剩四件事：
##   ① 配置：@export 开关 ② 装配：new 出各系统与八个模块 ③ 信号接线：全在 _wire_signals()
##   ④ 战局流程：分数 / 任务结算 / 占领胜负 / 输入
## 分工：世界建场 → WorldSetup ｜ HUD 构建与刷新 → HudBuilder
##       载具（上下车·换座·操炮·开火）→ VehicleController ｜ 报点标记链 → MarkController
##       补给护送（派车 + 抵达回告）→ SupplyController ｜ 侧翼通路（派穿插兵 + 穿线判定）→ LaneController
##       间瞄链（选点 / 发射 / 落弹）→ IndirectController
##       玩家步兵开火链（开火门禁 / 目标组装 / 伤害与压制）→ PlayerFireController
##       炸药 / 工程兵（放置 / 遥控起爆 / 爆炸结算）→ ExplosiveController
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
## 出生锚点（2026-10-05）：WorldSetup 从地图出生区挑出来的点 —— 玩家 / 友军载具 / 补给车共用
var spawn_anchor := Vector2.ZERO
## 地图遮挡体原始条目（同上，只解析一次）：出生点挑选与载具落点微调都要用
var map_occluders: Array = []

## 五个子模块（各自持有本节点引用）
var world = null            # WorldSetup
var vehicles = null         # VehicleController
var mark_ctl = null         # MarkController
var hud = null              # HudBuilder
var supply_ctl = null       # SupplyController（候选 L3）
var lane_ctl = null         # LaneController（候选 L4）
var smoke_ctl = null        # SmokeController（候选 P）
var fire_ctl = null         # PlayerFireController（玩家步兵开火链）
var explosive_ctl = null    # ExplosiveController（炸药 / 工程兵）

## 各系统
var quests: QuestSystem = null
var marks: MarkSystem = null
var indirect = null         # IndirectFire（由 IndirectController 建好后写回；HUD / 小地图读它的余弹）
var indirect_ctl = null     # IndirectController（候选 L4 前从 Main 拆出）

var score := 0              # 战力分（HUD 由 HudBuilder 显示）
var _victory := false
var match_flow = null   # 战局流程（候选 Q）：计时 / 加时 / 平局 / 重生预算
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
	# 玩家步兵开火链（2026-10-04 从 Main 拆出）：门禁 → 目标组装 → 伤害与压制结算
	fire_ctl = PlayerFireControllerScript.new()
	fire_ctl.name = "PlayerFireController"
	add_child(fire_ctl)
	fire_ctl.setup(self)
	# 炸药 / 工程兵（2026-10-04 拍板）：必须**在 HUD 之前**建好 ——
	# HudBuilder.update_role() 组装标签时要读 explosive_ctl.remaining()
	explosive_ctl = ExplosiveControllerScript.new()
	explosive_ctl.name = "ExplosiveController"
	add_child(explosive_ctl)
	explosive_ctl.setup(self)
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
	# 间瞄链（候选 L4 前从 Main 拆出）：IndirectFire + 落点预警层 + 选点 / 发射 / 落弹提示
	# 必须先于 HUD 创建（HUD 标签与小地图要读 indirect 的余弹）
	indirect_ctl = IndirectControllerScript.new()
	indirect_ctl.name = "IndirectController"
	add_child(indirect_ctl)
	indirect_ctl.setup(self, player, sight)
	# 任务系统（docx 4.10）：必须先于 HUD 建好——战术地图的「主线任务高亮」要读它
	# （原来建在 HUD 之后，TacticalMap 拿到的是 null，高亮从来没生效过；2026-09-30 修）
	quests = QuestSystem.new()
	quests.name = "QuestSystem"
	add_child(quests)
	quests.quest_list_changed.connect(_on_quest_list_changed)
	quests.quest_completed.connect(_on_quest_completed)
	quests.quest_failed.connect(_on_quest_failed)
	# 补给护送（候选 L3，docx 4.10.11 T-S5）：任务系统发出护送任务时派车，车抵达后回告任务系统
	# 必须在 quests.start() 之前建好，才接得住「开局就发」的那次列表广播
	supply_ctl = SupplyControllerScript.new()
	supply_ctl.name = "SupplyController"
	add_child(supply_ctl)
	supply_ctl.setup(self)
	# 侧翼通路（候选 L4，docx 4.10.11 T-S6）：任务系统发出「守住侧翼通路」时在通路入口派穿插兵
	lane_ctl = LaneControllerScript.new()
	lane_ctl.name = "LaneController"
	add_child(lane_ctl)
	lane_ctl.setup(self)
	# 烟雾（候选 P，docx 4.12）：按烟雾键投烟雾弹 / 放载具发烟器；配额与流程都在模块里
	smoke_ctl = SmokeControllerScript.new()
	smoke_ctl.name = "SmokeController"
	add_child(smoke_ctl)
	match_flow = MatchFlowScript.new()
	add_child(match_flow)
	match_flow.setup(self)
	smoke_ctl.setup(self)
	# HUD（含战术地图图层 / 小地图 / 任务卡片 / 报点轮盘）
	hud = HudBuilderScript.new()
	hud.name = "HudBuilder"
	add_child(hud)
	hud.setup(self, terrain_texture)
	_check_data_tables()
	_wire_signals()
	# 开局下发任务（此时 HUD 与任务卡片已就绪，任务列表信号能直接刷到卡片上）
	quests.start(capture_zones, marks, player_role)


## 启动自检：三张数据表是 .txt，**不是 Godot 资源**（刻意如此：.csv 会被当翻译表导入），
## 导出时必须在 export_presets.cfg 的 include_filter 里，否则包里读不到而三条降级全是静默的：
## 载具 hp/弹药归零（车显示 0/0、炮永远打不出来）、武器退回 GameConfig 默认值、任务没有模板。
## 2026-10-01 真机「上车换座后开不了炮」就是这个。判定与文案都在 BootCheck.gd。
func _check_data_tables() -> void:
	var missing := BootCheckScript.missing_tables()
	if missing.is_empty():
		return
	push_error(BootCheckScript.missing_error(missing))
	if hud != null:
		hud.show_hint(BootCheckScript.missing_hint(missing), 8.0)


## 信号接线表：控件、战术地图、事件总线、玩家的回调全部集中在这一处，便于以后查「谁接了谁」
func _wire_signals() -> void:
	# HUD 控件
	hud.fire_button.fired.connect(fire_ctl.fire)
	# 2026-10-07（docx ㊼）：开火也算「安放中被打断」的一种 —— 同一条 fired 信号多接一处
	hud.fire_button.fired.connect(explosive_ctl.notify_fired)
	hud.focus_button.focus_changed.connect(hud.apply_focus)
	hud.mark_wheel.mark_requested.connect(mark_ctl.place_at_crosshair)
	hud.command_wheel.command_requested.connect(mark_ctl.send_command)   # 4.13 快捷指令
	hud.map_button.pressed.connect(hud.toggle_map)   # 地图开合归 HUD（含玩家输入冻结）
	hud.role_button.pressed.connect(_cycle_role)
	hud.posture_button.pressed.connect(_cycle_posture)
	hud.indirect_button.pressed.connect(indirect_ctl.request_targeting)
	hud.smoke_button.pressed.connect(smoke_ctl.deploy)
	hud.explosive_button.pressed.connect(explosive_ctl.toggle)
	hud.weapon_button.pressed.connect(_switch_weapon)
	hud.vehicle_button.pressed.connect(vehicles.toggle)
	hud.seat_button.pressed.connect(vehicles.switch_seat)
	hud.ammo_type_button.pressed.connect(vehicles.switch_ammo)   # 弹种：主炮 ⇄ 反坦克导弹
	hud.aim_gear_button.pressed.connect(vehicles.cycle_aim_gear)  # 瞄高：炮塔 / 车体 / 弹药架 / 机动件
	# 战术地图
	hud.tactical_map.mark_placed.connect(mark_ctl.place_at)
	hud.tactical_map.closed.connect(hud.close_map)
	hud.tactical_map.indirect_target_selected.connect(indirect_ctl.on_map_target)
	# 事件总线 / 玩家
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.flag_state_changed.connect(_on_flag_state_changed)
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


func _on_flag_state_changed(_zone_name, _state) -> void:
	hud.update_capture()
	if _all_zones_captured():
		_retire_match("player", "全部节点被我方占领")
	elif _all_zones_lost():
		_retire_match("enemy", "全部节点失守")


## 世界层的结束入口（2026-10-07 第八十九版真机验收修）：**先让 MatchFlow 记账再结束**。
## 历史 bug：这里以前直接 _on_victory()/_on_defeat()，它们只 emit match_finished，
## 不写 flow.outcome / flow.reason ⇒ 结算屏「结束原因」是空白（真机截图实证）。
func _retire_match(who: String, why: String) -> void:
	if match_flow != null and match_flow.has_method("finish_by_world"):
		match_flow.finish_by_world(who, why)
	elif who == "player":
		_on_victory()
	else:
		_on_defeat(why)


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
