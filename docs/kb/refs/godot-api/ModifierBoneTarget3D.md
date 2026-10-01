# ModifierBoneTarget3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ModifierBoneTarget3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ModifierBoneTarget3D.md`

**摘要**：А node that dynamically copies the 3D transform of a bone in its parent `Skeleton3D`.

## 描述

This node selects a bone in a `Skeleton3D` and attaches to it. This means that the `ModifierBoneTarget3D` node will dynamically copy the 3D transform of the selected bone.
		The functionality is similar to `BoneAttachment3D`, but this node adopts the `SkeletonModifier3D` cycle and is intended to be used as another `SkeletonModifier3D`'s target.

## 属性

- **`bone`** `int` = `-1`
  - 其它属性：getter=get_bone · setter=set_bone
- **`bone_name`** `String` = `""`
  - 其它属性：getter=get_bone_name · setter=set_bone_name

