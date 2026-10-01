# AnimationNodeBlendSpace2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeBlendSpace2D` → `AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeBlendSpace2D.md`

**摘要**：A set of `AnimationRootNode`s placed on 2D coordinates, crossfading between the three adjacent ones. Used by `AnimationTree`.

## 描述

A resource used by `AnimationNodeBlendTree`.
		`AnimationNodeBlendSpace2D` represents a virtual 2D space on which `AnimationRootNode`s are placed. Outputs the linear blend of the three adjacent animations using a `Vector2` weight. Adjacent in this context means the three `AnimationRootNode`s making up the triangle that contains the current value.
		You can add vertices to the blend space with `add_blend_point` and automatically triangulate it by setting `auto_triangles` to `true`. Otherwise, use `add_triangle` and `remove_triangle` to triangulate the blend space by hand.

## 属性

- **`auto_triangles`** `bool` = `true`
  - 其它属性：getter=get_auto_triangles · setter=set_auto_triangles
- **`blend_mode`** `int` = `0` · 枚举 `AnimationNodeBlendSpace2D.BlendMode`
  - 其它属性：getter=get_blend_mode · setter=set_blend_mode
- **`cyclic_length`** `float` = `0.0`
  - 其它属性：getter=get_cyclic_length · setter=set_cyclic_length
- **`max_space`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_max_space · setter=set_max_space
- **`min_space`** `Vector2` = `Vector2(-1, -1)`
  - 其它属性：getter=get_min_space · setter=set_min_space
- **`snap`** `Vector2` = `Vector2(0.1, 0.1)`
  - 其它属性：getter=get_snap · setter=set_snap
- **`sync`** `bool`
  - 其它属性：deprecated=Use [member sync_mode] instead. · getter=is_using_sync · setter=set_use_sync
- **`sync_mode`** `int` = `0` · 枚举 `AnimationNodeBlendSpace2D.SyncMode`
  - 其它属性：getter=get_sync_mode · setter=set_sync_mode
- **`x_label`** `String` = `"x"`
  - 其它属性：getter=get_x_label · setter=set_x_label
- **`y_label`** `String` = `"y"`
  - 其它属性：getter=get_y_label · setter=set_y_label

## 方法

### `add_blend_point(node: AnimationRootNode, pos: Vector2, at_index: int = -1, name: StringName = &"") -> void`

Adds a new point with `name` that represents a `node` at the position set by `pos`. You can insert it at a specific index using the `at_index` argument. If you use the default value for `at_index`, the point is inserted at the end of the blend points array.
				**Note:** If no name is provided, safe index is used as reference. In the future, empty names will be deprecated, so explicitly passing a name is recommended.

### `add_triangle(x: int, y: int, z: int, at_index: int = -1) -> void`

Creates a new triangle using three points `x`, `y`, and `z`. Triangles can overlap. You can insert the triangle at a specific index using the `at_index` argument. If you use the default value for `at_index`, the point is inserted at the end of the blend points array.

### `find_blend_point_by_name(name: StringName) -> int`
- 限定：qualifiers=const

Returns the index of the blend point with the given `name`. Returns `-1` if no blend point with that name is found.

### `get_blend_point_count() -> int`
- 限定：qualifiers=const

Returns the number of points in the blend space.

### `get_blend_point_name(point: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the blend point at index `point`.

### `get_blend_point_node(point: int) -> AnimationRootNode`
- 限定：qualifiers=const

Returns the `AnimationRootNode` referenced by the point at index `point`.

### `get_blend_point_position(point: int) -> Vector2`
- 限定：qualifiers=const

Returns the position of the point at index `point`.

### `get_triangle_count() -> int`
- 限定：qualifiers=const

Returns the number of triangles in the blend space.

### `get_triangle_point(triangle: int, point: int) -> int`

Returns the position of the point at index `point` in the triangle of index `triangle`.

### `remove_blend_point(point: int) -> void`

Removes the point at index `point` from the blend space.

### `remove_triangle(triangle: int) -> void`

Removes the triangle at index `triangle` from the blend space.

### `reorder_blend_point(from_index: int, to_index: int) -> void`

Swaps the blend points at indices `from_index` and `to_index`, exchanging their positions and properties.

### `set_blend_point_name(point: int, name: StringName) -> void`

Sets the name of the blend point at index `point`. If the name conflicts with an existing point, a unique name will be generated automatically.

### `set_blend_point_node(point: int, node: AnimationRootNode) -> void`

Changes the `AnimationNode` referenced by the point at index `point`.

### `set_blend_point_position(point: int, pos: Vector2) -> void`

Updates the position of the point at index `point` in the blend space.

## 信号

### `triangles_updated()`

Emitted every time the blend space's triangles are created, removed, or when one of their vertices changes position.

## 枚举

### `BlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_MODE_INTERPOLATED` |  |
| `1` | `BLEND_MODE_DISCRETE` |  |
| `2` | `BLEND_MODE_DISCRETE_CARRY` |  |

### `SyncMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SYNC_MODE_NONE` |  |
| `1` | `SYNC_MODE_INDEPENDENT` |  |
| `2` | `SYNC_MODE_CYCLIC_MUTABLE` |  |
| `3` | `SYNC_MODE_CYCLIC_CONSTANT` |  |

## 教程链接

- [Using AnimationTree](None)
- [Third Person Shooter (TPS) Demo](None)

