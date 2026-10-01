# PacketPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PacketPeer.md`

**摘要**：Abstraction and base class for packet-based protocols.

## 描述

PacketPeer is an abstraction and base class for packet-based protocols (such as UDP). It provides an API for sending and receiving packets both as raw data or variables. This makes it easy to transfer data over a protocol, without having to encode data as low-level bytes or having to worry about network ordering.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 属性

- **`encode_buffer_max_size`** `int` = `8388608`
  - 其它属性：getter=get_encode_buffer_max_size · setter=set_encode_buffer_max_size

## 方法

### `get_available_packet_count() -> int`
- 限定：qualifiers=const

Returns the number of packets currently available in the ring-buffer.

### `get_packet() -> PackedByteArray`

Gets a raw packet.

### `get_packet_error() -> int`
- 限定：qualifiers=const

Returns the error state of the last packet received (via `get_packet` and `get_var`).

### `get_var(allow_objects: bool = false) -> Variant`

Gets a Variant. If `allow_objects` is `true`, decoding objects is allowed.
				Internally, this uses the same decoding mechanism as the `@GlobalScope.bytes_to_var` method.
				**Warning:** Deserialized objects can contain code which gets executed. Do not use this option if the serialized object comes from untrusted sources to avoid potential security threats such as remote code execution.

### `put_packet(buffer: PackedByteArray) -> int`

Sends a raw packet.

### `put_var(var: Variant, full_objects: bool = false) -> int`

Sends a `Variant` as a packet. If `full_objects` is `true`, encoding objects is allowed (and can potentially include code).
				Internally, this uses the same encoding mechanism as the `@GlobalScope.var_to_bytes` method.

