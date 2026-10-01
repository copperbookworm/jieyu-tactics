# PhysicsDirectBodyState2DExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsDirectBodyState2DExtension` → `PhysicsDirectBodyState2D` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsDirectBodyState2DExtension.md`

**摘要**：Provides virtual methods that can be overridden to create custom `PhysicsDirectBodyState2D` implementations.

## 描述

This class extends `PhysicsDirectBodyState2D` by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.
		Intended for use with GDExtension to create custom implementations of `PhysicsDirectBodyState2D`.

## 方法

### `_add_constant_central_force(force: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.add_constant_central_force`.

### `_add_constant_force(force: Vector2, position: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.add_constant_force`.

### `_add_constant_torque(torque: float) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.add_constant_torque`.

### `_apply_central_force(force: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_central_force`.

### `_apply_central_impulse(impulse: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_central_impulse`.

### `_apply_force(force: Vector2, position: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_force`.

### `_apply_impulse(impulse: Vector2, position: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_impulse`.

### `_apply_torque(torque: float) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_torque`.

### `_apply_torque_impulse(impulse: float) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.apply_torque_impulse`.

### `_get_angular_velocity() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.angular_velocity` and its respective getter.

### `_get_center_of_mass() -> Vector2`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.center_of_mass` and its respective getter.

### `_get_center_of_mass_local() -> Vector2`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.center_of_mass_local` and its respective getter.

### `_get_collision_layer() -> int`
- 限定：qualifiers=virtual required const

### `_get_collision_mask() -> int`
- 限定：qualifiers=virtual required const

### `_get_constant_force() -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_constant_force`.

### `_get_constant_torque() -> float`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_constant_torque`.

### `_get_contact_collider(contact_idx: int) -> RID`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider`.

### `_get_contact_collider_id(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider_id`.

### `_get_contact_collider_object(contact_idx: int) -> Object`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider_object`.

### `_get_contact_collider_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider_position`.

### `_get_contact_collider_shape(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider_shape`.

### `_get_contact_collider_velocity_at_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_collider_velocity_at_position`.

### `_get_contact_count() -> int`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_count`.

### `_get_contact_impulse(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_impulse`.

### `_get_contact_local_normal(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_local_normal`.

### `_get_contact_local_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_local_position`.

### `_get_contact_local_shape(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_local_shape`.

### `_get_contact_local_velocity_at_position(contact_idx: int) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_contact_local_velocity_at_position`.

### `_get_inverse_inertia() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.inverse_inertia` and its respective getter.

### `_get_inverse_mass() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.inverse_mass` and its respective getter.

### `_get_linear_velocity() -> Vector2`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.linear_velocity` and its respective getter.

### `_get_space_state() -> PhysicsDirectSpaceState2D`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.get_space_state`.

### `_get_step() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.step` and its respective getter.

### `_get_total_angular_damp() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.total_angular_damp` and its respective getter.

### `_get_total_gravity() -> Vector2`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.total_gravity` and its respective getter.

### `_get_total_linear_damp() -> float`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.total_linear_damp` and its respective getter.

### `_get_transform() -> Transform2D`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.transform` and its respective getter.

### `_get_velocity_at_local_position(local_position: Vector2) -> Vector2`
- 限定：qualifiers=virtual required const

Overridable version of `PhysicsDirectBodyState2D.get_velocity_at_local_position`.

### `_integrate_forces() -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.integrate_forces`.

### `_is_sleeping() -> bool`
- 限定：qualifiers=virtual required const

Implement to override the behavior of `PhysicsDirectBodyState2D.sleeping` and its respective getter.

### `_set_angular_velocity(velocity: float) -> void`
- 限定：qualifiers=virtual required

Implement to override the behavior of `PhysicsDirectBodyState2D.angular_velocity` and its respective setter.

### `_set_collision_layer(layer: int) -> void`
- 限定：qualifiers=virtual required

### `_set_collision_mask(mask: int) -> void`
- 限定：qualifiers=virtual required

### `_set_constant_force(force: Vector2) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.set_constant_force`.

### `_set_constant_torque(torque: float) -> void`
- 限定：qualifiers=virtual required

Overridable version of `PhysicsDirectBodyState2D.set_constant_torque`.

### `_set_linear_velocity(velocity: Vector2) -> void`
- 限定：qualifiers=virtual required

Implement to override the behavior of `PhysicsDirectBodyState2D.linear_velocity` and its respective setter.

### `_set_sleep_state(enabled: bool) -> void`
- 限定：qualifiers=virtual required

Implement to override the behavior of `PhysicsDirectBodyState2D.sleeping` and its respective setter.

### `_set_transform(transform: Transform2D) -> void`
- 限定：qualifiers=virtual required

Implement to override the behavior of `PhysicsDirectBodyState2D.transform` and its respective setter.

