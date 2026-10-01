# VScrollBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VScrollBar` → `ScrollBar` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VScrollBar.md`

**摘要**：A vertical scrollbar that goes from top (min) to bottom (max).

## 描述

A vertical scrollbar, typically used to navigate through content that extends beyond the visible height of a control. It is a `Range`-based control and goes from top (min) to bottom (max). Note that this direction is the opposite of `VSlider`'s.

## 属性

- **`size_flags_horizontal`** `int` = `0` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_h_size_flags · is_bitfield=true · overrides=Control · setter=set_h_size_flags
- **`size_flags_vertical`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags

## 主题属性

### `padding_left`
- data_type=constant · default=0 · type=int

### `padding_right`
- data_type=constant · default=0 · type=int

