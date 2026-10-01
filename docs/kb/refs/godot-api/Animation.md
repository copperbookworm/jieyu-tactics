# Animation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Animation` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Animation.md`

**摘要**：Holds data that can be used to animate anything in the engine.

## 描述

This resource holds data that can be used to animate anything in the engine. Animations are divided into tracks and each track must be linked to a node. The state of that node can be changed through time, by adding timed keys (events) to the track.
		`codeblocks`
		`gdscript`
		# This creates an animation that makes the node "Enemy" move to the right by
		# 100 pixels in 2.0 seconds.
		var animation = Animation.new()
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_index, "Enemy:position:x")
		animation.track_insert_key(track_index, 0.0, 0)
		animation.track_insert_key(track_index, 2.0, 100)
		animation.length = 2.0
		
		`csharp`
		// This creates an animation that makes the node "Enemy" move to the right by
		// 100 pixels in 2.0 seconds.
		var animation = new Animation();
		int trackIndex = animation.AddTrack(Animation.TrackType.Value);
		animation.TrackSetPath(trackIndex, "Enemy:position:x");
		animation.TrackInsertKey(trackIndex, 0.0f, 0);
		animation.TrackInsertKey(trackIndex, 2.0f, 100);
		animation.Length = 2.0f;
		
		
		Animations are just data containers, and must be added to nodes such as an `AnimationPlayer` to be played back. Animation tracks have different types, each with its own set of dedicated methods. Check `TrackType` to see available types.
		**Note:** For 3D position/rotation/scale, using the dedicated `TYPE_POSITION_3D`, `TYPE_ROTATION_3D` and `TYPE_SCALE_3D` track types instead of `TYPE_VALUE` is recommended for performance reasons.

## 属性

- **`capture_included`** `bool` = `false`
  - 其它属性：getter=is_capture_included · setter=
- **`length`** `float` = `1.0`
  - 其它属性：getter=get_length · setter=set_length
- **`loop_mode`** `int` = `0` · 枚举 `Animation.LoopMode`
  - 其它属性：getter=get_loop_mode · setter=set_loop_mode
- **`step`** `float` = `0.033333335`
  - 其它属性：getter=get_step · setter=set_step

## 方法

### `add_marker(name: StringName, time: float) -> void`

Adds a marker to this Animation.

### `add_track(type: int, at_position: int = -1) -> int`

Adds a track to the Animation.

### `animation_track_get_key_animation(track_idx: int, key_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the animation name at the key identified by `key_idx`. The `track_idx` must be the index of an Animation Track.

### `animation_track_insert_key(track_idx: int, time: float, animation: StringName) -> int`

Inserts a key with value `animation` at the given `time` (in seconds). The `track_idx` must be the index of an Animation Track.

### `animation_track_set_key_animation(track_idx: int, key_idx: int, animation: StringName) -> void`

Sets the key identified by `key_idx` to value `animation`. The `track_idx` must be the index of an Animation Track.

### `audio_track_get_key_end_offset(track_idx: int, key_idx: int) -> float`
- 限定：qualifiers=const

Returns the end offset of the key identified by `key_idx`. The `track_idx` must be the index of an Audio Track.
				End offset is the number of seconds cut off at the ending of the audio stream.

### `audio_track_get_key_start_offset(track_idx: int, key_idx: int) -> float`
- 限定：qualifiers=const

Returns the start offset of the key identified by `key_idx`. The `track_idx` must be the index of an Audio Track.
				Start offset is the number of seconds cut off at the beginning of the audio stream.

### `audio_track_get_key_stream(track_idx: int, key_idx: int) -> Resource`
- 限定：qualifiers=const

Returns the audio stream of the key identified by `key_idx`. The `track_idx` must be the index of an Audio Track.

### `audio_track_insert_key(track_idx: int, time: float, stream: Resource, start_offset: float = 0, end_offset: float = 0) -> int`

Inserts an Audio Track key at the given `time` in seconds. The `track_idx` must be the index of an Audio Track.
				`stream` is the `AudioStream` resource to play. `start_offset` is the number of seconds cut off at the beginning of the audio stream, while `end_offset` is at the ending.

### `audio_track_is_use_blend(track_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the track at `track_idx` will be blended with other animations.

### `audio_track_set_key_end_offset(track_idx: int, key_idx: int, offset: float) -> void`

