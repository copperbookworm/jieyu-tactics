# RigidBody2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RigidBody2D` → `PhysicsBody2D` → `CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RigidBody2D.md`

**摘要**：A 2D physics body that is moved by a physics simulation.

## 描述

`RigidBody2D` implements full 2D physics. It cannot be controlled directly, instead, you must apply forces to it (gravity, impulses, etc.), and the physics simulation will calculate the resulting movement, rotation, react to collisions, and affect other physics bodies in its path.
		The body's behavior can be adjusted via `lock_rotation`, `freeze`, and `freeze_mode`. By changing various properties of the object, such as `mass`, you can control how the physics simulation acts on it.
		A rigid body will always maintain its shape and size, even when forces are applied to it. It is useful for objects that can be interacted with in an environment, such as a tree that can be knocked over or a stack of crates that can be pushed around.
		If you need to directly affect the body, prefer `_integrate_forces` as it allows you to directly access the physics state.
		If you need to override the default physics behavior, you can write a custom force integration function. See `custom_integrator`.
		**Note:** Changing the 2D transform or `linear_velocity` of a `RigidBody2D` very often may lead to some unpredictable behaviors. This also happens when a `RigidBody2D` is the descendant of a constantly moving node, like another `RigidBody2D`, as that will cause its global transform to be set whenever its ancestor moves.

## 属性

- **`angular_damp`** `float` = `0.0`
  - 其它属性：getter=get_angular_damp · setter=set_angular_damp
- **`angular_damp_mode`** `int` = `0` · 枚举 `RigidBody2D.DampMode`
  - 其它属性：getter=get_angular_damp_mode · setter=set_angular_damp_mode
- **`angular_velocity`** `float` = `0.0`
  - 其它属性：getter=get_angular_velocity · setter=set_angular_velocity
- **`can_sleep`** `bool` = `true`
  - 其它属性：getter=is_able_to_sleep · setter=set_can_sleep
- **`center_of_mass`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_center_of_mass · setter=set_center_of_mass
- **`center_of_mass_mode`** `int` = `0` · 枚举 `RigidBody2D.CenterOfMassMode`
  - 其它属性：getter=get_center_of_mass_mode · setter=set_center_of_mass_mode
- **`constant_force`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_constant_force · setter=set_constant_force
- **`constant_torque`** `float` = `0.0`
  - 其它属性：getter=get_constant_torque · setter=set_constant_torque
- **`contact_monitor`** `bool` = `false`
  - 其它属性：getter=is_contact_monitor_enabled · setter=set_contact_monitor
- **`continuous_cd`** `int` = `0` · 枚举 `RigidBody2D.CCDMode`
  - 其它属性：getter=get_continuous_collision_detection_mode · setter=set_continuous_collision_detection_mode
- **`custom_integrator`** `bool` = `false`
  - 其它属性：getter=is_using_custom_integrator · setter=set_use_custom_integrator
- **`freeze`** `bool` = `false`
  - 其它属性：getter=is_freeze_enabled · setter=set_freeze_enabled
- **`freeze_mode`** `int` = `0` · 枚举 `RigidBody2D.FreezeMode`
  - 其它属性：getter=get_freeze_mode · setter=set_freeze_mode
- **`gravity_scale`** `float` = `1.0`
  - 其它属性：getter=get_gravity_scale · setter=set_gravity_scale
- **`inertia`** `float` = `0.0`
  - 其它属性：getter=get_inertia · setter=set_inertia
- **`linear_damp`** `float` = `0.0`
  - 其它属性：getter=get_linear_damp · setter=set_linear_damp
- **`linear_damp_mode`** `int` = `0` · 枚举 `RigidBody2D.DampMode`
  - 其它属性：getter=get_linear_damp_mode · setter=set_linear_damp_mode
- **`linear_velocity`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_linear_velocity · setter=set_linear_velocity
- **`lock_rotation`** `bool` = `false`
  - 其它属性：getter=is_lock_rotation_enabled · setter=set_lock_rotation_enabled
