# RDShaderFile

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDShaderFile` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDShaderFile.md`

**摘要**：Compiled shader file in SPIR-V form (used by `RenderingDevice`). Not to be confused with Godot's own `Shader`.

## 描述

Compiled shader file in SPIR-V form.
		See also `RDShaderSource`. `RDShaderFile` is only meant to be used with the `RenderingDevice` API. It should not be confused with Godot's own `Shader` resource, which is what Godot's various nodes use for high-level shader programming.

## 属性

- **`base_error`** `String` = `""`
  - 其它属性：getter=get_base_error · setter=set_base_error

## 方法

### `get_spirv(version: StringName = &"") -> RDShaderSPIRV`
- 限定：qualifiers=const

Returns the SPIR-V intermediate representation for the specified shader `version`.

### `get_version_list() -> StringName[]`
- 限定：qualifiers=const

Returns the list of compiled versions for this shader.

### `set_bytecode(bytecode: RDShaderSPIRV, version: StringName = &"") -> void`

Sets the SPIR-V `bytecode` that will be compiled for the specified `version`.

