# EditorSpinSlider

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSpinSlider` → `Range` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSpinSlider.md`

**摘要**：Godot editor's control for editing numeric values.

## 描述

This `Control` node is used in the editor's Inspector dock to allow editing of numeric values. Can be used with `EditorInspectorPlugin` to recreate the same behavior.
		If the `Range.step` value is `1`, the `EditorSpinSlider` will display up/down arrows, similar to `SpinBox`. If the `Range.step` value is not `1`, a slider will be displayed instead.

## 属性

- **`control_state`** `int` = `0` · 枚举 `EditorSpinSlider.ControlState`
  - 其它属性：getter=get_control_state · setter=set_control_state
- **`deferred_drag_mode`** `bool` = `false`
  - 其它属性：getter=is_deferred_drag_mode_enabled · setter=set_deferred_drag_mode_enabled
- **`editing_integer`** `bool` = `false`
  - 其它属性：getter=is_editing_integer · setter=set_editing_integer
- **`flat`** `bool` = `false`
  - 其它属性：getter=is_flat · setter=set_flat
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`hide_slider`** `bool` = `false`
  - 其它属性：deprecated=Use [member control_state] instead. · getter=is_hiding_slider · setter=set_hide_slider
- **`label`** `String` = `""`
  - 其它属性：getter=get_label · setter=set_label
- **`read_only`** `bool` = `false`
  - 其它属性：getter=is_read_only · keywords=enabled, disabled, editable · setter=set_read_only
- **`size_flags_vertical`** `int` = `1` · 枚举 `Control.SizeFlags` · 位标志
  - 其它属性：getter=get_v_size_flags · is_bitfield=true · overrides=Control · setter=set_v_size_flags
- **`step`** `float` = `1.0`
  - 其它属性：getter=get_step · overrides=Range · setter=set_step
- **`suffix`** `String` = `""`
  - 其它属性：getter=get_suffix · setter=set_suffix

## 信号

### `grabbed()`

Emitted when the spinner/slider is grabbed.

### `ungrabbed()`

Emitted when the spinner/slider is ungrabbed.

### `updown_pressed()`

Emitted when the updown button is pressed.

### `value_focus_entered()`

Emitted when the value form gains focus.

### `value_focus_exited()`

Emitted when the value form loses focus.

## 枚举

### `ControlState`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTROL_STATE_DEFAULT` |  |
| `1` | `CONTROL_STATE_PREFER_SLIDER` |  |
| `2` | `CONTROL_STATE_HIDE` |  |

## 主题属性

### `updown`
- data_type=icon · type=Texture2D

### `updown_disabled`
- data_type=icon · type=Texture2D

