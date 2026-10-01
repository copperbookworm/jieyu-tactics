# SoftBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SoftBody3D` → `MeshInstance3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SoftBody3D.md`

**摘要**：A deformable 3D physics mesh.

## 描述

A deformable 3D physics mesh. Used to create elastic or deformable objects such as cloth, rubber, or other flexible materials.
		Additionally, `SoftBody3D` is subject to wind forces defined in `Area3D` (see `Area3D.wind_source_path`, `Area3D.wind_force_magnitude`, and `Area3D.wind_attenuation_factor`).
		**Note:** It's recommended to use Jolt Physics when using `SoftBody3D` instead of the default GodotPhysics3D, as Jolt Physics' soft body implementation is faster and more reliable. You can switch the physics engine using the `ProjectSettings.physics/3d/physics_engine` project setting.

## 属性

- **`collision_layer`** `int` = `1`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`damping_coefficient`** `float` = `0.01`
  - 其它属性：getter=get_damping_coefficient · setter=set_damping_coefficient
- **`disable_mode`** `int` = `0` · 枚举 `SoftBody3D.DisableMode`
  - 其它属性：getter=get_disable_mode · setter=set_disable_mode
- **`drag_coefficient`** `float` = `0.0`
  - 其它属性：getter=get_drag_coefficient · setter=set_drag_coefficient
- **`linear_stiffness`** `float` = `0.5`
  - 其它属性：getter=get_linear_stiffness · setter=set_linear_stiffness
- **`parent_collision_ignore`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_parent_collision_ignore · setter=set_parent_collision_ignore
- **`pressure_coefficient`** `float` = `0.0`
  - 其它属性：getter=get_pressure_coefficient · setter=set_pressure_coefficient
- **`ray_pickable`** `bool` = `true`
  - 其它属性：getter=is_ray_pickable · setter=set_ray_pickable
- **`shrinking_factor`** `float` = `0.0`
  - 其它属性：getter=get_shrinking_factor · setter=set_shrinking_factor
- **`simulation_precision`** `int` = `5`
  - 其它属性：getter=get_simulation_precision · setter=set_simulation_precision
- **`total_mass`** `float` = `1.0`
  - 其它属性：getter=get_total_mass · setter=set_total_mass

## 方法

### `add_collision_exception_with(body: Node) -> void`

Adds a body to the list of bodies that this body can't collide with.

### `apply_central_force(force: Vector3) -> void`

Distributes and applies a force to all points. A force is time dependent and meant to be applied every physics update.

### `apply_central_impulse(impulse: Vector3) -> void`

Distributes and applies an impulse to all points.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

### `apply_force(point_index: int, force: Vector3) -> void`

Applies a force to a point. A force is time dependent and meant to be applied every physics update.

### `apply_impulse(point_index: int, impulse: Vector3) -> void`

Applies an impulse to a point.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

### `get_collision_exceptions() -> PhysicsBody3D[]`

Returns an array of nodes that were added as collision exceptions for this body.

### `get_collision_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_layer` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_physics_rid() -> RID`
- 限定：qualifiers=const

Returns the internal `RID` used by the `PhysicsServer3D` for this body.

### `get_point_transform(point_index: int) -> Vector3`

Returns local translation of a vertex in the surface array.

### `is_point_pinned(point_index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if vertex is set to pinned.

### `remove_collision_exception_with(body: Node) -> void`

Removes a body from the list of bodies that this body can't collide with.

### `set_collision_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_layer`, given a `layer_number` between 1 and 32.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

### `set_point_pinned(point_index: int, pinned: bool, attachment_path: NodePath = NodePath(""), insert_at: int = -1) -> void`

Sets the pinned state of a surface vertex. When set to `true`, the optional `attachment_path` can define a `Node3D` the pinned vertex will be attached to.

## 枚举

### `DisableMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISABLE_MODE_REMOVE` |  |
| `1` | `DISABLE_MODE_KEEP_ACTIVE` |  |

## 教程链接

- [SoftBody](None)

