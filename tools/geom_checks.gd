extends RefCounted

## 几何断言的可复用实现（visual-regression / A 路 · headless 可跑）
##
## 为什么抽出来：Main.tscn 的 HUD 门禁（tools/geom_assertions.gd）与游戏外壳各屏幕的门禁
## （tools/screen_geom_check.gd）必须跑**同一套**规则。抄一份 = 两份规则迟早对不上。
##
## 本文件只负责「算」，不负责「驱动」：谁调用谁负责建场景、决定要查哪些状态、基线写哪里。
## 断言口径（与 visual-regression 技能一致，不许为了让断言变绿而放宽）：
##   ① 不出屏          每个可见 Control 的 global_rect 落在 (0,0,view_w,view_h) 内（容差 OFFSCREEN_TOLERANCE）
##   ② 同级不重叠      同一父节点下的可见 Control 两两不相交；Container 的子节点跳过（重叠是布局器的意图）
##   ③ 点按目标够大    带点击语义的控件最短边 >= MIN_TAP_SIZE
##   ④ CanvasLayer    层号在 [0,100]
##   ⑤ 子控件不越界    非 Container 的父控件，其可见子 Control 必须落在父的 rect 内（容差 OVERFLOW_TOLERANCE）
##
## ⑤ 为什么必须有（2026-10-07 真机验收抓到）：①②③ 只比「同级」—— QuestCard 的 4 行文字压在
## 下方按钮行上时，父子关系完全合规、三条断言全绿，而真机截图里肉眼可见地压字。
## 那条 bug 的根因就是「内层 Label 320×105 装进了 300×96 的卡片、且没人裁剪」。
##
## key_prefix：多状态门禁用。把「状态名」并进重叠对的键，免得两个屏幕上同名的控件互相顶掉基线条目。
## 刻意不写 class_name：引用方 preload。

const OFFSCREEN_TOLERANCE := 1.0
const MIN_TAP_SIZE := 32.0
## 子控件越出父容器的容差（px）：亚像素舍入不算越界
const OVERFLOW_TOLERANCE := 1.0
## 带点击语义的信号名 —— 有其一就按「可点控件」检查最小尺寸
const CLICK_SIGNALS := ["pressed", "button_down", "button_up", "toggled"]

var view_w := 960.0
var view_h := 540.0
## 有意重叠/出屏的装饰层白名单（按节点名或完整路径匹配）。**每加一条都要写理由。**
var ignore_nodes: Array = []
## 重叠对键的前缀（多屏幕门禁用）
var key_prefix := ""

var passed := 0
var failed := 0
var overlaps := {}


## 每个状态开始前调一次：计数器与重叠表都得清，否则状态之间会串味
func reset_counters() -> void:
	passed = 0
	failed = 0
	overlaps = {}


func check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		passed += 1
		print("[OK]   %s" % title)
	else:
		failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func check_true(title: String, condition: bool) -> void:
	check(title, condition, true)


# ============================== 断言主体 ==============================

## 一次跑完全部五条断言（view 尺寸 + 白名单 + 前缀必须先在实例上设好）
func run_all(root_node: Node, baseline_path: String, notes: Dictionary,
		init_mode: bool, strict: bool) -> void:
	var controls := collect_controls(root_node)
	print("%s— 采集到可见 Control %d 个（视口 %.0fx%.0f）"
			% [key_prefix, controls.size(), view_w, view_h])
	check_no_offscreen(controls)
	collect_overlaps(controls)
	check_overlaps_against_baseline(baseline_path, notes, init_mode, strict)
	check_tap_targets(controls)
	check_canvas_layers(root_node)
	check_child_overflow(root_node)


func collect_controls(node: Node) -> Array:
	var out := []
	if node is Control:
		var c := node as Control
		if c.is_visible_in_tree():
			var r := c.get_global_rect()
			if r.size.x > 0.0 and r.size.y > 0.0:
				out.append(c)
	for child in node.get_children():
		out.append_array(collect_controls(child))
	return out


func check_no_offscreen(controls: Array) -> void:
	var bad := 0
	for c in controls:
		var ctrl := c as Control
		if ignored(ctrl):
			continue
		var r := ctrl.get_global_rect()
		var inside := r.position.x >= -OFFSCREEN_TOLERANCE \
			and r.position.y >= -OFFSCREEN_TOLERANCE \
			and (r.position.x + r.size.x) <= view_w + OFFSCREEN_TOLERANCE \
			and (r.position.y + r.size.y) <= view_h + OFFSCREEN_TOLERANCE
		if not inside:
			bad += 1
			print("[FAIL] 出屏：%s" % path_of(ctrl))
			print("       rect = %s（视口 %.0fx%.0f）" % [str(r), view_w, view_h])
	check("%s不出屏（%d 个可见 Control）" % [key_prefix, controls.size()], bad, 0)


