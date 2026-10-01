# SpriteBase3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpriteBase3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SpriteBase3D.md`

**摘要**：2D sprite node in 3D environment.

## 描述

A node that displays 2D texture information in a 3D environment. See also `Sprite3D` where many other properties are defined.

## 属性

- **`alpha_antialiasing_edge`** `float` = `0.0`
  - 其它属性：getter=get_alpha_antialiasing_edge · setter=set_alpha_antialiasing_edge
- **`alpha_antialiasing_mode`** `int` = `0` · 枚举 `BaseMaterial3D.AlphaAntiAliasing`
  - 其它属性：getter=get_alpha_antialiasing · setter=set_alpha_antialiasing
- **`alpha_cut`** `int` = `0` · 枚举 `SpriteBase3D.AlphaCutMode`
  - 其它属性：getter=get_alpha_cut_mode · setter=set_alpha_cut_mode
- **`alpha_hash_scale`** `float` = `1.0`
  - 其它属性：getter=get_alpha_hash_scale · setter=set_alpha_hash_scale
- **`alpha_scissor_threshold`** `float` = `0.5`
  - 其它属性：getter=get_alpha_scissor_threshold · setter=set_alpha_scissor_threshold
- **`axis`** `int` = `2` · 枚举 `Vector3.Axis`
  - 其它属性：getter=get_axis · setter=set_axis
- **`billboard`** `int` = `0` · 枚举 `BaseMaterial3D.BillboardMode`
  - 其它属性：getter=get_billboard_mode · setter=set_billboard_mode
- **`centered`** `bool` = `true`
  - 其它属性：getter=is_centered · setter=set_centered
- **`double_sided`** `bool` = `true`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`fixed_size`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`flip_h`** `bool` = `false`
  - 其它属性：getter=is_flipped_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=is_flipped_v · setter=set_flip_v
- **`modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · keywords=color, colour · setter=set_modulate
- **`no_depth_test`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`pixel_size`** `float` = `0.01`
  - 其它属性：getter=get_pixel_size · setter=set_pixel_size
- **`render_priority`** `int` = `0`
  - 其它属性：getter=get_render_priority · setter=set_render_priority
- **`shaded`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`texture_filter`** `int` = `3` · 枚举 `BaseMaterial3D.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`transparent`** `bool` = `true`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag

## 方法

### `generate_triangle_mesh() -> TriangleMesh`
- 限定：qualifiers=const

Returns a `TriangleMesh` with the sprite's vertices following its current configuration (such as its `axis` and `pixel_size`).

### `get_draw_flag(flag: int) -> bool`
- 限定：qualifiers=const

Returns the value of the specified flag.

### `get_item_rect() -> Rect2`
- 限定：qualifiers=const

Returns the rectangle representing this sprite.

### `set_draw_flag(flag: int, enabled: bool) -> void`

If `true`, the specified flag will be enabled.

## 枚举

### `DrawFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_TRANSPARENT` |  |
| `1` | `FLAG_SHADED` |  |
| `2` | `FLAG_DOUBLE_SIDED` |  |
| `3` | `FLAG_DISABLE_DEPTH_TEST` |  |
| `4` | `FLAG_FIXED_SIZE` |  |
| `5` | `FLAG_MAX` |  |

### `AlphaCutMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALPHA_CUT_DISABLED` |  |
| `1` | `ALPHA_CUT_DISCARD` |  |
| `2` | `ALPHA_CUT_OPAQUE_PREPASS` |  |
| `3` | `ALPHA_CUT_HASH` |  |

