# AudioEffectPitchShift

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectPitchShift` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectPitchShift.md`

**摘要**：Adds a pitch-shifting audio effect to an audio bus. 		Raises or lowers the pitch of the input audio.

## 描述

Allows modulation of pitch without modifying speed. All frequencies can be raised or lowered with minimal effect on transients.

## 属性

- **`fft_size`** `int` = `3` · 枚举 `AudioEffectPitchShift.FFTSize`
  - 其它属性：getter=get_fft_size · setter=set_fft_size
- **`oversampling`** `int` = `4`
  - 其它属性：getter=get_oversampling · setter=set_oversampling
- **`pitch_scale`** `float` = `1.0`
  - 其它属性：getter=get_pitch_scale · setter=set_pitch_scale

## 枚举

### `FFTSize`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FFT_SIZE_256` |  |
| `1` | `FFT_SIZE_512` |  |
| `2` | `FFT_SIZE_1024` |  |
| `3` | `FFT_SIZE_2048` |  |
| `4` | `FFT_SIZE_4096` |  |
| `5` | `FFT_SIZE_MAX` |  |

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

