extends RefCounted

## 游戏设置（音量 / 操作提示 / AI 参谋竞技开关 / 对局默认值）—— 落 user://game_settings.cfg
##
## 为什么不做成 autoload：本工程对 autoload 有硬约束——--script 模式下 autoload 未注册，
## 谁在编译期引用了全局名谁就炸（见 systems/audio/Sfx.gd 头部）。设置只需要「App 持有、
## 界面读写、存盘」三件事，RefCounted 实例完全够用，还顺带可以在单测里换临时路径。
##
## 路径可注入（config_path）：单测 / 自检一律指向临时文件，**绝不碰玩家真实的 user://game_settings.cfg**
## ——这条纪律抄自 systems/ai/AiAdvisor.gd 的 config_path。
##
## 刻意不写 class_name：引用方 preload。

const ModeTableScript := preload("res://data/config/ModeTable.gd")

const CONFIG_PATH := "user://game_settings.cfg"

## 音量：0~1 线性，落盘也存线性值（玩家看到的是滑条比例，不是 dB）
const VOLUME_MIN := 0.0
const VOLUME_MAX := 1.0
## 线性 0 会算出 -inf dB，实际听感上 -60 dB 已经等于静音
const MUTE_DB := -60.0
## 敌人数可调范围（对齐 docx 5.5 的人数口径示例与第一版规模）
const ENEMY_MIN := 0
## 8 → 30（2026-10-03）：PVEVP 的人数口径是 4P v 30E，调试/覆盖路径要能够到 30
const ENEMY_MAX := 30

var config_path := CONFIG_PATH

var master_volume := 1.0
var muted := false
var tips_enabled := GameConfig.TIP_DEFAULT_ENABLED
var default_mode := ModeTableScript.default_mode_id()
var default_role := RoleTable.Role.RIFLEMAN
var default_vehicle := "ifv_a"
var default_enemy_count := 2
var default_map_seed := GameConfig.DEFAULT_MAP_SEED
## 对局地图：res:// 下的高度图路径；空串 = 用工程内置示范图（Main 的 @export 默认）
var default_map_image := ""

var _last_error := ""


static func clamp_volume(value: float) -> float:
	return clampf(value, VOLUME_MIN, VOLUME_MAX)


## 音量 → dB（AudioSystem.master_volume_db 吃这个）。静音返回 MUTE_DB。
static func volume_to_db(volume: float, is_muted: bool) -> float:
	if is_muted or volume <= 0.0:
		return MUTE_DB
	return linear_to_db(clamp_volume(volume))


func volume_db() -> float:
	return volume_to_db(master_volume, muted)


func last_error() -> String:
	return _last_error


func set_volume(value: float) -> void:
	master_volume = clamp_volume(value)


func set_muted(value: bool) -> void:
	muted = value


func set_tips_enabled(value: bool) -> void:
	tips_enabled = value


## 一局的装配参数：模式 / 兵种 / 载具 / 敌人数 / 地图种子
func match_options() -> Dictionary:
	return {
		"mode": default_mode,
		"role": default_role,
		"vehicle": default_vehicle,
		"enemy_count": default_enemy_count,
		"map_seed": default_map_seed,
		"map_image": default_map_image,
	}


func reset_defaults() -> void:
	master_volume = 1.0
	muted = false
	tips_enabled = GameConfig.TIP_DEFAULT_ENABLED
	default_mode = ModeTableScript.default_mode_id()
	default_role = RoleTable.Role.RIFLEMAN
	default_vehicle = "ifv_a"
	default_enemy_count = 2
	default_map_seed = GameConfig.DEFAULT_MAP_SEED
	default_map_image = ""


func load_from_disk() -> bool:
	_last_error = ""
	var cfg := ConfigFile.new()
	if not FileAccess.file_exists(config_path):
		# 首次运行：没有存档不是错误，保持默认值
		return false
	var err := cfg.load(config_path)
	if err != OK:
		_last_error = "读取失败（错误 %d）" % err
		return false
	master_volume = clamp_volume(float(cfg.get_value("audio", "master_volume", master_volume)))
	muted = bool(cfg.get_value("audio", "muted", muted))
	tips_enabled = bool(cfg.get_value("ui", "tips_enabled", tips_enabled))
	default_mode = int(cfg.get_value("match", "mode", default_mode))
	default_role = int(cfg.get_value("match", "role", default_role))
	default_vehicle = String(cfg.get_value("match", "vehicle", default_vehicle))
	default_enemy_count = clampi(int(cfg.get_value("match", "enemy_count", default_enemy_count)),
			ENEMY_MIN, ENEMY_MAX)
	default_map_seed = int(cfg.get_value("match", "map_seed", default_map_seed))
	default_map_image = String(cfg.get_value("match", "map_image", default_map_image))
	# 模式表里没有的 id（旧存档 / 手工改坏）→ 退回默认，别让界面拿到空条目
	if ModeTableScript.index_of(default_mode) < 0:
		default_mode = ModeTableScript.default_mode_id()
	return true


func save_to_disk() -> bool:
	_last_error = ""
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", master_volume)
	cfg.set_value("audio", "muted", muted)
	cfg.set_value("ui", "tips_enabled", tips_enabled)
	cfg.set_value("match", "mode", default_mode)
	cfg.set_value("match", "role", default_role)
	cfg.set_value("match", "vehicle", default_vehicle)
	cfg.set_value("match", "enemy_count", default_enemy_count)
	cfg.set_value("match", "map_seed", default_map_seed)
	cfg.set_value("match", "map_image", default_map_image)
	var err := cfg.save(config_path)
	if err != OK:
		_last_error = "写入失败（错误 %d）" % err
		return false
	return true
