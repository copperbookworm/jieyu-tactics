# SpringArm3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpringArm3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SpringArm3D.md`

**摘要**：A 3D raycast that dynamically moves its children near the collision point.

## 描述

`SpringArm3D` casts a ray or a shape along its Z axis and moves all its direct children to the collision point, with an optional margin. This is useful for 3rd person cameras that move closer to the player when inside a tight space (you may need to exclude the player's collider from the `SpringArm3D`'s collision check).

## 属性

- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`margin`** `float` = `0.01`
  - 其它属性：getter=get_margin · setter=set_margin
- **`shape`** `Shape3D`
  - 其它属性：getter=get_shape · setter=set_shape
- **`spring_length`** `float` = `1.0`
  - 其它属性：getter=get_length · setter=set_length

## 方法

### `add_excluded_object(RID: RID) -> void`

Adds the `PhysicsBody3D` object with the given `RID` to the list of `PhysicsBody3D` objects excluded from the collision check.

### `clear_excluded_objects() -> void`

Clears the list of `PhysicsBody3D` objects excluded from the collision check.

### `get_hit_length() -> float`

Returns the spring arm's current length.

### `remove_excluded_object(RID: RID) -> bool`

Removes the given `RID` from the list of `PhysicsBody3D` objects excluded from the collision check.

## 教程链接

- [Third-person camera with spring arm](None)

