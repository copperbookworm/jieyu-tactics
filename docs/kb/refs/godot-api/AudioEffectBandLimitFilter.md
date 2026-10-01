# AudioEffectBandLimitFilter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectBandLimitFilter` → `AudioEffectFilter` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectBandLimitFilter.md`

**摘要**：Adds a band-limit filter to an audio bus.

## 描述

A "band-limit" filter attenuates the frequencies at `AudioEffectFilter.cutoff_hz`, and allows frequencies outside the frequency threshold to pass unchanged. It is a wider and weaker version of `AudioEffectNotchFilter`, and is the opposite of `AudioEffectBandPassFilter`.
		This filter can be used to give more room for other sounds to play at that frequency.

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

