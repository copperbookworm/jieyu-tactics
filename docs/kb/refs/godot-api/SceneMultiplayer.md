# SceneMultiplayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SceneMultiplayer` → `MultiplayerAPI` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SceneMultiplayer.md`

**摘要**：High-level multiplayer API implementation.

## 描述

This class is the default implementation of `MultiplayerAPI`, used to provide multiplayer functionalities in Godot Engine.
		This implementation supports RPCs via `Node.rpc` and `Node.rpc_id` and requires `MultiplayerAPI.rpc` to be passed a `Node` (it will fail for other object types).
		This implementation additionally provide `SceneTree` replication via the `MultiplayerSpawner` and `MultiplayerSynchronizer` nodes, and the `SceneReplicationConfig` resource.
		**Note:** The high-level multiplayer API protocol is an implementation detail and isn't meant to be used by non-Godot servers. It may change without notice.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 属性

- **`allow_object_decoding`** `bool` = `false`
  - 其它属性：getter=is_object_decoding_allowed · setter=set_allow_object_decoding
- **`auth_callback`** `Callable` = `Callable()`
  - 其它属性：getter=get_auth_callback · setter=set_auth_callback
- **`auth_timeout`** `float` = `3.0`
  - 其它属性：getter=get_auth_timeout · setter=set_auth_timeout
- **`max_delta_packet_size`** `int` = `65535`
  - 其它属性：getter=get_max_delta_packet_size · setter=set_max_delta_packet_size
- **`max_sync_packet_size`** `int` = `1350`
  - 其它属性：getter=get_max_sync_packet_size · setter=set_max_sync_packet_size
- **`refuse_new_connections`** `bool` = `false`
  - 其它属性：getter=is_refusing_new_connections · setter=set_refuse_new_connections
- **`root_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_root_path · setter=set_root_path
- **`server_relay`** `bool` = `true`
  - 其它属性：getter=is_server_relay_enabled · setter=set_server_relay_enabled

## 方法

### `clear() -> void`

Clears the current SceneMultiplayer network state (you shouldn't call this unless you know what you are doing).

### `complete_auth(id: int) -> int`

Mark the authentication step as completed for the remote peer identified by `id`. The `MultiplayerAPI.peer_connected` signal will be emitted for this peer once the remote side also completes the authentication. No further authentication messages are expected to be received from this peer.
				If a peer disconnects before completing authentication, either due to a network issue, the `auth_timeout` expiring, or manually calling `disconnect_peer`, the `peer_authentication_failed` signal will be emitted instead of `MultiplayerAPI.peer_disconnected`.

### `disconnect_peer(id: int) -> void`

Disconnects the peer identified by `id`, removing it from the list of connected peers, and closing the underlying connection with it.

### `get_authenticating_peers() -> PackedInt32Array`

Returns the IDs of the peers currently trying to authenticate with this `MultiplayerAPI`.

### `send_auth(id: int, data: PackedByteArray) -> int`

Sends the specified `data` to the remote peer identified by `id` as part of an authentication message. This can be used to authenticate peers, and control when `MultiplayerAPI.peer_connected` is emitted (and the remote peer accepted as one of the connected peers).

### `send_bytes(bytes: PackedByteArray, id: int = 0, mode: int = 2, channel: int = 0) -> int`

Sends the given raw `bytes` to a specific peer identified by `id` (see `MultiplayerPeer.set_target_peer`). Default ID is `0`, i.e. broadcast to all peers.

## 信号

### `peer_authenticating(id: int)`

Emitted when this MultiplayerAPI's `MultiplayerAPI.multiplayer_peer` connects to a new peer and a valid `auth_callback` is set. In this case, the `MultiplayerAPI.peer_connected` will not be emitted until `complete_auth` is called with given peer `id`. While in this state, the peer will not be included in the list returned by `MultiplayerAPI.get_peers` (but in the one returned by `get_authenticating_peers`), and only authentication data will be sent or received. See `send_auth` for sending authentication data.

### `peer_authentication_failed(id: int)`

Emitted when this MultiplayerAPI's `MultiplayerAPI.multiplayer_peer` disconnects from a peer for which authentication had not yet completed. See `peer_authenticating`.

### `peer_packet(id: int, packet: PackedByteArray)`

Emitted when this MultiplayerAPI's `MultiplayerAPI.multiplayer_peer` receives a `packet` with custom data (see `send_bytes`). ID is the peer ID of the peer that sent the packet.