- **`mass`** `float` = `1.0`
  - 其它属性：getter=get_mass · setter=set_mass
- **`max_contacts_reported`** `int` = `0`
  - 其它属性：getter=get_max_contacts_reported · setter=set_max_contacts_reported
- **`physics_material_override`** `PhysicsMaterial`
  - 其它属性：getter=get_physics_material_override · setter=set_physics_material_override
- **`sleeping`** `bool` = `false`
  - 其它属性：getter=is_sleeping · setter=set_sleeping

## 方法

### `_integrate_forces(state: PhysicsDirectBodyState2D) -> void`
- 限定：qualifiers=virtual

Called during physics processing, allowing you to read and safely modify the simulation state for the object. By default, it is called before the standard force integration, but the `custom_integrator` property allows you to disable the standard force integration and do fully custom force integration for a body.

### `add_constant_central_force(force: Vector2) -> void`

Adds a constant directional force without affecting rotation that keeps being applied over time until cleared with `constant_force = Vector2(0, 0)`.
				This is equivalent to using `add_constant_force` at the body's center of mass.

### `add_constant_force(force: Vector2, position: Vector2 = Vector2(0, 0)) -> void`

Adds a constant positioned force to the body that keeps being applied over time until cleared with `constant_force = Vector2(0, 0)`.
				`position` is the offset from the body origin in global coordinates.

### `add_constant_torque(torque: float) -> void`

Adds a constant rotational force without affecting position that keeps being applied over time until cleared with `constant_torque = 0`.

### `apply_central_force(force: Vector2) -> void`

Applies a directional force without affecting rotation. A force is time dependent and meant to be applied every physics update.
				This is equivalent to using `apply_force` at the body's center of mass.

### `apply_central_impulse(impulse: Vector2 = Vector2(0, 0)) -> void`

Applies a directional impulse without affecting rotation.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).
				This is equivalent to using `apply_impulse` at the body's center of mass.

### `apply_force(force: Vector2, position: Vector2 = Vector2(0, 0)) -> void`

Applies a positioned force to the body. A force is time dependent and meant to be applied every physics update.
				`position` is the offset from the body origin in global coordinates.

### `apply_impulse(impulse: Vector2, position: Vector2 = Vector2(0, 0)) -> void`

Applies a positioned impulse to the body.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).
				`position` is the offset from the body origin in global coordinates.

### `apply_torque(torque: float) -> void`

Applies a rotational force without affecting position. A force is time dependent and meant to be applied every physics update.
				**Note:** `inertia` is required for this to work. To have `inertia`, an active `CollisionShape2D` must be a child of the node, or you can manually set `inertia`.

### `apply_torque_impulse(torque: float) -> void`

Applies a rotational impulse to the body without affecting the position.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).
				**Note:** `inertia` is required for this to work. To have `inertia`, an active `CollisionShape2D` must be a child of the node, or you can manually set `inertia`.

### `get_colliding_bodies() -> Node2D[]`
- 限定：qualifiers=const

Returns a list of the bodies colliding with this one. Requires `contact_monitor` to be set to `true` and `max_contacts_reported` to be set high enough to detect all the collisions.
				**Note:** The result of this test is not immediate after moving objects. For performance, list of collisions is updated once per frame and before the physics step. Consider using signals instead.

### `get_contact_count() -> int`
- 限定：qualifiers=const

Returns the number of contacts this body has with other bodies. By default, this returns 0 unless bodies are configured to monitor contacts (see `contact_monitor`).
				**Note:** To retrieve the colliding bodies, use `get_colliding_bodies`.

### `set_axis_velocity(axis_velocity: Vector2) -> void`

Sets the body's velocity on the given axis. The velocity in the given vector axis will be set as the given vector length. This is useful for jumping behavior.

## 信号

### `body_entered(body: Node)`

