extends CanvasLayer

## 屏幕路由 —— 游戏外壳里所有界面跳转的唯一出口
##
## 为什么要有它（而不是各屏幕自己 show/hide）：
##   ① 跳转是**一处状态**，散在五个屏幕里必然出现「两个屏幕同时可见」这类脏状态；
##   ② 返回键（Android 返回 / ESC）只有一个入口，否则每个屏幕各写一遍迟早漏；
##   ③ 几何门禁只采集 is_visible_in_tree() 的控件 ⇒ 只要同一时刻只有一个屏幕可见，
##      各屏幕的布局就能各自独立地被门禁钉住。
##
## 层级：layer 100 —— 菜单在所有东西之上（HUD 是 1、战术地图 10、AI 参谋面板 90）。
##
## 刻意不写 class_name：引用方 preload。

signal screen_changed(from_id: String, to_id: String)

const UiKit := preload("res://ui/UiKit.gd")

## 菜单层：必须 >= AI 参谋面板(90)，否则暂停菜单会被参谋面板盖住
const STACK_LAYER := 100

var _screens: Dictionary = {}   ## id -> Control
var _order: Array = []          ## 注册顺序（报错时列出来，便于发现自己拼错了 id）
var _stack: Array = []          ## 栈顶在最后


func _ready() -> void:
	layer = STACK_LAYER
	# 暂停菜单本身就是在「引擎已暂停」时才出现的，路由因此必须无视 pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)


func register(screen_id: String, screen: Control) -> void:
	if screen_id == "":
		push_error("[路由] 屏幕 id 不能为空")
		return
	if _screens.has(screen_id):
		push_error("[路由] 屏幕 id 重复注册：%s" % screen_id)
		return
	_screens[screen_id] = screen
	_order.append(screen_id)
	screen.visible = false
	add_child(screen)


func has(screen_id: String) -> bool:
	return _screens.has(screen_id)


func screen_of(screen_id: String) -> Control:
	return _screens.get(screen_id, null)


func ids() -> Array:
	return _order.duplicate()


func depth() -> int:
	return _stack.size()


func current_id() -> String:
	return String(_stack[_stack.size() - 1]) if not _stack.is_empty() else ""


func current() -> Control:
	return screen_of(current_id())


func stack_ids() -> Array:
	return _stack.duplicate()


## 还有上一层吗（返回按钮 / 返回键要不要生效）
func can_pop() -> bool:
	return _stack.size() > 1


## 清空整栈只留这一屏（大厅用；对局开始 / 返回大厅也用它把菜单收干净）
func reset_to(screen_id: String) -> void:
	if not _screens.has(screen_id):
		push_error("[路由] 没有注册过的屏幕：%s（已注册：%s）" % [screen_id, str(_order)])
		return
	var from := current_id()
	for i in range(_stack.size() - 1, -1, -1):
		_exit_screen(String(_stack[i]))
	_stack = [screen_id]
	_sync(from)


func push(screen_id: String) -> void:
	if not _screens.has(screen_id):
		push_error("[路由] 没有注册过的屏幕：%s（已注册：%s）" % [screen_id, str(_order)])
		return
	var from := current_id()
	if from == screen_id:
		return   # 重复 push 同一屏没有意义，直接忽略（防连点）
	_stack.append(screen_id)
	_sync(from)


func pop() -> bool:
	if not can_pop():
		return false
	var from := current_id()
	_stack.pop_back()
	_sync(from)
	return true


func clear() -> void:
	var from := current_id()
	for i in range(_stack.size() - 1, -1, -1):
		_exit_screen(String(_stack[i]))
	_stack = []
	_sync(from)


## 返回键 / 返回按钮的统一入口
func back() -> bool:
	return pop()


func _sync(from_id: String) -> void:
	var top := current_id()
	for screen_id in _screens.keys():
		var screen := _screens[screen_id] as Control
		screen.visible = screen_id == top
	if top != "":
		_enter_screen(top)
	screen_changed.emit(from_id, top)


func _enter_screen(screen_id: String) -> void:
	var screen := screen_of(screen_id)
	if screen != null and screen.has_method("on_enter"):
		screen.on_enter()


func _exit_screen(screen_id: String) -> void:
	var screen := screen_of(screen_id)
	if screen != null and screen.has_method("on_exit"):
		screen.on_exit()


func _unhandled_input(event: InputEvent) -> void:
	if not can_pop():
		return
	var is_back := event.is_action_pressed("ui_cancel")
	if not is_back and event is InputEventKey:
		var key := event as InputEventKey
		is_back = key.pressed and not key.echo and key.keycode == KEY_ESCAPE
	if is_back:
		pop()
		get_viewport().set_input_as_handled()


## Android 实体返回键（与 ESC 走同一个出口）
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and can_pop():
		pop()
