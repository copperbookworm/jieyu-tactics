# VisualShaderNodeIntFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeIntFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeIntFunc.md`

**摘要**：A scalar integer function to be used within the visual shader graph.

## 描述

Accept an integer scalar (`x`) to the input port and transform it according to `function`.

## 属性

- **`function`** `int` = `2` · 枚举 `VisualShaderNodeIntFunc.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_ABS` |  |
| `1` | `FUNC_NEGATE` |  |
| `2` | `FUNC_SIGN` |  |
| `3` | `FUNC_BITWISE_NOT` |  |
| `4` | `FUNC_MAX` |  |

