# AudioEffectCapture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioEffectCapture` → `AudioEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioEffectCapture.md`

**摘要**：Exposes audio samples from an audio bus in real-time, such that it can be accessed as data.

## 描述

Copies all audio frames, also known as "samples" or "audio samples", from the attached audio bus into its internal ring buffer. This effect does not alter the audio. Can be used for storing real-time audio data for playback, and for creating real-time audio visualizations, like an oscilloscope.
		Application code should consume these audio frames from this ring buffer using `get_buffer` and process it as needed, for example to capture data from an `AudioStreamMicrophone`, implement application-defined effects, or to transmit audio over the network. When capturing audio data from a microphone, the format of the samples will be stereo 32-bit floating-point PCM.
		Unlike `AudioEffectRecord`, this effect only returns the raw audio samples instead of encoding them into an `AudioStream`.

## 属性

- **`buffer_length`** `float` = `0.1`
  - 其它属性：getter=get_buffer_length · setter=set_buffer_length

## 方法

### `can_get_buffer(frames: int) -> bool`
- 限定：qualifiers=const

Returns `true` if at least `frames` samples are available to read in the internal ring buffer.

### `clear_buffer() -> void`

Clears the internal ring buffer.
				**Note:** Calling this during a capture can cause the loss of samples which causes popping in the playback.

### `get_buffer(frames: int) -> PackedVector2Array`

Gets the next `frames` samples from the internal ring buffer.
				Returns a `PackedVector2Array` containing exactly `frames` samples if available, or an empty `PackedVector2Array` if insufficient data was available.
				The samples are signed floating-point PCM between `-1` and `1`. You will have to scale them if you want to use them as 8 or 16-bit integer samples. (`v = 0x7fff * samples[0].x`)

### `get_buffer_length_frames() -> int`
- 限定：qualifiers=const

Returns the total size of the internal ring buffer in number of samples.

### `get_discarded_frames() -> int`
- 限定：qualifiers=const

Returns the number of samples discarded from the audio bus due to full buffer.

### `get_frames_available() -> int`
- 限定：qualifiers=const

Returns the number of samples available to read using `get_buffer`.

### `get_pushed_frames() -> int`
- 限定：qualifiers=const

Returns the number of samples inserted from the audio bus.

## 教程链接

- [Audio buses](None)

