# IP

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`IP` → `Object`
> 附加属性：api_type=core · keywords=dns
> 自动生成，勿手改。文件：`refs/godot-api/IP.md`

**摘要**：Internet protocol (IP) support functions such as DNS resolution.

## 描述

IP contains support functions for the Internet Protocol (IP). TCP/IP support is in different classes (see `StreamPeerTCP` and `TCPServer`). IP provides DNS hostname resolution support, both blocking and threaded.

## 方法

### `clear_cache(hostname: String = "") -> void`

Removes all of a `hostname`'s cached references. If no `hostname` is given, all cached IP addresses are removed.

### `erase_resolve_item(id: int) -> void`

Removes a given item `id` from the queue. This should be used to free a queue after it has completed to enable more queries to happen.

### `get_local_addresses() -> PackedStringArray`
- 限定：qualifiers=const

Returns all the user's current IPv4 and IPv6 addresses as an array.

### `get_local_interfaces() -> Dictionary[]`
- 限定：qualifiers=const

Returns all network adapters as an array.
				Each adapter is a dictionary of the form:
				
```gdscript
				{
					"index": "1", # Interface index.
					"name": "eth0", # Interface name.
					"friendly": "Ethernet One", # A friendly name (might be empty).
					"addresses": ["192.168.1.101"], # An array of IP addresses associated to this interface.
				}
				
```

### `get_resolve_item_address(id: int) -> String`
- 限定：qualifiers=const

Returns a queued hostname's IP address, given its queue `id`. Returns an empty string on error or if resolution hasn't happened yet (see `get_resolve_item_status`).

### `get_resolve_item_addresses(id: int) -> Array`
- 限定：qualifiers=const

Returns resolved addresses, or an empty array if an error happened or resolution didn't happen yet (see `get_resolve_item_status`).

### `get_resolve_item_status(id: int) -> int`
- 限定：qualifiers=const

Returns a queued hostname's status as a `ResolverStatus` constant, given its queue `id`.

### `resolve_hostname(host: String, ip_type: int = 3) -> String`
- 限定：keywords=dns

Returns a given hostname's IPv4 or IPv6 address when resolved (blocking-type method). The address type returned depends on the `Type` constant given as `ip_type`.

### `resolve_hostname_addresses(host: String, ip_type: int = 3) -> PackedStringArray`

Resolves a given hostname in a blocking way. Addresses are returned as an `Array` of IPv4 or IPv6 addresses depending on `ip_type`.

### `resolve_hostname_queue_item(host: String, ip_type: int = 3) -> int`

Creates a queue item to resolve a hostname to an IPv4 or IPv6 address depending on the `Type` constant given as `ip_type`. Returns the queue ID if successful, or `RESOLVER_INVALID_ID` on error.

## 枚举

### `ResolverStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESOLVER_STATUS_NONE` |  |
| `1` | `RESOLVER_STATUS_WAITING` |  |
| `2` | `RESOLVER_STATUS_DONE` |  |
| `3` | `RESOLVER_STATUS_ERROR` |  |

### `Type`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_NONE` |  |
| `1` | `TYPE_IPV4` |  |
| `2` | `TYPE_IPV6` |  |
| `3` | `TYPE_ANY` |  |

## 常量

- **`RESOLVER_MAX_QUERIES`** = `256`
- **`RESOLVER_INVALID_ID`** = `-1`
