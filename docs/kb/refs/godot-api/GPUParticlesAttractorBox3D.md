# GPUParticlesAttractorBox3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticlesAttractorBox3D` → `GPUParticlesAttractor3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticlesAttractorBox3D.md`

**摘要**：A box-shaped attractor that influences particles from `GPUParticles3D` nodes.

## 描述

A box-shaped attractor that influences particles from `GPUParticles3D` nodes. Can be used to attract particles towards its origin, or to push them away from its origin.
		Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.
		**Note:** Particle attractors only affect `GPUParticles3D`, not `CPUParticles3D`.

## 属性

- **`size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_size · setter=set_size

