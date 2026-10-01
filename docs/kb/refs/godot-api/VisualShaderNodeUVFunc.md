# VisualShaderNodeUVFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeUVFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeUVFunc.md`

**摘要**：Contains functions to modify texture coordinates (`uv`) to be used within the visual shader graph.

## 描述

UV functions are similar to `Vector2` functions, but the input port of this node uses the shader's UV value by default.

## 属性

- **`function`** `int` = `0` · 枚举 `VisualShaderNodeUVFunc.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_PANNING` |  |
| `1` | `FUNC_SCALING` |  |
| `2` | `FUNC_MAX` |  |

