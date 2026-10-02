extends RefCounted

## 10 章基础音效的「程序生成 PCM」层（候选 M · 第二轮）
##
## 项目没有任何音频资产（docx 20.6 第十章：工程零 AudioStreamPlayer），所以第一版按「程序生成」把链路走通：
## 用 AudioStreamWAV 的 data 直接填 16-bit 单声道样本 —— 与贴图（HudTextureFactory）、特效（BlobShadow）
## 是同一套「没有资源就自己画 / 自己合成」的路子。
##
## 每段音效 = 噪声 + 正弦 的和，乘一条指数衰减包络：
##   · 枪声 / 爆炸：噪声为主（base_hz 给一点低频「膛音」，频率随时间下坠，听感更像击发而不是电子音）；
##   · 提示音（旗点 / 击杀）：正弦为主，噪声很少；
##   · 确定性：用 hash(id) 当随机种子，同一个音每次生成的字节完全一致 —— 可单测、录像可复现。
##
## 真机听感是另一回事：headless 只能验「样本数 / 波形在范围内 / 不削波 / 确定性」。
## 刻意不写 class_name：引用方 preload（见 Cover.gd 头部说明）

## 音效目录：id -> 配方
##   dur 时长(s) / base_hz 起振频率(0＝纯噪声) / noise 噪声占比 0..1 / decay 振幅衰减指数 / gain 总音量
const RECIPES := {
	"shot":       {"dur": 0.11, "base_hz": 180.0, "noise": 0.85, "decay": 26.0, "gain": 0.55},
	"shot_enemy": {"dur": 0.11, "base_hz": 140.0, "noise": 0.85, "decay": 26.0, "gain": 0.42},
	"cannon":     {"dur": 0.38, "base_hz": 70.0,  "noise": 0.62, "decay": 9.0,  "gain": 0.80},
	"missile":    {"dur": 0.55, "base_hz": 110.0, "noise": 0.95, "decay": 6.5,  "gain": 0.65},
	"impact":     {"dur": 0.07, "base_hz": 320.0, "noise": 0.90, "decay": 55.0, "gain": 0.40},
	"hit":        {"dur": 0.10, "base_hz": 220.0, "noise": 0.70, "decay": 38.0, "gain": 0.50},
	"explosion":  {"dur": 0.60, "base_hz": 45.0,  "noise": 0.80, "decay": 6.0,  "gain": 0.85},
	"reload":     {"dur": 0.14, "base_hz": 900.0, "noise": 0.55, "decay": 30.0, "gain": 0.30},
	"flag":       {"dur": 0.35, "base_hz": 520.0, "noise": 0.10, "decay": 4.0,  "gain": 0.35},
	"down":       {"dur": 0.45, "base_hz": 110.0, "noise": 0.35, "decay": 5.0,  "gain": 0.55},
	"kill":       {"dur": 0.18, "base_hz": 660.0, "noise": 0.15, "decay": 12.0, "gain": 0.35},
	"match":      {"dur": 0.90, "base_hz": 260.0, "noise": 0.05, "decay": 2.5,  "gain": 0.40},
}


static func sound_ids() -> Array:
	return RECIPES.keys()


static func has_sound(id: String) -> bool:
	return RECIPES.has(id)


## 合成一段音效；未知 id 返回 null
static func build(id: String) -> AudioStreamWAV:
	if not RECIPES.has(id):
		return null
	var recipe: Dictionary = RECIPES[id]
	var rate := GameConfig.SFX_SAMPLE_RATE
	var duration := float(recipe["dur"])
	var samples := int(duration * float(rate))
	if samples <= 0:
		return null
	var bytes := PackedByteArray()
	bytes.resize(samples * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(id)            # 确定性：同一个音每次都一样
	var phase := 0.0
	for i in samples:
		var t := float(i) / float(rate)
		var env := exp(-float(recipe["decay"]) * t)
		var noise := rng.randf_range(-1.0, 1.0) * float(recipe["noise"])
		var tone := 0.0
		if float(recipe["base_hz"]) > 0.0:
			# 频率随时间下坠 60%：更像「击发」而不是一声电子音
			var f := float(recipe["base_hz"]) * (1.0 - 0.6 * minf(t / duration, 1.0))
			phase += TAU * f / float(rate)
			tone = sin(phase) * (1.0 - float(recipe["noise"]))
		var value := clampf((noise + tone) * env * float(recipe["gain"]), -1.0, 1.0)
		bytes.encode_s16(i * 2, int(value * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.stereo = false
	stream.data = bytes
	return stream


static func sample_count(stream: AudioStreamWAV) -> int:
	if stream == null:
		return 0
	return int(stream.data.size() / 2)


## 峰值（0..1）——测试用它钉「不削波 / 不是一片静音」
static func peak_amplitude(stream: AudioStreamWAV) -> float:
	if stream == null:
		return 0.0
	var peak := 0.0
	var data := stream.data
	for i in sample_count(stream):
		peak = maxf(peak, absf(float(data.decode_s16(i * 2)) / 32767.0))
	return peak


## 前 10% 与后 10% 的平均振幅：用来验证「包络真的在衰减」
static func head_tail_ratio(stream: AudioStreamWAV) -> float:
	if stream == null:
		return 0.0
	var count := sample_count(stream)
	var window := maxi(count / 10, 1)
	var head := 0.0
	var tail := 0.0
	var data := stream.data
	for i in window:
		head += absf(float(data.decode_s16(i * 2)))
		tail += absf(float(data.decode_s16((count - 1 - i) * 2)))
	if tail <= 0.0:
		return 999.0
	return head / tail
