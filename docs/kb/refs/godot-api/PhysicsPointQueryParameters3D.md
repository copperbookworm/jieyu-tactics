# PhysicsPointQueryParameters3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsPointQueryParameters3D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsPointQueryParameters3D.md`

**摘要**：Provides parameters for `PhysicsDirectSpaceState3D.intersect_point`.

## 描述

By changing various properties of this object, such as the point position, you can configure the parameters for `PhysicsDirectSpaceState3D.intersect_point`.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`exclude`** `RID[]` = `[]`
  - 其它属性：getter=get_exclude · setter=set_exclude
- **`position`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_position · setter=set_position

