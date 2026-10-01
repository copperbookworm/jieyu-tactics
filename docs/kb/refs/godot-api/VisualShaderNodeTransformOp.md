# VisualShaderNodeTransformOp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTransformOp` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTransformOp.md`

**摘要**：A `Transform3D` operator to be used within the visual shader graph.

## 描述

Applies `operator` to two transform (4×4 matrices) inputs.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeTransformOp.Operator`
  - 其它属性：getter=get_operator · setter=set_operator

## 枚举

### `Operator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_AxB` |  |
| `1` | `OP_BxA` |  |
| `2` | `OP_AxB_COMP` |  |
| `3` | `OP_BxA_COMP` |  |
| `4` | `OP_ADD` |  |
| `5` | `OP_A_MINUS_B` |  |
| `6` | `OP_B_MINUS_A` |  |
| `7` | `OP_A_DIV_B` |  |
| `8` | `OP_B_DIV_A` |  |
| `9` | `OP_MAX` |  |

