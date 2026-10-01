# AudioEffectSpectrumAnalyzerInstance

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectSpectrumAnalyzerInstance` → `AudioEffectInstance` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectSpectrumAnalyzerInstance.md`

**摘要**：Queryable instance of an `AudioEffectSpectrumAnalyzer`.

## 描述

The runtime part of an `AudioEffectSpectrumAnalyzer`, which can be used to query the magnitude of a frequency range on its host bus.
		An instance of this class can be obtained with `AudioServer.get_bus_effect_instance`.

## 方法

### `get_magnitude_for_frequency_range(from_hz: float, to_hz: float, mode: int = 1) -> Vector2`
- 限定：qualifiers=const

Returns the magnitude of the frequencies from `from_hz` to `to_hz` in linear energy as a Vector2. The `x` component of the return value represents the left stereo channel, and `y` represents the right channel.
				`mode` determines how the frequency range will be processed.

## 枚举

### `MagnitudeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MAGNITUDE_AVERAGE` |  |
| `1` | `MAGNITUDE_MAX` |  |

## 教程链接

- [Audio buses](None)
- [Audio effects](None)
- [Audio Spectrum Visualizer Demo](None)

