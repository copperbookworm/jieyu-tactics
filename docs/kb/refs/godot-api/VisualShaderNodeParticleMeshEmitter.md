# VisualShaderNodeParticleMeshEmitter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeParticleMeshEmitter` → `VisualShaderNodeParticleEmitter` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeParticleMeshEmitter.md`

**摘要**：A visual shader node that makes particles emitted in a shape defined by a `Mesh`.

## 描述

`VisualShaderNodeParticleEmitter` that makes the particles emitted in a shape of the assigned `mesh`. It will emit from the mesh's surfaces, either all or only the specified one.

## 属性

- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`surface_index`** `int` = `0`
  - 其它属性：getter=get_surface_index · setter=set_surface_index
- **`use_all_surfaces`** `bool` = `true`
  - 其它属性：getter=is_use_all_surfaces · setter=set_use_all_surfaces

