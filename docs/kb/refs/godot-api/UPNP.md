# UPNP

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`UPNP` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/UPNP.md`

**摘要**：Universal Plug and Play (UPnP) functions for network device discovery, querying and port forwarding.

## 描述

This class can be used to discover compatible `UPNPDevice`s on the local network and execute commands on them, like managing port mappings (for port forwarding/NAT traversal) and querying the local and remote network IP address. Note that methods on this class are synchronous and block the calling thread.
		To forward a specific port (here `7777`, note both `discover` and `add_port_mapping` can return errors that should be checked):
		
```gdscript
		var upnp = UPNP.new()
		upnp.discover()
		upnp.add_port_mapping(7777)
		
```

		To close a specific port (e.g. after you have finished using it):
		
```gdscript
		upnp.delete_port_mapping(port)
		
```

		**Note:** UPnP discovery blocks the current thread. To perform discovery without blocking the main thread, use `Thread`s like this:
		
```gdscript
		# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
		signal upnp_completed(error)

		# Replace this with your own server port number between 1024 and 65535.
		const SERVER_PORT = 3928
		var thread = null

		func _upnp_setup(server_port):
			# UPNP queries take some time.
			var upnp = UPNP.new()
			var err = upnp.discover()

			if err != UPNP.UPNP_RESULT_SUCCESS:
				push_error(str(err))
				upnp_completed.emit(err)
				return

			if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
				upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
				upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
				upnp_completed.emit(UPNP.UPNP_RESULT_SUCCESS)

		func _ready():
			thread = Thread.new()
			thread.start(_upnp_setup.bind(SERVER_PORT))

		func _exit_tree():
			# Wait for thread finish here to handle game exit while the thread is running.
			thread.wait_to_finish()
		
