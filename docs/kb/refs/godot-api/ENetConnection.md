# ENetConnection

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ENetConnection` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ENetConnection.md`

**摘要**：A wrapper class for an ENetHost (http://enet.bespin.org/group__host.html).

## 描述

ENet's purpose is to provide a relatively thin, simple and robust network communication layer on top of UDP (User Datagram Protocol).

## 方法

### `bandwidth_limit(in_bandwidth: int = 0, out_bandwidth: int = 0) -> void`

Adjusts the bandwidth limits of a host.

### `broadcast(channel: int, packet: PackedByteArray, flags: int) -> void`

Queues a `packet` to be sent to all peers associated with the host over the specified `channel`. See `ENetPacketPeer` `FLAG_*` constants for available packet flags.

### `channel_limit(limit: int) -> void`

Limits the maximum allowed channels of future incoming connections.

### `compress(mode: int) -> void`

Sets the compression method used for network packets. These have different tradeoffs of compression speed versus bandwidth, you may need to test which one works best for your use case if you use compression at all.
				**Note:** Most games' network design involve sending many small packets frequently (smaller than 4 KB each). If in doubt, it is recommended to keep the default compression algorithm as it works best on these small packets.
				**Note:** The compression mode must be set to the same value on both the server and all its clients. Clients will fail to connect if the compression mode set on the client differs from the one set on the server.

### `connect_to_host(address: String, port: int, channels: int = 0, data: int = 0) -> ENetPacketPeer`

Initiates a connection to a foreign `address` using the specified `port` and allocating the requested `channels`. Optional `data` can be passed during connection in the form of a 32 bit integer.
				**Note:** You must call either `create_host` or `create_host_bound` on both ends before calling this method.

### `create_host(max_peers: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) -> int`

Creates an ENetHost that allows up to `max_peers` connected peers, each allocating up to `max_channels` channels, optionally limiting bandwidth to `in_bandwidth` and `out_bandwidth` (if greater than zero).
				This method binds a random available dynamic UDP port on the host machine at the *unspecified* address. Use `create_host_bound` to specify the address and port.
				**Note:** It is necessary to create a host in both client and server in order to establish a connection.

### `create_host_bound(bind_address: String, bind_port: int, max_peers: int = 32, max_channels: int = 0, in_bandwidth: int = 0, out_bandwidth: int = 0) -> int`

Creates an ENetHost bound to the given `bind_address` and `bind_port` that allows up to `max_peers` connected peers, each allocating up to `max_channels` channels, optionally limiting bandwidth to `in_bandwidth` and `out_bandwidth` (if greater than zero).
				**Note:** It is necessary to create a host in both client and server in order to establish a connection.

### `destroy() -> void`

Destroys the host and all resources associated with it.

### `dtls_client_setup(hostname: String, client_options: TLSOptions = null) -> int`

Configure this ENetHost to use the custom Godot extension allowing DTLS encryption for ENet clients. Call this before `connect_to_host` to have ENet connect using DTLS validating the server certificate against `hostname`. You can pass the optional `client_options` parameter to customize the trusted certification authorities, or disable the common name verification. See `TLSOptions.client` and `TLSOptions.client_unsafe`.

### `dtls_server_setup(server_options: TLSOptions) -> int`

Configure this ENetHost to use the custom Godot extension allowing DTLS encryption for ENet servers. Call this right after `create_host_bound` to have ENet expect peers to connect using DTLS. See `TLSOptions.server`.

### `flush() -> void`

Sends any queued packets on the host specified to its designated peers.

### `get_local_port() -> int`
- 限定：qualifiers=const

Returns the local port to which this peer is bound.

### `get_max_channels() -> int`
- 限定：qualifiers=const

Returns the maximum number of channels allowed for connected peers.

### `get_peers() -> ENetPacketPeer[]`

Returns the list of peers associated with this host.
				**Note:** This list might include some peers that are not fully connected or are still being disconnected.

### `pop_statistic(statistic: int) -> float`

Returns and resets host statistics.

### `refuse_new_connections(refuse: bool) -> void`

Configures the DTLS server to automatically drop new connections.
				**Note:** This method is only relevant after calling `dtls_server_setup`.

### `service(timeout: int = 0) -> Array`

Waits for events on this connection and shuttles packets between the host and its peers, with the given `timeout` (in milliseconds). The returned `Array` will have 4 elements. An `EventType`, the `ENetPacketPeer` which generated the event, the event associated data (if any), the event associated channel (if any). If the generated event is `EVENT_RECEIVE`, the received packet will be queued to the associated `ENetPacketPeer`.
				Call this function regularly to handle connections, disconnections, and to receive new packets.
				**Note:** This method must be called on both ends involved in the event (sending and receiving hosts).

### `socket_send(destination_address: String, destination_port: int, packet: PackedByteArray) -> void`

Sends a `packet` toward a destination from the address and port currently bound by this ENetConnection instance.
				This is useful as it serves to establish entries in NAT routing tables on all devices between this bound instance and the public facing internet, allowing a prospective client's connection packets to be routed backward through the NAT device(s) between the public internet and this host.
				This requires forward knowledge of a prospective client's address and communication port as seen by the public internet - after any NAT devices have handled their connection request. This information can be obtained by a STUN (https://en.wikipedia.org/wiki/STUN) service, and must be handed off to your host by an entity that is not the prospective client. This will never work for a client behind a Symmetric NAT due to the nature of the Symmetric NAT routing algorithm, as their IP and Port cannot be known beforehand.

## 枚举

### `CompressionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPRESS_NONE` |  |
| `1` | `COMPRESS_RANGE_CODER` |  |
| `2` | `COMPRESS_FASTLZ` |  |
| `3` | `COMPRESS_ZLIB` |  |
| `4` | `COMPRESS_ZSTD` |  |

### `EventType`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `EVENT_ERROR` |  |
| `0` | `EVENT_NONE` |  |
| `1` | `EVENT_CONNECT` |  |
| `2` | `EVENT_DISCONNECT` |  |
| `3` | `EVENT_RECEIVE` |  |

### `HostStatistic`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HOST_TOTAL_SENT_DATA` |  |
| `1` | `HOST_TOTAL_SENT_PACKETS` |  |
| `2` | `HOST_TOTAL_RECEIVED_DATA` |  |
| `3` | `HOST_TOTAL_RECEIVED_PACKETS` |  |

## 教程链接

- [API documentation on the ENet website](None)

