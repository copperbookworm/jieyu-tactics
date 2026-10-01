# TileMapLayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TileMapLayer` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TileMapLayer.md`

**摘要**：Node for 2D tile-based maps.

## 描述

Node for 2D tile-based maps. A `TileMapLayer` uses a `TileSet` which contain a list of tiles which are used to create grid-based maps. Unlike the `TileMap` node, which is deprecated, `TileMapLayer` has only one layer of tiles. You can use several `TileMapLayer` to achieve the same result as a `TileMap` node.
		For performance reasons, all TileMap updates are batched at the end of a frame. Notably, this means that scene tiles from a `TileSetScenesCollectionSource` are initialized after their parent. This is only queued when inside the scene tree.
		To force an update earlier on, call `update_internals`.
		**Note:** For performance and compatibility reasons, the coordinates serialized by `TileMapLayer` are limited to 16-bit signed integers, i.e. the range for X and Y coordinates is from `-32768` to `32767`. When saving tile data, tiles outside this range are wrapped.

## 属性

- **`collision_enabled`** `bool` = `true`
  - 其它属性：getter=is_collision_enabled · setter=set_collision_enabled
- **`collision_visibility_mode`** `int` = `0` · 枚举 `TileMapLayer.DebugVisibilityMode`
  - 其它属性：getter=get_collision_visibility_mode · setter=set_collision_visibility_mode
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`navigation_enabled`** `bool` = `true`
  - 其它属性：getter=is_navigation_enabled · setter=set_navigation_enabled
- **`navigation_visibility_mode`** `int` = `0` · 枚举 `TileMapLayer.DebugVisibilityMode`
  - 其它属性：getter=get_navigation_visibility_mode · setter=set_navigation_visibility_mode
- **`occlusion_enabled`** `bool` = `true`
  - 其它属性：getter=is_occlusion_enabled · setter=set_occlusion_enabled
- **`physics_quadrant_size`** `int` = `16`
  - 其它属性：getter=get_physics_quadrant_size · setter=set_physics_quadrant_size
- **`rendering_quadrant_size`** `int` = `16`
  - 其它属性：getter=get_rendering_quadrant_size · setter=set_rendering_quadrant_size
- **`tile_map_data`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_tile_map_data_as_array · setter=set_tile_map_data_from_array
- **`tile_set`** `TileSet`
  - 其它属性：getter=get_tile_set · setter=set_tile_set
- **`use_kinematic_bodies`** `bool` = `false`
  - 其它属性：getter=is_using_kinematic_bodies · setter=set_use_kinematic_bodies
- **`x_draw_order_reversed`** `bool` = `false`
  - 其它属性：getter=is_x_draw_order_reversed · setter=set_x_draw_order_reversed
- **`y_sort_origin`** `int` = `0`
  - 其它属性：getter=get_y_sort_origin · setter=set_y_sort_origin

## 方法

### `_tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void`
- 限定：qualifiers=virtual

Called with a `TileData` object about to be used internally by the `TileMapLayer`, allowing its modification at runtime.
				This method is only called if `_use_tile_data_runtime_update` is implemented and returns `true` for the given tile `coords`.
				**Warning:** The `tile_data` object's sub-resources are the same as the one in the TileSet. Modifying them might impact the whole TileSet. Instead, make sure to duplicate those resources.
				**Note:** If the properties of `tile_data` object should change over time, use `notify_runtime_tile_data_update` to notify the `TileMapLayer` it needs an update.

### `_update_cells(coords: Vector2i[], forced_cleanup: bool) -> void`
- 限定：qualifiers=virtual

Called when this `TileMapLayer`'s cells need an internal update. This update may be caused from individual cells being modified or by a change in the `tile_set` (causing all cells to be queued for an update). The first call to this function is always for initializing all the `TileMapLayer`'s cells. `coords` contains the coordinates of all modified cells, roughly in the order they were modified. `forced_cleanup` is `true` when the `TileMapLayer`'s internals should be fully cleaned up. This is the case when:
				- The layer is disabled;
				- The layer is not visible;
				- `tile_set` is set to `null`;
				- The node is removed from the tree;
				- The node is freed.
				Note that any internal update happening while one of these conditions is verified is considered to be a "cleanup". See also `update_internals`.
				**Warning:** Implementing this method may degrade the `TileMapLayer`'s performance.

### `_use_tile_data_runtime_update(coords: Vector2i) -> bool`
- 限定：qualifiers=virtual

Should return `true` if the tile at coordinates `coords` requires a runtime update.
				**Warning:** Make sure this function only returns `true` when needed. Any tile processed at runtime without a need for it will imply a significant performance penalty.
				**Note:** If the result of this function should change, use `notify_runtime_tile_data_update` to notify the `TileMapLayer` it needs an update.

### `clear() -> void`

Clears all cells.

