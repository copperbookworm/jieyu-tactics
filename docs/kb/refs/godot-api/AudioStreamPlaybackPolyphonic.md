# AudioStreamPlaybackPolyphonic

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlaybackPolyphonic` → `AudioStreamPlayback` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlaybackPolyphonic.md`

**摘要**：Playback instance for `AudioStreamPolyphonic`.

## 描述

Playback instance for `AudioStreamPolyphonic`. After setting the `stream` property of `AudioStreamPlayer`, `AudioStreamPlayer2D`, or `AudioStreamPlayer3D`, the playback instance can be obtained by calling `AudioStreamPlayer.get_stream_playback`, `AudioStreamPlayer2D.get_stream_playback` or `AudioStreamPlayer3D.get_stream_playback` methods.

## 方法

### `is_stream_playing(stream: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the stream associated with the given integer ID is still playing. Check `play_stream` for information on when this ID becomes invalid.

### `play_stream(stream: AudioStream, from_offset: float = 0, volume_db: float = 0, pitch_scale: float = 1.0, playback_type: int = 0, bus: StringName = &"Master") -> int`

Play an `AudioStream` at a given offset, volume, pitch scale, playback type, and bus. Playback starts immediately.
				The return value is a unique integer ID that is associated to this playback stream and which can be used to control it.
				This ID becomes invalid when the stream ends (if it does not loop), when the `AudioStreamPlaybackPolyphonic` is stopped, or when `stop_stream` is called.
				This function returns `INVALID_ID` if the amount of streams currently playing equals `AudioStreamPolyphonic.polyphony`. If you need a higher amount of maximum polyphony, raise this value.

### `set_stream_pitch_scale(stream: int, pitch_scale: float) -> void`

Change the stream pitch scale. The `stream` argument is an integer ID returned by `play_stream`.

### `set_stream_volume(stream: int, volume_db: float) -> void`

Change the stream volume (in db). The `stream` argument is an integer ID returned by `play_stream`.

### `stop_stream(stream: int) -> void`

Stop a stream. The `stream` argument is an integer ID returned by `play_stream`, which becomes invalid after calling this function.

## 常量

- **`INVALID_ID`** = `-1`
