extends SceneTree

## 无编辑器集成冒烟（2026-09-30 候选 N 加）
##
## 与 tools/run_tests_headless.gd 的分工：
##   · run_tests_headless.gd  跑 test/ 下 16 个纯逻辑 @tool 测试（不建场景）
##   · 本脚本                 真把 Main.tscn 实例化起来跑一遍，断言「装配关系 + 五条交互链」没被拆坏：
##                           战术地图开合（含 2026-09-28「关图后摇杆永久锁死」回归点）、
##                           载具（上车/换座/操炮塔/开炮/下车）、报点标记链、
##                           兵种·姿态·换枪·聚焦、开火曳光、血量/分数标签、
##                           提示超时消失、三个节点全占 → 胜利结算（走真实 flag_state_changed 链路）。
##
## 用法：godot --headless --path . --log-file <工作区内可写路径> --script res://tools/run_integration_headless.gd
## 退出码：0 = 全绿，1 = 有失败。
##
## ⚠ 本脚本的两条硬约束（都是 --script 模式的既有脾性，不是项目的锅）：
##   ① 本脚本的编译早于 autoload 注册 ⇒ 不能写 EventBus.xxx，也不能在编译期引用
##      CaptureZone / Player / Enemy / AimCameraController（它们用了 EventBus 全局名，
##      一旦在这里当依赖被拉进来编译失败还会被缓存，占领/任务链会跟着全废）。
##      要碰这些只能运行时按名字取（例如 EventBus 用 root.get_node_or_null）。
##   ② 手动实例化的场景不会自动成为 current_scene ⇒ 必须自己设，否则 Enemy 开火画曳光会炸。

const SETTLE_SECONDS := 1.0      # 先跑 1 s 让相机/玩家/节点进入稳定状态
const LATE_SECONDS := 2.5        # 再跑一会儿：覆盖「报点提示 1.6 s 自动消失」
const VICTORY_FRAMES := 10       # 让 CaptureZone._process 自己翻蓝并广播

var _main = null
var _phase := 0
var _elapsed := 0.0
var _frames := 0
var _passed := 0
var _failed := 0


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
				_check_structure()
				_check_interactions()
				_phase = 1
				_elapsed = 0.0
		1:
			if _elapsed >= LATE_SECONDS:
				_check_late()
				_arm_victory()
				_phase = 2
				_frames = 0
		2:
			if _frames >= VICTORY_FRAMES:
				_check_victory()
				print("—— 集成冒烟：通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
				if _failed > 0:
					print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)
				quit(1 if _failed > 0 else 0)
				return true
	return false


# ────────────── ① 装配关系（拆分没把场景树挪错地方）──────────────

func _check_structure() -> void:
	_check_true("Main 已 _ready：玩家 / 地形网格 / 相机控制器都在",
			_main.player != null and _main.grid != null and _main.camera_controller != null)
	_check_true("四个子模块都建好了",
			_main.world != null and _main.vehicles != null
			and _main.mark_ctl != null and _main.hud != null)
	_check_true("子模块都挂在 Main 下",
			_main.world.get_parent() == _main and _main.vehicles.get_parent() == _main
			and _main.mark_ctl.get_parent() == _main and _main.hud.get_parent() == _main)
	_check_true("实体仍挂在 Main 下（不是挂在模块下）",
			_main.get_node_or_null("Terrain") != null
			and _main.get_node_or_null("Player") != null
			and _main.get_node_or_null("Camera") != null
			and _main.get_node_or_null("AimCameraController") != null
			and _main.get_node_or_null("Vehicle") != null
			and _main.get_node_or_null("EnemyVehicle") != null)
	_check("占领节点 3 个", _main.capture_zones.size(), 3)
	# 掩体 = DEMO_NODES（5 个节点）× 每点 4 个沙袋 = 20（见 MapGenerator.demo_cover_points）
	_check("掩体 20 个（5 个节点 × 4）", get_nodes_in_group("occluder").size(), 20)
	_check("敌人 2 个", get_nodes_in_group("enemy").size(), 2)
	_check("载具 2 辆（我方 + 敌方 AI）", get_nodes_in_group("vehicle").size(), 2)
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
			and _main.hud.seat_button != null
	_check_true("HUD 控件齐全（15 个）", controls_ok)
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
	_check("武器位开炮：消耗一发", v.ammo(), ammo_before - 1)
	_main.vehicles.toggle()
	_check_true("下车：按钮回到「上车」", not v.is_occupied()
			and _main.hud.vehicle_button.text == "上车")

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
	_main._on_fire()
	_check_true("步兵开火：画了一条曳光（Main 子节点 +1）",
			_main.get_child_count() > children_before)
	_main.player.take_damage(25.0)

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


# ────────────── ③ 需要等一会儿的（提示超时 / 标签跟随）──────────────

func _check_late() -> void:
	_check("报点提示 1.6 s 后自动消失", _main.hud.mark_hint.text, "")
	_check_true("血量标签跟随玩家（血量 %d）" % int(_main.player.hp),
			_main.hud.hp_label.text.begins_with("血量 %d" % int(_main.player.hp)))


## 全占胜利：不去直接改 state，而是把进度推到「容差吸附」区间，让 CaptureZone._process
## 自己翻蓝并广播 flag_state_changed —— 走的就是真机那条链路。
func _arm_victory() -> void:
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
