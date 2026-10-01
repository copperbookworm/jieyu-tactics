# AudioEffectNotchFilter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectNotchFilter` → `AudioEffectFilter` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectNotchFilter.md`

**摘要**：Adds a notch filter to an audio bus.

## 描述

A "notch" filter attenuates frequencies at `AudioEffectFilter.cutoff_hz` and allows frequencies outside the frequency threshold to pass unchanged. It is a narrower and stronger version of `AudioEffectBandLimitFilter`, and is the opposite of `AudioEffectBandPassFilter`.
		This filter can be used to give more room for other sounds to play at that frequency. Because of how much it attenuates frequencies, it can also be used to completely remove undesired frequencies.

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

