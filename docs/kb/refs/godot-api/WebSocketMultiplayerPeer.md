# WebSocketMultiplayerPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WebSocketMultiplayerPeer` → `MultiplayerPeer` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WebSocketMultiplayerPeer.md`

**摘要**：Base class for WebSocket server and client.

## 描述

Base class for WebSocket server and client, allowing them to be used as multiplayer peer for the `MultiplayerAPI`.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 属性

- **`handshake_headers`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_handshake_headers · setter=set_handshake_headers
- **`handshake_timeout`** `float` = `3.0`
  - 其它属性：getter=get_handshake_timeout · setter=set_handshake_timeout
- **`inbound_buffer_size`** `int` = `65535`
  - 其它属性：getter=get_inbound_buffer_size · setter=set_inbound_buffer_size
- **`max_queued_packets`** `int` = `4096`
  - 其它属性：getter=get_max_queued_packets · setter=set_max_queued_packets
- **`outbound_buffer_size`** `int` = `65535`
  - 其它属性：getter=get_outbound_buffer_size · setter=set_outbound_buffer_size
- **`supported_protocols`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_supported_protocols · setter=set_supported_protocols

## 方法

### `create_client(url: String, tls_client_options: TLSOptions = null) -> int`

Starts a new multiplayer client connecting to the given `url`. TLS certificates will be verified against the hostname when connecting using the `wss://` protocol. You can pass the optional `tls_client_options` parameter to customize the trusted certification authorities, or disable the common name verification. See `TLSOptions.client` and `TLSOptions.client_unsafe`.
				**Note:** It is recommended to specify the scheme part of the URL, i.e. the `url` should start with either `ws://` or `wss://`.

### `create_server(port: int, bind_address: String = "*", tls_server_options: TLSOptions = null) -> int`

Starts a new multiplayer server listening on the given `port`. You can optionally specify a `bind_address`, and provide valid `tls_server_options` to use TLS. See `TLSOptions.server`.

### `get_peer(peer_id: int) -> WebSocketPeer`
- 限定：qualifiers=const

Returns the `WebSocketPeer` associated to the given `peer_id`.

### `get_peer_address(id: int) -> String`
- 限定：qualifiers=const

Returns the IP address of the given peer.

### `get_peer_port(id: int) -> int`
- 限定：qualifiers=const

Returns the remote port of the given peer.

