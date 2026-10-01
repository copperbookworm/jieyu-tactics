# Line2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Line2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Line2D.md`

**摘要**：A 2D polyline that can optionally be textured.

## 描述

This node draws a 2D polyline, i.e. a shape consisting of several points connected by segments. `Line2D` is not a mathematical polyline, i.e. the segments are not infinitely thin. It is intended for rendering and it can be colored and optionally textured.
		**Warning:** Certain configurations may be impossible to draw nicely, such as very sharp angles. In these situations, the node uses fallback drawing logic to look decent.
		**Note:** `Line2D` is drawn using a 2D mesh.

## 属性

- **`antialiased`** `bool` = `false`
  - 其它属性：getter=get_antialiased · setter=set_antialiased
- **`begin_cap_mode`** `int` = `0` · 枚举 `Line2D.LineCapMode`
  - 其它属性：getter=get_begin_cap_mode · setter=set_begin_cap_mode
- **`closed`** `bool` = `false`
  - 其它属性：getter=is_closed · setter=set_closed
- **`default_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_default_color · setter=set_default_color
- **`end_cap_mode`** `int` = `0` · 枚举 `Line2D.LineCapMode`
  - 其它属性：getter=get_end_cap_mode · setter=set_end_cap_mode
- **`gradient`** `Gradient`
  - 其它属性：getter=get_gradient · setter=set_gradient
- **`joint_mode`** `int` = `0` · 枚举 `Line2D.LineJointMode`
  - 其它属性：getter=get_joint_mode · setter=set_joint_mode
- **`points`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_points · setter=set_points
- **`round_precision`** `int` = `8`
  - 其它属性：getter=get_round_precision · setter=set_round_precision
- **`sharp_limit`** `float` = `2.0`
  - 其它属性：getter=get_sharp_limit · setter=set_sharp_limit
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_mode`** `int` = `0` · 枚举 `Line2D.LineTextureMode`
  - 其它属性：getter=get_texture_mode · setter=set_texture_mode
- **`width`** `float` = `10.0`
  - 其它属性：getter=get_width · setter=set_width
- **`width_curve`** `Curve`
  - 其它属性：getter=get_curve · setter=set_curve

## 方法

### `add_point(position: Vector2, index: int = -1) -> void`

Adds a point with the specified `position` relative to the polyline's own position. If no `index` is provided, the new point will be added to the end of the points array.
				If `index` is given, the new point is inserted before the existing point identified by index `index`. The indices of the points after the new point get increased by 1. The provided `index` must not exceed the number of existing points in the polyline. See `get_point_count`.

### `clear_points() -> void`

Removes all points from the polyline, making it empty.

### `get_point_count() -> int`
- 限定：qualifiers=const

Returns the number of points in the polyline.

### `get_point_position(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the position of the point at index `index`.

### `remove_point(index: int) -> void`

Removes the point at index `index` from the polyline.

### `set_point_position(index: int, position: Vector2) -> void`

Overwrites the position of the point at the given `index` with the supplied `position`.

## 枚举

### `LineJointMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LINE_JOINT_SHARP` |  |
| `1` | `LINE_JOINT_BEVEL` |  |
| `2` | `LINE_JOINT_ROUND` |  |

### `LineCapMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LINE_CAP_NONE` |  |
| `1` | `LINE_CAP_BOX` |  |
| `2` | `LINE_CAP_ROUND` |  |

### `LineTextureMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LINE_TEXTURE_NONE` |  |
| `1` | `LINE_TEXTURE_TILE` |  |
| `2` | `LINE_TEXTURE_STRETCH` |  |

## 教程链接

- [Matrix Transform Demo](None)
- [2.5D Game Demo](None)

