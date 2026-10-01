# WebRTCDataChannel

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WebRTCDataChannel` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WebRTCDataChannel.md`

## 属性

- **`write_mode`** `int` = `1` · 枚举 `WebRTCDataChannel.WriteMode`
  - 其它属性：getter=get_write_mode · setter=set_write_mode

## 方法

### `close() -> void`

Closes this data channel, notifying the other peer.

### `get_buffered_amount() -> int`
- 限定：qualifiers=const

Returns the number of bytes currently queued to be sent over this channel.

### `get_id() -> int`
- 限定：qualifiers=const

Returns the ID assigned to this channel during creation (or auto-assigned during negotiation).
				If the channel is not negotiated out-of-band the ID will only be available after the connection is established (will return `65535` until then).

### `get_label() -> String`
- 限定：qualifiers=const

Returns the label assigned to this channel during creation.

### `get_max_packet_life_time() -> int`
- 限定：qualifiers=const

Returns the `maxPacketLifeTime` value assigned to this channel during creation.
				Will be `65535` if not specified.

### `get_max_retransmits() -> int`
- 限定：qualifiers=const

Returns the `maxRetransmits` value assigned to this channel during creation.
				Will be `65535` if not specified.

### `get_protocol() -> String`
- 限定：qualifiers=const

Returns the sub-protocol assigned to this channel during creation. An empty string if not specified.

### `get_ready_state() -> int`
- 限定：qualifiers=const

Returns the current state of this channel.

### `is_negotiated() -> bool`
- 限定：qualifiers=const

Returns `true` if this channel was created with out-of-band configuration.

### `is_ordered() -> bool`
- 限定：qualifiers=const

Returns `true` if this channel was created with ordering enabled (default).

### `poll() -> int`

Reserved, but not used for now.

### `was_string_packet() -> bool`
- 限定：qualifiers=const

Returns `true` if the last received packet was transferred as text. See `write_mode`.

## 枚举

### `WriteMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WRITE_MODE_TEXT` |  |
| `1` | `WRITE_MODE_BINARY` |  |

### `ChannelState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATE_CONNECTING` |  |
| `1` | `STATE_OPEN` |  |
| `2` | `STATE_CLOSING` |  |
| `3` | `STATE_CLOSED` |  |

