# SkeletonModification2DTwoBoneIK

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModification2DTwoBoneIK` → `SkeletonModification2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModification2DTwoBoneIK.md`

**摘要**：A modification that rotates two bones using the law of cosines to reach the target.

## 描述

This `SkeletonModification2D` uses an algorithm typically called TwoBoneIK. This algorithm works by leveraging the law of cosines and the lengths of the bones to figure out what rotation the bones currently have, and what rotation they need to make a complete triangle, where the first bone, the second bone, and the target form the three vertices of the triangle. Because the algorithm works by making a triangle, it can only operate on two bones.
		TwoBoneIK is great for arms, legs, and really any joints that can be represented by just two bones that bend to reach a target. This solver is more lightweight than `SkeletonModification2DFABRIK`, but gives similar, natural looking results.

## 属性

- **`flip_bend_direction`** `bool` = `false`
  - 其它属性：getter=get_flip_bend_direction · setter=set_flip_bend_direction
- **`target_maximum_distance`** `float` = `0.0`
  - 其它属性：getter=get_target_maximum_distance · setter=set_target_maximum_distance
- **`target_minimum_distance`** `float` = `0.0`
  - 其它属性：getter=get_target_minimum_distance · setter=set_target_minimum_distance
- **`target_nodepath`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target_node · setter=set_target_node

## 方法

### `get_joint_one_bone2d_node() -> NodePath`
- 限定：qualifiers=const

Returns the `Bone2D` node that is being used as the first bone in the TwoBoneIK modification.

### `get_joint_one_bone_idx() -> int`
- 限定：qualifiers=const

Returns the index of the `Bone2D` node that is being used as the first bone in the TwoBoneIK modification.

### `get_joint_two_bone2d_node() -> NodePath`
- 限定：qualifiers=const

Returns the `Bone2D` node that is being used as the second bone in the TwoBoneIK modification.

### `get_joint_two_bone_idx() -> int`
- 限定：qualifiers=const

Returns the index of the `Bone2D` node that is being used as the second bone in the TwoBoneIK modification.

### `set_joint_one_bone2d_node(bone2d_node: NodePath) -> void`

Sets the `Bone2D` node that is being used as the first bone in the TwoBoneIK modification.

### `set_joint_one_bone_idx(bone_idx: int) -> void`

Sets the index of the `Bone2D` node that is being used as the first bone in the TwoBoneIK modification.

### `set_joint_two_bone2d_node(bone2d_node: NodePath) -> void`

Sets the `Bone2D` node that is being used as the second bone in the TwoBoneIK modification.

### `set_joint_two_bone_idx(bone_idx: int) -> void`

Sets the index of the `Bone2D` node that is being used as the second bone in the TwoBoneIK modification.

