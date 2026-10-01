# TileMap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TileMap` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · deprecated=Use multiple [TileMapLayer] nodes instead. To convert a TileMap to a set of TileMapLayer nodes, open the TileMap bottom panel with the node selected, click the toolbox icon in the top-right corner and choose 'Extract TileMap layers as individual TileMapLayer nodes'. · keywords=gridmap
> 自动生成，勿手改。文件：`refs/godot-api/TileMap.md`

**摘要**：Node for 2D tile-based maps.

## 描述

Node for 2D tile-based maps. Tilemaps use a `TileSet` which contain a list of tiles which are used to create grid-based maps. A TileMap may have several layers, layouting tiles on top of each other.
		For performance reasons, all TileMap updates are batched at the end of a frame. Notably, this means that scene tiles from a `TileSetScenesCollectionSource` may be initialized after their parent. This is only queued when inside the scene tree.
		To force an update earlier on, call `update_internals`.
		**Note:** For performance and compatibility reasons, the coordinates serialized by `TileMap` are limited to 16-bit signed integers, i.e. the range for X and Y coordinates is from `-32768` to `32767`. When saving tile data, tiles outside this range are wrapped.

## 属性

- **`collision_animatable`** `bool` = `false`
  - 其它属性：getter=is_collision_animatable · setter=set_collision_animatable
- **`collision_visibility_mode`** `int` = `0` · 枚举 `TileMap.VisibilityMode`
  - 其它属性：getter=get_collision_visibility_mode · setter=set_collision_visibility_mode
- **`navigation_visibility_mode`** `int` = `0` · 枚举 `TileMap.VisibilityMode`
  - 其它属性：getter=get_navigation_visibility_mode · setter=set_navigation_visibility_mode
- **`rendering_quadrant_size`** `int` = `16`
  - 其它属性：getter=get_rendering_quadrant_size · setter=set_rendering_quadrant_size
- **`tile_set`** `TileSet`
  - 其它属性：getter=get_tileset · setter=set_tileset

## 方法

### `_tile_data_runtime_update(layer: int, coords: Vector2i, tile_data: TileData) -> void`
- 限定：qualifiers=virtual

Called with a TileData object about to be used internally by the TileMap, allowing its modification at runtime.
				This method is only called if `_use_tile_data_runtime_update` is implemented and returns `true` for the given tile `coords` and `layer`.
				**Warning:** The `tile_data` object's sub-resources are the same as the one in the TileSet. Modifying them might impact the whole TileSet. Instead, make sure to duplicate those resources.
				**Note:** If the properties of `tile_data` object should change over time, use `notify_runtime_tile_data_update` to notify the TileMap it needs an update.

### `_use_tile_data_runtime_update(layer: int, coords: Vector2i) -> bool`
- 限定：qualifiers=virtual

Should return `true` if the tile at coordinates `coords` on layer `layer` requires a runtime update.
				**Warning:** Make sure this function only return `true` when needed. Any tile processed at runtime without a need for it will imply a significant performance penalty.
				**Note:** If the result of this function should changed, use `notify_runtime_tile_data_update` to notify the TileMap it needs an update.

### `add_layer(to_position: int) -> void`

Adds a layer at the given position `to_position` in the array. If `to_position` is negative, the position is counted from the end, with `-1` adding the layer at the end of the array.

### `clear() -> void`

Clears all cells.

### `clear_layer(layer: int) -> void`

Clears all cells on the given layer.
				If `layer` is negative, the layers are accessed from the last one.

### `erase_cell(layer: int, coords: Vector2i) -> void`

Erases the cell on layer `layer` at coordinates `coords`.
				If `layer` is negative, the layers are accessed from the last one.

### `fix_invalid_tiles() -> void`

Clears cells that do not exist in the tileset.

### `force_update(layer: int = -1) -> void`
- 限定：deprecated=Use [method notify_runtime_tile_data_update] and/or [method update_internals] instead.

Forces the TileMap and the layer `layer` to update.

### `get_cell_alternative_tile(layer: int, coords: Vector2i, use_proxies: bool = false) -> int`
- 限定：qualifiers=const

Returns the tile alternative ID of the cell on layer `layer` at `coords`.
				If `use_proxies` is `false`, ignores the `TileSet`'s tile proxies, returning the raw alternative identifier. See `TileSet.map_tile_proxy`.
				If `layer` is negative, the layers are accessed from the last one.

### `get_cell_atlas_coords(layer: int, coords: Vector2i, use_proxies: bool = false) -> Vector2i`
- 限定：qualifiers=const

Returns the tile atlas coordinates ID of the cell on layer `layer` at coordinates `coords`. Returns `Vector2i(-1, -1)` if the cell does not exist.
				If `use_proxies` is `false`, ignores the `TileSet`'s tile proxies, returning the raw atlas coordinate identifier. See `TileSet.map_tile_proxy`.
				If `layer` is negative, the layers are accessed from the last one.

