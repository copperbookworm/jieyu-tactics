# VisualShaderNodeBillboard

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeBillboard` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeBillboard.md`

**摘要**：A node that controls how the object faces the camera to be used within the visual shader graph.

## 描述

The output port of this node needs to be connected to `Model View Matrix` port of `VisualShaderNodeOutput`.

## 属性

- **`billboard_type`** `int` = `1` · 枚举 `VisualShaderNodeBillboard.BillboardType`
  - 其它属性：getter=get_billboard_type · setter=set_billboard_type
- **`keep_scale`** `bool` = `false`
  - 其它属性：getter=is_keep_scale_enabled · setter=set_keep_scale_enabled

## 枚举

### `BillboardType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BILLBOARD_TYPE_DISABLED` |  |
| `1` | `BILLBOARD_TYPE_ENABLED` |  |
| `2` | `BILLBOARD_TYPE_FIXED_Y` |  |
| `3` | `BILLBOARD_TYPE_PARTICLES` |  |
| `4` | `BILLBOARD_TYPE_MAX` |  |

