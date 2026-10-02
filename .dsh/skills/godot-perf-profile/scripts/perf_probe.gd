extends SceneTree

## godot-perf-profile / A 路 · 桌面 headless 性能与泄漏探针
##
## 采什么：对象数、节点数、静态内存的**曲线**（首值 → 末值 → 增量），外加按类名分的节点直方图。
## 不采什么：**帧时间 / FPS / 绘制调用** —— `--headless` 不渲染，这些值没有意义（全是 0）。
##           要帧时间请走真机 dumpsys gfxinfo（见技能 SKILL.md 的 B 路）。
##
## 用法：
##   godot --headless --path <proj> --log-file <工作区内可写路径> \
##         --script <本文件> [-- --seconds 20 --interval 0.5 --scene res://scenes/gameplay/Main.tscn]
##
## 退出码：0 = 跑完（不判定好坏，判定交给人比曲线）。
##
## ⚠ 与 tools/run_integration_headless.gd 同样的硬约束：本脚本的编译早于 autoload 注册，
##    因此不能编译期引用 EventBus / Player / Enemy / CaptureZone / QuestSystem。

const DEF_SECONDS := 20.0
const DEF_INTERVAL := 0.5
const DEF_SCENE := "res://scenes/gameplay/Main.tscn"

var _main: Node = null
var _scene_path := DEF_SCENE
var _seconds := DEF_SECONDS
var _interval := DEF_INTERVAL
var _elapsed := 0.0
var _next_sample := 0.0
var _samples: Array = []
var _done := false


func _initialize() -> void:
	var argv := OS.get_cmdline_user_args()
	var i := 0
	while i < argv.size():
		match argv[i]:
			"--seconds": _seconds = float(argv[i + 1]); i += 2
			"--interval": _interval = float(argv[i + 1]); i += 2
			"--scene": _scene_path = argv[i + 1]; i += 2
			_: i += 1

	print("===== perf_probe（headless：只采对象/节点/内存，不采帧时间）=====")
	print("场景=%s  采样时长=%.1fs  采样间隔=%.2fs" % [_scene_path, _seconds, _interval])
	print("渲染口径：headless 无渲染 ⇒ TIME_FPS / 绘制调用 本口径不采（见技能 B 路真机口径）")

	var packed: PackedScene = load(_scene_path)
	if packed == null:
		print("！！ 加载不到 %s" % _scene_path)
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
	if _elapsed >= _next_sample:
		_sample()
		_next_sample += _interval
	if _elapsed >= _seconds:
		_done = true
		_report()
		quit(0)
	return false


func _sample() -> void:
	_samples.append({
		"t": _elapsed,
		"objects": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"nodes": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		"orphans": int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)),
		"mem_static": int(Performance.get_monitor(Performance.MEMORY_STATIC)),
		"mem_static_max": int(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)),
	})


