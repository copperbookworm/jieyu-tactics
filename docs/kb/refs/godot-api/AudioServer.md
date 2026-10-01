# AudioServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioServer.md`

**摘要**：Server interface for low-level audio access.

## 描述

`AudioServer` is a low-level server interface for audio access. It is in charge of creating sample data (playable audio) as well as its playback via a voice interface.

## 属性

- **`bus_count`** `int` = `1`
  - 其它属性：getter=get_bus_count · setter=set_bus_count
- **`input_device`** `String` = `"Default"`
  - 其它属性：getter=get_input_device · setter=set_input_device
- **`output_device`** `String` = `"Default"`
  - 其它属性：getter=get_output_device · setter=set_output_device
- **`playback_speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_playback_speed_scale · setter=set_playback_speed_scale

## 方法

### `add_bus(at_position: int = -1) -> void`

Adds a bus at `at_position`.

### `add_bus_effect(bus_idx: int, effect: AudioEffect, at_position: int = -1) -> void`

Adds an `AudioEffect` effect to the bus `bus_idx` at `at_position`.

### `generate_bus_layout() -> AudioBusLayout`
- 限定：qualifiers=const

Generates an `AudioBusLayout` using the available buses and effects.

### `get_bus_channels(bus_idx: int) -> int`
- 限定：qualifiers=const

Returns the number of channels of the bus at index `bus_idx`.

### `get_bus_effect(bus_idx: int, effect_idx: int) -> AudioEffect`

Returns the `AudioEffect` at position `effect_idx` in bus `bus_idx`.

### `get_bus_effect_count(bus_idx: int) -> int`

Returns the number of effects on the bus at `bus_idx`.

### `get_bus_effect_instance(bus_idx: int, effect_idx: int, channel: int = 0) -> AudioEffectInstance`

Returns the `AudioEffectInstance` assigned to the given bus and effect indices (and optionally channel).

### `get_bus_index(bus_name: StringName) -> int`
- 限定：qualifiers=const

Returns the index of the bus with the name `bus_name`. Returns `-1` if no bus with the specified name exist.

### `get_bus_name(bus_idx: int) -> String`
- 限定：qualifiers=const

Returns the name of the bus with the index `bus_idx`.

### `get_bus_peak_volume_left_db(bus_idx: int, channel: int) -> float`
- 限定：qualifiers=const

Returns the peak volume of the left speaker at bus index `bus_idx` and channel index `channel`.

### `get_bus_peak_volume_right_db(bus_idx: int, channel: int) -> float`
- 限定：qualifiers=const

Returns the peak volume of the right speaker at bus index `bus_idx` and channel index `channel`.

### `get_bus_send(bus_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the bus that the bus at index `bus_idx` sends to.

### `get_bus_volume_db(bus_idx: int) -> float`
- 限定：qualifiers=const

Returns the volume of the bus at index `bus_idx` in dB.

### `get_bus_volume_linear(bus_idx: int) -> float`
- 限定：qualifiers=const

Returns the volume of the bus at index `bus_idx` as a linear value.
				**Note:** The returned value is equivalent to the result of `@GlobalScope.db_to_linear` on the result of `get_bus_volume_db`.

### `get_driver_name() -> String`
- 限定：qualifiers=const

Returns the name of the current audio driver. The default usually depends on the operating system, but may be overridden via the `--audio-driver` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html). `--headless` also automatically sets the audio driver to `Dummy`. See also `ProjectSettings.audio/driver/driver`.

### `get_input_buffer_length_frames() -> int`
- 限定：experimental=

Returns the absolute size of the microphone input buffer. This is set to a multiple of the audio latency and can be used to estimate the minimum rate at which the frames need to be fetched.

### `get_input_device_list() -> PackedStringArray`

Returns the names of all audio input devices detected on the system.
				**Note:** `ProjectSettings.audio/driver/enable_input` must be `true` for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

### `get_input_frames(frames: int) -> PackedVector2Array`
- 限定：experimental=

Returns a `PackedVector2Array` containing exactly `frames` audio samples from the internal microphone buffer if available, otherwise returns an empty `PackedVector2Array`.
				The buffer is filled at the rate of `get_input_mix_rate` frames per second when `set_input_device_active` has successfully been set to `true`.
				The samples are signed floating-point PCM values between `-1` and `1`.

### `get_input_frames_available() -> int`
- 限定：experimental=

Returns the number of frames available to read using `get_input_frames`.

### `get_input_mix_rate() -> float`
- 限定：qualifiers=const

Returns the sample rate at the input of the `AudioServer`.

### `get_mix_rate() -> float`
- 限定：qualifiers=const

Returns the sample rate at the output of the `AudioServer`.

### `get_output_device_list() -> PackedStringArray`

Returns the names of all audio output devices detected on the system.

### `get_output_latency() -> float`
- 限定：qualifiers=const

Returns the audio driver's effective output latency. This is based on `ProjectSettings.audio/driver/output_latency`, but the exact returned value will differ depending on the operating system and audio driver.
				**Note:** This can be expensive; it is not recommended to call `get_output_latency` every frame.

### `get_speaker_mode() -> int`
- 限定：qualifiers=const

Returns the speaker configuration.

### `get_time_since_last_mix() -> float`
- 限定：qualifiers=const

