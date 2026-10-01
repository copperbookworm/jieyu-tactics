# AnimationNodeBlendSpace1D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeBlendSpace1D` → `AnimationRootNode` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeBlendSpace1D.md`

**摘要**：A set of `AnimationRootNode`s placed on a virtual axis, crossfading between the two adjacent ones. Used by `AnimationTree`.

## 描述

A resource used by `AnimationNodeBlendTree`.
		`AnimationNodeBlendSpace1D` represents a virtual axis on which any type of `AnimationRootNode`s can be added using `add_blend_point`. Outputs the linear blend of the two `AnimationRootNode`s adjacent to the current value.
		You can set the extents of the axis with `min_space` and `max_space`.

## 属性

- **`blend_mode`** `int` = `0` · 枚举 `AnimationNodeBlendSpace1D.BlendMode`
  - 其它属性：getter=get_blend_mode · setter=set_blend_mode
- **`cyclic_length`** `float` = `0.0`
  - 其它属性：getter=get_cyclic_length · setter=set_cyclic_length
- **`max_space`** `float` = `1.0`
  - 其它属性：getter=get_max_space · setter=set_max_space
- **`min_space`** `float` = `-1.0`
  - 其它属性：getter=get_min_space · setter=set_min_space
- **`snap`** `float` = `0.1`
  - 其它属性：getter=get_snap · setter=set_snap
- **`sync`** `bool`
  - 其它属性：deprecated=Use [member sync_mode] instead. · getter=is_using_sync · setter=set_use_sync
- **`sync_mode`** `int` = `0` · 枚举 `AnimationNodeBlendSpace1D.SyncMode`
  - 其它属性：getter=get_sync_mode · setter=set_sync_mode
- **`value_label`** `String` = `"value"`
  - 其它属性：getter=get_value_label · setter=set_value_label

## 方法

### `add_blend_point(node: AnimationRootNode, pos: float, at_index: int = -1, name: StringName = &"") -> void`

Adds a new point with `name` that represents a `node` on the virtual axis at a given position set by `pos`. You can insert it at a specific index using the `at_index` argument. If you use the default value for `at_index`, the point is inserted at the end of the blend points array.
				**Note:** If no name is provided, safe index is used as reference. In the future, empty names will be deprecated, so explicitly passing a name is recommended.

### `find_blend_point_by_name(name: StringName) -> int`
- 限定：qualifiers=const

Returns the index of the blend point with the given `name`. Returns `-1` if no blend point with that name is found.

### `get_blend_point_count() -> int`
- 限定：qualifiers=const

Returns the number of points on the blend axis.

### `get_blend_point_name(point: int) -> StringName`
- 限定：qualifiers=const

Returns the name of the blend point at index `point`.

### `get_blend_point_node(point: int) -> AnimationRootNode`
- 限定：qualifiers=const

Returns the `AnimationNode` referenced by the point at index `point`.

### `get_blend_point_position(point: int) -> float`
- 限定：qualifiers=const

Returns the position of the point at index `point`.

### `remove_blend_point(point: int) -> void`

Removes the point at index `point` from the blend axis.

### `reorder_blend_point(from_index: int, to_index: int) -> void`

Swaps the blend points at indices `from_index` and `to_index`, exchanging their positions and properties.

### `set_blend_point_name(point: int, name: StringName) -> void`

Sets the name of the blend point at index `point`. If the name conflicts with an existing point, a unique name will be generated automatically.

### `set_blend_point_node(point: int, node: AnimationRootNode) -> void`

Changes the `AnimationNode` referenced by the point at index `point`.

### `set_blend_point_position(point: int, pos: float) -> void`

Updates the position of the point at index `point` on the blend axis.

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