### `get_cell_source_id(layer: int, coords: Vector2i, use_proxies: bool = false) -> int`
- 限定：qualifiers=const

Returns the tile source ID of the cell on layer `layer` at coordinates `coords`. Returns `-1` if the cell does not exist.
				If `use_proxies` is `false`, ignores the `TileSet`'s tile proxies, returning the raw source identifier. See `TileSet.map_tile_proxy`.
				If `layer` is negative, the layers are accessed from the last one.

### `get_cell_tile_data(layer: int, coords: Vector2i, use_proxies: bool = false) -> TileData`
- 限定：qualifiers=const

Returns the `TileData` object associated with the given cell, or `null` if the cell does not exist or is not a `TileSetAtlasSource`.
				If `layer` is negative, the layers are accessed from the last one.
				
```gdscript
				func get_clicked_tile_power():
					var clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
					var data = tile_map.get_cell_tile_data(0, clicked_cell)
					if data:
						return data.get_custom_data("power")
					else:
						return 0
				
```

				If `use_proxies` is `false`, ignores the `TileSet`'s tile proxies. See `TileSet.map_tile_proxy`.

### `get_coords_for_body_rid(body: RID) -> Vector2i`

Returns the coordinates of the tile for given physics body RID. Such RID can be retrieved from `KinematicCollision2D.get_collider_rid`, when colliding with a tile.

### `get_layer_for_body_rid(body: RID) -> int`

Returns the tilemap layer of the tile for given physics body RID. Such RID can be retrieved from `KinematicCollision2D.get_collider_rid`, when colliding with a tile.

### `get_layer_modulate(layer: int) -> Color`
- 限定：qualifiers=const

Returns a TileMap layer's modulate.
				If `layer` is negative, the layers are accessed from the last one.

### `get_layer_name(layer: int) -> String`
- 限定：qualifiers=const

Returns a TileMap layer's name.
				If `layer` is negative, the layers are accessed from the last one.

### `get_layer_navigation_map(layer: int) -> RID`
- 限定：qualifiers=const

Returns the `RID` of the `NavigationServer2D` navigation map assigned to the specified TileMap layer `layer`.
				By default the TileMap uses the default `World2D` navigation map for the first TileMap layer. For each additional TileMap layer a new navigation map is created for the additional layer.
				In order to make `NavigationAgent2D` switch between TileMap layer navigation maps use `NavigationAgent2D.set_navigation_map` with the navigation map received from `get_layer_navigation_map`.
				If `layer` is negative, the layers are accessed from the last one.

### `get_layer_y_sort_origin(layer: int) -> int`
- 限定：qualifiers=const

Returns a TileMap layer's Y sort origin.
				If `layer` is negative, the layers are accessed from the last one.

### `get_layer_z_index(layer: int) -> int`
- 限定：qualifiers=const

Returns a TileMap layer's Z-index value.
				If `layer` is negative, the layers are accessed from the last one.

### `get_layers_count() -> int`
- 限定：qualifiers=const

Returns the number of layers in the TileMap.

### `get_navigation_map(layer: int) -> RID`
- 限定：deprecated=Use [method get_layer_navigation_map] instead. · qualifiers=const

Returns the `RID` of the `NavigationServer2D` navigation map assigned to the specified TileMap layer `layer`.

### `get_neighbor_cell(coords: Vector2i, neighbor: int) -> Vector2i`
- 限定：qualifiers=const

Returns the neighboring cell to the one at coordinates `coords`, identified by the `neighbor` direction. This method takes into account the different layouts a TileMap can take.

### `get_pattern(layer: int, coords_array: Vector2i[]) -> TileMapPattern`

Creates a new `TileMapPattern` from the given layer and set of cells.
				If `layer` is negative, the layers are accessed from the last one.

### `get_surrounding_cells(coords: Vector2i) -> Vector2i[]`

Returns the list of all neighbourings cells to the one at `coords`.

### `get_used_cells(layer: int) -> Vector2i[]`
- 限定：qualifiers=const

Returns a `Vector2i` array with the positions of all cells containing a tile in the given layer. A cell is considered empty if its source identifier equals -1, its atlas coordinates identifiers is `Vector2(-1, -1)` and its alternative identifier is -1.
				If `layer` is negative, the layers are accessed from the last one.

### `get_used_cells_by_id(layer: int, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) -> Vector2i[]`
- 限定：qualifiers=const

