# ENetPacketPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ENetPacketPeer` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ENetPacketPeer.md`

**摘要**：A wrapper class for an ENetPeer (http://enet.bespin.org/group__peer.html).

## 描述

A PacketPeer implementation representing a peer of an `ENetConnection`.
		This class cannot be instantiated directly but can be retrieved during `ENetConnection.service` or via `ENetConnection.get_peers`.
		**Note:** When exporting to Android, make sure to enable the `INTERNET` permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.

## 方法

### `get_channels() -> int`
- 限定：qualifiers=const

Returns the number of channels allocated for communication with peer.

### `get_packet_flags() -> int`
- 限定：qualifiers=const

Returns the ENet flags of the next packet in the received queue. See `FLAG_*` constants for available packet flags. Note that not all flags are replicated from the sending peer to the receiving peer.

### `get_remote_address() -> String`
- 限定：qualifiers=const

Returns the IP address of this peer.

### `get_remote_port() -> int`
- 限定：qualifiers=const

Returns the remote port of this peer.

### `get_state() -> int`
- 限定：qualifiers=const

Returns the current peer state.

### `get_statistic(statistic: int) -> float`

Returns the requested `statistic` for this peer.

### `is_active() -> bool`
- 限定：qualifiers=const

Returns `true` if the peer is currently active (i.e. the associated `ENetConnection` is still valid).

### `peer_disconnect(data: int = 0) -> void`

Request a disconnection from a peer. An `ENetConnection.EVENT_DISCONNECT` will be generated during `ENetConnection.service` once the disconnection is complete.

### `peer_disconnect_later(data: int = 0) -> void`

Request a disconnection from a peer, but only after all queued outgoing packets are sent. An `ENetConnection.EVENT_DISCONNECT` will be generated during `ENetConnection.service` once the disconnection is complete.

### `peer_disconnect_now(data: int = 0) -> void`

Force an immediate disconnection from a peer. No `ENetConnection.EVENT_DISCONNECT` will be generated. The foreign peer is not guaranteed to receive the disconnect notification, and is reset immediately upon return from this function.

### `ping() -> void`

Sends a ping request to a peer. ENet automatically pings all connected peers at regular intervals, however, this function may be called to ensure more frequent ping requests.

### `ping_interval(ping_interval: int) -> void`

Sets the `ping_interval` in milliseconds at which pings will be sent to a peer. Pings are used both to monitor the liveness of the connection and also to dynamically adjust the throttle during periods of low traffic so that the throttle has reasonable responsiveness during traffic spikes. The default ping interval is `500` milliseconds.

### `reset() -> void`

Forcefully disconnects a peer. The foreign host represented by the peer is not notified of the disconnection and will timeout on its connection to the local host.

### `send(channel: int, packet: PackedByteArray, flags: int) -> int`

Queues a `packet` to be sent over the specified `channel`. See `FLAG_*` constants for available packet flags.

### `set_timeout(timeout: int, timeout_min: int, timeout_max: int) -> void`

Sets the timeout parameters for a peer. The timeout parameters control how and when a peer will timeout from a failure to acknowledge reliable traffic. Timeout values are expressed in milliseconds.
				The `timeout` is a factor that, multiplied by a value based on the average round trip time, will determine the timeout limit for a reliable packet. When that limit is reached, the timeout will be doubled, and the peer will be disconnected if that limit has reached `timeout_min`. The `timeout_max` parameter, on the other hand, defines a fixed timeout for which any packet must be acknowledged or the peer will be dropped.

### `throttle_configure(interval: int, acceleration: int, deceleration: int) -> void`

Configures throttle parameter for a peer.
				Unreliable packets are dropped by ENet in response to the varying conditions of the Internet connection to the peer. The throttle represents a probability that an unreliable packet should not be dropped and thus sent by ENet to the peer. By measuring fluctuations in round trip times of reliable packets over the specified `interval`, ENet will either increase the probability by the amount specified in the `acceleration` parameter, or decrease it by the amount specified in the `deceleration` parameter (both are ratios to `PACKET_THROTTLE_SCALE`).
				When the throttle has a value of `PACKET_THROTTLE_SCALE`, no unreliable packets are dropped by ENet, and so 100% of all unreliable packets will be sent.
				When the throttle has a value of `0`, all unreliable packets are dropped by ENet, and so 0% of all unreliable packets will be sent.
				Intermediate values for the throttle represent intermediate probabilities between 0% and 100% of unreliable packets being sent. The bandwidth limits of the local and foreign hosts are taken into account to determine a sensible limit for the throttle probability above which it should not raise even in the best of conditions.

## 枚举

### `PeerState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STATE_DISCONNECTED` |  |
| `1` | `STATE_CONNECTING` |  |
| `2` | `STATE_ACKNOWLEDGING_CONNECT` |  |
| `3` | `STATE_CONNECTION_PENDING` |  |
| `4` | `STATE_CONNECTION_SUCCEEDED` |  |
| `5` | `STATE_CONNECTED` |  |
| `6` | `STATE_DISCONNECT_LATER` |  |
| `7` | `STATE_DISCONNECTING` |  |
| `8` | `STATE_ACKNOWLEDGING_DISCONNECT` |  |
| `9` | `STATE_ZOMBIE` |  |

### `PeerStatistic`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PEER_PACKET_LOSS` |  |
| `1` | `PEER_PACKET_LOSS_VARIANCE` |  |
| `2` | `PEER_PACKET_LOSS_EPOCH` |  |
| `3` | `PEER_ROUND_TRIP_TIME` |  |
| `4` | `PEER_ROUND_TRIP_TIME_VARIANCE` |  |
| `5` | `PEER_LAST_ROUND_TRIP_TIME` |  |
| `6` | `PEER_LAST_ROUND_TRIP_TIME_VARIANCE` |  |
| `7` | `PEER_PACKET_THROTTLE` |  |
| `8` | `PEER_PACKET_THROTTLE_LIMIT` |  |
| `9` | `PEER_PACKET_THROTTLE_COUNTER` |  |
| `10` | `PEER_PACKET_THROTTLE_EPOCH` |  |
| `11` | `PEER_PACKET_THROTTLE_ACCELERATION` |  |
| `12` | `PEER_PACKET_THROTTLE_DECELERATION` |  |
| `13` | `PEER_PACKET_THROTTLE_INTERVAL` |  |

## 常量

- **`PACKET_LOSS_SCALE`** = `65536`
- **`PACKET_THROTTLE_SCALE`** = `32`
- **`FLAG_RELIABLE`** = `1`
- **`FLAG_UNSEQUENCED`** = `2`
- **`FLAG_UNRELIABLE_FRAGMENT`** = `8`
## 教程链接

- [API documentation on the ENet website](None)

