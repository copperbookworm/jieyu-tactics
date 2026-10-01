# VisualShaderNodeTransformVecMult

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTransformVecMult` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTransformVecMult.md`

**摘要**：Multiplies a `Transform3D` and a `Vector3` within the visual shader graph.

## 描述

A multiplication operation on a transform (4×4 matrix) and a vector, with support for different multiplication operators.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeTransformVecMult.Operator`
  - 其它属性：getter=get_operator · setter=set_operator

## 枚举

### `Operator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_AxB` |  |
| `1` | `OP_BxA` |  |
| `2` | `OP_3x3_AxB` |  |
| `3` | `OP_3x3_BxA` |  |
| `4` | `OP_MAX` |  |

