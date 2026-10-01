# RDPipelineShader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDPipelineShader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/RDPipelineShader.md`

**摘要**：Pipeline shader (used by `RenderingDevice`).

## 描述

Wraps a shader resource and allows specialization constants to be applied at pipeline creation time.
		Used by `RenderingDevice.raytracing_pipeline_create` for ray generation, miss, and hit shaders. The pipeline selects the required shader stage automatically.

## 属性

- **`shader`** `RID` = `RID()`
  - 其它属性：getter=get_shader · setter=set_shader
- **`specialization_constants`** `RDPipelineSpecializationConstant[]` = `[]`
  - 其它属性：getter=get_specialization_constants · setter=set_specialization_constants

