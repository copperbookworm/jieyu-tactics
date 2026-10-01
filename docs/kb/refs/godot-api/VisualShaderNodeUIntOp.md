# VisualShaderNodeUIntOp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeUIntOp` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeUIntOp.md`

**摘要**：An unsigned integer scalar operator to be used within the visual shader graph.

## 描述

Applies `operator` to two unsigned integer inputs: `a` and `b`.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeUIntOp.Operator`
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
| `5` | `OP_MAX` |  |
| `6` | `OP_MIN` |  |
| `7` | `OP_BITWISE_AND` |  |
| `8` | `OP_BITWISE_OR` |  |
| `9` | `OP_BITWISE_XOR` |  |
| `10` | `OP_BITWISE_LEFT_SHIFT` |  |
| `11` | `OP_BITWISE_RIGHT_SHIFT` |  |
| `12` | `OP_ENUM_SIZE` |  |

