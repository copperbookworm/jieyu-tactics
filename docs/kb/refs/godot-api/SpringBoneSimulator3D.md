# SpringBoneSimulator3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpringBoneSimulator3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SpringBoneSimulator3D.md`

**摘要**：A `SkeletonModifier3D` to apply inertial wavering to bone chains.

## 描述

This `SkeletonModifier3D` can be used to wiggle hair, cloth, and tails. This modifier behaves differently from `PhysicalBoneSimulator3D` as it attempts to return the original pose after modification.
		If you setup `set_root_bone` and `set_end_bone`, it is treated as one bone chain. Note that it does not support a branched chain like Y-shaped chains.
		When a bone chain is created, an array is generated from the bones that exist in between and listed in the joint list.
		Several properties can be applied to each joint, such as `set_joint_stiffness`, `set_joint_drag`, and `set_joint_gravity`.
		For simplicity, you can set values to all joints at the same time by using a `Curve`. If you want to specify detailed values individually, set `set_individual_config` to `true`.
		For physical simulation, `SpringBoneSimulator3D` can have children as self-standing collisions that are not related to `PhysicsServer3D`, see also `SpringBoneCollision3D`.
		**Warning:** A scaled `SpringBoneSimulator3D` will likely not behave as expected. Make sure that the parent `Skeleton3D` and its bones are not scaled.
		**Note:** Most methods in this class take an `index` parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. `settings/<index>/root_bone_name`).

## 属性

- **`external_force`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_external_force · setter=set_external_force
- **`mutable_bone_axes`** `bool` = `true`
  - 其它属性：getter=are_bone_axes_mutable · setter=set_mutable_bone_axes
- **`setting_count`** `int` = `0`
  - 其它属性：getter=get_setting_count · setter=set_setting_count

## 方法

### `are_all_child_collisions_enabled(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if all child `SpringBoneCollision3D`s are contained in the collision list at `index` in the settings.

### `clear_collisions(index: int) -> void`

Clears all collisions from the collision list at `index` in the settings when `are_all_child_collisions_enabled` is `false`.

### `clear_exclude_collisions(index: int) -> void`

Clears all exclude collisions from the collision list at `index` in the settings when `are_all_child_collisions_enabled` is `true`.

### `clear_settings() -> void`

Clears all settings.

### `get_center_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the center bone index of the bone chain.

### `get_center_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the center bone name of the bone chain.

### `get_center_from(index: int) -> int`
- 限定：qualifiers=const

Returns what the center originates from in the bone chain.

### `get_center_node(index: int) -> NodePath`
- 限定：qualifiers=const

Returns the center node path of the bone chain.

### `get_collision_count(index: int) -> int`
- 限定：qualifiers=const

Returns the collision count of the bone chain's collision list when `are_all_child_collisions_enabled` is `false`.

### `get_collision_path(index: int, collision: int) -> NodePath`
- 限定：qualifiers=const

Returns the node path of the `SpringBoneCollision3D` at `collision` in the bone chain's collision list when `are_all_child_collisions_enabled` is `false`.

### `get_drag(index: int) -> float`
- 限定：qualifiers=const

Returns the drag force damping curve of the bone chain.

### `get_drag_damping_curve(index: int) -> Curve`
- 限定：qualifiers=const

Returns the drag force damping curve of the bone chain.

### `get_end_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the end bone index of the bone chain.

### `get_end_bone_direction(index: int) -> int`
- 限定：qualifiers=const

Returns the tail direction of the end bone of the bone chain when `is_end_bone_extended` is `true`.

### `get_end_bone_length(index: int) -> float`
- 限定：qualifiers=const

Returns the end bone tail length of the bone chain when `is_end_bone_extended` is `true`.

### `get_end_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the end bone name of the bone chain.

### `get_exclude_collision_count(index: int) -> int`
- 限定：qualifiers=const

Returns the exclude collision count of the bone chain's exclude collision list when `are_all_child_collisions_enabled` is `true`.

