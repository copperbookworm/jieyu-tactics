# TileMapPattern

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TileMapPattern` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TileMapPattern.md`

**摘要**：Holds a pattern to be copied from or pasted into `TileMap`s.

## 描述

This resource holds a set of cells to help bulk manipulations of `TileMap`.
		A pattern always starts at the `(0, 0)` coordinates and cannot have cells with negative coordinates.

## 方法

### `get_cell_alternative_tile(coords: Vector2i) -> int`
- 限定：qualifiers=const

Returns the tile alternative ID of the cell at `coords`.

### `get_cell_atlas_coords(coords: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns the tile atlas coordinates ID of the cell at `coords`.

### `get_cell_source_id(coords: Vector2i) -> int`
- 限定：qualifiers=const

Returns the tile source ID of the cell at `coords`.

### `get_size() -> Vector2i`
- 限定：qualifiers=const

Returns the size, in cells, of the pattern.

### `get_used_cells() -> Vector2i[]`
- 限定：qualifiers=const

Returns the list of used cell coordinates in the pattern.

### `has_cell(coords: Vector2i) -> bool`
- 限定：qualifiers=const

Returns whether the pattern has a tile at the given coordinates.

### `is_empty() -> bool`
- 限定：qualifiers=const

Returns whether the pattern is empty or not.

### `remove_cell(coords: Vector2i, update_size: bool) -> void`

Remove the cell at the given coordinates.

### `set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = -1) -> void`

Sets the tile identifiers for the cell at coordinates `coords`. See `TileMap.set_cell`.

### `set_size(size: Vector2i) -> void`

Sets the size of the pattern.

