# AnimatedSprite2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimatedSprite2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimatedSprite2D.md`

**摘要**：Sprite node that contains multiple textures as frames to play for animation.

## 描述

`AnimatedSprite2D` is similar to the `Sprite2D` node, except it carries multiple textures as animation frames. Animations are created using a `SpriteFrames` resource, which allows you to import image files (or a folder containing said files) to provide the animation frames for the sprite. The `SpriteFrames` resource can be configured in the editor via the SpriteFrames bottom panel.

## 属性

- **`animation`** `StringName` = `&"default"`
  - 其它属性：getter=get_animation · setter=set_animation
- **`autoplay`** `String` = `""`
  - 其它属性：getter=get_autoplay · setter=set_autoplay
- **`centered`** `bool` = `true`
  - 其它属性：getter=is_centered · setter=set_centered
- **`flip_h`** `bool` = `false`
  - 其它属性：getter=is_flipped_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=is_flipped_v · setter=set_flip_v
- **`frame`** `int` = `0`
  - 其它属性：getter=get_frame · setter=set_frame
- **`frame_progress`** `float` = `0.0`
  - 其它属性：getter=get_frame_progress · setter=set_frame_progress
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale
- **`sprite_frames`** `SpriteFrames`
  - 其它属性：getter=get_sprite_frames · setter=set_sprite_frames

## 方法

### `get_playing_speed() -> float`
- 限定：qualifiers=const

Returns the actual playing speed of current animation or `0` if not playing. This speed is the `speed_scale` property multiplied by `custom_speed` argument specified when calling the `play` method.
				Returns a negative value if the current animation is playing backwards.

### `is_playing() -> bool`
- 限定：qualifiers=const

Returns `true` if an animation is currently playing (even if `speed_scale` and/or `custom_speed` are `0`).

### `pause() -> void`

Pauses the currently playing animation. The `frame` and `frame_progress` will be kept and calling `play` or `play_backwards` without arguments will resume the animation from the current playback position.
				See also `stop`.

### `play(name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false) -> void`

Plays the animation with key `name`. If `custom_speed` is negative and `from_end` is `true`, the animation will play backwards (which is equivalent to calling `play_backwards`).
				If this method is called with that same animation `name`, or with no `name` parameter, the assigned animation will resume playing if it was paused.

### `play_backwards(name: StringName = &"") -> void`

Plays the animation with key `name` in reverse.
				This method is a shorthand for `play` with `custom_speed = -1.0` and `from_end = true`, so see its description for more information.

### `set_frame_and_progress(frame: int, progress: float) -> void`

Sets `frame` and `frame_progress` to the given values. Unlike setting `frame`, this method does not reset the `frame_progress` to `0.0` implicitly.
				**Example:** Change the animation while keeping the same `frame` and `frame_progress`:
				`codeblocks`
				`gdscript`
				var current_frame = animated_sprite.get_frame()
				var current_progress = animated_sprite.get_frame_progress()
				animated_sprite.play("walk_another_skin")
				animated_sprite.set_frame_and_progress(current_frame, current_progress)

### `stop() -> void`

Stops the currently playing animation. The animation position is reset to `0` and the `custom_speed` is reset to `1.0`. See also `pause`.

## 信号

### `animation_changed()`

Emitted when `animation` changes.

### `animation_finished()`

Emitted when the animation reaches the end, or the start if it is played in reverse. When the animation finishes, it pauses the playback.
				**Note:** This signal is not emitted if an animation is looping.

### `animation_looped()`

Emitted when the animation loops.

### `frame_changed()`

Emitted when `frame` changes.

### `sprite_frames_changed()`

Emitted when `sprite_frames` changes.

## 教程链接

- [2D Sprite animation](None)
- [2D Dodge The Creeps Demo](None)

