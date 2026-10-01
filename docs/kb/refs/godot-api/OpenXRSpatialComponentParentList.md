# OpenXRSpatialComponentParentList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentParentList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentParentList.md`

**摘要**：Object for storing the queries parent result data.

## 描述

Object for storing the queries parent result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_parent(index: int) -> RID`
- 限定：qualifiers=const

Returns the RID for the parent entity at this `index`.

