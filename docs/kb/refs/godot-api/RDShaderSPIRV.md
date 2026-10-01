# RDShaderSPIRV

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDShaderSPIRV` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDShaderSPIRV.md`

**摘要**：SPIR-V intermediate representation as part of an `RDShaderFile` (used by `RenderingDevice`).

## 描述

`RDShaderSPIRV` represents an `RDShaderFile`'s SPIR-V (https://www.khronos.org/spir/) code for various shader stages, as well as possible compilation error messages. SPIR-V is a low-level intermediate shader representation. This intermediate representation is not used directly by GPUs for rendering, but it can be compiled into binary shaders that GPUs can understand. Unlike compiled shaders, SPIR-V is portable across GPU models and driver versions.
		This object is used by `RenderingDevice`.

## 属性

- **`bytecode_any_hit`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_closest_hit`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_compute`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_fragment`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_intersection`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_miss`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_raygen`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_tesselation_control`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_tesselation_evaluation`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`bytecode_vertex`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_stage_bytecode · setter=set_stage_bytecode
- **`compile_error_any_hit`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_closest_hit`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_compute`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_fragment`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_intersection`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_miss`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_raygen`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_tesselation_control`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_tesselation_evaluation`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error
- **`compile_error_vertex`** `String` = `""`
  - 其它属性：getter=get_stage_compile_error · setter=set_stage_compile_error

## 方法

### `get_stage_bytecode(stage: int) -> PackedByteArray`
- 限定：qualifiers=const

Equivalent to getting one of `bytecode_compute`, `bytecode_fragment`, `bytecode_tesselation_control`, `bytecode_tesselation_evaluation`, `bytecode_vertex`.

### `get_stage_compile_error(stage: int) -> String`
- 限定：qualifiers=const

Returns the compilation error message for the given shader `stage`. Equivalent to getting one of `compile_error_compute`, `compile_error_fragment`, `compile_error_tesselation_control`, `compile_error_tesselation_evaluation`, `compile_error_vertex`.

### `set_stage_bytecode(stage: int, bytecode: PackedByteArray) -> void`

Sets the SPIR-V `bytecode` for the given shader `stage`. Equivalent to setting one of `bytecode_compute`, `bytecode_fragment`, `bytecode_tesselation_control`, `bytecode_tesselation_evaluation`, `bytecode_vertex`.

### `set_stage_compile_error(stage: int, compile_error: String) -> void`

Sets the compilation error message for the given shader `stage` to `compile_error`. Equivalent to setting one of `compile_error_compute`, `compile_error_fragment`, `compile_error_tesselation_control`, `compile_error_tesselation_evaluation`, `compile_error_vertex`.

