# RayCast2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RayCast2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RayCast2D.md`

**摘要**：A ray in 2D space, used to find the first collision object it intersects.

## 描述

A raycast represents a ray from its origin to its `target_position` that finds the closest object along its path, if it intersects any.
		`RayCast2D` can ignore some objects by adding them to an exception list, by making its detection reporting ignore `Area2D`s (`collide_with_areas`) or `PhysicsBody2D`s (`collide_with_bodies`), or by configuring physics layers.
		`RayCast2D` calculates intersection every physics frame, and it holds the result until the next physics frame. For an immediate raycast, or if you want to configure a `RayCast2D` multiple times within the same physics frame, use `force_raycast_update`.
		To sweep over a region of 2D space, you can approximate the region with multiple `RayCast2D`s or use `ShapeCast2D`.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`exclude_parent`** `bool` = `true`
  - 其它属性：getter=get_exclude_parent_body · setter=set_exclude_parent_body
- **`hit_from_inside`** `bool` = `false`
  - 其它属性：getter=is_hit_from_inside_enabled · setter=set_hit_from_inside
- **`target_position`** `Vector2` = `Vector2(0, 50)`
  - 其它属性：getter=get_target_position · setter=set_target_position

## 方法

### `add_exception(node: CollisionObject2D) -> void`

Adds a collision exception so the ray does not report collisions with the specified `node`.

### `add_exception_rid(rid: RID) -> void`

Adds a collision exception so the ray does not report collisions with the specified `RID`.

### `clear_exceptions() -> void`

Removes all collision exceptions for this ray.

### `force_raycast_update() -> void`

Updates the collision information for the ray immediately, without waiting for the next `_physics_process` call. Use this method, for example, when the ray or its parent has changed state.
				**Note:** `enabled` does not need to be `true` for this to work.

### `get_collider() -> Object`
- 限定：qualifiers=const

Returns the first object that the ray intersects, or `null` if no object is intersecting the ray (i.e. `is_colliding` returns `false`).
				**Note:** This object is not guaranteed to be a `CollisionObject2D`. For example, if the ray intersects a `TileMapLayer`, the method will return a `TileMapLayer` instance.

### `get_collider_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the first object that the ray intersects, or an empty `RID` if no object is intersecting the ray (i.e. `is_colliding` returns `false`).

### `get_collider_shape() -> int`
- 限定：qualifiers=const

Returns the shape ID of the first object that the ray intersects, or `0` if no object is intersecting the ray (i.e. `is_colliding` returns `false`).
				To get the intersected shape node, for a `CollisionObject2D` target, use:
				`codeblocks`
				`gdscript`
				var target = get_collider() # A CollisionObject2D.
				var shape_id = get_collider_shape() # The shape index in the collider.
				var owner_id = target.shape_find_owner(shape_id) # The owner ID in the collider.
				var shape = target.shape_owner_get_owner(owner_id)
				
				`csharp`
				var target = (CollisionObject2D)GetCollider(); // A CollisionObject2D.
				var shapeId = GetColliderShape(); // The shape index in the collider.
				var ownerId = target.ShapeFindOwner(shapeId); // The owner ID in the collider.
				var shape = target.ShapeOwnerGetOwner(ownerId);

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_normal() -> Vector2`
- 限定：qualifiers=const

Returns the normal of the intersecting object's shape at the collision point, or `Vector2(0, 0)` if the ray starts inside the shape and `hit_from_inside` is `true`.
				**Note:** Check that `is_colliding` returns `true` before calling this method to ensure the returned normal is valid and up-to-date.

### `get_collision_point() -> Vector2`
- 限定：qualifiers=const

Returns the collision point at which the ray intersects the closest object, in the global coordinate system. If `hit_from_inside` is `true` and the ray starts inside of a collision shape, this function will return the origin point of the ray.
				**Note:** Check that `is_colliding` returns `true` before calling this method to ensure the returned point is valid and up-to-date.

### `is_colliding() -> bool`
- 限定：qualifiers=const

Returns whether any object is intersecting with the ray's vector (considering the vector length).

### `remove_exception(node: CollisionObject2D) -> void`

Removes a collision exception so the ray can report collisions with the specified `node`.

### `remove_exception_rid(rid: RID) -> void`

Removes a collision exception so the ray can report collisions with the specified `RID`.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

## 教程链接

- [Ray-casting](None)

