# TCPServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TCPServer` → `SocketServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TCPServer.md`

**摘要**：A TCP server.

## 描述

A TCP server. Listens to connections on a port and returns a `StreamPeerTCP` when it gets an incoming connection.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 方法

### `get_local_port() -> int`
- 限定：qualifiers=const

Returns the local port this server is listening to.

### `listen(port: int, bind_address: String = "*") -> int`

Listen on the `port` binding to `bind_address`.
				If `bind_address` is set as `"*"` (default), the server will listen on all available addresses (both IPv4 and IPv6).
				If `bind_address` is set as `"0.0.0.0"` (for IPv4) or `"::"` (for IPv6), the server will listen on all available addresses matching that IP type.
				If `bind_address` is set to any valid address (e.g. `"192.168.1.101"`, `"::1"`, etc.), the server will only listen on the interface with that address (or fail if no interface with the given address exists).

### `take_connection() -> StreamPeerTCP`

If a connection is available, returns a StreamPeerTCP with the connection.

