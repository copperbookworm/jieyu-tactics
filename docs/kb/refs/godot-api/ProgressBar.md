# ProgressBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ProgressBar` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ProgressBar.md`

**摘要**：A control used for visual representation of a percentage.

## 描述

A control used for visual representation of a percentage. Shows the fill percentage in the center. Can also be used to show indeterminate progress. For more fill modes, use `TextureProgressBar` instead.

## 属性

- **`editor_preview_indeterminate`** `bool`
  - 其它属性：getter=is_editor_preview_indeterminate_enabled · setter=set_editor_preview_indeterminate
- **`fill_mode`** `int` = `0`
  - 其它属性：getter=get_fill_mode · setter=set_fill_mode
- **`indeterminate`** `bool` = `false`
  - 其它属性：getter=is_indeterminate · setter=set_indeterminate
- **`show_percentage`** `bool` = `true`
  - 其它属性：getter=is_percentage_shown · setter=set_show_percentage

## 枚举

### `FillMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILL_BEGIN_TO_END` |  |
| `1` | `FILL_END_TO_BEGIN` |  |
| `2` | `FILL_TOP_TO_BOTTOM` |  |
| `3` | `FILL_BOTTOM_TO_TOP` |  |

## 主题属性

### `font_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `outline_size`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `background`
- data_type=style · type=StyleBox

### `fill`
- data_type=style · type=StyleBox

