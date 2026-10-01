# PhysicsShapeQueryParameters2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsShapeQueryParameters2D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsShapeQueryParameters2D.md`

**摘要**：Provides parameters for `PhysicsDirectSpaceState2D`'s methods.

## 描述

By changing various properties of this object, such as the shape, you can configure the parameters for `PhysicsDirectSpaceState2D`'s methods.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`exclude`** `RID[]` = `[]`
  - 其它属性：getter=get_exclude · setter=set_exclude
- **`margin`** `float` = `0.0`
  - 其它属性：getter=get_margin · setter=set_margin
- **`motion`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_motion · setter=set_motion
- **`shape`** `Resource`
  - 其它属性：getter=get_shape · setter=set_shape
- **`shape_rid`** `RID` = `RID()`
  - 其它属性：getter=get_shape_rid · setter=set_shape_rid
- **`transform`** `Transform2D` = `Transform2D(1, 0, 0, 1, 0, 0)`
  - 其它属性：getter=get_transform · setter=set_transform

