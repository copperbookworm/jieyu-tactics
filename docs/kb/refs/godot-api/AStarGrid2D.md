# AStarGrid2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AStarGrid2D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AStarGrid2D.md`

**摘要**：An implementation of A* for finding the shortest path between two points on a partial 2D grid.

## 描述

`AStarGrid2D` is a variant of `AStar2D` that is specialized for partial 2D grids. It is simpler to use because it doesn't require you to manually create points and connect them together. This class also supports multiple types of heuristics, modes for diagonal movement, and a jumping mode to speed up calculations.
		To use `AStarGrid2D`, you only need to set the `region` of the grid, optionally set the `cell_size`, and then call the `update` method:
		`codeblocks`
		`gdscript`
		var astar_grid = AStarGrid2D.new()
		astar_grid.region = Rect2i(0, 0, 32, 32)
		astar_grid.cell_size = Vector2(16, 16)
		astar_grid.update()
		print(astar_grid.get_id_path(Vector2i(0, 0), Vector2i(3, 4))) # Prints [(0, 0), (1, 1), (2, 2), (3, 3), (3, 4)]
		print(astar_grid.get_point_path(Vector2i(0, 0), Vector2i(3, 4))) # Prints [(0, 0), (16, 16), (32, 32), (48, 48), (48, 64)]
		
		`csharp`
		AStarGrid2D astarGrid = new AStarGrid2D();
		astarGrid.Region = new Rect2I(0, 0, 32, 32);
		astarGrid.CellSize = new Vector2I(16, 16);
		astarGrid.Update();
		GD.Print(astarGrid.GetIdPath(Vector2I.Zero, new Vector2I(3, 4))); // Prints [(0, 0), (1, 1), (2, 2), (3, 3), (3, 4)]
		GD.Print(astarGrid.GetPointPath(Vector2I.Zero, new Vector2I(3, 4))); // Prints [(0, 0), (16, 16), (32, 32), (48, 48), (48, 64)]
		
		
		To remove a point from the pathfinding grid, it must be set as "solid" with `set_point_solid`.

## 属性

- **`cell_shape`** `int` = `0` · 枚举 `AStarGrid2D.CellShape`
  - 其它属性：getter=get_cell_shape · setter=set_cell_shape
- **`cell_size`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_cell_size · setter=set_cell_size
- **`default_compute_heuristic`** `int` = `0` · 枚举 `AStarGrid2D.Heuristic`
  - 其它属性：getter=get_default_compute_heuristic · setter=set_default_compute_heuristic
- **`default_estimate_heuristic`** `int` = `0` · 枚举 `AStarGrid2D.Heuristic`
  - 其它属性：getter=get_default_estimate_heuristic · setter=set_default_estimate_heuristic
- **`diagonal_mode`** `int` = `0` · 枚举 `AStarGrid2D.DiagonalMode`
  - 其它属性：getter=get_diagonal_mode · setter=set_diagonal_mode
- **`jumping_enabled`** `bool` = `false`
  - 其它属性：getter=is_jumping_enabled · setter=set_jumping_enabled
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`region`** `Rect2i` = `Rect2i(0, 0, 0, 0)`
  - 其它属性：getter=get_region · setter=set_region
- **`size`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：deprecated=Use [member region] instead. · getter=get_size · setter=set_size

## 方法

### `_compute_cost(from_id: Vector2i, to_id: Vector2i) -> float`
- 限定：qualifiers=virtual const

Called when computing the cost between two connected points.
				Note that this function is hidden in the default `AStarGrid2D` class.

### `_estimate_cost(from_id: Vector2i, end_id: Vector2i) -> float`
- 限定：qualifiers=virtual const

Called when estimating the cost between a point and the path's ending point.
				Note that this function is hidden in the default `AStarGrid2D` class.

### `clear() -> void`

Clears the grid and sets the `region` to `Rect2i(0, 0, 0, 0)`.

### `fill_solid_region(region: Rect2i, solid: bool = true) -> void`

Fills the given `region` on the grid with the specified value for the solid flag.
				**Note:** Calling `update` is not needed after the call of this function.

### `fill_weight_scale_region(region: Rect2i, weight_scale: float) -> void`

Fills the given `region` on the grid with the specified value for the weight scale.
				**Note:** Calling `update` is not needed after the call of this function.

### `get_id_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false) -> Vector2i[]`

