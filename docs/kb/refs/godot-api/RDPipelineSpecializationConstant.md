# RDPipelineSpecializationConstant

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDPipelineSpecializationConstant` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDPipelineSpecializationConstant.md`

**摘要**：Pipeline specialization constant (used by `RenderingDevice`).

## 描述

A *specialization constant* is a way to create additional variants of shaders without actually increasing the number of shader versions that are compiled. This allows improving performance by reducing the number of shader versions and reducing `if` branching, while still allowing shaders to be flexible for different use cases.
		This object is used by `RenderingDevice`.

## 属性

- **`constant_id`** `int` = `0`
  - 其它属性：getter=get_constant_id · setter=set_constant_id
- **`value`** `Variant`
  - 其它属性：getter=get_value · setter=set_value

