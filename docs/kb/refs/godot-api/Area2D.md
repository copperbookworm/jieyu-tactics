# Area2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Area2D` → `CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=trigger
> 自动生成，勿手改。文件：`refs/godot-api/Area2D.md`

**摘要**：A region of 2D space that detects other `CollisionObject2D`s entering or exiting it.

## 描述

`Area2D` is a region of 2D space defined by one or multiple `CollisionShape2D` or `CollisionPolygon2D` child nodes. It detects when other `CollisionObject2D`s enter or exit it, and it also keeps track of which collision objects haven't exited it yet (i.e. which one are overlapping it).
		This node can also locally alter or override physics parameters (gravity, damping) and route audio to custom audio buses.
		**Note:** Areas and bodies created with `PhysicsServer2D` might not interact as expected with `Area2D`s, and might not emit signals or track objects correctly.

## 属性

- **`angular_damp`** `float` = `1.0`
  - 其它属性：getter=get_angular_damp · setter=set_angular_damp
- **`angular_damp_space_override`** `int` = `0` · 枚举 `Area2D.SpaceOverride`
  - 其它属性：getter=get_angular_damp_space_override_mode · setter=set_angular_damp_space_override_mode
- **`audio_bus_name`** `StringName` = `&"Master"`
  - 其它属性：getter=get_audio_bus_name · setter=set_audio_bus_name
- **`audio_bus_override`** `bool` = `false`
  - 其它属性：getter=is_overriding_audio_bus · setter=set_audio_bus_override
- **`gravity`** `float` = `980.0`
  - 其它属性：getter=get_gravity · setter=set_gravity
- **`gravity_direction`** `Vector2` = `Vector2(0, 1)`
  - 其它属性：getter=get_gravity_direction · setter=set_gravity_direction
- **`gravity_point`** `bool` = `false`
  - 其它属性：getter=is_gravity_a_point · setter=set_gravity_is_point
- **`gravity_point_center`** `Vector2` = `Vector2(0, 1)`
  - 其它属性：getter=get_gravity_point_center · setter=set_gravity_point_center
- **`gravity_point_unit_distance`** `float` = `0.0`
  - 其它属性：getter=get_gravity_point_unit_distance · setter=set_gravity_point_unit_distance
- **`gravity_space_override`** `int` = `0` · 枚举 `Area2D.SpaceOverride`
  - 其它属性：getter=get_gravity_space_override_mode · setter=set_gravity_space_override_mode
- **`linear_damp`** `float` = `0.1`
  - 其它属性：getter=get_linear_damp · setter=set_linear_damp
- **`linear_damp_space_override`** `int` = `0` · 枚举 `Area2D.SpaceOverride`
  - 其它属性：getter=get_linear_damp_space_override_mode · setter=set_linear_damp_space_override_mode
- **`monitorable`** `bool` = `true`
  - 其它属性：getter=is_monitorable · setter=set_monitorable
- **`monitoring`** `bool` = `true`
  - 其它属性：getter=is_monitoring · setter=set_monitoring
- **`priority`** `int` = `0`
  - 其它属性：getter=get_priority · setter=set_priority

## 方法

### `get_overlapping_areas() -> Area2D[]`
- 限定：qualifiers=const

Returns a list of intersecting `Area2D`s. The overlapping area's `CollisionObject2D.collision_layer` must be part of this area's `CollisionObject2D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `get_overlapping_bodies() -> Node2D[]`
- 限定：qualifiers=const

Returns a list of intersecting `PhysicsBody2D`s and `TileMap`s. The overlapping body's `CollisionObject2D.collision_layer` must be part of this area's `CollisionObject2D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `has_overlapping_areas() -> bool`
- 限定：qualifiers=const

