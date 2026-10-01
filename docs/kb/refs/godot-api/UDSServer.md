# UDSServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`UDSServer` → `SocketServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/UDSServer.md`

**摘要**：A Unix Domain Socket (UDS) server.

## 描述

A Unix Domain Socket (UDS) server. Listens to connections on a socket path and returns a `StreamPeerUDS` when it gets an incoming connection. Unix Domain Sockets provide inter-process communication on the same machine using the filesystem namespace.
		**Note:** Unix Domain Sockets are only available on Unix-like systems (Linux, macOS, etc.) and are not supported on Windows.

## 方法

### `listen(path: String) -> int`

Listens on the socket at `path`. The socket file will be created at the specified path.
				**Note:** The socket file must not already exist at the specified path. You may need to remove any existing socket file before calling this method.

### `take_connection() -> StreamPeerUDS`

If a connection is available, returns a StreamPeerUDS with the connection.

