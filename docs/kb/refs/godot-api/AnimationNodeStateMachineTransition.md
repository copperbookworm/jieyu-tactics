# AnimationNodeStateMachineTransition

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeStateMachineTransition` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeStateMachineTransition.md`

**摘要**：A transition within an `AnimationNodeStateMachine` connecting two `AnimationRootNode`s.

## 描述

The path generated when using `AnimationNodeStateMachinePlayback.travel` is limited to the nodes connected by `AnimationNodeStateMachineTransition`.
		You can set the timing and conditions of the transition in detail.

## 属性

- **`advance_condition`** `StringName` = `&""`
  - 其它属性：getter=get_advance_condition · setter=set_advance_condition
- **`advance_expression`** `String` = `""`
  - 其它属性：getter=get_advance_expression · setter=set_advance_expression
- **`advance_mode`** `int` = `1` · 枚举 `AnimationNodeStateMachineTransition.AdvanceMode`
  - 其它属性：getter=get_advance_mode · setter=set_advance_mode
- **`break_loop_at_end`** `bool` = `false`
  - 其它属性：getter=is_loop_broken_at_end · setter=set_break_loop_at_end
- **`priority`** `int` = `1`
  - 其它属性：getter=get_priority · setter=set_priority
- **`reset`** `bool` = `true`
  - 其它属性：getter=is_reset · setter=set_reset
- **`switch_mode`** `int` = `0` · 枚举 `AnimationNodeStateMachineTransition.SwitchMode`
  - 其它属性：getter=get_switch_mode · setter=set_switch_mode
- **`xfade_curve`** `Curve`
  - 其它属性：getter=get_xfade_curve · setter=set_xfade_curve
- **`xfade_time`** `float` = `0.0`
  - 其它属性：getter=get_xfade_time · setter=set_xfade_time

## 信号

### `advance_condition_changed()`

Emitted when `advance_condition` is changed.

## 枚举

### `SwitchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SWITCH_MODE_IMMEDIATE` |  |
| `1` | `SWITCH_MODE_SYNC` |  |
| `2` | `SWITCH_MODE_AT_END` |  |

### `AdvanceMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ADVANCE_MODE_DISABLED` |  |
| `1` | `ADVANCE_MODE_ENABLED` |  |
| `2` | `ADVANCE_MODE_AUTO` |  |

## 教程链接

- [Using AnimationTree](None)

