extends SceneTree

## 无编辑器集成冒烟（2026-09-30 候选 N 加）
##
## 与 tools/run_tests_headless.gd 的分工：
##   · run_tests_headless.gd  跑 test/ 下 16 个纯逻辑 @tool 测试（不建场景）
##   · 本脚本                 真把 Main.tscn 实例化起来跑一遍，断言「装配关系 + 五条交互链」没被拆坏：
##                           战术地图开合（含 2026-09-28「关图后摇杆永久锁死」回归点）、
##                           载具（上车/换座/操炮塔/开炮/下车）、报点标记链、
##                           兵种·姿态·换枪·聚焦、开火曳光、血量/分数标签、
##                           提示超时消失、三个节点全占 → 胜利结算（走真实 flag_state_changed 链路）、
##                           候选 O 第一轮：战斗播报（4.14）/ 操作提示（4.15）真的接进 HUD 与事件链。
##
## 用法：godot --headless --path . --log-file <工作区内可写路径> --script res://tools/run_integration_headless.gd
## 退出码：0 = 全绿，1 = 有失败。
##
## ⚠ 本脚本的两条硬约束（都是 --script 模式的既有脾性，不是项目的锅）：
##   ① 本脚本的编译早于 autoload 注册 ⇒ 不能写 EventBus.xxx，也不能在编译期引用
##      CaptureZone / Player / Enemy / AimCameraController / QuestSystem（QuestSystem 依赖 CaptureZone）
##      —— 它们用了 EventBus 全局名，一旦在这里当依赖被拉进来编译失败还会被缓存，占领/任务链会跟着全废。
##      要碰这些只能运行时按名字取（例如 EventBus 用 root.get_node_or_null，常量用实例.常量）。
##   ② 手动实例化的场景不会自动成为 current_scene ⇒ 必须自己设，否则 Enemy 开火画曳光会炸。

const SETTLE_SECONDS := 1.0      # 先跑 1 s 让相机/玩家/节点进入稳定状态
const LATE_SECONDS := 2.5        # 再跑一会儿：覆盖「报点提示 1.6 s 自动消失」
const VICTORY_FRAMES := 10       # 让 CaptureZone._process 自己翻蓝并广播
## 地图世界图层的数据源（2026-10-01 ④）：只读组 + Main 公开字段，无 EventBus 依赖，可以编译期引用
const MapLayerSourceScript := preload("res://ui/MapLayerSource.gd")
## 载具表（只读、无 autoload 依赖）：用真实装甲口径验「两发导弹打爆主战坦克」
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")
const VehiclePartsScript := preload("res://systems/vehicles/VehicleParts.gd")
## 出生点挑选（2026-10-05）：只用来读 NUDGE_RADIUS 这一条常量（判据断言自己实现，不自证）
const SpawnPickerScript := preload("res://systems/terrain/SpawnPicker.gd")

var _main = null
var _phase := 0
var _elapsed := 0.0
var _frames := 0
var _passed := 0
var _failed := 0
var _ts5_score_before := 0      # T-S5 结算的计分基线（赶在全占胜利 +40 之前查）
var _ts6_score_before := 0      # T-S6 穿线失败的计分基线（失败应该一分不动）


func _initialize() -> void:
	print("===== 集成冒烟：实例化 res://scenes/gameplay/Main.tscn =====")
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	if packed == null:
		print("！！ 加载不到 Main.tscn")
		quit(1)
		return
	_main = packed.instantiate()
	root.add_child(_main)
	current_scene = _main


func _process(delta: float) -> bool:
	_elapsed += delta
	_frames += 1
	match _phase:
		0:
			if _elapsed >= SETTLE_SECONDS:
				# 先挡一步：地图检测模式的遗留调试态会让「后面每一项都红」而根因藏在 SCRIPT ERROR 里
				# （2026-10-01 踩过：Main.tscn 里 map_preview_mode = true，表现为通过 1 / 失败 5）。
				# 这里直接点出开关名，别让人再去猜 Nonexistent function 'main_quest' in base 'Nil'。
				if _main.map_preview_mode:
					print("！！ 集成冒烟中止：Main.tscn 的 map_preview_mode = true（地图检测模式）")
					print("   预览模式只建地形 + 预览层，玩家 / 占领 / 任务 / 载具 / 通路全都不建，")
					print("   后面每一项都会红。把该开关关掉（或删掉那一行）再跑。")
					quit(1)
					return true
				# 2026-10-07 拍板（docx 19 ⑯）：调试值也一起纳入跑批前置检查。
				# 为什么只硬查这两个伤害倍率：它们是「脚本化验收让不让敌人真打」的旋钮，被调成 0 时
				# 整片断言会「看起来全绿」（敌人打不动玩家、也打不动载具）—— 最容易被当成绿提交的假绿源。
				# ENEMY_FINISH_OFF_ENABLED 故意不硬查：本套冒烟自己就跑在「补刀关」的测试态上
				# （见「补刀关（测试态）」那组断言），把它当错误会让每一轮都红 ⇒ 改为下面打印出来。
				if not is_equal_approx(GameConfig.ENEMY_DAMAGE_SCALE, 1.0):
					print("！！ 集成冒烟中止：GameConfig.ENEMY_DAMAGE_SCALE = %s（正式值 1.0）" % str(GameConfig.ENEMY_DAMAGE_SCALE))
					quit(1)
					return true
				if not is_equal_approx(GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE, 1.0):
					print("！！ 集成冒烟中止：GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE = %s（正式值 1.0）" % str(GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE))
					quit(1)
					return true
				print("[跑批·口径] ENEMY_DAMAGE_SCALE=%.2f ENEMY_VEHICLE_DAMAGE_SCALE=%.2f ENEMY_FINISH_OFF_ENABLED=%s（本套冒烟就跑在这个测试态上）" % [
					GameConfig.ENEMY_DAMAGE_SCALE, GameConfig.ENEMY_VEHICLE_DAMAGE_SCALE,
					"true" if GameConfig.ENEMY_FINISH_OFF_ENABLED else "false"])
				_neutralize_enemy_fire()   # 见函数注释：脚本化验收里不让敌人真把玩家打死
				_check_structure()
				_check_interactions()
				_phase = 1
				_elapsed = 0.0
		1:
			if _elapsed >= LATE_SECONDS:
				_check_late()
				_check_supply_escort()
				_phase = 2
				_frames = 0
		2:
			# 补给车抵达（T-S5 结算）必须赶在「全占胜利」之前查：否则主线完成 +40 会混进同一段
			if _frames >= VICTORY_FRAMES:
				_check_supply_arrived()
				_check_lane_dispatch()
				_check_map_layers()
				_check_main_defend()
				_arm_victory()
				_phase = 3
				_frames = 0
		3:
			if _frames >= VICTORY_FRAMES:
				_check_victory()
				# 候选 P 放在最后：它要挪玩家与敌人、还要等烟的寿命，不能污染上面的结算结论
				_check_smoke()
				# 候选 O 第一轮：播报 / 提示（只动播报缓冲与提示开关，不影响结算）
				_check_candidate_o()
				# 候选 O 第二轮：快捷指令（会落集结点标记）
				_check_commands()
				# 候选 O 第四轮：环境互动区（会挪玩家与敌人参数，放在倒地之前）
				_check_terrain_zones()
				# 候选 M 第一轮：表现层（阴影 / 枪口火光 / 命中 / 受击 / 屏幕震动）
				_check_effects()
				# 候选 M 第二轮：基础音效（程序生成的 PCM + 播放层）
				_check_audio()
				# 候选 M 第三轮：12.7.1 上下半身分离（角色图）
				_check_figure()
				# 候选 M 第四轮：12.7.2 载具动画（履带 / 毁伤表现）
				_check_vehicle_anim()
				# 反坦克导弹：玩家的步战车能打爆敌方主战坦克（使用者 2026-10-01 拍板）
				_check_atgm()
				# 坦克乘员：必须在打爆之后**立刻**查（后面的检查会改这辆车的 AI/结构值）
				_check_tank_crew()
				# 真机反馈 2026-10-02：残骸可命中 / 发烟器跟车 / 烟里准心不锁死
				_check_wreck_hittable()
				_check_vehicle_smoke()
				_check_respawn()
				_check_downed_not_targeted()
				_check_finish_off_pose()
				# 候选 O 第三轮：被击倒时的视角（会把玩家打死，必须是最后一项）
				# 2026-10-04 炸药 / 工程兵：会挪玩家与炸掉一个掩体，放最后一段（被击倒之前）
				_check_explosive()
				_check_downed()
				print("—— 集成冒烟：通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
				if _failed > 0:
					print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)
				quit(1 if _failed > 0 else 0)
				return true
	return false


# ────────────── ① 装配关系（拆分没把场景树挪错地方）──────────────