## ⑤ 子控件不越出父容器（非 Container 的父子关系才算；Container 的排布是布局器的意图）
func check_child_overflow(root_node: Node) -> void:
	var bad := 0
	for c in collect_controls(root_node):
		var child := c as Control
		var parent := child.get_parent()
		if not (parent is Control) or parent is Container:
			continue
		var pctrl := parent as Control
		if ignored(child) or ignored(pctrl):
			continue
		var rc := child.get_global_rect()
		var rp := pctrl.get_global_rect()
		var over_x := maxf(rp.position.x - rc.position.x,
				(rc.position.x + rc.size.x) - (rp.position.x + rp.size.x))
		var over_y := maxf(rp.position.y - rc.position.y,
				(rc.position.y + rc.size.y) - (rp.position.y + rp.size.y))
		if over_x > OVERFLOW_TOLERANCE or over_y > OVERFLOW_TOLERANCE:
			bad += 1
			print("[FAIL] 子控件越出父容器：%s" % path_of(child))
			print("       child=%s" % rect_str(rc))
			print("       parent=%s  越界 %.1f x %.1f px" % [rect_str(rp), over_x, over_y])
	check("%s子控件不越出父容器" % key_prefix, bad, 0)


func collect_overlaps(controls: Array) -> void:
	# 只在「同一父节点的直接 Control 子节点」之间两两比：跨层级的父子包含是正常嵌套。
	# 由 Container 排布的子节点跳过（重叠是布局器的意图）。
	var by_parent := {}
	for c in controls:
		var ctrl := c as Control
		if ignored(ctrl):
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
				var pair := "%s%s|%s" % [key_prefix, name_of(a), name_of(b)]
				overlaps[pair] = {
					"a": path_of(a), "b": path_of(b), "parent": key,
					"rect_a": rect_str(ra), "rect_b": rect_str(rb),
					"hit": rect_str(hit),
				}


func check_overlaps_against_baseline(baseline_path: String, notes: Dictionary,
		init_mode: bool, strict: bool) -> void:
	print("%s— 可见同级重叠对：%d 组" % [key_prefix, overlaps.size()])

	if init_mode:
		write_baseline(baseline_path, notes)
		return

	if strict:
		for pair in overlaps.keys():
			var d: Dictionary = overlaps[pair]
			print("[FAIL] 重叠（strict）：%s × %s" % [d["a"], d["b"]])
			print("       hit = %s" % d["hit"])
		check("%sstrict：无任何可见同级重叠" % key_prefix, overlaps.size(), 0)
		return

	# 默认：与基线比对。基线不存在 ⇒ 不让它变成隐形通过。
	if not FileAccess.file_exists(baseline_path):
		print("[FAIL] 找不到基线 %s —— 先用 --init 生成并人工确认，之后才能做「新重叠才失败」的比对"
				% baseline_path)
		failed += 1
		return
	var raw := FileAccess.get_file_as_string(baseline_path)
	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY or not (parsed as Dictionary).has("overlaps"):
		print("[FAIL] 基线 %s 格式不对（要 {\"overlaps\": {...}}）" % baseline_path)
		failed += 1
		return
	var known: Dictionary = parsed["overlaps"]
	# 让「账」可见：有意 / 无意待修 各几条（定案来自基线 verdict 字段）
	var on_purpose := 0
	var to_fix := 0
	var unclassified := 0
	for pair in known.keys():
		var verdict := String((known[pair] as Dictionary).get("verdict", ""))
		if verdict.begins_with("有意"):
			on_purpose += 1
		elif verdict.begins_with("无意"):
			to_fix += 1
		else:
			unclassified += 1
	print("%s— 已知重叠 %d 组：有意 %d / 无意待修 %d / 未归类 %d（定案见基线的 verdict）"
			% [key_prefix, known.size(), on_purpose, to_fix, unclassified])

	var newly := []
	for pair in overlaps.keys():
		if not known.has(pair):
			newly.append(pair)

	check("%s无**新出现**的同级重叠（基线已登记 %d 组）" % [key_prefix, known.size()], newly.size(), 0)
	for pair in newly:
		var d: Dictionary = overlaps[pair]
		print("       ★ 新重叠：%s × %s" % [d["a"], d["b"]])
		print("         父节点 = %s" % d["parent"])
		print("         %s rect = %s" % [d["a"], d["rect_a"]])
		print("         %s rect = %s" % [d["b"], d["rect_b"]])
		print("         交集   = %s" % d["hit"])

	# 反向：基线里有、这次没了 —— 说明修好了，应该把基线收紧（提示而非失败）
	var vanished := []
	for pair in known.keys():
		if not overlaps.has(pair):
			vanished.append(pair)
	if vanished.size() > 0:
		print("%s— 提示：基线里有 %d 组重叠这次不再重叠（多半是修好了）：" % [key_prefix, vanished.size()])
		for pair in vanished:
			print("    %s" % pair)
		print("    处置：人工确认后重跑 --init 收紧基线，别留过期条目。")


