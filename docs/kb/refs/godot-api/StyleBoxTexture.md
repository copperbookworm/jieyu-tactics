# StyleBoxTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StyleBoxTexture` → `StyleBox` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StyleBoxTexture.md`

**摘要**：A texture-based nine-patch `StyleBox`.

## 描述

A texture-based nine-patch `StyleBox`, in a way similar to `NinePatchRect`. This stylebox performs a 3×3 scaling of a texture, where only the center cell is fully stretched. This makes it possible to design bordered styles regardless of the stylebox's size.

## 属性

- **`axis_stretch_horizontal`** `int` = `0` · 枚举 `StyleBoxTexture.AxisStretchMode`
  - 其它属性：getter=get_h_axis_stretch_mode · setter=set_h_axis_stretch_mode
- **`axis_stretch_vertical`** `int` = `0` · 枚举 `StyleBoxTexture.AxisStretchMode`
  - 其它属性：getter=get_v_axis_stretch_mode · setter=set_v_axis_stretch_mode
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
- **`modulate_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · setter=set_modulate
- **`region_rect`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_region_rect · setter=set_region_rect
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_margin_bottom`** `float` = `0.0`
  - 其它属性：getter=get_texture_margin · setter=set_texture_margin
- **`texture_margin_left`** `float` = `0.0`
  - 其它属性：getter=get_texture_margin · setter=set_texture_margin
- **`texture_margin_right`** `float` = `0.0`
  - 其它属性：getter=get_texture_margin · setter=set_texture_margin
- **`texture_margin_top`** `float` = `0.0`
  - 其它属性：getter=get_texture_margin · setter=set_texture_margin

## 方法

### `get_expand_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the expand margin size of the specified `Side`.

### `get_texture_margin(margin: int) -> float`
- 限定：qualifiers=const

Returns the margin size of the specified `Side`.

### `set_expand_margin(margin: int, size: float) -> void`

Sets the expand margin to `size` pixels for the specified `Side`.

### `set_expand_margin_all(size: float) -> void`

Sets the expand margin to `size` pixels for all sides.

### `set_texture_margin(margin: int, size: float) -> void`

Sets the margin to `size` pixels for the specified `Side`.

### `set_texture_margin_all(size: float) -> void`

Sets the margin to `size` pixels for all sides.

## 枚举

### `AxisStretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_STRETCH_MODE_STRETCH` |  |
| `1` | `AXIS_STRETCH_MODE_TILE` |  |
| `2` | `AXIS_STRETCH_MODE_TILE_FIT` |  |

