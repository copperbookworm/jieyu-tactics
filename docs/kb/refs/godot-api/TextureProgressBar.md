# TextureProgressBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextureProgressBar` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextureProgressBar.md`

**摘要**：Texture-based progress bar. Useful for loading screens and life or stamina bars.

## 描述

TextureProgressBar works like `ProgressBar`, but uses up to 3 textures instead of Godot's `Theme` resource. It can be used to create horizontal, vertical and radial progress bars.

## 属性

- **`fill_mode`** `int` = `0`
  - 其它属性：getter=get_fill_mode · setter=set_fill_mode
- **`mouse_filter`** `int` = `1` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`nine_patch_stretch`** `bool` = `false`
  - 其它属性：getter=get_nine_patch_stretch · setter=set_nine_patch_stretch
- **`radial_center_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_radial_center_offset · setter=set_radial_center_offset
- **`radial_fill_degrees`** `float` = `360.0`
  - 其它属性：getter=get_fill_degrees · setter=set_fill_degrees
- **`radial_initial_angle`** `float` = `0.0`
  - 其它属性：getter=get_radial_initial_angle · setter=set_radial_initial_angle
- **`size_flags_vertical`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags
- **`step`** `float` = `1.0`
  - 其它属性：getter=get_step · overrides=Range · setter=set_step
- **`stretch_margin_bottom`** `int` = `0`
  - 其它属性：getter=get_stretch_margin · setter=set_stretch_margin
- **`stretch_margin_left`** `int` = `0`
  - 其它属性：getter=get_stretch_margin · setter=set_stretch_margin
- **`stretch_margin_right`** `int` = `0`
  - 其它属性：getter=get_stretch_margin · setter=set_stretch_margin
- **`stretch_margin_top`** `int` = `0`
  - 其它属性：getter=get_stretch_margin · setter=set_stretch_margin
- **`texture_over`** `Texture2D`
  - 其它属性：getter=get_over_texture · setter=set_over_texture
- **`texture_progress`** `Texture2D`
  - 其它属性：getter=get_progress_texture · setter=set_progress_texture
- **`texture_progress_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_texture_progress_offset · setter=set_texture_progress_offset
- **`texture_under`** `Texture2D`
  - 其它属性：getter=get_under_texture · setter=set_under_texture
- **`tint_over`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_tint_over · keywords=color, colour · setter=set_tint_over
- **`tint_progress`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_tint_progress · keywords=color, colour · setter=set_tint_progress
- **`tint_under`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_tint_under · keywords=color, colour · setter=set_tint_under

## 方法

### `get_stretch_margin(margin: int) -> int`
- 限定：qualifiers=const

Returns the stretch margin with the specified index. See `stretch_margin_bottom` and related properties.

### `set_stretch_margin(margin: int, value: int) -> void`

Sets the stretch margin with the specified index. See `stretch_margin_bottom` and related properties.

## 枚举

### `FillMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILL_LEFT_TO_RIGHT` |  |
| `1` | `FILL_RIGHT_TO_LEFT` |  |
| `2` | `FILL_TOP_TO_BOTTOM` |  |
| `3` | `FILL_BOTTOM_TO_TOP` |  |
| `4` | `FILL_CLOCKWISE` |  |
| `5` | `FILL_COUNTER_CLOCKWISE` |  |
| `6` | `FILL_BILINEAR_LEFT_AND_RIGHT` |  |
| `7` | `FILL_BILINEAR_TOP_AND_BOTTOM` |  |
| `8` | `FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE` |  |

