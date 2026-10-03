extends SceneTree

## 游戏外壳各屏幕的几何门禁（visual-regression / A 路）
##
## 为什么需要它：tools/geom_assertions.gd 只管 Main.tscn（对局内 HUD），而外壳的
## 大厅 / 模式 / 设置 / 暂停 / 结算五屏属于新场景 App.tscn，不在这条门禁的视野里。
## 「没门禁」不等于「不用管」—— 这个工程已经被这条教训咬过一次（见 ui/AiAdvisorPanel.gd 头部）。
##
## 断言实现复用 tools/geom_checks.gd（与 HUD 门禁同一套规则，不抄第二份）。
## 每一屏单独采集：路由保证同一时刻只有一屏可见，所以各屏布局互不干扰、各自可定位。
##
## 用法：
##   godot --headless --path <proj> --log-file <可写路径> \
##         --script res://tools/screen_geom_check.gd -- [--init] [--strict]
##   --init 把**五屏合并**的重叠集合一次写成 res://test/geom_baseline_app.json
##         （逐屏写会把前一屏的结果覆盖掉 —— 所以采集阶段只存不写，最后合并落盘）
##
## 退出码：0 = 全绿，1 = 有失败。
##
## ⚠ 同 run_integration_headless.gd 的硬约束：本脚本编译早于 autoload 注册，
##    因此不能在任何地方写出 autoload 的全局名。

const GeomChecksScript := preload("res://tools/geom_checks.gd")

const APP_SCENE_PATH := "res://scenes/app/App.tscn"
const BASELINE_PATH := "res://test/geom_baseline_app.json"
## 自检专用设置路径（不存在 ⇒ 全用默认值）：不读玩家真实 user://game_settings.cfg，
## 否则「界面文字随本机设置变」会让布局与基线在不同机器上不一样
const SETTINGS_PROBE := "user://_screen_geom_settings.cfg"

const VIEW_W := 960.0
const VIEW_H := 540.0

## 每屏停留多少帧再断言（ScreenRouter 同步切可见性，但要等容器排布完成）
const SETTLE_FRAMES := 12

## 外壳没有「有意重叠」的既有账：暂停 / 结算都是整屏菜单，一屏只该有一层。
## 真出现重叠就说明布局写坏了，必须修 —— 不许往这里加白名单。
const BASELINE_NOTES := {}

const STATES := ["lobby", "modes", "settings", "pause", "result"]

var _app: Node = null
var _checks = null
## 启动阶段帧数：等 App._ready 跑完
const BOOT_FRAMES := 3

var _booted := false
var _boot_frames := 0
var _index := 0
var _frames := 0
var _passed := 0
var _failed := 0
var _init_mode := false
var _strict := false


## 屏幕必须注册齐全的清单（含 info：它由大厅的「玩法说明 / 关于」进来）
const REQUIRED_SCREENS := ["lobby", "modes", "settings", "pause", "result", "info"]


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--init":
			_init_mode = true
		elif a == "--strict":
			_strict = true
	print("===== 游戏外壳几何断言（visual-regression A 路）%s%s=====" % [
		" [--init]" if _init_mode else "", " [--strict]" if _strict else ""])
	var packed: PackedScene = load(APP_SCENE_PATH)
	if packed == null:
		print("！！ 加载不到 %s" % APP_SCENE_PATH)
		quit(1)
		return
	_app = packed.instantiate()
	# 确定性：注入一份不存在的设置路径 ⇒ 界面全用默认值
	_app.settings_path_override = SETTINGS_PROBE
	root.add_child(_app)
	current_scene = _app
	_checks = GeomChecksScript.new()
	_checks.view_w = VIEW_W
	_checks.view_h = VIEW_H
	# 注意：_initialize 里 add_child 之后 **App._ready 还没跑**（引擎把它排到第一帧），
	# 所以「外壳起没起来」的体检不能放这里 —— 放 _process 的启动阶段（见 _boot）。


## 门禁自己也会「空跑通过」：App 起不来 ⇒ 一屏都没注册 ⇒ 零重叠零失败，看着像全绿。
## 历史教训是「把红的测试当成绿的提交」，所以这里先钉住「场景真的起来了」。
func _sanity_check() -> void:
	var router = _app.router if _app != null else null
	if router == null:
		print("[FAIL] App.router 是 null —— 外壳根本没起来，后面的断言没有意义")
		_failed += 1
		return
	for screen_id in REQUIRED_SCREENS:
		if not router.has(screen_id):
			print("[FAIL] 屏幕没注册：%s（已注册：%s）" % [screen_id, str(router.ids())])
			_failed += 1


func _process(_delta: float) -> bool:
	if _app == null or _checks == null:
		return true
	# 启动阶段：等 App._ready 真正跑完（add_child 之后的 _ready 排在首帧），再体检外壳
	if not _booted:
		_boot_frames += 1
		if _boot_frames < BOOT_FRAMES:
			return false
		_booted = true
		_sanity_check()
		return false
	if _index >= STATES.size():
		_finish()
		return true
	if _frames == 0:
		_enter_state(STATES[_index])
	_frames += 1
	if _frames >= SETTLE_FRAMES:
		_check_state(STATES[_index])
		_index += 1
		_frames = 0
	return false


## 把外壳切到某一屏。走路由自己的接口（不是直接改 visible），顺带把跳转也验一遍 ——
## 跳转错了（例如某屏没注册）会在这里就炸出来。
func _enter_state(state: String) -> void:
	var router = _app.router
	if router == null:
		return
	if state == "settings":
		# 设置是从大厅压上去的（栈底留大厅）：查的就是玩家那条路径
		router.reset_to("lobby")
		router.push("settings")
	elif state == "modes":
		router.reset_to("lobby")
		router.push("modes")
	else:
		router.reset_to(state)


func _check_state(state: String) -> void:
	# 屏幕 id 当键前缀：不同屏上同名的控件（例如都叫 BackButton）不会互相顶掉基线条目
	_checks.key_prefix = state + "/"
	# 这一屏必须真的看得见东西，否则门禁等于空跑（零控件也能报「不出屏」全绿）
	if _checks.collect_controls(_app).is_empty():
		print("[FAIL] 屏幕 [%s] 一个可见控件都没有 —— 门禁空跑，等于没查" % state)
		_failed += 1
		return
	if _init_mode:
		# 只采集不判定：五屏重叠合并成一份基线，_finish 里一次写盘
		_checks.collect_overlaps(_checks.collect_controls(_app))
		return
	_checks.reset_counters()
	_checks.run_all(_app, BASELINE_PATH, BASELINE_NOTES, false, _strict)
	_passed += _checks.passed
	_failed += _checks.failed
	if _checks.failed > 0:
		print("！！ 屏幕 [%s] 有 %d 项失败" % [state, _checks.failed])


func _finish() -> void:
	if _init_mode:
		# 前缀已经并进重叠对的键里，写盘时字段留空
		_checks.key_prefix = ""
		_checks.failed = 0
		_checks.write_baseline(BASELINE_PATH, BASELINE_NOTES)
		quit(0)
		return
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败：往上翻 [FAIL] 行，重叠会给两个控件路径与两个 rect" % _failed)
	quit(1 if _failed > 0 else 0)
