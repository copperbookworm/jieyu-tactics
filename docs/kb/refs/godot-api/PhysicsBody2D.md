# PhysicsBody2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsBody2D` → `CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsBody2D.md`

**摘要**：Abstract base class for 2D game objects affected by physics.

## 描述

`PhysicsBody2D` is an abstract base class for 2D game objects affected by physics. All 2D physics bodies inherit from it.

## 属性

- **`input_pickable`** `bool` = `false`
  - 其它属性：getter=is_pickable · overrides=CollisionObject2D · setter=set_pickable

## 方法

### `add_collision_exception_with(body: Node) -> void`

Adds a body to the list of bodies that this body can't collide with.

### `get_collision_exceptions() -> PhysicsBody2D[]`

Returns an array of nodes that were added as collision exceptions for this body.

### `get_gravity() -> Vector2`
- 限定：qualifiers=const

Returns the gravity vector computed from all sources that can affect the body, including all gravity overrides from `Area2D` nodes and the global world gravity.

### `move_and_collide(motion: Vector2, test_only: bool = false, safe_margin: float = 0.08, recovery_as_collision: bool = false) -> KinematicCollision2D`

Moves the body along the vector `motion`. In order to be frame rate independent in `Node._physics_process` or `Node._process`, `motion` should be computed using `delta`.
				Returns a `KinematicCollision2D`, which contains information about the collision when stopped, or when touching another body along the motion.
				If `test_only` is `true`, the body does not move but the would-be collision information is given.
				`safe_margin` is the extra margin used for collision recovery (see `CharacterBody2D.safe_margin` for more details).
				If `recovery_as_collision` is `true`, any depenetration from the recovery phase is also reported as a collision; this is used e.g. by `CharacterBody2D` for improving floor detection during floor snapping.

### `remove_collision_exception_with(body: Node) -> void`

Removes a body from the list of bodies that this body can't collide with.

### `test_move(from: Transform2D, motion: Vector2, collision: KinematicCollision2D = null, safe_margin: float = 0.08, recovery_as_collision: bool = false) -> bool`
- 限定：keywords=check, collision, sweep

Checks for collisions without moving the body. In order to be frame rate independent in `Node._physics_process` or `Node._process`, `motion` should be computed using `delta`.
				Virtually sets the node's position, scale and rotation to that of the given `Transform2D`, then tries to move the body along the vector `motion`. Returns `true` if a collision would stop the body from moving along the whole path.
				`collision` is an optional object of type `KinematicCollision2D`, which contains additional information about the collision when stopped, or when touching another body along the motion.
				`safe_margin` is the extra margin used for collision recovery (see `CharacterBody2D.safe_margin` for more details).
				If `recovery_as_collision` is `true`, any depenetration from the recovery phase is also reported as a collision; this is useful for checking whether the body would *touch* any other bodies.

## 教程链接

- [Physics introduction](None)
- [Troubleshooting physics issues](None)

