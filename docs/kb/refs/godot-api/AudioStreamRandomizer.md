# AudioStreamRandomizer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamRandomizer` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamRandomizer.md`

**摘要**：Wraps a pool of audio streams with pitch and volume shifting.

## 描述

Picks a random AudioStream from the pool, depending on the playback mode, and applies random pitch shifting and volume shifting during playback.

## 属性

- **`playback_mode`** `int` = `0` · 枚举 `AudioStreamRandomizer.PlaybackMode`
  - 其它属性：getter=get_playback_mode · setter=set_playback_mode
- **`random_pitch`** `float` = `1.0`
  - 其它属性：getter=get_random_pitch · setter=set_random_pitch
- **`random_pitch_semitones`** `float` = `0.0`
  - 其它属性：getter=get_random_pitch_semitones · setter=set_random_pitch_semitones
- **`random_volume_offset_db`** `float` = `0.0`
  - 其它属性：getter=get_random_volume_offset_db · setter=set_random_volume_offset_db
- **`stream_{index}/stream`** `AudioStream`
  - 其它属性：getter= · setter=
- **`stream_{index}/weight`** `float` = `1.0`
  - 其它属性：getter= · setter=
- **`streams_count`** `int` = `0`
  - 其它属性：getter=get_streams_count · setter=set_streams_count

## 方法

### `add_stream(index: int, stream: AudioStream, weight: float = 1.0) -> void`

Insert a stream at the specified index. If the index is less than zero, the insertion occurs at the end of the underlying pool.

### `get_stream(index: int) -> AudioStream`
- 限定：qualifiers=const

Returns the stream at the specified index.

### `get_stream_probability_weight(index: int) -> float`
- 限定：qualifiers=const

Returns the probability weight associated with the stream at the given index.

### `move_stream(index_from: int, index_to: int) -> void`

Move a stream from one index to another.

### `remove_stream(index: int) -> void`

Remove the stream at the specified index.

### `set_stream(index: int, stream: AudioStream) -> void`

Set the AudioStream at the specified index.

### `set_stream_probability_weight(index: int, weight: float) -> void`

Set the probability weight of the stream at the specified index. The higher this value, the more likely that the randomizer will choose this stream during random playback modes.

## 枚举

### `PlaybackMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PLAYBACK_RANDOM_NO_REPEATS` |  |
| `1` | `PLAYBACK_RANDOM` |  |
| `2` | `PLAYBACK_SEQUENTIAL` |  |

## 教程链接

- [Audio streams](None)

