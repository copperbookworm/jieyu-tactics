# PopupPanel

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PopupPanel` → `Popup` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PopupPanel.md`

**摘要**：A popup with a panel background.

## 描述

A popup with a configurable panel background. Any child controls added to this node will be stretched to fit the panel's size (similar to how `PanelContainer` works). If you are making windows, see `Window`.

## 属性

- **`canvas_item_default_texture_filter`** `int` = `4` · 枚举 `Viewport.DefaultCanvasItemTextureFilter`
  - 其它属性：getter=get_default_canvas_item_texture_filter · overrides=Viewport · setter=set_default_canvas_item_texture_filter
- **`canvas_item_default_texture_repeat`** `int` = `3` · 枚举 `Viewport.DefaultCanvasItemTextureRepeat`
  - 其它属性：getter=get_default_canvas_item_texture_repeat · overrides=Viewport · setter=set_default_canvas_item_texture_repeat
- **`transparent`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`transparent_bg`** `bool` = `true`
  - 其它属性：getter=has_transparent_background · overrides=Viewport · setter=set_transparent_background

## 主题属性

### `panel`
- data_type=style · type=StyleBox

