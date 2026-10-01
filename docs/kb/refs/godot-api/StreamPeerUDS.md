# StreamPeerUDS

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StreamPeerUDS` → `StreamPeerSocket` → `StreamPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StreamPeerUDS.md`

**摘要**：A stream peer that handles UNIX Domain Socket (UDS) connections.

## 描述

A stream peer that handles UNIX Domain Socket (UDS) connections. This object can be used to connect to UDS servers, or also is returned by a UDS server. Unix Domain Sockets provide inter-process communication on the same machine using the filesystem namespace.
		**Note:** UNIX Domain Sockets are only available on UNIX-like systems (Linux, macOS, etc.) and are not supported on Windows.

## 方法

### `bind(path: String) -> int`

Opens the UDS socket, and binds it to the specified socket path.
				This method is generally not needed, and only used to force the subsequent call to `connect_to_host` to use the specified `path` as the source address.

### `connect_to_host(path: String) -> int`

Connects to the specified UNIX Domain Socket path. Returns `OK` on success.

### `get_connected_path() -> String`
- 限定：qualifiers=const

Returns the socket path of this peer.

