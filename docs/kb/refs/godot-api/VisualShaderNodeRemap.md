# VisualShaderNodeRemap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeRemap` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeRemap.md`

**摘要**：A visual shader node for remap function.

## 描述

Remap will transform the input range into output range, e.g. you can change a `0..1` value to `-2..2` etc. See `@GlobalScope.remap` for more details.

## 属性

- **`op_type`** `int` = `0` · 枚举 `VisualShaderNodeRemap.OpType`
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

