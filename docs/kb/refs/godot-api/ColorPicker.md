# ColorPicker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ColorPicker` → `VBoxContainer` → `BoxContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ColorPicker.md`

**摘要**：A widget that provides an interface for selecting or modifying a color.

## 描述

A widget that provides an interface for selecting or modifying a color. It can optionally provide functionalities like a color sampler (eyedropper), color modes, and presets.
		**Note:** This control is the color picker widget itself. You can use a `ColorPickerButton` instead if you need a button that brings up a `ColorPicker` in a popup.

## 属性

- **`can_add_swatches`** `bool` = `true`
  - 其它属性：getter=are_swatches_enabled · setter=set_can_add_swatches
- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_pick_color · keywords=colour · setter=set_pick_color
- **`color_mode`** `int` = `0` · 枚举 `ColorPicker.ColorModeType`
  - 其它属性：getter=get_color_mode · setter=set_color_mode
- **`color_modes_visible`** `bool` = `true`
  - 其它属性：getter=are_modes_visible · setter=set_modes_visible
- **`deferred_mode`** `bool` = `false`
  - 其它属性：getter=is_deferred_mode · setter=set_deferred_mode
- **`edit_alpha`** `bool` = `true`
  - 其它属性：getter=is_editing_alpha · setter=set_edit_alpha
- **`edit_intensity`** `bool` = `true`
  - 其它属性：getter=is_editing_intensity · setter=set_edit_intensity
- **`hex_visible`** `bool` = `true`
  - 其它属性：getter=is_hex_visible · setter=set_hex_visible
- **`picker_shape`** `int` = `0` · 枚举 `ColorPicker.PickerShapeType`
  - 其它属性：getter=get_picker_shape · setter=set_picker_shape
- **`presets_visible`** `bool` = `true`
  - 其它属性：getter=are_presets_visible · setter=set_presets_visible
- **`sampler_visible`** `bool` = `true`
  - 其它属性：getter=is_sampler_visible · setter=set_sampler_visible
- **`sliders_visible`** `bool` = `true`
  - 其它属性：getter=are_sliders_visible · setter=set_sliders_visible

## 方法

### `add_preset(color: Color) -> void`

Adds the given color to a list of color presets. The presets are displayed in the color picker and the user will be able to select them.
				**Note:** The presets list is only for *this* color picker.

### `add_recent_preset(color: Color) -> void`

Adds the given color to a list of color recent presets so that it can be picked later. Recent presets are the colors that were picked recently, a new preset is automatically created and added to recent presets when you pick a new color.
				**Note:** The recent presets list is only for *this* color picker.

### `erase_preset(color: Color) -> void`

Removes the given color from the list of color presets of this color picker.

### `erase_recent_preset(color: Color) -> void`

Removes the given color from the list of color recent presets of this color picker.

### `get_presets() -> PackedColorArray`
- 限定：qualifiers=const

Returns the list of colors in the presets of the color picker.

### `get_recent_presets() -> PackedColorArray`
- 限定：qualifiers=const

Returns the list of colors in the recent presets of the color picker.

## 信号

### `color_changed(color: Color)`

Emitted when the color is changed.

### `preset_added(color: Color)`

Emitted when a preset is added.

### `preset_removed(color: Color)`

Emitted when a preset is removed.

## 枚举

### `ColorModeType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_RGB` |  |
| `1` | `MODE_HSV` |  |
| `2` | `MODE_RAW` |  |
| `2` | `MODE_LINEAR` |  |
| `3` | `MODE_OKHSL` |  |

### `PickerShapeType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHAPE_HSV_RECTANGLE` |  |
| `1` | `SHAPE_HSV_WHEEL` |  |
| `2` | `SHAPE_VHS_CIRCLE` |  |
| `3` | `SHAPE_OKHSL_CIRCLE` |  |
| `4` | `SHAPE_NONE` |  |
| `5` | `SHAPE_OK_HS_RECTANGLE` |  |
| `6` | `SHAPE_OK_HL_RECTANGLE` |  |

## 主题属性

### `focused_not_editing_cursor_color`
- data_type=color · default=Color(1, 1, 1, 0.275) · type=Color

### `center_slider_grabbers`
- data_type=constant · default=1 · type=int

### `h_width`
- data_type=constant · default=30 · type=int

### `label_width`
- data_type=constant · default=10 · type=int

### `margin`
- data_type=constant · default=4 · type=int

### `sv_height`
- data_type=constant · default=256 · type=int

### `sv_width`
- data_type=constant · default=256 · type=int

### `add_preset`
- data_type=icon · type=Texture2D

### `bar_arrow`
- data_type=icon · type=Texture2D

### `color_copy`
- data_type=icon · type=Texture2D

### `color_hue`
- data_type=icon · type=Texture2D

### `color_script`
- data_type=icon · type=Texture2D

### `expanded_arrow`
- data_type=icon · type=Texture2D

### `folded_arrow`
- data_type=icon · type=Texture2D

### `menu_option`
- data_type=icon · type=Texture2D

### `overbright_indicator`
- data_type=icon · type=Texture2D

### `picker_cursor`
- data_type=icon · type=Texture2D

### `picker_cursor_bg`
- data_type=icon · type=Texture2D

### `sample_bg`
- data_type=icon · type=Texture2D

### `sample_revert`
- data_type=icon · type=Texture2D

### `screen_picker`
- data_type=icon · type=Texture2D

### `shape_circle`
- data_type=icon · type=Texture2D

### `shape_rect`
- data_type=icon · type=Texture2D

### `shape_rect_wheel`
- data_type=icon · type=Texture2D

### `picker_focus_circle`
- data_type=style · type=StyleBox

### `picker_focus_rectangle`
- data_type=style · type=StyleBox

### `sample_focus`
- data_type=style · type=StyleBox

## 教程链接

- [Tween Interpolation Demo](None)

