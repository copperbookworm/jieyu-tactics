# BaseButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BaseButton.md`

**摘要**：Abstract base class for GUI buttons.

## 描述

`BaseButton` is an abstract base class for GUI buttons. It doesn't display anything by itself.

## 属性

- **`action_mode`** `int` = `1` · 枚举 `BaseButton.ActionMode`
  - 其它属性：getter=get_action_mode · setter=set_action_mode
- **`button_group`** `ButtonGroup`
  - 其它属性：getter=get_button_group · setter=set_button_group
- **`button_mask`** `int` = `1` · 枚举 `MouseButtonMask` · 位标志
  - 其它属性：getter=get_button_mask · is_bitfield=true · setter=set_button_mask
- **`button_pressed`** `bool` = `false`
  - 其它属性：getter=is_pressed · setter=set_pressed
- **`disabled`** `bool` = `false`
  - 其它属性：getter=is_disabled · keywords=enabled · setter=set_disabled
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`keep_pressed_outside`** `bool` = `false`
  - 其它属性：getter=is_keep_pressed_outside · setter=set_keep_pressed_outside
- **`shortcut`** `Shortcut`
  - 其它属性：getter=get_shortcut · setter=set_shortcut
- **`shortcut_feedback`** `bool` = `true`
  - 其它属性：getter=is_shortcut_feedback · setter=set_shortcut_feedback
- **`shortcut_in_tooltip`** `bool` = `true`
  - 其它属性：getter=is_shortcut_in_tooltip_enabled · setter=set_shortcut_in_tooltip
- **`toggle_mode`** `bool` = `false`
  - 其它属性：getter=is_toggle_mode · setter=set_toggle_mode

## 方法

### `_pressed() -> void`
- 限定：qualifiers=virtual

Called when the button is pressed. If you need to know the button's pressed state (and `toggle_mode` is active), use `_toggled` instead.

### `_toggled(toggled_on: bool) -> void`
- 限定：qualifiers=virtual

Called when the button is toggled (only if `toggle_mode` is active).

### `get_draw_mode() -> int`
- 限定：qualifiers=const

Returns the visual state used to draw the button. This is useful mainly when implementing your own draw code by either overriding _draw() or connecting to "draw" signal. The visual state of the button is defined by the `DrawMode` enum.

### `is_hovered() -> bool`
- 限定：qualifiers=const

Returns `true` if the mouse has entered the button and has not left it yet.

### `set_pressed_no_signal(pressed: bool) -> void`

Changes the `button_pressed` state of the button, without emitting `toggled`. Use when you just want to change the state of the button without sending the pressed event (e.g. when initializing scene). Only works if `toggle_mode` is `true`.
				**Note:** This method doesn't unpress other buttons in `button_group`.

## 信号

### `button_down()`

Emitted when the button starts being held down.

### `button_up()`

Emitted when the button stops being held down.

### `pressed()`

Emitted when the button is toggled or pressed. This is on `button_down` if `action_mode` is `ACTION_MODE_BUTTON_PRESS` and on `button_up` otherwise.
				If you need to know the button's pressed state (and `toggle_mode` is active), use `toggled` instead.

### `toggled(toggled_on: bool)`

Emitted when the button was just toggled between pressed and normal states (only if `toggle_mode` is active). The new state is contained in the `toggled_on` argument.

## 枚举

### `DrawMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAW_NORMAL` |  |
| `1` | `DRAW_PRESSED` |  |
| `2` | `DRAW_HOVER` |  |
| `3` | `DRAW_DISABLED` |  |
| `4` | `DRAW_HOVER_PRESSED` |  |

### `ActionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ACTION_MODE_BUTTON_PRESS` |  |
| `1` | `ACTION_MODE_BUTTON_RELEASE` |  |

