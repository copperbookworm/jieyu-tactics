# InputEventWithModifiers

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventWithModifiers` → `InputEventFromWindow` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventWithModifiers.md`

**摘要**：Abstract base class for input events affected by modifier keys like Shift and Alt.

## 描述

Stores information about mouse, keyboard, and touch gesture input events. This includes information about which modifier keys are pressed, such as Shift or Alt. See `Node._input`.
		**Note:** Modifier keys are considered modifiers only when used in combination with another key. As a result, their corresponding member variables, such as `ctrl_pressed`, will return `false` if the key is pressed on its own.

## 属性

- **`alt_pressed`** `bool` = `false`
  - 其它属性：getter=is_alt_pressed · setter=set_alt_pressed
- **`command_or_control_autoremap`** `bool` = `false`
  - 其它属性：getter=is_command_or_control_autoremap · setter=set_command_or_control_autoremap
- **`ctrl_pressed`** `bool` = `false`
  - 其它属性：getter=is_ctrl_pressed · setter=set_ctrl_pressed
- **`device`** `int` = `16`
  - 其它属性：getter=get_device · overrides=InputEvent · setter=set_device
- **`meta_pressed`** `bool` = `false`
  - 其它属性：getter=is_meta_pressed · setter=set_meta_pressed
- **`shift_pressed`** `bool` = `false`
  - 其它属性：getter=is_shift_pressed · setter=set_shift_pressed

## 方法

### `get_modifiers_mask() -> int`
- 限定：qualifiers=const

Returns the keycode combination of modifier keys.

### `is_command_or_control_pressed() -> bool`
- 限定：qualifiers=const

On macOS, returns `true` if Meta (Cmd) is pressed.
				On other platforms, returns `true` if Ctrl is pressed.

## 教程链接

- [Using InputEvent](None)

