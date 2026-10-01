# AnimationMixer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimationMixer` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimationMixer.md`

**摘要**：Base class for `AnimationPlayer` and `AnimationTree`.

## 描述

Base class for `AnimationPlayer` and `AnimationTree` to manage animation lists. It also has general properties and methods for playback and blending.
		After instantiating the playback information data within the extended class, the blending is processed by the `AnimationMixer`.

## 属性

- **`active`** `bool` = `true`
  - 其它属性：getter=is_active · setter=set_active
- **`audio_max_polyphony`** `int` = `32`
  - 其它属性：getter=get_audio_max_polyphony · setter=set_audio_max_polyphony
- **`callback_mode_discrete`** `int` = `1` · 枚举 `AnimationMixer.AnimationCallbackModeDiscrete`
  - 其它属性：getter=get_callback_mode_discrete · setter=set_callback_mode_discrete
- **`callback_mode_method`** `int` = `0` · 枚举 `AnimationMixer.AnimationCallbackModeMethod`
  - 其它属性：getter=get_callback_mode_method · setter=set_callback_mode_method
- **`callback_mode_process`** `int` = `1` · 枚举 `AnimationMixer.AnimationCallbackModeProcess`
  - 其它属性：getter=get_callback_mode_process · setter=set_callback_mode_process
- **`deterministic`** `bool` = `false`
  - 其它属性：getter=is_deterministic · setter=set_deterministic
- **`reset_on_save`** `bool` = `true`
  - 其它属性：getter=is_reset_on_save_enabled · setter=set_reset_on_save_enabled
- **`root_motion_local`** `bool` = `false`
  - 其它属性：getter=is_root_motion_local · setter=set_root_motion_local
- **`root_motion_track`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_root_motion_track · setter=set_root_motion_track
- **`root_node`** `NodePath` = `NodePath("..")`
  - 其它属性：getter=get_root_node · setter=set_root_node

## 方法

### `_post_process_key_value(animation: Animation, track: int, value: Variant, object_id: int, object_sub_idx: int) -> Variant`
- 限定：qualifiers=virtual const

A virtual function for processing after getting a key during playback.

### `add_animation_library(name: StringName, library: AnimationLibrary) -> int`

Adds `library` to the animation player, under the key `name`.
				AnimationMixer has a global library by default with an empty string as key. For adding an animation to the global library:
				`codeblocks`
				`gdscript`
				var global_library = mixer.get_animation_library("")
				global_library.add_animation("animation_name", animation_resource)

### `advance(delta: float) -> void`

Manually advance the animations by the specified time (in seconds).

### `capture(name: StringName, duration: float, trans_type: int = 0, ease_type: int = 0) -> void`

If the animation track specified by `name` has an option `Animation.UPDATE_CAPTURE`, stores current values of the objects indicated by the track path as a cache. If there is already a captured cache, the old cache is discarded.
				After this it will interpolate with current animation blending result during the playback process for the time specified by `duration`, working like a crossfade.
				You can specify `trans_type` as the curve for the interpolation. For better results, it may be appropriate to specify `Tween.TRANS_LINEAR` for cases where the first key of the track begins with a non-zero value or where the key value does not change, and `Tween.TRANS_QUAD` for cases where the key value changes linearly.

### `clear_caches() -> void`

`AnimationMixer` caches animated nodes. It may not notice if a node disappears; `clear_caches` forces it to update the cache again.

### `find_animation(animation: Animation) -> StringName`
- 限定：qualifiers=const

Returns the key of `animation` or an empty `StringName` if not found.

### `find_animation_library(animation: Animation) -> StringName`
- 限定：qualifiers=const

Returns the key for the `AnimationLibrary` that contains `animation` or an empty `StringName` if not found.

### `get_animation(name: StringName) -> Animation`
- 限定：qualifiers=const

Returns the `Animation` with the key `name`. If the animation does not exist, `null` is returned and an error is logged.

### `get_animation_library(name: StringName) -> AnimationLibrary`
- 限定：qualifiers=const

