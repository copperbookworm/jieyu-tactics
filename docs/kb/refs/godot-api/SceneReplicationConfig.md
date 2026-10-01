# SceneReplicationConfig

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SceneReplicationConfig` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SceneReplicationConfig.md`

**摘要**：Configuration for properties to synchronize with a `MultiplayerSynchronizer`.

## 方法

### `add_property(path: NodePath, index: int = -1) -> void`

Adds the property identified by the given `path` to the list of the properties being synchronized, optionally passing an `index`.
				**Note:** For details on restrictions and limitations on property synchronization, see `MultiplayerSynchronizer`.

### `get_properties() -> NodePath[]`
- 限定：qualifiers=const

Returns a list of synchronized property `NodePath`s.

### `has_property(path: NodePath) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `path` is configured for synchronization.

### `property_get_index(path: NodePath) -> int`
- 限定：qualifiers=const

Finds the index of the given `path`.

### `property_get_replication_mode(path: NodePath) -> int`

Returns the replication mode for the property identified by the given `path`.

### `property_get_spawn(path: NodePath) -> bool`

Returns `true` if the property identified by the given `path` is configured to be synchronized on spawn.

### `property_get_sync(path: NodePath) -> bool`
- 限定：deprecated=Use [method property_get_replication_mode] instead.

Returns `true` if the property identified by the given `path` is configured to be synchronized on process.

### `property_get_watch(path: NodePath) -> bool`
- 限定：deprecated=Use [method property_get_replication_mode] instead.

Returns `true` if the property identified by the given `path` is configured to be reliably synchronized when changes are detected on process.

### `property_set_replication_mode(path: NodePath, mode: int) -> void`

Sets the synchronization mode for the property identified by the given `path`.

### `property_set_spawn(path: NodePath, enabled: bool) -> void`

Sets whether the property identified by the given `path` is configured to be synchronized on spawn.

### `property_set_sync(path: NodePath, enabled: bool) -> void`
- 限定：deprecated=Use [method property_set_replication_mode] with [constant REPLICATION_MODE_ALWAYS] instead.

Sets whether the property identified by the given `path` is configured to be synchronized on process.

### `property_set_watch(path: NodePath, enabled: bool) -> void`
- 限定：deprecated=Use [method property_set_replication_mode] with [constant REPLICATION_MODE_ON_CHANGE] instead.

Sets whether the property identified by the given `path` is configured to be reliably synchronized when changes are detected on process.

### `remove_property(path: NodePath) -> void`

Removes the property identified by the given `path` from the configuration.

## 枚举

### `ReplicationMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REPLICATION_MODE_NEVER` |  |
| `1` | `REPLICATION_MODE_ALWAYS` |  |
| `2` | `REPLICATION_MODE_ON_CHANGE` |  |

