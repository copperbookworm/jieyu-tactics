# VisualShaderNodeInput

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeInput` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeInput.md`

**摘要**：Represents the input shader parameter within the visual shader graph.

## 描述

Gives access to input variables (built-ins) available for the shader. See the shading reference for the list of available built-ins for each shader type (check `Tutorials` section for link).

## 属性

- **`input_name`** `String` = `"[None]"`
  - 其它属性：getter=get_input_name · setter=set_input_name

## 方法

### `get_input_real_name() -> String`
- 限定：qualifiers=const

Returns a translated name of the current constant in the Godot Shader Language. E.g. `"ALBEDO"` if the `input_name` equal to `"albedo"`.

## 信号

### `input_type_changed()`

Emitted when input is changed via `input_name`.

## 教程链接

- [Shading reference index](None)

