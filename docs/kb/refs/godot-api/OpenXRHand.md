# OpenXRHand

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRHand` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · deprecated=Use [XRHandModifier3D] instead.
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRHand.md`

**摘要**：Node supporting hand and finger tracking in OpenXR.

## 描述

This node enables OpenXR's hand tracking functionality. The node should be a child node of an `XROrigin3D` node, tracking will update its position to the player's tracked hand Palm joint location (the center of the middle finger's metacarpal bone). This node also updates the skeleton of a properly skinned hand or avatar model.
		If the skeleton is a hand (one of the hand bones is the root node of the skeleton), then the skeleton will be placed relative to the hand palm location and the hand mesh and skeleton should be children of the OpenXRHand node.
		If the hand bones are part of a full skeleton, then the root of the hand will keep its location with the assumption that IK is used to position the hand and arm.
		By default the skeleton hand bones are repositioned to match the size of the tracked hand. To preserve the modeled bone sizes change `bone_update` to apply rotation only.

## 属性

- **`bone_update`** `int` = `0` · 枚举 `OpenXRHand.BoneUpdate`
  - 其它属性：getter=get_bone_update · setter=set_bone_update
- **`hand`** `int` = `0` · 枚举 `OpenXRHand.Hands`
  - 其它属性：getter=get_hand · setter=set_hand
- **`hand_skeleton`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_hand_skeleton · setter=set_hand_skeleton
- **`motion_range`** `int` = `0` · 枚举 `OpenXRHand.MotionRange`
  - 其它属性：getter=get_motion_range · setter=set_motion_range
- **`skeleton_rig`** `int` = `0` · 枚举 `OpenXRHand.SkeletonRig`
  - 其它属性：getter=get_skeleton_rig · setter=set_skeleton_rig

## 枚举

### `Hands`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HAND_LEFT` |  |
| `1` | `HAND_RIGHT` |  |
| `2` | `HAND_MAX` |  |

### `MotionRange`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOTION_RANGE_UNOBSTRUCTED` |  |
| `1` | `MOTION_RANGE_CONFORM_TO_CONTROLLER` |  |
| `2` | `MOTION_RANGE_MAX` |  |

### `SkeletonRig`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SKELETON_RIG_OPENXR` |  |
| `1` | `SKELETON_RIG_HUMANOID` |  |
| `2` | `SKELETON_RIG_MAX` |  |

### `BoneUpdate`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BONE_UPDATE_FULL` |  |
| `1` | `BONE_UPDATE_ROTATION_ONLY` |  |
| `2` | `BONE_UPDATE_MAX` |  |