Sets the end offset of the key identified by `key_idx` to value `offset`. The `track_idx` must be the index of an Audio Track.

### `audio_track_set_key_start_offset(track_idx: int, key_idx: int, offset: float) -> void`

Sets the start offset of the key identified by `key_idx` to value `offset`. The `track_idx` must be the index of an Audio Track.

### `audio_track_set_key_stream(track_idx: int, key_idx: int, stream: Resource) -> void`

Sets the stream of the key identified by `key_idx` to value `stream`. The `track_idx` must be the index of an Audio Track.

### `audio_track_set_use_blend(track_idx: int, enable: bool) -> void`

Sets whether the track will be blended with other animations. If `true`, the audio playback volume changes depending on the blend value.

### `bezier_track_get_key_in_handle(track_idx: int, key_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the in handle of the key identified by `key_idx`. The `track_idx` must be the index of a Bezier Track.

### `bezier_track_get_key_out_handle(track_idx: int, key_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns the out handle of the key identified by `key_idx`. The `track_idx` must be the index of a Bezier Track.

### `bezier_track_get_key_value(track_idx: int, key_idx: int) -> float`
- 限定：qualifiers=const

Returns the value of the key identified by `key_idx`. The `track_idx` must be the index of a Bezier Track.

### `bezier_track_insert_key(track_idx: int, time: float, value: float, in_handle: Vector2 = Vector2(0, 0), out_handle: Vector2 = Vector2(0, 0)) -> int`

Inserts a Bezier Track key at the given `time` in seconds. The `track_idx` must be the index of a Bezier Track.
				`in_handle` is the left-side weight of the added Bezier curve point, `out_handle` is the right-side one, while `value` is the actual value at this point.

### `bezier_track_interpolate(track_idx: int, time: float) -> float`
- 限定：qualifiers=const

Returns the interpolated value at the given `time` (in seconds). The `track_idx` must be the index of a Bezier Track.

### `bezier_track_set_key_in_handle(track_idx: int, key_idx: int, in_handle: Vector2, balanced_value_time_ratio: float = 1.0) -> void`

Sets the in handle of the key identified by `key_idx` to value `in_handle`. The `track_idx` must be the index of a Bezier Track.

### `bezier_track_set_key_out_handle(track_idx: int, key_idx: int, out_handle: Vector2, balanced_value_time_ratio: float = 1.0) -> void`

Sets the out handle of the key identified by `key_idx` to value `out_handle`. The `track_idx` must be the index of a Bezier Track.

### `bezier_track_set_key_value(track_idx: int, key_idx: int, value: float) -> void`

Sets the value of the key identified by `key_idx` to the given value. The `track_idx` must be the index of a Bezier Track.

### `blend_shape_track_insert_key(track_idx: int, time: float, amount: float) -> int`

Inserts a key in a given blend shape track. Returns the key index.

### `blend_shape_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) -> float`
- 限定：qualifiers=const

Returns the interpolated blend shape value at the given time (in seconds). The `track_idx` must be the index of a blend shape track.

### `clear() -> void`

Clear the animation (clear all tracks and reset all).

### `compress(page_size: int = 8192, fps: int = 120, split_tolerance: float = 4.0) -> void`

Compress the animation and all its tracks in-place. This will make `track_is_compressed` return `true` once called on this `Animation`. Compressed tracks require less memory to be played, and are designed to be used for complex 3D animations (such as cutscenes) imported from external 3D software. Compression is lossy, but the difference is usually not noticeable in real world conditions.
				**Note:** Compressed tracks have various limitations (such as not being editable from the editor), so only use compressed animations if you actually need them.

### `copy_track(track_idx: int, to_animation: Animation) -> void`

Adds a new track to `to_animation` that is a copy of the given track from this animation.

### `find_track(path: NodePath, type: int) -> int`
- 限定：qualifiers=const

Returns the index of the specified track. If the track is not found, return -1.

### `get_marker_at_time(time: float) -> StringName`
- 限定：qualifiers=const

Returns the name of the marker located at the given time.

### `get_marker_color(name: StringName) -> Color`
- 限定：qualifiers=const

Returns the given marker's color.

### `get_marker_names() -> PackedStringArray`
- 限定：qualifiers=const

Returns every marker in this Animation, sorted ascending by time.

### `get_marker_time(name: StringName) -> float`
- 限定：qualifiers=const