Returns `true` if intersecting any `Area2D`s, otherwise returns `false`. The overlapping area's `CollisionObject2D.collision_layer` must be part of this area's `CollisionObject2D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) the list of overlapping areas is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `has_overlapping_bodies() -> bool`
- 限定：qualifiers=const

Returns `true` if intersecting any `PhysicsBody2D`s or `TileMap`s, otherwise returns `false`. The overlapping body's `CollisionObject2D.collision_layer` must be part of this area's `CollisionObject2D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) the list of overlapping bodies is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `overlaps_area(area: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `Area2D` intersects or overlaps this `Area2D`, `false` otherwise.
				**Note:** The result of this test is not immediate after moving objects. For performance, the list of overlaps is updated once per frame and before the physics step. Consider using signals instead.

### `overlaps_body(body: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given physics body intersects or overlaps this `Area2D`, `false` otherwise.
				**Note:** The result of this test is not immediate after moving objects. For performance, list of overlaps is updated once per frame and before the physics step. Consider using signals instead.
				The `body` argument can either be a `PhysicsBody2D` or a `TileMap` instance. While TileMaps are not physics bodies themselves, they register their tiles with collision shapes as a virtual physics body.

## 信号

### `area_entered(area: Area2D)`

Emitted when the received `area` enters this area. Requires `monitoring` to be set to `true`.

### `area_exited(area: Area2D)`

Emitted when the received `area` exits this area. Requires `monitoring` to be set to `true`.

### `area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int)`

Emitted when a `Shape2D` of the received `area` enters a shape of this area. Requires `monitoring` to be set to `true`.
				`local_shape_index` and `area_shape_index` contain indices of the interacting shapes from this area and the other area, respectively. `area_rid` contains the `RID` of the other area. These values can be used with the `PhysicsServer2D`.
				**Example:** Get the `CollisionShape2D` node from the shape index:
				`codeblocks`
				`gdscript`
				var other_shape_owner = area.shape_find_owner(area_shape_index)
				var other_shape_node = area.shape_owner_get_owner(other_shape_owner)

				var local_shape_owner = shape_find_owner(local_shape_index)
				var local_shape_node = shape_owner_get_owner(local_shape_owner)

### `area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int)`

Emitted when a `Shape2D` of the received `area` exits a shape of this area. Requires `monitoring` to be set to `true`.
				See also `area_shape_entered`.

### `body_entered(body: Node2D)`

Emitted when the received `body` enters this area. `body` can be a `PhysicsBody2D` or a `TileMap`. `TileMap`s are detected if their `TileSet` has collision shapes configured. Requires `monitoring` to be set to `true`.

### `body_exited(body: Node2D)`

Emitted when the received `body` exits this area. `body` can be a `PhysicsBody2D` or a `TileMap`. `TileMap`s are detected if their `TileSet` has collision shapes configured. Requires `monitoring` to be set to `true`.

### `body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int)`

Emitted when a `Shape2D` of the received `body` enters a shape of this area. `body` can be a `PhysicsBody2D` or a `TileMap`. `TileMap`s are detected if their `TileSet` has collision shapes configured. Requires `monitoring` to be set to `true`.
				`local_shape_index` and `body_shape_index` contain indices of the interacting shapes from this area and the interacting body, respectively. `body_rid` contains the `RID` of the body. These values can be used with the `PhysicsServer2D`.
				**Example:** Get the `CollisionShape2D` node from the shape index:
				`codeblocks`
				`gdscript`
				var body_shape_owner = body.shape_find_owner(body_shape_index)
				var body_shape_node = body.shape_owner_get_owner(body_shape_owner)

				var local_shape_owner = shape_find_owner(local_shape_index)
				var local_shape_node = shape_owner_get_owner(local_shape_owner)

### `body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int)`

Emitted when a `Shape2D` of the received `body` exits a shape of this area. `body` can be a `PhysicsBody2D` or a `TileMap`. `TileMap`s are detected if their `TileSet` has collision shapes configured. Requires `monitoring` to be set to `true`.
				See also `body_shape_entered`.

## 枚举

### `SpaceOverride`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SPACE_OVERRIDE_DISABLED` |  |
| `1` | `SPACE_OVERRIDE_COMBINE` |  |
| `2` | `SPACE_OVERRIDE_COMBINE_REPLACE` |  |
| `3` | `SPACE_OVERRIDE_REPLACE` |  |
| `4` | `SPACE_OVERRIDE_REPLACE_COMBINE` |  |

## 教程链接

- [Using Area2D](None)
- [2D Dodge The Creeps Demo](None)
- [2D Pong Demo](None)
- [2D Platformer Demo](None)

