@tool
extends EditorScript

## 通视节流器（GameConfig.SIGHT_THROTTLE_FRAMES）：同一窗口内复用上一次结果，
## 跨窗口才真查；换目标要 reset。用桩对象数「真查了几次」，不依赖场景树。

const SightSystemScript := preload("res://systems/terrain/SightSystem.gd")

var _passed := 0
var _failed := 0


## 桩：只数 has_sight 被真调了几次
class StubSight extends RefCounted:
	var calls := 0
	var value := true
	func has_sight(_o: Vector2, _oh: float, _t: Vector2, _th: float, _m: float = 0.0) -> bool:
		calls += 1
		return value


func _run() -> void:
	_test_throttles()
	_test_period_one_disables()
	_test_reset_and_target_change()
	_test_config_default()
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


func _sight() -> SightSystemScript.Throttle:
	return SightSystemScript.Throttle.new(4)


func _test_throttles() -> void:
	var stub := StubSight.new()
	var th := _sight()
	# 同一窗口（frame 0..3）连查 4 次 ⇒ 只真查 1 次
	for f in [0, 0, 1, 3]:
		th.sight(stub, f, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6)
	_check("窗口内 4 次调用只真查 1 次", stub.calls, 1)
	_check("命中 3 次", th.hits, 3)
	_check("真查计数 1", th.calls, 1)
	# 跨到第 4 帧 ⇒ 再真查一次
	th.sight(stub, 4, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6)
	_check("跨窗口再真查一次", stub.calls, 2)
	# 结果要跟着桩变化：窗口内沿用旧值，跨窗口拿到新值
	stub.value = false
	_check("窗口内沿用上一次的 true", th.sight(stub, 5, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6), true)
	_check("跨窗口后拿到新的 false", th.sight(stub, 8, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6), false)
	_check("真查总数 3", stub.calls, 3)


## period = 1 = 关掉节流（回到逐帧查）
func _test_period_one_disables() -> void:
	var stub := StubSight.new()
	var th := SightSystemScript.Throttle.new(1)
	for f in 5:
		th.sight(stub, f, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6)
	_check("period=1：5 次调用真查 5 次", stub.calls, 5)
	_check("period=1：没有命中", th.hits, 0)


## 换目标必须 reset：否则会把上一个目标的结果当成这个目标的
func _test_reset_and_target_change() -> void:
	var stub := StubSight.new()
	var th := _sight()
	th.sight(stub, 10, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6)
	_check("第一次真查", stub.calls, 1)
	th.reset()
	th.sight(stub, 11, Vector2.ZERO, 1.6, Vector2(50, 0), 1.6)
	_check("reset 之后立刻重查（不吃上一个目标的缓存）", stub.calls, 2)


func _test_config_default() -> void:
	_check_true("默认窗口 = GameConfig.SIGHT_THROTTLE_FRAMES", GameConfig.SIGHT_THROTTLE_FRAMES >= 1)
	var th := SightSystemScript.Throttle.new()
	_check("不传参时用配置里的窗口", th.period, maxi(GameConfig.SIGHT_THROTTLE_FRAMES, 1))
	_check_true("队友重挑目标的间隔已配置", GameConfig.AI_TARGET_RETRY_INTERVAL > 0.0)
