@tool
extends EditorScript

## 掩体层测试（docx 4.7 第③级检测 / C2 矮掩体与架枪依托）
## 运行：脚本编辑器打开本文件 → 文件 → 运行
## 说明：SightSystem 取掩体走 Engine.get_main_loop()，编辑器脚本里那个组是空的，
## 所以这里测「几何求交 + 高度规则 + 依托距离」这些纯函数，场景内效果靠真机验收。

const CoverScript := preload("res://entities/cover/Cover.gd")

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_segment_hit()
	_test_distance_to_edge()
	_test_top_height()
	_test_blocks_sight_rule()
	_test_rotated_hit()
	_test_destroy_removes_blocking()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _make_cover():
	var cover = CoverScript.new()
	cover.half_size = Vector2(4.0, 1.0)
	cover.position = Vector2(100.0, 100.0)
	return cover


func _test_segment_hit() -> void:
	var cover = _make_cover()
	var hit: Vector2 = cover.segment_hit(Vector2(80.0, 100.0), Vector2(120.0, 100.0))
	_check_true("掩体：横穿矩形的线段有交点", hit != Vector2.INF)
	_check("掩体：交点落在矩形左边缘 x = 96", hit.x, 96.0)
	_check("掩体：交点 y 在矩形中线上", hit.y, 100.0)
	var miss: Vector2 = cover.segment_hit(Vector2(80.0, 120.0), Vector2(120.0, 120.0))
	_check("掩体：绕过去的线段无交点", miss, Vector2.INF)
	cover.free()


func _test_distance_to_edge() -> void:
	var cover = _make_cover()
	_check("依托距离：矩形内部算 0", cover.distance_to_edge(Vector2(101.0, 100.0)), 0.0)
	_check("依托距离：正东 1 m 处 = 1", cover.distance_to_edge(Vector2(105.0, 100.0)), 1.0)
	_check_true("依托距离：1 m 在依托范围内（≤ SUPPORT_RANGE）",
			cover.distance_to_edge(Vector2(105.0, 100.0)) <= GameConfig.SUPPORT_RANGE)
	_check_true("依托距离：10 m 不在依托范围内",
			cover.distance_to_edge(Vector2(114.0, 100.0)) > GameConfig.SUPPORT_RANGE)
	cover.free()


func _test_top_height() -> void:
	var cover = _make_cover()
	cover.height = GameConfig.COVER_SANDBAG_HEIGHT
	_check("掩体顶高 = 地面高 + 掩体高", cover.top_height_at(10.0),
			10.0 + GameConfig.COVER_SANDBAG_HEIGHT)
	cover.free()


## C2「矮掩体」的核心：站着能看过沙袋，趴下就看不出去
func _test_blocks_sight_rule() -> void:
	var ground := 10.0
	var top := ground + GameConfig.COVER_SANDBAG_HEIGHT
	var stand_eye := ground + GameConfig.SOLDIER_EYE_HEIGHT
	var prone_eye := ground + GameConfig.PRONE_SIGHT_HEIGHT
	_check("高度规则：站姿眼高能越过沙袋", SightSystem.blocks_sight(stand_eye, top), false)
	_check("高度规则：卧姿视线被沙袋挡住", SightSystem.blocks_sight(prone_eye, top), true)
	# C2 矮掩体的判据是「卧姿视线低于掩体顶（看不出去）+ 站姿眼高高于掩体顶（看得过去）」。
	# 原来写成 PRONE_SIGHT_HEIGHT < SOLDIER_EYE_HEIGHT - COVER_SANDBAG_HEIGHT（0.6 < 0.5）是笔误：
	# 那是「站姿越过掩体后的余量」，不是「卧姿比站姿低」（2026-09-30 修）。
	_check_true("高度规则：卧姿视线低于沙袋顶、站姿眼高高于沙袋顶",
			GameConfig.PRONE_SIGHT_HEIGHT < GameConfig.COVER_SANDBAG_HEIGHT
			and GameConfig.COVER_SANDBAG_HEIGHT < GameConfig.SOLDIER_EYE_HEIGHT)


## 旋转支持：同一根线在轴对齐时不挡、转 90° 后挡住（长边转向南北）
func _test_rotated_hit() -> void:
	var cover = CoverScript.new()
	cover.half_size = Vector2(4.0, 1.0)
	cover.position = Vector2(100.0, 100.0)
	var from := Vector2(95.0, 102.0)
	var to := Vector2(105.0, 102.0)
	_check("旋转前：偏离中心 2 m 的横线无交点", cover.segment_hit(from, to), Vector2.INF)
	cover.rotation = PI * 0.5
	_check_true("旋转 90° 后：同一条线被挡住（矩形转向南北）",
			cover.segment_hit(from, to) != Vector2.INF)
	_check("旋转 90° 后：点 (100, 102.5) 落在矩形内 → 距离 0",
			cover.distance_to_edge(Vector2(100.0, 102.5)), 0.0)
	cover.free()


## 可破坏：打到一半还在挡，打光耐久后标记摧毁（并退出 occluder 组）
func _test_destroy_removes_blocking() -> void:
	var cover = CoverScript.new()
	_check_true("摧毁前：耐久满", cover.health_ratio() > 0.99)
	cover.take_damage(GameConfig.COVER_HP * 0.5)
	_check("受损一半：耐久比 = 0.5", snappedf(cover.health_ratio(), 0.01), 0.5)
	_check("受损一半：还没破", cover.is_destroyed(), false)
	cover.take_damage(GameConfig.COVER_HP)
	_check("打光耐久：标记为已摧毁", cover.is_destroyed(), true)
	cover.take_damage(1000.0)
	_check("已摧毁后再挨打：耐久不会变成负数", cover.health_ratio(), 0.0)
	cover.free()
