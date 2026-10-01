# VisualShaderNodeParameter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeParameter` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeParameter.md`

**摘要**：A base type for the parameters within the visual shader graph.

## 描述

A parameter represents a variable in the shader which is set externally, i.e. from the `ShaderMaterial`. Parameters are exposed as properties in the `ShaderMaterial` and can be assigned from the Inspector or from a script.

## 属性

- **`instance_index`** `int` = `0`
  - 其它属性：getter=get_instance_index · setter=set_instance_index
- **`parameter_name`** `String` = `""`
  - 其它属性：getter=get_parameter_name · setter=set_parameter_name
- **`qualifier`** `int` = `0` · 枚举 `VisualShaderNodeParameter.Qualifier`
  - 其它属性：getter=get_qualifier · setter=set_qualifier

## 枚举

### `Qualifier`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `QUAL_NONE` |  |
| `1` | `QUAL_GLOBAL` |  |
| `2` | `QUAL_INSTANCE` |  |
| `3` | `QUAL_INSTANCE_INDEX` |  |
| `4` | `QUAL_MAX` |  |

