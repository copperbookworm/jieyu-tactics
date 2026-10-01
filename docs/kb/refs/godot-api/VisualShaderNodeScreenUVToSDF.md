# VisualShaderNodeScreenUVToSDF

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeScreenUVToSDF` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeScreenUVToSDF.md`

**摘要**：A function to convert screen UV to an SDF (signed-distance field), to be used within the visual shader graph.

## 描述

Translates to `screen_uv_to_sdf(uv)` in the shader language. If the UV port isn't connected, `SCREEN_UV` is used instead.