func _check_structure() -> void:
	# 这条单独钉一下：它是 2026-10-01「集成冒烟整片红」的根因，值不值得留着当开关由使用者定，
	# 但「开着它还跑集成冒烟」必须是可见的失败（上一版跑成 通过 1 / 失败 5，根因藏在 Nil 报错里）。
	_check_true("地图检测模式开关已关（Main.tscn 的 map_preview_mode = false）",
			not _main.map_preview_mode)
	_check_true("Main 已 _ready：玩家 / 地形网格 / 相机控制器都在",
			_main.player != null and _main.grid != null and _main.camera_controller != null)
	_check_true("十个模块都建好了（候选 N 的 4 个 + 间瞄 / 补给 / 通路 / 烟雾 / 玩家开火 / 炸药）",
			_main.world != null and _main.vehicles != null and _main.mark_ctl != null
			and _main.hud != null and _main.supply_ctl != null and _main.lane_ctl != null
			and _main.smoke_ctl != null and _main.indirect_ctl != null
			and _main.fire_ctl != null
			and _main.explosive_ctl != null)
	_check_true("子模块都挂在 Main 下",
			_main.world.get_parent() == _main and _main.vehicles.get_parent() == _main
			and _main.mark_ctl.get_parent() == _main and _main.hud.get_parent() == _main
			and _main.supply_ctl.get_parent() == _main
			and _main.lane_ctl.get_parent() == _main
			and _main.smoke_ctl.get_parent() == _main
			and _main.fire_ctl.get_parent() == _main
			and _main.explosive_ctl.get_parent() == _main)
	# 2026-10-04：爆破键必须接到炸药模块上（炸药 / 工程兵）
	_check_true("爆破键接到 ExplosiveController.toggle",
			_main.hud.explosive_button.pressed.is_connected(_main.explosive_ctl.toggle))
	# 2026-10-04：开火键必须接到**玩家开火模块**上（Main 里已经没有 _on_fire 可接了）
	_check_true("开火键接到 PlayerFireController.fire（拆分后接线没断）",
			_main.hud.fire_button.fired.is_connected(_main.fire_ctl.fire))
	_check_true("实体仍挂在 Main 下（不是挂在模块下）",
			_main.get_node_or_null("Terrain") != null
			and _main.get_node_or_null("Player") != null
			and _main.get_node_or_null("Camera") != null
			and _main.get_node_or_null("AimCameraController") != null
			and _main.get_node_or_null("Vehicle") != null
			and _main.get_node_or_null("EnemyVehicle") != null)
	_check("占领节点 3 个（第一版：三节点全占即胜）", _main.capture_zones.size(), 3)
	# 2026-10-04 第五十九版：默认地图换成**正式图「青岭走廊」** ⇒ 掩体数量以地图数据为准。
	# 不再写死「20 个沙袋」：直接数地图 occluders.json 的条目数，地图改了测试自动跟上。
	var map_occluders := _count_map_occluders(GameConfig.MAP_HEIGHT_IMAGE)
	_check("掩体数 = 地图 occluders.json 的条目数（%d）" % map_occluders,
			get_nodes_in_group("occluder").size(), map_occluders)
	_check_true("默认地图确实是正式图（不是 demo 的 20 个沙袋）", map_occluders > 20)
	# 拍板 B（2026-10-05 · 第六十三版）：敌人驻守在地图节点上，不再是「出生点前方 45~75 m」。
	# 只算敌方**步兵**：enemy 组里还有敌方坦克乘员与事件驱动的穿插兵，它们的落点规则不同。
	var deployment_nodes := _map_node_positions(GameConfig.MAP_HEIGHT_IMAGE)
	var infantry: Array = []
	for node in get_nodes_in_group("enemy"):
		var enemy_name := String(node.name)
		if enemy_name.begins_with("Enemy") and not enemy_name.contains("TankCrew") \
				and not enemy_name.contains("Vehicle"):
			infantry.append(node)
	var on_node := 0
	for node in infantry:
		for node_pos in deployment_nodes:
			if (node as Node2D).global_position.distance_to(node_pos) <= 30.0:
				on_node += 1
				break
	_check("拍板 B：开局敌方步兵全部驻守在地图节点上（%d 人）" % infantry.size(),
			on_node, infantry.size())
	# 预备队支援：口令真的走到 Enemy.set_move_target()（2 敌的测试局本来没有预备队，这里手工挂上）
	var world = _main.world
	_check("拍板 B：人少（2 敌）时不留预备队", (world.reserve_enemies as Array).size(), 0)
	if deployment_nodes.size() >= 2 and not infantry.is_empty():
		for node in infantry:
			(world.reserve_enemies as Array).append(node)
		world._on_flag_state_changed((_main.capture_zones[0] as Node).name, 1)
		var aimed := 0
		for node in infantry:
			if (node as Node2D)._patrol_target.distance_to(deployment_nodes[1]) < 1.0:
				aimed += 1
		_check("拍板 B：预备队向前支援 —— 目标指向下一个节点", aimed, infantry.size())
		for node in infantry:
			node.set_move_target((node as Node2D).global_position)   # 还原：回自己脚下巡逻
		(world.reserve_enemies as Array).clear()
	# 拍板 B（2026-10-05 · 第六十五版）：敌人不再「只锁玩家」—— 玩家挪远、敌人贴到队友面前时应改打队友，
	# 而且伤害要真的落到队友身上（队友 200 血、有自己的 take_damage）。
	var allies_alive: Array = []
	for node in get_nodes_in_group("friendly"):
		# 必须排除倒地 / 已阵亡：Ally.take_damage 对倒地目标走 die()、**不动血量**，
		# 拿一个倒地队友来验「会掉血」必然假红（实测踩过）
		if String(node.name).begins_with("Ally") and float(node.hp) > 0.0 \
				and bool(node.alive) and not bool(node.downed):
			allies_alive.append(node)
	if not allies_alive.is_empty() and not infantry.is_empty():
		var ally = allies_alive[0]
		var attacker = infantry[0]
		var player_home: Vector2 = _main.player.global_position
		ally.order_active = false
		# 摆到**出生垫**上再验伤害：那块是第六十一/六十二版保证「平地 + 5 m 内无掩体」的地方，
		# 队友站在楼里时八条射线全被掩体截断（第一版就是这么假红的）
		var pad: Vector2 = _main.spawn_anchor
		(ally as Node2D).global_position = pad + Vector2(0.0, 8.0)
		attacker.global_position = pad + Vector2(5.0, 8.0)
		attacker.set_move_target(attacker.global_position)
		_main.player.global_position = Vector2(950.0, 950.0)   # 玩家挪到地图另一角
		_reset_sight_caches()
		_tick_ai(attacker, 0.7)   # 推过 0.3 s 的重挑闸门
		_check("拍板 B：敌人挑最近的队友当目标（不再只锁玩家）", attacker._target, ally)
		var ally_hp_before: float = float(ally.hp)
		# 试 8 个方向：正上方 / 正下方可能被掩体截断，也可能残留压制让敌人「不敢露头」
		# ⚠ 前面为「避免敌人真把玩家打死」把所有敌人的 fire_damage 设成了 0（见本文件那条说明），
		# 所以要验「队友会掉血」必须临时恢复 —— 否则测出来的是「0 伤害当然不掉血」
		var damage_home: float = float(attacker.fire_damage)
		attacker.fire_damage = 20.0
		for attempt in 8:
			var around := TAU * float(attempt) / 8.0
			attacker.global_position = (ally as Node2D).global_position \
					+ Vector2(cos(around), sin(around)) * 5.0
			attacker._fire_cooldown = 0.0
			attacker._hold_fire_time = 0.0
			attacker.suppression = 0.0
			attacker._try_fire(0.0, (ally as Node2D).global_position, false)
			if float(ally.hp) < ally_hp_before:
				break
		_check_true("拍板 B：队友真的会掉血（%.0f → %.0f，alive=%s downed=%s hp=%.0f）"
				% [ally_hp_before, float(ally.hp), str(ally.alive), str(ally.downed), float(ally.hp)],
				float(ally.hp) < ally_hp_before)
		# 粘滞：目标仍可见时不许逐帧换人（否则一枪都打不出去）
		_tick_ai(attacker, 0.4)
		_check("拍板 B：目标粘滞 —— 再推 0.4 s 仍锁同一个队友", attacker._target, ally)
		attacker.fire_damage = damage_home
		_main.player.global_position = player_home
		_reset_sight_caches()
	# 白旗点也必须来自地图的推进链（zones.json）—— 实测：地图 N2 与 demo N2 差 44.7 m，
	# 而 demo N2 在正式图上是 45.8° 的坡、核心圈里还压着一栋房子。
	var map_nodes := _map_node_positions(GameConfig.MAP_HEIGHT_IMAGE)
	var zones_on_map: bool = _main.capture_zones.size() == mini(3, map_nodes.size())
	for i in _main.capture_zones.size():
		if i >= map_nodes.size() \
				or (_main.capture_zones[i] as Node2D).global_position.distance_to(map_nodes[i]) > 1.0:
			zones_on_map = false
	_check_true("白旗点落在地图 zones.json 的节点坐标上（±1 m，取前 3 个）", zones_on_map)
	# 出生点也必须来自地图（2026-10-05 · 第六十一版）：地图只给**出生区多边形**，出生点是现挑的。
	# 判据见 systems/terrain/SpawnPicker.gd：双尺度坡度 ≤30° · 离掩体 ≥5 m · 离最近节点 ≥100 m（逐级放宽）。
	# 实测本图 west 出生区有 699 个采样点满足 100 m 档，所以这里按顶档断言；换地图若降档，该红——
	# 那正是「看一眼为什么」的信号，不是把断言放宽。
	var spawn_polygon := _map_spawn_polygon(GameConfig.MAP_HEIGHT_IMAGE, "west")
	_check_true("地图给了 west 出生区（多边形 ≥ 3 点）", spawn_polygon.size() >= 3)
	var spawn: Vector2 = _main.spawn_anchor
	print("[出生] 锚点 = %s（离最近节点 %.1f m，离最近掩体 %.1f m）"
			% [str(spawn), _nearest_distance(spawn, map_nodes), _cover_distance(spawn)])
	_check_true("出生锚点落在 west 出生区多边形内", _point_in_polygon(spawn_polygon, spawn))
	_check_true("出生锚点不是 demo 出生点（地图接手了）",
			spawn.distance_to(MapGenerator.demo_spawn_point()) > 5.0)
	_check_true("出生锚点双尺度坡度合格（≤ %.0f°）" % GameConfig.MAX_SLOPE_DEG, _spawn_slope_ok(spawn))
	_check_true("出生锚点离最近遮挡体 ≥ 5 m（实测 %.1f m）" % _cover_distance(spawn),
			_cover_distance(spawn) >= 5.0)
	_check_true("出生锚点离最近节点 ≥ 100 m（实测 %.1f m）" % _nearest_distance(spawn, map_nodes),
			_nearest_distance(spawn, map_nodes) >= 100.0)
	_check_true("玩家出生在出生锚点上", _main.player.global_position.distance_to(spawn) < 1.0)
	# 我方载具按「锚点 + 35 m」摆，并且同样要站得住（正式图上偏移点可能正好在陡坡 / 楼里）
	var vehicle_spawn: Vector2 = (_main.get_node("Vehicle") as Node2D).global_position
	_check_true("我方载具落在出生锚点附近且坡度合格",
			vehicle_spawn.distance_to(spawn + Vector2(35.0, 0.0)) <= SpawnPickerScript.NUDGE_RADIUS + 1.0
			and _spawn_slope_ok(vehicle_spawn))
	# 2026-10-02 订正：这条原来是「敌人 2 个」的等值断言，现在不再成立 ——
	# 实测 enemy 组是 [Enemy1, Infiltrator1..3]：① 开局 2 名步兵里可能有人被**队友**先击毙；
	# ② T-S6 的事件驱动穿插兵（Infiltrator*）也会进这个组。所以改成「至少 2 个 + 成员必须是敌兵类」，
	# 顺带钉住「队友不能漏进 enemy 组」（那才是真的结构错误）。
	var enemy_names: Array = []
	for node in get_nodes_in_group("enemy"):
		enemy_names.append(String(node.name))
	var shapes_ok := enemy_names.size() >= 2
	for node_name in enemy_names:
		shapes_ok = shapes_ok and (node_name.begins_with("Enemy")
				or node_name.begins_with("Infiltrator"))
	_check_true("敌人：≥ 2 个，且都是敌兵类节点（开局步兵 / 穿插兵）", shapes_ok)
	var leaked := 0
	for ally in get_nodes_in_group("friendly"):
		if ally.is_in_group("enemy"):
			leaked += 1
	_check("队友：没有一个漏进 enemy 组", leaked, 0)
	_check("队友：开局 3 名（friendly 组）", get_nodes_in_group("friendly").size(), 3)
	_check("载具 2 辆（我方 + 敌方 AI）", get_nodes_in_group("vehicle").size(), 2)
	_check("敌方 FOB 1 座（候选 L2）", get_nodes_in_group("fob_enemy").size(), 1)
	_check_true("HUD 层与地图层（layer=10）都在",
			_main.hud.get_node_or_null("HUD") != null
			and _main.hud.tactical_map.get_parent() != null
			and _main.hud.tactical_map.get_parent().layer == 10)
	var controls_ok := _main.hud.crosshair != null and _main.hud.vignette != null \
			and _main.hud.fire_button != null and _main.hud.focus_button != null \
			and _main.hud.mark_wheel != null and _main.hud.joystick != null \
			and _main.hud.mini_map != null and _main.hud.quest_card != null \
			and _main.hud.map_button != null and _main.hud.role_button != null \
			and _main.hud.posture_button != null and _main.hud.indirect_button != null \
			and _main.hud.weapon_button != null and _main.hud.vehicle_button != null \
			and _main.hud.seat_button != null and _main.hud.smoke_button != null \
			and _main.hud.pause_button != null
	_check_true("HUD 控件齐全（17 个：16 个既有 + 游戏外壳的暂停键）", controls_ok)
	# 暂停键由 ui/screens/MatchHost.gd 接线（Main.gd 守着 400 行硬线，不加这一行）——
	# 单独跑 Main.tscn 时它就是个没接线的按钮，这里钉住「它自己不做事」这一点
	_check_true("暂停键自己不带接线（接线在外壳的 MatchHost）",
			_main.hud.pause_button.pressed.get_connections().is_empty()
			and _main.hud.has_method("set_shell_visible"))
	_check_true("候选 O：播报 / 提示两个面板在 HUD 层上（4.14 / 4.15）",
			_main.hud.feed != null and _main.hud.tips != null
			and _main.hud.has_method("push_feed"))
	_check_true("候选 O 4.13：快捷指令轮盘已在 HUD 上（6 条指令）",
			_main.hud.command_wheel != null
			and _main.hud.command_wheel.item_count() == 6)
	_check_true("烟雾键已接上 Main._deploy_smoke",
			_main.hud.smoke_button.pressed.is_connected(_main.smoke_ctl.deploy))
	_check_true("HUD 标签已填内容（占领 / 弹药 / 兵种 / 血量）",
			_main.hud.capture_hud.text.contains("节点")
			and _main.hud.ammo_label.text.contains("弹匣")
			and _main.hud.role_label.text.contains(RoleTable.role_name(_main.player_role))
			and _main.hud.hp_label.text.contains("血量"))
	_check_true("任务系统已下发主线任务",
			_main.quests != null and not _main.quests.main_quest().is_empty())


# ────────────── ② 五条交互链 ──────────────

