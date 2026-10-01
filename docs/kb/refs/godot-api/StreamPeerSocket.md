# StreamPeerSocket

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StreamPeerSocket` → `StreamPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StreamPeerSocket.md`

**摘要**：Abstract base class for interacting with socket streams.

## 描述

StreamPeerSocket is an abstract base class that defines common behavior for socket-based streams.

## 方法

### `disconnect_from_host() -> void`

Disconnects from host.

### `get_status() -> int`
- 限定：qualifiers=const

Returns the status of the connection.

### `poll() -> int`

Polls the socket, updating its state. See `get_status`.

## 枚举

### `Status`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATUS_NONE` |  |
| `1` | `STATUS_CONNECTING` |  |
| `2` | `STATUS_CONNECTED` |  |
| `3` | `STATUS_ERROR` |  |

