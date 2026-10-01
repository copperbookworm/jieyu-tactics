# VisualShaderNodeTransformFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTransformFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTransformFunc.md`

**摘要**：Computes a `Transform3D` function within the visual shader graph.

## 描述

Computes an inverse or transpose function on the provided `Transform3D`.

## 属性

- **`function`** `int` = `0` · 枚举 `VisualShaderNodeTransformFunc.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_INVERSE` |  |
| `1` | `FUNC_TRANSPOSE` |  |
| `2` | `FUNC_MAX` |  |

