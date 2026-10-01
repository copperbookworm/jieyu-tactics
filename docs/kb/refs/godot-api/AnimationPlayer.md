# AnimationPlayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationPlayer` → `AnimationMixer` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationPlayer.md`

**摘要**：A node used for animation playback.

## 描述

An animation player is used for general-purpose playback of animations. It contains a dictionary of `AnimationLibrary` resources and custom blend times between animation transitions.
		Some methods and properties use a single key to reference an animation directly. These keys are formatted as the key for the library, followed by a forward slash, then the key for the animation within the library, for example `"movement/run"`. If the library's key is an empty string (known as the default library), the forward slash is omitted, being the same key used by the library.
		`AnimationPlayer` is better-suited than `Tween` for more complex animations, for example ones with non-trivial timings. It can also be used over `Tween` if the animation track editor is more convenient than doing it in code.
		Updating the target properties of animations occurs at the process frame.

## 属性

- **`assigned_animation`** `StringName`
  - 其它属性：getter=get_assigned_animation · setter=set_assigned_animation
- **`autoplay`** `StringName` = `&""`
  - 其它属性：getter=get_autoplay · setter=set_autoplay
- **`current_animation`** `StringName` = `&""`
  - 其它属性：getter=get_current_animation · setter=set_current_animation
- **`current_animation_length`** `float`
  - 其它属性：getter=get_current_animation_length · setter=
- **`current_animation_position`** `float`
  - 其它属性：getter=get_current_animation_position · setter=
- **`movie_quit_on_finish`** `bool` = `false`
  - 其它属性：getter=is_movie_quit_on_finish_enabled · setter=set_movie_quit_on_finish_enabled
- **`playback_auto_capture`** `bool` = `true`
  - 其它属性：getter=is_auto_capture · setter=set_auto_capture
- **`playback_auto_capture_duration`** `float` = `-1.0`
  - 其它属性：getter=get_auto_capture_duration · setter=set_auto_capture_duration
- **`playback_auto_capture_ease_type`** `int` = `0` · 枚举 `Tween.EaseType`
  - 其它属性：getter=get_auto_capture_ease_type · setter=set_auto_capture_ease_type
- **`playback_auto_capture_transition_type`** `int` = `0` · 枚举 `Tween.TransitionType`
  - 其它属性：getter=get_auto_capture_transition_type · setter=set_auto_capture_transition_type
- **`playback_default_blend_time`** `float` = `0.0`
  - 其它属性：getter=get_default_blend_time · setter=set_default_blend_time
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale

## 方法

### `animation_get_next(animation_from: StringName) -> StringName`
- 限定：qualifiers=const

Returns the key of the animation which is queued to play after the `animation_from` animation.

### `animation_set_next(animation_from: StringName, animation_to: StringName) -> void`

Triggers the `animation_to` animation when the `animation_from` animation completes.

### `clear_queue() -> void`

Clears all queued, unplayed animations.

### `get_blend_time(animation_from: StringName, animation_to: StringName) -> float`
- 限定：qualifiers=const

Returns the blend time (in seconds) between two animations, referenced by their keys.

### `get_method_call_mode() -> int`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_method] instead. · qualifiers=const

Returns the call mode used for "Call Method" tracks.

### `get_playing_speed() -> float`
- 限定：qualifiers=const

Returns the actual playing speed of current animation or `0` if not playing. This speed is the `speed_scale` property multiplied by `custom_speed` argument specified when calling the `play` method.
				Returns a negative value if the current animation is playing backwards.

### `get_process_callback() -> int`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_process] instead. · qualifiers=const

Returns the process notification in which to update animations.

### `get_queue() -> StringName[]`

Returns a list of the animation keys that are currently queued to play.

### `get_root() -> NodePath`
- 限定：deprecated=Use [member AnimationMixer.root_node] instead. · qualifiers=const

Returns the node which node path references will travel from.

### `get_section_end_time() -> float`
- 限定：qualifiers=const

Returns the end time of the section currently being played.

### `get_section_start_time() -> float`
- 限定：qualifiers=const

Returns the start time of the section currently being played.

### `has_section() -> bool`
- 限定：qualifiers=const

Returns `true` if an animation is currently playing with a section.

### `is_animation_active() -> bool`
- 限定：qualifiers=const

Returns `true` if the an animation is currently active. An animation is active if it was played by calling `play` and was not finished yet, or was stopped by calling `stop`.
				This can be used to check whether an animation is currently paused or stopped.
				
```gdscript
				var is_paused = not is_playing() and is_animation_active()
				var is_stopped = not is_playing() and not is_animation_active()
				
```

### `is_playing() -> bool`
- 限定：qualifiers=const

Returns `true` if an animation is currently playing (even if `speed_scale` and/or `custom_speed` are `0`).

### `pause() -> void`

Pauses the currently playing animation. The `current_animation_position` will be kept and calling `play` or `play_backwards` without arguments or with the same animation name as `assigned_animation` will resume the animation.
				See also `stop`.

### `play(name: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void`

Plays the animation with key `name`. Custom blend times and speed can be set.
				The `from_end` option only affects when switching to a new animation track, or if the same track but at the start or end. It does not affect resuming playback that was paused in the middle of an animation. If `custom_speed` is negative and `from_end` is `true`, the animation will play backwards (which is equivalent to calling `play_backwards`).
				The `AnimationPlayer` keeps track of its current or last played animation with `assigned_animation`. If this method is called with that same animation `name`, or with no `name` parameter, the assigned animation will resume playing if it was paused.
				**Note:** The animation will be updated the next time the `AnimationPlayer` is processed. If other variables are updated at the same time this is called, they may be updated too early. To perform the update immediately, call `advance(0)`.

