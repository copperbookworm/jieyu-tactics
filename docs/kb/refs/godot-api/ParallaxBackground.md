# ParallaxBackground

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ParallaxBackground` → `CanvasLayer` → `Node` → `Object`
> 附加属性：api_type=core · deprecated=Use the [Parallax2D] node instead.
> 自动生成，勿手改。文件：`refs/godot-api/ParallaxBackground.md`

**摘要**：A node used to create a parallax scrolling background.

## 描述

A ParallaxBackground uses one or more `ParallaxLayer` child nodes to create a parallax effect. Each `ParallaxLayer` can move at a different speed using `ParallaxLayer.motion_offset`. This creates an illusion of depth in a 2D game. If not used with a `Camera2D`, you must manually calculate the `scroll_offset`.
		**Note:** Each `ParallaxBackground` is drawn on one specific `Viewport` and cannot be shared between multiple `Viewport`s, see `CanvasLayer.custom_viewport`. When using multiple `Viewport`s, for example in a split-screen game, you need create an individual `ParallaxBackground` for each `Viewport` you want it to be drawn on.

## 属性

- **`layer`** `int` = `-100`
  - 其它属性：getter=get_layer · overrides=CanvasLayer · setter=set_layer
- **`scroll_base_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_scroll_base_offset · setter=set_scroll_base_offset
- **`scroll_base_scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_scroll_base_scale · setter=set_scroll_base_scale
- **`scroll_ignore_camera_zoom`** `bool` = `false`
  - 其它属性：getter=is_ignore_camera_zoom · setter=set_ignore_camera_zoom
- **`scroll_limit_begin`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_limit_begin · setter=set_limit_begin
- **`scroll_limit_end`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_limit_end · setter=set_limit_end
- **`scroll_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_scroll_offset · setter=set_scroll_offset

