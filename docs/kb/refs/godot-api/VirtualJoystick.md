# VirtualJoystick

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VirtualJoystick` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VirtualJoystick.md`

**摘要**：A virtual joystick control for touchscreen devices.

## 描述

A customizable on-screen joystick control designed for touchscreen devices. It allows users to provide directional input by dragging a virtual tip within a defined circular area.
		This control can simulate directional actions (see `action_up`, `action_down`, `action_left`, and `action_right`), which are triggered when the joystick is moved in the corresponding directions.

## 属性

- **`action_down`** `StringName` = `&"ui_down"`
  - 其它属性：getter=get_action_down · setter=set_action_down
- **`action_left`** `StringName` = `&"ui_left"`
  - 其它属性：getter=get_action_left · setter=set_action_left
- **`action_right`** `StringName` = `&"ui_right"`
  - 其它属性：getter=get_action_right · setter=set_action_right
- **`action_up`** `StringName` = `&"ui_up"`
  - 其它属性：getter=get_action_up · setter=set_action_up
- **`clampzone_ratio`** `float` = `1.0`
  - 其它属性：getter=get_clampzone_ratio · setter=set_clampzone_ratio
- **`deadzone_ratio`** `float` = `0.0`
  - 其它属性：getter=get_deadzone_ratio · setter=set_deadzone_ratio
- **`initial_offset_ratio`** `Vector2` = `Vector2(0.5, 0.5)`
  - 其它属性：getter=get_initial_offset_ratio · setter=set_initial_offset_ratio
- **`joystick_mode`** `int` = `0` · 枚举 `VirtualJoystick.JoystickMode`
  - 其它属性：getter=get_joystick_mode · setter=set_joystick_mode
- **`joystick_size`** `float` = `100.0`
  - 其它属性：getter=get_joystick_size · setter=set_joystick_size
- **`tip_size`** `float` = `50.0`
  - 其它属性：getter=get_tip_size · setter=set_tip_size
- **`visibility_mode`** `int` = `0` · 枚举 `VirtualJoystick.VisibilityMode`
  - 其它属性：getter=get_visibility_mode · setter=set_visibility_mode

## 信号

### `flick_canceled()`

Emitted when the tip enters the deadzone after being outside of it.

### `flicked(input_vector: Vector2)`

Emitted when the tip moved outside the deadzone and the joystick is released. The `input_vector` contains the last input direction and strength before release. Its length is between `0.0` and `1.0`.

### `pressed()`

Emitted when the joystick is pressed.

### `released(input_vector: Vector2)`

Emitted when the joystick is released. The `input_vector` is the final input direction and strength, with a length between `0.0` and `1.0`.

### `tapped()`

Emitted when the joystick is released without moving the tip.

## 枚举

### `JoystickMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `JOYSTICK_FIXED` |  |
| `1` | `JOYSTICK_DYNAMIC` |  |
| `2` | `JOYSTICK_FOLLOWING` |  |

### `VisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_ALWAYS` |  |
| `1` | `VISIBILITY_WHEN_TOUCHED` |  |

## 主题属性

### `normal_joystick`
- data_type=style · type=StyleBox

### `normal_tip`
- data_type=style · type=StyleBox

### `pressed_joystick`
- data_type=style · type=StyleBox

### `pressed_tip`
- data_type=style · type=StyleBox

