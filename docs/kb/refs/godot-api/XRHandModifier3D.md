# XRHandModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRHandModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRHandModifier3D.md`

**摘要**：A node for driving hand meshes from `XRHandTracker` data.

## 描述

This node uses hand tracking data from an `XRHandTracker` to pose the skeleton of a hand mesh.
		Positioning of hands is performed by creating an `XRNode3D` ancestor of the hand mesh driven by the same `XRHandTracker`.
		The hand tracking position-data is scaled by `Skeleton3D.motion_scale` when applied to the skeleton, which can be used to adjust the tracked hand to match the scale of the hand model.

## 属性

- **`bone_update`** `int` = `0` · 枚举 `XRHandModifier3D.BoneUpdate`
  - 其它属性：getter=get_bone_update · setter=set_bone_update
- **`hand_tracker`** `StringName` = `&"/user/hand_tracker/left"`
  - 其它属性：getter=get_hand_tracker · setter=set_hand_tracker

## 枚举

### `BoneUpdate`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BONE_UPDATE_FULL` |  |
| `1` | `BONE_UPDATE_ROTATION_ONLY` |  |
| `2` | `BONE_UPDATE_MAX` |  |

## 教程链接

- [XR documentation index](None)

