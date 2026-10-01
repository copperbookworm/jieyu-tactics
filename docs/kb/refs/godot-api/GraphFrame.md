# GraphFrame

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GraphFrame` → `GraphElement` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GraphFrame.md`

**摘要**：GraphFrame is a special `GraphElement` that can be used to organize other `GraphElement`s inside a `GraphEdit`.

## 描述

GraphFrame is a special `GraphElement` to which other `GraphElement`s can be attached. It can be configured to automatically resize to enclose all attached `GraphElement`s. If the frame is moved, all the attached `GraphElement`s inside it will be moved as well.
		A GraphFrame is always kept behind the connection layer and other `GraphElement`s inside a `GraphEdit`.

## 属性

- **`autoshrink_enabled`** `bool` = `true`
  - 其它属性：getter=is_autoshrink_enabled · setter=set_autoshrink_enabled
- **`autoshrink_margin`** `int` = `40`
  - 其它属性：getter=get_autoshrink_margin · setter=set_autoshrink_margin
- **`drag_margin`** `int` = `16`
  - 其它属性：getter=get_drag_margin · setter=set_drag_margin
- **`mouse_filter`** `int` = `0` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`tint_color`** `Color` = `Color(0.3, 0.3, 0.3, 0.75)`
  - 其它属性：getter=get_tint_color · setter=set_tint_color
- **`tint_color_enabled`** `bool` = `false`
  - 其它属性：getter=is_tint_color_enabled · setter=set_tint_color_enabled
- **`title`** `String` = `""`
  - 其它属性：getter=get_title · setter=set_title

## 方法

### `get_titlebar_hbox() -> HBoxContainer`

Returns the `HBoxContainer` used for the title bar, only containing a `Label` for displaying the title by default.
				This can be used to add custom controls to the title bar such as option or close buttons.

## 信号

### `autoshrink_changed()`

Emitted when `autoshrink_enabled` or `autoshrink_margin` changes.

## 主题属性

### `resizer_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `panel`
- data_type=style · type=StyleBox

### `panel_selected`
- data_type=style · type=StyleBox

### `titlebar`
- data_type=style · type=StyleBox

### `titlebar_selected`
- data_type=style · type=StyleBox

