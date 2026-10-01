# VisualShaderNodeCompare

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeCompare` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeCompare.md`

**摘要**：A comparison function for common types within the visual shader graph.

## 描述

Compares `a` and `b` of `type` by `function`. Returns a boolean scalar. Translates to `if` instruction in shader code.

## 属性

- **`condition`** `int` = `0` · 枚举 `VisualShaderNodeCompare.Condition`
  - 其它属性：getter=get_condition · setter=set_condition
- **`function`** `int` = `0` · 枚举 `VisualShaderNodeCompare.Function`
  - 其它属性：getter=get_function · setter=set_function
- **`type`** `int` = `0` · 枚举 `VisualShaderNodeCompare.ComparisonType`
  - 其它属性：getter=get_comparison_type · setter=set_comparison_type

## 枚举

### `ComparisonType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CTYPE_SCALAR` |  |
| `1` | `CTYPE_SCALAR_INT` |  |
| `2` | `CTYPE_SCALAR_UINT` |  |
| `3` | `CTYPE_VECTOR_2D` |  |
| `4` | `CTYPE_VECTOR_3D` |  |
| `5` | `CTYPE_VECTOR_4D` |  |
| `6` | `CTYPE_BOOLEAN` |  |
| `7` | `CTYPE_TRANSFORM` |  |
| `8` | `CTYPE_MAX` |  |

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_EQUAL` |  |
| `1` | `FUNC_NOT_EQUAL` |  |
| `2` | `FUNC_GREATER_THAN` |  |
| `3` | `FUNC_GREATER_THAN_EQUAL` |  |
| `4` | `FUNC_LESS_THAN` |  |
| `5` | `FUNC_LESS_THAN_EQUAL` |  |
| `6` | `FUNC_MAX` |  |

### `Condition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COND_ALL` |  |
| `1` | `COND_ANY` |  |
| `2` | `COND_MAX` |  |

