# OpenXRSpatialComponentMesh2DList

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialComponentMesh2DList` → `OpenXRSpatialComponentData` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialComponentMesh2DList.md`

**摘要**：Object for storing the queries mesh2d result data.

## 描述

Object for storing the queries 2D mesh result data when calling `OpenXRSpatialEntityExtension.query_snapshot`.

## 方法

### `get_indices(snapshot: RID, index: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns the mesh indices for the entity at this `index`.

### `get_transform(index: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform for positioning our mesh for the entity at this `index`.

### `get_vertices(snapshot: RID, index: int) -> PackedVector2Array`
- 限定：qualifiers=const

Returns the mesh vertices for the entity at this `index`.

