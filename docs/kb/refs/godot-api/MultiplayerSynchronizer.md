# MultiplayerSynchronizer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MultiplayerSynchronizer` → `Node` → `Object`
> 附加属性：api_type=core · keywords=network
> 自动生成，勿手改。文件：`refs/godot-api/MultiplayerSynchronizer.md`

**摘要**：Synchronizes properties from the multiplayer authority to the remote peers.

## 描述

By default, `MultiplayerSynchronizer` synchronizes configured properties to all peers.
		Visibility can be handled directly with `set_visibility_for` or as-needed with `add_visibility_filter` and `update_visibility`.
		`MultiplayerSpawner`s will handle nodes according to visibility of synchronizers as long as the node at `root_path` was spawned by one.
		Internally, `MultiplayerSynchronizer` uses `MultiplayerAPI.object_configuration_add` to notify synchronization start passing the `Node` at `root_path` as the `object` and itself as the `configuration`, and uses `MultiplayerAPI.object_configuration_remove` to notify synchronization end in a similar way.
		**Note:** Synchronization is not supported for `Object` type properties, like `Resource`. Properties that are unique to each peer, like the instance IDs of `Object`s (see `Object.get_instance_id`) or `RID`s, will also not work in synchronization.

## 属性

- **`delta_interval`** `float` = `0.0`
  - 其它属性：getter=get_delta_interval · setter=set_delta_interval
- **`public_visibility`** `bool` = `true`
  - 其它属性：getter=is_visibility_public · setter=set_visibility_public
- **`replication_config`** `SceneReplicationConfig`
  - 其它属性：getter=get_replication_config · setter=set_replication_config
- **`replication_interval`** `float` = `0.0`
  - 其它属性：getter=get_replication_interval · setter=set_replication_interval
- **`root_path`** `NodePath` = `NodePath("..")`
  - 其它属性：getter=get_root_path · setter=set_root_path
- **`visibility_update_mode`** `int` = `0` · 枚举 `MultiplayerSynchronizer.VisibilityUpdateMode`
  - 其它属性：getter=get_visibility_update_mode · setter=set_visibility_update_mode

## 方法

### `add_visibility_filter(filter: Callable) -> void`

Adds a peer visibility filter for this synchronizer.
				`filter` should take a peer ID `int` and return a `bool`.

### `get_visibility_for(peer: int) -> bool`
- 限定：qualifiers=const

Queries the current visibility for peer `peer`.

### `remove_visibility_filter(filter: Callable) -> void`

Removes a peer visibility filter from this synchronizer.

### `set_visibility_for(peer: int, visible: bool) -> void`

Sets the visibility of `peer` to `visible`. If `peer` is `0`, the value of `public_visibility` will be updated instead.

### `update_visibility(for_peer: int = 0) -> void`

Updates the visibility of `for_peer` according to visibility filters. If `for_peer` is `0` (the default), all peers' visibilties are updated.

## 信号

### `delta_synchronized()`

Emitted when a new delta synchronization state is received by this synchronizer after the properties have been updated.

### `synchronized()`

Emitted when a new synchronization state is received by this synchronizer after the properties have been updated.

### `visibility_changed(for_peer: int)`

Emitted when visibility of `for_peer` is updated. See `update_visibility`.

## 枚举

### `VisibilityUpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_PROCESS_IDLE` |  |
| `1` | `VISIBILITY_PROCESS_PHYSICS` |  |
| `2` | `VISIBILITY_PROCESS_NONE` |  |

