extends Node

## 【临时 · 100 fps 冲刺探针】一次运行扫三轴，跑完可删
##
## 为什么要有它（2026-10-05 真机实测）：本包被华为 FrameRateManager 钉在 **60 Hz**——
##   adb 里 "FrameRateManager: set active config - fps 60"、mActiveModeId=1、SurfaceFlinger
##   报 period_ns=16666666（16.67 ms）。面板本身支持 60/120/144（supportedModes id=1/2/3），
##   但系统的 appRequestRefreshRateRange=[0 Infinity] 要**应用自己请求**才会给高刷。
##   ⇒ 「FPS 100」的头号前提不是优化，而是**先把 surface 请求到 120 Hz**。
##
## 三轴（每轴只改一个自变量，窗口时长固定，便于横向比）：
##   ① 呈现：Engine.max_fps / vsync_mode —— 验证「max_fps>0 会不会让系统切到 120 Hz」
##   ② 像素预算：content_scale_mode/size —— 2880x1920 (5.53 Mpx) → 960x540 (0.52 Mpx)
##   ③ 仿真：Engine.physics_ticks_per_second —— 60（满 AI）→ 1（只渲染）/ 30（已拍板可降）
##
## 口径纪律：真机帧时间一律引擎自报（dumpsys gfxinfo 对 Godot 结构性无效，见 PerfOverlay.gd 头部）。
## 每窗一行，变体切换单独一行，便于从 logcat 直接读。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
## M1（施工单 改动1.md §4）：变体名写进 CSV 的 tag 列，这样一份 CSV 里能按变体分组复算分位数。
## 正常对局那条路径由 ui/PerfOverlay.gd 负责开写（tag 保持默认 "match"）。
const PerfCsv := preload("res://systems/debug/PerfCsvWriter.gd")

const WINDOW_S := 2.5      # 每个变体采样窗口（秒）
const WARMUP_S := 3.0      # 起对局后的预热：地图 / 纹理上传 / 铺开

## 自变量表：-1 = 本项不动；mode="" = 不动
const VARIANTS: Array = [
	{"name": "01_base_maxfps0_vsync_on", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60},
	{"name": "02_maxfps120_vsync_off", "max_fps": 120, "vsync": 0, "mode": "", "size": Vector2i.ZERO, "phys": 60},
	{"name": "03_maxfps100_mailbox", "max_fps": 100, "vsync": 3, "mode": "", "size": Vector2i.ZERO, "phys": 60},
	{"name": "04_px960x540_maxfps120", "max_fps": 120, "vsync": 0, "mode": "viewport", "size": Vector2i(960, 540), "phys": 60},
	{"name": "05_render_only_px960_phys1", "max_fps": 120, "vsync": 0, "mode": "viewport", "size": Vector2i(960, 540), "phys": 1},
	{"name": "06_sim_only_hide_all", "max_fps": 120, "vsync": 0, "mode": "viewport", "size": Vector2i(960, 540), "phys": 60, "hide": true},
	{"name": "07_phys30_canvasitems", "max_fps": 120, "vsync": 0, "mode": "canvas_items", "size": Vector2i.ZERO, "phys": 30},
	{"name": "08_best_guess_px960_phys30_mf100", "max_fps": 100, "vsync": 3, "mode": "viewport", "size": Vector2i(960, 540), "phys": 30},
	# 2026-10-05 轨 2 新增：物理两参数在真机上的效果（桌面 v3 探针：cap1 把最大帧 49.9→33.0 ms，
	# jitter0 把 p50 1.389→0.698 ms）。与 01_base 同口径，只差这两项。
	{"name": "09_jitter0", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60, "jitter": 0.0},
	{"name": "10_cap1", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60, "cap": 1},
	# 2026-10-06 M2 复测：真机首轮里 01 是第 1 窗、09/10 是最后两窗，而运行内漂移实测可达 +68%
	# （见 docs/性能预算.md 第十八节 M3）⇒ 直接比 01 vs 10 会把漂移算进"变体收益"。
	# 这里给 09/10 **各夹一对基线**，用「前后相邻基线均值」当参考，把漂移压到一阶小量。
	# 11 与 01 参数完全一致 ⇒ 11 vs 01 的差就是这段运行内的纯漂移。
	{"name": "11_base_again_a", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60},
	{"name": "12_jitter0_again", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60, "jitter": 0.0},
	{"name": "13_base_again_b", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60},
	{"name": "14_cap1_again", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60, "cap": 1},
	{"name": "15_base_again_c", "max_fps": 0, "vsync": 1, "mode": "", "size": Vector2i.ZERO, "phys": 60},
]

var _main = null
var _samples: Array = []
var _elapsed := 0.0
var _window := 0.0
var _last_phys := 0
var _index := -1
var _hidden: Array = []


func _ready() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	_main = (load("res://scenes/gameplay/Main.tscn") as PackedScene).instantiate()
	_main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(_main)
	print("[探针] 起对局：敌人 %d、队友 %d | 屏幕 %s refresh=%.1fHz | 初始 vsync=%d max_fps=%d phys_hz=%d" % [
			_main.enemy_count, MatchRulesScript.ally_count(),
			str(DisplayServer.screen_get_size()), DisplayServer.screen_get_refresh_rate(),
			DisplayServer.window_get_vsync_mode(), Engine.get_max_fps(), Engine.physics_ticks_per_second])


