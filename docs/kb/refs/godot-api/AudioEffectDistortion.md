# AudioEffectDistortion

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectDistortion` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectDistortion.md`

**摘要**：Adds a distortion audio effect to an audio bus. 		Remaps audio samples using a nonlinear function to achieve a distorted sound.

## 描述

A "distortion" effect modifies the waveform via a nonlinear mathematical function (see available ones in `Mode`), based on the amplitude of the waveform's samples.
		**Note:** In a nonlinear function, an input sample at *x* amplitude value, will either have its amplitude increased or decreased to a *y* value, based on the function value at *x*, which is why even at the same `drive`, the output sound will vary depending on the input's volume. To change the volume while maintaining the output waveform, use `post_gain`.
		In this effect, each type is a different nonlinear function. The different types available are: clip, atan, lofi (bitcrush), overdrive, and waveshape. Every distortion type available here is symmetric: negative amplitude values are affected the same way as positive ones.
		Although distortion will always change frequency content, usually by introducing high harmonics, different distortion types offer a range of sound qualities; from "soft" and "warm", to "crunchy" and "abrasive".
		For games, it can help simulate sound coming from some saturated device or speaker very efficiently. It can also help the audio stand out in a mix, by introducing higher frequencies and increasing the volume.
		**Note:** Although usually imperceptible, an enabled distortion effect still changes the sound even when `drive` is set to 0. This is not a bug. If this behavior is undesirable, consider disabling the effect using `AudioServer.set_bus_effect_enabled`.

## 属性

- **`drive`** `float` = `0.0`
  - 其它属性：getter=get_drive · setter=set_drive
- **`keep_hf_hz`** `float` = `16000.0`
  - 其它属性：getter=get_keep_hf_hz · setter=set_keep_hf_hz
- **`mode`** `int` = `0` · 枚举 `AudioEffectDistortion.Mode`
  - 其它属性：getter=get_mode · setter=set_mode
- **`post_gain`** `float` = `0.0`
  - 其它属性：getter=get_post_gain · setter=set_post_gain
- **`pre_gain`** `float` = `0.0`
  - 其它属性：getter=get_pre_gain · setter=set_pre_gain

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_CLIP` |  |
| `1` | `MODE_ATAN` |  |
| `2` | `MODE_LOFI` |  |
| `3` | `MODE_OVERDRIVE` |  |
| `4` | `MODE_WAVESHAPE` |  |

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