func _check_interactions() -> void:
	# ① 战术地图开合——2026-09-28 那个「关图后摇杆永久锁死」的回归点
	_main.hud.toggle_map()
	_check_true("开图：地图已开 + 玩家输入被冻结",
			_main.hud.is_map_open() and _main.player.input_locked)
	_main.hud.tactical_map.close()  # 走「地图内关闭按钮」那条路径（靠 closed 信号复位）
	_check_true("关图：输入解冻（这是当年的回归点）",
			not _main.hud.is_map_open() and not _main.player.input_locked)

	# ② 载具链：太远拒绝 → 靠近上车 → 换座 → 操炮塔 → 开炮 → 下车
	var v = _main.vehicles.vehicle
	_main.player.global_position = v.global_position + Vector2(200.0, 0.0)
	_main.vehicles.toggle()
	_check_true("离载具 200 m：拒绝上车 + 提示太远",
			not v.is_occupied() and _main.hud.mark_hint.text.contains("太远"))
	_main.player.global_position = v.global_position
	_main.vehicles.toggle()
	_check_true("靠近后上车：占用 + 按钮变「下车」",
			v.is_occupied() and _main.hud.vehicle_button.text == "下车")
	# 载具相机三档（docx 19 ②）：上车就换档位表与拖拽上限
	_check_true("上车：相机切到载具档 [32,8,4]（docx 19 ②）",
			_main.camera_controller.in_vehicle
			and _main.camera_controller.zoom_levels() == GameConfig.VEHICLE_ZOOM_LEVELS)
	_check("上车：相机拖拽上限 1500 m",
			_main.camera_controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_VEHICLE)
	_main.vehicles.switch_seat()
	_check_true("换座到武器位：is_gunner + 标签显示武器位",
			_main.vehicles.is_gunner(_main.player)
			and _main.hud.role_label.text.contains("武器位"))
	var turret_before: Vector2 = v.turret_facing
	_main.camera_controller.crosshair_world = v.global_position + Vector2.UP * 100.0
	_main.vehicles.tick(0.1)
	_check_true("武器位操炮塔：朝准心转了一步（且不是瞬间对准）",
			not v.turret_facing.is_equal_approx(turret_before))
	var ammo_before: int = v.ammo()
	_main.vehicles.fire()
	_check("武器位开炮：消耗一发（直调控制器）", v.ammo(), ammo_before - 1)
	# 【2026-10-01 补覆盖】上面那条走的是 vehicles.fire()，而玩家按开火键走的是
	# FireButton.fired → PlayerFireController.fire() → vehicles.fire()。以前只测前半段，
	# 于是「开火键在武器位打不出炮」这类问题测试全绿也照样漏（排查 bug 时发现的覆盖缺口）。
	v._fire_cooldown = 0.0
	var ammo_via_callback: int = v.ammo()
	_main.hud.fire_button.fired.emit()
	_check("武器位开炮：走玩家那条路（fired 信号 → PlayerFireController.fire）也消耗一发",
			v.ammo(), ammo_via_callback - 1)
	# 报废后武器位必须给回话，而不是静默什么都不做
	v.take_hit(99999.0, 99999.0, Vector2.RIGHT)
	_check_true("报废：会被请下车", not v.is_occupied())
	_check("报废：HUD 上车键文字复位（否则玩家以为还在车里）",
			_main.hud.vehicle_button.text, "上车")
	_main.hud.mark_hint.text = ""
	_main.vehicles.toggle()
	_check_true("报废车：拒绝上车并说明原因",
			not v.is_occupied() and _main.hud.mark_hint.text.contains("报废"))
	# 由测试复位（后面还有交互链要用这辆车）
	v.destroyed = false
	v.hp = v.max_hp
	_main.vehicles.toggle()
	_check_true("载具恢复后可正常上车（避免污染后续交互链）", v.is_occupied())
	_main.vehicles.switch_seat()
	_check_true("载具恢复后换到武器位", _main.vehicles.is_gunner(_main.player))
	# 瞄高（docx 8.4.2 · 2026-10-05 加第四档「弹药架」）：武器位能换、驾驶位换不动
	var gear_before: int = v.aim_gear
	_main.hud.mark_hint.text = ""
	_check_true("瞄高：武器位显示瞄高键", _main.hud.aim_gear_button.visible)
	var aim_rect: Rect2 = _main.hud.aim_gear_button.get_global_rect()
	var clash := ""
	for other in [_main.hud.fire_button, _main.hud.explosive_button, _main.hud.focus_button]:
		if other != null and aim_rect.intersects(other.get_global_rect()):
			clash += String(other.name) + " "
	_check_true("瞄高：键不与开火 / 爆破 / 聚焦键重叠（枪手态几何）", clash == "")
	_check_true("瞄高：键不出屏（右缘 %.0f ≤ 960）" % aim_rect.end.x, aim_rect.end.x <= 960.0)
	_check_true("瞄高：武器位能换档", _main.vehicles.cycle_aim_gear())
	_check_true("瞄高：HUD 状态行显示当前档", _main.hud.role_label.text.contains("瞄高"))
	_check("瞄高：换到下一档", v.aim_gear,
			(gear_before + 1) % VehiclePartsScript.GEAR_COUNT)
	_check_true("瞄高：换档给了提示", _main.hud.mark_hint.text.contains("瞄高"))
	_main.vehicles.switch_seat()
	_check_true("瞄高：驾驶位不显示瞄高键", not _main.hud.aim_gear_button.visible)
	var gear_after: int = v.aim_gear
	_main.hud.mark_hint.text = ""
	_check("瞄高：驾驶位换不动", _main.vehicles.cycle_aim_gear(), false)
	_check("瞄高：驾驶位换档后档位没变", v.aim_gear, gear_after)
	_main.vehicles.switch_seat()          # 换回武器位，别污染后面的交互链
	v.aim_gear = VehiclePartsScript.Gear.HULL
	_main.vehicles.toggle()
	_check_true("下车：按钮回到「上车」", not v.is_occupied()
			and _main.hud.vehicle_button.text == "上车")
	_check_true("瞄高：下车后瞄高键收起", not _main.hud.aim_gear_button.visible)
	_check_true("下车：相机回到步兵档 [32,16,8] + 500 m 上限",
			not _main.camera_controller.in_vehicle
			and _main.camera_controller.zoom_levels() == GameConfig.ZOOM_LEVELS
			and _main.camera_controller.max_drag_distance == GameConfig.SIGHT_MAX_DISTANCE_INFANTRY)

	# ③ 报点标记链
	_main.camera_controller.blocked_by_terrain = false  # 直接给「通视前提」
	var n0: int = _main.marks.marks.size()
	_main.mark_ctl.place_at_crosshair(MarkSystem.MarkType.ENEMY)
	_check("轮盘报点：落一个标记", _main.marks.marks.size(), n0 + 1)
	_check_true("轮盘报点：提示已更新", _main.hud.mark_hint.text.contains("已报点"))
	_main.camera_controller.blocked_by_terrain = true
	_main.mark_ctl.place_at_crosshair(MarkSystem.MarkType.ENEMY)
	_check("地形挡住时不许报点（4.11.2 红线）", _main.marks.marks.size(), n0 + 1)
	_main.camera_controller.blocked_by_terrain = false
	var n1: int = _main.marks.marks.size()
	_main.mark_ctl.place_at(MarkSystem.MarkType.ENEMY,
			_main.player.global_position + Vector2(600.0, 0.0))
	_check("地图报点：超出 500 m 拖拽上限被拒", _main.marks.marks.size(), n1)

	# ④ 战斗与分数（步兵开火画曳光）
	# EventBus 只能运行时按名字取（见文件头约束①）
	var bus := root.get_node_or_null("EventBus")
	_check_true("事件总线 EventBus 已注册", bus != null)
	if bus != null:
		bus.emit_signal("enemy_killed", null)
	_check_true("击倒事件 → 战力分 +1 且标签刷新",
			_main.score >= 1 and _main.hud.score_label.text.contains("战力分"))
	var children_before: int = _main.get_child_count()
	_main.fire_ctl.fire()
	_check_true("步兵开火：画了一条曳光（Main 子节点 +1）",
			_main.get_child_count() > children_before)
	_main.player.take_damage(25.0)

	# ④.5 候选 L1：T-S3「摧毁敌方载具」端到端 —— 标记敌方载具 → 支线重算下发 → 击毁 → 结算 +20
	var tank = _main.vehicles.enemy_vehicle
	_main.marks.add_mark(MarkSystem.MarkType.VEHICLE, tank.global_position,
			RoleTable.mark_duration(_main.player_role))
	_main.quests.notify_mark_placed(tank.global_position)  # 报点事件 → 支线重算
	var has_ts3 := false
	for quest in _main.quests.quests:
		if String(quest["id"]) == "T-S3":
			has_ts3 = true
	_check_true("T-S3：标记敌方载具后支线下发（官方触发条件）", has_ts3)
	var side_now := 0
	for quest in _main.quests.quests:
		if not bool(quest["main"]):
			side_now += 1
	# 注意：这里不能写 QuestSystem.SIDE_QUEST_LIMIT —— QuestSystem 编译期依赖 CaptureZone（它用 EventBus 全局名）
	var side_limit: int = _main.quests.SIDE_QUEST_LIMIT
	_check_true("T-S3：重发后支线不超过 %d 条（实际 %d）" % [side_limit, side_now],
			side_now <= side_limit)
	var score_before: int = _main.score
	tank.take_hit(99999.0, 99999.0, Vector2.RIGHT)  # 一发打爆（穿深给足，绕开 808 mm 首上的判定）
	_check_true("T-S3：击毁敌方载具 → 任务结算 +20（战力分 %d → %d）"
			% [score_before, _main.score], _main.score == score_before + 20)

	# ④.6 候选 L2：T-S2「摧毁敌方 FOB」端到端 —— 先报点暴露 → 支线下发 → 打掉 → 结算 +20
	var fobs := get_nodes_in_group("fob_enemy")
	var fob = fobs[0] if fobs.size() > 0 else null
	_check_true("T-S2：敌方 FOB 在世界里", fob != null)
	if fob != null:
		var has_ts2 := false
		for quest in _main.quests.quests:
			if String(quest["id"]) == "T-S2":
				has_ts2 = true
		_check_true("T-S2：未被报点暴露前不下发（官方触发条件）", not has_ts2)
		# 4.11.2 红线：敌方默认不上地图 —— 没暴露的 FOB 不该出现在地图图层里
		_check("T-S2 ／ 4.11.2：未被报点暴露的 FOB 不上地图图层",
				MapLayerSourceScript.visible_fobs(self).size(), 0)
		_main.marks.add_mark(MarkSystem.MarkType.POSITION, fob.global_position,
				RoleTable.mark_duration(_main.player_role))
		_main.quests.notify_mark_placed(fob.global_position)
		var exposed := false
		for quest in _main.quests.quests:
			if String(quest["id"]) == "T-S2":
				exposed = true
		_check_true("T-S2：报点暴露 FOB 后支线下发", exposed)
		_check("4.11.2：报点暴露后 FOB 上地图图层（含小地图与战术地图）",
				MapLayerSourceScript.visible_fobs(self).size(), 1)
		var score_pre: int = _main.score
		fob.take_damage(GameConfig.FOB_MAX_HP + 1.0)
		_check_true("T-S2：FOB 打光结构值后摧毁", bool(fob.destroyed))
		_check_true("T-S2：摧毁 FOB → 任务结算 +20（战力分 %d → %d）"
				% [score_pre, _main.score], _main.score == score_pre + 20)

	# ④.7 为 T-S5 铺垫：把 0 号节点推进「容差吸附」区间，让 CaptureZone._process 自己翻蓝
	# （T-S5 的闸门是「我方已控制 ≥1 个节点」，翻蓝之后它才发得出来）
	# ⚠ 拍板 B 之后敌人驻守在节点上：不清点，「双方同在 = 对冲」会让进度原地不动（那是设计）
	_clear_zone_of_enemies()
	_main.capture_zones[0].progress = 0.9995

	# ⑤ 兵种 / 姿态 / 换枪 / 聚焦
	var role_before: int = _main.player_role
	_main._cycle_role()
	_check("兵种按钮：循环到下一个兵种", _main.player_role, RoleTable.next_role(role_before))
	_check_true("兵种标签跟随新兵种",
			_main.hud.role_label.text.contains(RoleTable.role_name(_main.player_role)))
	_main._cycle_posture()
	_check_true("姿势按钮：提示「姿态切换中」", _main.hud.mark_hint.text.contains("姿态"))
	_main._switch_weapon()
	_check_true("换枪按钮：进入切枪状态", _main.player.is_switching_weapon())
	_main.hud.apply_focus(true)
	# 准心 scale 是 float32（Vector2），0.45 存进去会变 0.44999998…，只能近似比较
	_check_true("聚焦：准心按 FOCUS_CROSSHAIR_SCALE 收窄",
			is_equal_approx(_main.hud.crosshair.scale.x, GameConfig.FOCUS_CROSSHAIR_SCALE)
			and is_equal_approx(_main.hud.crosshair.scale.y, GameConfig.FOCUS_CROSSHAIR_SCALE))
	_check_true("聚焦：暗角显示 + 玩家进入聚焦", _main.hud.vignette.visible
			and _main.player.focusing)
	_main.hud.apply_focus(false)
	_check_true("退出聚焦：暗角隐藏", not _main.hud.vignette.visible)

	# 2026-10-01 ④：把战术地图打开并留在下一阶段——它的 _draw() 只在 visible 时跑，
	# 不开图就等于「新加的图层代码一次都没被执行过」（小地图常显，所以那边每帧都在跑）
	_main.hud.tactical_map.open()


# ────────────── ②.5 地图世界图层（2026-10-01 ④）──────────────

## 小地图 / 战术地图都要画：己方补给车、侧翼通路、敌方 FOB（暴露后）。
## 取数走同一个 MapLayerSource —— 这里验「两张图都拿到了 Main」＋「三样东西都取得到」。
func _check_map_layers() -> void:
	_check_true("④ 小地图拿到了 Main（世界图层有数据源）", _main.hud.mini_map._main == _main)
	_check_true("④ 战术地图拿到了 Main（世界图层有数据源）",
			_main.hud.tactical_map._main == _main)
	var lane = MapLayerSourceScript.lane(_main)
	_check_true("④ 侧翼通路可取到（小地图与战术地图共用）", lane != null)
	if lane != null:
		_check_true("④ 通路节点就是 LaneController 建的那条", lane == _main.lane_ctl.lane)
	var convoy = MapLayerSourceScript.convoy(_main)
	_check_true("④ 补给车可取到（4.11.1 ④ 己方全显）", convoy != null)
	if convoy != null:
		_check_true("④ 补给车节点就是 SupplyController 派的那辆",
				convoy == _main.supply_ctl.convoy)
	# FOB：这一轮跑下来已经被报点暴露过（见 ④.6），所以在地图图层里应该还在
	_check("④ 敌方 FOB 暴露后一直留在图层上",
			MapLayerSourceScript.visible_fobs(self).size(), 1)
	# 地图开过一阶段了，收掉，别影响后面的断言
	_main.hud.tactical_map.close()


