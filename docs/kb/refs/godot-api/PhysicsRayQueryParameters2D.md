# PhysicsRayQueryParameters2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsRayQueryParameters2D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsRayQueryParameters2D.md`

**摘要**：Provides parameters for `PhysicsDirectSpaceState2D.intersect_ray`.

## 描述

By changing various properties of this object, such as the ray position, you can configure the parameters for `PhysicsDirectSpaceState2D.intersect_ray`.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`exclude`** `RID[]` = `[]`
  - 其它属性：getter=get_exclude · setter=set_exclude
- **`from`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_from · setter=set_from
- **`hit_from_inside`** `bool` = `false`
  - 其它属性：getter=is_hit_from_inside_enabled · setter=set_hit_from_inside
- **`to`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_to · setter=set_to

## 方法

### `create(from: Vector2, to: Vector2, collision_mask: int = 4294967295, exclude: RID[] = []) -> PhysicsRayQueryParameters2D`
- 限定：qualifiers=static

Returns a new, pre-configured `PhysicsRayQueryParameters2D` object. Use it to quickly create query parameters using the most common options.
				
```gdscript
				var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 100))
				var collision = get_world_2d().direct_space_state.intersect_ray(query)
				
```