### `play_backwards(name: StringName = &"", custom_blend: float = -1) -> void`

Plays the animation with key `name` in reverse.
				This method is a shorthand for `play` with `custom_speed = -1.0` and `from_end = true`, so see its description for more information.

### `play_section(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void`

Plays the animation with key `name` and the section starting from `start_time` and ending on `end_time`. See also `play`.
				Setting `start_time` to a value outside the range of the animation means the start of the animation will be used instead, and setting `end_time` to a value outside the range of the animation means the end of the animation will be used instead. `start_time` cannot be equal to `end_time`.

### `play_section_backwards(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1) -> void`

Plays the animation with key `name` and the section starting from `start_time` and ending on `end_time` in reverse.
				This method is a shorthand for `play_section` with `custom_speed = -1.0` and `from_end = true`, see its description for more information.

### `play_section_with_markers(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void`

Plays the animation with key `name` and the section starting from `start_marker` and ending on `end_marker`.
				If the start marker is empty, the section starts from the beginning of the animation. If the end marker is empty, the section ends on the end of the animation. See also `play`.

### `play_section_with_markers_backwards(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1) -> void`

Plays the animation with key `name` and the section starting from `start_marker` and ending on `end_marker` in reverse.
				This method is a shorthand for `play_section_with_markers` with `custom_speed = -1.0` and `from_end = true`, see its description for more information.

### `play_with_capture(name: StringName = &"", duration: float = -1.0, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false, trans_type: int = 0, ease_type: int = 0) -> void`

See also `AnimationMixer.capture`.
				You can use this method to use more detailed options for capture than those performed by `playback_auto_capture`. When `playback_auto_capture` is `false`, this method is almost the same as the following:
				
```gdscript
				capture(name, duration, trans_type, ease_type)
				play(name, custom_blend, custom_speed, from_end)
				
```

				If `name` is blank, it specifies `assigned_animation`.
				If `duration` is a negative value, the duration is set to the interval between the current position and the first key, when `from_end` is `true`, uses the interval between the current position and the last key instead.
				**Note:** The `duration` takes `speed_scale` into account, but `custom_speed` does not, because the capture cache is interpolated with the blend result and the result may contain multiple animations.

### `queue(name: StringName) -> void`

Queues an animation for playback once the current animation and all previously queued animations are done.
				**Note:** If a looped animation is currently playing, the queued animation will never play unless the looped animation is stopped somehow.

### `reset_section() -> void`

Resets the current section. Does nothing if a section has not been set.

### `seek(seconds: float, update: bool = false, update_only: bool = false) -> void`

Seeks the animation to the `seconds` point in time (in seconds). If `update` is `true`, the animation updates too, otherwise it updates at process time. Events between the current frame and `seconds` are skipped.
				If `update_only` is `true`, the method / audio / animation playback tracks will not be processed.
				**Note:** Seeking to the end of the animation doesn't emit `AnimationMixer.animation_finished`. If you want to skip animation and emit the signal, use `AnimationMixer.advance`.

### `set_blend_time(animation_from: StringName, animation_to: StringName, sec: float) -> void`

Specifies a blend time (in seconds) between two animations, referenced by their keys.

### `set_method_call_mode(mode: int) -> void`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_method] instead.

Sets the call mode used for "Call Method" tracks.

### `set_process_callback(mode: int) -> void`
- 限定：deprecated=Use [member AnimationMixer.callback_mode_process] instead.

Sets the process notification in which to update animations.

### `set_root(path: NodePath) -> void`
- 限定：deprecated=Use [member AnimationMixer.root_node] instead.

Sets the node which node path references will travel from.

### `set_section(start_time: float = -1, end_time: float = -1) -> void`

Changes the start and end times of the section being played. The current playback position will be clamped within the new section. See also `play_section`.

### `set_section_with_markers(start_marker: StringName = &"", end_marker: StringName = &"") -> void`

Changes the start and end markers of the section being played. The current playback position will be clamped within the new section. See also `play_section_with_markers`.
				If the argument is empty, the section uses the beginning or end of the animation. If both are empty, it means that the section is not set.

### `stop(keep_state: bool = false) -> void`

Stops the currently playing animation. The animation position is reset to `0` and the `custom_speed` is reset to `1.0`. See also `pause`.
				If `keep_state` is `true`, the animation state is not updated visually.
				**Note:** The method / audio / animation playback tracks will not be processed by this method.

## 信号

### `animation_changed(old_name: StringName, new_name: StringName)`

Emitted when a queued animation plays after the previous animation finished. See also `AnimationPlayer.queue`.
				**Note:** The signal is not emitted when the animation is changed via `AnimationPlayer.play` or by an `AnimationTree`.

### `current_animation_changed(anim_name: StringName)`

Emitted when `current_animation` changes.

## 枚举

### `AnimationProcessCallback`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_PROCESS_PHYSICS` |  |
| `1` | `ANIMATION_PROCESS_IDLE` |  |
| `2` | `ANIMATION_PROCESS_MANUAL` |  |

### `AnimationMethodCallMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_METHOD_CALL_DEFERRED` |  |
| `1` | `ANIMATION_METHOD_CALL_IMMEDIATE` |  |

## 教程链接

- [2D Sprite animation](None)
- [Animation documentation index](None)
- [Third Person Shooter (TPS) Demo](None)

