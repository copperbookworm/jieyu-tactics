# Area3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Area3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=trigger
> 自动生成，勿手改。文件：`refs/godot-api/Area3D.md`

**摘要**：A region of 3D space that detects other `CollisionObject3D`s entering or exiting it.

## 描述

`Area3D` is a region of 3D space defined by one or multiple `CollisionShape3D` or `CollisionPolygon3D` child nodes. It detects when other `CollisionObject3D`s enter or exit it, and it also keeps track of which collision objects haven't exited it yet (i.e. which one are overlapping it).
		This node can also locally alter or override physics parameters (gravity, damping) and route audio to custom audio buses.
		**Note:** Areas and bodies created with `PhysicsServer3D` might not interact as expected with `Area3D`s, and might not emit signals or track objects correctly.
		**Warning:** Using a `ConcavePolygonShape3D` inside a `CollisionShape3D` child of this node (created e.g. by using the **Create Trimesh Collision Sibling** option in the **Mesh** menu that appears when selecting a `MeshInstance3D` node) may give unexpected results, since this collision shape is hollow. If this is not desired, it has to be split into multiple `ConvexPolygonShape3D`s or primitive shapes like `BoxShape3D`, or in some cases it may be replaceable by a `CollisionPolygon3D`.

## 属性

- **`angular_damp`** `float` = `0.1`
  - 其它属性：getter=get_angular_damp · setter=set_angular_damp
- **`angular_damp_space_override`** `int` = `0` · 枚举 `Area3D.SpaceOverride`
  - 其它属性：getter=get_angular_damp_space_override_mode · setter=set_angular_damp_space_override_mode
- **`audio_bus_name`** `StringName` = `&"Master"`
  - 其它属性：getter=get_audio_bus_name · setter=set_audio_bus_name
- **`audio_bus_override`** `bool` = `false`
  - 其它属性：getter=is_overriding_audio_bus · setter=set_audio_bus_override
- **`gravity`** `float` = `9.8`
  - 其它属性：getter=get_gravity · setter=set_gravity
- **`gravity_direction`** `Vector3` = `Vector3(0, -1, 0)`
  - 其它属性：getter=get_gravity_direction · setter=set_gravity_direction
- **`gravity_point`** `bool` = `false`
  - 其它属性：getter=is_gravity_a_point · setter=set_gravity_is_point
- **`gravity_point_center`** `Vector3` = `Vector3(0, -1, 0)`
  - 其它属性：getter=get_gravity_point_center · setter=set_gravity_point_center
- **`gravity_point_unit_distance`** `float` = `0.0`
  - 其它属性：getter=get_gravity_point_unit_distance · setter=set_gravity_point_unit_distance
- **`gravity_space_override`** `int` = `0` · 枚举 `Area3D.SpaceOverride`
  - 其它属性：getter=get_gravity_space_override_mode · setter=set_gravity_space_override_mode
- **`linear_damp`** `float` = `0.1`
  - 其它属性：getter=get_linear_damp · setter=set_linear_damp
- **`linear_damp_space_override`** `int` = `0` · 枚举 `Area3D.SpaceOverride`
  - 其它属性：getter=get_linear_damp_space_override_mode · setter=set_linear_damp_space_override_mode
- **`monitorable`** `bool` = `true`
  - 其它属性：getter=is_monitorable · setter=set_monitorable
- **`monitoring`** `bool` = `true`
  - 其它属性：getter=is_monitoring · setter=set_monitoring
- **`priority`** `int` = `0`
  - 其它属性：getter=get_priority · setter=set_priority
- **`reverb_bus_amount`** `float` = `0.0`
  - 其它属性：getter=get_reverb_amount · setter=set_reverb_amount
- **`reverb_bus_enabled`** `bool` = `false`
  - 其它属性：getter=is_using_reverb_bus · setter=set_use_reverb_bus
- **`reverb_bus_name`** `StringName` = `&"Master"`
  - 其它属性：getter=get_reverb_bus_name · setter=set_reverb_bus_name
- **`reverb_bus_uniformity`** `float` = `0.0`
  - 其它属性：getter=get_reverb_uniformity · setter=set_reverb_uniformity
- **`wind_attenuation_factor`** `float` = `0.0`
  - 其它属性：getter=get_wind_attenuation_factor · setter=set_wind_attenuation_factor
- **`wind_force_magnitude`** `float` = `0.0`
  - 其它属性：getter=get_wind_force_magnitude · setter=set_wind_force_magnitude
- **`wind_source_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_wind_source_path · setter=set_wind_source_path

## 方法

### `get_overlapping_areas() -> Area3D[]`
- 限定：qualifiers=const

Returns a list of intersecting `Area3D`s. The overlapping area's `CollisionObject3D.collision_layer` must be part of this area's `CollisionObject3D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `get_overlapping_bodies() -> Node3D[]`
- 限定：qualifiers=const