## 把 notes 的定案并进每条记录（--init 时调用）⇒ 下次 --init 不会把 verdict 抹掉
func overlaps_with_verdicts(notes: Dictionary) -> Dictionary:
	var out := {}
	for pair in overlaps.keys():
		var entry: Dictionary = (overlaps[pair] as Dictionary).duplicate()
		entry["verdict"] = notes.get(pair,
				"未归类 —— 新出现的重叠必须先定案（有意 / 无意 + 一句理由），再 --init")
		out[pair] = entry
	return out


func write_baseline(baseline_path: String, notes: Dictionary) -> void:
	var payload := {
		"note": "由几何门禁 --init 生成。人工确认过才能作为基线。新增条目要写清理由。",
		"viewport": "%dx%d" % [int(view_w), int(view_h)],
		"key_prefix": key_prefix,
		"overlaps": overlaps_with_verdicts(notes),
	}
	var f := FileAccess.open(baseline_path, FileAccess.WRITE)
	if f == null:
		print("[FAIL] 写不了基线 %s（错误 %d）" % [baseline_path, FileAccess.get_open_error()])
		failed += 1
		return
	f.store_string(JSON.stringify(payload, "  "))
	f.close()
	var unclassified := 0
	for pair in overlaps.keys():
		if not notes.has(pair):
			unclassified += 1
	print("已写入基线：%s（%d 组重叠，其中未归类 %d 组）—— 请人工过一眼再提交"
			% [baseline_path, overlaps.size(), unclassified])
	print("逐条定案（有意 / 无意）见驱动脚本里的 BASELINE_NOTES —— 新出现的重叠必须补一条再 --init")
	print("—— 通过 %d 项 / 失败 %d 项（--init 模式不判定）——" % [passed, failed])


func check_tap_targets(controls: Array) -> void:
	var bad := 0
	for c in controls:
		var ctrl := c as Control
		if ignored(ctrl):
			continue
		if not is_clickable(ctrl):
			continue
		var r := ctrl.get_global_rect()
		var shortest := minf(r.size.x, r.size.y)
		if shortest < MIN_TAP_SIZE:
			bad += 1
			print("[FAIL] 点按目标过小：%s（最短边 %.1f < %.0f）" % [path_of(ctrl), shortest, MIN_TAP_SIZE])
	check("%s点按目标都 ≥ %.0f px" % [key_prefix, MIN_TAP_SIZE], bad, 0)


func check_canvas_layers(root_node: Node) -> void:
	var layers := collect_canvas_layers(root_node)
	check("%s场景里存在 CanvasLayer（HUD 有独立层）" % key_prefix, layers.size() > 0, true)
	var bad := 0
	for lnode in layers:
		var l := lnode as CanvasLayer
		if l.layer < 0 or l.layer > 100:
			bad += 1
			print("[FAIL] CanvasLayer 层号越界：%s（layer=%d）" % [path_of(l), l.layer])
	check("%sCanvasLayer 层号都在 [0,100]" % key_prefix, bad, 0)


# ============================== 小工具 ==============================

func collect_canvas_layers(node: Node) -> Array:
	var out := []
	if node is CanvasLayer:
		out.append(node)
	for child in node.get_children():
		out.append_array(collect_canvas_layers(child))
	return out


func is_clickable(ctrl: Control) -> bool:
	if ctrl is BaseButton:
		return true
	for sig in CLICK_SIGNALS:
		if ctrl.has_signal(sig):
			return true
	return false


func ignored(ctrl: Control) -> bool:
	for w in ignore_nodes:
		if name_of(ctrl) == w or path_of(ctrl) == w:
			return true
	return false


func rect_str(r: Rect2) -> String:
	return "(%.0f,%.0f %.0fx%.0f)" % [r.position.x, r.position.y, r.size.x, r.size.y]


func path_of(node: Node) -> String:
	return str(node.get_path()) if node.is_inside_tree() else String(node.name)


func name_of(node: Node) -> String:
	return String(node.name)
