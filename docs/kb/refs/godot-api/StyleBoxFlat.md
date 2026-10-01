# StyleBoxFlat

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StyleBoxFlat` → `StyleBox` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StyleBoxFlat.md`

**摘要**：A customizable `StyleBox` that doesn't use a texture.

## 描述

By configuring various properties of this style box, you can achieve many common looks without the need of a texture. This includes optionally rounded borders, antialiasing, shadows, and skew.
		Setting corner radius to high values is allowed. As soon as corners overlap, the stylebox will switch to a relative system:
		`lang=text`
		height = 30
		corner_radius_top_left = 50
		corner_radius_bottom_left = 100
		
		The relative system now would take the 1:2 ratio of the two left corners to calculate the actual corner width. Both corners added will **never** be more than the height. Result:
		`lang=text`
		corner_radius_top_left: 10
		corner_radius_bottom_left: 20

## 属性

- **`anti_aliasing`** `bool` = `true`
  - 其它属性：getter=is_anti_aliased · setter=set_anti_aliased
- **`anti_aliasing_size`** `float` = `1.0`
  - 其它属性：getter=get_aa_size · setter=set_aa_size
- **`bg_color`** `Color` = `Color(0.6, 0.6, 0.6, 1)`
  - 其它属性：getter=get_bg_color · setter=set_bg_color
- **`border_blend`** `bool` = `false`
  - 其它属性：getter=get_border_blend · setter=set_border_blend
- **`border_color`** `Color` = `Color(0.8, 0.8, 0.8, 1)`
  - 其它属性：getter=get_border_color · setter=set_border_color
- **`border_width_bottom`** `int` = `0`
  - 其它属性：getter=get_border_width · setter=set_border_width
- **`border_width_left`** `int` = `0`
  - 其它属性：getter=get_border_width · setter=set_border_width
- **`border_width_right`** `int` = `0`
  - 其它属性：getter=get_border_width · setter=set_border_width
- **`border_width_top`** `int` = `0`
  - 其它属性：getter=get_border_width · setter=set_border_width
- **`corner_detail`** `int` = `8`
  - 其它属性：getter=get_corner_detail · setter=set_corner_detail
- **`corner_radius_bottom_left`** `int` = `0`
  - 其它属性：getter=get_corner_radius · setter=set_corner_radius
- **`corner_radius_bottom_right`** `int` = `0`
  - 其它属性：getter=get_corner_radius · setter=set_corner_radius
- **`corner_radius_top_left`** `int` = `0`
  - 其它属性：getter=get_corner_radius · setter=set_corner_radius
- **`corner_radius_top_right`** `int` = `0`
  - 其它属性：getter=get_corner_radius · setter=set_corner_radius
- **`draw_center`** `bool` = `true`
  - 其它属性：getter=is_draw_center_enabled · setter=set_draw_center
- **`expand_margin_bottom`** `float` = `0.0`
  - 其它属性：getter=get_expand_margin · setter=set_expand_margin
- **`expand_margin_left`** `float` = `0.0`
  - 其它属性：getter=get_expand_margin · setter=set_expand_margin
- **`expand_margin_right`** `float` = `0.0`
  - 其它属性：getter=get_expand_margin · setter=set_expand_margin
- **`expand_margin_top`** `float` = `0.0`
  - 其它属性：getter=get_expand_margin · setter=set_expand_margin
- **`shadow_color`** `Color` = `Color(0, 0, 0, 0.6)`
  - 其它属性：getter=get_shadow_color · setter=set_shadow_color
- **`shadow_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_shadow_offset · setter=set_shadow_offset
- **`shadow_size`** `int` = `0`
  - 其它属性：getter=get_shadow_size · setter=set_shadow_size
- **`skew`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_skew · setter=set_skew

## 方法

### `get_border_width(margin: int) -> int`
- 限定：qualifiers=const

Returns the specified `Side`'s border width.

### `get_border_width_min() -> int`
- 限定：qualifiers=const

Returns the smallest border width out of all four borders.

### `get_corner_radius(corner: int) -> int`
- 限定：qualifiers=const

Returns the given `corner`'s radius.

### `get_expand_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the size of the specified `Side`'s expand margin.

### `set_border_width(margin: int, width: int) -> void`

Sets the specified `Side`'s border width to `width` pixels.

### `set_border_width_all(width: int) -> void`

Sets the border width to `width` pixels for all sides.

### `set_corner_radius(corner: int, radius: int) -> void`

Sets the corner radius to `radius` pixels for the given `corner`.

### `set_corner_radius_all(radius: int) -> void`

Sets the corner radius to `radius` pixels for all corners.

### `set_expand_margin(margin: int, size: float) -> void`

Sets the expand margin to `size` pixels for the specified `Side`.

### `set_expand_margin_all(size: float) -> void`

Sets the expand margin to `size` pixels for all sides.

