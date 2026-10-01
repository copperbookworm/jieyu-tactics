# AudioEffectHardLimiter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectHardLimiter` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectHardLimiter.md`

**摘要**：Adds a limiter audio effect to an audio bus. 		Prevents audio signals from exceeding a specified volume level.

## 描述

A "limiter" disallows audio signals from exceeding a given volume threshold level in dB. Hard limiters predict volume peaks, and will smoothly apply gain reduction when a peak crosses the ceiling threshold level to prevent clipping. It preserves the waveform and prevents it from crossing the ceiling threshold level. Adding one in the Master bus is recommended as a safety measure to prevent sudden volume peaks from occurring, and to prevent distortion caused by clipping, when the volume exceeds 0 dB.
		If clipping is desired, consider `AudioEffectDistortion.MODE_CLIP`.

## 属性

- **`ceiling_db`** `float` = `-0.3`
  - 其它属性：getter=get_ceiling_db · setter=set_ceiling_db
- **`pre_gain_db`** `float` = `0.0`
  - 其它属性：getter=get_pre_gain_db · setter=set_pre_gain_db
- **`release`** `float` = `0.1`
  - 其它属性：getter=get_release · setter=set_release

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

