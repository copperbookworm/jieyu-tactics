# InputEventMouseMotion

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`InputEventMouseMotion` → `InputEventMouse` → `InputEventWithModifiers` → `InputEventFromWindow` → `InputEvent` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/InputEventMouseMotion.md`

**摘要**：Represents a mouse or a pen movement.

## 描述

Stores information about a mouse or a pen motion. This includes relative position, absolute position, and velocity. See `Node._input`.
		**Note:** By default, this event is only emitted once per frame rendered at most. If you need more precise input reporting, set `Input.use_accumulated_input` to `false` to make events emitted as often as possible. If you use InputEventMouseMotion to draw lines, consider using `Geometry2D.bresenham_line` as well to avoid visible gaps in lines if the user is moving the mouse quickly.
		**Note:** This event may be emitted even when the mouse hasn't moved, either by the operating system or by Godot itself. If you really need to know if the mouse has moved (e.g. to suppress displaying a tooltip), you should check that `relative.is_zero_approx()` is `false`.

## 属性

- **`pen_inverted`** `bool` = `false`
  - 其它属性：getter=get_pen_inverted · setter=set_pen_inverted
- **`pressure`** `float` = `0.0`
  - 其它属性：getter=get_pressure · setter=set_pressure
- **`relative`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_relative · setter=set_relative
- **`screen_relative`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_screen_relative · setter=set_screen_relative
- **`screen_velocity`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_screen_velocity · setter=set_screen_velocity
- **`tilt`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_tilt · setter=set_tilt
- **`velocity`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_velocity · setter=set_velocity

## 教程链接

- [Using InputEvent](None)
- [Mouse and input coordinates](None)
- [3D Voxel Demo](None)

