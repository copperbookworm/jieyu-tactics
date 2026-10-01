# AudioStreamInteractive

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioStreamInteractive` → `AudioStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AudioStreamInteractive.md`

**摘要**：Audio stream that can playback music interactively, combining clips and a transition table.

## 描述

This is an audio stream that can playback music interactively, combining clips and a transition table. Clips must be added first, and then the transition rules via the `add_transition`. Additionally, this stream exports a property parameter to control the playback via `AudioStreamPlayer`, `AudioStreamPlayer2D`, or `AudioStreamPlayer3D`.
		The way this is used is by filling a number of clips, then configuring the transition table. From there, clips are selected for playback and the music will smoothly go from the current to the new one while using the corresponding transition rule defined in the transition table.

## 属性

- **`clip_count`** `int` = `0`
  - 其它属性：getter=get_clip_count · setter=set_clip_count
- **`initial_clip`** `int` = `0`
  - 其它属性：getter=get_initial_clip · setter=set_initial_clip

## 方法

### `add_transition(from_clip: int, to_clip: int, from_time: int, to_time: int, fade_mode: int, fade_beats: float, use_filler_clip: bool = false, filler_clip: int = -1, hold_previous: bool = false) -> void`

Add a transition between two clips. Provide the indices of the source and destination clips, or use the `CLIP_ANY` constant to indicate that transition happens to/from any clip to this one.
				* `from_time` indicates the moment in the current clip the transition will begin after triggered.
				* `to_time` indicates the time in the next clip that the playback will start from.
				* `fade_mode` indicates how the fade will happen between clips. If unsure, just use `FADE_AUTOMATIC` which uses the most common type of fade for each situation.
				* `fade_beats` indicates how many beats the fade will take. Using decimals is allowed.
				* `use_filler_clip` indicates that there will be a filler clip used between the source and destination clips.
				* `filler_clip` the index of the filler clip.
				* If `hold_previous` is used, then this clip will be remembered. This can be used together with `AUTO_ADVANCE_RETURN_TO_HOLD` to return to this clip after another is done playing.

### `erase_transition(from_clip: int, to_clip: int) -> void`

Erase a transition by providing `from_clip` and `to_clip` clip indices. `CLIP_ANY` can be used for either argument or both.

### `get_clip_auto_advance(clip_index: int) -> int`
- 限定：qualifiers=const

Return whether a clip has auto-advance enabled. See `set_clip_auto_advance`.

### `get_clip_auto_advance_next_clip(clip_index: int) -> int`
- 限定：qualifiers=const

Return the clip towards which the clip referenced by `clip_index` will auto-advance to.

### `get_clip_name(clip_index: int) -> StringName`
- 限定：qualifiers=const

Return the name of a clip.

### `get_clip_stream(clip_index: int) -> AudioStream`
- 限定：qualifiers=const

Return the `AudioStream` associated with a clip.

### `get_transition_fade_beats(from_clip: int, to_clip: int) -> float`
- 限定：qualifiers=const

Return the time (in beats) for a transition (see `add_transition`).

### `get_transition_fade_mode(from_clip: int, to_clip: int) -> int`
- 限定：qualifiers=const

Return the mode for a transition (see `add_transition`).

### `get_transition_filler_clip(from_clip: int, to_clip: int) -> int`
- 限定：qualifiers=const

Return the filler clip for a transition (see `add_transition`).

### `get_transition_from_time(from_clip: int, to_clip: int) -> int`
- 限定：qualifiers=const

Return the source time position for a transition (see `add_transition`).

### `get_transition_list() -> PackedInt32Array`
- 限定：qualifiers=const

Return the list of transitions (from, to interleaved).

### `get_transition_to_time(from_clip: int, to_clip: int) -> int`
- 限定：qualifiers=const

Return the destination time position for a transition (see `add_transition`).

### `has_transition(from_clip: int, to_clip: int) -> bool`
- 限定：qualifiers=const

Returns `true` if a given transition exists (was added via `add_transition`).

### `is_transition_holding_previous(from_clip: int, to_clip: int) -> bool`
- 限定：qualifiers=const

Return whether a transition uses the *hold previous* functionality (see `add_transition`).

### `is_transition_using_filler_clip(from_clip: int, to_clip: int) -> bool`
- 限定：qualifiers=const

Return whether a transition uses the *filler clip* functionality (see `add_transition`).

### `set_clip_auto_advance(clip_index: int, mode: int) -> void`

Set whether a clip will auto-advance by changing the auto-advance mode.

### `set_clip_auto_advance_next_clip(clip_index: int, auto_advance_next_clip: int) -> void`

Set the index of the next clip towards which this clip will auto advance to when finished. If the clip being played loops, then auto-advance will be ignored.

### `set_clip_name(clip_index: int, name: StringName) -> void`

Set the name of the current clip (for easier identification).

### `set_clip_stream(clip_index: int, stream: AudioStream) -> void`

Set the `AudioStream` associated with the current clip.

## 枚举

### `TransitionFromTime`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSITION_FROM_TIME_IMMEDIATE` |  |
| `1` | `TRANSITION_FROM_TIME_NEXT_BEAT` |  |
| `2` | `TRANSITION_FROM_TIME_NEXT_BAR` |  |
| `3` | `TRANSITION_FROM_TIME_END` |  |

### `TransitionToTime`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSITION_TO_TIME_SAME_POSITION` |  |
| `1` | `TRANSITION_TO_TIME_START` |  |
| `2` | `TRANSITION_TO_TIME_PREVIOUS_POSITION` |  |

### `FadeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FADE_DISABLED` |  |
| `1` | `FADE_IN` |  |
| `2` | `FADE_OUT` |  |
| `3` | `FADE_CROSS` |  |
| `4` | `FADE_AUTOMATIC` |  |

### `AutoAdvanceMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AUTO_ADVANCE_DISABLED` |  |
| `1` | `AUTO_ADVANCE_ENABLED` |  |
| `2` | `AUTO_ADVANCE_RETURN_TO_HOLD` |  |

## 常量

- **`CLIP_ANY`** = `-1`
## 教程链接

- [Audio streams](None)

