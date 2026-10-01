# VisualShaderNodeFloatParameter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeFloatParameter` → `VisualShaderNodeParameter` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeFloatParameter.md`

**摘要**：A scalar float parameter to be used within the visual shader graph.

## 描述

Translated to `uniform float` in the shader language.

## 属性

- **`default_value`** `float` = `0.0`
  - 其它属性：getter=get_default_value · setter=set_default_value
- **`default_value_enabled`** `bool` = `false`
  - 其它属性：getter=is_default_value_enabled · setter=set_default_value_enabled
- **`hint`** `int` = `0` · 枚举 `VisualShaderNodeFloatParameter.Hint`
  - 其它属性：getter=get_hint · setter=set_hint
- **`max`** `float` = `1.0`
  - 其它属性：getter=get_max · setter=set_max
- **`min`** `float` = `0.0`
  - 其它属性：getter=get_min · setter=set_min
- **`step`** `float` = `0.1`
  - 其它属性：getter=get_step · setter=set_step

## 枚举

### `Hint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HINT_NONE` |  |
| `1` | `HINT_RANGE` |  |
| `2` | `HINT_RANGE_STEP` |  |
| `3` | `HINT_MAX` |  |