Returns the first `AnimationLibrary` with key `name` or `null` if not found.
				To get the `AnimationMixer`'s global animation library, use `get_animation_library("")`.

### `get_animation_library_list() -> StringName[]`
- 限定：qualifiers=const

Returns the list of stored library keys.

### `get_animation_list() -> PackedStringArray`
- 限定：qualifiers=const

Returns the list of stored animation keys.

### `get_root_motion_position() -> Vector3`
- 限定：qualifiers=const

Retrieve the motion delta of position with the `root_motion_track` as a `Vector3` that can be used elsewhere.
				If `root_motion_track` is not a path to a track of type `Animation.TYPE_POSITION_3D`, returns `Vector3(0, 0, 0)`.
				See also `root_motion_track` and `RootMotionView`.
				The most basic example is applying position to `CharacterBody3D`:
				`codeblocks`
				`gdscript`
				var current_rotation

				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						current_rotation = get_quaternion()
						state_machine.travel("Animate")
					var velocity = current_rotation * animation_tree.get_root_motion_position() / delta
					set_velocity(velocity)
					move_and_slide()
				
				
				By using this in combination with `get_root_motion_rotation_accumulator`, you can apply the root motion position more correctly to account for the rotation of the node.
				`codeblocks`
				`gdscript`
				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())
					var velocity = (animation_tree.get_root_motion_rotation_accumulator().inverse() * get_quaternion()) * animation_tree.get_root_motion_position() / delta
					set_velocity(velocity)
					move_and_slide()
				
				
				If `root_motion_local` is `true`, returns the pre-multiplied translation value with the inverted rotation.
				In this case, the code can be written as follows:
				`codeblocks`
				`gdscript`
				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())
					var velocity = get_quaternion() * animation_tree.get_root_motion_position() / delta
					set_velocity(velocity)
					move_and_slide()

### `get_root_motion_position_accumulator() -> Vector3`
- 限定：qualifiers=const

Retrieve the blended value of the position tracks with the `root_motion_track` as a `Vector3` that can be used elsewhere.
				This is useful in cases where you want to respect the initial key values of the animation.
				For example, if an animation with only one key `Vector3(0, 0, 0)` is played in the previous frame and then an animation with only one key `Vector3(1, 0, 1)` is played in the next frame, the difference can be calculated as follows:
				`codeblocks`
				`gdscript`
				var prev_root_motion_position_accumulator

				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					var current_root_motion_position_accumulator = animation_tree.get_root_motion_position_accumulator()
					var difference = current_root_motion_position_accumulator - prev_root_motion_position_accumulator
					prev_root_motion_position_accumulator = current_root_motion_position_accumulator
					transform.origin += difference
				
				
				However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

### `get_root_motion_rotation() -> Quaternion`
- 限定：qualifiers=const

Retrieve the motion delta of rotation with the `root_motion_track` as a `Quaternion` that can be used elsewhere.
				If `root_motion_track` is not a path to a track of type `Animation.TYPE_ROTATION_3D`, returns `Quaternion(0, 0, 0, 1)`.
				See also `root_motion_track` and `RootMotionView`.
				The most basic example is applying rotation to `CharacterBody3D`:
				`codeblocks`
				`gdscript`
				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())

### `get_root_motion_rotation_accumulator() -> Quaternion`
- 限定：qualifiers=const

Retrieve the blended value of the rotation tracks with the `root_motion_track` as a `Quaternion` that can be used elsewhere.
				This is necessary to apply the root motion position correctly, taking rotation into account. See also `get_root_motion_position`.
				Also, this is useful in cases where you want to respect the initial key values of the animation.
				For example, if an animation with only one key `Quaternion(0, 0, 0, 1)` is played in the previous frame and then an animation with only one key `Quaternion(0, 0.707, 0, 0.707)` is played in the next frame, the difference can be calculated as follows:
				`codeblocks`
				`gdscript`
				var prev_root_motion_rotation_accumulator

				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					var current_root_motion_rotation_accumulator = animation_tree.get_root_motion_rotation_accumulator()
					var difference = prev_root_motion_rotation_accumulator.inverse() * current_root_motion_rotation_accumulator
					prev_root_motion_rotation_accumulator = current_root_motion_rotation_accumulator
					transform.basis *=  Basis(difference)
				
				
				However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

