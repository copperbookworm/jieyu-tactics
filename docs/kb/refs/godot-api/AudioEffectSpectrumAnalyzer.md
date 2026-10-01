# AudioEffectSpectrumAnalyzer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectSpectrumAnalyzer` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectSpectrumAnalyzer.md`

**摘要**：Creates an `AudioEffectInstance` which performs frequency analysis and exposes results to be accessed in real-time.

## 描述

Calculates a Fourier Transform of the audio signal. This effect does not alter the audio. Can be used for creating real-time audio visualizations, like a spectrogram.
		This resource configures an `AudioEffectSpectrumAnalyzerInstance`, which performs the actual analysis at runtime. An instance should be obtained with `AudioServer.get_bus_effect_instance` to make use of this effect.

## 属性

- **`buffer_length`** `float` = `2.0`
  - 其它属性：getter=get_buffer_length · setter=set_buffer_length
- **`fft_size`** `int` = `2` · 枚举 `AudioEffectSpectrumAnalyzer.FFTSize`
  - 其它属性：getter=get_fft_size · setter=set_fft_size

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
- [Audio Spectrum Visualizer Demo](None)

