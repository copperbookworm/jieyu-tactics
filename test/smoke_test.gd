@tool
extends EditorScript

## 烟雾遮蔽测试（docx 4.12 + 4.12.8 确认稿，候选 P）
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 说明：SightSystem.smoke_blocks() 取烟走 Engine.get_main_loop() 的组查询，
## 编辑器 / 批跑脚本里那个组是空的 —— 所以这里测「几何 + 高度规则 + 计时 + 盲射命中率」这些纯函数，
## 「投烟真的把敌方通视判黑」跑在集成冒烟里（res://tools/run_integration_headless.gd）。

const SmokeScreenScript := preload("res://entities/smoke/SmokeScreen.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_confirmed_params()
	_test_segment_entry()
	_test_inside_and_miss()
	_test_height_rule()
	_test_lifetime()
	_test_blind_fire_scale()
	_test_vehicle_smoke_follows()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


## 载具发烟器：烟幕跟着车走（2026-10-02 真机修 —— 以前提示写着「跟着车走」，实际是个固定落点）
func _test_vehicle_smoke_follows() -> void:
	var vehicle := Node2D.new()
	vehicle.position = Vector2(10.0, 20.0)
	var smoke = SmokeScreenScript.new()
	smoke.setup(vehicle.position, vehicle)
	_check("发烟器：落点就是车的位置", smoke.global_position, vehicle.position)
	vehicle.position = Vector2(60.0, -30.0)
	smoke._process(0.1)
	_check("发烟器：车开走了烟跟着走", smoke.global_position, vehicle.position)
	var grenade = SmokeScreenScript.new()
	grenade.setup(Vector2(5.0, 5.0))
	grenade._process(0.1)
	_check("步兵烟雾弹：没有跟随对象就固定死在落点",
			grenade.global_position, Vector2(5.0, 5.0))
	smoke.free()
	grenade.free()
	vehicle.free()


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


## 4.12.8 确认稿五项参数：半径 10 / 高 3 / 25 s / 触发即生效 / 盲射 −70%
func _test_confirmed_params() -> void:
	_check("4.12.8 ①：单发覆盖半径 10 m", GameConfig.SMOKE_RADIUS, 10.0)
	_check("4.12.8 ②：烟雾高度 3 m（遮坦克 2.5~3 m 观察高）", GameConfig.SMOKE_HEIGHT, 3.0)
	_check("4.12.8 ③：持续 25 s", GameConfig.SMOKE_DURATION, 25.0)
	_check("4.12.8 ④：盲射命中率倍率 0.3（＝下降 70%）",
			GameConfig.SMOKE_BLIND_FIRE_HIT_SCALE, 0.3)
	# 4.12.6：只挡视线不挡子弹 —— 所以烟不能进掩体组（那个组同时喂给子弹截断 first_cover）
	_check_true("4.12.6：烟雾走独立分组，不进 occluder 组",
			GameConfig.SMOKE_GROUP != GameConfig.OCCLUDER_GROUP)


## 几何：线段与烟饼圆的入射点（正穿圆心应落在圆上，不是圆心）
func _test_segment_entry() -> void:
	var smoke = SmokeScreenScript.new()
	smoke.position = Vector2.ZERO
	var hit: Vector2 = smoke.segment_crossing(Vector2(-100.0, 0.0), Vector2(100.0, 0.0))
	_check_true("几何：正穿烟饼有入射点", hit != Vector2.INF)
	_check("几何：入射点在圆周（x = -10）", hit.x, -GameConfig.SMOKE_RADIUS)
	_check("几何：入射点在中线上（y = 0）", hit.y, 0.0)

	# 擦过直径外 1 m 的平行线：不挡
	var near_miss: Vector2 = smoke.segment_crossing(Vector2(-100.0, 11.0), Vector2(100.0, 11.0))
	_check("几何：离圆心 11 m 的平行线不穿烟（半径 10）", near_miss, Vector2.INF)
	var graze: Vector2 = smoke.segment_crossing(Vector2(-100.0, 9.0), Vector2(100.0, 9.0))
	_check_true("几何：离圆心 9 m 的平行线算穿烟", graze != Vector2.INF)

	# 反向也要成立（判定不分方向：谁看谁都一样）
	var back: Vector2 = smoke.segment_crossing(Vector2(100.0, 0.0), Vector2(-100.0, 0.0))
	_check("几何：反向入射点在另一侧（x = +10）", back.x, GameConfig.SMOKE_RADIUS)

	# 线段没伸到烟饼就结束：不挡
	var short_seg: Vector2 = smoke.segment_crossing(Vector2(-100.0, 0.0), Vector2(-50.0, 0.0))
	_check("几何：线段没够到烟饼就不算穿烟", short_seg, Vector2.INF)
	smoke.free()


## 起点已在烟里（从烟内往外看）应返回起点本身
func _test_inside_and_miss() -> void:
	var smoke = SmokeScreenScript.new()
	smoke.position = Vector2(200.0, 200.0)
	var from_inside := Vector2(205.0, 200.0)
	var hit: Vector2 = smoke.segment_crossing(from_inside, Vector2(300.0, 200.0))
	_check("几何：起点在烟内时返回起点本身", hit, from_inside)
	# 零长线段：起点在圆内 → 起点；圆外 → INF
	_check("几何：零长线段在烟外 → 无交点",
			smoke.segment_crossing(Vector2(300.0, 300.0), Vector2(300.0, 300.0)), Vector2.INF)
	smoke.free()


## 高度规则（与掩体同一套）：低于烟顶挡、高于烟顶不挡 —— 飞机 / 高处仍可越过（4.12.2）
func _test_height_rule() -> void:
	var ground := 12.0
	var smoke = SmokeScreenScript.new()
	_check("烟顶高 = 地面高 + 烟高", smoke.top_height_at(ground),
			ground + GameConfig.SMOKE_HEIGHT)
	var stand_eye := ground + GameConfig.SOLDIER_EYE_HEIGHT   # 1.6 m 眼高
	_check("步兵眼高（1.6 m）低于烟顶 → 判被遮挡",
			SightSystem.blocks_sight(stand_eye, smoke.top_height_at(ground)), true)
	var tank_glass := ground + 3.0                            # 坦克车长 / 炮手镜 2.5~3 m
	_check("坦克观察高（3.0 m）不算高过烟顶 → 同样被遮挡",
			SightSystem.blocks_sight(tank_glass, smoke.top_height_at(ground)), true)
	var aircraft := ground + 20.0                             # 高处单位
	_check("高处单位（20 m）越过烟顶 → 不被遮挡",
			SightSystem.blocks_sight(aircraft, smoke.top_height_at(ground)), false)
	smoke.free()


## 时效：25 s 前还活着、25 s 后散尽（触发即生效，所以刚放下就是活的）
func _test_lifetime() -> void:
	var smoke = SmokeScreenScript.new()
	_check("时效：刚放下的烟就是活的（触发即生效）", smoke.is_active(), true)
	_check("时效：刚放下寿命比例 = 1", smoke.life_ratio(), 1.0)
	smoke.time_left = 0.2
	_check_true("时效：还剩 0.2 s 仍算活着", smoke.is_active())
	smoke.time_left = 0.0
	_check("时效：时间归零即散尽", smoke.is_active(), false)
	_check("时效：散尽后寿命比例 = 0", smoke.life_ratio(), 0.0)
	# 直接推 25 s（一帧推完，省得循环）
	smoke.time_left = GameConfig.SMOKE_DURATION
	smoke._process(GameConfig.SMOKE_DURATION - 0.5)
	_check_true("时效：24.5 s 时还在（25 s 寿命）", smoke.is_active())
	smoke.free()

	# 散尽那一帧：发 expired 信号
	var expiring = SmokeScreenScript.new()
	var fired := [0]
	expiring.expired.connect(func(_s): fired[0] += 1)
	expiring._process(GameConfig.SMOKE_DURATION + 0.1)
	_check("时效：到点发出 expired 信号", fired[0], 1)
	_check("时效：到点后不再活着", expiring.is_active(), false)


## 4.12.5 / 4.12.8 ④：盲射命中率 −70%
func _test_blind_fire_scale() -> void:
	_check("盲射：抽到 0.0（≤ 0.3）保留命中",
			SmokeScreenScript.keeps_blind_hit(0.0), true)
	_check("盲射：抽到 0.29 保留命中", SmokeScreenScript.keeps_blind_hit(0.29), true)
	_check("盲射：抽到 0.3 保留命中（闭区间）",
			SmokeScreenScript.keeps_blind_hit(0.30), true)
	_check("盲射：抽到 0.31 打成未命中", SmokeScreenScript.keeps_blind_hit(0.31), false)
	_check("盲射：抽到 0.99 打成未命中", SmokeScreenScript.keeps_blind_hit(0.99), false)
