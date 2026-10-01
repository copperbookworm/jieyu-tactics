# GridMap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GridMap` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=tilemap
> 自动生成，勿手改。文件：`refs/godot-api/GridMap.md`

**摘要**：Node for 3D tile-based maps.

## 描述

GridMap lets you place meshes on a grid interactively. It works both from the editor and from scripts, which can help you create in-game level editors.
		GridMaps use a `MeshLibrary` which contains a list of tiles. Each tile is a mesh with materials plus optional collision and navigation shapes.
		A GridMap contains a collection of cells. Each grid cell refers to a tile in the `MeshLibrary`. All cells in the map have the same dimensions.
		Internally, a GridMap is split into a sparse collection of octants for efficient rendering and physics processing. Every octant has the same dimensions and can contain several cells.
		**Note:** GridMap doesn't extend `VisualInstance3D` and therefore can't be hidden or cull masked based on `VisualInstance3D.layers`. If you make a light not affect the first layer, the whole GridMap won't be lit by the light in question.

## 属性

- **`bake_navigation`** `bool` = `false`
  - 其它属性：getter=is_baking_navigation · setter=set_bake_navigation
- **`cell_center_x`** `bool` = `true`
  - 其它属性：getter=get_center_x · setter=set_center_x
- **`cell_center_y`** `bool` = `true`
  - 其它属性：getter=get_center_y · setter=set_center_y
- **`cell_center_z`** `bool` = `true`
  - 其它属性：getter=get_center_z · setter=set_center_z
- **`cell_octant_size`** `int` = `8`
  - 其它属性：getter=get_octant_size · setter=set_octant_size
- **`cell_scale`** `float` = `1.0`
  - 其它属性：getter=get_cell_scale · setter=set_cell_scale
- **`cell_size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_cell_size · setter=set_cell_size
- **`collision_layer`** `int` = `1`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`collision_priority`** `float` = `1.0`
  - 其它属性：getter=get_collision_priority · setter=set_collision_priority
- **`collision_visibility_mode`** `int` = `0` · 枚举 `GridMap.DebugVisibilityMode`
  - 其它属性：getter=get_collision_visibility_mode · setter=set_collision_visibility_mode
- **`mesh_library`** `MeshLibrary`
  - 其它属性：getter=get_mesh_library · setter=set_mesh_library
- **`physics_material`** `PhysicsMaterial`
  - 其它属性：getter=get_physics_material · setter=set_physics_material

## 方法

### `clear() -> void`

Clear all cells.

### `clear_baked_meshes() -> void`

Clears all baked meshes. See `make_baked_meshes`.

### `get_bake_mesh_instance(idx: int) -> RID`

Returns `RID` of a baked mesh with the given `idx`.

### `get_bake_meshes() -> Array`

Returns an array of `ArrayMesh`es and `Transform3D` references of all bake meshes that exist within the current GridMap. Even indices contain `ArrayMesh`es, while odd indices contain `Transform3D`s that are always equal to `Transform3D.IDENTITY`.
				This method relies on the output of `make_baked_meshes`, which will be called with `gen_lightmap_uv` set to `true` and `lightmap_uv_texel_size` set to `0.1` if it hasn't been called yet.

### `get_basis_with_orthogonal_index(index: int) -> Basis`
- 限定：qualifiers=const

Returns one of 24 possible rotations that lie along the vectors (x,y,z) with each component being either -1, 0, or 1. For further details, refer to the Godot source code.

### `get_cell_item(position: Vector3i) -> int`
- 限定：qualifiers=const

The `MeshLibrary` item index located at the given grid coordinates. If the cell is empty, `INVALID_CELL_ITEM` will be returned.

### `get_cell_item_basis(position: Vector3i) -> Basis`
- 限定：qualifiers=const

Returns the basis that gives the specified cell its orientation.

### `get_cell_item_orientation(position: Vector3i) -> int`
- 限定：qualifiers=const

The orientation of the cell at the given grid coordinates. `-1` is returned if the cell is empty.

### `get_collision_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_layer` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_meshes() -> Array`
- 限定：qualifiers=const

Returns an array of `Transform3D` and `Mesh` references corresponding to the non-empty cells in the grid. The transforms are specified in local space. Even indices contain `Transform3D`s, while odd indices contain `Mesh`es related to the `Transform3D` in the index preceding it.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the navigation map this GridMap node uses for its cell baked navigation meshes.
				This function returns always the map set on the GridMap node and not the map on the NavigationServer. If the map is changed directly with the NavigationServer API the GridMap node will not be aware of the map change.

