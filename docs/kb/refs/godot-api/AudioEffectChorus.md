# AudioEffectChorus

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectChorus` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectChorus.md`

**摘要**：Adds a chorus audio effect to an audio bus. 		Gives the impression of multiple audio sources.

## 描述

A "chorus" effect creates multiple copies of the original audio (called "voices") with variations in pitch, and layers on top of the original, giving the impression that the sound comes from multiple sources. This creates spectral and spatial movement.
		Each voice is played a short period of time after the original audio, controlled by `delay`. An internal low-frequency oscillator (LFO) controls their pitch, and `depth` controls the LFO's maximum amount.
		In the real world, this kind of effect is found in pianos, choirs, and instrument ensembles.
		This effect can also be used to widen mono audio and make digital sounds have a more natural or analog quality.

## 属性

- **`dry`** `float` = `1.0`
  - 其它属性：getter=get_dry · setter=set_dry
- **`voice/1/cutoff_hz`** `float` = `8000.0`
  - 其它属性：getter=get_voice_cutoff_hz · setter=set_voice_cutoff_hz
- **`voice/1/delay_ms`** `float` = `15.0`
  - 其它属性：getter=get_voice_delay_ms · setter=set_voice_delay_ms
- **`voice/1/depth_ms`** `float` = `2.0`
  - 其它属性：getter=get_voice_depth_ms · setter=set_voice_depth_ms
- **`voice/1/level_db`** `float` = `0.0`
  - 其它属性：getter=get_voice_level_db · setter=set_voice_level_db
- **`voice/1/pan`** `float` = `-0.5`
  - 其它属性：getter=get_voice_pan · setter=set_voice_pan
- **`voice/1/rate_hz`** `float` = `0.8`
  - 其它属性：getter=get_voice_rate_hz · setter=set_voice_rate_hz
- **`voice/2/cutoff_hz`** `float` = `8000.0`
  - 其它属性：getter=get_voice_cutoff_hz · setter=set_voice_cutoff_hz
- **`voice/2/delay_ms`** `float` = `20.0`
  - 其它属性：getter=get_voice_delay_ms · setter=set_voice_delay_ms
- **`voice/2/depth_ms`** `float` = `3.0`
  - 其它属性：getter=get_voice_depth_ms · setter=set_voice_depth_ms
- **`voice/2/level_db`** `float` = `0.0`
  - 其它属性：getter=get_voice_level_db · setter=set_voice_level_db
- **`voice/2/pan`** `float` = `0.5`
  - 其它属性：getter=get_voice_pan · setter=set_voice_pan
- **`voice/2/rate_hz`** `float` = `1.2`
  - 其它属性：getter=get_voice_rate_hz · setter=set_voice_rate_hz
- **`voice/3/cutoff_hz`** `float`
  - 其它属性：getter=get_voice_cutoff_hz · setter=set_voice_cutoff_hz
- **`voice/3/delay_ms`** `float`
  - 其它属性：getter=get_voice_delay_ms · setter=set_voice_delay_ms
- **`voice/3/depth_ms`** `float`
  - 其它属性：getter=get_voice_depth_ms · setter=set_voice_depth_ms
- **`voice/3/level_db`** `float`
  - 其它属性：getter=get_voice_level_db · setter=set_voice_level_db
- **`voice/3/pan`** `float`
  - 其它属性：getter=get_voice_pan · setter=set_voice_pan
- **`voice/3/rate_hz`** `float`
  - 其它属性：getter=get_voice_rate_hz · setter=set_voice_rate_hz
- **`voice/4/cutoff_hz`** `float`
  - 其它属性：getter=get_voice_cutoff_hz · setter=set_voice_cutoff_hz
- **`voice/4/delay_ms`** `float`
  - 其它属性：getter=get_voice_delay_ms · setter=set_voice_delay_ms
- **`voice/4/depth_ms`** `float`
  - 其它属性：getter=get_voice_depth_ms · setter=set_voice_depth_ms
- **`voice/4/level_db`** `float`
  - 其它属性：getter=get_voice_level_db · setter=set_voice_level_db
- **`voice/4/pan`** `float`
  - 其它属性：getter=get_voice_pan · setter=set_voice_pan
- **`voice/4/rate_hz`** `float`
  - 其它属性：getter=get_voice_rate_hz · setter=set_voice_rate_hz
- **`voice_count`** `int` = `2`
  - 其它属性：getter=get_voice_count · setter=set_voice_count
- **`wet`** `float` = `0.5`
  - 其它属性：getter=get_wet · setter=set_wet

## 方法

### `get_voice_cutoff_hz(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the frequency threshold of a given `voice_idx`'s low-pass filter in Hz. Frequencies above this value are removed from the voice.

### `get_voice_delay_ms(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the delay of a given `voice_idx` in milliseconds, compared to the original audio.

### `get_voice_depth_ms(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the depth of a given `voice_idx`'s low-frequency oscillator in milliseconds.

### `get_voice_level_db(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the gain of a given `voice_idx` in dB.

### `get_voice_pan(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the pan position of a given `voice_idx`. Negative values mean the left channel, positive mean the right.

### `get_voice_rate_hz(voice_idx: int) -> float`
- 限定：qualifiers=const

Returns the rate of a given `voice_idx`'s low-frequency oscillator in Hz.

### `set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float) -> void`

Sets the frequency threshold of a given `voice_idx`'s low-pass filter in Hz. Frequencies above `cutoff_hz` are removed from `voice_idx`. Value can range from 1 to 20500.

### `set_voice_delay_ms(voice_idx: int, delay_ms: float) -> void`

Sets the delay of a given `voice_idx` in milliseconds, compared to the original audio. Value can range from 0 to 50.

### `set_voice_depth_ms(voice_idx: int, depth_ms: float) -> void`

Sets the depth of a given `voice_idx`'s low-frequency oscillator in milliseconds. Value can range from 0 to 20.

### `set_voice_level_db(voice_idx: int, level_db: float) -> void`

Sets the gain of a given `voice_idx` in dB. Value can range from -60 to 24.

### `set_voice_pan(voice_idx: int, pan: float) -> void`

Sets the pan position of a given `voice_idx`. Negative values pan the sound to the left, positive pan to the right. Value can range from -1 to 1.

### `set_voice_rate_hz(voice_idx: int, rate_hz: float) -> void`

Sets the rate of a given `voice_idx`'s low-frequency oscillator in Hz. Value can range from 0.1 to 20.

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

