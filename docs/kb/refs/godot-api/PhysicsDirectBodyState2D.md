# PhysicsDirectBodyState2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsDirectBodyState2D` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsDirectBodyState2D.md`

**摘要**：Provides direct access to a physics body in the `PhysicsServer2D`.

## 描述

Provides direct access to a physics body in the `PhysicsServer2D`, allowing safe changes to physics properties. This object is passed via the direct state callback of `RigidBody2D`, and is intended for changing the direct state of that body. See `RigidBody2D._integrate_forces`.

## 属性

- **`angular_velocity`** `float`
  - 其它属性：getter=get_angular_velocity · setter=set_angular_velocity
- **`center_of_mass`** `Vector2`
  - 其它属性：getter=get_center_of_mass · setter=
- **`center_of_mass_local`** `Vector2`
  - 其它属性：getter=get_center_of_mass_local · setter=
- **`collision_layer`** `int`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`inverse_inertia`** `float`
  - 其它属性：getter=get_inverse_inertia · setter=
- **`inverse_mass`** `float`
  - 其它属性：getter=get_inverse_mass · setter=
- **`linear_velocity`** `Vector2`
  - 其它属性：getter=get_linear_velocity · setter=set_linear_velocity
- **`sleeping`** `bool`
  - 其它属性：getter=is_sleeping · setter=set_sleep_state
- **`step`** `float`
  - 其它属性：getter=get_step · setter=
- **`total_angular_damp`** `float`
  - 其它属性：getter=get_total_angular_damp · setter=
- **`total_gravity`** `Vector2`
  - 其它属性：getter=get_total_gravity · setter=
- **`total_linear_damp`** `float`
  - 其它属性：getter=get_total_linear_damp · setter=
- **`transform`** `Transform2D`
  - 其它属性：getter=get_transform · setter=set_transform

## 方法

### `add_constant_central_force(force: Vector2 = Vector2(0, 0)) -> void`

Adds a constant directional force without affecting rotation that keeps being applied over time until cleared with `constant_force = Vector2(0, 0)`.
				This is equivalent to using `add_constant_force` at the body's center of mass.

### `add_constant_force(force: Vector2, position: Vector2 = Vector2(0, 0)) -> void`

Adds a constant positioned force to the body that keeps being applied over time until cleared with `constant_force = Vector2(0, 0)`.
				`position` is the offset from the body origin in global coordinates.

### `add_constant_torque(torque: float) -> void`

Adds a constant rotational force without affecting position that keeps being applied over time until cleared with `constant_torque = 0`.

### `apply_central_force(force: Vector2 = Vector2(0, 0)) -> void`

Applies a directional force without affecting rotation. A force is time dependent and meant to be applied every physics update.
				This is equivalent to using `apply_force` at the body's center of mass.

### `apply_central_impulse(impulse: Vector2) -> void`

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
				**Note:** `inverse_inertia` is required for this to work. To have `inverse_inertia`, an active `CollisionShape2D` must be a child of the node, or you can manually set `inverse_inertia`.

### `apply_torque_impulse(impulse: float) -> void`

Applies a rotational impulse to the body without affecting the position.
				An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).
				**Note:** `inverse_inertia` is required for this to work. To have `inverse_inertia`, an active `CollisionShape2D` must be a child of the node, or you can manually set `inverse_inertia`.

### `get_constant_force() -> Vector2`
- 限定：qualifiers=const

Returns the body's total constant positional forces applied during each physics update.
				See `add_constant_force` and `add_constant_central_force`.

### `get_constant_torque() -> float`
- 限定：qualifiers=const

Returns the body's total constant rotational forces applied during each physics update.
				See `add_constant_torque`.

### `get_contact_collider(contact_idx: int) -> RID`
- 限定：qualifiers=const

Returns the collider's `RID`.

### `get_contact_collider_id(contact_idx: int) -> int`
- 限定：qualifiers=const

Returns the collider's object id.

### `get_contact_collider_object(contact_idx: int) -> Object`
- 限定：qualifiers=const

Returns the collider object. This depends on how it was created (will return a scene node if such was used to create it).

### `get_contact_collider_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the position of the contact point on the collider in the global coordinate system.

### `get_contact_collider_shape(contact_idx: int) -> int`
- 限定：qualifiers=const

Returns the collider's shape index.

### `get_contact_collider_velocity_at_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the velocity vector at the collider's contact point.

### `get_contact_count() -> int`
- 限定：qualifiers=const

Returns the number of contacts this body has with other bodies.
				**Note:** By default, this returns 0 unless bodies are configured to monitor contacts. See `RigidBody2D.contact_monitor`.

### `get_contact_impulse(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the impulse created by the contact.

### `get_contact_local_normal(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the local normal at the contact point.

### `get_contact_local_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the position of the contact point on the body in the global coordinate system.

### `get_contact_local_shape(contact_idx: int) -> int`
- 限定：qualifiers=const

Returns the local shape index of the collision.

### `get_contact_local_velocity_at_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the velocity vector at the body's contact point.

### `get_space_state() -> PhysicsDirectSpaceState2D`

Returns the current state of the space, useful for queries.

### `get_velocity_at_local_position(local_position: Vector2) -> Vector2`
- 限定：qualifiers=const

Returns the body's velocity at the given relative position.
				`local_position` is the offset from the body origin in global coordinates.

### `integrate_forces() -> void`

Updates the body's linear and angular velocity by applying gravity and damping for the equivalent of one physics tick.

### `set_constant_force(force: Vector2) -> void`

Sets the body's total constant positional forces applied during each physics update.
				See `add_constant_force` and `add_constant_central_force`.

### `set_constant_torque(torque: float) -> void`

Sets the body's total constant rotational forces applied during each physics update.
				See `add_constant_torque`.

## 教程链接

- [Physics introduction](None)
- [Ray-casting](None)

