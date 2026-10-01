# StreamPeerBuffer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StreamPeerBuffer` → `StreamPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StreamPeerBuffer.md`

**摘要**：A stream peer used to handle binary data streams.

## 描述

A data buffer stream peer that uses a byte array as the stream. This object can be used to handle binary data from network sessions. To handle binary data stored in files, `FileAccess` can be used directly.
		A `StreamPeerBuffer` object keeps an internal cursor which is the offset in bytes to the start of the buffer. Get and put operations are performed at the cursor position and will move the cursor accordingly.

## 属性

- **`data_array`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_data_array · setter=set_data_array

## 方法

### `clear() -> void`

Clears the `data_array` and resets the cursor.

### `duplicate() -> StreamPeerBuffer`
- 限定：qualifiers=const

Returns a new `StreamPeerBuffer` with the same `data_array` content.

### `get_position() -> int`
- 限定：qualifiers=const

Returns the current cursor position.

### `get_size() -> int`
- 限定：qualifiers=const

Returns the size of `data_array`.

### `resize(size: int) -> void`

Resizes the `data_array`. This *doesn't* update the cursor.

### `seek(position: int) -> void`

Moves the cursor to the specified position. `position` must be a valid index of `data_array`.

