@tool
extends EditorScript

## 占领状态机测试：进区 30s 翻蓝、进区 10s 未翻蓝、离开回退
## 运行：脚本编辑器打开本文件 → 文件 → 运行

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_capture_to_blue()
	_test_capture_partial_and_revert()
	_test_retake_from_red()
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


func _test_capture_to_blue() -> void:
	var zone := CaptureZone.new()
	var player := Node2D.new()
	player.position = Vector2.ZERO
	zone.position = Vector2.ZERO
	zone.setup(player)
	# 玩家一直在区内，模拟 30s（每帧 0.1s × 300 帧）
	for i in 300:
		zone._process(0.1)
	_check("占领：区内保持 30s 翻蓝", zone.state, CaptureZone.State.BLUE)
	_check("占领：翻蓝后进度满", zone.progress, 1.0)
	zone.free()
	player.free()


func _test_capture_partial_and_revert() -> void:
	var zone := CaptureZone.new()
	var player := Node2D.new()
	player.position = Vector2.ZERO
	zone.position = Vector2.ZERO
	zone.setup(player)
	for i in 100:
		zone._process(0.1)
	_check_true("占领：进区 10s 未翻蓝（进度未满）", zone.state != CaptureZone.State.BLUE)
	_check_true("占领：进区 10s 有进度", zone.progress > 0.0)
	# 离开：玩家移到 50m 外，模拟 20s
	player.position = Vector2(50.0, 0.0)
	for i in 200:
		zone._process(0.1)
	_check_true("占领：离开后进度回退到 0", zone.progress <= 0.001)
	zone.free()
	player.free()


## 反夺：节点已被敌方占满（RED，progress = -1），玩家进圈独自推，应能翻回我方
## 口径（2026-09-28 修正）：完整翻转 -1 → +1 = FLAG_HOLD_TIME = 30 s（原实现 60 s，打不回来）
func _test_retake_from_red() -> void:
	var zone := CaptureZone.new()
	var player := Node2D.new()
	zone.position = Vector2.ZERO
	player.position = Vector2.ZERO
	zone.setup(player)
	zone.progress = -1.0
	zone._update_state()
	_check("反夺：起点＝敌方满占（RED）", zone.state, CaptureZone.State.RED)
	for i in 300:
		zone._process(0.1)
	_check("反夺：30 s 后从敌占满翻回我方", zone.state, CaptureZone.State.BLUE)
	_check("反夺：翻蓝后进度满", zone.progress, 1.0)
	zone.free()
	player.free()