### `get_exclude_collision_path(index: int, collision: int) -> NodePath`
- 限定：qualifiers=const

Returns the node path of the `SpringBoneCollision3D` at `collision` in the bone chain's exclude collision list when `are_all_child_collisions_enabled` is `true`.

### `get_gravity(index: int) -> float`
- 限定：qualifiers=const

Returns the gravity amount of the bone chain.

### `get_gravity_damping_curve(index: int) -> Curve`
- 限定：qualifiers=const

Returns the gravity amount damping curve of the bone chain.

### `get_gravity_direction(index: int) -> Vector3`
- 限定：qualifiers=const

Returns the gravity direction of the bone chain.

### `get_joint_bone(index: int, joint: int) -> int`
- 限定：qualifiers=const

Returns the bone index at `joint` in the bone chain's joint list.

### `get_joint_bone_name(index: int, joint: int) -> String`
- 限定：qualifiers=const

Returns the bone name at `joint` in the bone chain's joint list.

### `get_joint_count(index: int) -> int`
- 限定：qualifiers=const

Returns the joint count of the bone chain's joint list.

### `get_joint_drag(index: int, joint: int) -> float`
- 限定：qualifiers=const

Returns the drag force at `joint` in the bone chain's joint list.

### `get_joint_gravity(index: int, joint: int) -> float`
- 限定：qualifiers=const

Returns the gravity amount at `joint` in the bone chain's joint list.

### `get_joint_gravity_direction(index: int, joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the gravity direction at `joint` in the bone chain's joint list.

### `get_joint_radius(index: int, joint: int) -> float`
- 限定：qualifiers=const

Returns the radius at `joint` in the bone chain's joint list.

### `get_joint_rotation_axis(index: int, joint: int) -> int`
- 限定：qualifiers=const

Returns the rotation axis at `joint` in the bone chain's joint list.

### `get_joint_rotation_axis_vector(index: int, joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the rotation axis vector for the specified joint in the bone chain. This vector represents the axis around which the joint can rotate. It is determined based on the rotation axis set for the joint.
				If `get_joint_rotation_axis` is `SkeletonModifier3D.ROTATION_AXIS_ALL`, this method returns `Vector3(0, 0, 0)`.

### `get_joint_stiffness(index: int, joint: int) -> float`
- 限定：qualifiers=const

Returns the stiffness force at `joint` in the bone chain's joint list.

### `get_radius(index: int) -> float`
- 限定：qualifiers=const

Returns the joint radius of the bone chain.

### `get_radius_damping_curve(index: int) -> Curve`
- 限定：qualifiers=const

Returns the joint radius damping curve of the bone chain.

### `get_root_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the root bone index of the bone chain.

### `get_root_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the root bone name of the bone chain.

### `get_rotation_axis(index: int) -> int`
- 限定：qualifiers=const

Returns the rotation axis of the bone chain.

### `get_rotation_axis_vector(index: int) -> Vector3`
- 限定：qualifiers=const

Returns the rotation axis vector of the bone chain. This vector represents the axis around which the bone chain can rotate. It is determined based on the rotation axis set for the bone chain.
				If `get_rotation_axis` is `SkeletonModifier3D.ROTATION_AXIS_ALL`, this method returns `Vector3(0, 0, 0)`.

### `get_stiffness(index: int) -> float`
- 限定：qualifiers=const

Returns the stiffness force of the bone chain.

### `get_stiffness_damping_curve(index: int) -> Curve`
- 限定：qualifiers=const

Returns the stiffness force damping curve of the bone chain.

### `is_config_individual(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the config can be edited individually for each joint.

### `is_end_bone_extended(index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the end bone is extended to have a tail.

### `reset() -> void`

Resets a simulating state with respect to the current bone pose.
				It is useful to prevent the simulation result getting violent. For example, calling this immediately after a call to `AnimationPlayer.play` without a fading, or within the previous `SkeletonModifier3D.modification_processed` signal if it's condition changes significantly.

### `set_center_bone(index: int, bone: int) -> void`