```

		**Terminology:** In the context of UPnP networking, "gateway" (or "internet gateway device", short IGD) refers to network devices that allow computers in the local network to access the internet ("wide area network", WAN). These gateways are often also called "routers".
		**Pitfalls:**
		- As explained above, these calls are blocking and shouldn't be run on the main thread, especially as they can block for multiple seconds at a time. Use threading!
		- Networking is physical and messy. Packets get lost in transit or get filtered, addresses, free ports and assigned mappings change, and devices may leave or join the network at any time. Be mindful of this, be diligent when checking and handling errors, and handle these gracefully if you can: add clear error UI, timeouts and re-try handling.
		- Port mappings may change (and be removed) at any time, and the remote/external IP address of the gateway can change likewise. You should consider re-querying the external IP and try to update/refresh the port mapping periodically (for example, every 5 minutes and on networking failures).
		- Not all devices support UPnP, and some users disable UPnP support. You need to handle this (e.g. documenting and requiring the user to manually forward ports, or adding alternative methods of NAT traversal, like a relay/mirror server, or NAT hole punching, STUN/TURN, etc.).
		- Consider what happens on mapping conflicts. Maybe multiple users on the same network would like to play your game at the same time, or maybe another application uses the same port. Make the port configurable, and optimally choose a port automatically (re-trying with a different port on failure).
		**Further reading:** If you want to know more about UPnP (and the Internet Gateway Device (IGD) and Port Control Protocol (PCP) specifically), Wikipedia (https://en.wikipedia.org/wiki/Universal_Plug_and_Play) is a good first stop, the specification can be found at the Open Connectivity Foundation (https://openconnectivity.org/developer/specifications/upnp-resources/upnp/) and Godot's implementation is based on the MiniUPnP client (https://github.com/miniupnp/miniupnp).

## 属性

- **`discover_ipv6`** `bool` = `false`
  - 其它属性：getter=is_discover_ipv6 · setter=set_discover_ipv6
- **`discover_local_port`** `int` = `0`
  - 其它属性：getter=get_discover_local_port · setter=set_discover_local_port
- **`discover_multicast_if`** `String` = `""`
  - 其它属性：getter=get_discover_multicast_if · setter=set_discover_multicast_if

## 方法

### `add_device(device: UPNPDevice) -> void`

Adds the given `UPNPDevice` to the list of discovered devices.

### `add_port_mapping(port: int, port_internal: int = 0, desc: String = "", proto: String = "UDP", duration: int = 0) -> int`
- 限定：qualifiers=const

Adds a mapping to forward the external `port` (between 1 and 65535, although recommended to use port 1024 or above) on the default gateway (see `get_gateway`) to the `port_internal` on the local machine for the given protocol `proto` (either `"TCP"` or `"UDP"`, with UDP being the default). If a port mapping for the given port and protocol combination already exists on that gateway device, this method tries to overwrite it. If that is not desired, you can retrieve the gateway manually with `get_gateway` and call `add_port_mapping` on it, if any. Note that forwarding a well-known port (below 1024) with UPnP may fail depending on the device.
				Depending on the gateway device, if a mapping for that port already exists, it will either be updated or it will refuse this command due to that conflict, especially if the existing mapping for that port wasn't created via UPnP or points to a different network address (or device) than this one.
				If `port_internal` is `0` (the default), the same port number is used for both the external and the internal port (the `port` value).
				The description (`desc`) is shown in some routers management UIs and can be used to point out which application added the mapping.
				The mapping's lease `duration` can be limited by specifying a duration in seconds. The default of `0` means no duration, i.e. a permanent lease and notably some devices only support these permanent leases. Note that whether permanent or not, this is only a request and the gateway may still decide at any point to remove the mapping (which usually happens on a reboot of the gateway, when its external IP address changes, or on some models when it detects a port mapping has become inactive, i.e. had no traffic for multiple minutes). If not `0` (permanent), the allowed range according to spec is between `120` (2 minutes) and `86400` seconds (24 hours).
				See `UPNPResult` for possible return values.

### `clear_devices() -> void`

Clears the list of discovered devices.

### `delete_port_mapping(port: int, proto: String = "UDP") -> int`
- 限定：qualifiers=const

Deletes the port mapping for the given port and protocol combination on the default gateway (see `get_gateway`) if one exists. `port` must be a valid port between 1 and 65535, `proto` can be either `"TCP"` or `"UDP"`. May be refused for mappings pointing to addresses other than this one, for well-known ports (below 1024), or for mappings not added via UPnP. See `UPNPResult` for possible return values.

### `discover(timeout: int = 2000, ttl: int = 2, device_filter: String = "InternetGatewayDevice") -> int`

Discovers local `UPNPDevice`s. Clears the list of previously discovered devices.
				Filters for IGD (InternetGatewayDevice) type devices by default, as those manage port forwarding. `timeout` is the time to wait for responses in milliseconds. `ttl` is the time-to-live; only touch this if you know what you're doing.
				See `UPNPResult` for possible return values.

### `get_device(index: int) -> UPNPDevice`
- 限定：qualifiers=const

Returns the `UPNPDevice` at the given `index`.

### `get_device_count() -> int`
- 限定：qualifiers=const

Returns the number of discovered `UPNPDevice`s.

### `get_gateway() -> UPNPDevice`
- 限定：qualifiers=const

Returns the default gateway. That is the first discovered `UPNPDevice` that is also a valid IGD (InternetGatewayDevice).

### `query_external_address() -> String`
- 限定：qualifiers=const

Returns the external `IP` address of the default gateway (see `get_gateway`) as string. Returns an empty string on error.

### `remove_device(index: int) -> void`

Removes the device at `index` from the list of discovered devices.

### `set_device(index: int, device: UPNPDevice) -> void`

Sets the device at `index` from the list of discovered devices to `device`.

## 枚举

### `UPNPResult`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UPNP_RESULT_SUCCESS` |  |
| `1` | `UPNP_RESULT_NOT_AUTHORIZED` |  |
| `2` | `UPNP_RESULT_PORT_MAPPING_NOT_FOUND` |  |
| `3` | `UPNP_RESULT_INCONSISTENT_PARAMETERS` |  |
| `4` | `UPNP_RESULT_NO_SUCH_ENTRY_IN_ARRAY` |  |
| `5` | `UPNP_RESULT_ACTION_FAILED` |  |
| `6` | `UPNP_RESULT_SRC_IP_WILDCARD_NOT_PERMITTED` |  |
| `7` | `UPNP_RESULT_EXT_PORT_WILDCARD_NOT_PERMITTED` |  |
| `8` | `UPNP_RESULT_INT_PORT_WILDCARD_NOT_PERMITTED` |  |
| `9` | `UPNP_RESULT_REMOTE_HOST_MUST_BE_WILDCARD` |  |
| `10` | `UPNP_RESULT_EXT_PORT_MUST_BE_WILDCARD` |  |
| `11` | `UPNP_RESULT_NO_PORT_MAPS_AVAILABLE` |  |
| `12` | `UPNP_RESULT_CONFLICT_WITH_OTHER_MECHANISM` |  |
| `13` | `UPNP_RESULT_CONFLICT_WITH_OTHER_MAPPING` |  |
| `14` | `UPNP_RESULT_SAME_PORT_VALUES_REQUIRED` |  |
| `15` | `UPNP_RESULT_ONLY_PERMANENT_LEASE_SUPPORTED` |  |
| `16` | `UPNP_RESULT_INVALID_GATEWAY` |  |
| `17` | `UPNP_RESULT_INVALID_PORT` |  |
| `18` | `UPNP_RESULT_INVALID_PROTOCOL` |  |
| `19` | `UPNP_RESULT_INVALID_DURATION` |  |
| `20` | `UPNP_RESULT_INVALID_ARGS` |  |
| `21` | `UPNP_RESULT_INVALID_RESPONSE` |  |
| `22` | `UPNP_RESULT_INVALID_PARAM` |  |
| `23` | `UPNP_RESULT_HTTP_ERROR` |  |
| `24` | `UPNP_RESULT_SOCKET_ERROR` |  |
| `25` | `UPNP_RESULT_MEM_ALLOC_ERROR` |  |
| `26` | `UPNP_RESULT_NO_GATEWAY` |  |
| `27` | `UPNP_RESULT_NO_DEVICES` |  |
| `28` | `UPNP_RESULT_UNKNOWN_ERROR` |  |