Returns the given marker's time.

### `get_next_marker(time: float) -> StringName`
- 限定：qualifiers=const

Returns the closest marker that comes after the given time. If no such marker exists, an empty string is returned.

### `get_prev_marker(time: float) -> StringName`
- 限定：qualifiers=const

Returns the closest marker that comes before the given time. If no such marker exists, an empty string is returned.

### `get_track_count() -> int`
- 限定：qualifiers=const

Returns the amount of tracks in the animation.

### `has_marker(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if this Animation contains a marker with the given name.

### `method_track_get_name(track_idx: int, key_idx: int) -> StringName`
- 限定：qualifiers=const

Returns the method name of a method track.

### `method_track_get_params(track_idx: int, key_idx: int) -> Array`
- 限定：qualifiers=const

Returns the arguments values to be called on a method track for a given key in a given track.

### `optimize(allowed_velocity_err: float = 0.01, allowed_angular_err: float = 0.01, precision: int = 3) -> void`

Optimize the animation and all its tracks in-place. This will preserve only as many keys as are necessary to keep the animation within the specified bounds.

### `position_track_insert_key(track_idx: int, time: float, position: Vector3) -> int`

Inserts a key in a given 3D position track. Returns the key index.

### `position_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) -> Vector3`
- 限定：qualifiers=const

Returns the interpolated position value at the given time (in seconds). The `track_idx` must be the index of a 3D position track.

### `remove_marker(name: StringName) -> void`

Removes the marker with the given name from this Animation.

### `remove_track(track_idx: int) -> void`

Removes a track by specifying the track index.

### `rotation_track_insert_key(track_idx: int, time: float, rotation: Quaternion) -> int`

Inserts a key in a given 3D rotation track. Returns the key index.

### `rotation_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) -> Quaternion`
- 限定：qualifiers=const

Returns the interpolated rotation value at the given time (in seconds). The `track_idx` must be the index of a 3D rotation track.

### `scale_track_insert_key(track_idx: int, time: float, scale: Vector3) -> int`

Inserts a key in a given 3D scale track. Returns the key index.

### `scale_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) -> Vector3`
- 限定：qualifiers=const

Returns the interpolated scale value at the given time (in seconds). The `track_idx` must be the index of a 3D scale track.

### `set_marker_color(name: StringName, color: Color) -> void`

Sets the given marker's color.

### `track_find_key(track_idx: int, time: float, find_mode: int = 0, limit: bool = false, backward: bool = false) -> int`
- 限定：qualifiers=const

Finds the key index by time in a given track. Optionally, only find it if the approx/exact time is given.
				If `limit` is `true`, it does not return keys outside the animation range.
				If `backward` is `true`, the direction is reversed in methods that rely on one directional processing.
				For example, in case `find_mode` is `FIND_MODE_NEAREST`, if there is no key in the current position just after seeked, the first key found is retrieved by searching before the position, but if `backward` is `true`, the first key found is retrieved after the position.

### `track_get_interpolation_loop_wrap(track_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the track at `track_idx` wraps the interpolation loop. New tracks wrap the interpolation loop by default.

### `track_get_interpolation_type(track_idx: int) -> int`
- 限定：qualifiers=const

Returns the interpolation type of a given track.

### `track_get_key_count(track_idx: int) -> int`
- 限定：qualifiers=const

Returns the number of keys in a given track.

### `track_get_key_time(track_idx: int, key_idx: int) -> float`
- 限定：qualifiers=const

Returns the time at which the key is located.

### `track_get_key_transition(track_idx: int, key_idx: int) -> float`
- 限定：qualifiers=const

Returns the transition curve (easing) for a specific key (see the built-in math function `@GlobalScope.ease`).

### `track_get_key_value(track_idx: int, key_idx: int) -> Variant`
- 限定：qualifiers=const

Returns the value of a given key in a given track.

### `track_get_path(track_idx: int) -> NodePath`
- 限定：qualifiers=const

Gets the path of a track. For more information on the path format, see `track_set_path`.

### `track_get_type(track_idx: int) -> int`
- 限定：qualifiers=const

Gets the type of a track.

### `track_insert_key(track_idx: int, time: float, key: Variant, transition: float = 1) -> int`

Inserts a generic key in a given track. Returns the key index.

### `track_is_compressed(track_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the track is compressed, `false` otherwise. See also `compress`.

