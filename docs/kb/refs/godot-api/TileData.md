# TileData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TileData` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TileData.md`

**摘要**：Settings for a single tile in a `TileSet`.

## 描述

`TileData` object represents a single tile in a `TileSet`. It is usually edited using the tileset editor, but it can be modified at runtime using `TileMapLayer._tile_data_runtime_update`.

## 属性

- **`flip_h`** `bool` = `false`
  - 其它属性：getter=get_flip_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=get_flip_v · setter=set_flip_v
- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · keywords=color, colour · setter=set_modulate
- **`probability`** `float` = `1.0`
  - 其它属性：getter=get_probability · setter=set_probability
- **`terrain`** `int` = `-1`
  - 其它属性：getter=get_terrain · setter=set_terrain
- **`terrain_set`** `int` = `-1`
  - 其它属性：getter=get_terrain_set · setter=set_terrain_set
- **`texture_origin`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_texture_origin · setter=set_texture_origin
- **`transpose`** `bool` = `false`
  - 其它属性：getter=get_transpose · setter=set_transpose
- **`y_sort_origin`** `int` = `0`
  - 其它属性：getter=get_y_sort_origin · setter=set_y_sort_origin
- **`z_index`** `int` = `0`
  - 其它属性：getter=get_z_index · setter=set_z_index

## 方法

### `add_collision_polygon(layer_id: int) -> void`

Adds a collision polygon to the tile on the given TileSet physics layer.

### `add_occluder_polygon(layer_id: int) -> void`

Adds an occlusion polygon to the tile on the TileSet occlusion layer with index `layer_id`.

### `get_collision_polygon_one_way_margin(layer_id: int, polygon_index: int) -> float`
- 限定：qualifiers=const

Returns the one-way margin (for one-way platforms) of the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `get_collision_polygon_points(layer_id: int, polygon_index: int) -> PackedVector2Array`
- 限定：qualifiers=const

Returns the points of the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `get_collision_polygons_count(layer_id: int) -> int`
- 限定：qualifiers=const

Returns how many polygons the tile has for TileSet physics layer with index `layer_id`.

### `get_constant_angular_velocity(layer_id: int) -> float`
- 限定：qualifiers=const

Returns the constant angular velocity applied to objects colliding with this tile.

### `get_constant_linear_velocity(layer_id: int) -> Vector2`
- 限定：qualifiers=const

Returns the constant linear velocity applied to objects colliding with this tile.

### `get_custom_data(layer_name: String) -> Variant`
- 限定：qualifiers=const

Returns the custom data value for custom data layer named `layer_name`. To check if a custom data layer exists, use `has_custom_data`.

### `get_custom_data_by_layer_id(layer_id: int) -> Variant`
- 限定：qualifiers=const

Returns the custom data value for custom data layer with index `layer_id`.

### `get_navigation_polygon(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) -> NavigationPolygon`
- 限定：qualifiers=const

Returns the navigation polygon of the tile for the TileSet navigation layer with index `layer_id`.
				`flip_h`, `flip_v`, and `transpose` allow transforming the returned polygon.

### `get_occluder(layer_id: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) -> OccluderPolygon2D`
- 限定：deprecated=Use [method get_occluder_polygon] instead. · qualifiers=const

Returns the occluder polygon of the tile for the TileSet occlusion layer with index `layer_id`.
				`flip_h`, `flip_v`, and `transpose` allow transforming the returned polygon.

### `get_occluder_polygon(layer_id: int, polygon_index: int, flip_h: bool = false, flip_v: bool = false, transpose: bool = false) -> OccluderPolygon2D`
- 限定：qualifiers=const

Returns the occluder polygon at index `polygon_index` from the TileSet occlusion layer with index `layer_id`.
				The `flip_h`, `flip_v`, and `transpose` parameters can be `true` to transform the returned polygon.

### `get_occluder_polygons_count(layer_id: int) -> int`
- 限定：qualifiers=const

Returns the number of occluder polygons of the tile in the TileSet occlusion layer with index `layer_id`.

### `get_terrain_peering_bit(peering_bit: int) -> int`
- 限定：qualifiers=const

Returns the tile's terrain bit for the given `peering_bit` direction. To check that a direction is valid, use `is_valid_terrain_peering_bit`.

### `has_custom_data(layer_name: String) -> bool`
- 限定：qualifiers=const

Returns whether there exists a custom data layer named `layer_name`.

### `is_collision_polygon_one_way(layer_id: int, polygon_index: int) -> bool`
- 限定：qualifiers=const

Returns whether one-way collisions are enabled for the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `is_valid_terrain_peering_bit(peering_bit: int) -> bool`
- 限定：qualifiers=const

Returns whether the given `peering_bit` direction is valid for this tile.

### `remove_collision_polygon(layer_id: int, polygon_index: int) -> void`

Removes the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `remove_occluder_polygon(layer_id: int, polygon_index: int) -> void`

Removes the polygon at index `polygon_index` for TileSet occlusion layer with index `layer_id`.

### `set_collision_polygon_one_way(layer_id: int, polygon_index: int, one_way: bool) -> void`

Enables/disables one-way collisions on the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `set_collision_polygon_one_way_margin(layer_id: int, polygon_index: int, one_way_margin: float) -> void`

Sets the one-way margin (for one-way platforms) of the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `set_collision_polygon_points(layer_id: int, polygon_index: int, polygon: PackedVector2Array) -> void`

Sets the points of the polygon at index `polygon_index` for TileSet physics layer with index `layer_id`.

### `set_collision_polygons_count(layer_id: int, polygons_count: int) -> void`

Sets the polygons count for TileSet physics layer with index `layer_id`.

### `set_constant_angular_velocity(layer_id: int, velocity: float) -> void`

Sets the constant angular velocity. This does not rotate the tile. This angular velocity is applied to objects colliding with this tile.

### `set_constant_linear_velocity(layer_id: int, velocity: Vector2) -> void`

Sets the constant linear velocity. This does not move the tile. This linear velocity is applied to objects colliding with this tile. This is useful to create conveyor belts.

### `set_custom_data(layer_name: String, value: Variant) -> void`

Sets the tile's custom data value for the TileSet custom data layer with name `layer_name`.

### `set_custom_data_by_layer_id(layer_id: int, value: Variant) -> void`

Sets the tile's custom data value for the TileSet custom data layer with index `layer_id`.

### `set_navigation_polygon(layer_id: int, navigation_polygon: NavigationPolygon) -> void`

Sets the navigation polygon for the TileSet navigation layer with index `layer_id`.

### `set_occluder(layer_id: int, occluder_polygon: OccluderPolygon2D) -> void`
- 限定：deprecated=Use [method set_occluder_polygon] instead.

Sets the occluder for the TileSet occlusion layer with index `layer_id`.

### `set_occluder_polygon(layer_id: int, polygon_index: int, polygon: OccluderPolygon2D) -> void`

Sets the occluder for polygon with index `polygon_index` in the TileSet occlusion layer with index `layer_id`.

### `set_occluder_polygons_count(layer_id: int, polygons_count: int) -> void`

Sets the occluder polygon count in the TileSet occlusion layer with index `layer_id`.

### `set_terrain_peering_bit(peering_bit: int, terrain: int) -> void`

Sets the tile's terrain bit for the given `peering_bit` direction. To check that a direction is valid, use `is_valid_terrain_peering_bit`.

## 信号

### `changed()`

Emitted when any of the properties are changed.

