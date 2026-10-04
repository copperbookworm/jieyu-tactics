extends Node

## 游戏外壳的装配根（新的主场景 App.tscn 挂在它上面）
##
## 职责边界（刻意的）：
##   ① **只做装配与路由**：建设置、建路由、注册屏幕、把模式配置交给 MatchHost；
##   ② 对局本身不在这里 —— ui/screens/MatchHost.gd；
##   ③ Main.tscn **完全不改**：模式 / 兵种 / 载具 / 敌人数都在 add_child 之前写进 @export，
##      于是「单跑 Main.tscn」的既有测试（单元 / 集成 / 几何门禁）一行都不用动。
##
## 主场景从 Main.tscn 换成本场景＝启动先进大厅（使用者 2026-10-03 拍板）。
## 代价是 APK 启动时先看到大厅；收益是「进对局」变成一次显式点击，模式选择才立得住。
##
## 刻意不写 class_name：引用方 preload。

const GameSettingsScript := preload("res://systems/settings/GameSettings.gd")
const ScreenRouterScript := preload("res://systems/ui/ScreenRouter.gd")
const MatchHostScript := preload("res://ui/screens/MatchHost.gd")
const LobbyScreenScript := preload("res://ui/screens/LobbyScreen.gd")
const ModeSelectScreenScript := preload("res://ui/screens/ModeSelectScreen.gd")
const SettingsScreenScript := preload("res://ui/screens/SettingsScreen.gd")
const PauseScreenScript := preload("res://ui/screens/PauseScreen.gd")
const ResultScreenScript := preload("res://ui/screens/ResultScreen.gd")
const InfoScreenScript := preload("res://ui/screens/InfoScreen.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")
const MatchRulesScript := preload("res://systems/match/MatchRules.gd")
const VehicleTableScript := preload("res://systems/vehicles/VehicleTable.gd")

const MAIN_SCENE := "res://scenes/gameplay/Main.tscn"
const VERSION := "0.46"
## autoload 一律运行时按路径取：本工程不允许在编译期引用全局名（--script 模式下会炸）
const ADVISOR_PATH := "/root/AiAdvisor"
const AUDIO_PATH := "/root/Audio"

## 设置文件路径可注入：几何门禁 / 自检指向一份不存在的临时路径 ⇒ 全用默认值，
## 于是界面的布局与文字都是确定性的（否则跑门禁会读到玩家真实设置，不同机器结果不同）
var settings_path_override := ""

var settings = null
var router = null
var match_host = null
var info_screen = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	settings = GameSettingsScript.new()
	if settings_path_override != "":
		settings.config_path = settings_path_override
	settings.load_from_disk()
	router = ScreenRouterScript.new()
	router.name = "ScreenRouter"
	add_child(router)
	_build_screens()
	apply_runtime()
	router.reset_to("lobby")


func _build_screens() -> void:
	info_screen = InfoScreenScript.new()
	_register("lobby", LobbyScreenScript.new())
	_register("modes", ModeSelectScreenScript.new())
	_register("settings", SettingsScreenScript.new())
	_register("pause", PauseScreenScript.new())
	_register("result", ResultScreenScript.new())
	_register("info", info_screen)


func _register(screen_id: String, screen: Control) -> void:
	screen.setup(router, self)
	router.register(screen_id, screen)


# ─────────────────────── 外壳给屏幕用的接口（ctx.*）───────────────────────

func version_text() -> String:
	return VERSION


func vehicle_ids() -> Array:
	return VehicleTableScript.ids()


func vehicle_name(vehicle_id: String) -> String:
	var data := VehicleTableScript.get_vehicle(vehicle_id)
	var label := String(data.get("name", ""))
	return label if label != "" else vehicle_id


func open_settings() -> void:
	router.push("settings")


func open_info(topic: String) -> void:
	if info_screen != null:
		info_screen.set_topic(topic)
	router.push("info")


