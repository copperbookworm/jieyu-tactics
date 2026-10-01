# OpenXRSpatialComponentBounded2DList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentBounded2DList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentBounded2DList.md`

**摘要**：Object for storing the queries bounded2d result data.

## 描述

Object for storing the queries 2D bounding rectangle result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_center_pose(index: int) -> Transform3D`
- 限定：qualifiers=const

Returns the center of our bounding rectangle for the entity at this `index`.

### `get_size(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the size of our bounding rectangle for the entity at this `index`.