### `erase_cell(coords: Vector2i) -> void`

Erases the cell at coordinates `coords`.

### `fix_invalid_tiles() -> void`

Clears cells containing tiles that do not exist in the `tile_set`.

### `get_cell_alternative_tile(coords: Vector2i) -> int`
- 限定：qualifiers=const

Returns the tile alternative ID of the cell at coordinates `coords`.

### `get_cell_atlas_coords(coords: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns the tile atlas coordinates ID of the cell at coordinates `coords`. Returns `Vector2i(-1, -1)` if the cell does not exist.

### `get_cell_source_id(coords: Vector2i) -> int`
- 限定：qualifiers=const

Returns the tile source ID of the cell at coordinates `coords`. Returns `-1` if the cell does not exist.

### `get_cell_tile_data(coords: Vector2i) -> TileData`
- 限定：qualifiers=const

Returns the `TileData` object associated with the given cell, or `null` if the cell does not exist or is not a `TileSetAtlasSource`.
				
```gdscript
				func get_clicked_tile_power():
					var clicked_cell = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
					var data = tile_map_layer.get_cell_tile_data(clicked_cell)
					if data:
						return data.get_custom_data("power")
					else:
						return 0
				
```

### `get_coords_for_body_rid(body: RID) -> Vector2i`
- 限定：qualifiers=const

Returns the coordinates of the physics quadrant (see `physics_quadrant_size`) for given physics body `RID`. Such an `RID` can be retrieved from `KinematicCollision2D.get_collider_rid`, when colliding with a tile.
				**Note:** Higher values of `physics_quadrant_size` will make this function less precise. To get the exact cell coordinates, you need to set `physics_quadrant_size` to `1`, which disables physics chunking.

### `get_navigation_map() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the `NavigationServer2D` navigation used by this `TileMapLayer`.
				By default this returns the default `World2D` navigation map, unless a custom map was provided using `set_navigation_map`.

### `get_neighbor_cell(coords: Vector2i, neighbor: int) -> Vector2i`
- 限定：qualifiers=const

Returns the neighboring cell to the one at coordinates `coords`, identified by the `neighbor` direction. This method takes into account the different layouts a TileMap can take.

### `get_pattern(coords_array: Vector2i[]) -> TileMapPattern`

Creates and returns a new `TileMapPattern` from the given array of cells. See also `set_pattern`.

### `get_surrounding_cells(coords: Vector2i) -> Vector2i[]`

Returns the list of all neighboring cells to the one at `coords`. Any neighboring cell is one that is touching edges, so for a square cell 4 cells would be returned, for a hexagon 6 cells are returned.

### `get_used_cells() -> Vector2i[]`
- 限定：qualifiers=const

Returns a `Vector2i` array with the positions of all cells containing a tile. A cell is considered empty if its source identifier equals `-1`, its atlas coordinate identifier is `Vector2(-1, -1)` and its alternative identifier is `-1`.

### `get_used_cells_by_id(source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) -> Vector2i[]`
- 限定：qualifiers=const

Returns a `Vector2i` array with the positions of all cells containing a tile. Tiles may be filtered according to their source (`source_id`), their atlas coordinates (`atlas_coords`), or alternative id (`alternative_tile`).
				If a parameter has its value set to the default one, this parameter is not used to filter a cell. Thus, if all parameters have their respective default values, this method returns the same result as `get_used_cells`.
				A cell is considered empty if its source identifier equals `-1`, its atlas coordinate identifier is `Vector2(-1, -1)` and its alternative identifier is `-1`.

### `get_used_rect() -> Rect2i`
- 限定：qualifiers=const

Returns a rectangle enclosing the used (non-empty) tiles of the map.

### `has_body_rid(body: RID) -> bool`
- 限定：qualifiers=const

Returns whether the provided `body` `RID` belongs to one of this `TileMapLayer`'s cells.

### `is_cell_flipped_h(coords: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell at coordinates `coords` is flipped horizontally. The result is valid only for atlas sources.

### `is_cell_flipped_v(coords: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell at coordinates `coords` is flipped vertically. The result is valid only for atlas sources.

### `is_cell_transposed(coords: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell at coordinates `coords` is transposed. The result is valid only for atlas sources.

### `local_to_map(local_position: Vector2) -> Vector2i`
- 限定：qualifiers=const

Returns the map coordinates of the cell containing the given `local_position`. If `local_position` is in global coordinates, consider using `Node2D.to_local` before passing it to this method. See also `map_to_local`.

### `map_pattern(position_in_tilemap: Vector2i, coords_in_pattern: Vector2i, pattern: TileMapPattern) -> Vector2i`

