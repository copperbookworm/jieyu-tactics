# MultiplayerSpawner

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MultiplayerSpawner` → `Node` → `Object`
> 附加属性：api_type=core · keywords=network
> 自动生成，勿手改。文件：`refs/godot-api/MultiplayerSpawner.md`

**摘要**：Automatically replicates spawnable nodes from the authority to other multiplayer peers.

## 描述

Spawnable scenes can be configured in the editor or through code (see `add_spawnable_scene`).
		Also supports custom node spawns through `spawn`, calling `spawn_function` on all peers.
		Internally, `MultiplayerSpawner` uses `MultiplayerAPI.object_configuration_add` to notify spawns passing the spawned node as the `object` and itself as the `configuration`, and `MultiplayerAPI.object_configuration_remove` to notify despawns in a similar way.

## 属性

- **`spawn_function`** `Callable`
  - 其它属性：getter=get_spawn_function · setter=set_spawn_function
- **`spawn_limit`** `int` = `0`
  - 其它属性：getter=get_spawn_limit · setter=set_spawn_limit
- **`spawn_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_spawn_path · setter=set_spawn_path

## 方法

### `add_spawnable_scene(path: String) -> void`

Adds a scene path to spawnable scenes, making it automatically replicated from the multiplayer authority to other peers when added as children of the node pointed by `spawn_path`.

### `clear_spawnable_scenes() -> void`

Clears all spawnable scenes. Does not despawn existing instances on remote peers.

### `get_spawnable_scene(index: int) -> String`
- 限定：qualifiers=const

Returns the spawnable scene path by index.

### `get_spawnable_scene_count() -> int`
- 限定：qualifiers=const

Returns the count of spawnable scene paths.

### `spawn(data: Variant = null) -> Node`

Requests a custom spawn, with `data` passed to `spawn_function` on all peers. Returns the locally spawned node instance already inside the scene tree, and added as a child of the node pointed by `spawn_path`.
				**Note:** Spawnable scenes are spawned automatically. `spawn` is only needed for custom spawns.

## 信号

### `despawned(node: Node)`

Emitted when a spawnable scene or custom spawn was despawned by the multiplayer authority. Only called on remote peers.

### `spawned(node: Node)`

Emitted when a spawnable scene or custom spawn was spawned by the multiplayer authority. Only called on remote peers.

