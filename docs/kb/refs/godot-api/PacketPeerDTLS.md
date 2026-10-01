# PacketPeerDTLS

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PacketPeerDTLS` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PacketPeerDTLS.md`

**摘要**：DTLS packet peer.

## 描述

This class represents a DTLS peer connection. It can be used to connect to a DTLS server, and is returned by `DTLSServer.take_connection`.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.
		**Warning:** TLS certificate revocation and certificate pinning are currently not supported. Revoked certificates are accepted as long as they are otherwise valid. If this is a concern, you may want to use automatically managed certificates with a short validity period.

## 方法

### `connect_to_peer(packet_peer: PacketPeerUDP, hostname: String, client_options: TLSOptions = null) -> int`

Connects a `packet_peer` beginning the DTLS handshake using the underlying `PacketPeerUDP` which must be connected (see `PacketPeerUDP.connect_to_host`). You can optionally specify the `client_options` to be used while verifying the TLS connections. See `TLSOptions.client` and `TLSOptions.client_unsafe`.

### `disconnect_from_peer() -> void`

Disconnects this peer, terminating the DTLS session.

### `get_status() -> int`
- 限定：qualifiers=const

Returns the status of the connection.

### `poll() -> void`

Poll the connection to check for incoming packets. Call this frequently to update the status and keep the connection working.

## 枚举

### `Status`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATUS_DISCONNECTED` |  |
| `1` | `STATUS_HANDSHAKING` |  |
| `2` | `STATUS_CONNECTED` |  |
| `3` | `STATUS_ERROR` |  |
| `4` | `STATUS_ERROR_HOSTNAME_MISMATCH` |  |

