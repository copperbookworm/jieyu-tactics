# SkeletonModification2DLookAt

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModification2DLookAt` → `SkeletonModification2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModification2DLookAt.md`

**摘要**：A modification that rotates a `Bone2D` node to look at a target.

## 描述

This `SkeletonModification2D` rotates a bone to look a target. This is extremely helpful for moving character's head to look at the player, rotating a turret to look at a target, or any other case where you want to make a bone rotate towards something quickly and easily.

## 属性

- **`bone2d_node`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_bone2d_node · setter=set_bone2d_node
- **`bone_index`** `int` = `-1`
  - 其它属性：getter=get_bone_index · setter=set_bone_index
- **`target_nodepath`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target_node · setter=set_target_node

## 方法

### `get_additional_rotation() -> float`
- 限定：qualifiers=const

Returns the amount of additional rotation that is applied after the LookAt modification executes.

### `get_constraint_angle_invert() -> bool`
- 限定：qualifiers=const

Returns whether the constraints to this modification are inverted or not.

### `get_constraint_angle_max() -> float`
- 限定：qualifiers=const

Returns the constraint's maximum allowed angle.

### `get_constraint_angle_min() -> float`
- 限定：qualifiers=const

Returns the constraint's minimum allowed angle.

### `get_enable_constraint() -> bool`
- 限定：qualifiers=const

Returns `true` if the LookAt modification is using constraints.

### `set_additional_rotation(rotation: float) -> void`

Sets the amount of additional rotation that is to be applied after executing the modification. This allows for offsetting the results by the inputted rotation amount.

### `set_constraint_angle_invert(invert: bool) -> void`

When `true`, the modification will use an inverted joint constraint.
				An inverted joint constraint only constraints the `Bone2D` to the angles *outside of* the inputted minimum and maximum angles. For this reason, it is referred to as an inverted joint constraint, as it constraints the joint to the outside of the inputted values.

### `set_constraint_angle_max(angle_max: float) -> void`

Sets the constraint's maximum allowed angle.

### `set_constraint_angle_min(angle_min: float) -> void`

Sets the constraint's minimum allowed angle.

### `set_enable_constraint(enable_constraint: bool) -> void`

Sets whether this modification will use constraints or not. When `true`, constraints will be applied when solving the LookAt modification.

