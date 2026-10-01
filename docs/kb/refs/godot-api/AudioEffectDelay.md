# AudioEffectDelay

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectDelay` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectDelay.md`

**摘要**：Adds a delay audio effect to an audio bus. 		Emulates an echo by playing the input audio back after a period of time.

## 描述

A "delay" effect plays the input audio signal back after a period of time. Each repetition is called a "delay tap" or simply "tap". Delay taps may be played back multiple times to create the sound of a repeating, decaying echo. Delay effects range from a subtle echo to a pronounced blending of previous sounds with new sounds.
		See also `AudioEffectReverb` for a blurry, continuous echo.

## 属性

- **`dry`** `float` = `1.0`
  - 其它属性：getter=get_dry · setter=set_dry
- **`feedback_active`** `bool` = `false`
  - 其它属性：getter=is_feedback_active · setter=set_feedback_active
- **`feedback_delay_ms`** `float` = `340.0`
  - 其它属性：getter=get_feedback_delay_ms · setter=set_feedback_delay_ms
- **`feedback_level_db`** `float` = `-6.0`
  - 其它属性：getter=get_feedback_level_db · setter=set_feedback_level_db
- **`feedback_lowpass`** `float` = `16000.0`
  - 其它属性：getter=get_feedback_lowpass · setter=set_feedback_lowpass
- **`tap1_active`** `bool` = `true`
  - 其它属性：getter=is_tap1_active · setter=set_tap1_active
- **`tap1_delay_ms`** `float` = `250.0`
  - 其它属性：getter=get_tap1_delay_ms · setter=set_tap1_delay_ms
- **`tap1_level_db`** `float` = `-6.0`
  - 其它属性：getter=get_tap1_level_db · setter=set_tap1_level_db
- **`tap1_pan`** `float` = `0.2`
  - 其它属性：getter=get_tap1_pan · setter=set_tap1_pan
- **`tap2_active`** `bool` = `true`
  - 其它属性：getter=is_tap2_active · setter=set_tap2_active
- **`tap2_delay_ms`** `float` = `500.0`
  - 其它属性：getter=get_tap2_delay_ms · setter=set_tap2_delay_ms
- **`tap2_level_db`** `float` = `-12.0`
  - 其它属性：getter=get_tap2_level_db · setter=set_tap2_level_db
- **`tap2_pan`** `float` = `-0.4`
  - 其它属性：getter=get_tap2_pan · setter=set_tap2_pan

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

