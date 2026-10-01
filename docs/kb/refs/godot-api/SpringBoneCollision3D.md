# SpringBoneCollision3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpringBoneCollision3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SpringBoneCollision3D.md`

**摘要**：A base class of the collision that interacts with `SpringBoneSimulator3D`.

## 描述

A collision can be a child of `SpringBoneSimulator3D`. If it is not a child of `SpringBoneSimulator3D`, it has no effect.
		The colliding and sliding are done in the `SpringBoneSimulator3D`'s modification process in order of its collision list which is set by `SpringBoneSimulator3D.set_collision_path`. If `SpringBoneSimulator3D.are_all_child_collisions_enabled` is `true`, the order matches `SceneTree`.
		If `bone` is set, it synchronizes with the bone pose of the ancestor `Skeleton3D`, which is done in before the `SpringBoneSimulator3D`'s modification process as the pre-process.
		**Warning:** A scaled `SpringBoneCollision3D` will likely not behave as expected. Make sure that the parent `Skeleton3D` and its bones are not scaled.

## 属性

- **`bone`** `int` = `-1`
  - 其它属性：getter=get_bone · setter=set_bone
- **`bone_name`** `String` = `""`
  - 其它属性：getter=get_bone_name · setter=set_bone_name
- **`position_offset`** `Vector3`
  - 其它属性：getter=get_position_offset · setter=set_position_offset
- **`rotation_offset`** `Quaternion`
  - 其它属性：getter=get_rotation_offset · setter=set_rotation_offset

## 方法

### `get_skeleton() -> Skeleton3D`
- 限定：qualifiers=const

Get parent `Skeleton3D` node of the parent `SpringBoneSimulator3D` if found.

