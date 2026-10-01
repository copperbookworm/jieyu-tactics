# CapsuleShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CapsuleShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CapsuleShape3D.md`

**摘要**：A 3D capsule shape used for physics collision.

## 描述

A 3D capsule shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape3D`.
		**Performance:** `CapsuleShape3D` is fast to check collisions against. It is faster than `CylinderShape3D`, but slower than `SphereShape3D` and `BoxShape3D`.

## 属性

- **`height`** `float` = `2.0`
  - 其它属性：getter=get_height · setter=set_height
- **`mid_height`** `float`
  - 其它属性：getter=get_mid_height · setter=set_mid_height
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius

## 教程链接

- [3D Physics Tests Demo](None)

