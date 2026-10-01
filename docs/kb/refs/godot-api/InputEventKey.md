# InputEventKey

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventKey` → `InputEventWithModifiers` → `InputEventFromWindow` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventKey.md`

**摘要**：Represents a key on a keyboard being pressed or released.

## 描述

An input event for keys on a keyboard. Supports key presses, key releases and `echo` events. It can also be received in `Node._unhandled_key_input`.
		**Note:** Events received from the keyboard usually have all properties set. Event mappings should have only one of the `keycode`, `physical_keycode` or `unicode` set.
		When events are compared, properties are checked in the following priority - `keycode`, `physical_keycode` and `unicode`. Events with the first matching value will be considered equal.

## 属性

- **`echo`** `bool` = `false`
  - 其它属性：getter=is_echo · keywords=repeat · setter=set_echo
- **`key_label`** `int` = `0` · 枚举 `Key`
  - 其它属性：getter=get_key_label · setter=set_key_label
- **`keycode`** `int` = `0` · 枚举 `Key`
  - 其它属性：getter=get_keycode · setter=set_keycode
- **`location`** `int` = `0` · 枚举 `KeyLocation`
  - 其它属性：getter=get_location · setter=set_location
- **`physical_keycode`** `int` = `0` · 枚举 `Key`
  - 其它属性：getter=get_physical_keycode · setter=set_physical_keycode
- **`pressed`** `bool` = `false`
  - 其它属性：getter=is_pressed · setter=set_pressed
- **`unicode`** `int` = `0`
  - 其它属性：getter=get_unicode · setter=set_unicode

## 方法

### `as_text_key_label() -> String`
- 限定：qualifiers=const

Returns a `String` representation of the event's `key_label` and modifiers.

### `as_text_keycode() -> String`
- 限定：qualifiers=const

Returns a `String` representation of the event's `keycode` and modifiers.

### `as_text_location() -> String`
- 限定：qualifiers=const

Returns a `String` representation of the event's `location`. This will be a blank string if the event is not specific to a location.

### `as_text_physical_keycode() -> String`
- 限定：qualifiers=const

Returns a `String` representation of the event's `physical_keycode` and modifiers.

### `get_key_label_with_modifiers() -> int`
- 限定：qualifiers=const

Returns the localized key label combined with modifier keys such as Shift or Alt. See also `InputEventWithModifiers`.
				To get a human-readable representation of the `InputEventKey` with modifiers, use `OS.get_keycode_string(event.get_key_label_with_modifiers())` where `event` is the `InputEventKey`.

### `get_keycode_with_modifiers() -> int`
- 限定：qualifiers=const

Returns the Latin keycode combined with modifier keys such as Shift or Alt. See also `InputEventWithModifiers`.
				To get a human-readable representation of the `InputEventKey` with modifiers, use `OS.get_keycode_string(event.get_keycode_with_modifiers())` where `event` is the `InputEventKey`.

### `get_physical_keycode_with_modifiers() -> int`
- 限定：qualifiers=const

Returns the physical keycode combined with modifier keys such as Shift or Alt. See also `InputEventWithModifiers`.
				To get a human-readable representation of the `InputEventKey` with modifiers, use `OS.get_keycode_string(event.get_physical_keycode_with_modifiers())` where `event` is the `InputEventKey`.

## 教程链接

- [Using InputEvent](None)

