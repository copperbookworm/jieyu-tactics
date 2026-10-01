# InputEvent

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEvent.md`

**摘要**：Abstract base class for input events.

## 描述

Abstract base class of all types of input events. See `Node._input`.

## 属性

- **`device`** `int` = `0`
  - 其它属性：getter=get_device · setter=set_device

## 方法

### `accumulate(with_event: InputEvent) -> bool`

Returns `true` if the given input event and this input event can be added together (only for events of type `InputEventMouseMotion`).
				The given input event's position, global position and speed will be copied. The resulting `relative` is a sum of both events. Both events' modifiers have to be identical.

### `as_text() -> String`
- 限定：qualifiers=const

Returns a `String` representation of the event.

### `get_action_strength(action: StringName, exact_match: bool = false) -> float`
- 限定：qualifiers=const

Returns a value between 0.0 and 1.0 depending on the given actions' state. Useful for getting the value of events of type `InputEventJoypadMotion`.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `is_action(action: StringName, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if this input event matches a pre-defined action of any type.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `is_action_pressed(action: StringName, allow_echo: bool = false, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if the given action matches this event and is being pressed (and is not an echo event for `InputEventKey` events, unless `allow_echo` is `true`). Not relevant for events of type `InputEventMouseMotion` or `InputEventScreenDrag`.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** Due to keyboard ghosting, `is_action_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.

### `is_action_released(action: StringName, exact_match: bool = false) -> bool`
- 限定：qualifiers=const

Returns `true` if the given action matches this event and is released (i.e. not pressed). Not relevant for events of type `InputEventMouseMotion` or `InputEventScreenDrag`.
				If `exact_match` is `false`, it ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.

### `is_action_type() -> bool`
- 限定：qualifiers=const

Returns `true` if this input event's type is one that can be assigned to an input action: `InputEventKey`, `InputEventMouseButton`, `InputEventJoypadButton`, `InputEventJoypadMotion`, `InputEventAction`. Returns `false` for all other input event types.

### `is_canceled() -> bool`
- 限定：qualifiers=const

Returns `true` if this input event has been canceled.

### `is_echo() -> bool`
- 限定：keywords=is_repeat · qualifiers=const

Returns `true` if this input event is an echo event (only for events of type `InputEventKey`). An echo event is a repeated key event sent when the user is holding down the key. Any other event type returns `false`.
				**Note:** The rate at which echo events are sent is typically around 20 events per second (after holding down the key for roughly half a second). However, the key repeat delay/speed can be changed by the user or disabled entirely in the operating system settings. To ensure your project works correctly on all configurations, do not assume the user has a specific key repeat configuration in your project's behavior.

### `is_match(event: InputEvent, exact_match: bool = true) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified `event` matches this event. Only valid for action events, which include key (`InputEventKey`), button (`InputEventMouseButton` or `InputEventJoypadButton`), axis `InputEventJoypadMotion`, and action (`InputEventAction`) events.
				If `exact_match` is `false`, the check ignores additional input modifiers for `InputEventKey` and `InputEventMouseButton` events, and the direction for `InputEventJoypadMotion` events.
				**Note:** This method only considers the event configuration (such as the keyboard key or the joypad axis), not state information like `is_pressed`, `is_released`, `is_echo`, or `is_canceled`.

### `is_pressed() -> bool`
- 限定：qualifiers=const

Returns `true` if this input event is pressed. Not relevant for events of type `InputEventMouseMotion` or `InputEventScreenDrag`.
				**Note:** Due to keyboard ghosting, `is_pressed` may return `false` even if one of the action's keys is pressed. See Input examples ($DOCS_URL/tutorials/inputs/input_examples.html#keyboard-events) in the documentation for more information.

### `is_released() -> bool`
- 限定：qualifiers=const

Returns `true` if this input event is released. Not relevant for events of type `InputEventMouseMotion` or `InputEventScreenDrag`.

### `xformed_by(xform: Transform2D, local_ofs: Vector2 = Vector2(0, 0)) -> InputEvent`
- 限定：qualifiers=const

Returns a copy of the given input event which has been offset by `local_ofs` and transformed by `xform`. Relevant for events of type `InputEventMouseButton`, `InputEventMouseMotion`, `InputEventScreenTouch`, `InputEventScreenDrag`, `InputEventMagnifyGesture` and `InputEventPanGesture`.

## 常量

- **`DEVICE_ID_EMULATION`** = `-1`
- **`DEVICE_ID_KEYBOARD`** = `16`
- **`DEVICE_ID_MOUSE`** = `32`
## 教程链接

- [Using InputEvent](None)
- [Viewport and canvas transforms](None)
- [2D Dodge The Creeps Demo](None)
- [3D Voxel Demo](None)

