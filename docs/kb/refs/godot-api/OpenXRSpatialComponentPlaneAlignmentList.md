# OpenXRSpatialComponentPlaneAlignmentList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentPlaneAlignmentList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentPlaneAlignmentList.md`

**摘要**：Object for storing the queries plane alignment result data.

## 描述

Object for storing the queries plane alignment result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_plane_alignment(index: int) -> int`
- 限定：qualifiers=const

Returns the plane alignment for the parent entity at this `index`.

## 枚举

### `PlaneAlignment`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PLANE_ALIGNMENT_HORIZONTAL_UPWARD` |  |
| `1` | `PLANE_ALIGNMENT_HORIZONTAL_DOWNWARD` |  |
| `2` | `PLANE_ALIGNMENT_VERTICAL` |  |
| `3` | `PLANE_ALIGNMENT_ARBITRARY` |  |

