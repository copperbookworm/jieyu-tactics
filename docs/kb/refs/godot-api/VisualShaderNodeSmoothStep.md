# VisualShaderNodeSmoothStep

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeSmoothStep` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeSmoothStep.md`

**摘要**：Calculates a SmoothStep function within the visual shader graph.

## 描述

Translates to `smoothstep(edge0, edge1, x)` in the shader language.
		Returns `0.0` if `x` is smaller than `edge0` and `1.0` if `x` is larger than `edge1`. Otherwise, the return value is interpolated between `0.0` and `1.0` using Hermite polynomials.

## 属性

- **`op_type`** `int` = `0` · 枚举 `VisualShaderNodeSmoothStep.OpType`
  - 其它属性：getter=get_op_type · setter=set_op_type

## 枚举

### `OpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_TYPE_SCALAR` |  |
| `1` | `OP_TYPE_VECTOR_2D` |  |
| `2` | `OP_TYPE_VECTOR_2D_SCALAR` |  |
| `3` | `OP_TYPE_VECTOR_3D` |  |
| `4` | `OP_TYPE_VECTOR_3D_SCALAR` |  |
| `5` | `OP_TYPE_VECTOR_4D` |  |
| `6` | `OP_TYPE_VECTOR_4D_SCALAR` |  |
| `7` | `OP_TYPE_MAX` |  |

