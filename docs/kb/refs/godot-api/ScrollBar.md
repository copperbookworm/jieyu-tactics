# ScrollBar

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScrollBar` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ScrollBar.md`

**摘要**：Abstract base class for scrollbars.

## 描述

Abstract base class for scrollbars, typically used to navigate through content that extends beyond the visible area of a control. Scrollbars are `Range`-based controls.

## 属性

- **`custom_step`** `float` = `-1.0`
  - 其它属性：getter=get_custom_step · setter=set_custom_step
- **`focus_mode`** `int` = `3` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`step`** `float` = `0.0`
  - 其它属性：getter=get_step · overrides=Range · setter=set_step

## 信号

### `scrolling()`

Emitted when the scrollbar is being scrolled.

## 主题属性

### `decrement`
- data_type=icon · type=Texture2D

### `decrement_highlight`
- data_type=icon · type=Texture2D

### `decrement_pressed`
- data_type=icon · type=Texture2D

### `increment`
- data_type=icon · type=Texture2D

### `increment_highlight`
- data_type=icon · type=Texture2D

### `increment_pressed`
- data_type=icon · type=Texture2D

### `grabber`
- data_type=style · type=StyleBox

### `grabber_highlight`
- data_type=style · type=StyleBox

### `grabber_pressed`
- data_type=style · type=StyleBox

### `scroll`
- data_type=style · type=StyleBox

### `scroll_focus`
- data_type=style · type=StyleBox

