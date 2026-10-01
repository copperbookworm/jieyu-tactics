# OggPacketSequence

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OggPacketSequence` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OggPacketSequence.md`

**摘要**：A sequence of Ogg packets.

## 描述

A sequence of Ogg packets.

## 属性

- **`granule_positions`** `PackedInt64Array` = `PackedInt64Array()`
  - 其它属性：getter=get_packet_granule_positions · setter=set_packet_granule_positions
- **`packet_data`** `Array[]` = `[]`
  - 其它属性：getter=get_packet_data · setter=set_packet_data
- **`sampling_rate`** `float` = `0.0`
  - 其它属性：getter=get_sampling_rate · setter=set_sampling_rate

## 方法

### `get_length() -> float`
- 限定：qualifiers=const

The length of this stream, in seconds.

