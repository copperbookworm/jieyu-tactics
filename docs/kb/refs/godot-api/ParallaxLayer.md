# ParallaxLayer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ParallaxLayer` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · deprecated=Use the [Parallax2D] node instead.
> 自动生成，勿手改。文件：`refs/godot-api/ParallaxLayer.md`

**摘要**：A parallax scrolling layer to be used with `ParallaxBackground`.

## 描述

A ParallaxLayer must be the child of a `ParallaxBackground` node. Each ParallaxLayer can be set to move at different speeds relative to the camera movement or the `ParallaxBackground.scroll_offset` value.
		This node's children will be affected by its scroll offset.
		**Note:** Any changes to this node's position and scale made after it enters the scene will be ignored.

## 属性

- **`motion_mirroring`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_mirroring · setter=set_mirroring
- **`motion_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_motion_offset · setter=set_motion_offset
- **`motion_scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_motion_scale · setter=set_motion_scale
- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode

