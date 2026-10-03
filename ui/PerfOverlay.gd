extends CanvasLayer

## 真机帧率 / 帧时间读数（**仅调试包**）
##
## 为什么要有它：godot-perf-profile 的 B 路权威口径是 dumpsys gfxinfo，但它在**本项目的真机上取不到数** ——
## HUAWEI PCE-W30 / HarmonyOS 上 Godot 用 SurfaceView 直接画（不走 HWUI），gfxinfo 报 Total frames rendered: 0。
## 所以在调试包里自己把引擎侧的帧率与帧时间显示出来，截图即证据。
##
## 正式包（OS.is_debug_build() 为假）**整段不构建**，与「立刻结束本局」同一条纪律。
##
## 口径说明（别混）：
##   · FPS = Engine.get_frames_per_second()（含 vsync 与渲染，是**真机体验口径**）
##   · 帧时间 = Performance.get_monitor(TIME_PROCESS)（引擎自己统计的一帧处理耗时，ms）
##   · 单位数 = 现场数的敌我活单位，用来证明「这读数是在 20 v 20 下取的」
##
## 刻意不写 class_name：引用方 preload。

const VIEW := Vector2(960.0, 540.0)
const REFRESH := 0.5

var main = null
var _label: Label = null
var _timer := 0.0
var _frames := 0
var _worst_ms := 0.0


func setup(main_node) -> void:
	main = main_node
	layer = 95          # 压在 HUD(1)/地图(10) 之上、AI 参谋(90)/菜单(100) 之下
	process_mode = Node.PROCESS_MODE_ALWAYS
	# 关掉垂直同步并把帧率上限放开：不然 FPS 永远贴着 60，TIME_PROCESS 也≈一个 vsync 周期，
	# 两个数都变成「刷新率」而不是「余量」。调试包才这么做（正式包整段不构建）。
	if OS.is_debug_build():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Engine.max_fps = 0
	var box := ColorRect.new()
	box.color = Color(0.0, 0.0, 0.0, 0.62)
	box.position = Vector2(378.0, 0.0)
	box.size = Vector2(288.0, 22.0)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(box)
	_label = Label.new()
	_label.name = "PerfReadout"
	_label.position = Vector2(382.0, 1.0)
	_label.add_theme_font_size_override("font_size", 13)
	_label.add_theme_color_override("font_color", Color(0.55, 1.0, 0.62))
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label)


func _process(delta: float) -> void:
	_timer += delta
	var ms := float(Performance.get_monitor(Performance.TIME_PROCESS)) * 1000.0
	if ms > _worst_ms:
		_worst_ms = ms
	if _timer < REFRESH:
		return
	_timer = 0.0
	_frames += 1
	var enemy_count := 0
	var ally_count := 0
	var tree := get_tree()
	if tree != null:
		enemy_count = tree.get_nodes_in_group("enemy").size()
		ally_count = tree.get_nodes_in_group("friendly").size()
	var phys := float(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0
	_label.text = "FPS %d（不限帧）｜引擎 %.1f ms（峰 %.0f）｜物理 %.1f ms ｜ 敌 %d 友 %d" % [
			Engine.get_frames_per_second(), ms, _worst_ms, phys, enemy_count, ally_count]
	_worst_ms = 0.0
