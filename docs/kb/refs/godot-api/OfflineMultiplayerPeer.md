# OfflineMultiplayerPeer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OfflineMultiplayerPeer` → `MultiplayerPeer` → `PacketPeer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OfflineMultiplayerPeer.md`

**摘要**：A `MultiplayerPeer` which is always connected and acts as a server.

## 描述

This is the default `MultiplayerAPI.multiplayer_peer` for the `Node.multiplayer`. It mimics the behavior of a server with no peers connected.
		This means that the `SceneTree` will act as the multiplayer authority by default. Calls to `MultiplayerAPI.is_server` will return `true`, and calls to `MultiplayerAPI.get_unique_id` will return `MultiplayerPeer.TARGET_PEER_SERVER`.

