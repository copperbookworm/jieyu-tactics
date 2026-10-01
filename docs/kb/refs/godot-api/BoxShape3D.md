# BoxShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoxShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoxShape3D.md`

**摘要**：A 3D box shape used for physics collision.

## 描述

A 3D box shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape3D`.
		**Performance:** `BoxShape3D` is fast to check collisions against. It is faster than `CapsuleShape3D` and `CylinderShape3D`, but slower than `SphereShape3D`.

## 属性

- **`size`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_size · setter=set_size

## 教程链接

- [3D Physics Tests Demo](None)
- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)

