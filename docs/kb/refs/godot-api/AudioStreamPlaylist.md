# AudioStreamPlaylist

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamPlaylist` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamPlaylist.md`

**摘要**：`AudioStream` that includes sub-streams and plays them back like a playlist.

## 描述

An audio stream that can play back sub-streams in sequence. Streams can be added to the Playlist with `set_list_stream`, and shuffled with `shuffle`.

## 属性

- **`fade_time`** `float` = `0.3`
  - 其它属性：getter=get_fade_time · setter=set_fade_time
- **`loop`** `bool` = `true`
  - 其它属性：getter=has_loop · setter=set_loop
- **`shuffle`** `bool` = `false`
  - 其它属性：getter=get_shuffle · setter=set_shuffle
- **`stream_count`** `int` = `0`
  - 其它属性：getter=get_stream_count · setter=set_stream_count

## 方法

### `get_bpm() -> float`
- 限定：qualifiers=const

Returns the BPM of the playlist, which can vary depending on the clip being played.

### `get_list_stream(stream_index: int) -> AudioStream`
- 限定：qualifiers=const

Returns the stream at playback position index.

### `set_list_stream(stream_index: int, audio_stream: AudioStream) -> void`

Sets the stream at playback position index.

## 常量

- **`MAX_STREAMS`** = `64`
## 教程链接

- [Audio streams](None)

