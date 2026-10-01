# NinePatchRect

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NinePatchRect` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/NinePatchRect.md`

**摘要**：A control that displays a texture by keeping its corners intact, but tiling its edges and center.

## 描述

Also known as 9-slice panels, `NinePatchRect` produces clean panels of any size based on a small texture. To do so, it splits the texture in a 3×3 grid. When you scale the node, it tiles the texture's edges horizontally or vertically, tiles the center on both axes, and leaves the corners unchanged.

## 属性

- **`axis_stretch_horizontal`** `int` = `0` · 枚举 `NinePatchRect.AxisStretchMode`
  - 其它属性：getter=get_h_axis_stretch_mode · setter=set_h_axis_stretch_mode
- **`axis_stretch_vertical`** `int` = `0` · 枚举 `NinePatchRect.AxisStretchMode`
  - 其它属性：getter=get_v_axis_stretch_mode · setter=set_v_axis_stretch_mode
- **`draw_center`** `bool` = `true`
  - 其它属性：getter=is_draw_center_enabled · setter=set_draw_center
- **`mouse_filter`** `int` = `2` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`patch_margin_bottom`** `int` = `0`
  - 其它属性：getter=get_patch_margin · setter=set_patch_margin
- **`patch_margin_left`** `int` = `0`
  - 其它属性：getter=get_patch_margin · setter=set_patch_margin
- **`patch_margin_right`** `int` = `0`
  - 其它属性：getter=get_patch_margin · setter=set_patch_margin
- **`patch_margin_top`** `int` = `0`
  - 其它属性：getter=get_patch_margin · setter=set_patch_margin
- **`region_rect`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_region_rect · setter=set_region_rect
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture

## 方法

### `get_patch_margin(margin: int) -> int`
- 限定：qualifiers=const

Returns the size of the margin on the specified `Side`.

### `set_patch_margin(margin: int, value: int) -> void`

Sets the size of the margin on the specified `Side` to `value` pixels.

## 信号

### `texture_changed()`

Emitted when the node's texture changes.

## 枚举

### `AxisStretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_STRETCH_MODE_STRETCH` |  |
| `1` | `AXIS_STRETCH_MODE_TILE` |  |
| `2` | `AXIS_STRETCH_MODE_TILE_FIT` |  |

