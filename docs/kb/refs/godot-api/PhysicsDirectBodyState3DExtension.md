# PhysicsDirectBodyState3DExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsDirectBodyState3DExtension` → `PhysicsDirectBodyState3D` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsDirectBodyState3DExtension.md`

**摘要**：Provides virtual methods that can be overridden to create custom `PhysicsDirectBodyState3D` implementations.

## 描述

This class extends `PhysicsDirectBodyState3D` by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.
		Intended for use with GDExtension to create custom implementations of `PhysicsDirectBodyState3D`.

## 方法

### `_add_constant_central_force(force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_add_constant_force(force: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_add_constant_torque(torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_central_force(force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_central_impulse(impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_force(force: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_impulse(impulse: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_torque(torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_apply_torque_impulse(impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_get_angular_velocity() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_center_of_mass() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_center_of_mass_local() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_collision_layer() -> int`
- 限定：qualifiers=virtual required const

### `_get_collision_mask() -> int`
- 限定：qualifiers=virtual required const

### `_get_constant_force() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_constant_torque() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_collider(contact_idx: int) -> RID`
- 限定：qualifiers=virtual required const

### `_get_contact_collider_id(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

### `_get_contact_collider_object(contact_idx: int) -> Object`
- 限定：qualifiers=virtual required const

### `_get_contact_collider_position(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_collider_shape(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

### `_get_contact_collider_velocity_at_position(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_count() -> int`
- 限定：qualifiers=virtual required const

### `_get_contact_impulse(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_local_normal(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_local_position(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_contact_local_shape(contact_idx: int) -> int`
- 限定：qualifiers=virtual required const

### `_get_contact_local_velocity_at_position(contact_idx: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_inverse_inertia() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_inverse_inertia_tensor() -> Basis`
- 限定：qualifiers=virtual required const

### `_get_inverse_mass() -> float`
- 限定：qualifiers=virtual required const

### `_get_linear_velocity() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_principal_inertia_axes() -> Basis`
- 限定：qualifiers=virtual required const

### `_get_space_state() -> PhysicsDirectSpaceState3D`
- 限定：qualifiers=virtual required

### `_get_step() -> float`
- 限定：qualifiers=virtual required const

### `_get_total_angular_damp() -> float`
- 限定：qualifiers=virtual required const

### `_get_total_gravity() -> Vector3`
- 限定：qualifiers=virtual required const

### `_get_total_linear_damp() -> float`
- 限定：qualifiers=virtual required const

### `_get_transform() -> Transform3D`
- 限定：qualifiers=virtual required const

### `_get_velocity_at_local_position(local_position: Vector3) -> Vector3`
- 限定：qualifiers=virtual required const

### `_integrate_forces() -> void`
- 限定：qualifiers=virtual required

### `_is_sleeping() -> bool`
- 限定：qualifiers=virtual required const

### `_set_angular_velocity(velocity: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_set_collision_layer(layer: int) -> void`
- 限定：qualifiers=virtual required

### `_set_collision_mask(mask: int) -> void`
- 限定：qualifiers=virtual required

### `_set_constant_force(force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_set_constant_torque(torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_set_linear_velocity(velocity: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_set_sleep_state(enabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_set_transform(transform: Transform3D) -> void`
- 限定：qualifiers=virtual required

