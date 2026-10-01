# AudioStreamPlayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlayer` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sound, music, song
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlayer.md`

**摘要**：A node for audio playback.

## 描述

The `AudioStreamPlayer` node plays an audio stream non-positionally. It is ideal for user interfaces, menus, or background music.
		To use this node, `stream` needs to be set to a valid `AudioStream` resource. Playing more than one sound at the same time is also supported, see `max_polyphony`.
		If you need to play audio at a specific position, use `AudioStreamPlayer2D` or `AudioStreamPlayer3D` instead.

## 属性

- **`autoplay`** `bool` = `false`
  - 其它属性：getter=is_autoplay_enabled · setter=set_autoplay
- **`bus`** `StringName` = `&"Master"`
  - 其它属性：getter=get_bus · setter=set_bus
- **`max_polyphony`** `int` = `1`
  - 其它属性：getter=get_max_polyphony · setter=set_max_polyphony
- **`mix_target`** `int` = `0` · 枚举 `AudioStreamPlayer.MixTarget`
  - 其它属性：getter=get_mix_target · setter=set_mix_target
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

Returns the position in the `AudioStream` of the latest sound, in seconds. Returns `0.0` if no sounds are playing.
				**Note:** The position is not always accurate, as the `AudioServer` does not mix audio every processed frame. To get more accurate results, add `AudioServer.get_time_since_last_mix` to the returned position.
				**Note:** This method always returns `0.0` if the `stream` is an `AudioStreamInteractive`, since it can have multiple clips playing at once.

### `get_stream_playback() -> AudioStreamPlayback`

Returns the latest `AudioStreamPlayback` of this node, usually the most recently created by `play`. If no sounds are playing, this method fails and returns an empty playback.

### `has_stream_playback() -> bool`

Returns `true` if any sound is active, even if `stream_paused` is set to `true`. See also `playing` and `get_stream_playback`.

### `play(from_position: float = 0.0) -> void`

Plays a sound from the beginning, or the given `from_position` in seconds.

### `seek(to_position: float) -> void`

Restarts all sounds to be played from the given `to_position`, in seconds. Does nothing if no sounds are playing.

### `stop() -> void`

Stops all sounds from this node.

## 信号

### `finished()`

Emitted when a sound finishes playing without interruptions. This signal is *not* emitted when calling `stop`, or when exiting the tree while sounds are playing.

## 枚举

### `MixTarget`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MIX_TARGET_STEREO` |  |
| `1` | `MIX_TARGET_SURROUND` |  |
| `2` | `MIX_TARGET_CENTER` |  |

## 教程链接

- [Audio streams](None)
- [2D Dodge The Creeps Demo](None)
- [Audio Device Changer Demo](None)
- [Audio Generator Demo](None)
- [Audio Microphone Record Demo](None)
- [Audio Spectrum Visualizer Demo](None)

