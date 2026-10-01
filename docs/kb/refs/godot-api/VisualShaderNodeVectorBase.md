# VisualShaderNodeVectorBase

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeVectorBase` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeVectorBase.md`

**摘要**：A base type for the nodes that perform vector operations within the visual shader graph.

## 描述

This is an abstract class. See the derived types for descriptions of the possible operations.

## 属性

- **`op_type`** `int` = `1` · 枚举 `VisualShaderNodeVectorBase.OpType`
  - 其它属性：getter=get_op_type · setter=set_op_type

## 枚举

### `OpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_TYPE_VECTOR_2D` |  |
| `1` | `OP_TYPE_VECTOR_3D` |  |
| `2` | `OP_TYPE_VECTOR_4D` |  |
| `3` | `OP_TYPE_MAX` |  |

