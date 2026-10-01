# AnimationNodeTransition

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeTransition` → `AnimationNodeSync` → `AnimationNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeTransition.md`

**摘要**：A transition within an `AnimationTree` connecting two `AnimationNode`s.

## 描述

Simple state machine for cases which don't require a more advanced `AnimationNodeStateMachine`. Animations can be connected to the inputs and transition times can be specified.
		After setting the request and changing the animation playback, the transition node automatically clears the request on the next process frame by setting its `transition_request` value to empty.
		**Note:** When using a cross-fade, `current_state` and `current_index` change to the next state immediately after the cross-fade begins.
		`codeblocks`
		`gdscript`
		# Play child animation connected to "state_2" port.
		animation_tree.set("parameters/Transition/transition_request", "state_2")
		# Alternative syntax (same result as above).
		animation_tree["parameters/Transition/transition_request"] = "state_2"

		# Get current state name (read-only).
		animation_tree.get("parameters/Transition/current_state")
		# Alternative syntax (same result as above).
		animation_tree["parameters/Transition/current_state"]

		# Get current state index (read-only).
		animation_tree.get("parameters/Transition/current_index")
		# Alternative syntax (same result as above).
		animation_tree["parameters/Transition/current_index"]
		
		`csharp`
		// Play child animation connected to "state_2" port.
		animationTree.Set("parameters/Transition/transition_request", "state_2");

		// Get current state name (read-only).
		animationTree.Get("parameters/Transition/current_state");

		// Get current state index (read-only).
		animationTree.Get("parameters/Transition/current_index");

## 属性

- **`allow_transition_to_self`** `bool` = `false`
  - 其它属性：getter=is_allow_transition_to_self · setter=set_allow_transition_to_self
- **`input_count`** `int` = `0`
  - 其它属性：getter=get_input_count · setter=set_input_count
- **`xfade_curve`** `Curve`
  - 其它属性：getter=get_xfade_curve · setter=set_xfade_curve
- **`xfade_time`** `float` = `0.0`
  - 其它属性：getter=get_xfade_time · setter=set_xfade_time

## 方法

### `is_input_loop_broken_at_end(input: int) -> bool`
- 限定：qualifiers=const

Returns whether the animation breaks the loop at the end of the loop cycle for transition.

### `is_input_reset(input: int) -> bool`
- 限定：qualifiers=const

Returns whether the animation restarts when the animation transitions from the other animation.

### `is_input_set_as_auto_advance(input: int) -> bool`
- 限定：qualifiers=const

Returns `true` if auto-advance is enabled for the given `input` index.

### `set_input_as_auto_advance(input: int, enable: bool) -> void`

Enables or disables auto-advance for the given `input` index. If enabled, state changes to the next input after playing the animation once. If enabled for the last input state, it loops to the first.

### `set_input_break_loop_at_end(input: int, enable: bool) -> void`

If `true`, breaks the loop at the end of the loop cycle for transition, even if the animation is looping.

### `set_input_reset(input: int, enable: bool) -> void`

If `true`, the destination animation is restarted when the animation transitions.

## 教程链接

- [Using AnimationTree](None)
- [3D Platformer Demo](None)
- [Third Person Shooter (TPS) Demo](None)