func _process(delta: float) -> void:
	_elapsed += delta
	if _index < 0:
		if _elapsed < WARMUP_S:
			return
		_elapsed = 0.0
		_advance(0)
		return
	_window += delta
	_samples.append(delta * 1000.0)
	# M1：本场景自己驱动逐帧落盘（不经过 MatchHost ⇒ 没有 PerfOverlay）
	PerfCsv.frame("sweep", delta)
	if _window < WINDOW_S:
		return
	_window = 0.0
	_report()
	if _index + 1 < VARIANTS.size():
		_advance(_index + 1)
	else:
		print("[探针] 扫描结束")
		set_process(false)
		PerfCsv.stop()
		_restore_defaults()
		# 扫完主动退出：真机上用 logcat 判定「扫完了」而不是被系统挂起；headless 里也一样
		get_tree().quit(0)


## 退出前把动过的全局口径还原，避免「探针跑完把工程留在怪状态」这种坑
func _restore_defaults() -> void:
	_unhide_scene_tree()
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	Engine.max_fps = 0
	Engine.physics_ticks_per_second = 60
	Engine.max_physics_steps_per_frame = 2
	Engine.physics_jitter_fix = 0.5
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	print("[探针] 已还原默认口径（vsync=1 max_fps=0 phys=60 canvas_items）")


func _advance(i: int) -> void:
	_index = i
	var v: Dictionary = VARIANTS[i]
	# 幂等；overlay 若已开写则保持它的 driver（本场景不经过 MatchHost，通常没有 overlay）
	PerfCsv.tag = str(v["name"])
	PerfCsv.start("sweep")
	var note := ""
	if int(v.get("hide", false)) != 0:
		note += _hide_scene_tree()
	else:
		note += _unhide_scene_tree()
	if int(v["vsync"]) >= 0:
		DisplayServer.window_set_vsync_mode(int(v["vsync"]))
	Engine.max_fps = int(v["max_fps"])
	if str(v["mode"]) == "viewport":
		var w := get_window()
		w.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
		w.content_scale_size = v["size"]
	elif str(v["mode"]) == "canvas_items":
		var w2 := get_window()
		w2.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	var phys := int(v["phys"])
	Engine.physics_ticks_per_second = phys
	var steps_cap := 2 if phys > 2 else 1
	if v.has("cap"):
		steps_cap = int(v["cap"])
	Engine.max_physics_steps_per_frame = steps_cap
	Engine.physics_jitter_fix = float(v["jitter"]) if v.has("jitter") else 0.5
	_samples.clear()
	print("[探针·变体] %s | 请求 max_fps=%d vsync=%d mode=%s size=%s phys=%d cap=%d jitter=%.2f %s" % [
			v["name"], Engine.get_max_fps(), DisplayServer.window_get_vsync_mode(),
			str(get_window().content_scale_mode), str(get_window().content_scale_size), phys,
			Engine.max_physics_steps_per_frame, Engine.physics_jitter_fix, note])


func _report() -> void:
	var sorted := _samples.duplicate()
	sorted.sort()
	var count := sorted.size()
	if count == 0:
		return
	var phys_total := Engine.get_physics_frames()
	var steps := phys_total - _last_phys
	_last_phys = phys_total
	var p50: float = sorted[int(float(count) * 0.5)]
	var p90: float = sorted[mini(int(float(count) * 0.9), count - 1)]
	var p99: float = sorted[mini(int(float(count) * 0.99), count - 1)]
	print("[测帧] %s | 帧数=%d fps=%.1f steps=%.1f/帧 | p50=%.1f p90=%.1f p99=%.1f max=%.1f ms | PROC=%.1f PHYS=%.1f | draw=%d robj=%d prim=%d nodes=%d objs=%d mem=%.1fMB | refresh=%.1fHz vsync=%d maxfps=%d" % [
			VARIANTS[_index]["name"], count, Engine.get_frames_per_second(),
			float(steps) / maxf(float(count), 1.0), p50, p90, p99, sorted[count - 1],
			float(Performance.get_monitor(Performance.TIME_PROCESS)) * 1000.0,
			float(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0,
			int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
			int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)),
			int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)),
			int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
			int(Performance.get_monitor(Performance.OBJECT_COUNT)),
			float(Performance.get_monitor(Performance.MEMORY_STATIC)) / 1048576.0,
			DisplayServer.screen_get_refresh_rate(),
			DisplayServer.window_get_vsync_mode(), Engine.get_max_fps()])


## 「只仿真」变体：把整棵树上所有 CanvasItem / CanvasLayer 藏起来（渲染≈0），保留 AI 与物理
func _hide_scene_tree() -> String:
	_hidden.clear()
	var stack: Array = [get_tree().root]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is CanvasLayer or n is CanvasItem:
			if n.visible:
				n.visible = false
				_hidden.append(n)
		for c in n.get_children():
			stack.append(c)
	return "已隐藏视觉节点 %d 个" % _hidden.size()


func _unhide_scene_tree() -> String:
	if _hidden.is_empty():
		return "视觉节点本就可见"
	var n := _hidden.size()
	for node in _hidden:
		if is_instance_valid(node):
			node.visible = true
	_hidden.clear()
	return "已恢复视觉节点 %d 个" % n
