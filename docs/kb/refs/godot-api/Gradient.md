# Gradient

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Gradient` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Gradient.md`

**摘要**：A color transition.

## 描述

This resource describes a color transition by defining a set of colored points and how to interpolate between them.
		See also `Curve` which supports more complex easing methods, but does not support colors.

## 属性

- **`colors`** `PackedColorArray` = `PackedColorArray(0, 0, 0, 1, 1, 1, 1, 1)`
  - 其它属性：getter=get_colors · setter=set_colors
- **`interpolation_color_space`** `int` = `0` · 枚举 `Gradient.ColorSpace`
  - 其它属性：getter=get_interpolation_color_space · setter=set_interpolation_color_space
- **`interpolation_mode`** `int` = `0` · 枚举 `Gradient.InterpolationMode`
  - 其它属性：getter=get_interpolation_mode · setter=set_interpolation_mode
- **`offsets`** `PackedFloat32Array` = `PackedFloat32Array(0, 1)`
  - 其它属性：getter=get_offsets · setter=set_offsets

## 方法

### `add_point(offset: float, color: Color) -> void`

Adds the specified color to the gradient, with the specified offset.

### `get_color(point: int) -> Color`

Returns the color of the gradient color at index `point`.

### `get_offset(point: int) -> float`

Returns the offset of the gradient color at index `point`.

### `get_point_count() -> int`
- 限定：qualifiers=const

Returns the number of colors in the gradient.

### `remove_point(point: int) -> void`

Removes the color at index `point`.

### `reverse() -> void`

Reverses/mirrors the gradient.
				**Note:** This method mirrors all points around the middle of the gradient, which may produce unexpected results when `interpolation_mode` is set to `GRADIENT_INTERPOLATE_CONSTANT`.

### `sample(offset: float) -> Color`

Returns the interpolated color specified by `offset`. `offset` should be between `0.0` and `1.0` (inclusive). Using a value lower than `0.0` will return the same color as `0.0`, and using a value higher than `1.0` will return the same color as `1.0`. If your input value is not within this range, consider using `@GlobalScope.remap` on the input value with output values set to `0.0` and `1.0`.

### `set_color(point: int, color: Color) -> void`

Sets the color of the gradient color at index `point`.

### `set_offset(point: int, offset: float) -> void`

Sets the offset for the gradient color at index `point`.

## 枚举

### `InterpolationMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GRADIENT_INTERPOLATE_LINEAR` |  |
| `1` | `GRADIENT_INTERPOLATE_CONSTANT` |  |
| `2` | `GRADIENT_INTERPOLATE_CUBIC` |  |

### `ColorSpace`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GRADIENT_COLOR_SPACE_SRGB` |  |
| `1` | `GRADIENT_COLOR_SPACE_LINEAR_SRGB` |  |
| `2` | `GRADIENT_COLOR_SPACE_OKLAB` |  |

