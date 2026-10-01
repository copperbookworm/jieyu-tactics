# PhysicsTestMotionParameters2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsTestMotionParameters2D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsTestMotionParameters2D.md`

**摘要**：Provides parameters for `PhysicsServer2D.body_test_motion`.

## 描述

By changing various properties of this object, such as the motion, you can configure the parameters for `PhysicsServer2D.body_test_motion`.

## 属性

- **`collide_separation_ray`** `bool` = `false`
  - 其它属性：getter=is_collide_separation_ray_enabled · setter=set_collide_separation_ray_enabled
- **`exclude_bodies`** `RID[]` = `[]`
  - 其它属性：getter=get_exclude_bodies · setter=set_exclude_bodies
- **`exclude_objects`** `int[]` = `[]`
  - 其它属性：getter=get_exclude_objects · setter=set_exclude_objects
- **`from`** `Transform2D` = `Transform2D(1, 0, 0, 1, 0, 0)`
  - 其它属性：getter=get_from · setter=set_from
- **`margin`** `float` = `0.08`
  - 其它属性：getter=get_margin · setter=set_margin
- **`motion`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_motion · setter=set_motion
- **`recovery_as_collision`** `bool` = `false`
  - 其它属性：getter=is_recovery_as_collision_enabled · setter=set_recovery_as_collision_enabled

