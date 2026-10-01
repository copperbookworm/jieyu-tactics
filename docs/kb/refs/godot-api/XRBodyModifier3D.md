# XRBodyModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRBodyModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/XRBodyModifier3D.md`

**摘要**：A node for driving body meshes from `XRBodyTracker` data.

## 描述

This node uses body tracking data from an `XRBodyTracker` to pose the skeleton of a body mesh.
		Positioning of the body is performed by creating an `XRNode3D` ancestor of the body mesh driven by the same `XRBodyTracker`.
		The body tracking position-data is scaled by `Skeleton3D.motion_scale` when applied to the skeleton, which can be used to adjust the tracked body to match the scale of the body model.

## 属性

- **`body_tracker`** `StringName` = `&"/user/body_tracker"`
  - 其它属性：getter=get_body_tracker · setter=set_body_tracker
- **`body_update`** `int` = `7` · 枚举 `XRBodyModifier3D.BodyUpdate` · 位标志
  - 其它属性：getter=get_body_update · is_bitfield=true · setter=set_body_update
- **`bone_update`** `int` = `0` · 枚举 `XRBodyModifier3D.BoneUpdate`
  - 其它属性：getter=get_bone_update · setter=set_bone_update

## 枚举

### `BodyUpdate`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `BODY_UPDATE_UPPER_BODY` | （位标志） |
| `2` | `BODY_UPDATE_LOWER_BODY` | （位标志） |
| `4` | `BODY_UPDATE_HANDS` | （位标志） |

### `BoneUpdate`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BONE_UPDATE_FULL` |  |
| `1` | `BONE_UPDATE_ROTATION_ONLY` |  |
| `2` | `BONE_UPDATE_MAX` |  |

## 教程链接

- [XR documentation index](None)

