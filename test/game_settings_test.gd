@tool
extends EditorScript

## 游戏设置：默认值 / 音量换算 / 存盘读回 / 坏存档兜底。
## 一律用临时路径 —— 绝不碰玩家真实的 user://game_settings.cfg（纪律抄自 AiAdvisor 的自检）。

const SettingsScript := preload("res://systems/settings/GameSettings.gd")
const ModeTableScript := preload("res://data/config/ModeTable.gd")

const TMP := "user://_test_game_settings.cfg"

var _passed := 0
var _failed := 0


func _run() -> void:
	_cleanup()
	_test_defaults()
	_test_volume_math()
	_test_roundtrip()
	_test_missing_file()
	_test_bad_mode_id()
	_test_clamped_enemy_count()
	_test_reset()
	_cleanup()
	print("—— 通过 %d 项 / 失败 %d 项 ——" % [_passed, _failed])
	if _failed > 0:
		print("！！ 有 %d 项失败，往上翻看期望与实际" % _failed)


func _check(title: String, actual: Variant, expected: Variant) -> void:
	if actual == expected:
		_passed += 1
		print("[OK]   %s" % title)
	else:
		_failed += 1
		print("[FAIL] %s  期望=%s 实际=%s" % [title, str(expected), str(actual)])


func _check_true(title: String, condition: bool) -> void:
	_check(title, condition, true)


func _cleanup() -> void:
	if FileAccess.file_exists(TMP):
		DirAccess.remove_absolute(TMP)


func _new_settings():
	var s = SettingsScript.new()
	s.config_path = TMP
	return s


func _test_defaults() -> void:
	var s = _new_settings()
	_check("默认音量满格", s.master_volume, 1.0)
	_check("默认不静音", s.muted, false)
	_check("默认操作提示＝GameConfig.TIP_DEFAULT_ENABLED",
			s.tips_enabled, GameConfig.TIP_DEFAULT_ENABLED)
	_check("默认模式＝模式表默认模式", s.default_mode, ModeTableScript.default_mode_id())
	_check("默认兵种＝步枪兵", s.default_role, RoleTable.Role.RIFLEMAN)
	_check("默认载具非空", s.default_vehicle != "", true)
	_check("默认敌人数＝2", s.default_enemy_count, 2)
	_check("默认地图种子＝GameConfig.DEFAULT_MAP_SEED",
			s.default_map_seed, GameConfig.DEFAULT_MAP_SEED)
	_check("默认地图＝空串（＝工程内置示范图）", s.default_map_image, "")
	var opts: Dictionary = s.match_options()
	_check("对局参数：六个键", opts.size(), 6)
	_check("对局参数里的模式与字段一致", opts["mode"], s.default_mode)
	_check("对局参数里的地图与字段一致", opts["map_image"], s.default_map_image)


func _test_volume_math() -> void:
	_check("满音量 → 0 dB", SettingsScript.volume_to_db(1.0, false), 0.0)
	_check("静音 → MUTE_DB", SettingsScript.volume_to_db(1.0, true), SettingsScript.MUTE_DB)
	_check("音量 0 → MUTE_DB（线性 0 算不出 dB，必须挡住）",
			SettingsScript.volume_to_db(0.0, false), SettingsScript.MUTE_DB)
	_check_true("半音量是负 dB", SettingsScript.volume_to_db(0.5, false) < 0.0)
	_check("越界音量被钳到上限", SettingsScript.clamp_volume(9.0), 1.0)
	_check("负音量被钳到 0", SettingsScript.clamp_volume(-3.0), 0.0)
	var s = _new_settings()
	s.set_volume(2.5)
	_check("set_volume 也钳制", s.master_volume, 1.0)
	s.set_muted(true)
	_check("静音后 volume_db 走静音值", s.volume_db(), SettingsScript.MUTE_DB)


## 存 → 读：每一项都要回来（这是「设置能保存」的唯一证据）
func _test_roundtrip() -> void:
	var a = _new_settings()
	a.set_volume(0.42)
	a.set_muted(true)
	a.set_tips_enabled(false)
	a.default_mode = ModeTableScript.Mode.PVP_RANKED
	a.default_role = RoleTable.Role.SCOUT
	a.default_vehicle = "mbt_t1"
	a.default_enemy_count = 5
	a.default_map_seed = 12345
	a.default_map_image = "res://assets/maps/qingling_corridor/heightmap.png"
	_check_true("存盘成功", a.save_to_disk())
	_check_true("存档文件真的写出来了", FileAccess.file_exists(TMP))

	var b = _new_settings()
	_check_true("读盘成功", b.load_from_disk())
	_check("音量读回", b.master_volume, 0.42)
	_check("静音读回", b.muted, true)
	_check("操作提示开关读回", b.tips_enabled, false)
	_check("默认模式读回", b.default_mode, ModeTableScript.Mode.PVP_RANKED)
	_check("默认兵种读回", b.default_role, RoleTable.Role.SCOUT)
	_check("默认载具读回", b.default_vehicle, "mbt_t1")
	_check("敌人数读回", b.default_enemy_count, 5)
	_check("地图种子读回", b.default_map_seed, 12345)
	_check("地图读回", b.default_map_image, "res://assets/maps/qingling_corridor/heightmap.png")


func _test_missing_file() -> void:
	_cleanup()
	var s = _new_settings()
	_check("没有存档：load 返回 false（首次运行不是错误）", s.load_from_disk(), false)
	_check("没有存档：值保持默认", s.default_map_seed, GameConfig.DEFAULT_MAP_SEED)


## 旧存档 / 手改坏了的模式 id 不能让界面拿到空条目
func _test_bad_mode_id() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("match", "mode", 9999)
	cfg.save(TMP)
	var s = _new_settings()
	_check_true("坏存档能读进来", s.load_from_disk())
	_check("坏模式 id → 退回默认模式", s.default_mode, ModeTableScript.default_mode_id())


func _test_clamped_enemy_count() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("match", "enemy_count", 999)
	cfg.save(TMP)
	var s = _new_settings()
	s.load_from_disk()
	_check("敌人数超上限 → 钳到上限", s.default_enemy_count, SettingsScript.ENEMY_MAX)
	cfg.set_value("match", "enemy_count", -5)
	cfg.save(TMP)
	var s2 = _new_settings()
	s2.load_from_disk()
	_check("敌人数为负 → 钳到下限", s2.default_enemy_count, SettingsScript.ENEMY_MIN)


func _test_reset() -> void:
	var s = _new_settings()
	s.set_volume(0.1)
	s.set_muted(true)
	s.default_enemy_count = 7
	s.default_mode = ModeTableScript.Mode.PVEVP
	s.reset_defaults()
	_check("复位：音量", s.master_volume, 1.0)
	_check("复位：静音", s.muted, false)
	_check("复位：敌人数", s.default_enemy_count, 2)
	_check("复位：模式", s.default_mode, ModeTableScript.default_mode_id())
	_check("复位：地图回到内置示范图", s.default_map_image, "")
