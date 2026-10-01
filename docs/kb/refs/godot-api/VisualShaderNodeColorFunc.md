# VisualShaderNodeColorFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeColorFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeColorFunc.md`

**摘要**：A `Color` function to be used within the visual shader graph.

## 描述

Accept a `Color` to the input port and transform it according to `function`.

## 属性

- **`function`** `int` = `0` · 枚举 `VisualShaderNodeColorFunc.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_GRAYSCALE` |  |
| `1` | `FUNC_HSV2RGB` |  |
| `2` | `FUNC_RGB2HSV` |  |
| `3` | `FUNC_SEPIA` |  |
| `4` | `FUNC_LINEAR_TO_SRGB` |  |
| `5` | `FUNC_SRGB_TO_LINEAR` |  |
| `6` | `FUNC_MAX` |  |

