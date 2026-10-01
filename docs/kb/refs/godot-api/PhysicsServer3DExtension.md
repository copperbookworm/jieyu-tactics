# PhysicsServer3DExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsServer3DExtension` → `PhysicsServer3D` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsServer3DExtension.md`

**摘要**：Provides virtual methods that can be overridden to create custom `PhysicsServer3D` implementations.

## 描述

This class extends `PhysicsServer3D` by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.
		Intended for use with GDExtension to create custom implementations of `PhysicsServer3D`.

## 方法

### `_area_add_shape(area: RID, shape: RID, transform: Transform3D, disabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_area_attach_object_instance_id(area: RID, id: int) -> void`
- 限定：qualifiers=virtual required

### `_area_clear_shapes(area: RID) -> void`
- 限定：qualifiers=virtual required

### `_area_create() -> RID`
- 限定：qualifiers=virtual required

### `_area_get_collision_layer(area: RID) -> int`
- 限定：qualifiers=virtual required const

### `_area_get_collision_mask(area: RID) -> int`
- 限定：qualifiers=virtual required const

### `_area_get_object_instance_id(area: RID) -> int`
- 限定：qualifiers=virtual required const

### `_area_get_param(area: RID, param: int) -> Variant`
- 限定：qualifiers=virtual required const

### `_area_get_shape(area: RID, shape_idx: int) -> RID`
- 限定：qualifiers=virtual required const

### `_area_get_shape_count(area: RID) -> int`
- 限定：qualifiers=virtual required const

### `_area_get_shape_transform(area: RID, shape_idx: int) -> Transform3D`
- 限定：qualifiers=virtual required const

### `_area_get_space(area: RID) -> RID`
- 限定：qualifiers=virtual required const

### `_area_get_transform(area: RID) -> Transform3D`
- 限定：qualifiers=virtual required const

### `_area_remove_shape(area: RID, shape_idx: int) -> void`
- 限定：qualifiers=virtual required

### `_area_set_area_monitor_callback(area: RID, callback: Callable) -> void`
- 限定：qualifiers=virtual required

### `_area_set_collision_layer(area: RID, layer: int) -> void`
- 限定：qualifiers=virtual required

### `_area_set_collision_mask(area: RID, mask: int) -> void`
- 限定：qualifiers=virtual required

### `_area_set_monitor_callback(area: RID, callback: Callable) -> void`
- 限定：qualifiers=virtual required

### `_area_set_monitorable(area: RID, monitorable: bool) -> void`
- 限定：qualifiers=virtual required

### `_area_set_param(area: RID, param: int, value: Variant) -> void`
- 限定：qualifiers=virtual required

### `_area_set_ray_pickable(area: RID, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_area_set_shape(area: RID, shape_idx: int, shape: RID) -> void`
- 限定：qualifiers=virtual required

### `_area_set_shape_disabled(area: RID, shape_idx: int, disabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_area_set_shape_transform(area: RID, shape_idx: int, transform: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_area_set_space(area: RID, space: RID) -> void`
- 限定：qualifiers=virtual required

### `_area_set_transform(area: RID, transform: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_body_add_collision_exception(body: RID, excepted_body: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_add_constant_central_force(body: RID, force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_add_constant_force(body: RID, force: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_add_constant_torque(body: RID, torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_add_shape(body: RID, shape: RID, transform: Transform3D, disabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_central_force(body: RID, force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_central_impulse(body: RID, impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_force(body: RID, force: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_impulse(body: RID, impulse: Vector3, position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_torque(body: RID, torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_apply_torque_impulse(body: RID, impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_attach_object_instance_id(body: RID, id: int) -> void`
- 限定：qualifiers=virtual required

### `_body_clear_shapes(body: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_create() -> RID`
- 限定：qualifiers=virtual required

### `_body_get_collision_exceptions(body: RID) -> RID[]`
- 限定：qualifiers=virtual required const

### `_body_get_collision_layer(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_collision_mask(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_collision_priority(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_body_get_constant_force(body: RID) -> Vector3`
- 限定：qualifiers=virtual required const

