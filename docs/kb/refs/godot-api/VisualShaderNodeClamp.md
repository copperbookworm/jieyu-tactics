# VisualShaderNodeClamp

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeClamp` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeClamp.md`

**摘要**：Clamps a value within the visual shader graph.

## 描述

Constrains a value to lie between `min` and `max` values.

## 属性

- **`op_type`** `int` = `0` · 枚举 `VisualShaderNodeClamp.OpType`
  - 其它属性：getter=get_op_type · setter=set_op_type

## 枚举

### `OpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_TYPE_FLOAT` |  |
| `1` | `OP_TYPE_INT` |  |
| `2` | `OP_TYPE_UINT` |  |
| `3` | `OP_TYPE_VECTOR_2D` |  |
| `4` | `OP_TYPE_VECTOR_3D` |  |
| `5` | `OP_TYPE_VECTOR_4D` |  |
| `6` | `OP_TYPE_MAX` |  |

