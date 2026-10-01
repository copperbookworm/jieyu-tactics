# CylinderShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CylinderShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CylinderShape3D.md`

**摘要**：A 3D cylinder shape used for physics collision.

## 描述

A 3D cylinder shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape3D`.
		**Note:** There are several known bugs with cylinder collision shapes. Using `CapsuleShape3D` or `BoxShape3D` instead is recommended.
		**Performance:** `CylinderShape3D` is fast to check collisions against, but it is slower than `CapsuleShape3D`, `BoxShape3D`, and `SphereShape3D`.

## 属性

- **`height`** `float` = `2.0`
  - 其它属性：getter=get_height · setter=set_height
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius

## 教程链接

- [Third Person Shooter (TPS) Demo](None)
- [3D Physics Tests Demo](None)
- [3D Voxel Demo](None)

