# WebSocketPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WebSocketPeer` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WebSocketPeer.md`

**摘要**：A WebSocket connection.

## 描述

This class represents WebSocket connection, and can be used as a WebSocket client (RFC 6455 (https://datatracker.ietf.org/doc/html/rfc6455)-compliant) or as a remote peer of a WebSocket server.
		You can send WebSocket binary frames using `PacketPeer.put_packet`, and WebSocket text frames using `send` (prefer text frames when interacting with text-based API). You can check the frame type of the last packet via `was_string_packet`.
		To start a WebSocket client, first call `connect_to_url`, then regularly call `poll` (e.g. during `Node` process). You can query the socket state via `get_ready_state`, get the number of pending packets using `PacketPeer.get_available_packet_count`, and retrieve them via `PacketPeer.get_packet`.
		`codeblocks`
		`gdscript`
		extends Node

		var socket = WebSocketPeer.new()

		func _ready():
			socket.connect_to_url("wss://example.com")

		func _process(delta):
			socket.poll()
			var state = socket.get_ready_state()
			if state == WebSocketPeer.STATE_OPEN:
				while socket.get_available_packet_count():
					print("Packet: ", socket.get_packet())
			elif state == WebSocketPeer.STATE_CLOSING:
				# Keep polling to achieve proper close.
				pass
			elif state == WebSocketPeer.STATE_CLOSED:
				var code = socket.get_close_code()
				var reason = socket.get_close_reason()
				print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
				set_process(false) # Stop processing.
		
		
		To use the peer as part of a WebSocket server refer to `accept_stream` and the online tutorial.

## 属性

- **`handshake_headers`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_handshake_headers · setter=set_handshake_headers
- **`heartbeat_interval`** `float` = `0.0`
  - 其它属性：getter=get_heartbeat_interval · setter=set_heartbeat_interval
- **`inbound_buffer_size`** `int` = `65535`
  - 其它属性：getter=get_inbound_buffer_size · setter=set_inbound_buffer_size
- **`max_queued_packets`** `int` = `4096`
  - 其它属性：getter=get_max_queued_packets · setter=set_max_queued_packets
- **`outbound_buffer_size`** `int` = `65535`
  - 其它属性：getter=get_outbound_buffer_size · setter=set_outbound_buffer_size
- **`supported_protocols`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_supported_protocols · setter=set_supported_protocols

## 方法

### `accept_stream(stream: StreamPeer) -> int`

Accepts a peer connection performing the HTTP handshake as a WebSocket server. The `stream` must be a valid TCP stream retrieved via `TCPServer.take_connection`, or a TLS stream accepted via `StreamPeerTLS.accept_stream`.
				**Note:** Not supported in Web exports due to browsers' restrictions.

### `close(code: int = 1000, reason: String = "") -> void`

Closes this WebSocket connection.
				`code` is the status code for the closure (see RFC 6455 section 7.4 (https://datatracker.ietf.org/doc/html/rfc6455#section-7.4.1) for a list of valid status codes). If `code` is negative, the connection will be closed immediately without notifying the remote peer.
				`reason` is the human-readable reason for closing the connection. It can be any UTF-8 string that's smaller than 123 bytes.
				**Note:** To achieve a clean closure, you will need to keep polling until `STATE_CLOSED` is reached.
				**Note:** The Web export might not support all status codes. Please refer to browser-specific documentation for more details.

### `connect_to_url(url: String, tls_client_options: TLSOptions = null) -> int`

Connects to the given URL. TLS certificates will be verified against the hostname when connecting using the `wss://` protocol. You can pass the optional `tls_client_options` parameter to customize the trusted certification authorities, or disable the common name verification. See `TLSOptions.client` and `TLSOptions.client_unsafe`.
				**Note:** This method is non-blocking, and will return `OK` before the connection is established as long as the provided parameters are valid and the peer is not in an invalid state (e.g. already connected). Regularly call `poll` (e.g. during `Node` process) and check the result of `get_ready_state` to know whether the connection succeeds or fails.
				**Note:** To avoid mixed content warnings or errors in Web, you may have to use a `url` that starts with `wss://` (secure) instead of `ws://`. When doing so, make sure to use the fully qualified domain name that matches the one defined in the server's TLS certificate. Do not connect directly via the IP address for `wss://` connections, as it won't match with the TLS certificate.

### `get_close_code() -> int`
- 限定：qualifiers=const

Returns the received WebSocket close frame status code, or `-1` when the connection was not cleanly closed. Only call this method when `get_ready_state` returns `STATE_CLOSED`.

### `get_close_reason() -> String`
- 限定：qualifiers=const

Returns the received WebSocket close frame status reason string. Only call this method when `get_ready_state` returns `STATE_CLOSED`.

### `get_connected_host() -> String`
- 限定：qualifiers=const

Returns the IP address of the connected peer.
				**Note:** Not available in the Web export.

### `get_connected_port() -> int`
- 限定：qualifiers=const

Returns the remote port of the connected peer.
				**Note:** Not available in the Web export.

### `get_current_outbound_buffered_amount() -> int`
- 限定：qualifiers=const

Returns the current amount of data in the outbound websocket buffer. **Note:** Web exports use WebSocket.bufferedAmount, while other platforms use an internal buffer.

### `get_ready_state() -> int`
- 限定：qualifiers=const

Returns the ready state of the connection.

### `get_requested_url() -> String`
- 限定：qualifiers=const

Returns the URL requested by this peer. The URL is derived from the `url` passed to `connect_to_url` or from the HTTP headers when acting as server (i.e. when using `accept_stream`).

### `get_selected_protocol() -> String`
- 限定：qualifiers=const

Returns the selected WebSocket sub-protocol for this connection or an empty string if the sub-protocol has not been selected yet.

### `poll() -> void`

Updates the connection state and receive incoming packets. Call this function regularly to keep it in a clean state.

### `send(message: PackedByteArray, write_mode: int = 1) -> int`

Sends the given `message` using the desired `write_mode`. When sending a `String`, prefer using `send_text`.

### `send_text(message: String) -> int`

Sends the given `message` using WebSocket text mode. Prefer this method over `PacketPeer.put_packet` when interacting with third-party text-based API (e.g. when using `JSON` formatted messages).

### `set_no_delay(enabled: bool) -> void`

Disable Nagle's algorithm on the underlying TCP socket (default). See `StreamPeerTCP.set_no_delay` for more information.
				**Note:** Not available in the Web export.

### `was_string_packet() -> bool`
- 限定：qualifiers=const

Returns `true` if the last received packet was sent as a text payload. See `WriteMode`.

## 枚举

### `WriteMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `WRITE_MODE_TEXT` |  |
| `1` | `WRITE_MODE_BINARY` |  |

### `State`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATE_CONNECTING` |  |
| `1` | `STATE_OPEN` |  |
| `2` | `STATE_CLOSING` |  |
| `3` | `STATE_CLOSED` |  |

