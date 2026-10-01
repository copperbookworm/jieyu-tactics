# Parallax2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Parallax2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Parallax2D.md`

**摘要**：A node used to create a parallax scrolling background.

## 描述

A `Parallax2D` is used to create a parallax effect. It can move at a different speed relative to the camera movement using `scroll_scale`. This creates an illusion of depth in a 2D game. If manual scrolling is desired, the `Camera2D` position can be ignored with `ignore_camera_scroll`.
		**Note:** Any changes to this node's position made after it enters the scene tree will be overridden if `ignore_camera_scroll` is `false` or `screen_offset` is modified.

## 属性

- **`autoscroll`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_autoscroll · setter=set_autoscroll
- **`follow_viewport`** `bool` = `true`
  - 其它属性：getter=get_follow_viewport · setter=set_follow_viewport
- **`ignore_camera_scroll`** `bool` = `false`
  - 其它属性：getter=is_ignore_camera_scroll · setter=set_ignore_camera_scroll
- **`limit_begin`** `Vector2` = `Vector2(-10000000, -10000000)`
  - 其它属性：getter=get_limit_begin · setter=set_limit_begin
- **`limit_end`** `Vector2` = `Vector2(10000000, 10000000)`
  - 其它属性：getter=get_limit_end · setter=set_limit_end
- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode
- **`repeat_size`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_repeat_size · setter=set_repeat_size
- **`repeat_times`** `int` = `1`
  - 其它属性：getter=get_repeat_times · setter=set_repeat_times
- **`screen_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_screen_offset · setter=set_screen_offset
- **`scroll_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_scroll_offset · setter=set_scroll_offset
- **`scroll_scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_scroll_scale · setter=set_scroll_scale

## 教程链接

- [2D Parallax](None)

