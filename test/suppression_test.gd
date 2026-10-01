@tool
extends EditorScript

## 压制机制测试（docx 7.3）：近失因子、累积上限、衰减、散布恶化
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_near_miss_factor()
	_test_accumulate_and_clamp()
	_test_decay()
	_test_spread_worsens()
	_test_ai_return_fire_degrades()
	_test_enemy_suppression()
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


## 近失因子：正对 = 1、擦过打折、超半径 = 0、背向 = 0
func _test_near_miss_factor() -> void:
	var origin := Vector2.ZERO
	var direction := Vector2.RIGHT
	_check("近失：弹道正对目标 = 1.0（满贴近）",
			SuppressionSystem.near_miss_factor(origin, direction, Vector2(50.0, 0.0)), 1.0)
	var grazing := SuppressionSystem.near_miss_factor(origin, direction,
			Vector2(50.0, GameConfig.SUPPRESSION_NEAR_MISS_RADIUS * 0.5))
	_check_true("近失：擦过半径一半 = 0.5", is_equal_approx(grazing, 0.5))
	_check("近失：超出半径 = 0",
			SuppressionSystem.near_miss_factor(origin, direction,
					Vector2(50.0, GameConfig.SUPPRESSION_NEAR_MISS_RADIUS + 1.0)), 0.0)
	_check("近失：背向目标 = 0（背后开枪不压自己）",
			SuppressionSystem.near_miss_factor(origin, direction, Vector2(-50.0, 0.0)), 0.0)


func _test_accumulate_and_clamp() -> void:
	var player := PlayerUnit.new()
	player.add_suppression(0.4)
	_check("累积：一发 0.4", player.suppression, 0.4)
	player.add_suppression(0.9)
	_check("累积：上限夹到 1.0", player.suppression, 1.0)
	player.add_suppression(0.0)
	_check("累积：加 0 不改变", player.suppression, 1.0)
	player.free()


func _test_decay() -> void:
	var player := PlayerUnit.new()
	player.add_suppression(1.0)
	var after_2s := SuppressionSystem.decayed(player.suppression, 2.0)
	_check("衰减：2 s 后 = 1 - 0.25×2",
			after_2s, 1.0 - GameConfig.SUPPRESSION_DECAY * 2.0)
	_check("衰减：时间足够长归零",
			SuppressionSystem.decayed(after_2s, 10.0), 0.0)
	player.free()


func _test_spread_worsens() -> void:
	var player := PlayerUnit.new()
	var base := player.effective_spread_moa()
	player.add_suppression(1.0)
	var worst := player.effective_spread_moa()
	_check("散布：满压制 = 基础 × (1 + SUPPRESSION_SPREAD_SCALE)", worst,
			base * (1.0 + GameConfig.SUPPRESSION_SPREAD_SCALE))
	_check_true("散布：被压制后确实变差", worst > base)
	player.free()


## 反向：压制让敌人的还击变散、压制够重就不敢露头（docx 7.3 反向）
func _test_ai_return_fire_degrades() -> void:
	_check("反压制：敌人无压制时零散布（直射）",
			SuppressionSystem.return_fire_spread_deg(0.0), 0.0)
	_check("反压制：满压制时还击散布 = 上限",
			SuppressionSystem.return_fire_spread_deg(1.0),
			GameConfig.SUPPRESSION_AI_SPREAD_DEG)
	var half := SuppressionSystem.return_fire_spread_deg(0.5)
	_check_true("反压制：散布随压制上升", half > 0.0
			and half < GameConfig.SUPPRESSION_AI_SPREAD_DEG)
	_check("反压制：低于阈值照常还击", SuppressionSystem.holds_fire(
			GameConfig.SUPPRESSION_AI_HOLD_FIRE - 0.01), false)
	_check("反压制：达到阈值就不敢露头", SuppressionSystem.holds_fire(
			GameConfig.SUPPRESSION_AI_HOLD_FIRE), true)


## 敌人自己的压制值：与玩家同一套累积 + 衰减
func _test_enemy_suppression() -> void:
	var enemy := Enemy.new()
	enemy.add_suppression(0.5)
	_check("敌人累积压制：0.5", enemy.suppression, 0.5)
	enemy.add_suppression(1.0)
	_check("敌人累积压制：上限夹到 1.0", enemy.suppression, 1.0)
	_check("敌人压制：4 s 后衰减归零（0.25/s）",
			SuppressionSystem.decayed(enemy.suppression, 4.0), 0.0)
	enemy.free()