Returns a `Vector2i` array with the positions of all cells containing a tile in the given layer. Tiles may be filtered according to their source (`source_id`), their atlas coordinates (`atlas_coords`) or alternative id (`alternative_tile`).
				If a parameter has its value set to the default one, this parameter is not used to filter a cell. Thus, if all parameters have their respective default value, this method returns the same result as `get_used_cells`.
				A cell is considered empty if its source identifier equals -1, its atlas coordinates identifiers is `Vector2(-1, -1)` and its alternative identifier is -1.
				If `layer` is negative, the layers are accessed from the last one.

### `get_used_rect() -> Rect2i`
- 限定：qualifiers=const

Returns a rectangle enclosing the used (non-empty) tiles of the map, including all layers.

### `is_cell_flipped_h(layer: int, coords: Vector2i, use_proxies: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell on layer `layer` at coordinates `coords` is flipped horizontally. The result is valid only for atlas sources.

### `is_cell_flipped_v(layer: int, coords: Vector2i, use_proxies: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell on layer `layer` at coordinates `coords` is flipped vertically. The result is valid only for atlas sources.

### `is_cell_transposed(layer: int, coords: Vector2i, use_proxies: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if the cell on layer `layer` at coordinates `coords` is transposed. The result is valid only for atlas sources.

### `is_layer_enabled(layer: int) -> bool`
- 限定：qualifiers=const

Returns if a layer is enabled.
				If `layer` is negative, the layers are accessed from the last one.

### `is_layer_navigation_enabled(layer: int) -> bool`
- 限定：qualifiers=const

Returns if a layer's built-in navigation regions generation is enabled.

### `is_layer_y_sort_enabled(layer: int) -> bool`
- 限定：qualifiers=const

Returns if a layer Y-sorts its tiles.
				If `layer` is negative, the layers are accessed from the last one.

### `local_to_map(local_position: Vector2) -> Vector2i`
- 限定：qualifiers=const

Returns the map coordinates of the cell containing the given `local_position`. If `local_position` is in global coordinates, consider using `Node2D.to_local` before passing it to this method. See also `map_to_local`.

### `map_pattern(position_in_tilemap: Vector2i, coords_in_pattern: Vector2i, pattern: TileMapPattern) -> Vector2i`

Returns for the given coordinate `coords_in_pattern` in a `TileMapPattern` the corresponding cell coordinates if the pattern was pasted at the `position_in_tilemap` coordinates (see `set_pattern`). This mapping is required as in half-offset tile shapes, the mapping might not work by calculating `position_in_tile_map + coords_in_pattern`.

### `map_to_local(map_position: Vector2i) -> Vector2`
- 限定：qualifiers=const

Returns the centered position of a cell in the TileMap's local coordinate space. To convert the returned value into global coordinates, use `Node2D.to_global`. See also `local_to_map`.
				**Note:** This may not correspond to the visual position of the tile, i.e. it ignores the `TileData.texture_origin` property of individual tiles.

### `move_layer(layer: int, to_position: int) -> void`

Moves the layer at index `layer` to the given position `to_position` in the array.

### `notify_runtime_tile_data_update(layer: int = -1) -> void`

Notifies the TileMap node that calls to `_use_tile_data_runtime_update` or `_tile_data_runtime_update` will lead to different results. This will thus trigger a TileMap update.
				If `layer` is provided, only notifies changes for the given layer. Providing the `layer` argument (when applicable) is usually preferred for performance reasons.
				**Warning:** Updating the TileMap is computationally expensive and may impact performance. Try to limit the number of calls to this function to avoid unnecessary update.
				**Note:** This does not trigger a direct update of the TileMap, the update will be done at the end of the frame as usual (unless you call `update_internals`).

### `remove_layer(layer: int) -> void`

Removes the layer at index `layer`.

### `set_cell(layer: int, coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0) -> void`

Sets the tile identifiers for the cell on layer `layer` at coordinates `coords`. Each tile of the `TileSet` is identified using three parts:
				- The source identifier `source_id` identifies a `TileSetSource` identifier. See `TileSet.set_source_id`,
				- The atlas coordinates identifier `atlas_coords` identifies a tile coordinates in the atlas (if the source is a `TileSetAtlasSource`). For `TileSetScenesCollectionSource` it should always be `Vector2i(0, 0)`),
				- The alternative tile identifier `alternative_tile` identifies a tile alternative in the atlas (if the source is a `TileSetAtlasSource`), and the scene for a `TileSetScenesCollectionSource`.
				If `source_id` is set to `-1`, `atlas_coords` to `Vector2i(-1, -1)` or `alternative_tile` to `-1`, the cell will be erased. An erased cell gets **all** its identifiers automatically set to their respective invalid values, namely `-1`, `Vector2i(-1, -1)` and `-1`.
				If `layer` is negative, the layers are accessed from the last one.

### `set_cells_terrain_connect(layer: int, cells: Vector2i[], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) -> void`

