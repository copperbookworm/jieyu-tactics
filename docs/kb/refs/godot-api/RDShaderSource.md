# RDShaderSource

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDShaderSource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDShaderSource.md`

**摘要**：Shader source code (used by `RenderingDevice`).

## 描述

Shader source code in text form.
		See also `RDShaderFile`. `RDShaderSource` is only meant to be used with the `RenderingDevice` API. It should not be confused with Godot's own `Shader` resource, which is what Godot's various nodes use for high-level shader programming.

## 属性

- **`language`** `int` = `0` · 枚举 `RenderingDevice.ShaderLanguage`
  - 其它属性：getter=get_language · setter=set_language
- **`source_any_hit`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_closest_hit`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_compute`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_fragment`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_intersection`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_miss`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_raygen`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_tesselation_control`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_tesselation_evaluation`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source
- **`source_vertex`** `String` = `""`
  - 其它属性：getter=get_stage_source · setter=set_stage_source

## 方法

### `get_stage_source(stage: int) -> String`
- 限定：qualifiers=const

Returns source code for the specified shader `stage`. Equivalent to getting one of `source_compute`, `source_fragment`, `source_tesselation_control`, `source_tesselation_evaluation` or `source_vertex`.

### `set_stage_source(stage: int, source: String) -> void`

Sets `source` code for the specified shader `stage`. Equivalent to setting one of `source_compute`, `source_fragment`, `source_tesselation_control`, `source_tesselation_evaluation` or `source_vertex`.
				**Note:** If you set the compute shader source code using this method directly, remember to remove the Godot-specific hint `#`compute``.

