# AnimatedTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimatedTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · deprecated=This class does not work properly in current versions and may be removed in the future. There is currently no equivalent workaround.
> 自动生成，勿手改。文件：`refs/godot-api/AnimatedTexture.md`

**摘要**：Proxy texture for simple frame-based animations.

## 描述

`AnimatedTexture` is a resource format for frame-based animations, where multiple textures can be chained automatically with a predefined delay for each frame. Unlike `AnimationPlayer` or `AnimatedSprite2D`, it isn't a `Node`, but has the advantage of being usable anywhere a `Texture2D` resource can be used, e.g. in a `TileSet`.
		The playback of the animation is controlled by the `speed_scale` property, as well as each frame's duration (see `set_frame_duration`). The animation loops, i.e. it will restart at frame 0 automatically after playing the last frame.
		`AnimatedTexture` currently requires all frame textures to have the same size, otherwise the bigger ones will be cropped to match the smallest one.
		**Note:** AnimatedTexture doesn't support using `AtlasTexture`s. Each frame needs to be a separate `Texture2D`.
		**Warning:** The current implementation is not efficient for the modern renderers.

## 属性

- **`current_frame`** `int`
  - 其它属性：getter=get_current_frame · setter=set_current_frame
- **`frames`** `int` = `1`
  - 其它属性：getter=get_frames · setter=set_frames
- **`one_shot`** `bool` = `false`
  - 其它属性：getter=get_one_shot · setter=set_one_shot
- **`pause`** `bool` = `false`
  - 其它属性：getter=get_pause · setter=set_pause
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale

## 方法

### `get_frame_duration(frame: int) -> float`
- 限定：qualifiers=const

Returns the given `frame`'s duration, in seconds.

### `get_frame_texture(frame: int) -> Texture2D`
- 限定：qualifiers=const

Returns the given frame's `Texture2D`.

### `set_frame_duration(frame: int, duration: float) -> void`

Sets the duration of any given `frame`. The final duration is affected by the `speed_scale`. If set to `0`, the frame is skipped during playback.

### `set_frame_texture(frame: int, texture: Texture2D) -> void`

Assigns a `Texture2D` to the given frame. Frame IDs start at 0, so the first frame has ID 0, and the last frame of the animation has ID `frames` - 1.
				You can define any number of textures up to `MAX_FRAMES`, but keep in mind that only frames from 0 to `frames` - 1 will be part of the animation.

## 常量

- **`MAX_FRAMES`** = `256`