Emitted when a collision with another `PhysicsBody2D` or `TileMap` occurs. Requires `contact_monitor` to be set to `true` and `max_contacts_reported` to be set high enough to detect all the collisions. `TileMap`s are detected if the `TileSet` has Collision `Shape2D`s.
				`body` the `Node`, if it exists in the tree, of the other `PhysicsBody2D` or `TileMap`.

### `body_exited(body: Node)`

Emitted when the collision with another `PhysicsBody2D` or `TileMap` ends. Requires `contact_monitor` to be set to `true` and `max_contacts_reported` to be set high enough to detect all the collisions. `TileMap`s are detected if the `TileSet` has Collision `Shape2D`s.
				`body` the `Node`, if it exists in the tree, of the other `PhysicsBody2D` or `TileMap`.

### `body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int)`

Emitted when one of this RigidBody2D's `Shape2D`s collides with another `PhysicsBody2D` or `TileMap`'s `Shape2D`s. Requires `contact_monitor` to be set to `true` and `max_contacts_reported` to be set high enough to detect all the collisions. `TileMap`s are detected if the `TileSet` has Collision `Shape2D`s.
				`body_rid` the `RID` of the other `PhysicsBody2D` or `TileSet`'s `CollisionObject2D` used by the `PhysicsServer2D`.
				`body` the `Node`, if it exists in the tree, of the other `PhysicsBody2D` or `TileMap`.
				`body_shape_index` the index of the `Shape2D` of the other `PhysicsBody2D` or `TileMap` used by the `PhysicsServer2D`. Get the `CollisionShape2D` node with `body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))`.
				`local_shape_index` the index of the `Shape2D` of this RigidBody2D used by the `PhysicsServer2D`. Get the `CollisionShape2D` node with `self.shape_owner_get_owner(self.shape_find_owner(local_shape_index))`.

### `body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int)`

Emitted when the collision between one of this RigidBody2D's `Shape2D`s and another `PhysicsBody2D` or `TileMap`'s `Shape2D`s ends. Requires `contact_monitor` to be set to `true` and `max_contacts_reported` to be set high enough to detect all the collisions. `TileMap`s are detected if the `TileSet` has Collision `Shape2D`s.
				`body_rid` the `RID` of the other `PhysicsBody2D` or `TileSet`'s `CollisionObject2D` used by the `PhysicsServer2D`.
				`body` the `Node`, if it exists in the tree, of the other `PhysicsBody2D` or `TileMap`.
				`body_shape_index` the index of the `Shape2D` of the other `PhysicsBody2D` or `TileMap` used by the `PhysicsServer2D`. Get the `CollisionShape2D` node with `body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))`.
				`local_shape_index` the index of the `Shape2D` of this RigidBody2D used by the `PhysicsServer2D`. Get the `CollisionShape2D` node with `self.shape_owner_get_owner(self.shape_find_owner(local_shape_index))`.

### `sleeping_state_changed()`

Emitted when the physics engine changes the body's sleeping state.
				**Note:** Changing the value `sleeping` will not trigger this signal. It is only emitted if the sleeping state is changed by the physics engine or `emit_signal("sleeping_state_changed")` is used.

## 枚举

### `FreezeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FREEZE_MODE_STATIC` |  |
| `1` | `FREEZE_MODE_KINEMATIC` |  |

### `CenterOfMassMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CENTER_OF_MASS_MODE_AUTO` |  |
| `1` | `CENTER_OF_MASS_MODE_CUSTOM` |  |

### `DampMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DAMP_MODE_COMBINE` |  |
| `1` | `DAMP_MODE_REPLACE` |  |

### `CCDMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CCD_MODE_DISABLED` |  |
| `1` | `CCD_MODE_CAST_RAY` |  |
| `2` | `CCD_MODE_CAST_SHAPE` |  |

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)
- [2D Physics Platformer Demo](None)
- [Instancing Demo](None)

