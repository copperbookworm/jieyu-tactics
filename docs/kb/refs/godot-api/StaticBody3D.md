# StaticBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`StaticBody3D` → `PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/StaticBody3D.md`

**摘要**：A 3D physics body that can't be moved by external forces. When moved manually, it doesn't affect other bodies in its path.

## 描述

A static 3D physics body. It can't be moved by external forces or contacts, but can be moved manually by other means such as code, `AnimationMixer`s (with `AnimationMixer.callback_mode_process` set to `AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS`), and `RemoteTransform3D`.
		When `StaticBody3D` is moved, it is teleported to its new position without affecting other physics bodies in its path. If this is not desired, use `AnimatableBody3D` instead.
		`StaticBody3D` is useful for completely static objects like floors and walls, as well as moving surfaces like conveyor belts and circular revolving platforms (by using `constant_linear_velocity` and `constant_angular_velocity`).

## 属性

- **`constant_angular_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_constant_angular_velocity · setter=set_constant_angular_velocity
- **`constant_linear_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_constant_linear_velocity · setter=set_constant_linear_velocity
- **`physics_material_override`** `PhysicsMaterial`
  - 其它属性：getter=get_physics_material_override · setter=set_physics_material_override

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)
- [3D Physics Tests Demo](None)
- [Third Person Shooter (TPS) Demo](None)
- [3D Voxel Demo](None)

