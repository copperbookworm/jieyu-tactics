# VisualShaderNodeColorOp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeColorOp` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeColorOp.md`

**摘要**：A `Color` operator to be used within the visual shader graph.

## 描述

Applies `operator` to two color inputs.

## 属性

- **`operator`** `int` = `0` · 枚举 `VisualShaderNodeColorOp.Operator`
  - 其它属性：getter=get_operator · setter=set_operator

## 枚举

### `Operator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_SCREEN` |  |
| `1` | `OP_DIFFERENCE` |  |
| `2` | `OP_DARKEN` |  |
| `3` | `OP_LIGHTEN` |  |
| `4` | `OP_OVERLAY` |  |
| `5` | `OP_DODGE` |  |
| `6` | `OP_BURN` |  |
| `7` | `OP_SOFT_LIGHT` |  |
| `8` | `OP_HARD_LIGHT` |  |
| `9` | `OP_MAX` |  |

