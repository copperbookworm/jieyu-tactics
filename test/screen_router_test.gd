@tool
extends EditorScript

## 屏幕路由（界面跳转的唯一出口）：栈语义 / 显隐 / 返回 / 重复保护。
## 不需要进场景树 —— CanvasLayer 与 Control 都能当游离节点建起来，visible 与 _stack 照样可断言。

const RouterScript := preload("res://systems/ui/ScreenRouter.gd")

var _passed := 0
var _failed := 0


## 假屏幕：只记「进过 / 出过」与自己的可见性
class StubScreen extends Control:
	var id := ""
	var enters := 0
	var exits := 0
	func screen_id() -> String:
		return id
	func on_enter() -> void:
		enters += 1
	func on_exit() -> void:
		exits += 1


func _run() -> void:
	_test_register_and_reset()
	_test_push_pop()
	_test_visible_only_top()
	_test_guard_duplicates()
	_test_unknown_id()
	_test_clear_and_signal()
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


func _stub(router, screen_id: String):
	var s := StubScreen.new()
	s.id = screen_id
	router.register(screen_id, s)
	return s


func _make_router():
	var r = RouterScript.new()
	r.register("lobby", _stub(r, "lobby"))
	r.register("modes", _stub(r, "modes"))
	r.register("settings", _stub(r, "settings"))
	return r


func _test_register_and_reset() -> void:
	var r = _make_router()
	_check("注册了 3 屏", r.ids().size(), 3)
	_check("还没进栈时 current 为空", r.current_id(), "")
	_check("空栈不能 pop", r.can_pop(), false)
	r.reset_to("lobby")
	_check("reset_to 后栈深 1", r.depth(), 1)
	_check("current 是 lobby", r.current_id(), "lobby")
	_check_true("栈底不算「还有上一层」", not r.can_pop())


func _test_push_pop() -> void:
	var r = _make_router()
	r.reset_to("lobby")
	r.push("modes")
	_check("push 后栈深 2", r.depth(), 2)
	_check("current 是 modes", r.current_id(), "modes")
	_check_true("现在可以返回", r.can_pop())
	r.push("settings")
	_check("再 push → 栈深 3", r.depth(), 3)
	_check("back() 出栈后回到 modes", r.back() and r.current_id() == "modes", true)
	_check("再 back 回到 lobby", r.back() and r.current_id() == "lobby", true)
	_check("栈底 back 返回 false（不能把屏幕栈退空）", r.back(), false)
	_check("栈底 back 之后仍是 lobby", r.current_id(), "lobby")


## 同一时刻只能有一屏可见 —— 几何门禁只采集可见控件，这条是它的前提
func _test_visible_only_top() -> void:
	var r = _make_router()
	r.reset_to("lobby")
	var lobby = r.screen_of("lobby")
	var modes = r.screen_of("modes")
	_check("只有 lobby 可见", lobby.visible, true)
	_check("modes 不可见", modes.visible, false)
	r.push("modes")
	_check("push 后 lobby 立刻不可见（不能两屏同时可见）", lobby.visible, false)
	_check("push 后 modes 可见", modes.visible, true)
	r.pop()
	_check("pop 后 lobby 重新可见", lobby.visible, true)
	_check("pop 后 modes 不可见", modes.visible, false)


func _test_guard_duplicates() -> void:
	var r = _make_router()
	r.reset_to("lobby")
	r.push("modes")
	r.push("modes")   # 连点两下
	_check("重复 push 同一屏被忽略（防连点）", r.depth(), 2)
	# 重复注册要拒绝：否则 ids 与 _screens 会对不上
	r.register("modes", StubScreen.new())
	_check("重复注册同一 id 被拒绝", r.ids().size(), 3)


func _test_unknown_id() -> void:
	var r = _make_router()
	r.reset_to("lobby")
	r.push("no_such_screen")
	_check("push 未注册的屏：栈不变", r.depth(), 1)
	_check("push 未注册的屏：current 不变", r.current_id(), "lobby")
	r.reset_to("no_such_screen")
	_check("reset_to 未注册的屏：栈不变", r.current_id(), "lobby")
	_check("has() 对未注册 id 返回 false", r.has("no_such_screen"), false)


func _test_clear_and_signal() -> void:
	var r = _make_router()
	r.reset_to("lobby")
	var seen: Array = []
	r.screen_changed.connect(func(from_id, to_id): seen.append("%s->%s" % [from_id, to_id]))
	r.push("modes")
	_check("screen_changed 广播了一次", seen.size(), 1)
	_check("from/to 正确", String(seen[0]), "lobby->modes")
	r.clear()
	_check("clear 后栈空", r.depth(), 0)
	_check("clear 后 current 为空", r.current_id(), "")
	_check("clear 后没有可见屏", r.screen_of("modes").visible, false)
	_check("clear 也广播了", seen.size(), 2)
