extends Node

## 【固定场景基线探针】按固定时长跑一局 20v20，把逐帧帧时间写进 M1 的 CSV，然后自退。
##
## 为什么要有它：真机 A/B 需要一个**可复现、无 UI 交互**的场景 —— 否则"操作串不同"会把变体差异淹掉。
## 本场景把 main_scene 临时指过来导出，开机即固定：PVP_CASUAL 20 v 20、不碰任何设置、预热 4 s、
## 测量 60 s、然后自己退出。取数走 M1 的 `perf_frame.ps1`（adb pull + 解析 + 与同轮 logcat 交叉验证）。
##
## 用法（导出侧）：
##   临时把 project.godot 的 run/main_scene 指向 res://scenes/_probe_fixed_scene.tscn
##   → export_android.ps1 -Mode debug -Out <apk> → 导出后立刻还原 project.godot
## 用法（取数侧）：
##   & perf_frame.ps1 -Serial <dev> -OutDir D:\Godot4.7_Proj\_perf -Scenario "固定场景 20v20 60s"

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const PerfCsv := preload("res://systems/debug/PerfCsvWriter.gd")

const WARMUP_S := 4.0
const DURATION_S := 60.0
const TAG := "fixed20v20_60s"

var _main: Node = null
var _t := 0.0
var _measuring := false


func _ready() -> void:
	MatchRulesScript.set_mode(ModeTableScript.Mode.PVP_CASUAL)
	var packed: PackedScene = load("res://scenes/gameplay/Main.tscn")
	_main = packed.instantiate()
	_main.enemy_count = ModeTableScript.enemy_count(ModeTableScript.Mode.PVP_CASUAL)
	add_child(_main)
	print("[固定场景] 起局：敌人 %d、队友 %d｜预热 %.0fs + 测量 %.0fs" % [
			_main.enemy_count, MatchRulesScript.ally_count(), WARMUP_S, DURATION_S])


func _process(delta: float) -> void:
	_t += delta
	if not _measuring:
		if _t < WARMUP_S:
			return
		_t = 0.0
		_measuring = true
		PerfCsv.tag = TAG
		PerfCsv.start("fixed")
		print("[固定场景] 开始测量")
		return
	PerfCsv.frame("fixed", delta)
	if _t >= DURATION_S:
		PerfCsv.stop()
		print("[固定场景] 测量结束（%.1fs），退出" % _t)
		get_tree().quit(0)
