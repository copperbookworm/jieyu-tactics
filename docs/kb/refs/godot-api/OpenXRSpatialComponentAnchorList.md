# OpenXRSpatialComponentAnchorList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentAnchorList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentAnchorList.md`

**摘要**：Object for storing the queries anchor result data.

## 描述

Object for storing the queries anchor result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_entity_pose(index: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform for the entity at this `index`.

