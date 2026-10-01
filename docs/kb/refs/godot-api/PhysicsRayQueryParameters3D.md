# PhysicsRayQueryParameters3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsRayQueryParameters3D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsRayQueryParameters3D.md`

**摘要**：Provides parameters for `PhysicsDirectSpaceState3D.intersect_ray`.

## 描述

By changing various properties of this object, such as the ray position, you can configure the parameters for `PhysicsDirectSpaceState3D.intersect_ray`.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `4294967295`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`exclude`** `RID[]` = `[]`
  - 其它属性：getter=get_exclude · setter=set_exclude
- **`from`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_from · setter=set_from
- **`hit_back_faces`** `bool` = `true`
  - 其它属性：getter=is_hit_back_faces_enabled · setter=set_hit_back_faces
- **`hit_from_inside`** `bool` = `false`
  - 其它属性：getter=is_hit_from_inside_enabled · setter=set_hit_from_inside
- **`to`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_to · setter=set_to

## 方法

### `create(from: Vector3, to: Vector3, collision_mask: int = 4294967295, exclude: RID[] = []) -> PhysicsRayQueryParameters3D`
- 限定：qualifiers=static

Returns a new, pre-configured `PhysicsRayQueryParameters3D` object. Use it to quickly create query parameters using the most common options.
				
```gdscript
				var query = PhysicsRayQueryParameters3D.create(position, position + Vector3(0, -10, 0))
				var collision = get_world_3d().direct_space_state.intersect_ray(query)
				
```