# ────────────── ③ 需要等一会儿的（提示超时 / 标签跟随）──────────────

func _check_late() -> void:
	_check("报点提示 1.6 s 后自动消失", _main.hud.mark_hint.text, "")
	_check_true("血量标签跟随玩家（血量 %d）" % int(_main.player.hp),
			_main.hud.hp_label.text.begins_with("血量 %d" % int(_main.player.hp)))


## 候选 L3：T-S5 护送补给——我方控制节点后任务下发、控制器派车
func _check_supply_escort() -> void:
	_check("T-S5：前置就绪——0 号节点已翻蓝（我方已控制 ≥1 节点）",
			int(_main.capture_zones[0].state), 1)
	# 真机上这条重算由「报点 / 任务完成 / 失败」这些战局事件触发，这里直接调同一个入口
	_main.quests._assign_side_quests()
	var has_ts5 := false
	var target_zone = null
	for quest in _main.quests.quests:
		if String(quest["id"]) == "T-S5":
			has_ts5 = true
			target_zone = quest.get("zone")
	_check_true("T-S5：我方控制节点后支线下发", has_ts5)
	_check_true("T-S5：任务带「指定节点」（要送到哪个节点）", target_zone != null)
	var convoy = _main.get_node_or_null("SupplyConvoy")
	_check_true("T-S5：补给护送控制器已派车", convoy != null)
	if convoy != null and target_zone != null:
		_check_true("T-S5：补给车朝指定节点开（还有 %.0f m）" % convoy.distance_left(),
				convoy.distance_left() > 0.0)
		_ts5_score_before = _main.score
		# 直接挪到目标点，省掉 ~90 s 的行车时间；下一帧它自己判「抵达」
		convoy.global_position = target_zone.global_position
		_check_true("T-S5：已挪到目标点（等它自己判抵达）",
				convoy.distance_left() <= GameConfig.SUPPLY_ARRIVE_RADIUS)


## 补给车抵达 → T-S5 结算（必须赶在全占胜利之前查，免得和主线 +40 混在一起）
func _check_supply_arrived() -> void:
	var convoy = _main.get_node_or_null("SupplyConvoy")
	_check_true("T-S5：补给车自己判定抵达", convoy != null and bool(convoy.has_arrived()))
	var still := false
	for quest in _main.quests.quests:
		if String(quest["id"]) == "T-S5":
			still = true
	_check_true("T-S5：抵达后任务移出列表", not still)
	_check_true("T-S5：抵达结算 +15（战力分 %d → %d）"
			% [_ts5_score_before, _main.score], _main.score == _ts5_score_before + 15)


## 候选 L4：T-S6 守住侧翼通路——有主线 + 有通路时下发任务、派穿插兵、穿线即失败
func _check_lane_dispatch() -> void:
	var lanes := get_nodes_in_group("flank_lane")
	_check_true("T-S6：场上有侧翼通路（候选 L4）", lanes.size() == 1)
	_main.quests._assign_side_quests()
	_check_true("T-S6：主线为占领 + 有通路 → 支线下发", _has_quest("T-S6"))
	var spawned := 0
	var first = null
	for node in get_nodes_in_group("enemy"):
		if String(node.name).begins_with("Infiltrator"):
			spawned += 1
			if first == null:
				first = node
	_check("T-S6：通路入口派出穿插兵", spawned, GameConfig.LANE_INFILTRATORS)
	if first == null:
		return
	var lane = lanes[0]
	_check_true("T-S6：穿插兵在通路入口一侧（离出口 %.0f m）"
			% first.global_position.distance_to(lane.exit_position),
			lane.progress_along(first.global_position) < 1.0)
	_ts6_score_before = _main.score
	# 把一名穿插兵挪到出口之外，手动推一帧 LaneController：省掉等帧，也避免和主线完成的 +40 混在一起
	first.global_position = lane.exit_position + Vector2(-30.0, 0.0)
	_check_true("T-S6：该位置判定为「已穿线」", lane.is_crossed(first.global_position))
	_main.lane_ctl._process(0.0)
	_check_true("T-S6：穿线 → 任务失败（移出列表）", not _has_quest("T-S6"))
	_check_true("T-S6：失败不扣分也不加分（战力分 %d → %d）"
			% [_ts6_score_before, _main.score], _main.score == _ts6_score_before)


## 当前任务列表里有没有这条模板
func _has_quest(id: String) -> bool:
	for quest in _main.quests.quests:
		if String(quest["id"]) == id:
			return true
	return false


## 候选 L5：T-M2 守住节点——拿下节点后主线转防守；节点被翻红则失守、主线回到「夺回该节点」
func _check_main_defend() -> void:
	var main_q: Dictionary = _main.quests.main_quest()
	_check("T-M2：0 号节点被我方拿下后，主线转入防守阶段",
			String(main_q.get("id", "")), "T-M2")
	_check_true("T-M2：防守目标就是刚拿下的节点",
			main_q.get("zone") == _main.capture_zones[0])
	# 节点被翻红：手动推一帧节点（让它自己判红并广播）+ 一帧任务系统
	# —— 省掉等帧，也避免和后面「全占胜利」互相干扰
	_main.capture_zones[0].progress = -0.9995
	_main.capture_zones[0]._process(0.0)
	_main.quests.update(0.0)
	_check("T-M2：节点被翻红 → 失守，主线回到「夺回该节点」",
			String(_main.quests.main_quest().get("id", "")), "T-M1")
	_check_true("T-M2：夺回目标就是丢掉的节点",
			_main.quests.main_quest().get("zone") == _main.capture_zones[0])


## 全占胜利：不去直接改 state，而是把进度推到「容差吸附」区间，让 CaptureZone._process
## 自己翻蓝并广播 flag_state_changed —— 走的就是真机那条链路。
func _arm_victory() -> void:
	_clear_zone_of_enemies()   # 同上：敌人站在点上时进度不该涨
	for zone in _main.capture_zones:
		zone.progress = 0.9995


func _check_victory() -> void:
	var all_blue := true
	for zone in _main.capture_zones:
		if int(zone.state) != 1:  # CaptureZone.State.BLUE == 1（NEUTRAL, BLUE, RED）
			all_blue = false
	_check_true("三个节点经真实状态机翻蓝", all_blue)
	_check_true("全占 → 胜利结算 + 胜利文字出现",
			_main._victory and _main.hud.victory_label.visible)


# ────────────── 候选 P：烟雾遮蔽端到端（docx 4.12 / 4.12.8 确认稿）──────────────
# 验收四条：① 投烟后敌方通视立刻判黑 ② 无通视时 AI 朝最后已知位置盲射、命中率 −70%
#           ③ 轮盘能标烟雾区（MarkSystem 的烟雾类型，见 mark_test） ④ 烟散后通视恢复
# 纯几何 / 高度规则 / 命中率抽签在 test/smoke_test.gd 里测；这里验的是「接进 SightSystem 与 AI 之后真的这样」。

func _check_smoke() -> void:
	if _main == null or _main.player == null or not is_instance_valid(_main.player):
		_check_true("候选 P：烟雾端到端（前置：玩家还在场）", false)
		return
	_restore_player()   # 前面可能被打倒：倒地的玩家眼高只有 0.6 m，烟线判据会跟着变
	var enemies := get_nodes_in_group("enemy")
	_check_true("候选 P：场上有敌人可用来验烟", enemies.size() > 0)
	if enemies.is_empty():
		return
	var enemy = enemies[0]
	var pair := _find_clear_sight_pair(24.0)
	_check_true("候选 P：找到一对「投烟前就通视」的位置（前置）", pair.size() == 2)
	if pair.size() != 2:
		return
	var from: Vector2 = pair[0]      # 敌人站这边
	var to: Vector2 = pair[1]        # 玩家站这边
	_check_true("候选 P：投烟前这条视线是通的", _sight_clear(from, to))

	# 摆位：敌人看得见玩家 → 正常交火（基线）
	_main.player.global_position = to
	enemy.global_position = from
	enemy.detection_range = 60.0
	_reset_sight_caches()   # 传送后就地问 AI：不先清缓存会拿到传送前的结论
	_tick_ai(enemy, 0.5)
	var seen_at: Vector2 = _main.player.global_position
	_check_true("候选 P：投烟前 AI 是正常交火（不是盲射）", not enemy.is_blind_firing())

	# 投烟：烟落在两人中间
	_main.smoke_ctl.spawn_smoke((from + to) * 0.5)
	_check("候选 P：投烟后场上有一团烟（SMOKE_GROUP）",
			get_nodes_in_group(GameConfig.SMOKE_GROUP).size(), 1)
	_check_true("候选 P ①：投烟后同一条视线立刻判黑（4.12.4）", not _sight_clear(from, to))

	# 4.12.4 后半句：准心拖进烟雾区按遮挡处理（停在烟前）
	_main.camera_controller.crosshair_world = from
	_main.camera_controller._resolve_crosshair()
	var crosshair_gap: float = _main.player.global_position.distance_to(
			_main.camera_controller.crosshair_world)
	_check_true("候选 P ①：准心被烟挡住并回退到烟前（%.1f m < 12 m 烟心）" % crosshair_gap,
			_main.camera_controller.blocked_by_terrain and crosshair_gap < 12.0)
	var marks_before_crosshair: int = _main.marks.marks.size()
	_main.mark_ctl.place_at_crosshair(MarkSystem.MarkType.SMOKE)
	_check("候选 P ①：隔着烟不许报点（4.11.2 通视红线 + 4.12.4）",
			_main.marks.marks.size(), marks_before_crosshair)

	# 无通视 → 盲射，且瞄的是「最后已知位置」而不是实时位置（4.11.2 红线）
	# 拍板 B 之后重挑是 0.3 s 节流的 ⇒ 必须推进时间，单次 _update_ai(0.0) 推不动
	_tick_ai(enemy, 0.5)
	_check_true("候选 P ②：无通视时 AI 转入盲射（4.12.5）", enemy.is_blind_firing())
	_main.player.global_position = to + Vector2(0.0, 15.0)   # 玩家挪窝：AI 不该跟着转
	_tick_ai(enemy, 0.1)
	_check("候选 P ②：盲射瞄的是最后已知位置，不是玩家实时位置",
			enemy.blind_aim_target(), seen_at)
	var shots_before: int = enemy.blind_shots
	enemy._update_ai(2.0)                                     # 推过开火间隔
	_check_true("候选 P ②：盲射真的打出去了（盲射计数 %d → %d）"
			% [shots_before, enemy.blind_shots], enemy.blind_shots > shots_before)
	_check("候选 P ②：盲射命中率倍率 = 0.3（−70%，4.12.8 ④）",
			GameConfig.SMOKE_BLIND_FIRE_HIT_SCALE, 0.3)

	# 烟散 → 通视恢复、AI 回到正常交火
	var smoke = get_nodes_in_group(GameConfig.SMOKE_GROUP)[0]
	smoke.time_left = 0.01
	smoke._process(0.02)
	_main.player.global_position = to
	_check_true("候选 P ④：烟散后同一条视线恢复（4.12.3）", _sight_clear(from, to))
	_tick_ai(enemy, 0.5)
	_check_true("候选 P ④：烟散后 AI 回到正常交火（不再盲射）", not enemy.is_blind_firing())


## 在几个「地形一定平」的锚点周围扫一圈，找一对**又通视、又够平**的位置（不去赌地形）
##
## 为什么要「够平」这一条（2026-10-05 补）：烟高 3 m、眼高约 2.3 m。如果这一对的
## 两端高差或中点隆起超过约 1 m，视线会从烟顶掠过 —— 那是几何事实，不是烟失效。
## 第六十一版把出生点从 demo 摆位换成「地图出生区里挑出的平地」之后，前面几项检查把玩家
## 带到了河岸上（那儿 12 m 就掉 17 m），于是这条前置条件第一次露馅：三条烟断言连带两条 AI 断言全红。
## 白旗点核心是生成器**刻意压平**过的，所以「优先玩家位置、再退到节点」的扫法配上平地要求就能找到对的位置。
func _find_clear_sight_pair(distance: float) -> Array:
	var anchors: Array = [_main.player.global_position]
	for zone in _main.capture_zones:
		anchors.append((zone as Node2D).global_position)
	for anchor in anchors:
		for i in 32:
			var angle := TAU * float(i) / 32.0
			var offset := Vector2(cos(angle), sin(angle)) * distance * 0.5
			var from: Vector2 = anchor + offset
			var to: Vector2 = anchor - offset
			if not _sight_clear(from, to):
				continue
			# 只查两端 + 中点是不够的：地形可以在两点之间鼓起来，把卧姿玩家的视线顶掉
			# （2026-10-05 实测：两端差 0.6 m、中点也只差 0.6 m，但 20% 处就隆起 2 m 多）。
			var high_from: float = _main.grid.height_at_world(from)
			var high_to: float = _main.grid.height_at_world(to)
			var flat := true
			for k in range(1, 5):
				var ratio := float(k) / 5.0
				var line_height := lerpf(high_from, high_to, ratio)
				if absf(_main.grid.height_at_world(from.lerp(to, ratio)) - line_height) > 1.0:
					flat = false
					break
			if not flat:
				continue
			return [from, to]
	return []