Returns the relative time since the last mix occurred, in seconds.

### `get_time_to_next_mix() -> float`
- 限定：qualifiers=const

Returns the relative time until the next mix occurs, in seconds.

### `is_bus_bypassing_effects(bus_idx: int) -> bool`
- 限定：qualifiers=const

If `true`, the bus at index `bus_idx` is bypassing effects.

### `is_bus_effect_enabled(bus_idx: int, effect_idx: int) -> bool`
- 限定：qualifiers=const

If `true`, the effect at index `effect_idx` on the bus at index `bus_idx` is enabled.

### `is_bus_mute(bus_idx: int) -> bool`
- 限定：qualifiers=const

If `true`, the bus at index `bus_idx` is muted.

### `is_bus_solo(bus_idx: int) -> bool`
- 限定：qualifiers=const

If `true`, the bus at index `bus_idx` is in solo mode.

### `is_stream_registered_as_sample(stream: AudioStream) -> bool`
- 限定：experimental=

If `true`, the stream is registered as a sample. The engine will not have to register it before playing the sample.
				If `false`, the stream will have to be registered before playing it. To prevent lag spikes, register the stream as sample with `register_stream_as_sample`.

### `lock() -> void`

Locks the audio driver's main loop.
				**Note:** Remember to unlock it afterwards.

### `move_bus(index: int, to_index: int) -> void`

Moves the bus from index `index` to index `to_index`.

### `register_stream_as_sample(stream: AudioStream) -> void`
- 限定：experimental=

Forces the registration of a stream as a sample.
				**Note:** Lag spikes may occur when calling this method, especially on single-threaded builds. It is suggested to call this method while loading assets, where the lag spike could be masked, instead of registering the sample right before it needs to be played.

### `remove_bus(index: int) -> void`

Removes the bus at index `index`.

### `remove_bus_effect(bus_idx: int, effect_idx: int) -> void`

Removes the effect at index `effect_idx` from the bus at index `bus_idx`.

### `set_bus_bypass_effects(bus_idx: int, enable: bool) -> void`

If `true`, the bus at index `bus_idx` is bypassing effects.

### `set_bus_effect_enabled(bus_idx: int, effect_idx: int, enabled: bool) -> void`

If `true`, the effect at index `effect_idx` on the bus at index `bus_idx` is enabled.

### `set_bus_layout(bus_layout: AudioBusLayout) -> void`

Overwrites the currently used `AudioBusLayout`.

### `set_bus_mute(bus_idx: int, enable: bool) -> void`

If `true`, the bus at index `bus_idx` is muted.

### `set_bus_name(bus_idx: int, name: String) -> void`

Sets the name of the bus at index `bus_idx` to `name`.

### `set_bus_send(bus_idx: int, send: StringName) -> void`

Connects the output of the bus at `bus_idx` to the bus named `send`.

### `set_bus_solo(bus_idx: int, enable: bool) -> void`

If `true`, the bus at index `bus_idx` is in solo mode.

### `set_bus_volume_db(bus_idx: int, volume_db: float) -> void`

Sets the volume in decibels of the bus at index `bus_idx` to `volume_db`.

### `set_bus_volume_linear(bus_idx: int, volume_linear: float) -> void`

Sets the volume as a linear value of the bus at index `bus_idx` to `volume_linear`.
				**Note:** Using this method is equivalent to calling `set_bus_volume_db` with the result of `@GlobalScope.linear_to_db` on a value.

### `set_enable_tagging_used_audio_streams(enable: bool) -> void`

If set to `true`, all instances of `AudioStreamPlayback` will call `AudioStreamPlayback._tag_used_streams` every mix step.
				**Note:** This is enabled by default in the editor, as it is used by editor plugins for the audio stream previews.

### `set_input_device_active(active: bool) -> int`
- 限定：experimental=

If `active` is `true`, starts the microphone input stream specified by `input_device` or returns an error if it failed.
				If `active` is `false`, stops the input stream if it is running.

### `swap_bus_effects(bus_idx: int, effect_idx: int, by_effect_idx: int) -> void`

Swaps the position of two effects in bus `bus_idx`.

### `unlock() -> void`

Unlocks the audio driver's main loop. (After locking it, you should always unlock it.)

## 信号

### `bus_layout_changed()`

Emitted when an audio bus is added, deleted, or moved.

### `bus_renamed(bus_index: int, old_name: StringName, new_name: StringName)`

Emitted when the audio bus at `bus_index` is renamed from `old_name` to `new_name`.

## 枚举

### `SpeakerMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SPEAKER_MODE_STEREO` |  |
| `1` | `SPEAKER_SURROUND_31` |  |
| `2` | `SPEAKER_SURROUND_51` |  |
| `3` | `SPEAKER_SURROUND_71` |  |

### `PlaybackType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PLAYBACK_TYPE_DEFAULT` |  |
| `1` | `PLAYBACK_TYPE_STREAM` |  |
| `2` | `PLAYBACK_TYPE_SAMPLE` |  |
| `3` | `PLAYBACK_TYPE_MAX` |  |

## 教程链接

- [Audio buses](None)
- [Audio Device Changer Demo](None)
- [Audio Microphone Record Demo](None)
- [Audio Spectrum Visualizer Demo](None)

