# VisualShaderNodeIntParameter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeIntParameter` → `VisualShaderNodeParameter` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeIntParameter.md`

**摘要**：A visual shader node for shader parameter (uniform) of type `int`.

## 描述

A `VisualShaderNodeParameter` of type `int`. Offers additional customization for range of accepted values.

## 属性

- **`default_value`** `int` = `0`
  - 其它属性：getter=get_default_value · setter=set_default_value
- **`default_value_enabled`** `bool` = `false`
  - 其它属性：getter=is_default_value_enabled · setter=set_default_value_enabled
- **`enum_names`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_enum_names · setter=set_enum_names
- **`hint`** `int` = `0` · 枚举 `VisualShaderNodeIntParameter.Hint`
  - 其它属性：getter=get_hint · setter=set_hint
- **`max`** `int` = `100`
  - 其它属性：getter=get_max · setter=set_max
- **`min`** `int` = `0`
  - 其它属性：getter=get_min · setter=set_min
- **`step`** `int` = `1`
  - 其它属性：getter=get_step · setter=set_step

## 枚举

### `Hint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HINT_NONE` |  |
| `1` | `HINT_RANGE` |  |
| `2` | `HINT_RANGE_STEP` |  |
| `3` | `HINT_ENUM` |  |
| `4` | `HINT_MAX` |  |

