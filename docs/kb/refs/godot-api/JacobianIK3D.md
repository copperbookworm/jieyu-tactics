# JacobianIK3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`JacobianIK3D` → `IterateIK3D` → `ChainIK3D` → `IKModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/JacobianIK3D.md`

**摘要**：Jacobian transpose based inverse kinematics solver.

## 描述

`JacobianIK3D` calculates rotations for all joints simultaneously, producing natural and smooth movement. It is particularly suited for biological animations.
		The resulting twist around the forward vector will always be kept from the previous pose.
		**Note:** It converges more slowly than other IK solvers, leading to gentler and less immediate tracking of targets.