Returns an array with the IDs of the points that form the path found by AStar2D between the given points. The array is ordered from the starting point to the ending point of the path.
				If `from_id` point is disabled, returns an empty array (even if `from_id == to_id`).
				If `from_id` point is not disabled, there is no valid path to the target, and `allow_partial_path` is `true`, returns a path to the point closest to the target that can be reached.
				**Note:** When `allow_partial_path` is `true` and `to_id` is solid the search may take an unusually long time to finish.

### `get_point_data_in_region(region: Rect2i) -> Dictionary[]`
- 限定：qualifiers=const

Returns an array of dictionaries with point data (`id`: `Vector2i`, `position`: `Vector2`, `solid`: `bool`, `weight_scale`: `float`) within a `region`.

### `get_point_path(from_id: Vector2i, to_id: Vector2i, allow_partial_path: bool = false) -> PackedVector2Array`

Returns an array with the points that are in the path found by `AStarGrid2D` between the given points. The array is ordered from the starting point to the ending point of the path.
				If `from_id` point is disabled, returns an empty array (even if `from_id == to_id`).
				If `from_id` point is not disabled, there is no valid path to the target, and `allow_partial_path` is `true`, returns a path to the point closest to the target that can be reached.
				**Note:** This method is not thread-safe; it can only be used from a single `Thread` at a given time. Consider using `Mutex` to ensure exclusive access to one thread to avoid race conditions.
				Additionally, when `allow_partial_path` is `true` and `to_id` is solid the search may take an unusually long time to finish.

### `get_point_position(id: Vector2i) -> Vector2`
- 限定：qualifiers=const

Returns the position of the point associated with the given `id`.

### `get_point_weight_scale(id: Vector2i) -> float`
- 限定：qualifiers=const

Returns the weight scale of the point associated with the given `id`.

### `is_dirty() -> bool`
- 限定：qualifiers=const

Indicates that the grid parameters were changed and `update` needs to be called.

### `is_in_bounds(x: int, y: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the `x` and `y` is a valid grid coordinate (id), i.e. if it is inside `region`. Equivalent to `region.has_point(Vector2i(x, y))`.

### `is_in_boundsv(id: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if the `id` vector is a valid grid coordinate, i.e. if it is inside `region`. Equivalent to `region.has_point(id)`.

### `is_point_solid(id: Vector2i) -> bool`
- 限定：qualifiers=const

Returns `true` if a point is disabled for pathfinding. By default, all points are enabled.

### `set_point_solid(id: Vector2i, solid: bool = true) -> void`

Disables or enables the specified point for pathfinding. Useful for making an obstacle. By default, all points are enabled.
				**Note:** Calling `update` is not needed after the call of this function.

### `set_point_weight_scale(id: Vector2i, weight_scale: float) -> void`

Sets the `weight_scale` for the point with the given `id`. The `weight_scale` is multiplied by the result of `_compute_cost` when determining the overall cost of traveling across a segment from a neighboring point to this point.
				**Note:** Calling `update` is not needed after the call of this function.

### `update() -> void`

Updates the internal state of the grid according to the parameters to prepare it to search the path. Needs to be called if parameters like `region`, `cell_size` or `offset` are changed. `is_dirty` will return `true` if this is the case and this needs to be called.
				**Note:** All point data (solidity and weight scale) will be cleared.

## 枚举

### `Heuristic`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HEURISTIC_EUCLIDEAN` |  |
| `1` | `HEURISTIC_MANHATTAN` |  |
| `2` | `HEURISTIC_OCTILE` |  |
| `3` | `HEURISTIC_CHEBYSHEV` |  |
| `4` | `HEURISTIC_MAX` |  |

### `DiagonalMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DIAGONAL_MODE_ALWAYS` |  |
| `1` | `DIAGONAL_MODE_NEVER` |  |
| `2` | `DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE` |  |
| `3` | `DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES` |  |
| `4` | `DIAGONAL_MODE_MAX` |  |

### `CellShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CELL_SHAPE_SQUARE` |  |
| `1` | `CELL_SHAPE_ISOMETRIC_RIGHT` |  |
| `2` | `CELL_SHAPE_ISOMETRIC_DOWN` |  |
| `3` | `CELL_SHAPE_MAX` |  |

## 教程链接

- [Grid-based Navigation with AStarGrid2D Demo](None)

