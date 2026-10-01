# PhysicalBone2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicalBone2D` → `RigidBody2D` → `PhysicsBody2D` → `CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=ragdoll
> 自动生成，勿手改。文件：`refs/godot-api/PhysicalBone2D.md`

**摘要**：A `RigidBody2D`-derived node used to make `Bone2D`s in a `Skeleton2D` react to physics.

## 描述

The `PhysicalBone2D` node is a `RigidBody2D`-based node that can be used to make `Bone2D`s in a `Skeleton2D` react to physics.
		**Note:** To make the `Bone2D`s visually follow the `PhysicalBone2D` node, use a `SkeletonModification2DPhysicalBones` modification on the `Skeleton2D` parent.
		**Note:** The `PhysicalBone2D` node does not automatically create a `Joint2D` node to keep `PhysicalBone2D` nodes together. They must be created manually. For most cases, you want to use a `PinJoint2D` node. The `PhysicalBone2D` node will automatically configure the `Joint2D` node once it's been added as a child node.

## 属性

- **`auto_configure_joint`** `bool` = `true`
  - 其它属性：getter=get_auto_configure_joint · setter=set_auto_configure_joint
- **`bone2d_index`** `int` = `-1`
  - 其它属性：getter=get_bone2d_index · setter=set_bone2d_index
- **`bone2d_nodepath`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_bone2d_nodepath · setter=set_bone2d_nodepath
- **`follow_bone_when_simulating`** `bool` = `false`
  - 其它属性：getter=get_follow_bone_when_simulating · setter=set_follow_bone_when_simulating
- **`simulate_physics`** `bool` = `false`
  - 其它属性：getter=get_simulate_physics · setter=set_simulate_physics

## 方法

### `get_joint() -> Joint2D`
- 限定：qualifiers=const

Returns the first `Joint2D` child node, if one exists. This is mainly a helper function to make it easier to get the `Joint2D` that the `PhysicalBone2D` is autoconfiguring.

### `is_simulating_physics() -> bool`
- 限定：qualifiers=const

Returns a boolean that indicates whether the `PhysicalBone2D` is running and simulating using the Godot 2D physics engine. When `true`, the PhysicalBone2D node is using physics.