Sets the center bone index of the bone chain.

### `set_center_bone_name(index: int, bone_name: String) -> void`

Sets the center bone name of the bone chain.

### `set_center_from(index: int, center_from: int) -> void`

Sets what the center originates from in the bone chain.
				Bone movement is calculated based on the difference in relative distance between center and bone in the previous and next frames.
				For example, if the parent `Skeleton3D` is used as the center, the bones are considered to have not moved if the `Skeleton3D` moves in the world.
				In this case, only a change in the bone pose is considered to be a bone movement.

### `set_center_node(index: int, node_path: NodePath) -> void`

Sets the center node path of the bone chain.

### `set_collision_count(index: int, count: int) -> void`

Sets the number of collisions in the collision list at `index` in the settings when `are_all_child_collisions_enabled` is `false`.

### `set_collision_path(index: int, collision: int, node_path: NodePath) -> void`

Sets the node path of the `SpringBoneCollision3D` at `collision` in the bone chain's collision list when `are_all_child_collisions_enabled` is `false`.

### `set_drag(index: int, drag: float) -> void`

Sets the drag force of the bone chain. The greater the value, the more suppressed the wiggling.
				The value is scaled by `set_drag_damping_curve` and cached in each joint setting in the joint list.

### `set_drag_damping_curve(index: int, curve: Curve) -> void`

Sets the drag force damping curve of the bone chain.

### `set_enable_all_child_collisions(index: int, enabled: bool) -> void`

If `enabled` is `true`, all child `SpringBoneCollision3D`s are colliding and `set_exclude_collision_path` is enabled as an exclusion list at `index` in the settings.
				If `enabled` is `false`, you need to manually register all valid collisions with `set_collision_path`.

### `set_end_bone(index: int, bone: int) -> void`

Sets the end bone index of the bone chain.

### `set_end_bone_direction(index: int, bone_direction: int) -> void`

Sets the end bone tail direction of the bone chain when `is_end_bone_extended` is `true`.

### `set_end_bone_length(index: int, length: float) -> void`

Sets the end bone tail length of the bone chain when `is_end_bone_extended` is `true`.

### `set_end_bone_name(index: int, bone_name: String) -> void`

Sets the end bone name of the bone chain.
				**Note:** End bone must be the root bone or a child of the root bone. If they are the same, the tail must be extended by `set_extend_end_bone` to jiggle the bone.

### `set_exclude_collision_count(index: int, count: int) -> void`

Sets the number of exclude collisions in the exclude collision list at `index` in the settings when `are_all_child_collisions_enabled` is `true`.

### `set_exclude_collision_path(index: int, collision: int, node_path: NodePath) -> void`

Sets the node path of the `SpringBoneCollision3D` at `collision` in the bone chain's exclude collision list when `are_all_child_collisions_enabled` is `true`.

### `set_extend_end_bone(index: int, enabled: bool) -> void`

If `enabled` is `true`, the end bone is extended to have a tail.
				The extended tail config is allocated to the last element in the joint list. In other words, if you set `enabled` to `false`, the config of the last element in the joint list has no effect in the simulated result.

### `set_gravity(index: int, gravity: float) -> void`

Sets the gravity amount of the bone chain. This value is not an acceleration, but a constant velocity of movement in `set_gravity_direction`.
				If `gravity` is not `0`, the modified pose will not return to the original pose since it is always affected by gravity.
				The value is scaled by `set_gravity_damping_curve` and cached in each joint setting in the joint list.

### `set_gravity_damping_curve(index: int, curve: Curve) -> void`

Sets the gravity amount damping curve of the bone chain.

### `set_gravity_direction(index: int, gravity_direction: Vector3) -> void`

Sets the gravity direction of the bone chain. This value is internally normalized and then multiplied by `set_gravity`.
				The value is cached in each joint setting in the joint list.

### `set_individual_config(index: int, enabled: bool) -> void`

If `enabled` is `true`, the config can be edited individually for each joint.

### `set_joint_drag(index: int, joint: int, drag: float) -> void`