Update all the cells in the `cells` coordinates array so that they use the given `terrain` for the given `terrain_set`. If an updated cell has the same terrain as one of its neighboring cells, this function tries to join the two. This function might update neighboring tiles if needed to create correct terrain transitions.
				If `ignore_empty_terrains` is `true`, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.
				If `layer` is negative, the layers are accessed from the last one.
				**Note:** To work correctly, this method requires the TileMap's TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

### `set_cells_terrain_path(layer: int, path: Vector2i[], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true) -> void`

Update all the cells in the `path` coordinates array so that they use the given `terrain` for the given `terrain_set`. The function will also connect two successive cell in the path with the same terrain. This function might update neighboring tiles if needed to create correct terrain transitions.
				If `ignore_empty_terrains` is `true`, empty terrains will be ignored when trying to find the best fitting tile for the given terrain constraints.
				If `layer` is negative, the layers are accessed from the last one.
				**Note:** To work correctly, this method requires the TileMap's TileSet to have terrains set up with all required terrain combinations. Otherwise, it may produce unexpected results.

### `set_layer_enabled(layer: int, enabled: bool) -> void`

Enables or disables the layer `layer`. A disabled layer is not processed at all (no rendering, no physics, etc.).
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_modulate(layer: int, modulate: Color) -> void`

Sets a layer's color. It will be multiplied by tile's color and TileMap's modulate.
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_name(layer: int, name: String) -> void`

Sets a layer's name. This is mostly useful in the editor.
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_navigation_enabled(layer: int, enabled: bool) -> void`

Enables or disables a layer's built-in navigation regions generation. Disable this if you need to bake navigation regions from a TileMap using a `NavigationRegion2D` node.

### `set_layer_navigation_map(layer: int, map: RID) -> void`

Assigns `map` as a `NavigationServer2D` navigation map for the specified TileMap layer `layer`.
				By default the TileMap uses the default `World2D` navigation map for the first TileMap layer. For each additional TileMap layer a new navigation map is created for the additional layer.
				In order to make `NavigationAgent2D` switch between TileMap layer navigation maps use `NavigationAgent2D.set_navigation_map` with the navigation map received from `get_layer_navigation_map`.
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_y_sort_enabled(layer: int, y_sort_enabled: bool) -> void`

Enables or disables a layer's Y-sorting. If a layer is Y-sorted, the layer will behave as a CanvasItem node where each of its tile gets Y-sorted.
				Y-sorted layers should usually be on different Z-index values than not Y-sorted layers, otherwise, each of those layer will be Y-sorted as whole with the Y-sorted one. This is usually an undesired behavior.
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_y_sort_origin(layer: int, y_sort_origin: int) -> void`

Sets a layer's Y-sort origin value. This Y-sort origin value is added to each tile's Y-sort origin value.
				This allows, for example, to fake a different height level on each layer. This can be useful for top-down view games.
				If `layer` is negative, the layers are accessed from the last one.

### `set_layer_z_index(layer: int, z_index: int) -> void`

Sets a layers Z-index value. This Z-index is added to each tile's Z-index value.
				If `layer` is negative, the layers are accessed from the last one.

### `set_navigation_map(layer: int, map: RID) -> void`
- 限定：deprecated=Use [method set_layer_navigation_map] instead.

Assigns `map` as a `NavigationServer2D` navigation map for the specified TileMap layer `layer`.

### `set_pattern(layer: int, position: Vector2i, pattern: TileMapPattern) -> void`

Paste the given `TileMapPattern` at the given `position` and `layer` in the tile map.
				If `layer` is negative, the layers are accessed from the last one.

### `update_internals() -> void`

Triggers a direct update of the TileMap. Usually, calling this function is not needed, as TileMap node updates automatically when one of its properties or cells is modified.
				However, for performance reasons, those updates are batched and delayed to the end of the frame. Calling this function will force the TileMap to update right away instead.
				**Warning:** Updating the TileMap is computationally expensive and may impact performance. Try to limit the number of updates and how many tiles they impact.

## 信号

### `changed()`

Emitted when the `TileSet` of this TileMap changes.

## 枚举

### `VisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_MODE_DEFAULT` |  |
| `2` | `VISIBILITY_MODE_FORCE_HIDE` |  |
| `1` | `VISIBILITY_MODE_FORCE_SHOW` |  |

## 教程链接

- [Using Tilemaps](None)
- [2D Platformer Demo](None)
- [2D Isometric Demo](None)
- [2D Hexagonal Demo](None)
- [2D Grid-based Navigation with AStarGrid2D Demo](None)
- [2D Role Playing Game (RPG) Demo](None)
- [2D Kinematic Character Demo](None)
- [2D Dynamic TileMap Layers Demo](None)

