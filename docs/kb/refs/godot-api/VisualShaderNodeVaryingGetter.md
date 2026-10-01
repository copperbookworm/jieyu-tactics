# VisualShaderNodeVaryingGetter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeVaryingGetter` → `VisualShaderNodeVarying` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeVaryingGetter.md`

**摘要**：A visual shader node that gets a value of a varying.

## 描述

Outputs a value of a varying defined in the shader. You need to first create a varying that can be used in the given function, e.g. varying getter in Fragment shader requires a varying with mode set to `VisualShader.VARYING_MODE_VERTEX_TO_FRAG_LIGHT`.

