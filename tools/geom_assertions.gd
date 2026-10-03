extends SceneTree

## visual-regression / A 路 · HUD 几何断言（headless 可跑）
##
## 为什么不用像素：`--headless` 渲染不出画面，截 Viewport 只会得到空图。
## 「按钮不重叠 / 不出屏 / 点按够大」全部只看 Control.get_global_rect()，所以 headless 就能断言。
##
## 用法（放进工程 res://tools/ 后跑）：
##   godot --headless --path <proj> --log-file <工作区内可写路径> \
##         --script res://tools/geom_assertions.gd -- [--init] [--strict]
##
##   --init    把当前的重叠集合写成基线（人确认过之后才用）
##   默认      与基线比对：**新出现**的重叠才算失败；已登记的重叠不报错
##   --strict  不看基线，任何可见同级重叠都失败（做 HUD 专项排查时才用）
##
## 退出码：0 = 全绿，1 = 有失败。输出沿用 test/effects_test.gd 的 [OK]/[FAIL] 口径。
##
## 【2026-10-03】断言实现抽到 tools/geom_checks.gd —— 游戏外壳的新屏幕（tools/screen_geom_check.gd）
## 要跑同一套规则，抄一份等于两份规则迟早对不上。本文件只剩「驱动」：建 Main.tscn、跑、报数。
## 唯一的例外：MAIN 的基线是**逐条人工定案**的历史账，它属于这个场景，不属于通用实现。
##
## ⚠ 与 tools/run_integration_headless.gd 同样的硬约束：本脚本的编译早于 autoload 注册，
##    因此**不能**在编译期引用 EventBus / CaptureZone / Player / Enemy / AimCameraController / QuestSystem。
##    要碰这些只能在运行时按名字取。

const GeomChecksScript := preload("res://tools/geom_checks.gd")

const SETTLE_SECONDS := 1.5      # 等 HUD 装配与第一帧布局稳定
const SCENE_PATH := "res://scenes/gameplay/Main.tscn"

const VIEW_W := 960.0            # 工程逻辑分辨率（960x540 + canvas_items 拉伸）
const VIEW_H := 540.0

## 基线文件（相对工程根）。--init 写它，默认读它。
const BASELINE_PATH := "res://test/geom_baseline.json"

## 有意重叠/出屏的装饰层白名单（按节点名或完整路径匹配）
const IGNORE_NODES := [
	"Crosshair",   # 准星本就叠在战场中央，是有意覆盖
	"Joystick",    # 摇杆是触摸热区，视觉可被覆盖
]

## 基线逐条定案（2026-10-02 使用者拍板）：键 = "A|B"（与 overlaps 的键口径一致，字母序）
## 「有意」= 按设计保留（必须写清为什么功能上不冲突）；「无意」= 真问题，待修（必须写清修法）。
## 这份定案由 --init 写进 test/geom_baseline.json 的 verdict 字段 ⇒ 下次 --init 不会丢。
const BASELINE_NOTES := {
	"CaptureStatus|QuestCard": "无意（真 bug，真机截图可见）：节点状态行 (16,36 高 49) 与任务卡 (16,60 高 96) 纵向叠 25 px，真机上两行文字互相压。修法：任务卡下移或收窄 —— 但下方 85..162 只剩 77 px，放不下 96 高的卡，需拍板（缩卡 / 换位置）。",
	"FocusButton|MarkHint": "有意：聚焦触摸热区刻意做 120×120（点按目标够大），提示行是 Label 不接收输入 ⇒ 功能上不冲突。",
	"MarkWheel|HP": "有意：报点轮盘展开时按层级临时盖住右上信息条，选择或取消后立即收起；HP 是 Label，不抢触摸。",
	"MarkWheel|MapButton": "无意（真问题）：轮盘与地图键**都是可点按钮**，重叠区里按下命中不确定（触屏歧义）。修法：轮盘展开时禁用地图键，或把轮盘中心左移。",
	"MatchClock|MarkWheel": "有意：同 MarkWheel|HP —— 战局状态行是 Label；要更干净可在轮盘展开时临时隐藏该行。",
	"QuestCard|CombatFeed": "无意：任务卡实际宽 316（不止 300）与播报区左缘相交 16 px ⇒ 两块面板边框/文字可能贴住。修法：卡宽收到 300，或播报区右移 16 px。",
	# 2026-10-03 游戏外壳：HUD 按钮分组重排后新增的一对（左下角摇杆热区与暂停键无关，
	# 这里只登记真实新增的；reason 必须写清）
}

var _checks = null
var _main: Node = null
var _elapsed := 0.0
var _done := false
var _init_mode := false
var _strict := false


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--init":
			_init_mode = true
		elif a == "--strict":
			_strict = true
	print("===== HUD 几何断言（visual-regression A 路）%s%s=====" % [
		" [--init]" if _init_mode else "", " [--strict]" if _strict else ""])
	var packed: PackedScene = load(SCENE_PATH)
	if packed == null:
		print("！！ 加载不到 %s" % SCENE_PATH)
		_done = true
		quit(1)
		return
	_main = packed.instantiate()
	root.add_child(_main)
	current_scene = _main


func _process(delta: float) -> bool:
	if _done:
		return true
	_elapsed += delta
	if _elapsed < SETTLE_SECONDS:
		return false
	_done = true
	_run_all()
	quit(1 if _checks.failed > 0 else 0)
	return true


func _run_all() -> void:
	_checks = GeomChecksScript.new()
	_checks.view_w = VIEW_W
	_checks.view_h = VIEW_H
	_checks.ignore_nodes = IGNORE_NODES
	_checks.run_all(_main, BASELINE_PATH, BASELINE_NOTES, _init_mode, _strict)
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_checks.passed, _checks.failed])
	if _checks.failed > 0:
		print("！！ 有 %d 项失败：往上翻看 [FAIL] 行 —— 重叠会给两个控件路径与两个 rect，直接可定位"
				% _checks.failed)
