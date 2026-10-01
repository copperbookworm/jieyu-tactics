# ButtonGroup

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ButtonGroup` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · keywords=radio
> 自动生成，勿手改。文件：`refs/godot-api/ButtonGroup.md`

**摘要**：A group of buttons that doesn't allow more than one button to be pressed at a time.

## 描述

A group of `BaseButton`-derived buttons. The buttons in a `ButtonGroup` are treated like radio buttons: No more than one button can be pressed at a time. Some types of buttons (such as `CheckBox`) may have a special appearance in this state.
		Every member of a `ButtonGroup` should have `BaseButton.toggle_mode` set to `true`.

## 属性

- **`allow_unpress`** `bool` = `false`
  - 其它属性：getter=is_allow_unpress · setter=set_allow_unpress
- **`resource_local_to_scene`** `bool` = `true`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

## 方法

### `get_buttons() -> BaseButton[]`

Returns an `Array` of `Button`s who have this as their `ButtonGroup` (see `BaseButton.button_group`).

### `get_pressed_button() -> BaseButton`

Returns the current pressed button.

## 信号

### `pressed(button: BaseButton)`

Emitted when one of the buttons of the group is pressed.

