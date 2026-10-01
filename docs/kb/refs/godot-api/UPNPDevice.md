# UPNPDevice

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`UPNPDevice` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/UPNPDevice.md`

**摘要**：Universal Plug and Play (UPnP) device.

## 描述

Universal Plug and Play (UPnP) device. See `UPNP` for UPnP discovery and utility functions. Provides low-level access to UPNP control commands. Allows to manage port mappings (port forwarding) and to query network information of the device (like local and external IP address and status). Note that methods on this class are synchronous and block the calling thread.

## 属性

- **`description_url`** `String` = `""`
  - 其它属性：getter=get_description_url · setter=set_description_url
- **`igd_control_url`** `String` = `""`
  - 其它属性：getter=get_igd_control_url · setter=set_igd_control_url
- **`igd_our_addr`** `String` = `""`
  - 其它属性：getter=get_igd_our_addr · setter=set_igd_our_addr
- **`igd_service_type`** `String` = `""`
  - 其它属性：getter=get_igd_service_type · setter=set_igd_service_type
- **`igd_status`** `int` = `9` · 枚举 `UPNPDevice.IGDStatus`
  - 其它属性：getter=get_igd_status · setter=set_igd_status
- **`service_type`** `String` = `""`
  - 其它属性：getter=get_service_type · setter=set_service_type

## 方法

### `add_port_mapping(port: int, port_internal: int = 0, desc: String = "", proto: String = "UDP", duration: int = 0) -> int`
- 限定：qualifiers=const

Adds a port mapping to forward the given external port on this `UPNPDevice` for the given protocol to the local machine. See `UPNP.add_port_mapping`.

### `delete_port_mapping(port: int, proto: String = "UDP") -> int`
- 限定：qualifiers=const

Deletes the port mapping identified by the given port and protocol combination on this device. See `UPNP.delete_port_mapping`.

### `is_valid_gateway() -> bool`
- 限定：qualifiers=const

Returns `true` if this is a valid IGD (InternetGatewayDevice) which potentially supports port forwarding.

### `query_external_address() -> String`
- 限定：qualifiers=const

Returns the external IP address of this `UPNPDevice` or an empty string.

## 枚举

### `IGDStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `IGD_STATUS_OK` |  |
| `1` | `IGD_STATUS_HTTP_ERROR` |  |
| `2` | `IGD_STATUS_HTTP_EMPTY` |  |
| `3` | `IGD_STATUS_NO_URLS` |  |
| `4` | `IGD_STATUS_NO_IGD` |  |
| `5` | `IGD_STATUS_DISCONNECTED` |  |
| `6` | `IGD_STATUS_UNKNOWN_DEVICE` |  |
| `7` | `IGD_STATUS_INVALID_CONTROL` |  |
| `8` | `IGD_STATUS_MALLOC_ERROR` |  |
| `9` | `IGD_STATUS_UNKNOWN_ERROR` |  |

