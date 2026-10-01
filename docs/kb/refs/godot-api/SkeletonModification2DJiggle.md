# SkeletonModification2DJiggle

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SkeletonModification2DJiggle` → `SkeletonModification2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/SkeletonModification2DJiggle.md`

**摘要**：A modification that jiggles `Bone2D` nodes as they move towards a target.

## 描述

This modification moves a series of bones, typically called a bone chain, towards a target. What makes this modification special is that it calculates the velocity and acceleration for each bone in the bone chain, and runs a very light physics-like calculation using the inputted values. This allows the bones to overshoot the target and "jiggle" around. It can be configured to act more like a spring, or sway around like cloth might.
		This modification is useful for adding additional motion to things like hair, the edges of clothing, and more. It has several settings to that allow control over how the joint moves when the target moves.
		**Note:** The Jiggle modifier has `jiggle_joints`, which are the data objects that hold the data for each joint in the Jiggle chain. This is different from than `Bone2D` nodes! Jiggle joints hold the data needed for each `Bone2D` in the bone chain used by the Jiggle modification.

## 属性

- **`damping`** `float` = `0.75`
  - 其它属性：getter=get_damping · setter=set_damping
- **`gravity`** `Vector2` = `Vector2(0, 6)`
  - 其它属性：getter=get_gravity · setter=set_gravity
- **`jiggle_data_chain_length`** `int` = `0`
  - 其它属性：getter=get_jiggle_data_chain_length · setter=set_jiggle_data_chain_length
- **`mass`** `float` = `0.75`
  - 其它属性：getter=get_mass · setter=set_mass
- **`stiffness`** `float` = `3.0`
  - 其它属性：getter=get_stiffness · setter=set_stiffness
- **`target_nodepath`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target_node · setter=set_target_node
- **`use_gravity`** `bool` = `false`
  - 其它属性：getter=get_use_gravity · setter=set_use_gravity

## 方法

### `get_collision_mask() -> int`
- 限定：qualifiers=const

Returns the collision mask used by the Jiggle modifier when collisions are enabled.

### `get_jiggle_joint_bone2d_node(joint_idx: int) -> NodePath`
- 限定：qualifiers=const

Returns the `Bone2D` node assigned to the Jiggle joint at `joint_idx`.

### `get_jiggle_joint_bone_index(joint_idx: int) -> int`
- 限定：qualifiers=const

Returns the index of the `Bone2D` node assigned to the Jiggle joint at `joint_idx`.

### `get_jiggle_joint_damping(joint_idx: int) -> float`
- 限定：qualifiers=const

Returns the amount of damping of the Jiggle joint at `joint_idx`.

### `get_jiggle_joint_gravity(joint_idx: int) -> Vector2`
- 限定：qualifiers=const

Returns a `Vector2` representing the amount of gravity the Jiggle joint at `joint_idx` is influenced by.

### `get_jiggle_joint_mass(joint_idx: int) -> float`
- 限定：qualifiers=const

Returns the amount of mass of the jiggle joint at `joint_idx`.

### `get_jiggle_joint_override(joint_idx: int) -> bool`
- 限定：qualifiers=const

Returns a boolean that indicates whether the joint at `joint_idx` is overriding the default Jiggle joint data defined in the modification.

### `get_jiggle_joint_stiffness(joint_idx: int) -> float`
- 限定：qualifiers=const

Returns the stiffness of the Jiggle joint at `joint_idx`.

### `get_jiggle_joint_use_gravity(joint_idx: int) -> bool`
- 限定：qualifiers=const

Returns a boolean that indicates whether the joint at `joint_idx` is using gravity or not.

### `get_use_colliders() -> bool`
- 限定：qualifiers=const

Returns whether the jiggle modifier is taking physics colliders into account when solving.

### `reset() -> void`

Resets the internal jiggle simulation state to the current bone positions, clearing velocity, acceleration, and accumulated forces.

### `set_collision_mask(collision_mask: int) -> void`

Sets the collision mask that the Jiggle modifier will use when reacting to colliders, if the Jiggle modifier is set to take colliders into account.

### `set_jiggle_joint_bone2d_node(joint_idx: int, bone2d_node: NodePath) -> void`

Sets the `Bone2D` node assigned to the Jiggle joint at `joint_idx`.

### `set_jiggle_joint_bone_index(joint_idx: int, bone_idx: int) -> void`

Sets the bone index, `bone_idx`, of the Jiggle joint at `joint_idx`. When possible, this will also update the `bone2d_node` of the Jiggle joint based on data provided by the linked skeleton.

### `set_jiggle_joint_damping(joint_idx: int, damping: float) -> void`

Sets the amount of damping of the Jiggle joint at `joint_idx`.

### `set_jiggle_joint_gravity(joint_idx: int, gravity: Vector2) -> void`

Sets the gravity vector of the Jiggle joint at `joint_idx`.

### `set_jiggle_joint_mass(joint_idx: int, mass: float) -> void`

Sets the of mass of the Jiggle joint at `joint_idx`.

### `set_jiggle_joint_override(joint_idx: int, override: bool) -> void`

Sets whether the Jiggle joint at `joint_idx` should override the default Jiggle joint settings. Setting this to `true` will make the joint use its own settings rather than the default ones attached to the modification.

### `set_jiggle_joint_stiffness(joint_idx: int, stiffness: float) -> void`

Sets the of stiffness of the Jiggle joint at `joint_idx`.

### `set_jiggle_joint_use_gravity(joint_idx: int, use_gravity: bool) -> void`

Sets whether the Jiggle joint at `joint_idx` should use gravity.

### `set_use_colliders(use_colliders: bool) -> void`

If `true`, the Jiggle modifier will take colliders into account, keeping them from entering into these collision objects.

