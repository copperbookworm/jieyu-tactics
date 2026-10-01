# StreamPeerTLS

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StreamPeerTLS` → `StreamPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StreamPeerTLS.md`

**摘要**：A stream peer that handles TLS connections.

## 描述

A stream peer that handles TLS connections. This object can be used to connect to a TLS server or accept a single TLS client connection.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 方法

### `accept_stream(stream: StreamPeer, server_options: TLSOptions) -> int`

Accepts a peer connection as a server using the given `server_options`. See `TLSOptions.server`.

### `connect_to_stream(stream: StreamPeer, common_name: String, client_options: TLSOptions = null) -> int`

Connects to a peer using an underlying `StreamPeer` `stream` and verifying the remote certificate is correctly signed for the given `common_name`. You can pass the optional `client_options` parameter to customize the trusted certification authorities, or disable the common name verification. See `TLSOptions.client` and `TLSOptions.client_unsafe`.

### `disconnect_from_stream() -> void`

Disconnects from host.

### `get_status() -> int`
- 限定：qualifiers=const

Returns the status of the connection.

### `get_stream() -> StreamPeer`
- 限定：qualifiers=const

Returns the underlying `StreamPeer` connection, used in `accept_stream` or `connect_to_stream`.

### `poll() -> void`

Poll the connection to check for incoming bytes. Call this right before `StreamPeer.get_available_bytes` for it to work properly.

## 枚举

### `Status`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATUS_DISCONNECTED` |  |
| `1` | `STATUS_HANDSHAKING` |  |
| `2` | `STATUS_CONNECTED` |  |
| `3` | `STATUS_ERROR` |  |
| `4` | `STATUS_ERROR_HOSTNAME_MISMATCH` |  |

## 教程链接

- [TLS certificates](None)

