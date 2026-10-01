# VisualShaderNodeTransformCompose

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTransformCompose` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTransformCompose.md`

**摘要**：Composes a `Transform3D` from four `Vector3`s within the visual shader graph.

## 描述

Creates a 4×4 transform matrix using four vectors of type `vec3`. Each vector is one row in the matrix and the last column is a `vec4(0, 0, 0, 1)`.

