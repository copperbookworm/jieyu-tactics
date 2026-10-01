# PhysicsDirectSpaceState2DExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsDirectSpaceState2DExtension` → `PhysicsDirectSpaceState2D` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsDirectSpaceState2DExtension.md`

**摘要**：Provides virtual methods that can be overridden to create custom `PhysicsDirectSpaceState2D` implementations.

## 描述

This class extends `PhysicsDirectSpaceState2D` by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.
		Intended for use with GDExtension to create custom implementations of `PhysicsDirectSpaceState2D`.

## 方法

### `_cast_motion(shape_rid: RID, transform: Transform2D, motion: Vector2, margin: float, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, r_closest_safe: float*, r_closest_unsafe: float*) -> bool`
- 限定：qualifiers=virtual required

### `_collide_shape(shape_rid: RID, transform: Transform2D, motion: Vector2, margin: float, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, r_results: void*, max_results: int, r_result_count: int32_t*) -> bool`
- 限定：qualifiers=virtual required

### `_intersect_point(position: Vector2, canvas_instance_id: int, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, r_results: PhysicsServer2DExtensionShapeResult*, max_results: int) -> int`
- 限定：qualifiers=virtual required

### `_intersect_ray(from: Vector2, to: Vector2, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, hit_from_inside: bool, r_result: PhysicsServer2DExtensionRayResult*) -> bool`
- 限定：qualifiers=virtual required

### `_intersect_shape(shape_rid: RID, transform: Transform2D, motion: Vector2, margin: float, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, r_result: PhysicsServer2DExtensionShapeResult*, max_results: int) -> int`
- 限定：qualifiers=virtual required

### `_rest_info(shape_rid: RID, transform: Transform2D, motion: Vector2, margin: float, collision_mask: int, collide_with_bodies: bool, collide_with_areas: bool, r_rest_info: PhysicsServer2DExtensionShapeRestInfo*) -> bool`
- 限定：qualifiers=virtual required

### `is_body_excluded_from_query(body: RID) -> bool`
- 限定：qualifiers=const

