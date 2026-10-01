# VisualShaderNodeFloatOp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeFloatOp` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeFloatOp.md`

**摘要**：A floating-point scalar operator to be used within the visual shader graph.

## 描述

Applies `operator` to two floating-point inputs: `a` and `b`.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeFloatOp.Operator`
  - 其它属性：getter=get_operator · setter=set_operator

## 枚举

### `Operator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_ADD` |  |
| `1` | `OP_SUB` |  |
| `2` | `OP_MUL` |  |
| `3` | `OP_DIV` |  |
| `4` | `OP_MOD` |  |
| `5` | `OP_POW` |  |
| `6` | `OP_MAX` |  |
| `7` | `OP_MIN` |  |
| `8` | `OP_ATAN2` |  |
| `9` | `OP_STEP` |  |
| `10` | `OP_ENUM_SIZE` |  |

