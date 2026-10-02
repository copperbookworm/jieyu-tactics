@tool
extends EditorScript

## 4.16 被击倒时的视角（候选 O 第三轮）：倒地态 / 行为闸门 / 计时转阵亡 / 相机锁定
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## 纯逻辑与相机行为在这里测；全屏灰罩 / 暗角 / 倒计时这些画面项跑在集成冒烟里（要真起 HUD）。

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_params()
	_test_down_not_die()
	_test_action_gates()
	_test_timer_to_death()
	_test_revive()
	_test_damage_after_death()
	_test_camera_lock()
	_test_camera_free_when_healthy()
	_test_drag_ignored_while_down()
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


func _new_player():
	return PlayerUnit.new()


## 4.16 的数值出口
func _test_params() -> void:
	_check("4.16：倒地超时默认 60 s", GameConfig.DOWNED_TIMEOUT, 60.0)
	_check_true("4.16：扶起后有血量", GameConfig.DOWNED_REVIVE_HP > 0.0)


## 血量归零 → 倒地，而不是直接阵亡（4.16 的核心改动）
func _test_down_not_die() -> void:
	var player = _new_player()
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	_check_true("倒地：downed 为真", player.downed)
	_check_true("倒地：alive 仍为真（还没阵亡）", player.alive)
	_check("倒地：血量钳在 0", player.hp, 0.0)
	_check("倒地：计时从 60 s 起算", player.downed_time_left, GameConfig.DOWNED_TIMEOUT)
	player.free()


## 倒地期间无法行动：开火 / 移动 / 换弹 / 换枪
func _test_action_gates() -> void:
	var player = _new_player()
	var joystick := TouchJoystick.new()
	joystick.move_vector = Vector2.RIGHT
	player.set_joystick(joystick)
	_check("未倒地：摇杆输入能读出来", player.move_input(), Vector2.RIGHT)
	var healthy_can_fire: bool = player.can_fire()
	_check_true("未倒地：能开火", healthy_can_fire)

	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	_check_true("倒地：不能开火", not player.can_fire())
	_check("倒地：移动输入被清零", player.move_input(), Vector2.ZERO)

	# 换弹：有备弹且弹匣空，本该能开始换弹——倒地就不许
	player.ammo_in_mag = 0
	player.reserve_ammo = 30
	player._reloading = false
	player.start_reload()
	_check_true("倒地：不能开始换弹", not player._reloading)

	# 换枪：带两把枪也不许切
	player.weapons = ["qbz191", "m17"]
	player.switch_weapon()
	_check_true("倒地：不能换枪", not player.is_switching_weapon())
	joystick.free()
	player.free()


## 到点转阵亡（走真实的 _physics_process，不是直调 die）
func _test_timer_to_death() -> void:
	var player = _new_player()
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	player._physics_process(GameConfig.DOWNED_TIMEOUT - 1.0)
	_check_true("计时：59 s 时还在倒地（没到点）", player.downed and player.alive)
	_check("计时：剩余 1 s", player.downed_time_left, 1.0)
	player._physics_process(1.5)
	_check_true("计时：到点转阵亡", not player.alive and not player.downed)
	_check("计时：阵亡后倒计时清零", player.downed_time_left, 0.0)
	player.free()


## 扶起（4.16 的队友救援路径；第一版单机没有队友，接口先留着）
func _test_revive() -> void:
	var player = _new_player()
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	player.revive()
	_check_true("扶起：不再是倒地态", not player.downed)
	_check_true("扶起：人还活着", player.alive)
	_check("扶起：血量 = DOWNED_REVIVE_HP", player.hp, GameConfig.DOWNED_REVIVE_HP)
	_check("扶起：倒计时清零", player.downed_time_left, 0.0)
	player.free()


func _test_damage_after_death() -> void:
	var player = _new_player()
	player.die()
	_check_true("阵亡后：alive 为假", not player.alive)
	player.take_damage(10.0)
	_check("阵亡后：再挨打血量不动", player.hp, GameConfig.SOLDIER_HP)
	player.free()


## 4.16：倒地后相机锁定在倒地身体上方（俯视固定、不可拖动）
func _test_camera_lock() -> void:
	var player = _new_player()
	player.global_position = Vector2(120.0, 340.0)
	var camera := Camera2D.new()
	var controller := AimCameraController.new()
	controller.setup(player, camera, null)
	controller.crosshair_world = Vector2(900.0, 900.0)
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	controller._process(0.016)
	_check_true("相机：locked_on_unit 为真", controller.locked_on_unit)
	_check("相机：准心被锁到身体上", controller.crosshair_world, Vector2(120.0, 340.0))
	_check_true("相机：锁定状态不再报「被地形挡住」", not controller.blocked_by_terrain)
	camera.free()
	controller.free()
	player.free()


func _test_camera_free_when_healthy() -> void:
	var player = _new_player()
	player.global_position = Vector2(100.0, 100.0)
	var camera := Camera2D.new()
	var controller := AimCameraController.new()
	controller.setup(player, camera, null)
	controller.crosshair_world = Vector2(180.0, 100.0)
	controller._process(0.016)
	_check_true("相机：站着的时候不锁", not controller.locked_on_unit)
	_check("相机：准心保持玩家拖到的位置", controller.crosshair_world, Vector2(180.0, 100.0))
	camera.free()
	controller.free()
	player.free()


## 倒地后拖屏不该再动准心（_unhandled_input 的第一道闸门）
func _test_drag_ignored_while_down() -> void:
	var player = _new_player()
	player.global_position = Vector2(50.0, 50.0)
	var camera := Camera2D.new()
	var controller := AimCameraController.new()
	controller.setup(player, camera, null)
	player.take_damage(GameConfig.SOLDIER_HP * 2.0)
	var press := InputEventScreenTouch.new()
	press.index = 0
	press.position = Vector2(700.0, 300.0)   # 右半屏起手
	press.pressed = true
	controller._unhandled_input(press)
	var drag := InputEventScreenDrag.new()
	drag.index = 0
	drag.relative = Vector2(220.0, 0.0)
	controller._unhandled_input(drag)
	_check("倒地：拖屏不动准心", controller.crosshair_world, Vector2(50.0, 50.0))
	camera.free()
	controller.free()
	player.free()
