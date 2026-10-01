# OpenXRPlaneTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRPlaneTracker` → `OpenXRSpatialEntityTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRPlaneTracker.md`

**摘要**：Spatial entity tracker for our spatial entity plane tracking extension.

## 描述

Spatial entity tracker for our OpenXR spatial entity plane tracking extension. These trackers identify entities in our real space such as walls, floors, tables, etc. and map their location to our virtual space.

## 属性

- **`bounds_size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_bounds_size · setter=set_bounds_size
- **`plane_alignment`** `int` = `0` · 枚举 `OpenXRSpatialComponentPlaneAlignmentList.PlaneAlignment`
  - 其它属性：getter=get_plane_alignment · setter=set_plane_alignment
- **`plane_label`** `String` = `""`
  - 其它属性：getter=get_plane_label · setter=set_plane_label

## 方法

### `clear_mesh_data() -> void`

Clears the mesh data for this tracker. You should only call this if you are handling your own discovery logic.

### `get_mesh() -> Mesh`

Gets a mesh created from either the mesh data or from our bounding size for this plane.

### `get_mesh_offset() -> Transform3D`
- 限定：qualifiers=const

Gets the transform by which to offset the mesh and collision shape from our pose to display these correctly.

### `get_shape(thickness: float = 0.01) -> Shape3D`

Gets a collision shape built either from the mesh data or from our bounding size for this plane.

### `set_mesh_data(origin: Transform3D, vertices: PackedVector2Array, indices: PackedInt32Array = PackedInt32Array()) -> void`

Sets the mesh data for this plane. You should only call this if you are handling your own discovery logic.

## 信号

### `mesh_changed()`

Emitted when our mesh data has changed the mesh instance and collision needs to be updated.