# ───────────────────────────── AI 参谋（autoload）─────────────────────────

func advisor() -> Node:
	return get_node_or_null(ADVISOR_PATH)


func advisor_competitive() -> bool:
	var a := advisor()
	return bool(a.competitive) if a != null else false


func set_advisor_competitive(value: bool) -> void:
	var a := advisor()
	if a == null:
		return
	a.competitive = value
	a.save_config()


func open_advisor_panel() -> void:
	var a := advisor()
	if a == null or a.panel == null:
		return
	a.panel.open_panel()


func clear_usage_records() -> int:
	var a := advisor()
	return int(a.clear_records()) if a != null else 0


func clear_api_key() -> bool:
	var a := advisor()
	if a == null:
		return false
	var had := bool(a.key_is_set())
	a.clear_api_key()
	return had


# ────────────────────────────── 设置的应用 ──────────────────────────────

## 只推到运行时（启动时用；不落盘，免得每次开游戏都写一遍玩家配置）
func apply_runtime() -> void:
	var audio := get_node_or_null(AUDIO_PATH)
	if audio != null:
		audio.master_volume_db = settings.volume_db()
		audio.enabled = not settings.muted
	var hud = _current_hud()
	if hud != null:
		hud.set_tips_enabled(settings.tips_enabled)


## 玩家改了设置：应用 + 立刻落盘（设置项没有「取消」，改了就是改了）
func apply_settings() -> void:
	apply_runtime()
	settings.save_to_disk()


func _current_hud():
	if match_host == null or match_host.main == null:
		return null
	return match_host.main.hud


# ─────────────────────────────── 对局生命周期 ───────────────────────────────

func start_match(mode_id: int) -> void:
	if not ModeTableScript.is_available(mode_id):
		return
	_teardown_match()
	# 模式先落到「本局全局事实」上：Player.shoot（友伤）与 MatchFlow 都从这里取
	MatchRulesScript.set_mode(mode_id)
	# 竞技会在开局时覆盖 AI 参谋的竞技开关（20 章：只有竞技 / 严格对抗才关）
	var a := advisor()
	if a != null:
		a.competitive = ModeTableScript.competitive(mode_id)
	match_host = MatchHostScript.new()
	match_host.name = "MatchHost"
	add_child(match_host)
	match_host.setup(self, router)
	var options := {
		"mode": mode_id,
		"role": settings.default_role,
		"vehicle": settings.default_vehicle,
		"enemy_count": settings.default_enemy_count,
		"map_seed": settings.default_map_seed,
		"map_image": settings.default_map_image,
	}
	if not match_host.start(MAIN_SCENE, options):
		_teardown_match()
		return
	# 进对局：把菜单栈清空（暂停 / 结算会再 push 回来）
	router.clear()
	apply_runtime()


func resume_match() -> void:
	if match_host != null:
		match_host.resume()


func return_to_lobby() -> void:
	_teardown_match()
	MatchRulesScript.reset()
	router.reset_to("lobby")


func restart_match() -> void:
	var mode_id: int = int(settings.default_mode)
	if match_host != null:
		mode_id = int(match_host.mode_id)
	start_match(mode_id)


## 对局结束（MatchHost 收到 EventBus.match_finished 后回调）
func on_match_finished() -> void:
	router.reset_to("result")


func has_match() -> bool:
	return match_host != null and match_host.main != null


func match_summary() -> Dictionary:
	if match_host == null:
		return {
			"active": false, "mode_name": "-", "mode_tag": "-", "outcome": "",
			"reason": "", "time_text": "-", "holds": "-", "budget": 0, "score": 0, "quest": "无",
		}
	return match_host.summary()


func _teardown_match() -> void:
	var tree := get_tree()
	if tree != null:
		tree.paused = false
	if match_host != null and is_instance_valid(match_host):
		match_host.stop()
		remove_child(match_host)
		match_host.queue_free()
	match_host = null
