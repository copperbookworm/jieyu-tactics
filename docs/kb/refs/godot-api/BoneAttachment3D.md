# BoneAttachment3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoneAttachment3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=tag
> 自动生成，勿手改。文件：`refs/godot-api/BoneAttachment3D.md`

**摘要**：А node that dynamically copies or overrides the 3D transform of a bone in its parent `Skeleton3D`.

## 描述

This node selects a bone in a `Skeleton3D` and attaches to it. This means that the `BoneAttachment3D` node will either dynamically copy or override the 3D transform of the selected bone.

## 属性

- **`bone_idx`** `int` = `-1`
  - 其它属性：getter=get_bone_idx · setter=set_bone_idx
- **`bone_name`** `String` = `""`
  - 其它属性：getter=get_bone_name · setter=set_bone_name
- **`external_skeleton`** `NodePath`
  - 其它属性：getter=get_external_skeleton · setter=set_external_skeleton
- **`override_pose`** `bool` = `false`
  - 其它属性：getter=get_override_pose · setter=set_override_pose
- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`use_external_skeleton`** `bool` = `false`
  - 其它属性：getter=get_use_external_skeleton · setter=set_use_external_skeleton

## 方法

### `get_skeleton() -> Skeleton3D`

Returns the parent or external `Skeleton3D` node if it exists, otherwise returns `null`.

### `on_skeleton_update() -> void`

A function that is called automatically when the `Skeleton3D` is updated. This function is where the `BoneAttachment3D` node updates its position so it is correctly bound when it is *not* set to override the bone pose.

