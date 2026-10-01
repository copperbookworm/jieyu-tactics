# StaticBody2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StaticBody2D` → `PhysicsBody2D` → `CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StaticBody2D.md`

**摘要**：A 2D physics body that can't be moved by external forces. When moved manually, it doesn't affect other bodies in its path.

## 描述

A static 2D physics body. It can't be moved by external forces or contacts, but can be moved manually by other means such as code, `AnimationMixer`s (with `AnimationMixer.callback_mode_process` set to `AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS`), and `RemoteTransform2D`.
		When `StaticBody2D` is moved, it is teleported to its new position without affecting other physics bodies in its path. If this is not desired, use `AnimatableBody2D` instead.
		`StaticBody2D` is useful for completely static objects like floors and walls, as well as moving surfaces like conveyor belts and circular revolving platforms (by using `constant_linear_velocity` and `constant_angular_velocity`).

## 属性

- **`constant_angular_velocity`** `float` = `0.0`
  - 其它属性：getter=get_constant_angular_velocity · setter=set_constant_angular_velocity
- **`constant_linear_velocity`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_constant_linear_velocity · setter=set_constant_linear_velocity
- **`physics_material_override`** `PhysicsMaterial`
  - 其它属性：getter=get_physics_material_override · setter=set_physics_material_override

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)

