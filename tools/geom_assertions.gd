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
## ⚠ 与 tools/run_integration_headless.gd 同样的硬约束：本脚本的编译早于 autoload 注册，
##    因此**不能**在编译期引用 EventBus / CaptureZone / Player / Enemy / AimCameraController / QuestSystem。
##    要碰这些只能在运行时按名字取。

const SETTLE_SECONDS := 1.5      # 等 HUD 装配与第一帧布局稳定
const SCENE_PATH := "res://scenes/gameplay/Main.tscn"

const VIEW_W := 960.0            # 工程逻辑分辨率（960x540 + canvas_items 拉伸）
const VIEW_H := 540.0

const OFFSCREEN_TOLERANCE := 1.0 # 出屏容差（逻辑像素）
const MIN_TAP_SIZE := 32.0       # 最小点按目标边长（逻辑像素）

## 基线文件（相对工程根）。--init 写它，默认读它。
const BASELINE_PATH := "res://test/geom_baseline.json"

## 有意重叠/出屏的装饰层白名单（按节点名或完整路径匹配）
const IGNORE_NODES := [
	"Crosshair",   # 准星本就叠在战场中央，是有意覆盖
	"Joystick",    # 摇杆是触摸热区，视觉可被覆盖
]

## 带点击语义的信号名 —— 有其一就按「可点控件」检查最小尺寸
const CLICK_SIGNALS := ["pressed", "button_down", "button_up", "toggled"]

var _main: Node = null
var _elapsed := 0.0
var _passed := 0
var _failed := 0
var _done := false
var _init_mode := false
var _strict := false

var _overlaps := {}   # "A|B" -> {a, b, parent, hit_size}


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
	quit(1 if _failed > 0 else 0)
	return true


# ============================== 断言主体 ==============================

func _run_all() -> void:
	var controls := _collect_controls(_main)
	print("— 采集到可见 Control %d 个（视口 %.0fx%.0f）" % [controls.size(), VIEW_W, VIEW_H])

	_check_no_offscreen(controls)
	_collect_overlaps(controls)
	_check_overlaps_against_baseline()
	_check_tap_targets(controls)
	_check_canvas_layers()

	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败：往上翻看 [FAIL] 行 —— 重叠会给两个控件路径与两个 rect，直接可定位" % _failed)


func _collect_controls(node: Node) -> Array:
	var out := []
	if node is Control:
		var c := node as Control
		if c.is_visible_in_tree():
			var r := c.get_global_rect()
			if r.size.x > 0.0 and r.size.y > 0.0:
				out.append(c)
	for child in node.get_children():
		out.append_array(_collect_controls(child))
	return out


func _check_no_offscreen(controls: Array) -> void:
	var bad := 0
	for c in controls:
		var ctrl := c as Control
		if _ignored(ctrl):
			continue
		var r := ctrl.get_global_rect()
		var inside := r.position.x >= -OFFSCREEN_TOLERANCE \
			and r.position.y >= -OFFSCREEN_TOLERANCE \
			and (r.position.x + r.size.x) <= VIEW_W + OFFSCREEN_TOLERANCE \
			and (r.position.y + r.size.y) <= VIEW_H + OFFSCREEN_TOLERANCE
		if not inside:
			bad += 1
			print("[FAIL] 出屏：%s" % _path_of(ctrl))
			print("       rect = %s（视口 %.0fx%.0f）" % [str(r), VIEW_W, VIEW_H])
	_check("不出屏（%d 个可见 Control）" % controls.size(), bad, 0)


func _collect_overlaps(controls: Array) -> void:
	# 只在「同一父节点的直接 Control 子节点」之间两两比：跨层级的父子包含是正常嵌套。
	# 由 Container 排布的子节点跳过（重叠是布局器的意图）。
	var by_parent := {}
	for c in controls:
		var ctrl := c as Control
		if _ignored(ctrl):
			continue
		var parent := ctrl.get_parent()
		if parent is Container:
			continue
		var key := str(parent.get_path())
		if not by_parent.has(key):
			by_parent[key] = []
		by_parent[key].append(ctrl)

	for key in by_parent.keys():
		var group: Array = by_parent[key]
		if group.size() < 2:
			continue
		for i in range(group.size()):
			for j in range(i + 1, group.size()):
				var a := group[i] as Control
				var b := group[j] as Control
				var ra := a.get_global_rect()
				var rb := b.get_global_rect()
				var hit := ra.intersection(rb)
				if hit.size.x <= 0.0 or hit.size.y <= 0.0:
					continue
				var na := _name_of(a)
				var nb := _name_of(b)
				var pair := "%s|%s" % [na, nb]
				_overlaps[pair] = {
					"a": _path_of(a), "b": _path_of(b), "parent": key,
					"rect_a": _rect_str(ra), "rect_b": _rect_str(rb),
					"hit": _rect_str(hit),
				}


