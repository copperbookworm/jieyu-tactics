# ShapeCast2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ShapeCast2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ShapeCast2D.md`

**摘要**：A 2D shape that sweeps a region of space to detect `CollisionObject2D`s.

## 描述

Shape casting allows to detect collision objects by sweeping its `shape` along the cast direction determined by `target_position`. This is similar to `RayCast2D`, but it allows for sweeping a region of space, rather than just a straight line. `ShapeCast2D` can detect multiple collision objects. It is useful for things like wide laser beams or snapping a simple shape to a floor.
		Immediate collision overlaps can be done with the `target_position` set to `Vector2(0, 0)` and by calling `force_shapecast_update` within the same physics frame. This helps to overcome some limitations of `Area2D` when used as an instantaneous detection area, as collision information isn't immediately available to it.
		**Note:** Shape casting is more computationally expensive than ray casting.

## 属性

- **`collide_with_areas`** `bool` = `false`
  - 其它属性：getter=is_collide_with_areas_enabled · setter=set_collide_with_areas
- **`collide_with_bodies`** `bool` = `true`
  - 其它属性：getter=is_collide_with_bodies_enabled · setter=set_collide_with_bodies
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`collision_result`** `Array` = `[]`
  - 其它属性：getter=get_collision_result · setter=
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`exclude_parent`** `bool` = `true`
  - 其它属性：getter=get_exclude_parent_body · setter=set_exclude_parent_body
- **`margin`** `float` = `0.0`
  - 其它属性：getter=get_margin · setter=set_margin
- **`max_results`** `int` = `32`
  - 其它属性：getter=get_max_results · setter=set_max_results
- **`shape`** `Shape2D`
  - 其它属性：getter=get_shape · setter=set_shape
- **`target_position`** `Vector2` = `Vector2(0, 50)`
  - 其它属性：getter=get_target_position · setter=set_target_position

## 方法

### `add_exception(node: CollisionObject2D) -> void`

Adds a collision exception so the shape does not report collisions with the specified node.

### `add_exception_rid(rid: RID) -> void`

Adds a collision exception so the shape does not report collisions with the specified `RID`.

### `clear_exceptions() -> void`

Removes all collision exceptions for this shape.

### `force_shapecast_update() -> void`

Updates the collision information for the shape immediately, without waiting for the next `_physics_process` call. Use this method, for example, when the shape or its parent has changed state.
				**Note:** Setting `enabled` to `true` is not required for this to work.

### `get_closest_collision_safe_fraction() -> float`
- 限定：qualifiers=const

Returns the fraction from this cast's origin to its `target_position` of how far the shape can move without triggering a collision, as a value between `0.0` and `1.0`.

### `get_closest_collision_unsafe_fraction() -> float`
- 限定：qualifiers=const

Returns the fraction from this cast's origin to its `target_position` of how far the shape must move to trigger a collision, as a value between `0.0` and `1.0`.
				In ideal conditions this would be the same as `get_closest_collision_safe_fraction`, however shape casting is calculated in discrete steps, so the precise point of collision can occur between two calculated positions.

### `get_collider(index: int) -> Object`
- 限定：qualifiers=const

Returns the collided `Object` of one of the multiple collisions at `index`, or `null` if no object is intersecting the shape (i.e. `is_colliding` returns `false`).

### `get_collider_rid(index: int) -> RID`
- 限定：qualifiers=const

Returns the `RID` of the collided object of one of the multiple collisions at `index`.

### `get_collider_shape(index: int) -> int`
- 限定：qualifiers=const

Returns the shape ID of the colliding shape of one of the multiple collisions at `index`, or `0` if no object is intersecting the shape (i.e. `is_colliding` returns `false`).

### `get_collision_count() -> int`
- 限定：qualifiers=const

The number of collisions detected at the point of impact. Use this to iterate over multiple collisions as provided by `get_collider`, `get_collider_shape`, `get_collision_point`, and `get_collision_normal` methods.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_normal(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the normal of one of the multiple collisions at `index` of the intersecting object.

### `get_collision_point(index: int) -> Vector2`
- 限定：qualifiers=const

Returns the collision point of one of the multiple collisions at `index` where the shape intersects the colliding object.
				**Note:** This point is in the **global** coordinate system.

### `is_colliding() -> bool`
- 限定：qualifiers=const

Returns whether any object is intersecting with the shape's vector (considering the vector length).

### `remove_exception(node: CollisionObject2D) -> void`

Removes a collision exception so the shape does report collisions with the specified node.

### `remove_exception_rid(rid: RID) -> void`

Removes a collision exception so the shape does report collisions with the specified `RID`.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

