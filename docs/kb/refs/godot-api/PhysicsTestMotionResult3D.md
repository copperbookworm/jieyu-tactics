# PhysicsTestMotionResult3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsTestMotionResult3D` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsTestMotionResult3D.md`

**摘要**：Describes the motion and collision result from `PhysicsServer3D.body_test_motion`.

## 描述

Describes the motion and collision result from `PhysicsServer3D.body_test_motion`.

## 方法

### `get_collider(collision_index: int = 0) -> Object`
- 限定：qualifiers=const

Returns the colliding body's attached `Object` given a collision index (the deepest collision by default), if a collision occurred.

### `get_collider_id(collision_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the unique instance ID of the colliding body's attached `Object` given a collision index (the deepest collision by default), if a collision occurred. See `Object.get_instance_id`.

### `get_collider_rid(collision_index: int = 0) -> RID`
- 限定：qualifiers=const

Returns the colliding body's `RID` used by the `PhysicsServer3D` given a collision index (the deepest collision by default), if a collision occurred.

### `get_collider_shape(collision_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the colliding body's shape index given a collision index (the deepest collision by default), if a collision occurred. See `CollisionObject3D`.

### `get_collider_velocity(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the colliding body's velocity given a collision index (the deepest collision by default), if a collision occurred.

### `get_collision_count() -> int`
- 限定：qualifiers=const

Returns the number of detected collisions.

### `get_collision_depth(collision_index: int = 0) -> float`
- 限定：qualifiers=const

Returns the length of overlap along the collision normal given a collision index (the deepest collision by default), if a collision occurred.

### `get_collision_local_shape(collision_index: int = 0) -> int`
- 限定：qualifiers=const

Returns the moving object's colliding shape given a collision index (the deepest collision by default), if a collision occurred.

### `get_collision_normal(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the colliding body's shape's normal at the point of collision given a collision index (the deepest collision by default), if a collision occurred.

### `get_collision_point(collision_index: int = 0) -> Vector3`
- 限定：qualifiers=const

Returns the point of collision in global coordinates given a collision index (the deepest collision by default), if a collision occurred.

### `get_collision_safe_fraction() -> float`
- 限定：qualifiers=const

Returns the maximum fraction of the motion that can occur without a collision, between `0` and `1`.

### `get_collision_unsafe_fraction() -> float`
- 限定：qualifiers=const

Returns the minimum fraction of the motion needed to collide, if a collision occurred, between `0` and `1`.

### `get_remainder() -> Vector3`
- 限定：qualifiers=const

Returns the moving object's remaining movement vector.

### `get_travel() -> Vector3`
- 限定：qualifiers=const

Returns the moving object's travel before collision.

