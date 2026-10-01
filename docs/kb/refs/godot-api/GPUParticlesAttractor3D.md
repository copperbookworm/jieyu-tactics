# GPUParticlesAttractor3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticlesAttractor3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticlesAttractor3D.md`

**摘要**：Abstract base class for 3D particle attractors.

## 描述

Particle attractors can be used to attract particles towards the attractor's origin, or to push them away from the attractor's origin.
		Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.
		Attractors can be temporarily disabled by hiding them, or by setting their `strength` to `0.0`.
		**Note:** Particle attractors only affect `GPUParticles3D`, not `CPUParticles3D`.

## 属性

- **`attenuation`** `float` = `1.0`
  - 其它属性：getter=get_attenuation · setter=set_attenuation
- **`cull_mask`** `int` = `4294967295`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask
- **`directionality`** `float` = `0.0`
  - 其它属性：getter=get_directionality · setter=set_directionality
- **`strength`** `float` = `1.0`
  - 其它属性：getter=get_strength · setter=set_strength

