# AnimatableBody3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AnimatableBody3D` → `StaticBody3D` → `PhysicsBody3D` → `CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AnimatableBody3D.md`

**摘要**：A 3D physics body that can't be moved by external forces. When moved manually, it affects other bodies in its path.

## 描述

An animatable 3D physics body. It can't be moved by external forces or contacts, but can be moved manually by other means such as code, `AnimationMixer`s (with `AnimationMixer.callback_mode_process` set to `AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS`), and `RemoteTransform3D`.
		When `AnimatableBody3D` is moved, its linear and angular velocity are estimated and used to affect other physics bodies in its path. This makes it useful for moving platforms, doors, and other moving objects.

## 属性

- **`sync_to_physics`** `bool` = `true`
  - 其它属性：getter=is_sync_to_physics_enabled · setter=set_sync_to_physics

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)
- [3D Physics Tests Demo](None)
- [Third Person Shooter (TPS) Demo](None)
- [3D Voxel Demo](None)

