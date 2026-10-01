# RDUniform

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDUniform` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RDUniform.md`

**摘要**：Shader uniform (used by `RenderingDevice`).

## 描述

This object is used by `RenderingDevice`.

## 属性

- **`binding`** `int` = `0`
  - 其它属性：getter=get_binding · setter=set_binding
- **`uniform_type`** `int` = `3` · 枚举 `RenderingDevice.UniformType`
  - 其它属性：getter=get_uniform_type · setter=set_uniform_type

## 方法

### `add_id(id: RID) -> void`

Binds the given id to the uniform. The data associated with the id is then used when the uniform is passed to a shader.

### `clear_ids() -> void`

Unbinds all ids currently bound to the uniform.

### `get_ids() -> RID[]`
- 限定：qualifiers=const

Returns an array of all ids currently bound to the uniform.

