# AudioEffectPhaser

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectPhaser` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectPhaser.md`

**摘要**：Adds a phaser audio effect to an audio bus. 		Creates several notch and peak filters that sweep across the spectrum.

## 描述

A "phaser" effect creates a copy of the original audio that phase-rotates differently across the entire frequency spectrum, with the use of a series of all-pass filter stages (6 in this effect). This copy modulates with a low-frequency oscillator and combines with the original audio, resulting in peaks and troughs that sweep across the spectrum.
		This effect can be used to create a "glassy" or "bubbly" sound.

## 属性

- **`depth`** `float` = `1.0`
  - 其它属性：getter=get_depth · setter=set_depth
- **`feedback`** `float` = `0.7`
  - 其它属性：getter=get_feedback · setter=set_feedback
- **`range_max_hz`** `float` = `1600.0`
  - 其它属性：getter=get_range_max_hz · setter=set_range_max_hz
- **`range_min_hz`** `float` = `440.0`
  - 其它属性：getter=get_range_min_hz · setter=set_range_min_hz
- **`rate_hz`** `float` = `0.5`
  - 其它属性：getter=get_rate_hz · setter=set_rate_hz

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

