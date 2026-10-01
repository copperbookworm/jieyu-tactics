# VisualShaderNodeIs

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeIs` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeIs.md`

**摘要**：A boolean comparison operator to be used within the visual shader graph.

## 描述

Returns the boolean result of the comparison between `INF` or `NaN` and a scalar parameter.

## 属性

- **`function`** `int` = `0` · 枚举 `VisualShaderNodeIs.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_IS_INF` |  |
| `1` | `FUNC_IS_NAN` |  |
| `2` | `FUNC_MAX` |  |