### `_body_get_constant_torque(body: RID) -> Vector3`
- 限定：qualifiers=virtual required const

### `_body_get_contacts_reported_depth_threshold(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_body_get_direct_state(body: RID) -> PhysicsDirectBodyState3D`
- 限定：qualifiers=virtual required

### `_body_get_max_contacts_reported(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_mode(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_object_instance_id(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_param(body: RID, param: int) -> Variant`
- 限定：qualifiers=virtual required const

### `_body_get_shape(body: RID, shape_idx: int) -> RID`
- 限定：qualifiers=virtual required const

### `_body_get_shape_count(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_get_shape_transform(body: RID, shape_idx: int) -> Transform3D`
- 限定：qualifiers=virtual required const

### `_body_get_space(body: RID) -> RID`
- 限定：qualifiers=virtual required const

### `_body_get_state(body: RID, state: int) -> Variant`
- 限定：qualifiers=virtual required const

### `_body_get_user_flags(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_body_is_axis_locked(body: RID, axis: int) -> bool`
- 限定：qualifiers=virtual required const

### `_body_is_continuous_collision_detection_enabled(body: RID) -> bool`
- 限定：qualifiers=virtual required const

### `_body_is_omitting_force_integration(body: RID) -> bool`
- 限定：qualifiers=virtual required const

### `_body_remove_collision_exception(body: RID, excepted_body: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_remove_shape(body: RID, shape_idx: int) -> void`
- 限定：qualifiers=virtual required

### `_body_reset_mass_properties(body: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_set_axis_lock(body: RID, axis: int, lock: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_set_axis_velocity(body: RID, axis_velocity: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_set_collision_layer(body: RID, layer: int) -> void`
- 限定：qualifiers=virtual required

### `_body_set_collision_mask(body: RID, mask: int) -> void`
- 限定：qualifiers=virtual required

### `_body_set_collision_priority(body: RID, priority: float) -> void`
- 限定：qualifiers=virtual required

### `_body_set_constant_force(body: RID, force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_set_constant_torque(body: RID, torque: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_body_set_contacts_reported_depth_threshold(body: RID, threshold: float) -> void`
- 限定：qualifiers=virtual required

### `_body_set_enable_continuous_collision_detection(body: RID, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_set_force_integration_callback(body: RID, callable: Callable, userdata: Variant) -> void`
- 限定：qualifiers=virtual required

### `_body_set_max_contacts_reported(body: RID, amount: int) -> void`
- 限定：qualifiers=virtual required

### `_body_set_mode(body: RID, mode: int) -> void`
- 限定：qualifiers=virtual required

### `_body_set_omit_force_integration(body: RID, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_set_param(body: RID, param: int, value: Variant) -> void`
- 限定：qualifiers=virtual required

### `_body_set_ray_pickable(body: RID, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_set_shape(body: RID, shape_idx: int, shape: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_set_shape_disabled(body: RID, shape_idx: int, disabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_body_set_shape_transform(body: RID, shape_idx: int, transform: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_body_set_space(body: RID, space: RID) -> void`
- 限定：qualifiers=virtual required

### `_body_set_state(body: RID, state: int, value: Variant) -> void`
- 限定：qualifiers=virtual required

### `_body_set_state_sync_callback(body: RID, callable: Callable) -> void`
- 限定：qualifiers=virtual required

### `_body_set_user_flags(body: RID, flags: int) -> void`
- 限定：qualifiers=virtual required

### `_body_test_motion(body: RID, from: Transform3D, motion: Vector3, margin: float, max_collisions: int, collide_separation_ray: bool, recovery_as_collision: bool, r_result: PhysicsServer3DExtensionMotionResult*) -> bool`
- 限定：qualifiers=virtual required const

### `_box_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_capsule_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_concave_polygon_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_cone_twist_joint_get_param(joint: RID, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_cone_twist_joint_set_param(joint: RID, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_convex_polygon_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_custom_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_cylinder_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_end_sync() -> void`
- 限定：qualifiers=virtual required

