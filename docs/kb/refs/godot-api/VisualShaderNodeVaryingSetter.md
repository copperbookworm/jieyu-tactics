# VisualShaderNodeVaryingSetter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeVaryingSetter` → `VisualShaderNodeVarying` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeVaryingSetter.md`

**摘要**：A visual shader node that sets a value of a varying.

## 描述

Inputs a value to a varying defined in the shader. You need to first create a varying that can be used in the given function, e.g. varying setter in Fragment shader requires a varying with mode set to `VisualShader.VARYING_MODE_FRAG_TO_LIGHT`.

