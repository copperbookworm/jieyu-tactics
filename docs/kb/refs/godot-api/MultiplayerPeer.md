# MultiplayerPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MultiplayerPeer` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core · keywords=network
> 自动生成，勿手改。文件：`refs/godot-api/MultiplayerPeer.md`

**摘要**：Abstract class for specialized `PacketPeer`s used by the `MultiplayerAPI`.

## 描述

Manages the connection with one or more remote peers acting as server or client and assigning unique IDs to each of them. See also `MultiplayerAPI`.
		**Note:** The `MultiplayerAPI` protocol is an implementation detail and isn't meant to be used by non-Godot servers. It may change without notice.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 属性

- **`refuse_new_connections`** `bool` = `false`
  - 其它属性：getter=is_refusing_new_connections · setter=set_refuse_new_connections
- **`transfer_channel`** `int` = `0`
  - 其它属性：getter=get_transfer_channel · setter=set_transfer_channel
- **`transfer_mode`** `int` = `2` · 枚举 `MultiplayerPeer.TransferMode`
  - 其它属性：getter=get_transfer_mode · setter=set_transfer_mode

## 方法

### `close() -> void`

Immediately close the multiplayer peer returning to the state `CONNECTION_DISCONNECTED`. Connected peers will be dropped without emitting `peer_disconnected`.

### `disconnect_peer(peer: int, force: bool = false) -> void`

Disconnects the given `peer` from this host. If `force` is `true` the `peer_disconnected` signal will not be emitted for this peer.

### `generate_unique_id() -> int`
- 限定：qualifiers=const

Returns a randomly generated integer that can be used as a network unique ID.

### `get_connection_status() -> int`
- 限定：qualifiers=const

Returns the current state of the connection.

### `get_packet_channel() -> int`
- 限定：qualifiers=const

Returns the channel over which the next available packet was received. See `PacketPeer.get_available_packet_count`.

### `get_packet_mode() -> int`
- 限定：qualifiers=const

Returns the transfer mode the remote peer used to send the next available packet. See `PacketPeer.get_available_packet_count`.

### `get_packet_peer() -> int`
- 限定：qualifiers=const

Returns the ID of the `MultiplayerPeer` who sent the next available packet. See `PacketPeer.get_available_packet_count`.

### `get_unique_id() -> int`
- 限定：qualifiers=const

Returns the ID of this `MultiplayerPeer`.

### `is_server_relay_supported() -> bool`
- 限定：qualifiers=const

Returns `true` if the server can act as a relay in the current configuration. That is, if the higher level `MultiplayerAPI` should notify connected clients of other peers, and implement a relay protocol to allow communication between them.

### `poll() -> void`

Waits up to 1 second to receive a new network event.

### `set_target_peer(id: int) -> void`

Sets the peer to which packets will be sent.
				The `id` can be one of: `TARGET_PEER_BROADCAST` to send to all connected peers, `TARGET_PEER_SERVER` to send to the peer acting as server, a valid peer ID to send to that specific peer, a negative peer ID to send to all peers except that one. By default, the target peer is `TARGET_PEER_BROADCAST`.

## 信号

### `peer_connected(id: int)`

Emitted when a remote peer connects.

### `peer_disconnected(id: int)`

Emitted when a remote peer has disconnected.

## 枚举

### `ConnectionStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONNECTION_DISCONNECTED` |  |
| `1` | `CONNECTION_CONNECTING` |  |
| `2` | `CONNECTION_CONNECTED` |  |

### `TransferMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSFER_MODE_UNRELIABLE` |  |
| `1` | `TRANSFER_MODE_UNRELIABLE_ORDERED` |  |
| `2` | `TRANSFER_MODE_RELIABLE` |  |

## 常量

- **`TARGET_PEER_BROADCAST`** = `0`
- **`TARGET_PEER_SERVER`** = `1`
## 教程链接

- [High-level multiplayer](None)

