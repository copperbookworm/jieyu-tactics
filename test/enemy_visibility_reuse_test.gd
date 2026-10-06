@tool
extends EditorScript

## A 改动（施工单 `改动1.md` §5）：`_update_visibility` 复用 `_update_ai` 刚算出的 `_can_see(_target)`，
## 省掉一次完整 `has_sight`（地形 + 掩体 + 烟雾三层都白算）。
##
## 用桩计 `has_sight` 的**真实调用次数**来证明"没再算第二遍"，并逐条守住施工单的三条红线：
##   ① 只在 `_target == _player` 时复用；
##   ② 缓存必须正对**当前**目标（`_sight_throttle` 是单槽的，换目标会 reset）；
##   ③ 框检测（`in_world_view`）不被绕过。
##
## 注意两个类型约束（踩过一次）：
##   · `Enemy._sight` 是**强类型** `SightSystem` ⇒ 桩必须 `extends SightSystem`，裸 RefCounted 赋值会被拒；
##   · `SightSystem.grid` 是强类型 `HeightGrid` ⇒ 塞一个真的 `HeightGrid.new()`（代码只判它是不是 null，
##     而所有要用的方法都被桩覆盖了）。

const EnemyScript := preload("res://entities/enemy/Enemy.gd")

var _passed := 0
var _failed := 0


## 桩：可控返回值 + 数各层被真调了几次
class StubSight extends SightSystem:
	var has_sight_calls := 0
	var has_sight_value := true
	var in_view := true
	var core_value := true
	var smoke_value := false

	func _init() -> void:
		grid = HeightGrid.new()

	func in_world_view(_target_world: Vector2, _camera_center: Vector2, _zoom: float,
			_viewport_size: Vector2 = Vector2(GameConfig.VIEWPORT_WIDTH, GameConfig.VIEWPORT_HEIGHT),
			_margin_px: float = 0.0) -> bool:
		return in_view

	func unit_sight_height(_world_pos: Vector2, _unit: Node) -> float:
		return 1.6

	func eye_height_at(_world_pos: Vector2, _eye_height: float = 1.6) -> float:
		return 1.6

	func has_sight(_origin: Vector2, _origin_height: float, _target: Vector2,
			_target_height: float, _margin: float = 0.0) -> bool:
		has_sight_calls += 1
		return has_sight_value

	func sight_core(_origin: Vector2, _origin_height: float, _target: Vector2,
			_target_height: float, _margin: float = 0.0) -> bool:
		return core_value

	func smoke_blocks(_origin: Vector2, _origin_height: float, _target: Vector2,
			_target_height: float) -> bool:
		return smoke_value


func _run() -> void:
	_test_reuse_when_target_is_player()
	_test_falls_back_when_cache_is_other_target()
	_test_falls_back_when_target_is_not_player()
	_test_frame_box_not_bypassed()
	_test_equivalent_to_direct_has_sight()
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


## 造一个"活着 + 有桩"的敌人；player / 队友都用普通 Node2D 顶替
func _make(player: Node2D, target: Node2D) -> Array:
	var e = EnemyScript.new()
	var stub := StubSight.new()
	e._sight = stub
	e._player = player
	e._target = target
	e.alive = true
	e.position = Vector2.ZERO
	return [e, stub]


func _test_reuse_when_target_is_player() -> void:
	var player := Node2D.new()
	player.position = Vector2(10.0, 0.0)
	var made := _make(player, player)
	var e = made[0]
	var stub: StubSight = made[1]
	# 目标就是玩家 + 缓存正对当前目标 ⇒ 必须复用
	e.visible = false
	e._cache_sees(player, true)
	stub.has_sight_calls = 0
	e._update_visibility()
	_check("复用：visible = 缓存值 true", e.visible, true)
	_check("复用：has_sight 一次都没调", stub.has_sight_calls, 0)

	e._cache_sees(player, false)
	e._update_visibility()
	_check("缓存 false ⇒ visible=false（也是直接复用）", e.visible, false)
	_check("缓存 false 时同样不调 has_sight", stub.has_sight_calls, 0)
	e.free()
	player.free()


## 红线②：缓存属于**别的目标**时，绝不能拿来当玩家的答案
func _test_falls_back_when_cache_is_other_target() -> void:
	var player := Node2D.new()
	player.position = Vector2(10.0, 0.0)
	var mate := Node2D.new()
	mate.position = Vector2(20.0, 0.0)
	var made := _make(player, player)
	var e = made[0]
	var stub: StubSight = made[1]
	e._cache_sees(mate, false)      # 缓存是队友的结论
	stub.has_sight_value = true
	stub.has_sight_calls = 0
	e._update_visibility()
	_check("缓存属于别的目标 ⇒ 走原路重算（has_sight 调 1 次）", stub.has_sight_calls, 1)
	_check("结果取自重算，而不是那条旧缓存", e.visible, true)
	e.free()
	player.free()
	mate.free()


## 红线①：目标不是玩家时不复用（谓词对象不同）
func _test_falls_back_when_target_is_not_player() -> void:
	var player := Node2D.new()
	player.position = Vector2(10.0, 0.0)
	var mate := Node2D.new()
	mate.position = Vector2(20.0, 0.0)
	var made := _make(player, mate)
	var e = made[0]
	var stub: StubSight = made[1]
	e._cache_sees(mate, true)
	stub.has_sight_value = false
	stub.has_sight_calls = 0
	e._update_visibility()
	_check("目标不是玩家 ⇒ 重算（has_sight 调 1 次）", stub.has_sight_calls, 1)
	_check("结果来自 has_sight（false）", e.visible, false)
	e.free()
	player.free()
	mate.free()


## 红线③：框检测在复用分支之前，不能被绕过
func _test_frame_box_not_bypassed() -> void:
	var player := Node2D.new()
	player.position = Vector2(10.0, 0.0)
	var made := _make(player, player)
	var e = made[0]
	var stub: StubSight = made[1]
	stub.in_view = false
	e.visible = true
	e._cache_sees(player, true)      # 缓存说"看得见"
	stub.has_sight_calls = 0
	e._update_visibility()
	_check("框外 ⇒ 仍然 visible=false（缓存说 true 也不算）", e.visible, false)
	_check("框外 ⇒ 一次 has_sight 都不调", stub.has_sight_calls, 0)
	e.free()
	player.free()


## 施工单 §5 的验收原话：「显隐结果与直接调 has_sight 一致」
func _test_equivalent_to_direct_has_sight() -> void:
	var player := Node2D.new()
	player.position = Vector2(10.0, 0.0)
	var made := _make(player, player)
	var e = made[0]
	var stub: StubSight = made[1]
	for v in [true, false]:
		stub.has_sight_value = v
		e._cache_sees(player, v)     # 缓存 = AI 用同一个谓词算出来的值
		e._update_visibility()
		var reused: bool = e.visible
		e._cache_sees(null, false)   # 作废缓存 ⇒ 走原路直接算
		e._update_visibility()
		var direct: bool = e.visible
		_check("复用结果 == 直接调 has_sight（桩值=%s）" % str(v), reused, direct)
	e.free()
	player.free()
