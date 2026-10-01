# GPUParticlesCollision3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticlesCollision3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticlesCollision3D.md`

**摘要**：Abstract base class for 3D particle collision shapes affecting `GPUParticles3D` nodes.

## 描述

Particle collision shapes can be used to make particles stop or bounce against them.
		Particle collision shapes work in real-time and can be moved, rotated and scaled during gameplay. Unlike attractors, non-uniform scaling of collision shapes is *not* supported.
		Particle collision shapes can be temporarily disabled by hiding them.
		**Note:** `ParticleProcessMaterial.collision_mode` must be `ParticleProcessMaterial.COLLISION_RIGID` or `ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT` on the `GPUParticles3D`'s process material for collision to work.
		**Note:** Particle collision only affects `GPUParticles3D`, not `CPUParticles3D`.
		**Note:** Particles pushed by a collider that is being moved will not be interpolated, which can result in visible stuttering. This can be alleviated by setting `GPUParticles3D.fixed_fps` to `0` or a value that matches or exceeds the target framerate.

## 属性

- **`cull_mask`** `int` = `4294967295`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask

