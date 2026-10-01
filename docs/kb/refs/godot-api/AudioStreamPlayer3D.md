# AudioStreamPlayer3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlayer3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sound, sfx
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlayer3D.md`

**摘要**：Plays positional sound in 3D space.

## 描述

Plays audio with positional sound effects, based on the relative position of the audio listener. Positional effects include distance attenuation, directionality, and the Doppler effect. For greater realism, a low-pass filter is applied to distant sounds. This can be disabled by setting `attenuation_filter_cutoff_hz` to `20500`.
		By default, audio is heard from the camera position. This can be changed by adding an `AudioListener3D` node to the scene and enabling it by calling `AudioListener3D.make_current` on it.
		See also `AudioStreamPlayer` to play a sound non-positionally.
		**Note:** Hiding an `AudioStreamPlayer3D` node does not disable its audio output. To temporarily disable an `AudioStreamPlayer3D`'s audio output, set `volume_db` to a very low value like `-100` (which isn't audible to human hearing).

## 属性

- **`area_mask`** `int` = `0`
  - 其它属性：getter=get_area_mask · setter=set_area_mask
- **`attenuation_filter_cutoff_hz`** `float` = `5000.0`
  - 其它属性：getter=get_attenuation_filter_cutoff_hz · setter=set_attenuation_filter_cutoff_hz
- **`attenuation_filter_db`** `float` = `-24.0`
  - 其它属性：getter=get_attenuation_filter_db · setter=set_attenuation_filter_db
- **`attenuation_model`** `int` = `0` · 枚举 `AudioStreamPlayer3D.AttenuationModel`
  - 其它属性：getter=get_attenuation_model · setter=set_attenuation_model
- **`autoplay`** `bool` = `false`
  - 其它属性：getter=is_autoplay_enabled · setter=set_autoplay
- **`bus`** `StringName` = `&"Master"`
  - 其它属性：getter=get_bus · setter=set_bus
- **`doppler_tracking`** `int` = `0` · 枚举 `AudioStreamPlayer3D.DopplerTracking`
  - 其它属性：getter=get_doppler_tracking · setter=set_doppler_tracking
- **`emission_angle_degrees`** `float` = `45.0`
  - 其它属性：getter=get_emission_angle · setter=set_emission_angle
- **`emission_angle_enabled`** `bool` = `false`
  - 其它属性：getter=is_emission_angle_enabled · setter=set_emission_angle_enabled
- **`emission_angle_filter_attenuation_db`** `float` = `-12.0`
  - 其它属性：getter=get_emission_angle_filter_attenuation_db · setter=set_emission_angle_filter_attenuation_db
- **`max_db`** `float` = `3.0`
  - 其它属性：getter=get_max_db · setter=set_max_db
- **`max_distance`** `float` = `0.0`
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
- **`unit_size`** `float` = `10.0`
  - 其它属性：getter=get_unit_size · setter=set_unit_size
- **`volume_db`** `float` = `0.0`
  - 其它属性：getter=get_volume_db · setter=set_volume_db
- **`volume_linear`** `float`
  - 其它属性：getter=get_volume_linear · setter=set_volume_linear

## 方法

### `get_playback_position() -> float`

Returns the position in the `AudioStream`.

### `get_stream_playback() -> AudioStreamPlayback`

Returns the `AudioStreamPlayback` object associated with this `AudioStreamPlayer3D`.

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

## 枚举

### `AttenuationModel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ATTENUATION_INVERSE_DISTANCE` |  |
| `1` | `ATTENUATION_INVERSE_SQUARE_DISTANCE` |  |
| `2` | `ATTENUATION_LOGARITHMIC` |  |
| `3` | `ATTENUATION_DISABLED` |  |

### `DopplerTracking`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOPPLER_TRACKING_DISABLED` |  |
| `1` | `DOPPLER_TRACKING_IDLE_STEP` |  |
| `2` | `DOPPLER_TRACKING_PHYSICS_STEP` |  |

## 教程链接

- [Audio streams](None)

