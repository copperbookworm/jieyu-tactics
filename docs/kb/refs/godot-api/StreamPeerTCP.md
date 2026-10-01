# StreamPeerTCP

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StreamPeerTCP` → `StreamPeerSocket` → `StreamPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StreamPeerTCP.md`

**摘要**：A stream peer that handles TCP connections.

## 描述

A stream peer that handles TCP connections. This object can be used to connect to TCP servers, or also is returned by a TCP server.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 方法

### `bind(port: int, host: String = "*") -> int`

Opens the TCP socket, and binds it to the specified local address.
				This method is generally not needed, and only used to force the subsequent call to `connect_to_host` to use the specified `host` and `port` as source address. This can be desired in some NAT punchthrough techniques, or when forcing the source network interface.

### `connect_to_host(host: String, port: int) -> int`

Connects to the specified `host:port` pair. A hostname will be resolved if valid. Returns `OK` on success.

### `get_connected_host() -> String`
- 限定：qualifiers=const

Returns the IP of this peer.

### `get_connected_port() -> int`
- 限定：qualifiers=const

Returns the port of this peer.

### `get_local_port() -> int`
- 限定：qualifiers=const

Returns the local port to which this peer is bound.

### `set_no_delay(enabled: bool) -> void`

If `enabled` is `true`, packets will be sent immediately. If `enabled` is `false` (the default), packet transfers will be delayed and combined using Nagle's algorithm (https://en.wikipedia.org/wiki/Nagle%27s_algorithm).
				**Note:** It's recommended to leave this disabled for applications that send large packets or need to transfer a lot of data, as enabling this can decrease the total available bandwidth.

