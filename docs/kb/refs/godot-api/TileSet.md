# TileSet

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TileSet` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TileSet.md`

**摘要**：Tile library for tilemaps.

## 描述

A TileSet is a library of tiles for a `TileMapLayer`. A TileSet handles a list of `TileSetSource`, each of them storing a set of tiles.
		Tiles can either be from a `TileSetAtlasSource`, which renders tiles out of a texture with support for physics, navigation, etc., or from a `TileSetScenesCollectionSource`, which exposes scene-based tiles.
		Tiles are referenced by using three IDs: their source ID, their atlas coordinates ID, and their alternative tile ID.
		A TileSet can be configured so that its tiles expose more or fewer properties. To do so, the TileSet resources use property layers, which you can add or remove depending on your needs.
		For example, adding a physics layer allows giving collision shapes to your tiles. Each layer has dedicated properties (physics layer and mask), so you may add several TileSet physics layers for each type of collision you need.
		See the functions to add new layers for more information.

## 属性

- **`tile_layout`** `int` = `0` · 枚举 `TileSet.TileLayout`
  - 其它属性：getter=get_tile_layout · setter=set_tile_layout
- **`tile_offset_axis`** `int` = `0` · 枚举 `TileSet.TileOffsetAxis`
  - 其它属性：getter=get_tile_offset_axis · setter=set_tile_offset_axis
- **`tile_shape`** `int` = `0` · 枚举 `TileSet.TileShape`
  - 其它属性：getter=get_tile_shape · setter=set_tile_shape
- **`tile_size`** `Vector2i` = `Vector2i(16, 16)`
  - 其它属性：getter=get_tile_size · setter=set_tile_size
- **`uv_clipping`** `bool` = `false`
  - 其它属性：getter=is_uv_clipping · setter=set_uv_clipping

## 方法

### `add_custom_data_layer(to_position: int = -1) -> void`

Adds a custom data layer to the TileSet at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.
				Custom data layers allow assigning custom properties to atlas tiles.

### `add_navigation_layer(to_position: int = -1) -> void`

Adds a navigation layer to the TileSet at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.
				Navigation layers allow assigning a navigable area to atlas tiles.

### `add_occlusion_layer(to_position: int = -1) -> void`

Adds an occlusion layer to the TileSet at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.
				Occlusion layers allow assigning occlusion polygons to atlas tiles.

### `add_pattern(pattern: TileMapPattern, index: int = -1) -> int`

Adds a `TileMapPattern` to be stored in the TileSet resource. If provided, insert it at the given `index`.

### `add_physics_layer(to_position: int = -1) -> void`

Adds a physics layer to the TileSet at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.
				Physics layers allow assigning collision polygons to atlas tiles.

### `add_source(source: TileSetSource, atlas_source_id_override: int = -1) -> int`

Adds a `TileSetSource` to the TileSet. If `atlas_source_id_override` is not -1, also set its source ID. Otherwise, a unique identifier is automatically generated.
				The function returns the added source ID or -1 if the source could not be added.
				**Warning:** A source cannot belong to two TileSets at the same time. If the added source was attached to another `TileSet`, it will be removed from that one.

### `add_terrain(terrain_set: int, to_position: int = -1) -> void`

Adds a new terrain to the given terrain set `terrain_set` at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.

### `add_terrain_set(to_position: int = -1) -> void`

Adds a new terrain set at the given position `to_position` in the array. If `to_position` is -1, adds it at the end of the array.

### `cleanup_invalid_tile_proxies() -> void`

Clears tile proxies pointing to invalid tiles.

### `clear_terrains(terrain_set: int) -> void`

Clears all terrain properties for the given terrain set.

### `clear_tile_proxies() -> void`

Clears all tile proxies.

### `get_alternative_level_tile_proxy(source_from: int, coords_from: Vector2i, alternative_from: int) -> Array`

Returns the alternative-level proxy for the given identifiers. The returned array contains the three proxie's target identifiers (source ID, atlas coords ID and alternative tile ID).
				If the TileSet has no proxy for the given identifiers, returns an empty Array.

### `get_coords_level_tile_proxy(source_from: int, coords_from: Vector2i) -> Array`

Returns the coordinate-level proxy for the given identifiers. The returned array contains the two target identifiers of the proxy (source ID and atlas coordinates ID).
				If the TileSet has no proxy for the given identifiers, returns an empty Array.

### `get_custom_data_layer_by_name(layer_name: String) -> int`
- 限定：qualifiers=const

Returns the index of the custom data layer identified by the given name.

