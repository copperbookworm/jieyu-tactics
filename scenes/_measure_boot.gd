extends Node

## 【临时 · 只用于真机帧时间采样，跑完就删】
## 为什么需要它：平板的大厅 UI 点不动（三种坐标映射都试过；logcat 显示华为 ITouchService
## 把本包当「非游戏」、系统还会 fastHibernation 挂起），所以直接按 PVP_RANKED 口径起对局。
##
## 为什么自带 FPS 打印：dumpsys gfxinfo 对 Godot **结构性无效** —— Godot 走原生 SurfaceView
## 渲染，不进 HWUI 的 View 体系，实测永远是「Total frames rendered: 0」+ 4950 ms 占位百分位。
## 所以真机帧时间用**引擎自报**：_process 逐帧收 delta，每 5 s 打一行 p50 / p95 / max。
## 口径：真机 · 满负载（20 敌 + 19 友）· 玩家不动 · 引擎 TIME_FPS + 逐帧 delta 百分位。
## 采样的是「满负载稳态」，不是「操作瞬间」—— 玩家不动就没有输入密度，这一点必须写在结论里。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")

const WINDOW_S := 5.0

var _samples: Array = []
var _elapsed := 0.0
var _window := 0.0


func _ready() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_RANKED)
	var main = (load("res://scenes/gameplay/Main.tscn") as PackedScene).instantiate()
	main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_RANKED)
	add_child(main)
	print("[测量包] 已按 PVP_RANKED 起对局：敌人 %d、队友 %d" % [main.enemy_count, MatchRulesScript.ally_count()])


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
	var worst: float = sorted[count - 1]
	print("[测帧] t=%.0fs 帧数=%d 引擎FPS=%.1f | 帧时间 p50=%.1f ms p95=%.1f ms p99=%.1f ms max=%.1f ms"
			% [_elapsed, count, Engine.get_frames_per_second(), p50, p95, p99, worst])
	_samples.clear()


## 用真实按键退出（测量完不必强杀）：这里不做，交给 adb am force-stop
