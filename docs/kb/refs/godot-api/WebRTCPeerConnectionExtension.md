# WebRTCPeerConnectionExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WebRTCPeerConnectionExtension` → `WebRTCPeerConnection` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WebRTCPeerConnectionExtension.md`

## 方法

### `_add_ice_candidate(sdp_mid_name: String, sdp_mline_index: int, sdp_name: String) -> int`
- 限定：qualifiers=virtual required

### `_close() -> void`
- 限定：qualifiers=virtual required

### `_create_data_channel(label: String, config: Dictionary) -> WebRTCDataChannel`
- 限定：qualifiers=virtual required

### `_create_offer() -> int`
- 限定：qualifiers=virtual required

### `_get_connection_state() -> int`
- 限定：qualifiers=virtual required const

### `_get_gathering_state() -> int`
- 限定：qualifiers=virtual required const

### `_get_signaling_state() -> int`
- 限定：qualifiers=virtual required const

### `_initialize(config: Dictionary) -> int`
- 限定：qualifiers=virtual required

### `_poll() -> int`
- 限定：qualifiers=virtual required

### `_set_local_description(type: String, sdp: String) -> int`
- 限定：qualifiers=virtual required

### `_set_remote_description(type: String, sdp: String) -> int`
- 限定：qualifiers=virtual required