### `get_custom_data_layer_name(layer_index: int) -> String`
- 限定：qualifiers=const

Returns the name of the custom data layer identified by the given index.

### `get_custom_data_layer_type(layer_index: int) -> int`
- 限定：qualifiers=const

Returns the type of the custom data layer identified by the given index.

### `get_custom_data_layers_count() -> int`
- 限定：qualifiers=const

Returns the custom data layers count.

### `get_navigation_layer_layer_value(layer_index: int, layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified navigation layer of the TileSet navigation data layer identified by the given `layer_index` is enabled, given a navigation_layers `layer_number` between 1 and 32.

### `get_navigation_layer_layers(layer_index: int) -> int`
- 限定：qualifiers=const

Returns the navigation layers (as in the Navigation server) of the given TileSet navigation layer.

### `get_navigation_layers_count() -> int`
- 限定：qualifiers=const

Returns the navigation layers count.

### `get_next_source_id() -> int`
- 限定：qualifiers=const

Returns a new unused source ID. This generated ID is the same that a call to `add_source` would return.

### `get_occlusion_layer_light_mask(layer_index: int) -> int`
- 限定：qualifiers=const

Returns the light mask of the occlusion layer.

### `get_occlusion_layer_sdf_collision(layer_index: int) -> bool`
- 限定：qualifiers=const

Returns if the occluders from this layer use `sdf_collision`.

### `get_occlusion_layers_count() -> int`
- 限定：qualifiers=const

Returns the occlusion layers count.

### `get_pattern(index: int = -1) -> TileMapPattern`

Returns the `TileMapPattern` at the given `index`.

### `get_patterns_count() -> int`

Returns the number of `TileMapPattern` this tile set handles.

### `get_physics_layer_collision_layer(layer_index: int) -> int`
- 限定：qualifiers=const

Returns the collision layer (as in the physics server) bodies on the given TileSet's physics layer are in.

### `get_physics_layer_collision_mask(layer_index: int) -> int`
- 限定：qualifiers=const

Returns the collision mask of bodies on the given TileSet's physics layer.

### `get_physics_layer_collision_priority(layer_index: int) -> float`
- 限定：qualifiers=const

Returns the collision priority of bodies on the given TileSet's physics layer.

### `get_physics_layer_physics_material(layer_index: int) -> PhysicsMaterial`
- 限定：qualifiers=const

Returns the physics material of bodies on the given TileSet's physics layer.

### `get_physics_layers_count() -> int`
- 限定：qualifiers=const

Returns the physics layers count.

### `get_source(source_id: int) -> TileSetSource`
- 限定：qualifiers=const

Returns the `TileSetSource` with ID `source_id`.

### `get_source_count() -> int`
- 限定：qualifiers=const

Returns the number of `TileSetSource` in this TileSet.

### `get_source_id(index: int) -> int`
- 限定：qualifiers=const

Returns the source ID for source with index `index`.

### `get_source_level_tile_proxy(source_from: int) -> int`

Returns the source-level proxy for the given source identifier.
				If the TileSet has no proxy for the given identifier, returns -1.

### `get_terrain_color(terrain_set: int, terrain_index: int) -> Color`
- 限定：qualifiers=const

Returns a terrain's color.

### `get_terrain_name(terrain_set: int, terrain_index: int) -> String`
- 限定：qualifiers=const

Returns a terrain's name.

### `get_terrain_set_mode(terrain_set: int) -> int`
- 限定：qualifiers=const

Returns a terrain set mode.

### `get_terrain_sets_count() -> int`
- 限定：qualifiers=const

Returns the terrain sets count.

### `get_terrains_count(terrain_set: int) -> int`
- 限定：qualifiers=const

Returns the number of terrains in the given terrain set.

### `has_alternative_level_tile_proxy(source_from: int, coords_from: Vector2i, alternative_from: int) -> bool`

Returns if there is an alternative-level proxy for the given identifiers.

### `has_coords_level_tile_proxy(source_from: int, coords_from: Vector2i) -> bool`

Returns if there is a coodinates-level proxy for the given identifiers.

### `has_custom_data_layer_by_name(layer_name: String) -> bool`
- 限定：qualifiers=const

Returns if there is a custom data layer named `layer_name`.

### `has_source(source_id: int) -> bool`
- 限定：qualifiers=const

Returns if this TileSet has a source for the given source ID.

### `has_source_level_tile_proxy(source_from: int) -> bool`

Returns if there is a source-level proxy for the given source ID.

### `map_tile_proxy(source_from: int, coords_from: Vector2i, alternative_from: int) -> Array`
- 限定：qualifiers=const

