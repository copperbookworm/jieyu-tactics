# AudioEffectLimiter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectLimiter` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · deprecated=Use [AudioEffectHardLimiter] instead.
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectLimiter.md`

**摘要**：Adds a soft-clip limiter audio effect to an audio bus.

## 描述

A "limiter" is an audio effect designed to stop audio signals from exceeding a specified volume threshold level, and usually works by decreasing the volume or soft-clipping the audio. Adding one in the Master bus is always recommended to prevent clipping when the volume goes above 0 dB.
		Soft clipping starts to decrease the peaks a little below the volume threshold level and progressively increases its effect as the input volume increases such that the threshold level is never exceeded.
		If hard clipping is desired, consider `AudioEffectDistortion.MODE_CLIP`.

## 属性

- **`ceiling_db`** `float` = `-0.1`
  - 其它属性：getter=get_ceiling_db · setter=set_ceiling_db
- **`soft_clip_db`** `float` = `2.0`
  - 其它属性：getter=get_soft_clip_db · setter=set_soft_clip_db
- **`soft_clip_ratio`** `float` = `10.0`
  - 其它属性：getter=get_soft_clip_ratio · setter=set_soft_clip_ratio
- **`threshold_db`** `float` = `0.0`
  - 其它属性：getter=get_threshold_db · setter=set_threshold_db

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

