extends Node

## 【临时 · 真机帧时间对照实验，跑完就删】
## 对照设计：同一个 FPS 记录器，只换启动目标 —— 起大厅（几个 Control 节点、几乎无 AI）
## 还是起 20v20 对局。用来分清「设备限帧」还是「我们的负载」：
##   大厅也 ~7 fps ⇒ 设备/策略限帧；大厅 60 fps 而对局 7.6 ⇒ 是我们的负载。
## 背景：dumpsys gfxinfo 对 Godot 结构性无效（SurfaceView 不进 HWUI，永远 0 帧 + 4950 ms 占位），
## 所以真机帧时间用引擎自报：_process 逐帧收 delta，每 5 s 打 p50/p95/p99/max + Engine FPS。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const BOOT_LOBBY := true      # true = 对照组（大厅）；false = 实验组（20 v 20 对局）
const WINDOW_S := 5.0

var _samples: Array = []
var _elapsed := 0.0
var _window := 0.0


func _ready() -> void:
	if BOOT_LOBBY:
		add_child((load("res://scenes/app/App.tscn") as PackedScene).instantiate())
		print("[测量包] 对照组：已起大厅 App.tscn")
		return
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	var main = (load("res://scenes/gameplay/Main.tscn") as PackedScene).instantiate()
	main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_RANKED)
	add_child(main)
	print("[测量包] 实验组：已按 PVP_RANKED 起对局（敌人 %d、队友 %d）"
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
	var p50: float = sorted[int(float(count) * 0.5)]
	var p95: float = sorted[mini(int(float(count) * 0.95), count - 1)]
	var p99: float = sorted[mini(int(float(count) * 0.99), count - 1)]
	print("[测帧] 对照=%s t=%.0fs 帧数=%d 引擎FPS=%.1f | 帧时间 p50=%.1f ms p95=%.1f ms p99=%.1f ms max=%.1f ms"
			% ["大厅" if BOOT_LOBBY else "对局", _elapsed, count,
			Engine.get_frames_per_second(), p50, p95, p99, sorted[count - 1]])
	_samples.clear()