## 这条视线在**游戏里**到底通不通 —— 口径与 Enemy._can_see_player() 一致：
## 起点用敌方的眼高（eye_height_at），目标用**玩家姿态相关**的高度（unit_sight_height ⇒ 卧姿 0.6 m）。
## 为什么必须一致（2026-10-05 踩到）：玩家卧姿时目标高度降到 0.6 m，用固定 2.34 m 眼高算出来的
## 「通视」会让测试以为 AI 该看得见，而 AI 其实被地形凸起挡住了 —— 三条烟 / AI 断言因此假红。
func _sight_clear(from: Vector2, to: Vector2) -> bool:
	return _main.sight.has_sight(from, _main.sight.eye_height_at(from),
			to, _main.sight.unit_sight_height(to, _main.player))


# ────────────── 候选 O 第一轮：战斗播报（4.14）+ 操作提示（4.15）──────────────
# 纯逻辑在 test/combat_feed_test.gd 与 test/tips_test.gd；这里验「真的接进 HUD 与事件链」。

func _check_candidate_o() -> void:
	# ① 两个面板都挂在 HUD 层上（纯展示、不参与交互）
	_check_true("候选 O：播报 / 提示面板挂在 HUD 层上（4.14 / 4.15）",
			_main.hud.feed != null and _main.hud.tips != null
			and _main.hud.feed.get_parent() == _main.hud.get_node("HUD")
			and _main.hud.tips.get_parent() == _main.hud.get_node("HUD"))

	# ② 4.14：走真实事件总线（enemy_killed → 面板 → 播报行）
	var bus := root.get_node_or_null("EventBus")
	_check_true("候选 O 4.14：播报面板已接上事件总线（enemy_killed）",
			bus != null and bus.enemy_killed.is_connected(_main.hud.feed._on_enemy_killed))
	if bus != null:
		_main.hud.feed.feed.clear()
		bus.emit_signal("enemy_killed", null)
		_check("候选 O 4.14：击倒事件 → 播报一条（真链路）", _main.hud.feed.feed.size(), 1)
		_check_true("候选 O 4.14：文案是「击倒敌人」",
				_main.hud.feed.feed.to_bbcode().contains("击倒敌人"))
		_main.hud.feed.tick(0.0)
		_check_true("候选 O 4.14：HUD 播报面板文字已刷新",
				_main.hud.feed.text.contains("击倒敌人"))

	# ③ 4.14：模块入口（main.hud.push_feed）与同类合并（限频）
	_main.hud.feed.feed.clear()
	for i in 3:
		_main.hud.push_feed("o_test", "测试播报", Color.WHITE)
	_check("候选 O 4.14：同类播报合并成一条", _main.hud.feed.feed.size(), 1)
	_check_true("候选 O 4.14：合并后文案带 ×3",
			_main.hud.feed.feed.to_bbcode().contains("×3"))

	# ④ 4.15：开局的「任务已更新」由真实的 quest_list_changed 广播触发（一次性）
	var book = _main.hud.tips.tips
	_check_true("候选 O 4.15：任务列表广播真的触发了「任务已更新」",
			book.seen("quest_updated"))
	_check_true("候选 O 4.15：提示目录不少于 5 条", book.TIPS.size() >= 5)

	# ⑤ 4.15：请求一条还没弹过的提示 → HUD 上显示的就是它
	var fresh := ""
	for id in book.TIPS:
		if not book.seen(id):
			fresh = id
			break
	_check_true("候选 O 4.15：目录里还有没弹过的提示（「一次性」不等于「都不弹」）", fresh != "")
	if fresh != "":
		book._active = {}
		book._pending = {}
		book._cooldown = 0.0
		_check_true("候选 O 4.15：请求后进入显示状态", book.request(fresh))
		_main.hud.tips.tick(0.0)
		_check("候选 O 4.15：HUD 上显示该条文案", _main.hud.tips.text, book.TIPS[fresh])
		_check_true("候选 O 4.15：提示面板可见", _main.hud.tips.visible)

	# ⑥ 4.15：总开关（4.15「可在设置关闭」）
	_main.hud.set_tips_enabled(false)
	_check("候选 O 4.15：设为关闭后开关值生效", book.enabled, false)
	_main.hud.set_tips_enabled(true)
	_check("候选 O 4.15：重新打开", book.enabled, true)


# ────────────── 候选 O 第二轮：快捷指令（docx 4.13）──────────────
# 纯逻辑在 test/command_test.gd；这里验「轮盘 → 沟通链 → 落标记 / 播报」这条真链路。

func _check_commands() -> void:
	# ① 接线：轮盘 → MarkController.send_command → CommandController（执行体挂在沟通链下，Main 不多子模块）
	_check_true("候选 O 4.13：指令轮盘已接上沟通链",
			_main.hud.command_wheel.command_requested.is_connected(_main.mark_ctl.send_command))
	_check_true("候选 O 4.13：执行体挂在 MarkController 下（Main 不多一个子模块）",
			_main.mark_ctl.commands != null
			and _main.mark_ctl.commands.get_parent() == _main.mark_ctl)

	# ② 口头类指令：不落点，进播报 + 主视图提示（走真实信号，不直调函数）
	_main.camera_controller.blocked_by_terrain = false
	_main.camera_controller.crosshair_world = _main.player.global_position + Vector2(80.0, 0.0)
	var marks_before: int = _main.marks.marks.size()
	_main.hud.feed.feed.clear()
	_main.hud.command_wheel.command_requested.emit("support")
	_check("候选 O 4.13：口头类指令不落标记", _main.marks.marks.size(), marks_before)
	_check_true("候选 O 4.13：口头类指令进战斗播报",
			_main.hud.feed.feed.to_bbcode().contains("需要支援"))
	# ③ 限频两层：同一条指令的冷却 + 任意两条之间的公共冷却
	_check_true("候选 O 4.13：同一条指令立刻重发被冷却拦下",
			not _main.mark_ctl.send_command("support"))
	_check_true("候选 O 4.13：公共冷却期内换一条也发不出去",
			not _main.mark_ctl.send_command("cover"))
	_main.mark_ctl.commands.book.tick(GameConfig.COMMAND_GLOBAL_COOLDOWN + 0.1)
	_check_true("候选 O 4.13：公共冷却过后换一条可以发", _main.mark_ctl.send_command("cover"))

	# ④ 落点类指令：走报点体系落成真实标记（于是小地图 / 战术地图天然会画）
	_main.mark_ctl.commands.book.tick(GameConfig.COMMAND_GLOBAL_COOLDOWN + 0.1)
	var marks_before_rally: int = _main.marks.marks.size()
	_main.hud.feed.feed.clear()
	_check_true("候选 O 4.13：「集结点」发得出去（落点类）",
			_main.mark_ctl.send_command("rally"))
	_check("候选 O 4.13：集结点落成一个标记", _main.marks.marks.size(), marks_before_rally + 1)
	var last: Dictionary = _main.marks.marks[_main.marks.marks.size() - 1]
	_check("候选 O 4.13：新标记类型是集结点", int(last["type"]), MarkSystem.MarkType.RALLY)
	_check_true("候选 O 4.13：集结点指令进战斗播报",
			_main.hud.feed.feed.to_bbcode().contains("集结点"))


# ────────────── 候选 M 第一轮：表现层（docx 12.3 阴影 / 12.7.3 枪口火光 / 12.7.4 命中与受击）──────
# 纯规则在 test/effects_test.gd；这里验「真的长在实体上、真开枪时真的挂进场景」。

## 集成冒烟是**脚本化验收**，不是打一局：把敌人的单发伤害临时归零，并把玩家恢复成满血站立。
## 为什么需要（2026-10-02 恢复正式值 fire_damage = 20 之后暴露）：敌人现在真的会打死人 ——
## 玩家在检查过程中被击倒后，「玩家还站着」「开一枪多出 3 个节点」这类前置会随机失败，
## 看着像功能坏了，其实只是脚本被打了。只关伤害，不动 detection / AI（AI 相关检查还要靠它）。
func _neutralize_enemy_fire() -> void:
	for enemy in get_nodes_in_group("enemy"):
		enemy.fire_damage = 0.0
	_restore_player()


## 传送任何单位之后必须清掉感知节流缓存（2026-10-05）：
## SightSystem.Throttle 每 SIGHT_THROTTLE_FRAMES（4）个物理帧才真查一次地形 + 掩体层，
## 而测试是「同一物理帧里传送 + 立刻问 AI 看不看得见」—— 不清就会拿到**传送前**的结论。
## 产品里这是设计内的有界陈旧（≤4 帧 ≈ 66 ms，单位是连续移动的），只有瞬移的测试要自己负责清。
## 把站在占领区里的敌人挪出去（2026-10-05 · 拍板 B 之后必须有这一步）：
## 敌人现在**驻守在地图节点上**，而 CaptureZone 的规则是「双方同在 = 对冲、进度不动」（docx 4.2）——
## 这是设计要的「要拿点先清点」，但测试里「把进度推到容差区等它自己翻蓝」的写法必须先把人挪开。
func _clear_zone_of_enemies() -> void:
	for node in get_nodes_in_group("enemy"):
		var enemy := node as Node2D
		if enemy == null or not is_instance_valid(enemy):
			continue
		for zone_v in _main.capture_zones:
			var zone := zone_v as Node2D
			if zone != null and zone.is_inside(enemy.global_position):
				enemy.global_position = Vector2(30.0, 30.0)   # 地图西北角：离五个节点都 ≥ 400 m
				break


## 推进敌人的 AI 一段时间（2026-10-05 第六十五版起必须有这一步）：
## 拍板 B 之后敌人重挑目标是 **0.3 s 节流**的（不节流就是 7× 性能回归），
## 而 AI 是时间制的 —— 测试里那句单次 _update_ai(0.0) 推不动间隔，目标永远挑不出来。
func _tick_ai(enemy, seconds: float = 0.7) -> void:
	var step := 1.0 / 60.0
	var left := seconds
	while left > 0.0:
		enemy._update_ai(minf(step, left))
		left -= step


func _reset_sight_caches() -> void:
	for node in get_nodes_in_group("enemy"):
		var throttle: Variant = node.get("_sight_throttle")
		if throttle != null:
			throttle.reset()
	if _main != null and _main.vehicles != null and _main.vehicles.enemy_vehicle != null:
		var tank_throttle: Variant = _main.vehicles.enemy_vehicle.get("_sight_throttle")
		if tank_throttle != null:
			tank_throttle.reset()


func _restore_player() -> void:
	if _main == null or _main.player == null:
		return
	var player = _main.player
	player.alive = true
	player.downed = false
	player.downed_time_left = 0.0
	player.hp = GameConfig.SOLDIER_HP


