# VisualShaderNodeDerivativeFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeDerivativeFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeDerivativeFunc.md`

**摘要**：Calculates a derivative within the visual shader graph.

## 描述

This node is only available in `Fragment` and `Light` visual shaders.

## 属性

- **`function`** `int` = `0` · 枚举 `VisualShaderNodeDerivativeFunc.Function`
  - 其它属性：getter=get_function · setter=set_function
- **`op_type`** `int` = `0` · 枚举 `VisualShaderNodeDerivativeFunc.OpType`
  - 其它属性：getter=get_op_type · setter=set_op_type
- **`precision`** `int` = `0` · 枚举 `VisualShaderNodeDerivativeFunc.Precision`
  - 其它属性：getter=get_precision · setter=set_precision

## 枚举

### `OpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_TYPE_SCALAR` |  |
| `1` | `OP_TYPE_VECTOR_2D` |  |
| `2` | `OP_TYPE_VECTOR_3D` |  |
| `3` | `OP_TYPE_VECTOR_4D` |  |
| `4` | `OP_TYPE_MAX` |  |

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_SUM` |  |
| `1` | `FUNC_X` |  |
| `2` | `FUNC_Y` |  |
| `3` | `FUNC_MAX` |  |

### `Precision`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PRECISION_NONE` |  |
| `1` | `PRECISION_COARSE` |  |
| `2` | `PRECISION_FINE` |  |
| `3` | `PRECISION_MAX` |  |

