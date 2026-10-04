extends Node

## 对局宿主：把 Main.tscn 装起来、接住胜负、管暂停 / 恢复 / 收场
##
## 为什么要有它（而不是让 App 直接装 Main）：
##   ① Main.gd 是 398/400 的硬线，装配与暂停这两件事都不能再往里塞；
##   ② 「把选好的模式与配置在 add_child 之前写进 @export」是启动对局的**唯一正确时机**
##      —— _ready() 一跑，地形 / 玩家 / 敌人 / HUD 就按旧值建完了；
##   ③ 暂停要同时动三样东西（引擎 pause / HUD 显隐 / 路由进暂停屏），收在一处才不会漏。
##
## 暂停为什么收 HUD 而不是叠在上面：HUD 的按钮平铺在同一层，暂停面板压上去会产生一堆
## 「真实存在但没法修」的重叠；而且暂停时本来就不该点战斗键。世界仍渲染（Node2D 不是
## HUD 的子节点），看起来就是「冻结的战场 + 暂停菜单」。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
## 真机帧率 / 帧时间读数（**仅调试包**：gfxinfo 在本项目真机上取不到数，见 PerfOverlay.gd 头部）
const PerfOverlayScript := preload("res://ui/PerfOverlay.gd")

const BUS_PATH := "/root/EventBus"

var ctx = null
var router = null
var main = null              ## Main.tscn 实例（Node2D）
var mode_id := 0
var paused := false

var _finished := false


func setup(context, router_node) -> void:
	ctx = context
	router = router_node


func start(main_scene_path: String, options: Dictionary) -> bool:
	var packed: PackedScene = load(main_scene_path)
	if packed == null:
		push_error("[对局] 加载不到 %s" % main_scene_path)
		return false
	mode_id = int(options.get("mode", ModeTableScript.default_mode_id()))
	main = packed.instantiate()
	main.name = "Main"
	# 这几个 @export 必须在 add_child 之前赋值 —— 之后世界已经按旧值建好了
	main.player_role = int(options.get("role", main.player_role))
	main.vehicle_id = String(options.get("vehicle", main.vehicle_id))
	# 人数优先取模式（docx 5.8：PVP 20 v 20 / PVEVP 4P v 30E）；模式没定（兵棋）才回落到玩家设置
	var mode_enemies := MatchRulesScript.enemy_count()
	main.enemy_count = mode_enemies if mode_enemies > 0 \
			else int(options.get("enemy_count", main.enemy_count))
	main.map_seed = int(options.get("map_seed", main.map_seed))
	# 地图（2026-10-04 第一张正式地图）：空串 = 用 Main.tscn 的 @export 默认（工程内置示范图）。
	# 显式选了地图才覆盖 —— 单跑 Main.tscn 的测试与 demo 摆位完全不受影响。
	var map_image := String(options.get("map_image", ""))
	if not map_image.is_empty():
		main.map_height_image = map_image
	main.map_preview_mode = false
	add_child(main)
	_apply_mode_rules()
	_attach_perf_overlay()
	_wire_pause_button()
	_wire_match_finished()
	return true


## 把模式表的规则灌进战局流程（时长 / 加时 / 胜负口径）。
## 不灌 = MatchFlow 保持今天的占领口径，所以单独跑 Main.tscn 的测试完全不受影响。
func _apply_mode_rules() -> void:
	if main == null or main.match_flow == null:
		return
	main.match_flow.apply_mode(
			ModeTableScript.win_rule(mode_id),
			ModeTableScript.duration_s(mode_id),
			ModeTableScript.overtime_s(mode_id),
			"完成主线任务")


## 暂停键由 HudBuilder 建、由这里接线 —— Main.gd 因此一行都不用加（它守着 400 行硬线）
## 仅在调试包里挂帧率读数（正式包连节点都不建 —— 与「立刻结束本局」同一条纪律）
func _attach_perf_overlay() -> void:
	if not OS.is_debug_build() or main == null:
		return
	var overlay = PerfOverlayScript.new()
	overlay.name = "PerfOverlay"
	main.add_child(overlay)
	overlay.setup(main)


func _wire_pause_button() -> void:
	if main == null or main.hud == null:
		return
	var button = main.hud.pause_button
	if button != null and not button.pressed.is_connected(pause):
		button.pressed.connect(pause)


func _wire_match_finished() -> void:
	var bus := get_node_or_null(BUS_PATH)
	if bus == null or not bus.has_signal("match_finished"):
		return
	if not bus.match_finished.is_connected(_on_match_finished):
		bus.match_finished.connect(_on_match_finished)


func _on_match_finished(_winner) -> void:
	if _finished:
		return
	_finished = true
	is_finished()
	# 结算屏是满屏战报：世界解冻（别让玩家以为卡了），但 HUD 收起来
	_set_tree_paused(false)
	set_hud_visible(false)
	if ctx != null:
		ctx.on_match_finished()


func is_finished() -> bool:
	return _finished


func pause() -> void:
	if _finished:
		return
	_set_tree_paused(true)
	set_hud_visible(false)
	if router != null:
		router.push("pause")


## 恢复：不管暂停栈里压了几层（暂停 / 暂停+设置），一律清干净
func resume() -> void:
	_set_tree_paused(false)
	set_hud_visible(true)
	if router != null:
		router.clear()


func _set_tree_paused(value: bool) -> void:
	paused = value
	var tree := get_tree()
	if tree != null:
		tree.paused = value


## HUD 与战术地图两层一起收（战术地图是 HudBuilder 里另开的 CanvasLayer）
func set_hud_visible(value: bool) -> void:
	if main == null or main.hud == null:
		return
	if main.hud.has_method("set_shell_visible"):
		main.hud.set_shell_visible(value)


func stop() -> void:
	_set_tree_paused(false)
	if main != null and is_instance_valid(main):
		main.queue_free()
	main = null


## 战局摘要（暂停屏 / 结算屏共用一处取数，别让两个屏各读一遍 Main 的内部字段）
func summary() -> Dictionary:
	var empty := {
		"active": false, "mode": mode_id, "mode_name": ModeTableScript.name_of(mode_id),
		"mode_tag": ModeTableScript.tag_of(mode_id), "outcome": "", "reason": "",
		"time_text": "-", "holds": "-", "budget": 0, "score": 0, "quest": "无",
	}
	if main == null or not is_instance_valid(main):
		return empty
	var flow = main.match_flow
	var out := empty.duplicate()
	out["active"] = true
	out["score"] = int(main.score)
	if flow != null:
		out["outcome"] = String(flow.outcome)
		out["reason"] = String(flow.reason)
		out["time_text"] = flow.clock_text()
		out["holds"] = flow.holds_text()
		out["budget"] = int(flow.budget)
	if main.quests != null and main.quests.has_method("main_quest"):
		var quest: Dictionary = main.quests.main_quest()
		if not quest.is_empty():
			out["quest"] = String(quest.get("name", "无"))
	return out