func _check_effects() -> void:
	_restore_player()   # 前面可能被压制 / 挨打过：开火前先保证站着（倒了开不出枪）
	# ① 12.3 Blob Shadow：角色 / 敌人脚下都挂着阴影
	var shadow = _main.player.get_node_or_null("BlobShadow")
	_check_true("候选 M 12.3：玩家脚下有 Blob Shadow", shadow != null)
	var enemies := get_nodes_in_group("enemy")
	_check_true("候选 M 12.3：敌人脚下有 Blob Shadow",
			enemies.size() > 0 and enemies[0].get_node_or_null("BlobShadow") != null)
	_check("候选 M 12.3：阴影进 TERRAIN_ZONE_GROUP 之外（不参与任何判定）",
			_main.player.get_node_or_null("BlobShadow").get_class(), "Node2D")
	if shadow != null:
		_check("候选 M 12.3：贴地时缩放 = 1.0", shadow.current_scale(), 1.0)
		shadow.set_height(0.5)
		_check("候选 M 12.3：抬高 0.5 m → 缩到 0.6（滞空变小）", shadow.current_scale(), 0.6)
		_check_true("候选 M 12.3：抬高后同时变淡",
				shadow.current_alpha() < GameConfig.BLOB_SHADOW_ALPHA)
		shadow.set_height(0.0)
		_check_true("候选 M 12.3：阴影画在身体之后（show_behind_parent）",
				shadow.show_behind_parent)

	# ② 12.7.3 / 12.7.4：真开一枪 → 曳光 + 枪口火光 + 弹着特效都挂进场景
	_main.camera_controller.blocked_by_terrain = false
	_main.camera_controller.crosshair_world = _main.player.global_position + Vector2(80.0, 0.0)
	var before: int = _main.get_child_count()
	_main.hud.fire_button.fired.emit()
	var after: int = _main.get_child_count()
	_check_true("候选 M 12.7.3/4：开一枪多出至少 3 个节点（曳光 + 枪口火光 + 弹着）",
			after >= before + 3)

	# ③ 12.7.4 受击闪白 + 轻微屏幕震动（玩家）
	_main.player.take_damage(5.0)
	_check_true("候选 M 12.7.4：玩家受击 → 闪白计时拉满",
			_main.player._hit_flash_left > 0.0)
	_check_true("候选 M 12.7.4：玩家受击 → 相机开始轻微震动",
			_main.camera_controller.shake_active())
	var offset: Vector2 = _main.camera_controller.advance_shake(0.02)
	_check_true("候选 M 12.7.4：震动幅度很小（≤ 0.35 m）",
			absf(offset.x) <= GameConfig.SCREEN_SHAKE_STRENGTH
			and absf(offset.y) <= GameConfig.SCREEN_SHAKE_STRENGTH)
	_main.camera_controller.advance_shake(GameConfig.SCREEN_SHAKE_TIME)
	_check_true("候选 M 12.7.4：震动到点自己停下",
			not _main.camera_controller.shake_active())

	# ④ 12.7.4 敌人受击也闪白（双方一致，玩家才看得出「打中了」）
	if enemies.size() > 0:
		enemies[0].take_damage(1.0)
		_check_true("候选 M 12.7.4：敌人受击 → 闪白计时拉满",
				enemies[0]._hit_flash_left > 0.0)


# ────────────── 反坦克导弹（使用者 2026-10-01 拍板：IFV 装 ATGM，能打爆敌方坦克）──────────────

func _check_atgm() -> void:
	var ifv = _main.vehicles.vehicle
	# 武器位要有人：这里直接给操作员（跳过上车距离判定）。放在前面 —— HUD 的载具分支
	# 判的是 is_occupied()，不先坐上去 update_role() 会走步兵分支、看不到弹种。
	ifv.operator = _main.player
	_check_true("ATGM：玩家的步战车装了反坦克导弹", ifv.has_atgm())
	_check("ATGM：一个基数 2 发", ifv.atgm_total(), 2)
	# ① HUD：弹种键 + 接线（走真实的按钮信号，不直调函数）
	_check_true("ATGM：HUD 有弹种键", _main.hud.ammo_type_button != null)
	_check_true("ATGM：弹种键已接上切弹种",
			_main.hud.ammo_type_button.pressed.is_connected(_main.vehicles.switch_ammo))
	_main.hud.ammo_type_button.pressed.emit()
	_check("ATGM：按一下切到反坦克导弹", ifv.ammo_type(), 1)
	_check("ATGM：武器位选中导弹时相机拖拽上限 2000 m（docx 19 ②）",
			_main.camera_controller.max_drag_distance, GameConfig.SIGHT_MAX_DISTANCE_ATGM)
	_main.hud.update_role()
	_check_true("ATGM：HUD 显示当前弹种是反坦克导弹",
			_main.hud.role_label.text.contains("反坦克导弹"))
	# ② 真开一炮（走 VehicleController.fire 这条链路）：消耗的是导弹，主炮弹药不动
	ifv._fire_cooldown = 0.0
	var gun_ammo_before: int = ifv.ammo()
	var atgm_before: int = ifv.atgm_ammo()
	_main.camera_controller.crosshair_world = ifv.global_position + Vector2(400.0, 0.0)
	_main.vehicles.fire()
	_check("ATGM：开一炮消耗的是导弹", ifv.atgm_ammo(), atgm_before - 1)
	_check("ATGM：主炮弹药没被动（各记各的账）", ifv.ammo(), gun_ammo_before)
	# ③ 两发导弹打爆敌方主战坦克（真实装甲 / 伤害链路；坦克在 _check_interactions 里被打爆过，先修好它）
	var tank = _main.vehicles.enemy_vehicle
	if tank != null:
		tank.destroyed = false
		tank.hp = tank.max_hp
		var front := VehicleTableScript.effective_armor_mm(tank.data, "front", 0.0)
		_check_true("ATGM：主战坦克正面等效 ≈ 808 mm（700 ÷ cos30°）",
				absf(front - 808.29) < 1.0)
		var damage := float(ifv.atgm_value("atgm_damage", 0.0))
		var penetration := float(ifv.atgm_value("atgm_penetration_mm", 0.0))
		var first: Dictionary = tank.take_hit(damage, penetration, tank.hull_facing)
		_check_true("ATGM：第一发正面击穿（900 ≥ 808）", bool(first["penetrated"]))
		_check("ATGM：第一发打掉 1000", float(first["damage"]), 1000.0)
		var second: Dictionary = tank.take_hit(damage, penetration, tank.hull_facing)
		_check_true("ATGM：第二发把主战坦克打爆（2000 结构值 ÷ 2 发）",
				bool(second["destroyed"]) and tank.destroyed)
		_check("ATGM：打爆后结构值归零", tank.hp, 0.0)


# ────────────── 真机反馈 2026-10-02：残骸可命中 / 发烟器跟车 / 烟里准心不锁死 ──────────────

## 被击毁的敌方坦克不能再当空气（旧实现把 destroyed 的车从 targets 里排除）
func _check_wreck_hittable() -> void:
	var wreck = _main.vehicles.enemy_vehicle
	var ifv = _main.vehicles.vehicle
	_check_true("残骸：敌方坦克此时已报废", bool(wreck.destroyed))
	# 摆到车头前 60 m + 临时摘掉通视系统：这条只验「残骸能被命中且有照实提示」，不想被地形遮挡搅进来
	wreck.global_position = ifv.global_position + ifv.hull_facing * 60.0
	ifv.turret_facing = ifv.hull_facing
	var sight_backup = ifv._sight
	ifv._sight = null
	var ray: Dictionary = BallisticsSystem.resolve_shot(ifv.muzzle_position(),
			ifv.turret_facing, 1500.0, [wreck], GameConfig.ENEMY_HIT_RADIUS, null,
			GameConfig.SOLDIER_EYE_HEIGHT)
	_check_true("残骸：弹道射线命中残骸（以前残骸被排除在 targets 之外）",
			ray["target"] == wreck)
	ifv._fire_cooldown = 0.0
	_main.hud.show_hint("")
	_main.vehicles.fire()
	# 提示行走的是 HudBuilder.show_hint → mark_hint（不是 hint_label，那个是常驻操作说明）
	_check_true("残骸：命中后有照实提示（不再拿 0 mm 等效算「未击穿」）",
			_main.hud.mark_hint.text.contains("残骸"))
	ifv._sight = sight_backup


## 载具发烟器：烟幕要绑在车体上跟着走；人站在自己放的烟里时准心不能被钳死
# ────────────── 重生（候选 Q）：阵亡 → 扣预算 → 满血 + 回出生点 ──────────────

func _check_respawn() -> void:
	var flow = _main.match_flow
	_check_true("重生：战局流程已挂到 Main 上", flow != null)
	if flow == null:
		return
	flow.budget = 2
	flow.phase = 0                        # Phase.PLAYING
	var spawn: Vector2 = _main.player.respawn_point
	_check_true("重生：出生点已记录（不是零向量）", spawn != Vector2.ZERO)
	var death_pos := spawn + Vector2(120.0, 80.0)
	_main.player.global_position = death_pos                     # 死在离出生点 140 m 处
	_main.player.suppression = 0.9
	_main.player.hp = 0.0
	_main.player.alive = true
	_main.player.down()
	_main.player.die()                    # 真的发 player_died → MatchFlow.on_player_died
	_check("重生：预算扣 1", flow.budget, 1)
	_check_true("重生：人复活了（不再停在阵亡态）", _main.player.alive)
	_check("重生：血量补满", _main.player.hp, GameConfig.SOLDIER_HP)
	# 落点现在是「出生点 + 我方节点」里离敌人最远的那个（候选 Q 的安全落点），不再写死出生点
	var landed: Vector2 = _main.player.global_position   # _main 是鸭子类型，必须显式标类型
	var is_candidate := landed == spawn
	for zone in _main.capture_zones:
		if landed == zone.global_position:
			is_candidate = true
	_check_true("重生：落在己方候选点（出生点 / 我方节点）上，不是死亡位置",
			is_candidate and landed != death_pos)
	_check("重生：压制清零", _main.player.suppression, 0.0)
	_check_true("重生：不再是倒地态 + 输入解锁",
			not _main.player.downed and not _main.player.input_locked)


# ────────────── 倒地后不再被攻击（候选 Q，使用者 2026-10-02 反馈）──────────────

func _check_downed_not_targeted() -> void:
	var enemies := get_nodes_in_group("enemy")
	_check_true("倒地停火：场上有敌人可测", enemies.size() > 0)
	if enemies.is_empty():
		return
	var enemy = enemies[0]
	_restore_player()
	# 站到敌人眼前（2026-10-05）：不再写死「东边 12 m」—— 那条线可能正好被地形 / 河岸切掉。
	# 8 个方向里挑第一个**真有通视**的（口径同 AI），挑不到才退回东边。
	var enemy_pos: Vector2 = enemy.global_position
	var chosen := Vector2(12.0, 0.0)
	for i in 8:
		var angle := TAU * float(i) / 8.0
		var candidate: Vector2 = enemy_pos + Vector2(cos(angle), sin(angle)) * 12.0
		if _sight_clear(enemy_pos, candidate):
			chosen = candidate - enemy_pos
			break
	_main.player.global_position = enemy_pos + chosen
	_reset_sight_caches()   # 同上：玩家刚被瞬移，敌方的感知缓存必须清
	_tick_ai(enemy, 0.5)    # 拍板 B：重挑目标 0.3 s 节流，推进时间才挑得出来
	var engaged: bool = int(enemy._state) == 1        # AIState.COMBAT
	# 再倒地：**仍然**是交战态 —— 这是「倒地可被补刀」（使用者 2026-10-02 拍板）的前提
	_main.player.hp = 0.0
	_main.player.down()
	_tick_ai(enemy, 0.2)
	_check_true("补刀前提：站着时敌人交战", engaged)
	if GameConfig.ENEMY_FINISH_OFF_ENABLED:
		_check("补刀开：玩家倒地后敌人仍然交战（会来补刀）", int(enemy._state), 1)
	else:
		_check("补刀关（🧪 测试态）：玩家倒地后敌人退回巡逻", int(enemy._state), 0)
	# 敌方坦克：站着会开炮，倒地的玩家不再挨炮
	var tank = _main.vehicles.enemy_vehicle
	if tank != null:
		tank.destroyed = false
		tank.hp = tank.max_hp
		tank.ai_enabled = true
		tank._player_ref = _main.player
		tank.global_position = _main.player.global_position + Vector2(-100.0, 0.0)
		tank.turret_facing = Vector2.RIGHT
		tank._fire_cooldown = 0.0
		# 2026-10-04 第五十九版：默认图换成正式图（235 个遮挡体）之后，随便放个 100 m 外的点
		# **很可能被一栋楼挡住**，坦克就不开炮了 —— 于是「补刀前提」这条会假红。
		# 本条要测的是「开炮 / 不开炮」，不是通视（通视另有专项断言）。这里显式关掉：
		# Vehicle._has_sight_to_player() 在 _sight == null 时返回 true，就是留给测试环境的口子。
		var sight_backup = tank._sight
		tank._sight = null
		var ammo_before: int = tank._ammo
		_restore_player()
		tank._ai_update(0.05)
		var fired_when_alive: bool = tank._ammo < ammo_before
		tank._ammo = ammo_before
		tank._fire_cooldown = 0.0
		_main.player.hp = 0.0
		_main.player.down()
		tank._ai_update(0.05)
		_check_true("补刀前提：站着时坦克会开炮", fired_when_alive)
		if GameConfig.ENEMY_FINISH_OFF_ENABLED:
			_check("补刀开：玩家倒地后坦克照打（会来补刀）", tank._ammo < ammo_before, true)
		else:
			_check("补刀关（🧪 测试态）：玩家倒地后坦克不开炮", tank._ammo, ammo_before)
		tank._sight = sight_backup   # 收尾：把通视还回去，别影响后面的断言
	_main.player.respawn()      # 收尾：让人站起来


# ────────────── 补刀 + 倒地姿势（使用者 2026-10-02 拍板）──────────────

