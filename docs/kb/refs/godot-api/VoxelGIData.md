# VoxelGIData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VoxelGIData` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VoxelGIData.md`

**摘要**：Contains baked voxel global illumination data for use in a `VoxelGI` node.

## 描述

`VoxelGIData` contains baked voxel global illumination for use in a `VoxelGI` node. `VoxelGIData` also offers several properties to adjust the final appearance of the global illumination. These properties can be adjusted at run-time without having to bake the `VoxelGI` node again.
		**Note:** To prevent text-based scene files (`.tscn`) from growing too much and becoming slow to load and save, always save `VoxelGIData` to an external binary resource file (`.res`) instead of embedding it within the scene. This can be done by clicking the dropdown arrow next to the `VoxelGIData` resource, choosing **Edit**, clicking the floppy disk icon at the top of the Inspector then choosing **Save As...**.

## 属性

- **`bias`** `float` = `1.5`
  - 其它属性：getter=get_bias · setter=set_bias
- **`dynamic_range`** `float` = `2.0`
  - 其它属性：getter=get_dynamic_range · setter=set_dynamic_range
- **`energy`** `float` = `1.0`
  - 其它属性：getter=get_energy · setter=set_energy
- **`interior`** `bool` = `false`
  - 其它属性：getter=is_interior · setter=set_interior
- **`normal_bias`** `float` = `0.0`
  - 其它属性：getter=get_normal_bias · setter=set_normal_bias
- **`propagation`** `float` = `0.5`
  - 其它属性：getter=get_propagation · setter=set_propagation
- **`use_two_bounces`** `bool` = `true`
  - 其它属性：getter=is_using_two_bounces · setter=set_use_two_bounces

## 方法

### `allocate(to_cell_xform: Transform3D, aabb: AABB, octree_size: Vector3, octree_cells: PackedByteArray, data_cells: PackedByteArray, distance_field: PackedByteArray, level_counts: PackedInt32Array) -> void`

Initializes this `VoxelGIData` with the specified data. `octree_cells` must be a multiple of 32. `octree_cells` must be double the size of `data_cells`. The allocated data can be retrieved later using the various getter methods.

### `get_bounds() -> AABB`
- 限定：qualifiers=const

Returns the bounds of the baked voxel data as an `AABB`, which should match `VoxelGI.size` after being baked (which only contains the size as a `Vector3`).
				**Note:** If the size was modified without baking the VoxelGI data, then the value of `get_bounds` and `VoxelGI.size` will not match.

### `get_data_cells() -> PackedByteArray`
- 限定：qualifiers=const

Returns the baked cell data for this `VoxelGIData`.

### `get_level_counts() -> PackedInt32Array`
- 限定：qualifiers=const

Returns the baked level counts for this `VoxelGIData`.

### `get_octree_cells() -> PackedByteArray`
- 限定：qualifiers=const

Returns the baked octree cell data for this `VoxelGIData`.

### `get_octree_size() -> Vector3`
- 限定：qualifiers=const

Returns the baked octree size for this `VoxelGIData`, which corresponds to the number of subdivisions per axis. This can be viewed in the editor by hovering the **Bake VoxelGI** button at the top of the 3D editor viewport when a `VoxelGI` node is selected and looking at the **Subdivisions** field in the tooltip.

### `get_to_cell_xform() -> Transform3D`
- 限定：qualifiers=const

Returns the baked cell transform for this `VoxelGIData`.

## 教程链接

- [Third Person Shooter (TPS) Demo](None)

