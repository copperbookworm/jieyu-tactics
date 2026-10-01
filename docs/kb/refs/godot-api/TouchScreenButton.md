# TouchScreenButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TouchScreenButton` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TouchScreenButton.md`

**摘要**：Button for touch screen devices for gameplay use.

## 描述

TouchScreenButton allows you to create on-screen buttons for touch devices. It's intended for gameplay use, such as a unit you have to touch to move. Unlike `Button`, TouchScreenButton supports multitouch out of the box. Several TouchScreenButtons can be pressed at the same time with touch input.
		This node inherits from `Node2D`. Unlike with `Control` nodes, you cannot set anchors on it. If you want to create menus or user interfaces, you may want to use `Button` nodes instead. To make button nodes react to touch events, you can enable `ProjectSettings.input_devices/pointing/emulate_mouse_from_touch` in the Project Settings.
		You can configure TouchScreenButton to be visible only on touch devices, helping you develop your game both for desktop and mobile devices.

## 属性

- **`action`** `String` = `""`
  - 其它属性：getter=get_action · setter=set_action
- **`bitmask`** `BitMap`
  - 其它属性：getter=get_bitmask · setter=set_bitmask
- **`passby_press`** `bool` = `false`
  - 其它属性：getter=is_passby_press_enabled · setter=set_passby_press
- **`shape`** `Shape2D`
  - 其它属性：getter=get_shape · setter=set_shape
- **`shape_centered`** `bool` = `true`
  - 其它属性：getter=is_shape_centered · setter=set_shape_centered
- **`shape_visible`** `bool` = `true`
  - 其它属性：getter=is_shape_visible · setter=set_shape_visible
- **`texture_normal`** `Texture2D`
  - 其它属性：getter=get_texture_normal · setter=set_texture_normal
- **`texture_pressed`** `Texture2D`
  - 其它属性：getter=get_texture_pressed · setter=set_texture_pressed
- **`visibility_mode`** `int` = `0` · 枚举 `TouchScreenButton.VisibilityMode`
  - 其它属性：getter=get_visibility_mode · setter=set_visibility_mode

## 方法

### `is_pressed() -> bool`
- 限定：qualifiers=const

Returns `true` if this button is currently pressed.

## 信号

### `pressed()`

Emitted when the button is pressed (down).

### `released()`

Emitted when the button is released (up).

## 枚举

### `VisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_ALWAYS` |  |
| `1` | `VISIBILITY_TOUCHSCREEN_ONLY` |  |