### `_finish() -> void`
- 限定：qualifiers=virtual required

### `_flush_queries() -> void`
- 限定：qualifiers=virtual required

### `_free_rid(rid: RID) -> void`
- 限定：qualifiers=virtual required

### `_generic_6dof_joint_get_flag(joint: RID, axis: int, flag: int) -> bool`
- 限定：qualifiers=virtual required const

### `_generic_6dof_joint_get_param(joint: RID, axis: int, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_generic_6dof_joint_set_flag(joint: RID, axis: int, flag: int, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_generic_6dof_joint_set_param(joint: RID, axis: int, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_get_process_info(process_info: int) -> int`
- 限定：qualifiers=virtual required

### `_heightmap_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_hinge_joint_get_flag(joint: RID, flag: int) -> bool`
- 限定：qualifiers=virtual required const

### `_hinge_joint_get_param(joint: RID, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_hinge_joint_set_flag(joint: RID, flag: int, enabled: bool) -> void`
- 限定：qualifiers=virtual required

### `_hinge_joint_set_param(joint: RID, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_init() -> void`
- 限定：qualifiers=virtual required

### `_is_flushing_queries() -> bool`
- 限定：qualifiers=virtual required const

### `_joint_clear(joint: RID) -> void`
- 限定：qualifiers=virtual required

### `_joint_create() -> RID`
- 限定：qualifiers=virtual required

### `_joint_disable_collisions_between_bodies(joint: RID, disable: bool) -> void`
- 限定：qualifiers=virtual required

### `_joint_get_solver_priority(joint: RID) -> int`
- 限定：qualifiers=virtual required const

### `_joint_get_type(joint: RID) -> int`
- 限定：qualifiers=virtual required const

### `_joint_is_disabled_collisions_between_bodies(joint: RID) -> bool`
- 限定：qualifiers=virtual required const

### `_joint_make_cone_twist(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_joint_make_generic_6dof(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_joint_make_hinge(joint: RID, body_A: RID, hinge_A: Transform3D, body_B: RID, hinge_B: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_joint_make_hinge_simple(joint: RID, body_A: RID, pivot_A: Vector3, axis_A: Vector3, body_B: RID, pivot_B: Vector3, axis_B: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_joint_make_pin(joint: RID, body_A: RID, local_A: Vector3, body_B: RID, local_B: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_joint_make_slider(joint: RID, body_A: RID, local_ref_A: Transform3D, body_B: RID, local_ref_B: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_joint_set_solver_priority(joint: RID, priority: int) -> void`
- 限定：qualifiers=virtual required

### `_pin_joint_get_local_a(joint: RID) -> Vector3`
- 限定：qualifiers=virtual required const

### `_pin_joint_get_local_b(joint: RID) -> Vector3`
- 限定：qualifiers=virtual required const

### `_pin_joint_get_param(joint: RID, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_pin_joint_set_local_a(joint: RID, local_A: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_pin_joint_set_local_b(joint: RID, local_B: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_pin_joint_set_param(joint: RID, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_separation_ray_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_set_active(active: bool) -> void`
- 限定：qualifiers=virtual required

### `_shape_get_custom_solver_bias(shape: RID) -> float`
- 限定：qualifiers=virtual required const

### `_shape_get_data(shape: RID) -> Variant`
- 限定：qualifiers=virtual required const

### `_shape_get_margin(shape: RID) -> float`
- 限定：qualifiers=virtual required const

### `_shape_get_type(shape: RID) -> int`
- 限定：qualifiers=virtual required const

### `_shape_set_custom_solver_bias(shape: RID, bias: float) -> void`
- 限定：qualifiers=virtual required

### `_shape_set_data(shape: RID, data: Variant) -> void`
- 限定：qualifiers=virtual required

### `_shape_set_margin(shape: RID, margin: float) -> void`
- 限定：qualifiers=virtual required

