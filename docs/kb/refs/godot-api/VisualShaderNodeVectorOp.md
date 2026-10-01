# VisualShaderNodeVectorOp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeVectorOp` → `VisualShaderNodeVectorBase` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeVectorOp.md`

**摘要**：A vector operator to be used within the visual shader graph.

## 描述

A visual shader node for use of vector operators. Operates on vector `a` and vector `b`.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeVectorOp.Operator`
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
| `8` | `OP_CROSS` |  |
| `9` | `OP_ATAN2` |  |
| `10` | `OP_REFLECT` |  |
| `11` | `OP_STEP` |  |
| `12` | `OP_ENUM_SIZE` |  |

