# AudioEffectReverb

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectReverb` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectReverb.md`

**摘要**：Adds a reverberation audio effect to an audio bus. 		Emulates an echo by playing a blurred version of the input audio.

## 描述

A "reverb" effect plays the input audio back continuously, decaying over a period of time. It simulates sounds in different kinds of spaces, ranging from small rooms, to big caverns.
		See also `AudioEffectDelay` for a non-blurry type of echo.

## 属性

- **`damping`** `float` = `0.5`
  - 其它属性：getter=get_damping · setter=set_damping
- **`dry`** `float` = `1.0`
  - 其它属性：getter=get_dry · setter=set_dry
- **`hipass`** `float` = `0.0`
  - 其它属性：getter=get_hpf · setter=set_hpf
- **`predelay_feedback`** `float` = `0.4`
  - 其它属性：getter=get_predelay_feedback · setter=set_predelay_feedback
- **`predelay_msec`** `float` = `150.0`
  - 其它属性：getter=get_predelay_msec · setter=set_predelay_msec
- **`room_size`** `float` = `0.8`
  - 其它属性：getter=get_room_size · setter=set_room_size
- **`spread`** `float` = `1.0`
  - 其它属性：getter=get_spread · setter=set_spread
- **`wet`** `float` = `0.5`
  - 其它属性：getter=get_wet · setter=set_wet

## 教程链接

- [Audio buses](None)
- [Audio effects](None)
- [Third Person Shooter (TPS) Demo](None)