### `get_root_motion_scale() -> Vector3`
- 限定：qualifiers=const

Retrieve the motion delta of scale with the `root_motion_track` as a `Vector3` that can be used elsewhere.
				If `root_motion_track` is not a path to a track of type `Animation.TYPE_SCALE_3D`, returns `Vector3(0, 0, 0)`.
				See also `root_motion_track` and `RootMotionView`.
				The most basic example is applying scale to `CharacterBody3D`:
				`codeblocks`
				`gdscript`
				var current_scale = Vector3(1, 1, 1)
				var scale_accum = Vector3(1, 1, 1)

				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						current_scale = get_scale()
						scale_accum = Vector3(1, 1, 1)
						state_machine.travel("Animate")
					scale_accum += animation_tree.get_root_motion_scale()
					set_scale(current_scale * scale_accum)

### `get_root_motion_scale_accumulator() -> Vector3`
- 限定：qualifiers=const

Retrieve the blended value of the scale tracks with the `root_motion_track` as a `Vector3` that can be used elsewhere.
				For example, if an animation with only one key `Vector3(1, 1, 1)` is played in the previous frame and then an animation with only one key `Vector3(2, 2, 2)` is played in the next frame, the difference can be calculated as follows:
				`codeblocks`
				`gdscript`
				var prev_root_motion_scale_accumulator

				func _process(delta):
					if Input.is_action_just_pressed("animate"):
						state_machine.travel("Animate")
					var current_root_motion_scale_accumulator = animation_tree.get_root_motion_scale_accumulator()
					var difference = current_root_motion_scale_accumulator - prev_root_motion_scale_accumulator
					prev_root_motion_scale_accumulator = current_root_motion_scale_accumulator
					transform.basis = transform.basis.scaled(difference)
				
				
				However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

### `has_animation(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the `AnimationMixer` stores an `Animation` with key `name`.

### `has_animation_library(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the `AnimationMixer` stores an `AnimationLibrary` with key `name`.

### `remove_animation_library(name: StringName) -> void`

Removes the `AnimationLibrary` associated with the key `name`.

### `rename_animation_library(name: StringName, newname: StringName) -> void`

Moves the `AnimationLibrary` associated with the key `name` to the key `newname`.

## 信号

### `animation_finished(anim_name: StringName)`

Notifies when an animation finished playing.
				**Note:** This signal is not emitted if an animation is looping.

### `animation_libraries_updated()`

Notifies when the animation libraries have changed.

### `animation_list_changed()`

Notifies when an animation list is changed.

### `animation_started(anim_name: StringName)`

Notifies when an animation starts playing.
				**Note:** This signal is not emitted if an animation is looping.

### `caches_cleared()`

Notifies when the caches have been cleared, either automatically, or manually via `clear_caches`.

### `mixer_applied()`

Notifies when the blending result related have been applied to the target objects.

### `mixer_updated()`

Notifies when the property related process have been updated.

## 枚举

### `AnimationCallbackModeProcess`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS` |  |
| `1` | `ANIMATION_CALLBACK_MODE_PROCESS_IDLE` |  |
| `2` | `ANIMATION_CALLBACK_MODE_PROCESS_MANUAL` |  |

### `AnimationCallbackModeMethod`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_CALLBACK_MODE_METHOD_DEFERRED` |  |
| `1` | `ANIMATION_CALLBACK_MODE_METHOD_IMMEDIATE` |  |

### `AnimationCallbackModeDiscrete`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ANIMATION_CALLBACK_MODE_DISCRETE_DOMINANT` |  |
| `1` | `ANIMATION_CALLBACK_MODE_DISCRETE_RECESSIVE` |  |
| `2` | `ANIMATION_CALLBACK_MODE_DISCRETE_FORCE_CONTINUOUS` |  |

## 教程链接

- [Migrating Animations from Godot 4.0 to 4.3](None)

