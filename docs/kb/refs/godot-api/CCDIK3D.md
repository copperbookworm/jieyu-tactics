# CCDIK3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CCDIK3D` → `IterateIK3D` → `ChainIK3D` → `IKModifier3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CCDIK3D.md`

**摘要**：Rotation based cyclic coordinate descent inverse kinematics solver.

## 描述

`CCDIK3D` is rotation based IK, enabling fast and effective tracking even with large joint rotations. It's especially suitable for chains with limitations, providing smoother and more stable target tracking compared to `FABRIK3D`.
		The resulting twist around the forward vector will always be kept from the previous pose.
		**Note:** When the target is close to the root, it can cause unnatural movement, including joint flips and oscillations.