func _report() -> void:
	if _samples.is_empty():
		print("！！ 一个采样点都没采到（采样时长 %.1fs < 间隔 %.2fs？）" % [_seconds, _interval])
		return

	var first: Dictionary = _samples[0]
	var last: Dictionary = _samples[_samples.size() - 1]

	print("\n— 采样 %d 点 / 共 %.1fs" % [_samples.size(), _elapsed])

	var keys := [
		["objects", "ENGINE_OBJECT_COUNT（泄漏首选指标）"],
		["nodes", "OBJECT_NODE_COUNT"],
		["orphans", "OBJECT_ORPHAN_NODE_COUNT（孤儿节点）"],
		["mem_static", "MEMORY_STATIC"],
		["mem_static_max", "MEMORY_STATIC_MAX"],
	]
	for entry in keys:
		var k: String = entry[0]
		var label: String = entry[1]
		var a: int = first[k]
		var b: int = last[k]
		var d := b - a
		var sign_s := "+" if d >= 0 else ""
		# 每行的趋势：把整条曲线压成一行方便看走势
		var spark := _sparkline(k)
		print("  %-38s 首=%-12s 末=%-12s 增量=%s%s   %s" % [
			label, _fmt(a), _fmt(b), sign_s, _fmt(d), spark])

	print("\n— 内存换算（便于读）")
	print("  MEMORY_STATIC      首 %.1f MiB → 末 %.1f MiB" % [
		float(first["mem_static"]) / 1048576.0, float(last["mem_static"]) / 1048576.0])
	print("  MEMORY_STATIC_MAX  首 %.1f MiB → 末 %.1f MiB" % [
		float(first["mem_static_max"]) / 1048576.0, float(last["mem_static_max"]) / 1048576.0])

	# 泄漏提示：对象数只涨不落
	var obj_delta: int = last["objects"] - first["objects"]
	var monotonic := true
	for i in range(1, _samples.size()):
		if _samples[i]["objects"] < _samples[i - 1]["objects"]:
			monotonic = false
			break
	if monotonic and obj_delta > 0 and _samples.size() >= 4:
		print("\n  ⚠ ENGINE_OBJECT_COUNT 全程单调上升（+%d）—— 疑似对象/节点泄漏，重点查信号连接与 new() 未 free。" % obj_delta)
	elif obj_delta > 0:
		print("\n  · 对象数有涨有落（净 +%d）—— 正常波动范围内的缓存/池化行为。" % obj_delta)
	else:
		print("\n  · 对象数净变化 %d，未见增长性泄漏迹象。" % obj_delta)

	print("\n— 场景树节点按类名 Top 20（谁在涨一眼看出）")
	var hist := _class_histogram(_main)
	var pairs := []
	for k in hist.keys():
		pairs.append([k, hist[k]])
	pairs.sort_custom(func(x, y): return x[1] > y[1])
	var shown := 0
	for p in pairs:
		if shown >= 20:
			break
		print("  %-28s %d" % [p[0], p[1]])
		shown += 1

	print("\n— 判定纪律提醒")
	print("  · 单点内存没有可比性：要比就比同场景/同时长/同采样点的曲线。")
	print("  · 启动后先涨后平是正常的；只涨不落才叫泄漏。")
	print("  · 帧时间/卡顿请走真机 dumpsys gfxinfo（技能 SKILL.md B 路）。")


func _sparkline(key: String) -> String:
	# 把曲线压成 24 段火花线，只看走势
	var n := _samples.size()
	if n == 0:
		return ""
	var blocks := "▁▂▃▄▅▆▇█"
	var vals := []
	for s in _samples:
		vals.append(float(s[key]))
	var lo: float = vals.min()
	var hi: float = vals.max()
	if is_equal_approx(hi, lo):
		return "（全程恒定 %s）" % _fmt(int(lo))
	var out := ""
	var segs := 24
	for b in range(segs):
		var i0 := int(float(b) * n / segs)
		var i1 := int(float(b + 1) * n / segs)
		if i1 <= i0:
			i1 = i0 + 1
		if i0 >= n:
			break
		var seg_max := -INF
		for i in range(i0, min(i1, n)):
			seg_max = maxf(seg_max, vals[i])
		var t := (seg_max - lo) / (hi - lo)
		var idx := clampi(int(t * 7.0), 0, 7)
		out += blocks[idx]
	return out


func _class_histogram(node: Node) -> Dictionary:
	var hist := {}
	_walk(node, hist)
	return hist


func _walk(node: Node, hist: Dictionary) -> void:
	var cls := node.get_class()
	hist[cls] = int(hist.get(cls, 0)) + 1
	for c in node.get_children():
		_walk(c, hist)


func _fmt(v: int) -> String:
	# 大数加千分位，读起来不费劲
	var s := str(absi(v))
	var out := ""
	var cnt := 0
	for i in range(s.length() - 1, -1, -1):
		out = s[i] + out
		cnt += 1
		if cnt % 3 == 0 and i > 0:
			out = "," + out
	return ("-" if v < 0 else "") + out
