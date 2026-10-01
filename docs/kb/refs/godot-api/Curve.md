# Curve

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Curve` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Curve.md`

**摘要**：A mathematical curve.

## 描述

This resource describes a mathematical curve by defining a set of points and tangents at each point. By default, it ranges between `0` and `1` on the X and Y axes, but these ranges can be changed.
		Please note that many resources and nodes assume they are given *unit curves*. A unit curve is a curve whose domain (the X axis) is between `0` and `1`. Some examples of unit curve usage are `CPUParticles2D.angle_curve` and `Line2D.width_curve`.

## 属性

- **`bake_resolution`** `int` = `100`
  - 其它属性：getter=get_bake_resolution · setter=set_bake_resolution
- **`max_domain`** `float` = `1.0`
  - 其它属性：getter=get_max_domain · setter=set_max_domain
- **`max_value`** `float` = `1.0`
  - 其它属性：getter=get_max_value · setter=set_max_value
- **`min_domain`** `float` = `0.0`
  - 其它属性：getter=get_min_domain · setter=set_min_domain
- **`min_value`** `float` = `0.0`
  - 其它属性：getter=get_min_value · setter=set_min_value
- **`point_count`** `int` = `0`
  - 其它属性：getter=get_point_count · setter=set_point_count
- **`point_{index}/left_mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`point_{index}/left_tangent`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`point_{index}/position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter= · setter=
- **`point_{index}/right_mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`point_{index}/right_tangent`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `add_point(position: Vector2, left_tangent: float = 0, right_tangent: float = 0, left_mode: int = 0, right_mode: int = 0) -> int`

Adds a point to the curve. For each side, if the `*_mode` is `TANGENT_LINEAR`, the `*_tangent` angle (in degrees) uses the slope of the curve halfway to the adjacent point. Allows custom assignments to the `*_tangent` angle if `*_mode` is set to `TANGENT_FREE`.

### `bake() -> void`

Recomputes the baked cache of points for the curve.

### `clean_dupes() -> void`

Removes duplicate points, i.e. points that are less than 0.00001 units (engine epsilon value) away from their neighbor on the curve.

### `clear_points() -> void`

Removes all points from the curve.

### `get_domain_range() -> float`
- 限定：qualifiers=const

Returns the difference between `min_domain` and `max_domain`.

### `get_point_left_mode(index: int) -> int`
- 限定：qualifiers=const

Returns the left `TangentMode` for the point at `index`.

### `get_point_left_tangent(index: int) -> float`
- 限定：qualifiers=const

Returns the left tangent angle (in degrees) for the point at `index`.

### `get_point_position(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the curve coordinates for the point at `index`.

### `get_point_right_mode(index: int) -> int`
- 限定：qualifiers=const

Returns the right `TangentMode` for the point at `index`.

### `get_point_right_tangent(index: int) -> float`
- 限定：qualifiers=const

Returns the right tangent angle (in degrees) for the point at `index`.

### `get_value_range() -> float`
- 限定：qualifiers=const

Returns the difference between `min_value` and `max_value`.

### `remove_point(index: int) -> void`

Removes the point at `index` from the curve.

### `sample(offset: float) -> float`
- 限定：qualifiers=const

Returns the Y value for the point that would exist at the X position `offset` along the curve.

### `sample_baked(offset: float) -> float`
- 限定：qualifiers=const

Returns the Y value for the point that would exist at the X position `offset` along the curve using the baked cache. Bakes the curve's points if not already baked.

### `set_point_left_mode(index: int, mode: int) -> void`

Sets the left `TangentMode` for the point at `index` to `mode`.

### `set_point_left_tangent(index: int, tangent: float) -> void`

Sets the left tangent angle for the point at `index` to `tangent`.

### `set_point_offset(index: int, offset: float) -> int`

Assigns the horizontal position `offset` to the point at `index`.

### `set_point_right_mode(index: int, mode: int) -> void`

Sets the right `TangentMode` for the point at `index` to `mode`.

### `set_point_right_tangent(index: int, tangent: float) -> void`

Sets the right tangent angle for the point at `index` to `tangent`.

### `set_point_value(index: int, y: float) -> void`

Assigns the vertical position `y` to the point at `index`.

## 信号

### `domain_changed()`

Emitted when `max_domain` or `min_domain` is changed.

### `range_changed()`

Emitted when `max_value` or `min_value` is changed.

## 枚举

### `TangentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TANGENT_FREE` |  |
| `1` | `TANGENT_LINEAR` |  |
| `2` | `TANGENT_MODE_COUNT` |  |

