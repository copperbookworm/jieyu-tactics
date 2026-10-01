# InputEventMouseButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventMouseButton` → `InputEventMouse` → `InputEventWithModifiers` → `InputEventFromWindow` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · keywords=click, press
> 自动生成，勿手改。文件：`refs/godot-api/InputEventMouseButton.md`

**摘要**：Represents a mouse button being pressed or released.

## 描述

Stores information about mouse click events. See `Node._input`.
		**Note:** On Wear OS devices, rotary input is mapped to `MOUSE_BUTTON_WHEEL_UP` and `MOUSE_BUTTON_WHEEL_DOWN`. This can be changed to `MOUSE_BUTTON_WHEEL_LEFT` and `MOUSE_BUTTON_WHEEL_RIGHT` with the `ProjectSettings.input_devices/pointing/android/rotary_input_scroll_axis` setting.

## 属性

- **`button_index`** `int` = `0` · 枚举 `MouseButton`
  - 其它属性：getter=get_button_index · setter=set_button_index
- **`canceled`** `bool` = `false`
  - 其它属性：getter=is_canceled · setter=set_canceled
- **`double_click`** `bool` = `false`
  - 其它属性：getter=is_double_click · setter=set_double_click
- **`factor`** `float` = `1.0`
  - 其它属性：getter=get_factor · setter=set_factor
- **`pressed`** `bool` = `false`
  - 其它属性：getter=is_pressed · setter=set_pressed

## 教程链接

- [Using InputEvent](None)
- [Mouse and input coordinates](None)

