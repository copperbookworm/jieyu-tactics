extends Node

## 【临时 · 真机帧时间对照实验，跑完就删】
## 对照设计：同一个 FPS 记录器，只换启动目标 —— 起大厅（几个 Control 节点、几乎无 AI）
## 还是起 20v20 对局。用来分清「设备限帧」还是「我们的负载」：
##   大厅也 ~7 fps ⇒ 设备/策略限帧；大厅 60 fps 而对局 7.6 ⇒ 是我们的负载。
## 背景：dumpsys gfxinfo 对 Godot 结构性无效（SurfaceView 不进 HWUI，永远 0 帧 + 4950 ms 占位），
## 所以真机帧时间用引擎自报：_process 逐帧收 delta，每 5 s 打 p50/p95/p99/max + Engine FPS。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const BOOT_LOBBY := false     # true = 对照组（大厅）；false = 实验组（20 v 20 对局）
const WINDOW_S := 3.0

var _samples: Array = []
var _elapsed := 0.0
var _window := 0.0
var _last_phys := 0


func _ready() -> void:
	if BOOT_LOBBY:
		add_child((load("res://scenes/app/App.tscn") as PackedScene).instantiate())
		print("[测量包] 对照组：已起大厅 App.tscn")
		return
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var main = (load("res://scenes/gameplay/Main.tscn") as PackedScene).instantiate()
	main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(main)
	print("[测量包] 实验组：已按 PVP_CASUAL 起对局（敌人 %d、队友 %d）"
			% [main.enemy_count, MatchRulesScript.ally_count()])


func _process(delta: float) -> void:
	_elapsed += delta
	_window += delta
	_samples.append(delta * 1000.0)
	if _window < WINDOW_S:
		return
	_window = 0.0
	var sorted := _samples.duplicate()
	sorted.sort()
	var count := sorted.size()
	_samples.clear()
	if count == 0:
		return
	var p50: float = sorted[int(float(count) * 0.5)]
	var p90: float = sorted[mini(int(float(count) * 0.9), count - 1)]
	var p95: float = sorted[mini(int(float(count) * 0.95), count - 1)]
	var p99: float = sorted[mini(int(float(count) * 0.99), count - 1)]
	# 2026-10-05：帧时间要与「引擎侧拆解」同一行打出来 —— 否则分不清是仿真还是渲染。
	# steps = 这一窗里物理步进了几次：帧慢时 Godot 会一帧补跑多个物理步（默认上限 8），
	# 而单位的 _physics_process（AI / 通视）在**每个**物理步里都跑一遍 ⇒ 帧越慢、AI 跑得越多（死亡螺旋）。
	var phys_total := Engine.get_physics_frames()
	var steps := phys_total - _last_phys
	_last_phys = phys_total
	print("[测帧] t=%.0fs 帧数=%d fps=%.1f steps=%d(%.1f/帧) | p50=%.1f p90=%.1f p95=%.1f p99=%.1f max=%.1f ms | PROC=%.1f PHYS=%.1f | draw=%d robj=%d nodes=%d objs=%d mem=%.1fMB" % [
			_elapsed, count, Engine.get_frames_per_second(), steps,
			float(steps) / maxf(float(count), 1.0),
			p50, p90, p95, p99,
			sorted[count - 1],
			float(Performance.get_monitor(Performance.TIME_PROCESS)) * 1000.0,
			float(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0,
			int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
			int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)),
			int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
			int(Performance.get_monitor(Performance.OBJECT_COUNT)),
			float(Performance.get_monitor(Performance.MEMORY_STATIC)) / 1048576.0])