Returns for the given coordinates `coords_in_pattern` in a `TileMapPattern` the corresponding cell coordinates if the pattern was pasted at the `position_in_tilemap` coordinates (see `set_pattern`). This mapping is required as in half-offset tile shapes, the mapping might not work by calculating `position_in_tile_map + coords_in_pattern`.

### `map_to_local(map_position: Vector2i) -> Vector2`
- 限定：qualifiers=const

Returns the centered position of a cell in the `TileMapLayer`'s local coordinate space. To convert the returned value into global coordinates, use `Node2D.to_global`. See also `local_to_map`.
				**Note:** This may not correspond to the visual position of the tile, i.e. it ignores the `TileData.texture_origin` property of individual tiles.

### `notify_runtime_tile_data_update() -> void`

Notifies the `TileMapLayer` node that calls to `_use_tile_data_runtime_update` or `_tile_data_runtime_update` will lead to different results. This will thus trigger a `TileMapLayer` update.
				**Warning:** Updating the `TileMapLayer` is computationally expensive and may impact performance. Try to limit the number of calls to this function to avoid unnecessary update.
				**Note:** This does not trigger a direct update of the `TileMapLayer`, the update will be done at the end of the frame as usual (unless you call `update_internals`).

### `set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0) -> void`

Sets the tile identifiers for the cell at coordinates `coords`. Each tile of the `TileSet` is identified using three parts:
				- The source identifier `source_id` identifies a `TileSetSource` identifier. See `TileSet.set_source_id`,
				- The atlas coordinate identifier `atlas_coords` identifies a tile coordinates in the atlas (if the source is a `TileSetAtlasSource`). For `TileSetScenesCollectionSource` it should always be `Vector2i(0, 0)`,
				- The alternative tile identifier `alternative_tile` identifies a tile alternative in the atlas (if the source is a `TileSetAtlasSource`), and the scene for a `TileSetScenesCollectionSource`.
				If `source_id` is set to `-1`, `atlas_coords` to `Vector2i(-1, -1)`, or `alternative_tile` to `-1`, the cell will be erased. An erased cell gets **all** its identifiers automatically set to their respective invalid values, namely `-1`, `Vector2i(-1, -1)` and `-1`.

### `set_cells_terrain_connect(cells: Vector2i[], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) -> void`

Update all the cells in the `cells` coordinates array so that they use the given `terrain` for the given `terrain_set`. If an updated cell has the same terrain as one of its neighboring cells, this function tries to join the two. This function might update neighboring tiles if needed to create correct terrain transitions.
				If `ignore_empty_terrains` is `true`, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.
				**Note:** To work correctly, this method requires the `TileMapLayer`'s TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

### `set_cells_terrain_path(path: Vector2i[], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) -> void`

Update all the cells in the `path` coordinates array so that they use the given `terrain` for the given `terrain_set`. The function will also connect two successive cell in the path with the same terrain. This function might update neighboring tiles if needed to create correct terrain transitions.
				If `ignore_empty_terrains` is `true`, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.
				**Note:** To work correctly, this method requires the `TileMapLayer`'s TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

### `set_navigation_map(map: RID) -> void`

Sets a custom `map` as a `NavigationServer2D` navigation map. If not set, uses the default `World2D` navigation map instead.

### `set_pattern(position: Vector2i, pattern: TileMapPattern) -> void`

Pastes the `TileMapPattern` at the given `position` in the tile map. See also `get_pattern`.

### `update_internals() -> void`

Triggers a direct update of the `TileMapLayer`. Usually, calling this function is not needed, as `TileMapLayer` node updates automatically when one of its properties or cells is modified.
				However, for performance reasons, those updates are batched and delayed to the end of the frame. Calling this function will force the `TileMapLayer` to update right away instead.
				**Warning:** Updating the `TileMapLayer` is computationally expensive and may impact performance. Try to limit the number of updates and how many tiles they impact.

## 信号

### `changed()`

Emitted when this `TileMapLayer`'s properties changes. This includes modified cells, properties, or changes made to its assigned `TileSet`.
				**Note:** This signal may be emitted very often when batch-modifying a `TileMapLayer`. Avoid executing complex processing in a connected function, and consider delaying it to the end of the frame instead (i.e. calling `Object.call_deferred`).

## 枚举

### `DebugVisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEBUG_VISIBILITY_MODE_DEFAULT` |  |
| `2` | `DEBUG_VISIBILITY_MODE_FORCE_HIDE` |  |
| `1` | `DEBUG_VISIBILITY_MODE_FORCE_SHOW` |  |

## 教程链接

- [Using Tilemaps](None)
- [2D Platformer Demo](None)
- [2D Isometric Demo](None)
- [2D Hexagonal Demo](None)
- [2D Grid-based Navigation with AStarGrid2D Demo](None)
- [2D Role Playing Game (RPG) Demo](None)
- [2D Kinematic Character Demo](None)
- [2D Dynamic TileMap Layers Demo](None)