func _check_finish_off_pose() -> void:
	_restore_player()
	var pos: Vector2 = _main.player.global_position   # _main 是鸭子类型，必须显式标类型
	_main.player._visual.set_downed(false)
	_main.player.hp = 0.0
	_main.player.down()
	_check_true("姿势：真场景里倒地也会躺平", _main.player._visual.downed)
	# 补刀 → 阵亡 → MatchFlow 立刻扣预算重生
	_main.match_flow.budget = 2
	_main.match_flow.phase = 0                       # 复位到 PLAYING（前面的 4.16 检查可能已把战局结算掉）
	_main.player.take_damage(1.0)
	if GameConfig.ENEMY_FINISH_OFF_ENABLED:
		_check_true("补刀：被打中一发 → 阵亡 → 立刻复活（不用等 60 s）",
				_main.player.alive and _main.match_flow.budget == 1)
		_check_true("补刀：复活时满血 + 姿势站回 + 换了落点",
				_main.player.hp == GameConfig.SOLDIER_HP
				and not _main.player._visual.downed
				and _main.player.global_position != pos)
	else:
		_check_true("补刀关（🧪 测试态）：倒地期间挨打不掉血、也不扣预算（仍在等 60 s 流血）",
				_main.player.downed and _main.player.alive
				and _main.match_flow.budget == 2)
		_main.player.respawn()
	# 敌人：血打光倒地 → 补刀阵亡
	# 2026-10-04 第五十九版：不能再拿 enemies[0] 就测 —— 前面十几段检查（烟雾 / 载具 / 交战）
	# 可能已经把它打倒了，而 Enemy.take_damage 对**已倒地**的目标是直接 die()（补刀口径），
	# 于是「血打光是倒地」这条会假红。这里挑一个「活着且未倒地」的敌人来测。
	var target_enemy = null
	for node in get_nodes_in_group("enemy"):
		if bool(node.get("alive")) and not bool(node.get("downed")) and node._visual != null:
			target_enemy = node
			break
	_check_true("敌人：场上有「活着且未倒地」的目标可测", target_enemy != null)
	if target_enemy != null:
		target_enemy.take_damage(target_enemy.hp + 1.0)
		_check_true("敌人：血打光是倒地（不是立刻死）",
				target_enemy.downed and target_enemy.alive)
		target_enemy.take_damage(1.0)
		_check_true("敌人：补刀才阵亡", not target_enemy.alive)


# ────────────── 敌方坦克乘员 + 弃车逃生（候选 Q · 使用者 2026-10-02）──────────────

func _check_tank_crew() -> void:
	# 注意：集成脚本**不能**编译期引用 Enemy（它引用 EventBus，会连带整支脚本编译失败）。
	# 所以这里不新建乘员，而是检查真场景里那个开局就配好的乘员（VehicleController.setup 建的）。
	var tank = _main.vehicles.enemy_vehicle
	var crew = _main.get_node_or_null("EnemyTankCrew")
	_check_true("坦克乘员：敌方坦克配了敌人士兵（EnemyTankCrew 在场）", crew != null)
	if crew == null:
		return
	# 前面 _check_atgm 用两发 ATGM 打爆过这辆车（结构值归零 ⇒ 低于弃车阈值）——那时乘员应该已经下车
	_check_true("坦克乘员：ATGM 打爆坦克时乘员已经弃车逃生（车里的乘员清空）",
			tank.crew.is_empty())
	_check_true("坦克乘员：弃车后车停火（没人操炮）", not tank.ai_enabled)
	# 不断言 visible：敌人的 visible 由 4.7 通视系统管（玩家看不到时会自动隐藏），
	# 那不是「弃车失败」的证据。这里只验「它重新成为一个独立的、可被补刀的敌人」。
	_check_true("坦克乘员：弃车的人回到 enemy 组（可被补刀）", crew.is_in_group("enemy"))
	_check_true("坦克乘员：弃车的人自己会走（AI 打开）", crew.ai_enabled)


func _check_vehicle_smoke() -> void:
	var ifv = _main.vehicles.vehicle
	ifv.operator = _main.player            # 人在车里才会走发烟器那条路
	var before: int = get_nodes_in_group(GameConfig.SMOKE_GROUP).size()
	_main.smoke_ctl.vehicle_charges = 1    # 前面的检查可能已用掉配额，给回一次
	_main.smoke_ctl.deploy()
	var smokes := get_nodes_in_group(GameConfig.SMOKE_GROUP)
	_check("载具发烟器：放出一团烟", smokes.size(), before + 1)
	if smokes.size() <= before:
		return
	var smoke = smokes[smokes.size() - 1]
	_check_true("载具发烟器：烟幕绑在车体上（不是固定落点）", smoke.follow == ifv)
	var from: Vector2 = ifv.global_position
	ifv.global_position = from + Vector2(80.0, 0.0)
	smoke._process(0.016)
	_check_true("载具发烟器：车挪 80 m 烟也跟着（真机反馈「烟被留在原地」）",
			is_equal_approx(smoke.global_position.distance_to(ifv.global_position), 0.0))
	ifv.global_position = from
	smoke._process(0.016)
	# 自己在自己放的烟里：旧实现 keep = 0 - offset ⇒ 准心被钳到脚下、拖不动
	_main.player.global_position = smoke.global_position
	var unit_pos: Vector2 = _main.player.global_position
	_main.camera_controller.crosshair_world = unit_pos + Vector2(300.0, 0.0)
	_main.camera_controller._resolve_crosshair()
	_check_true("在烟里：准心不会被钳死在脚下（真机反馈「准心锁死拖不动」）",
			_main.camera_controller.crosshair_world.distance_to(unit_pos) > 1.0)
	smoke.time_left = 0.01
	smoke._process(0.02)


# ────────────── 候选 M 第四轮：12.7.2 载具动画（履带滚动 / 毁伤表现）──────────────
# 纯规则在 test/vehicle_anim_test.gd；这里验「真场景里的图层结构 + 履带真的按位移滚 + 残骸真的在冒烟」。

func _check_vehicle_anim() -> void:
	var vehicles := get_nodes_in_group("vehicle")
	_check("候选 M 12.7.2：场上 2 辆车", vehicles.size(), 2)
	var alive = null
	var wreck = null
	for node in vehicles:
		if bool(node.destroyed):
			wreck = node
		else:
			alive = node
	_check_true("候选 M 12.7.2：一辆在跑 + 一辆已报废（残骸）", alive != null and wreck != null)
	if alive != null:
		_check_true("候选 M 12.7.2：Hull / Turret / Track 三个图层都在",
				alive.get_node_or_null("Hull") != null
				and alive.get_node_or_null("Turret") != null
				and alive.get_node_or_null("Track") != null)
		var phase_before: float = alive.track_phase
		alive.velocity = alive.hull_facing * (alive.max_speed() * 0.5)
		alive._update_track(0.5)
		_check_true("候选 M 12.7.2：跑起来履带相位推进（滚过的距离）",
				alive.track_phase > phase_before)
		alive.velocity = Vector2.ZERO
		alive._update_track(0.5)
		var frozen_phase: float = alive.track_phase
		alive._update_track(0.5)
		_check("候选 M 12.7.2：停车后履带冻结", alive.track_phase, frozen_phase)
	if wreck != null:
		var wreck_phase: float = wreck.track_phase
		wreck._update_track(1.0)
		_check("候选 M 12.7.2：残骸的履带冻结（M-kill 等效）", wreck.track_phase, wreck_phase)
		var smoke = wreck.get_node_or_null("WreckSmoke")
		_check_true("候选 M 12.7.2：残骸持续冒烟（K-kill 等效，WreckSmoke 已挂上）", smoke != null)
		if smoke != null:
			var before: float = smoke.puff_phase(0)
			smoke.tick(0.4)
			_check_true("候选 M 12.7.2：烟团相位在推进（是持续冒烟，不是一锤子）",
					smoke.puff_phase(0) != before)


# ────────────── 候选 M 第三轮：12.7.1 上下半身分离（角色图）──────────────
# 纯规则在 test/figure_test.gd；这里验「真场景里的 Lower / Upper 结构 + 上半身真的跟着准星转」。

func _check_figure() -> void:
	# ① 结构：12.7.1 的原话是「根节点 + Lower / Upper 两个子节点」
	_check_true("候选 M 12.7.1：玩家有 Figure/Lower 与 Figure/Upper",
			_main.player.get_node_or_null("Figure/Lower") != null
			and _main.player.get_node_or_null("Figure/Upper") != null)
	var enemies := get_nodes_in_group("enemy")
	_check_true("候选 M 12.7.1：敌人也是同一套角色图（Lower / Upper）",
			enemies.size() > 0
			and enemies[0].get_node_or_null("Figure/Lower") != null
			and enemies[0].get_node_or_null("Figure/Upper") != null)
	# ② 上半身随准星：准心挪到玩家正北，推一帧 HUD（HudBuilder 每帧把方向推给角色图）
	_main.camera_controller.blocked_by_terrain = false
	_main.camera_controller.crosshair_world = _main.player.global_position + Vector2(0.0, -120.0)
	_main.hud.update_crosshair()
	var upper: Node2D = _main.player.get_node_or_null("Figure/Upper")
	if upper != null:
		_check_true("候选 M 12.7.1：准心在北 → 上半身朝北（Upper.rotation ≈ -π/2）",
				is_equal_approx(upper.rotation, Vector2.UP.angle()))
	# ③ 下半身随移动：驱动一次 tick_timers，Lower 应该朝移动方向，腿的相位也要推进
	var lower: Node2D = _main.player.get_node_or_null("Figure/Lower")
	if lower != null:
		var phase_before: float = _main.player._visual.leg_phase
		_main.player.facing = Vector2.LEFT
		_main.player.velocity = Vector2.LEFT * _main.player.move_speed
		_main.player.tick_timers(0.2)
		_check_true("候选 M 12.7.1：下半身跟随移动方向（LEFT = π）",
				is_equal_approx(lower.rotation, Vector2.LEFT.angle()))
		_check_true("候选 M 12.7.1：走动时腿的相位推进（程序化的「腿交替」）",
				_main.player._visual.leg_phase != phase_before)
		_main.player.velocity = Vector2.ZERO
		_main.player.facing = Vector2.RIGHT


# ────────────── 候选 M 第二轮：基础音效（docx 第十章）──────────────
# 纯规则在 test/audio_test.gd；这里验「autoload 注册了、开火真的把音效送到播放层、事件订阅齐了」。

func _check_audio() -> void:
	var audio := root.get_node_or_null("Audio")
	_check_true("候选 M 10 章：Audio autoload 已注册", audio != null)
	if audio == null:
		return
	# ① 程序生成的 PCM 真的能合成
	var stream = audio.stream_for("shot")
	_check_true("候选 M 10 章：枪声音效能合成（程序生成 PCM）", stream != null)
	_check_true("候选 M 10 章：样本数 > 0",
			preload("res://systems/audio/ProceduralAudio.gd").sample_count(stream) > 0)
	# ② 开火那条真链路把音效送到了播放层（_check_effects 刚开过一枪）
	_check("候选 M 10 章：开火真的建了声部（说明调用点接通了）",
			audio.voice_count("shot"), GameConfig.SFX_MAX_VOICES)
	# ③ 战局音效走事件总线：订阅都在
	var bus := root.get_node_or_null("EventBus")
	_check_true("候选 M 10 章：旗点音效已订阅事件总线",
			bus != null and bus.is_connected("flag_state_changed",
					audio._on_flag_state_changed))
	_check_true("候选 M 10 章：击杀 / 倒地 / 战局结束音效已订阅",
			bus != null and bus.is_connected("enemy_killed", audio._on_enemy_killed)
			and bus.is_connected("player_downed", audio._on_player_downed)
			and bus.is_connected("match_finished", audio._on_match_finished))
	# ④ 关闭开关与限频
	audio.enabled = false
	audio._last_played.clear()
	_check("候选 M 10 章：关掉音频后播不出去", audio.play("shot"), false)
	audio.enabled = true
	_check("候选 M 10 章：未知音效播不出去", audio.play("nope"), false)
	audio._last_played.clear()
	_check_true("候选 M 10 章：打开后能播", audio.play("shot"))
	_check("候选 M 10 章：同一音效立刻重播被限频拦下", audio.play("shot"), false)


# ────────────── 候选 O 第四轮：环境互动区（docx 4.17）──────────────
# 纯规则在 test/terrain_zone_test.gd；这里验「真的建在世界里、真的接进 Player / Enemy」。