### `_slider_joint_get_param(joint: RID, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_slider_joint_set_param(joint: RID, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_add_collision_exception(body: RID, body_b: RID) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_apply_central_force(body: RID, force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_apply_central_impulse(body: RID, impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_apply_point_force(body: RID, point_index: int, force: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_apply_point_impulse(body: RID, point_index: int, impulse: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_create() -> RID`
- 限定：qualifiers=virtual required

### `_soft_body_get_bounds(body: RID) -> AABB`
- 限定：qualifiers=virtual required const

### `_soft_body_get_collision_exceptions(body: RID) -> RID[]`
- 限定：qualifiers=virtual required const

### `_soft_body_get_collision_layer(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_soft_body_get_collision_mask(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_soft_body_get_damping_coefficient(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_get_drag_coefficient(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_get_linear_stiffness(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_get_point_global_position(body: RID, point_index: int) -> Vector3`
- 限定：qualifiers=virtual required const

### `_soft_body_get_pressure_coefficient(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_get_shrinking_factor(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_get_simulation_precision(body: RID) -> int`
- 限定：qualifiers=virtual required const

### `_soft_body_get_space(body: RID) -> RID`
- 限定：qualifiers=virtual required const

### `_soft_body_get_state(body: RID, state: int) -> Variant`
- 限定：qualifiers=virtual required const

### `_soft_body_get_total_mass(body: RID) -> float`
- 限定：qualifiers=virtual required const

### `_soft_body_is_point_pinned(body: RID, point_index: int) -> bool`
- 限定：qualifiers=virtual required const

### `_soft_body_move_point(body: RID, point_index: int, global_position: Vector3) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_pin_point(body: RID, point_index: int, pin: bool) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_remove_all_pinned_points(body: RID) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_remove_collision_exception(body: RID, body_b: RID) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_collision_layer(body: RID, layer: int) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_collision_mask(body: RID, mask: int) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_damping_coefficient(body: RID, damping_coefficient: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_drag_coefficient(body: RID, drag_coefficient: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_linear_stiffness(body: RID, linear_stiffness: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_mesh(body: RID, mesh: RID) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_pressure_coefficient(body: RID, pressure_coefficient: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_ray_pickable(body: RID, enable: bool) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_shrinking_factor(body: RID, shrinking_factor: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_simulation_precision(body: RID, simulation_precision: int) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_space(body: RID, space: RID) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_state(body: RID, state: int, variant: Variant) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_total_mass(body: RID, total_mass: float) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_set_transform(body: RID, transform: Transform3D) -> void`
- 限定：qualifiers=virtual required

### `_soft_body_update_rendering_server(body: RID, rendering_server_handler: PhysicsServer3DRenderingServerHandler) -> void`
- 限定：qualifiers=virtual required

### `_space_create() -> RID`
- 限定：qualifiers=virtual required

### `_space_get_contact_count(space: RID) -> int`
- 限定：qualifiers=virtual required const

### `_space_get_contacts(space: RID) -> PackedVector3Array`
- 限定：qualifiers=virtual required const

### `_space_get_direct_state(space: RID) -> PhysicsDirectSpaceState3D`
- 限定：qualifiers=virtual required

### `_space_get_param(space: RID, param: int) -> float`
- 限定：qualifiers=virtual required const

### `_space_is_active(space: RID) -> bool`
- 限定：qualifiers=virtual required const

### `_space_set_active(space: RID, active: bool) -> void`
- 限定：qualifiers=virtual required

### `_space_set_debug_contacts(space: RID, max_contacts: int) -> void`
- 限定：qualifiers=virtual required

### `_space_set_param(space: RID, param: int, value: float) -> void`
- 限定：qualifiers=virtual required

### `_sphere_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `_step(step: float) -> void`
- 限定：qualifiers=virtual required

### `_sync() -> void`
- 限定：qualifiers=virtual required

### `_world_boundary_shape_create() -> RID`
- 限定：qualifiers=virtual required

### `body_test_motion_is_excluding_body(body: RID) -> bool`
- 限定：qualifiers=const

### `body_test_motion_is_excluding_object(object: int) -> bool`
- 限定：qualifiers=const

