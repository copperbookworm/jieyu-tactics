# SkeletonIK3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonIK3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · deprecated=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonIK3D.md`

**摘要**：A node used to rotate all bones of a `Skeleton3D` bone chain a way that places the end bone at a desired 3D position.

## 描述

SkeletonIK3D is used to rotate all bones of a `Skeleton3D` bone chain a way that places the end bone at a desired 3D position. A typical scenario for IK in games is to place a character's feet on the ground or a character's hands on a currently held object. SkeletonIK uses FabrikInverseKinematic internally to solve the bone chain and applies the results to the `Skeleton3D` `bones_global_pose_override` property for all affected bones in the chain. If fully applied, this overwrites any bone transform from `Animation`s or bone custom poses set by users. The applied amount can be controlled with the `SkeletonModifier3D.influence` property.
		
```gdscript
		# Apply IK effect automatically on every new frame (not the current)
		skeleton_ik_node.start()

		# Apply IK effect only on the current frame
		skeleton_ik_node.start(true)

		# Stop IK effect and reset bones_global_pose_override on Skeleton
		skeleton_ik_node.stop()

		# Apply full IK effect
		skeleton_ik_node.set_influence(1.0)

		# Apply half IK effect
		skeleton_ik_node.set_influence(0.5)

		# Apply zero IK effect (a value at or below 0.01 also removes bones_global_pose_override on Skeleton)
		skeleton_ik_node.set_influence(0.0)
		
```

## 属性

- **`interpolation`** `float`
  - 其它属性：deprecated=Use [member SkeletonModifier3D.influence] instead. · getter=get_interpolation · setter=set_interpolation
- **`magnet`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_magnet_position · setter=set_magnet_position
- **`max_iterations`** `int` = `10`
  - 其它属性：getter=get_max_iterations · setter=set_max_iterations
- **`min_distance`** `float` = `0.01`
  - 其它属性：getter=get_min_distance · setter=set_min_distance
- **`override_tip_basis`** `bool` = `true`
  - 其它属性：getter=is_override_tip_basis · setter=set_override_tip_basis
- **`root_bone`** `StringName` = `&""`
  - 其它属性：getter=get_root_bone · setter=set_root_bone
- **`target`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_target_transform · setter=set_target_transform
- **`target_node`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target_node · setter=set_target_node
- **`tip_bone`** `StringName` = `&""`
  - 其它属性：getter=get_tip_bone · setter=set_tip_bone
- **`use_magnet`** `bool` = `false`
  - 其它属性：getter=is_using_magnet · setter=set_use_magnet

## 方法

### `get_parent_skeleton() -> Skeleton3D`
- 限定：qualifiers=const

Returns the parent `Skeleton3D` node that was present when SkeletonIK entered the scene tree. Returns `null` if the parent node was not a `Skeleton3D` node when SkeletonIK3D entered the scene tree.

### `is_running() -> bool`

Returns `true` if SkeletonIK is applying IK effects on continues frames to the `Skeleton3D` bones. Returns `false` if SkeletonIK is stopped or `start` was used with the `one_time` parameter set to `true`.

### `start(one_time: bool = false) -> void`

Starts applying IK effects on each frame to the `Skeleton3D` bones but will only take effect starting on the next frame. If `one_time` is `true`, this will take effect immediately but also reset on the next frame.

### `stop() -> void`

Stops applying IK effects on each frame to the `Skeleton3D` bones and also calls `Skeleton3D.clear_bones_global_pose_override` to remove existing overrides on all bones.

