@tool
extends EditorScript

## 10 章基础音效（候选 M · 第二轮）：程序生成的 PCM / 播放层 / 调用入口
## 运行：脚本编辑器打开本文件 → 文件 → 运行；或 godot --headless --script res://tools/run_tests_headless.gd
## headless 验不了「好不好听」，只能验：合成出来的样本在合理范围、包络在衰减、同一个音确定、
## 播放层有限频与声部上限、调用入口在没有播放层时安全。真机听感另作验收。

const Procedural := preload("res://systems/audio/ProceduralAudio.gd")
const AudioSystemScript := preload("res://systems/audio/AudioSystem.gd")
const Sfx := preload("res://systems/audio/Sfx.gd")

## 目录里的全部音效（与 docx 10 章的用途对应）
const WANTED := ["shot", "shot_enemy", "cannon", "missile", "impact", "hit", "explosion",
		"reload", "flag", "down", "kill", "match"]

var _passed := 0
var _failed := 0


func _run() -> void:
	_test_catalogue()
	_test_stream_shape()
	_test_envelope_decays()
	_test_deterministic()
	_test_all_recipes()
	_test_system_rate_limit()
	_test_sfx_entry()
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


func _test_catalogue() -> void:
	_check("音效：目录 12 条（含 ATGM 的 missile）",
			Procedural.sound_ids().size(), WANTED.size())
	for id in WANTED:
		_check_true("音效：有「%s」" % id, Procedural.has_sound(id))
	_check_true("音效：未知 id 不算有", not Procedural.has_sound("nope"))
	_check("音效：未知 id 合成返回 null", Procedural.build("nope"), null)
	_check("音效：采样率 22050（移动端够用）", GameConfig.SFX_SAMPLE_RATE, 22050)


func _test_stream_shape() -> void:
	var stream := Procedural.build("shot")
	_check_true("波形：枪声能合成出来", stream != null)
	_check("波形：16 bit 格式", stream.format, AudioStreamWAV.FORMAT_16_BITS)
	_check("波形：采样率写进了流", stream.mix_rate, GameConfig.SFX_SAMPLE_RATE)
	_check_true("波形：单声道（省一半样本）", not stream.stereo)
	_check("波形：样本数 = 0.11 s × 22050",
			Procedural.sample_count(stream), int(0.11 * 22050.0))
	_check("波形：字节数 = 样本数 × 2", stream.data.size(),
			Procedural.sample_count(stream) * 2)
	var peak := Procedural.peak_amplitude(stream)
	_check_true("波形：有声音（峰值 > 0.1）", peak > 0.1)
	_check_true("波形：不削波（峰值 ≤ 1.0）", peak <= 1.0)


## 10 章的音效都是「击发 / 提示」类，必须是衰减包络而不是一段平声
func _test_envelope_decays() -> void:
	for id in ["shot", "cannon", "explosion"]:
		var stream := Procedural.build(id)
		_check_true("包络：%s 头尾振幅比 > 2（确实在衰减）" % id,
				Procedural.head_tail_ratio(stream) > 2.0)


## 同一个音每次合成必须逐字节一致（可单测 / 录像可复现）
func _test_deterministic() -> void:
	var a := Procedural.build("shot")
	var b := Procedural.build("shot")
	_check("确定性：两次合成的字节完全一样", a.data, b.data)
	var c := Procedural.build("cannon")
	_check_true("确定性：不同音效的波形不同", a.data != c.data)


func _test_all_recipes() -> void:
	for id in WANTED:
		var stream := Procedural.build(id)
		_check_true("配方：%s 样本数 > 0" % id, Procedural.sample_count(stream) > 0)
		_check_true("配方：%s 峰值在 (0, 1]" % id,
				Procedural.peak_amplitude(stream) > 0.0
				and Procedural.peak_amplitude(stream) <= 1.0)


## 播放层：限频 + 声部上限 + 关闭开关。测试里把它挂进场景树，player.play() 才不会报「不在树里」。
func _test_system_rate_limit() -> void:
	var loop := Engine.get_main_loop() as SceneTree
	var system = AudioSystemScript.new()
	if loop != null:
		loop.root.add_child(system)

	_check("播放层：未知音效播不出去", system.play("nope"), false)
	var stream := system.stream_for("shot")
	_check_true("播放层：能拿到（必要时合成）枪声音效", stream != null)
	_check("播放层：音效是缓存的（第二次是同一个对象）",
			system.stream_for("shot"), stream)

	system._last_played.clear()
	_check_true("播放层：第一次播得出去", system.play("shot"))
	_check("播放层：同一音效立刻重播被限频拦下", system.play("shot"), false)
	_check("播放层：声部数 = SFX_MAX_VOICES",
			system.voice_count("shot"), GameConfig.SFX_MAX_VOICES)
	system.enabled = false
	system._last_played.clear()
	_check("播放层：关掉后播不出去", system.play("shot"), false)
	system.enabled = true

	if loop != null:
		loop.root.remove_child(system)
	system.free()


func _test_sfx_entry() -> void:
	_check("入口：未知音效返回 false", Sfx.play("nope"), false)
	var audio := Sfx.find_audio()
	_check_true("入口：跑批环境里能找到 Audio autoload（project.godot 已注册）", audio != null)
	if audio != null:
		audio._last_played.clear()
		_check_true("入口：Sfx.play 能把音效送到播放层", Sfx.play("shot"))
		_check("入口：播放层真的建了声部", audio.voice_count("shot"),
				GameConfig.SFX_MAX_VOICES)