Sets the drag force at `joint` in the bone chain's joint list when `is_config_individual` is `true`.

### `set_joint_gravity(index: int, joint: int, gravity: float) -> void`

Sets the gravity amount at `joint` in the bone chain's joint list when `is_config_individual` is `true`.

### `set_joint_gravity_direction(index: int, joint: int, gravity_direction: Vector3) -> void`

Sets the gravity direction at `joint` in the bone chain's joint list when `is_config_individual` is `true`.

### `set_joint_radius(index: int, joint: int, radius: float) -> void`

Sets the joint radius at `joint` in the bone chain's joint list when `is_config_individual` is `true`.

### `set_joint_rotation_axis(index: int, joint: int, axis: int) -> void`

Sets the rotation axis at `joint` in the bone chain's joint list when `is_config_individual` is `true`.
				The axes are based on the reference pose's space, if `axis` is `SkeletonModifier3D.ROTATION_AXIS_CUSTOM`, you can specify any axis.
				In here, the reference pose is the bone pose immediately before the simulation.
				**Note:** The rotation axis and the forward vector shouldn't be colinear to avoid unintended rotation since `SpringBoneSimulator3D` does not factor in twisting forces.

### `set_joint_rotation_axis_vector(index: int, joint: int, vector: Vector3) -> void`

Sets the rotation axis vector for the specified joint in the bone chain.
				This vector is normalized by an internal process and represents the axis around which the bone chain can rotate.
				If the vector length is `0`, it is considered synonymous with `SkeletonModifier3D.ROTATION_AXIS_ALL`.

### `set_joint_stiffness(index: int, joint: int, stiffness: float) -> void`

Sets the stiffness force at `joint` in the bone chain's joint list when `is_config_individual` is `true`.

### `set_radius(index: int, radius: float) -> void`

Sets the joint radius of the bone chain. It is used to move and slide with the `SpringBoneCollision3D` in the collision list.
				The value is scaled by `set_radius_damping_curve` and cached in each joint setting in the joint list.

### `set_radius_damping_curve(index: int, curve: Curve) -> void`

Sets the joint radius damping curve of the bone chain.

### `set_root_bone(index: int, bone: int) -> void`

Sets the root bone index of the bone chain.

### `set_root_bone_name(index: int, bone_name: String) -> void`

Sets the root bone name of the bone chain.

### `set_rotation_axis(index: int, axis: int) -> void`

Sets the rotation axis of the bone chain. If set to a specific axis, it acts like a hinge joint. The value is cached in each joint setting in the joint list.
				The axes are based on the reference pose's space, if `axis` is `SkeletonModifier3D.ROTATION_AXIS_CUSTOM`, you can specify any axis.
				In here, the reference pose is the bone pose immediately before the simulation.
				**Note:** The rotation axis vector and the forward vector shouldn't be colinear to avoid unintended rotation since `SpringBoneSimulator3D` does not factor in twisting forces.

### `set_rotation_axis_vector(index: int, vector: Vector3) -> void`

Sets the rotation axis vector of the bone chain. The value is cached in each joint setting in the joint list.
				This vector is normalized by an internal process and represents the axis around which the bone chain can rotate.
				If the vector length is `0`, it is considered synonymous with `SkeletonModifier3D.ROTATION_AXIS_ALL`.

### `set_stiffness(index: int, stiffness: float) -> void`

Sets the stiffness force of the bone chain. The greater the value, the faster it recovers to its initial pose.
				If `stiffness` is `0`, the modified pose will not return to the original pose.
				The value is scaled by `set_stiffness_damping_curve` and cached in each joint setting in the joint list.

### `set_stiffness_damping_curve(index: int, curve: Curve) -> void`

Sets the stiffness force damping curve of the bone chain.

## 枚举

### `CenterFrom`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CENTER_FROM_WORLD_ORIGIN` |  |
| `1` | `CENTER_FROM_NODE` |  |
| `2` | `CENTER_FROM_BONE` |  |

