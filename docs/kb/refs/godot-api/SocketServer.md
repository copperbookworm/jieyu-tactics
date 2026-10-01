# SocketServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SocketServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SocketServer.md`

**摘要**：An abstract class for servers based on sockets.

## 描述

A socket server.

## 方法

### `is_connection_available() -> bool`
- 限定：qualifiers=const

Returns `true` if a connection is available for taking.

### `is_listening() -> bool`
- 限定：qualifiers=const

Returns `true` if the server is currently listening for connections.

### `stop() -> void`

Stops listening.

### `take_socket_connection() -> StreamPeerSocket`

If a connection is available, returns a StreamPeerSocket with the connection.