Returns a list of intersecting `PhysicsBody3D`s, `SoftBody3D`s, and `GridMap`s. The overlapping body's `CollisionObject3D.collision_layer` must be part of this area's `CollisionObject3D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) this list is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not return any such bodies.

### `has_overlapping_areas() -> bool`
- 限定：qualifiers=const

Returns `true` if intersecting any `Area3D`s, otherwise returns `false`. The overlapping area's `CollisionObject3D.collision_layer` must be part of this area's `CollisionObject3D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) the list of overlapping areas is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.

### `has_overlapping_bodies() -> bool`
- 限定：qualifiers=const

Returns `true` if intersecting any `PhysicsBody3D`s, `SoftBody3D`s, or `GridMap`s, otherwise returns `false`. The overlapping body's `CollisionObject3D.collision_layer` must be part of this area's `CollisionObject3D.collision_mask` in order to be detected.
				For performance reasons (collisions are all processed at the same time) the list of overlapping bodies is modified once during the physics step, not immediately after objects are moved. Consider using signals instead.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not consider such bodies.

### `overlaps_area(area: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `Area3D` intersects or overlaps this `Area3D`, `false` otherwise.
				**Note:** The result of this test is not immediate after moving objects. For performance, list of overlaps is updated once per frame and before the physics step. Consider using signals instead.

### `overlaps_body(body: Node) -> bool`
- 限定：qualifiers=const

Returns `true` if the given physics body intersects or overlaps this `Area3D`, `false` otherwise.
				`body` argument can either be a `PhysicsBody3D`, `SoftBody3D`, or a `GridMap` instance. While GridMaps are not physics body themselves, they register their tiles with collision shapes as a virtual physics body.
				**Note:** The result of this test is not immediate after moving objects. For performance, list of overlaps is updated once per frame and before the physics step. Consider using signals instead.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will return `false` in such cases.

## 信号

### `area_entered(area: Area3D)`

Emitted when the received `area` enters this area. Requires `monitoring` to be set to `true`.

### `area_exited(area: Area3D)`

Emitted when the received `area` exits this area. Requires `monitoring` to be set to `true`.

### `area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int)`

Emitted when a `Shape3D` of the received `area` enters a shape of this area. Requires `monitoring` to be set to `true`.
				`local_shape_index` and `area_shape_index` contain indices of the interacting shapes from this area and the other area, respectively. `area_rid` contains the `RID` of the other area. These values can be used with the `PhysicsServer3D`.
				**Example:** Get the `CollisionShape3D` node from the shape index:
				`codeblocks`
				`gdscript`
				var other_shape_owner = area.shape_find_owner(area_shape_index)
				var other_shape_node = area.shape_owner_get_owner(other_shape_owner)

				var local_shape_owner = shape_find_owner(local_shape_index)
				var local_shape_node = shape_owner_get_owner(local_shape_owner)

### `area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int)`

Emitted when a `Shape3D` of the received `area` exits a shape of this area. Requires `monitoring` to be set to `true`.
				See also `area_shape_entered`.

### `body_entered(body: Node3D)`

Emitted when the received `body` enters this area. `body` can be a `PhysicsBody3D`, `SoftBody3D` or `GridMap`. `GridMap`s are detected if their `MeshLibrary` has collision shapes configured. Requires `monitoring` to be set to `true`.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not emit this signal in such cases.

### `body_exited(body: Node3D)`

Emitted when the received `body` exits this area. `body` can be a `PhysicsBody3D`, `SoftBody3D` or `GridMap`. `GridMap`s are detected if their `MeshLibrary` has collision shapes configured. Requires `monitoring` to be set to `true`.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not emit this signal in such cases.

### `body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int)`

Emitted when a `Shape3D` of the received `body` enters a shape of this area. `body` can be a `PhysicsBody3D`, `SoftBody3D` or `GridMap`. `GridMap`s are detected if their `MeshLibrary` has collision shapes configured. Requires `monitoring` to be set to `true`.
				`local_shape_index` and `body_shape_index` contain indices of the interacting shapes from this area and the interacting body, respectively. `body_rid` contains the `RID` of the body. These values can be used with the `PhysicsServer3D`.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not emit this signal in such cases.
				**Example:** Get the `CollisionShape3D` node from the shape index:
				`codeblocks`
				`gdscript`
				var body_shape_owner = body.shape_find_owner(body_shape_index)
				var body_shape_node = body.shape_owner_get_owner(body_shape_owner)

				var local_shape_owner = shape_find_owner(local_shape_index)
				var local_shape_node = shape_owner_get_owner(local_shape_owner)

### `body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int)`

Emitted when a `Shape3D` of the received `body` exits a shape of this area. `body` can be a `PhysicsBody3D`, `SoftBody3D` or `GridMap`. `GridMap`s are detected if their `MeshLibrary` has collision shapes configured. Requires `monitoring` to be set to `true`.
				See also `body_shape_entered`.
				**Note:** Godot Physics does not support reporting overlaps with `SoftBody3D`, so will not emit this signal in such cases.

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
- [3D Platformer Demo](None)
- [GUI in 3D Viewport Demo](None)

