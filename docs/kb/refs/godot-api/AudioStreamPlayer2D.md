# AudioStreamPlayer2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlayer2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sound, sfx
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlayer2D.md`

**摘要**：Plays positional sound in 2D space.

## 描述

Plays audio that is attenuated with distance to the listener.
		By default, audio is heard from the screen center. This can be changed by adding an `AudioListener2D` node to the scene and enabling it by calling `AudioListener2D.make_current` on it.
		See also `AudioStreamPlayer` to play a sound non-positionally.
		**Note:** Hiding an `AudioStreamPlayer2D` node does not disable its audio output. To temporarily disable an `AudioStreamPlayer2D`'s audio output, set `volume_db` to a very low value like `-100` (which isn't audible to human hearing).

## 属性

- **`area_mask`** `int` = `0`
  - 其它属性：getter=get_area_mask · setter=set_area_mask
- **`attenuation`** `float` = `1.0`
  - 其它属性：getter=get_attenuation · setter=set_attenuation
- **`autoplay`** `bool` = `false`
  - 其它属性：getter=is_autoplay_enabled · setter=set_autoplay
- **`bus`** `StringName` = `&"Master"`
  - 其它属性：getter=get_bus · setter=set_bus
- **`max_distance`** `float` = `2000.0`
  - 其它属性：getter=get_max_distance · setter=set_max_distance
- **`max_polyphony`** `int` = `1`
  - 其它属性：getter=get_max_polyphony · setter=set_max_polyphony
- **`panning_strength`** `float` = `1.0`
  - 其它属性：getter=get_panning_strength · setter=set_panning_strength
- **`pitch_scale`** `float` = `1.0`
  - 其它属性：getter=get_pitch_scale · setter=set_pitch_scale
- **`playback_type`** `int` = `0` · 枚举 `AudioServer.PlaybackType`
  - 其它属性：experimental= · getter=get_playback_type · setter=set_playback_type
- **`playing`** `bool` = `false`
  - 其它属性：getter=is_playing · setter=set_playing
- **`stream`** `AudioStream`
  - 其它属性：getter=get_stream · setter=set_stream
- **`stream_paused`** `bool` = `false`
  - 其它属性：getter=get_stream_paused · setter=set_stream_paused
- **`volume_db`** `float` = `0.0`
  - 其它属性：getter=get_volume_db · setter=set_volume_db
- **`volume_linear`** `float`
  - 其它属性：getter=get_volume_linear · setter=set_volume_linear

## 方法

### `get_playback_position() -> float`

Returns the position in the `AudioStream`.

### `get_stream_playback() -> AudioStreamPlayback`

Returns the `AudioStreamPlayback` object associated with this `AudioStreamPlayer2D`.

### `has_stream_playback() -> bool`

Returns whether the `AudioStreamPlayer` can return the `AudioStreamPlayback` object or not.

### `play(from_position: float = 0.0) -> void`

Queues the audio to play on the next physics frame, from the given position `from_position`, in seconds.

### `seek(to_position: float) -> void`

Sets the position from which audio will be played, in seconds.

### `stop() -> void`

Stops the audio.

## 信号

### `finished()`

Emitted when the audio stops playing.

## 教程链接

- [Audio streams](None)

