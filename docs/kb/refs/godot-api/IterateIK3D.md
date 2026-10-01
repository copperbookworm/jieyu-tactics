# IterateIK3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`IterateIK3D` → `ChainIK3D` → `IKModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/IterateIK3D.md`

**摘要**：A `SkeletonModifier3D` to approach the goal by repeating small rotations.

## 描述

Base class of `SkeletonModifier3D` to approach the goal by repeating small rotations.
		Each bone chain (setting) has one effector, which is processed in order of the setting list. You can set some limitations for each joint.
		**Note:** All the methods in this class take an `index` parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. `settings/<index>/target_node`).

## 属性

- **`angular_delta_limit`** `float` = `0.034906585`
  - 其它属性：getter=get_angular_delta_limit · setter=set_angular_delta_limit
- **`deterministic`** `bool` = `false`
  - 其它属性：getter=is_deterministic · setter=set_deterministic
- **`max_iterations`** `int` = `4`
  - 其它属性：getter=get_max_iterations · setter=set_max_iterations
- **`min_distance`** `float` = `0.001`
  - 其它属性：getter=get_min_distance · setter=set_min_distance
- **`setting_count`** `int` = `0`
  - 其它属性：getter=get_setting_count · setter=set_setting_count

## 方法

### `get_joint_limitation(index: int, joint: int) -> JointLimitation3D`
- 限定：qualifiers=const

Returns the joint limitation at `joint` in the bone chain's joint list.

### `get_joint_limitation_right_axis(index: int, joint: int) -> int`
- 限定：qualifiers=const

Returns the joint limitation right axis at `joint` in the bone chain's joint list.

### `get_joint_limitation_right_axis_vector(index: int, joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the joint limitation right axis vector at `joint` in the bone chain's joint list.
				If `get_joint_limitation_right_axis` is `SkeletonModifier3D.SECONDARY_DIRECTION_NONE`, this method returns `Vector3(0, 0, 0)`.

### `get_joint_limitation_rotation_offset(index: int, joint: int) -> Quaternion`
- 限定：qualifiers=const

Returns the joint limitation rotation offset at `joint` in the bone chain's joint list.
				Rotation is done in the local space which is constructed by the bone direction (in general parent to child) as the +Y axis and `get_joint_limitation_right_axis_vector` as the +X axis.
				If the +X and +Y axes are not orthogonal, the +X axis is implicitly modified to make it orthogonal.
				Also, if the length of `get_joint_limitation_right_axis_vector` is zero, the space is created by rotating the reference pose using the shortest arc that rotates the +Y axis of the reference pose to match the bone direction.
				In here, the reference pose is the bone pose immediately before processing IK.

### `get_joint_rotation_axis(index: int, joint: int) -> int`
- 限定：qualifiers=const

Returns the rotation axis at `joint` in the bone chain's joint list.

### `get_joint_rotation_axis_vector(index: int, joint: int) -> Vector3`
- 限定：qualifiers=const

Returns the rotation axis vector for the specified joint in the bone chain. This vector represents the axis around which the joint can rotate. It is determined based on the rotation axis set for the joint.
				If `get_joint_rotation_axis` is `SkeletonModifier3D.ROTATION_AXIS_ALL`, this method returns `Vector3(0, 0, 0)`.

### `get_target_node(index: int) -> NodePath`
- 限定：qualifiers=const

Returns the target node that the end bone is trying to reach.

### `set_joint_limitation(index: int, joint: int, limitation: JointLimitation3D) -> void`

Sets the joint limitation at `joint` in the bone chain's joint list.

### `set_joint_limitation_right_axis(index: int, joint: int, direction: int) -> void`

Sets the joint limitation right axis at `joint` in the bone chain's joint list.

### `set_joint_limitation_right_axis_vector(index: int, joint: int, vector: Vector3) -> void`

Sets the optional joint limitation right axis vector at `joint` in the bone chain's joint list.

### `set_joint_limitation_rotation_offset(index: int, joint: int, offset: Quaternion) -> void`

Sets the joint limitation rotation offset at `joint` in the bone chain's joint list.
				Rotation is done in the local space which is constructed by the bone direction (in general parent to child) as the +Y axis and `get_joint_limitation_right_axis_vector` as the +X axis.
				If the +X and +Y axes are not orthogonal, the +X axis is implicitly modified to make it orthogonal.
				Also, if the length of `get_joint_limitation_right_axis_vector` is zero, the space is created by rotating the reference pose using the shortest arc that rotates the +Y axis of the reference pose to match the bone direction.
				In here, the reference pose is the bone pose immediately before processing IK.

### `set_joint_rotation_axis(index: int, joint: int, axis: int) -> void`

Sets the rotation axis at `joint` in the bone chain's joint list.
				The axes are based on the reference pose's space, if `axis` is `SkeletonModifier3D.ROTATION_AXIS_CUSTOM`, you can specify any axis.
				In here, the reference pose is the bone pose immediately before processing IK.
				**Note:** The rotation axis and the forward vector shouldn't be colinear to avoid unintended rotation since `ChainIK3D` does not factor in twisting forces.

### `set_joint_rotation_axis_vector(index: int, joint: int, axis_vector: Vector3) -> void`

Sets the rotation axis vector for the specified joint in the bone chain.
				This vector is normalized by an internal process and represents the axis around which the bone chain can rotate.
				If the vector length is `0`, it is considered synonymous with `SkeletonModifier3D.ROTATION_AXIS_ALL`.

### `set_target_node(index: int, target_node: NodePath) -> void`

Sets the target node that the end bone is trying to reach.