func _check_terrain_zones() -> void:
	var zones := get_nodes_in_group(GameConfig.TERRAIN_ZONE_GROUP)
	# 2026-10-04 第五十九版：内容层来自正式图的 material.png（连通域 → 等面积圆），
	# 所以「3 片」这个 demo 摆位数字不再成立 —— 改成「至少 3 片 + 泥 / 雪 / 草三种都有」。
	_check_true("候选 O 4.17：场上有环境互动区（%d 片，来自正式图 material.png）" % zones.size(),
			zones.size() >= 3)
	_check("候选 O 4.17：区域已注入玩家（WorldSetup → player.zones）",
			_main.player.zones.size(), zones.size())

	var grass = null
	var mud = null
	var snow = null
	for zone in zones:
		if int(zone.kind) == 2:
			grass = zone
		elif int(zone.kind) == 0:
			mud = zone
		elif int(zone.kind) == 1:
			snow = zone
	_check_true("候选 O 4.17：泥 / 雪 / 草三种内容层都在场上",
			grass != null and mud != null and snow != null)

	# ① 草丛隐蔽：玩家站进去，敌人的发现距离随之打折
	if grass != null:
		_main.player.global_position = grass.global_position
		_check("候选 O 4.17：站进草丛 → 隐蔽 0.35", _main.player.terrain_concealment(), 0.35)
		var enemy = null
		for node in get_nodes_in_group("enemy"):
			if enemy == null:
				enemy = node
		if enemy != null:
			enemy.detection_range = 60.0
			_check("候选 O 4.17：敌人发现距离按隐蔽打折（60 → 39）",
					enemy.effective_detection_range(),
					60.0 * (1.0 - GameConfig.TERRAIN_GRASS_CONCEAL))

	# ② 泥泞减速：移速档进实际移速
	if mud != null:
		_main.player.global_position = mud.global_position
		_check("候选 O 4.17：站进泥泞 → 移速档 0.70", _main.player.terrain_speed_scale(), 0.70)
		_check_true("候选 O 4.17：实际移速低于基础速度",
				_main.player.effective_move_speed() < _main.player.move_speed)

	# ③ 掩体互动：贴到沙袋上＝缩着（暴露 ×0.5），聚焦＝探头（暴露回满）
	var covers := get_nodes_in_group(GameConfig.OCCLUDER_GROUP)
	_check_true("候选 O 4.17：场上有掩体可贴", covers.size() > 0)
	if covers.size() > 0:
		_main.player.global_position = covers[0].global_position
		_main.player.tick_timers(0.0)
		_check_true("候选 O 4.17：贴到掩体上 → hugging 为真", _main.player.hugging)
		_check("候选 O 4.17：缩在掩体后暴露 ×0.5", _main.player.exposure_scale(), 0.5)
		_main.player.set_focus(true)
		_check("候选 O 4.17：探头（聚焦）暴露回满", _main.player.exposure_scale(), 1.0)
		_main.player.set_focus(false)


# ────────────── 候选 O 第三轮：被击倒时的视角（docx 4.16）──────────────
# 纯逻辑在 test/downed_test.gd；这里验「倒地态 → 相机锁定 → 全屏层 → 超时阵亡」这条真链路。
# 注意：此时前面已经跑过「全占胜利」⇒ Main._on_defeat 会被 _victory 挡掉（设计如此），
# 所以这里不去断言失败结算，而是直接盯 player_died 信号有没有真的发出去。

func _check_downed() -> void:
	if _main.player == null or not is_instance_valid(_main.player):
		_check_true("候选 O 4.16：前置——玩家还在场", false)
		return
	_restore_player()   # 这一项验的是「倒地怎么进」，进来时必须是站着的
	var player = _main.player
	_check_true("候选 O 4.16：倒地前是站着的（倒地是挨打后才进）",
			not player.downed and player.alive)

	# 阵亡信号：自己挂一个探针，避免依赖 Main 的胜负分支
	var died := [false]
	var bus := root.get_node_or_null("EventBus")
	if bus != null:
		bus.connect("player_died", func() -> void: died[0] = true)

	# ① 致死伤害 → 倒地，不立刻阵亡
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	_check_true("候选 O 4.16：血量归零 → 进倒地态（不是直接阵亡）",
			player.downed and player.alive)
	_check("候选 O 4.16：倒地计时 = 60 s 默认值",
			player.downed_time_left, GameConfig.DOWNED_TIMEOUT)
	_check_true("候选 O 4.16：倒地时不能开火", not player.can_fire())

	# ② 相机锁死在倒地身体上（俯视固定、不可拖动）
	_main.camera_controller.crosshair_world = player.global_position + Vector2(300.0, 0.0)
	_main.camera_controller._process(0.0)
	_check_true("候选 O 4.16：相机锁定在倒地身体上（俯视固定）",
			_main.camera_controller.locked_on_unit
			and _main.camera_controller.crosshair_world == player.global_position)

	# ③ 全屏去色 + 暗角 + 倒计时
	_main.hud.tick(0.0)
	_check_true("候选 O 4.16：倒地画面层显示（灰罩 + 暗角）",
			_main.hud.downed_overlay.visible
			and _main.hud.downed_overlay.veil.visible
			and _main.hud.downed_overlay.vignette.visible)
	_check_true("候选 O 4.16：倒计时文案带剩余秒数与「被击倒」",
			_main.hud.downed_overlay.title.text.contains("被击倒")
			and _main.hud.downed_overlay.title.text.contains("60"))
	_check_true("候选 O 4.16：倒地进战斗播报（4.14 联动）",
			_main.hud.feed.feed.to_bbcode().contains("倒地"))

	# ④ 60 s 到点 → 转阵亡（走真实的 _physics_process → die → player_died）
	player.downed_time_left = 0.01
	player._physics_process(0.05)
	# 注意：候选 Q 之后「阵亡」会立刻扣预算重生（有预算时），所以不能再断言 alive == false 这个瞬间；
	# 这里盯的是「阵亡事件真的发生了」——也是这一项原本要保的东西。
	_check_true("候选 O 4.16：倒地超时 → 触发阵亡（player_died；有重生预算时会立刻重生）", died[0])
	_check_true("候选 O 4.16：阵亡后不再处于倒地态", not player.downed)
	_main.hud.tick(0.0)
	_check_true("候选 O 4.16：阵亡后倒地画面层收起",
			not _main.hud.downed_overlay.visible)
	_check_true("候选 O 4.16：阵亡进战斗播报",
			_main.hud.feed.feed.to_bbcode().contains("阵亡"))


# ────────────── 断言工具 ──────────────

func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


# ────────────── ⑩ 炸药 / 工程兵（2026-10-04 使用者拍板）──────────────

## 端到端：工程兵按「爆破」在准心落点放一枚 → 再按一次遥控起爆 → 掩体吃结构值。
## 为什么放最后一段：它会挪玩家、还会当场炸掉一个掩体，不能污染上面那些结算结论。
func _check_explosive() -> void:
	_check_true("爆破键在 HUD 上（(700,340)：3×3 集群与摇杆触摸圈之外）",
			_main.hud.explosive_button != null)
	# 切到工程兵（携带 2 发）
	_main.player_role = RoleTable.Role.ENGINEER
	_main.player.apply_role(_main.player_role)
	_check("工程兵：携带 2 发炸药", _main.explosive_ctl.total(), 2)
	_check("开局满装：剩余 = 携带", _main.explosive_ctl.remaining(), 2)
	# 先钉「超距拒绝」：准心放到 500 m 外，按了必须不消耗、也不放
	_main.camera_controller.crosshair_world = _main.player.global_position + Vector2(500.0, 0.0)
	_main.explosive_ctl.toggle()
	_check_true("超距（500 m）拒绝放置：没有待爆药", not _main.explosive_ctl.is_armed())
	_check("超距拒绝不消耗发数", _main.explosive_ctl.remaining(), 2)
	# 找一个还完好的掩体，把玩家挪到它旁边、准心对准它
	var cover = null
	for node in get_nodes_in_group("occluder"):
		if not bool(node.get("destroyed")):
			cover = node
			break
	if cover == null:
		_check_true("场上有可用的掩体可炸", false)
		return
	_main.player.global_position = (cover as Node2D).global_position + Vector2(5.0, 0.0)
	_main.camera_controller.crosshair_world = (cover as Node2D).global_position
	var hp_before := float(cover.get("hp"))
	_main.explosive_ctl.toggle()          # 在准心落点放
	_check_true("工程兵：在准心落点放下一枚", _main.explosive_ctl.is_armed())
	_check("放置消耗 1 发（2 → 1）", _main.explosive_ctl.remaining(), 1)
	_main.explosive_ctl.toggle()          # 遥控起爆
	_check_true("遥控起爆：掩体吃到结构值（或直接摧毁）",
			bool(cover.get("destroyed")) or float(cover.get("hp")) < hp_before)
	_check_true("起爆后没有残留待爆药", not _main.explosive_ctl.is_armed())
	_check("起爆本身不再消耗发数（剩余仍是 1）", _main.explosive_ctl.remaining(), 1)
	# 收尾：切回步枪兵 —— 别让后面的检查读到工程兵（换武器 / 携带量都不同）
	_main.player_role = RoleTable.Role.RIFLEMAN
	_main.player.apply_role(_main.player_role)


# ────────────── 地图数据只读助手（2026-10-04 第五十九版）──────────────
# 为什么让测试自己去数地图文件：默认地图换成正式图之后，「场上 20 个沙袋」这类写死的数字
# 就变成了一张随时会过期的照片。改成「照地图数据核对」，地图重做一次测试自动跟上。

## 数一张地图目录里的 occluders.json 条目（不校验 schema —— schema 归插件侧 JieyuMapChecks）
func _count_map_occluders(height_image_path: String) -> int:
	var map_id := height_image_path.get_base_dir().get_file()
	var path := "res://assets/maps/%s/occluders.json" % map_id
	if map_id.is_empty() or not FileAccess.file_exists(path):
		return 0
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return 0
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	return (parsed as Array).size() if parsed is Array else 0


## 地图 zones.json 的出生区多边形（side = "west" / "east"），返回 Vector2 数组
func _map_spawn_polygon(height_image_path: String, side: String) -> Array:
	var zones := _map_zones(height_image_path)
	for area_v in zones.get("spawn_areas", []):
		if area_v is Dictionary and String((area_v as Dictionary).get("side", "")) == side:
			var result: Array = []
			for raw in (area_v as Dictionary).get("polygon", []):
				result.append(Vector2(float(raw[0]), float(raw[1])))
			return result
	return []


## 地图 zones.json 解析结果（读不到返回空字典）
func _map_zones(height_image_path: String) -> Dictionary:
	var map_id := height_image_path.get_base_dir().get_file()
	var path := "res://assets/maps/%s/zones.json" % map_id
	if map_id.is_empty() or not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	return parsed if parsed is Dictionary else {}


## 下面的出生点断言刻意自己实现（不用 SpawnPicker 的方法自证自己）：
## 射线法内外判定 · 双尺度坡度 · 点与遮挡体矩形的距离。
func _point_in_polygon(polygon: Array, point: Vector2) -> bool:
	var inside := false
	var count := polygon.size()
	var j := count - 1
	for i in count:
		var a: Vector2 = polygon[i]
		var b: Vector2 = polygon[j]
		if ((a.y > point.y) != (b.y > point.y)) \
				and point.x < (b.x - a.x) * (point.y - a.y) / maxf(b.y - a.y, 0.00001) + a.x:
			inside = not inside
		j = i
	return inside


func _spawn_slope_ok(point: Vector2) -> bool:
	for step in [8, 4]:
		var here: Vector2i = _main.grid.world_to_cell(point)
		var lateral: Vector2i = _main.grid.world_to_cell(point + Vector2(float(step), 0.0))
		var down: Vector2i = _main.grid.world_to_cell(point + Vector2(0.0, float(step)))
		if maxf(_main.grid.slope_deg(here, lateral), _main.grid.slope_deg(here, down)) \
				> GameConfig.MAX_SLOPE_DEG:
			return false
	return true


func _cover_distance(point: Vector2) -> float:
	var best := 99.0
	for entry in _main.map_occluders:
		var polygon: Array = (entry as Dictionary).get("polygon", [])
		if polygon.size() < 3:
			continue
		best = minf(best, _rect_distance(polygon, point))
	return best


func _rect_distance(polygon: Array, point: Vector2) -> float:
	var min_x := INF
	var max_x := -INF
	var min_y := INF
	var max_y := -INF
	for raw in polygon:
		min_x = minf(min_x, float(raw[0]))
		max_x = maxf(max_x, float(raw[0]))
		min_y = minf(min_y, float(raw[1]))
		max_y = maxf(max_y, float(raw[1]))
	if point.x >= min_x and point.x <= max_x and point.y >= min_y and point.y <= max_y:
		return 0.0
	var dx := maxf(maxf(min_x - point.x, 0.0), point.x - max_x)
	var dy := maxf(maxf(min_y - point.y, 0.0), point.y - max_y)
	return sqrt(dx * dx + dy * dy)


func _nearest_distance(point: Vector2, points: Array) -> float:
	var best := 9999.0
	for other in points:
		best = minf(best, point.distance_to(other))
	return best


## 地图 zones.json 的 raas_nodes 坐标（按推进链顺序）
func _map_node_positions(height_image_path: String) -> Array:
	var map_id := height_image_path.get_base_dir().get_file()
	var path := "res://assets/maps/%s/zones.json" % map_id
	if map_id.is_empty() or not FileAccess.file_exists(path):
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		return []
	var result: Array = []
	for node_v in (parsed as Dictionary).get("raas_nodes", []):
		if node_v is Dictionary:
			var pos: Array = (node_v as Dictionary).get("pos", [0, 0])
			result.append(Vector2(float(pos[0]), float(pos[1])))
	return result