### `track_is_enabled(track_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the track at index `track_idx` is enabled.

### `track_is_imported(track_idx: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given track is imported. Else, return `false`.

### `track_move_down(track_idx: int) -> void`

Moves a track down.

### `track_move_to(track_idx: int, to_idx: int) -> void`

Changes the index position of track `track_idx` to the one defined in `to_idx`.

### `track_move_up(track_idx: int) -> void`

Moves a track up.

### `track_remove_key(track_idx: int, key_idx: int) -> void`

Removes a key by index in a given track.

### `track_remove_key_at_time(track_idx: int, time: float) -> void`

Removes a key at `time` in a given track.

### `track_set_enabled(track_idx: int, enabled: bool) -> void`

Enables/disables the given track. Tracks are enabled by default.

### `track_set_imported(track_idx: int, imported: bool) -> void`

Sets the given track as imported or not.

### `track_set_interpolation_loop_wrap(track_idx: int, interpolation: bool) -> void`

If `true`, the track at `track_idx` wraps the interpolation loop.

### `track_set_interpolation_type(track_idx: int, interpolation: int) -> void`

Sets the interpolation type of a given track.

### `track_set_key_time(track_idx: int, key_idx: int, time: float) -> void`

Sets the time of an existing key.

### `track_set_key_transition(track_idx: int, key_idx: int, transition: float) -> void`

Sets the transition curve (easing) for a specific key (see the built-in math function `@GlobalScope.ease`).

### `track_set_key_value(track_idx: int, key: int, value: Variant) -> void`

Sets the value of an existing key.

### `track_set_path(track_idx: int, path: NodePath) -> void`

Sets the path of a track. Paths must be valid scene-tree paths to a node and must be specified starting from the `AnimationMixer.root_node` that will reproduce the animation. Tracks that control properties or bones must append their name after the path, separated by `":"`.
				For example, `"character/skeleton:ankle"` or `"character/mesh:transform/local"`.

### `track_swap(track_idx: int, with_idx: int) -> void`

Swaps the track `track_idx`'s index position with the track `with_idx`.

### `value_track_get_update_mode(track_idx: int) -> int`
- 限定：qualifiers=const

Returns the update mode of a value track.

### `value_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) -> Variant`
- 限定：qualifiers=const

Returns the interpolated value at the given time (in seconds). The `track_idx` must be the index of a value track.
				A `backward` mainly affects the direction of key retrieval of the track with `UPDATE_DISCRETE` converted by `AnimationMixer.ANIMATION_CALLBACK_MODE_DISCRETE_FORCE_CONTINUOUS` to match the result with `track_find_key`.

### `value_track_set_update_mode(track_idx: int, mode: int) -> void`

Sets the update mode of a value track.

## 枚举

### `TrackType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_VALUE` |  |
| `1` | `TYPE_POSITION_3D` |  |
| `2` | `TYPE_ROTATION_3D` |  |
| `3` | `TYPE_SCALE_3D` |  |
| `4` | `TYPE_BLEND_SHAPE` |  |
| `5` | `TYPE_METHOD` |  |
| `6` | `TYPE_BEZIER` |  |
| `7` | `TYPE_AUDIO` |  |
| `8` | `TYPE_ANIMATION` |  |

### `InterpolationType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INTERPOLATION_NEAREST` |  |
| `1` | `INTERPOLATION_LINEAR` |  |
| `2` | `INTERPOLATION_CUBIC` |  |
| `3` | `INTERPOLATION_LINEAR_ANGLE` |  |
| `4` | `INTERPOLATION_CUBIC_ANGLE` |  |

### `UpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UPDATE_CONTINUOUS` |  |
| `1` | `UPDATE_DISCRETE` |  |
| `2` | `UPDATE_CAPTURE` |  |

### `LoopMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOOP_NONE` |  |
| `1` | `LOOP_LINEAR` |  |
| `2` | `LOOP_PINGPONG` |  |

### `LoopedFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOOPED_FLAG_NONE` |  |
| `1` | `LOOPED_FLAG_END` |  |
| `2` | `LOOPED_FLAG_START` |  |

### `FindMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FIND_MODE_NEAREST` |  |
| `1` | `FIND_MODE_APPROX` |  |
| `2` | `FIND_MODE_EXACT` |  |

## 教程链接

- [Animation documentation index](None)