### `get_octant_coords_from_cell_coords(cell_coords: Vector3i) -> Vector3i`
- 限定：qualifiers=const

Returns the `Vector3i` octant coordinates of the octant that the cell at `cell_coords` belongs to.

### `get_octants_in_bounds(bounds: AABB) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i` octant coordinates that are inside the given `bounds`, including octants that have no cells in use.

### `get_orthogonal_index_from_basis(basis: Basis) -> int`
- 限定：qualifiers=const

This function considers a discretization of rotations into 24 points on unit sphere, lying along the vectors (x,y,z) with each component being either -1, 0, or 1, and returns the index (in the range from 0 to 23) of the point best representing the orientation of the object. For further details, refer to the Godot source code.

### `get_used_cells() -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3` with the non-empty cell coordinates in the grid map.

### `get_used_cells_by_item(item: int) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of all cells with the given item index specified in `item`.

### `get_used_cells_in_octant(octant_coords: Vector3i) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the cell coordinates of non-empty cells inside the octant at `octant_coords`.

### `get_used_cells_in_octant_by_item(octant_coords: Vector3i, item: int) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the cell coordinates of cells inside the octant at `octant_coords` that use the specified cell `item`.

### `get_used_octants() -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the octant coordinates of the non-empty octants in the grid map.

### `get_used_octants_by_item(item: int) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the octant coordinates of the octants that use the specified `item` in the grid map.

### `get_used_octants_in_bounds(bounds: AABB) -> Vector3i[]`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the octant coordinates of non-empty octants that are inside the local `bounds`.

### `local_to_map(local_position: Vector3) -> Vector3i`
- 限定：qualifiers=const

Returns the map coordinates of the cell containing the given `local_position`. If `local_position` is in global coordinates, consider using `Node3D.to_local` before passing it to this method. See also `map_to_local`.

### `make_baked_meshes(gen_lightmap_uv: bool = false, lightmap_uv_texel_size: float = 0.1) -> void`

Generates a baked mesh that represents all meshes in the assigned `MeshLibrary` for use with `LightmapGI`. If `gen_lightmap_uv` is `true`, UV2 data will be generated for each mesh currently used in the `GridMap`. Otherwise, only meshes that already have UV2 data present will be able to use baked lightmaps. When generating UV2, `lightmap_uv_texel_size` controls the texel density for lightmaps, with lower values resulting in more detailed lightmaps. `lightmap_uv_texel_size` is ignored if `gen_lightmap_uv` is `false`. See also `get_bake_meshes`, which relies on the output of this method.
				**Note:** Calling this method will not actually bake lightmaps, as lightmap baking is performed using the `LightmapGI` node.

### `map_to_local(map_position: Vector3i) -> Vector3`
- 限定：qualifiers=const

Returns the position of a grid cell in the GridMap's local coordinate space. To convert the returned value into global coordinates, use `Node3D.to_global`. See also `local_to_map`.

### `resource_changed(resource: Resource) -> void`
- 限定：deprecated=Use [signal Resource.changed] instead.

This method does nothing.

### `set_cell_item(position: Vector3i, item: int, orientation: int = 0) -> void`

Sets the mesh index for the cell referenced by its grid coordinates.
				A negative item index such as `INVALID_CELL_ITEM` will clear the cell.
				Optionally, the item's orientation can be passed. For valid orientation values, see `get_orthogonal_index_from_basis`.

### `set_collision_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_layer`, given a `layer_number` between 1 and 32.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

### `set_navigation_map(navigation_map: RID) -> void`

Sets the `RID` of the navigation map this GridMap node should use for its cell baked navigation meshes.

## 信号

### `cell_size_changed(cell_size: Vector3)`

Emitted when `cell_size` changes.

### `changed()`

Emitted when the `MeshLibrary` of this GridMap changes.

## 枚举

### `DebugVisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEBUG_VISIBILITY_MODE_DEFAULT` |  |
| `1` | `DEBUG_VISIBILITY_MODE_FORCE_SHOW` |  |
| `2` | `DEBUG_VISIBILITY_MODE_FORCE_HIDE` |  |

## 常量

- **`INVALID_CELL_ITEM`** = `-1`
## 教程链接

- [Using gridmaps](None)
- [3D Platformer Demo](None)
- [3D Kinematic Character Demo](None)