func _check_overlaps_against_baseline() -> void:
	print("— 可见同级重叠对：%d 组" % _overlaps.size())

	if _init_mode:
		_write_baseline()
		return

	if _strict:
		for pair in _overlaps.keys():
			var d: Dictionary = _overlaps[pair]
			print("[FAIL] 重叠（strict）：%s × %s" % [d["a"], d["b"]])
			print("       hit = %s" % d["hit"])
		_check("strict：无任何可见同级重叠", _overlaps.size(), 0)
		return

	# 默认：与基线比对。基线不存在 ⇒ 不让它变成隐形通过。
	if not FileAccess.file_exists(BASELINE_PATH):
		print("[FAIL] 找不到基线 %s —— 先用 --init 生成并人工确认，之后才能做「新重叠才失败」的比对" % BASELINE_PATH)
		_failed += 1
		return
	var raw := FileAccess.get_file_as_string(BASELINE_PATH)
	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY or not (parsed as Dictionary).has("overlaps"):
		print("[FAIL] 基线 %s 格式不对（要 {\"overlaps\": {...}}）" % BASELINE_PATH)
		_failed += 1
		return
	var known: Dictionary = parsed["overlaps"]

	var newly := []
	for pair in _overlaps.keys():
		if not known.has(pair):
			newly.append(pair)

	_check("无**新出现**的同级重叠（基线已登记 %d 组）" % known.size(), newly.size(), 0)
	for pair in newly:
		var d: Dictionary = _overlaps[pair]
		print("       ★ 新重叠：%s × %s" % [d["a"], d["b"]])
		print("         父节点 = %s" % d["parent"])
		print("         %s rect = %s" % [d["a"], d["rect_a"]])
		print("         %s rect = %s" % [d["b"], d["rect_b"]])
		print("         交集   = %s" % d["hit"])

	# 反向：基线里有、这次没了 —— 说明修好了，应该把基线收紧（提示而非失败）
	var vanished := []
	for pair in known.keys():
		if not _overlaps.has(pair):
			vanished.append(pair)
	if vanished.size() > 0:
		print("— 提示：基线里有 %d 组重叠这次不再重叠（多半是修好了）：" % vanished.size())
		for pair in vanished:
			print("    %s" % pair)
		print("    处置：人工确认后重跑 --init 收紧基线，别留过期条目。")


func _write_baseline() -> void:
	var payload := {
		"note": "由 geom_assertions.gd --init 生成。人工确认过才能作为基线。新增条目要写清理由。",
		"viewport": "%dx%d" % [int(VIEW_W), int(VIEW_H)],
		"scene": SCENE_PATH,
		"overlaps": _overlaps,
	}
	var f := FileAccess.open(BASELINE_PATH, FileAccess.WRITE)
	if f == null:
		print("[FAIL] 写不了基线 %s（错误 %d）" % [BASELINE_PATH, FileAccess.get_open_error()])
		_failed += 1
		return
	f.store_string(JSON.stringify(payload, "  "))
	f.close()
	print("已写入基线：%s（%d 组重叠）—— 请人工过一眼再提交" % [BASELINE_PATH, _overlaps.size()])
	print("—— 通过 %d 项 / 失败 %d 项（--init 模式不判定）——" % [_passed, _failed])


func _check_tap_targets(controls: Array) -> void:
	var bad := 0
	for c in controls:
		var ctrl := c as Control
		if _ignored(ctrl):
			continue
		if not _is_clickable(ctrl):
			continue
		var r := ctrl.get_global_rect()
		var shortest := minf(r.size.x, r.size.y)
		if shortest < MIN_TAP_SIZE:
			bad += 1
			print("[FAIL] 点按目标过小：%s（最短边 %.1f < %.0f）" % [_path_of(ctrl), shortest, MIN_TAP_SIZE])
	_check("点按目标都 ≥ %.0f px" % MIN_TAP_SIZE, bad, 0)


func _check_canvas_layers() -> void:
	var layers := _collect_canvas_layers(_main)
	_check("场景里存在 CanvasLayer（HUD 有独立层）", layers.size() > 0, true)
	var bad := 0
	for lnode in layers:
		var l := lnode as CanvasLayer
		if l.layer < 0 or l.layer > 100:
			bad += 1
			print("[FAIL] CanvasLayer 层号越界：%s（layer=%d）" % [_path_of(l), l.layer])
	_check("CanvasLayer 层号都在 [0,100]", bad, 0)


# ============================== 小工具 ==============================

func _collect_canvas_layers(node: Node) -> Array:
	var out := []
	if node is CanvasLayer:
		out.append(node)
	for child in node.get_children():
		out.append_array(_collect_canvas_layers(child))
	return out


func _is_clickable(ctrl: Control) -> bool:
	if ctrl is BaseButton:
		return true
	for sig in CLICK_SIGNALS:
		if ctrl.has_signal(sig):
			return true
	return false


func _ignored(ctrl: Control) -> bool:
	for w in IGNORE_NODES:
		if _name_of(ctrl) == w or _path_of(ctrl) == w:
			return true
	return false


func _rect_str(r: Rect2) -> String:
	return "(%.0f,%.0f %.0fx%.0f)" % [r.position.x, r.position.y, r.size.x, r.size.y]


func _path_of(node: Node) -> String:
	return str(node.get_path()) if node.is_inside_tree() else String(node.name)


func _name_of(node: Node) -> String:
	return String(node.name)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])
