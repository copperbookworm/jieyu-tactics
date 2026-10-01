# AnimationNodeStateMachinePlayback

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationNodeStateMachinePlayback` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationNodeStateMachinePlayback.md`

**摘要**：Provides playback control for an `AnimationNodeStateMachine`.

## 描述

Allows control of `AnimationTree` state machines created with `AnimationNodeStateMachine`. Retrieve with `$AnimationTree.get("parameters/playback")`.
		`codeblocks`
		`gdscript`
		var state_machine = $AnimationTree.get("parameters/playback")
		state_machine.travel("some_state")
		
		`csharp`
		var stateMachine = GetNode<AnimationTree>("AnimationTree").Get("parameters/playback").As<AnimationNodeStateMachinePlayback>();
		stateMachine.Travel("some_state");

## 属性

- **`resource_local_to_scene`** `bool` = `true`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

## 方法

### `get_current_length() -> float`
- 限定：qualifiers=const

Returns the current state length.
				**Note:** It is possible that any `AnimationRootNode` can be nodes as well as animations. This means that there can be multiple animations within a single state. Which animation length has priority depends on the nodes connected inside it. Also, if a transition does not reset, the remaining length at that point will be returned.

### `get_current_node() -> StringName`
- 限定：qualifiers=const

Returns the currently playing animation state.
				**Note:** When using a cross-fade, the current state changes to the next state immediately after the cross-fade begins.

### `get_current_play_position() -> float`
- 限定：qualifiers=const

Returns the playback position within the current animation state.

### `get_fading_from_length() -> float`
- 限定：qualifiers=const

Returns the playback state length of the node from `get_fading_from_node`. Returns `0` if no animation fade is occurring.

### `get_fading_from_node() -> StringName`
- 限定：qualifiers=const

Returns the starting state of currently fading animation.

### `get_fading_from_play_position() -> float`
- 限定：qualifiers=const

Returns the playback position of the node from `get_fading_from_node`. Returns `0` if no animation fade is occurring.

### `get_fading_length() -> float`
- 限定：qualifiers=const

Returns the length of the current fade animation. Returns `0` if no animation fade is occurring.

### `get_fading_position() -> float`
- 限定：qualifiers=const

Returns the playback position of the current fade animation. Returns `0` if no animation fade is occurring.

### `get_travel_path() -> StringName[]`
- 限定：qualifiers=const

Returns the current travel path as computed internally by the A* algorithm.

### `is_playing() -> bool`
- 限定：qualifiers=const

Returns `true` if an animation is playing.

### `next() -> void`

If there is a next path by travel or auto advance, immediately transitions from the current state to the next state.

### `start(node: StringName, reset: bool = true) -> void`

Starts playing the given animation.
				If `reset` is `true`, the animation is played from the beginning.

### `stop() -> void`

Stops the currently playing animation.

### `travel(to_node: StringName, reset_on_teleport: bool = true) -> void`

Transitions from the current state to another one, following the shortest path.
				If the path does not connect from the current state, the animation will play after the state teleports.
				If `reset_on_teleport` is `true`, the animation is played from the beginning when the travel cause a teleportation.

## 信号

### `state_finished(state: StringName)`

Emitted when the `state` finishes playback. If `state` is a state machine set to grouped mode, its signals are passed through with its name prefixed.
				If there is a crossfade, this will be fired when the influence of the `get_fading_from_node` animation is no longer present.

### `state_started(state: StringName)`

Emitted when the `state` starts playback. If `state` is a state machine set to grouped mode, its signals are passed through with its name prefixed.

## 教程链接

- [Using AnimationTree](None)

