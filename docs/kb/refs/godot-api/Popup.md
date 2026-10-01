# Popup

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Popup` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Popup.md`

**摘要**：Base class for contextual windows and panels with fixed position.

## 描述

`Popup` is a base class for contextual windows and panels with fixed position. It's a modal by default (see `Window.popup_window`) and provides methods for implementing custom popup behavior.
		**Note:** `Popup` is invisible by default. To make it visible, call one of the `popup_*` methods from `Window` on the node, such as `Window.popup_centered_clamped`.

## 属性

- **`borderless`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`maximize_disabled`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`minimize_disabled`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`popup_window`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`popup_wm_hint`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`transient`** `bool` = `true`
  - 其它属性：getter=is_transient · overrides=Window · setter=set_transient
- **`unresizable`** `bool` = `true`
  - 其它属性：getter=get_flag · overrides=Window · setter=set_flag
- **`visible`** `bool` = `false`
  - 其它属性：getter=is_visible · overrides=Window · setter=set_visible
- **`wrap_controls`** `bool` = `true`
  - 其它属性：getter=is_wrapping_controls · overrides=Window · setter=set_wrap_controls

## 信号

### `popup_hide()`

Emitted when the popup is hidden.