According to the configured proxies, maps the provided identifiers to a new set of identifiers. The source ID, atlas coordinates ID and alternative tile ID are returned as a 3 elements Array.
				This function first look for matching alternative-level proxies, then coordinates-level proxies, then source-level proxies.
				If no proxy corresponding to provided identifiers are found, returns the same values the ones used as arguments.

### `move_custom_data_layer(layer_index: int, to_position: int) -> void`

Moves the custom data layer at index `layer_index` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `move_navigation_layer(layer_index: int, to_position: int) -> void`

Moves the navigation layer at index `layer_index` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `move_occlusion_layer(layer_index: int, to_position: int) -> void`

Moves the occlusion layer at index `layer_index` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `move_physics_layer(layer_index: int, to_position: int) -> void`

Moves the physics layer at index `layer_index` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `move_terrain(terrain_set: int, terrain_index: int, to_position: int) -> void`

Moves the terrain at index `terrain_index` for terrain set `terrain_set` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `move_terrain_set(terrain_set: int, to_position: int) -> void`

Moves the terrain set at index `terrain_set` to the given position `to_position` in the array. Also updates the atlas tiles accordingly.

### `remove_alternative_level_tile_proxy(source_from: int, coords_from: Vector2i, alternative_from: int) -> void`

Removes an alternative-level proxy for the given identifiers.

### `remove_coords_level_tile_proxy(source_from: int, coords_from: Vector2i) -> void`

Removes a coordinates-level proxy for the given identifiers.

### `remove_custom_data_layer(layer_index: int) -> void`

Removes the custom data layer at index `layer_index`. Also updates the atlas tiles accordingly.

### `remove_navigation_layer(layer_index: int) -> void`

Removes the navigation layer at index `layer_index`. Also updates the atlas tiles accordingly.

### `remove_occlusion_layer(layer_index: int) -> void`

Removes the occlusion layer at index `layer_index`. Also updates the atlas tiles accordingly.

### `remove_pattern(index: int) -> void`

Remove the `TileMapPattern` at the given index.

### `remove_physics_layer(layer_index: int) -> void`

Removes the physics layer at index `layer_index`. Also updates the atlas tiles accordingly.

### `remove_source(source_id: int) -> void`

Removes the source with the given source ID.

### `remove_source_level_tile_proxy(source_from: int) -> void`

Removes a source-level tile proxy.

### `remove_terrain(terrain_set: int, terrain_index: int) -> void`

Removes the terrain at index `terrain_index` in the given terrain set `terrain_set`. Also updates the atlas tiles accordingly.

### `remove_terrain_set(terrain_set: int) -> void`

Removes the terrain set at index `terrain_set`. Also updates the atlas tiles accordingly.

### `set_alternative_level_tile_proxy(source_from: int, coords_from: Vector2i, alternative_from: int, source_to: int, coords_to: Vector2i, alternative_to: int) -> void`

Create an alternative-level proxy for the given identifiers. A proxy will map set of tile identifiers to another set of identifiers.
				Proxied tiles can be automatically replaced in TileMapLayer nodes using the editor.

### `set_coords_level_tile_proxy(source_from: int, coords_from: Vector2i, source_to: int, coords_to: Vector2i) -> void`

Creates a coordinates-level proxy for the given identifiers. A proxy will map set of tile identifiers to another set of identifiers. The alternative tile ID is kept the same when using coordinates-level proxies.
				Proxied tiles can be automatically replaced in TileMapLayer nodes using the editor.

### `set_custom_data_layer_name(layer_index: int, layer_name: String) -> void`

Sets the name of the custom data layer identified by the given index. Names are identifiers of the layer therefore if the name is already taken it will fail and raise an error.

### `set_custom_data_layer_type(layer_index: int, layer_type: int) -> void`

Sets the type of the custom data layer identified by the given index.

### `set_navigation_layer_layer_value(layer_index: int, layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified navigation layer of the TileSet navigation data layer identified by the given `layer_index`, given a navigation_layers `layer_number` between 1 and 32.

### `set_navigation_layer_layers(layer_index: int, layers: int) -> void`

Sets the navigation layers (as in the navigation server) for navigation regions in the given TileSet navigation layer.

### `set_occlusion_layer_light_mask(layer_index: int, light_mask: int) -> void`

Sets the occlusion layer (as in the rendering server) for occluders in the given TileSet occlusion layer.

### `set_occlusion_layer_sdf_collision(layer_index: int, sdf_collision: bool) -> void`

