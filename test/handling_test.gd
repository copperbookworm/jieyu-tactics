@tool
extends EditorScript

## 射击手感测试（docx 7.3 连发扩大/点射收敛 · C2 姿态 · C3 姿势精度）
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_burst_grows()
	_test_burst_caps_and_decays()
	_test_posture_spread()
	_test_posture_hit_scale()
	_test_posture_switch_time()
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


## 打一发（绕开冷却与弹药，只走 shoot 里的连发计数路径）
func _fire_once(player: PlayerUnit) -> void:
	player.ammo_in_mag = 10
	player._fire_cooldown = 0.0
	player.shoot(Vector2.RIGHT, [])


func _test_burst_grows() -> void:
	var player := PlayerUnit.new()
	_check("连发：第 1 发 ×1.0", player.burst_spread_multiplier(), 1.0)
	_fire_once(player)
	_check("连发：开火后仍 ×1.0（第 1 发不算惩罚）", player.burst_spread_multiplier(), 1.0)
	_fire_once(player)
	_check("连发：第 2 发 = 1 + 0.12", player.burst_spread_multiplier(),
			1.0 + GameConfig.BURST_SPREAD_PER_SHOT)
	_check("连发：散布确实变大", player.effective_spread_moa(),
			GameConfig.WEAPON_MOA * (1.0 + GameConfig.BURST_SPREAD_PER_SHOT))
	player.free()


func _test_burst_caps_and_decays() -> void:
	var player := PlayerUnit.new()
	for i in 30:
		_fire_once(player)
	_check("连发：封顶 ×2.2", player.burst_spread_multiplier(), GameConfig.BURST_SPREAD_MAX)
	# 停火：先过重置时间，再逐拍收敛
	player.tick_timers(GameConfig.BURST_RESET_TIME + 0.01)
	for i in 40:
		player.tick_timers(0.2)
	_check("收敛：持续停火后回到 ×1.0", player.burst_spread_multiplier(), 1.0)
	player.free()


func _test_posture_spread() -> void:
	var player := PlayerUnit.new()
	var stand := player.effective_spread_moa()
	player.posture = PlayerUnit.Posture.CROUCH
	_check("姿态散布：蹲 = 站 × 0.75", player.effective_spread_moa(),
			stand * GameConfig.POSTURE_SPREAD_CROUCH)
	player.posture = PlayerUnit.Posture.PRONE
	_check("姿态散布：卧 = 站 × 0.5", player.effective_spread_moa(),
			stand * GameConfig.POSTURE_SPREAD_PRONE)
	_check_true("姿态散布：卧比蹲更准", player.effective_spread_moa()
			< stand * GameConfig.POSTURE_SPREAD_CROUCH)
	player.free()


func _test_posture_hit_scale() -> void:
	var player := PlayerUnit.new()
	_check("命中面积：站姿 1.0", player.hit_radius_scale(), GameConfig.POSTURE_HIT_STAND)
	player.posture = PlayerUnit.Posture.CROUCH
	_check("命中面积：蹲姿 0.7", player.hit_radius_scale(), GameConfig.POSTURE_HIT_CROUCH)
	player.posture = PlayerUnit.Posture.PRONE
	_check("命中面积：卧姿 0.5", player.hit_radius_scale(), GameConfig.POSTURE_HIT_PRONE)
	player.free()


## C2：切换时间 0.45 s（切到蹲）/ 0.65 s（切到卧），到时才生效
func _test_posture_switch_time() -> void:
	var player := PlayerUnit.new()
	player.posture = PlayerUnit.Posture.STAND
	player.switch_posture(PlayerUnit.Posture.CROUCH)
	player.tick_timers(0.2)
	_check("姿态切换：未到 0.45 s 时仍按站姿算",
			player.posture, PlayerUnit.Posture.STAND)
	player.tick_timers(0.3)
	_check("姿态切换：超过 0.45 s 后生效",
			player.posture, PlayerUnit.Posture.CROUCH)
	player.switch_posture(PlayerUnit.Posture.PRONE)
	player.tick_timers(0.3)
	_check("姿态切换：0.3 s 时还没趴下",
			player.posture, PlayerUnit.Posture.CROUCH)
	player.tick_timers(0.4)
	_check("姿态切换：超过 0.65 s 后趴下",
			player.posture, PlayerUnit.Posture.PRONE)
	player.free()
