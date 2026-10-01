# FABRIK3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FABRIK3D` → `IterateIK3D` → `ChainIK3D` → `IKModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FABRIK3D.md`

**摘要**：Position based forward and backward reaching inverse kinematics solver.

## 描述

`FABRIK3D` is position based IK, allowing precise and accurate tracking of targets. It's ideal for simple chains without limitations.
		The resulting twist around the forward vector will always be kept from the previous pose.
		**Note:** When the target is close to the root, it tends to produce zig-zag patterns, resulting in unnatural visual movement.

## 教程链接

- [Inverse Kinematics Returns to Godot 4.6 - IKModifier3D](None)