Enables or disables SDF collision for occluders in the given TileSet occlusion layer.

### `set_physics_layer_collision_layer(layer_index: int, layer: int) -> void`

Sets the collision layer (as in the physics server) for bodies in the given TileSet physics layer.

### `set_physics_layer_collision_mask(layer_index: int, mask: int) -> void`

Sets the collision mask for bodies in the given TileSet physics layer.

### `set_physics_layer_collision_priority(layer_index: int, priority: float) -> void`

Sets the collision priority for bodies in the given TileSet physics layer.

### `set_physics_layer_physics_material(layer_index: int, physics_material: PhysicsMaterial) -> void`

Sets the physics material for bodies in the given TileSet physics layer.

### `set_source_id(source_id: int, new_source_id: int) -> void`

Changes a source's ID.

### `set_source_level_tile_proxy(source_from: int, source_to: int) -> void`

Creates a source-level proxy for the given source ID. A proxy will map set of tile identifiers to another set of identifiers. Both the atlas coordinates ID and the alternative tile ID are kept the same when using source-level proxies.
				Proxied tiles can be automatically replaced in TileMapLayer nodes using the editor.

### `set_terrain_color(terrain_set: int, terrain_index: int, color: Color) -> void`

Sets a terrain's color. This color is used for identifying the different terrains in the TileSet editor.

### `set_terrain_name(terrain_set: int, terrain_index: int, name: String) -> void`

Sets a terrain's name.

### `set_terrain_set_mode(terrain_set: int, mode: int) -> void`

Sets a terrain mode. Each mode determines which bits of a tile shape is used to match the neighboring tiles' terrains.

## 枚举

### `TileShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TILE_SHAPE_SQUARE` |  |
| `1` | `TILE_SHAPE_ISOMETRIC` |  |
| `2` | `TILE_SHAPE_HALF_OFFSET_SQUARE` |  |
| `3` | `TILE_SHAPE_HEXAGON` |  |

### `TileLayout`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TILE_LAYOUT_STACKED` |  |
| `1` | `TILE_LAYOUT_STACKED_OFFSET` |  |
| `2` | `TILE_LAYOUT_STAIRS_RIGHT` |  |
| `3` | `TILE_LAYOUT_STAIRS_DOWN` |  |
| `4` | `TILE_LAYOUT_DIAMOND_RIGHT` |  |
| `5` | `TILE_LAYOUT_DIAMOND_DOWN` |  |

### `TileOffsetAxis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TILE_OFFSET_AXIS_HORIZONTAL` |  |
| `1` | `TILE_OFFSET_AXIS_VERTICAL` |  |

### `CellNeighbor`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CELL_NEIGHBOR_RIGHT_SIDE` |  |
| `1` | `CELL_NEIGHBOR_RIGHT_CORNER` |  |
| `2` | `CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE` |  |
| `3` | `CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER` |  |
| `4` | `CELL_NEIGHBOR_BOTTOM_SIDE` |  |
| `5` | `CELL_NEIGHBOR_BOTTOM_CORNER` |  |
| `6` | `CELL_NEIGHBOR_BOTTOM_LEFT_SIDE` |  |
| `7` | `CELL_NEIGHBOR_BOTTOM_LEFT_CORNER` |  |
| `8` | `CELL_NEIGHBOR_LEFT_SIDE` |  |
| `9` | `CELL_NEIGHBOR_LEFT_CORNER` |  |
| `10` | `CELL_NEIGHBOR_TOP_LEFT_SIDE` |  |
| `11` | `CELL_NEIGHBOR_TOP_LEFT_CORNER` |  |
| `12` | `CELL_NEIGHBOR_TOP_SIDE` |  |
| `13` | `CELL_NEIGHBOR_TOP_CORNER` |  |
| `14` | `CELL_NEIGHBOR_TOP_RIGHT_SIDE` |  |
| `15` | `CELL_NEIGHBOR_TOP_RIGHT_CORNER` |  |

### `TerrainMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TERRAIN_MODE_MATCH_CORNERS_AND_SIDES` |  |
| `1` | `TERRAIN_MODE_MATCH_CORNERS` |  |
| `2` | `TERRAIN_MODE_MATCH_SIDES` |  |

## 教程链接

- [Using Tilemaps](None)
- [2D Platformer Demo](None)
- [2D Isometric Demo](None)
- [2D Hexagonal Demo](None)
- [2D Grid-based Navigation with AStarGrid2D Demo](None)
- [2D Role Playing Game (RPG) Demo](None)
- [2D Kinematic Character Demo](None)

