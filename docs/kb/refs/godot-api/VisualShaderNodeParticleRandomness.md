# VisualShaderNodeParticleRandomness

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeParticleRandomness` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeParticleRandomness.md`

**摘要**：Visual shader node for randomizing particle values.

## 描述

Randomness node will output pseudo-random values of the given type based on the specified minimum and maximum values.

## 属性

- **`op_type`** `int` = `0` · 枚举 `VisualShaderNodeParticleRandomness.OpType`
  - 其它属性：getter=get_op_type · setter=set_op_type

## 枚举

### `OpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_TYPE_SCALAR` |  |
| `1` | `OP_TYPE_VECTOR_2D` |  |
| `2` | `OP_TYPE_VECTOR_3D` |  |
| `3` | `OP_TYPE_VECTOR_4D` |  |
| `4` | `OP_TYPE_MAX` |  |

