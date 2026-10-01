# AudioEffectEQ

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectEQ` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectEQ.md`

**摘要**：Base class for audio equalizers (EQ). Gives you control over frequencies. 		Use it to create a custom equalizer if `AudioEffectEQ6`, `AudioEffectEQ10`, or `AudioEffectEQ21` don't fit your needs.

## 描述

An "equalizer" gives you control over the gain of frequencies in the entire spectrum, by allowing their adjustment through bands. A band is a point in the frequency spectrum, and each band means a division of the spectrum that can be adjusted.
		Use equalizers to compensate for existing deficiencies in the audio, make room for other elements, or remove undesirable frequencies. AudioEffectEQs are useful on the Master bus to balance the entire mix or give it more character. They are also useful when a game is run on a mobile device, to adjust the mix to that kind of speakers (it can be disabled when headphones are plugged in).

## 方法

### `get_band_count() -> int`
- 限定：qualifiers=const

Returns the number of bands of the equalizer.

### `get_band_gain_db(band_idx: int) -> float`
- 限定：qualifiers=const

Returns the band's gain at the specified index, in dB.

### `set_band_gain_db(band_idx: int, volume_db: float) -> void`

Sets band's gain at the specified index, in dB.

## 教程链接

- [Audio buses](None)
- [Audio effects](None)

