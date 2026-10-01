# AudioEffectFilter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectFilter` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectFilter.md`

**摘要**：Base class for filters. Use effects that inherit this class instead of using it directly.

## 描述

A "filter" controls the gain of frequencies, using `cutoff_hz` as a frequency threshold. Filters can help to give room for each sound, and create interesting effects.
		There are different types of filter that inherit this class:
		Shelf filters: `AudioEffectLowShelfFilter` and `AudioEffectHighShelfFilter`
		Band-pass and notch filters: `AudioEffectBandPassFilter`, `AudioEffectBandLimitFilter`, and `AudioEffectNotchFilter`
		Low/high-pass filters: `AudioEffectLowPassFilter` and `AudioEffectHighPassFilter`

## 属性

- **`cutoff_hz`** `float` = `2000.0`
  - 其它属性：getter=get_cutoff · setter=set_cutoff
- **`db`** `int` = `0` · 枚举 `AudioEffectFilter.FilterDB`
  - 其它属性：getter=get_db · setter=set_db
- **`gain`** `float` = `1.0`
  - 其它属性：getter=get_gain · setter=set_gain
- **`resonance`** `float` = `0.5`
  - 其它属性：getter=get_resonance · setter=set_resonance

## 枚举

### `FilterDB`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILTER_6DB` |  |
| `1` | `FILTER_12DB` |  |
| `2` | `FILTER_18DB` |  |
| `3` | `FILTER_24DB` |  |

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

