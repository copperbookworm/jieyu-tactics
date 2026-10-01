# PhysicalBoneSimulator3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicalBoneSimulator3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicalBoneSimulator3D.md`

**摘要**：Node that can be the parent of `PhysicalBone3D` and can apply the simulation results to `Skeleton3D`.

## 描述

Node that can be the parent of `PhysicalBone3D` and can apply the simulation results to `Skeleton3D`.

## 方法

### `is_simulating_physics() -> bool`
- 限定：qualifiers=const

Returns a boolean that indicates whether the `PhysicalBoneSimulator3D` is running and simulating.

### `physical_bones_add_collision_exception(exception: RID) -> void`

Adds a collision exception to the physical bone.
				Works just like the `RigidBody3D` node.

### `physical_bones_remove_collision_exception(exception: RID) -> void`

Removes a collision exception to the physical bone.
				Works just like the `RigidBody3D` node.

### `physical_bones_start_simulation(bones: StringName[] = []) -> void`

Tells the `PhysicalBone3D` nodes in the Skeleton to start simulating and reacting to the physics world.
				Optionally, a list of bone names can be passed-in, allowing only the passed-in bones to be simulated.

### `physical_bones_stop_simulation() -> void`

Tells the `PhysicalBone3D` nodes in the Skeleton to stop simulating.

