# AudioStreamPlaybackResampled

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlaybackResampled` → `AudioStreamPlayback` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlaybackResampled.md`

**摘要**：Playback class used for resampled `AudioStream`s.

## 描述

Playback class used to mix an `AudioStream`'s audio samples to `AudioServer.get_mix_rate` using cubic interpolation.

## 方法

### `_get_stream_sampling_rate() -> float`
- 限定：qualifiers=virtual required const

Returns an `AudioStream`'s sample rate, in Hz. Used to perform resampling.

### `_mix_resampled(dst_buffer: AudioFrame*, frame_count: int) -> int`
- 限定：qualifiers=virtual required

Called by `begin_resample` to mix an `AudioStream` to `AudioServer.get_mix_rate`. Uses `_get_stream_sampling_rate` as the source sample rate. Returns the number of mixed frames.

### `begin_resample() -> void`

Called when an `AudioStream` is played. Clears the cubic interpolation history and starts mixing by calling `_mix_resampled`.

