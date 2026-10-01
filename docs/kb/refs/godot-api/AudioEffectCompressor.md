# AudioEffectCompressor

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectCompressor` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectCompressor.md`

**摘要**：Adds a downward compressor audio effect to an audio bus. 		Allows control of the dynamic range via a volume threshold and timing controls.

## 描述

A "compressor" decreases the volume of sounds when it exceeds a certain volume threshold level.
		A compressor can have many uses in a mix:
		- To compress the whole volume in the Master bus (although an `AudioEffectHardLimiter` is probably better).
		- To ensure balance of voice audio clips.
		- To sidechain, using another bus as a trigger. This decreases the volume of the bus it is attached to, by using the volume from another audio bus for threshold detection. This technique is common in video game mixing to decrease the volume of music and SFX while voices are being heard. This effect is also known as "ducking".
		- To accentuate transients by using a long attack, letting sounds exceed the volume threshold level for a short period before compressing them. This can be used to make SFX more punchy.

## 属性

- **`attack_us`** `float` = `20.0`
  - 其它属性：getter=get_attack_us · setter=set_attack_us
- **`gain`** `float` = `0.0`
  - 其它属性：getter=get_gain · setter=set_gain
- **`mix`** `float` = `1.0`
  - 其它属性：getter=get_mix · setter=set_mix
- **`ratio`** `float` = `4.0`
  - 其它属性：getter=get_ratio · setter=set_ratio
- **`release_ms`** `float` = `250.0`
  - 其它属性：getter=get_release_ms · setter=set_release_ms
- **`sidechain`** `StringName` = `&""`
  - 其它属性：getter=get_sidechain · setter=set_sidechain
- **`threshold`** `float` = `0.0`
  - 其它属性：getter=get_threshold · setter=set_threshold

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

