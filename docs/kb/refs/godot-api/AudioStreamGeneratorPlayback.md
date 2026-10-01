# AudioStreamGeneratorPlayback

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamGeneratorPlayback` → `AudioStreamPlaybackResampled` → `AudioStreamPlayback` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamGeneratorPlayback.md`

**摘要**：Plays back audio generated using `AudioStreamGenerator`.

## 描述

This class is meant to be used with `AudioStreamGenerator` to play back the generated audio in real-time.

## 方法

### `can_push_buffer(amount: int) -> bool`
- 限定：qualifiers=const

Returns `true` if a buffer of the size `amount` can be pushed to the audio sample data buffer without overflowing it, `false` otherwise.

### `clear_buffer() -> void`

Clears the audio sample data buffer.

### `get_frames_available() -> int`
- 限定：qualifiers=const

Returns the number of frames that can be pushed to the audio sample data buffer without overflowing it. If the result is `0`, the buffer is full.

### `get_skips() -> int`
- 限定：qualifiers=const

Returns the number of times the playback skipped due to a buffer underrun in the audio sample data. This value is reset at the start of the playback.

### `push_buffer(frames: PackedVector2Array) -> bool`

Pushes several audio data frames to the buffer. This is usually more efficient than `push_frame` in C# and compiled languages via GDExtension, but `push_buffer` may be *less* efficient in GDScript.

### `push_frame(frame: Vector2) -> bool`

Pushes a single audio data frame to the buffer. This is usually less efficient than `push_buffer` in C# and compiled languages via GDExtension, but `push_frame` may be *more* efficient in GDScript.

## 教程链接

- [Audio Generator Demo](None)
- [Godot 3.2 will get new audio features](None)

