@tool
extends EditorScript

## 弹道测试（不需要场景）：300m 打低、下坠单调、命中敌人、打地
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_drop_at_300m()
	_test_drop_monotonic()
	_test_hit_enemy()
	_test_range_cutoff()
	_test_ammo_and_cooldown()
	_test_spread_scales()
	_test_spread_scale_is_realistic()
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


func _test_drop_at_300m() -> void:
	var points := BallisticsSystem.simulate(300.0, GameConfig.MUZZLE_VELOCITY)
	var last: Dictionary = points[points.size() - 1]
	_check_true("300m 处下坠 > 1m（打低）", last["drop"] > 1.0)
	_check_true("300m 处下坠 < 20m（不是垂直坠落）", last["drop"] < 20.0)


func _test_drop_monotonic() -> void:
	var points := BallisticsSystem.simulate(300.0, GameConfig.MUZZLE_VELOCITY)
	var monotonic := true
	for i in range(1, points.size()):
		if points[i]["drop"] < points[i - 1]["drop"] - 0.0001:
			monotonic = false
			break
	_check_true("下坠量单调递增", monotonic)


func _test_hit_enemy() -> void:
	var enemy := Node2D.new()
	enemy.position = Vector2(10.0, 0.0)
	var result := BallisticsSystem.resolve_shot(
			Vector2.ZERO, Vector2.RIGHT, GameConfig.WEAPON_MAX_RANGE, [enemy])
	_check_true("命中：10m 处敌人被击中", result["hit"])
	_check_true("命中：距离正确", result["distance"] > 9.0 and result["distance"] < 11.0)
	enemy.free()


func _test_range_cutoff() -> void:
	# 敌人远在射程（400m）之外：直瞄射线飞满射程截断、不命中（docx 第十八章直瞄口径）
	var enemy := Node2D.new()
	enemy.position = Vector2(500.0, 0.0)
	var result := BallisticsSystem.resolve_shot(
			Vector2.ZERO, Vector2.RIGHT, GameConfig.WEAPON_MAX_RANGE, [enemy])
	_check_true("射程截断：400m 外敌人打不到", not result["hit"])
	_check_true("射程截断：飞满 max_range", result["distance"] == GameConfig.WEAPON_MAX_RANGE)
	enemy.free()


func _test_ammo_and_cooldown() -> void:
	var player := PlayerUnit.new()
	var initial_mag := player.ammo_in_mag
	var result := player.shoot(Vector2.RIGHT, [])
	_check_true("开火消耗一发", player.ammo_in_mag == initial_mag - 1)
	_check_true("开火后进入射速冷却（can_fire=false）", not player.can_fire())
	_check_true("开火结果带 fired=true", result.get("fired", false) == true)
	player.free()


## 散布动静二分 + 聚焦（第十八章「步兵武器操纵性」确认稿）
func _test_spread_scales() -> void:
	var player := PlayerUnit.new()
	player.is_moving = false
	_check("站定散布 = 基础 MOA", player.effective_spread_moa(), GameConfig.WEAPON_MOA)
	player.is_moving = true
	_check("移动散布 = 基础 × 移动倍率", player.effective_spread_moa(),
			GameConfig.WEAPON_MOA * GameConfig.WEAPON_SPREAD_MOVE)
	_check_true("移动散布 > 站定散布", player.effective_spread_moa() > GameConfig.WEAPON_MOA)
	player.set_focus(true)
	_check("移动+聚焦散布 = 移动 × 聚焦倍率", player.effective_spread_moa(),
			GameConfig.WEAPON_MOA * GameConfig.WEAPON_SPREAD_MOVE * GameConfig.FOCUS_SPREAD_SCALE)
	player.is_moving = false
	_check("站定+聚焦散布 = 最小散布", player.effective_spread_moa(),
			GameConfig.WEAPON_MOA * GameConfig.FOCUS_SPREAD_SCALE)
	_check_true("聚焦标志位 = true", player.focusing)
	player.set_focus(false)
	_check_true("退出聚焦后标志位 = false", not player.focusing)
	player.free()


## 散布设计口径（docx 7.2/7.5 的现实值 3 MOA）：近距指哪打哪，远距才需点射与估距。
## 这条断言是防「为了手感明显而放大 MOA」的回头路——2026-09-28 放大到 6 MOA 又改回
func _test_spread_scale_is_realistic() -> void:
	var spread_rad := deg_to_rad(GameConfig.WEAPON_MOA / 60.0)
	var offset_100 := tan(spread_rad) * 100.0
	var offset_300 := tan(spread_rad) * 300.0
	_check_true("散布：100 m 偏移 %.2f m 明显小于命中半径 %.2f m（近距指哪打哪）"
			% [offset_100, GameConfig.ENEMY_HIT_RADIUS],
			offset_100 < GameConfig.ENEMY_HIT_RADIUS * 0.5)
	_check_true("散布：300 m 偏移 %.2f m 已达命中半径量级（远距要靠点射/估距）"
			% offset_300, offset_300 > GameConfig.ENEMY_HIT_RADIUS * 0.8)
