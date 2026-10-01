# AudioStreamSynchronized

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamSynchronized` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamSynchronized.md`

**摘要**：Stream that can be fitted with sub-streams, which will be played in-sync.

## 描述

This is a stream that can be fitted with sub-streams, which will be played in-sync. The streams begin at exactly the same time when play is pressed, and will end when the last of them ends. If one of the sub-streams loops, then playback will continue.

## 属性

- **`stream_count`** `int` = `0`
  - 其它属性：getter=get_stream_count · setter=set_stream_count

## 方法

### `get_sync_stream(stream_index: int) -> AudioStream`
- 限定：qualifiers=const

Get one of the synchronized streams, by index.

### `get_sync_stream_volume(stream_index: int) -> float`
- 限定：qualifiers=const

Get the volume of one of the synchronized streams, by index.

### `set_sync_stream(stream_index: int, audio_stream: AudioStream) -> void`

Set one of the synchronized streams, by index.

### `set_sync_stream_volume(stream_index: int, volume_db: float) -> void`

Set the volume of one of the synchronized streams, by index.

## 常量

- **`MAX_STREAMS`** = `32`
## 教程链接

- [Audio streams](None)

