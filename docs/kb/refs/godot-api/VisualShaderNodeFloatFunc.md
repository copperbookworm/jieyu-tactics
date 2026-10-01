# VisualShaderNodeFloatFunc

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeFloatFunc` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeFloatFunc.md`

**摘要**：A scalar floating-point function to be used within the visual shader graph.

## 描述

Accept a floating-point scalar (`x`) to the input port and transform it according to `function`.

## 属性

- **`function`** `int` = `13` · 枚举 `VisualShaderNodeFloatFunc.Function`
  - 其它属性：getter=get_function · setter=set_function

## 枚举

### `Function`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FUNC_SIN` |  |
| `1` | `FUNC_COS` |  |
| `2` | `FUNC_TAN` |  |
| `3` | `FUNC_ASIN` |  |
| `4` | `FUNC_ACOS` |  |
| `5` | `FUNC_ATAN` |  |
| `6` | `FUNC_SINH` |  |
| `7` | `FUNC_COSH` |  |
| `8` | `FUNC_TANH` |  |
| `9` | `FUNC_LOG` |  |
| `10` | `FUNC_EXP` |  |
| `11` | `FUNC_SQRT` |  |
| `12` | `FUNC_ABS` |  |
| `13` | `FUNC_SIGN` |  |
| `14` | `FUNC_FLOOR` |  |
| `15` | `FUNC_ROUND` |  |
| `16` | `FUNC_CEIL` |  |
| `17` | `FUNC_FRACT` |  |
| `18` | `FUNC_SATURATE` |  |
| `19` | `FUNC_NEGATE` |  |
| `20` | `FUNC_ACOSH` |  |
| `21` | `FUNC_ASINH` |  |
| `22` | `FUNC_ATANH` |  |
| `23` | `FUNC_DEGREES` |  |
| `24` | `FUNC_EXP2` |  |
| `25` | `FUNC_INVERSE_SQRT` |  |
| `26` | `FUNC_LOG2` |  |
| `27` | `FUNC_RADIANS` |  |
| `28` | `FUNC_RECIPROCAL` |  |
| `29` | `FUNC_ROUNDEVEN` |  |
| `30` | `FUNC_TRUNC` |  |
| `31` | `FUNC_ONEMINUS` |  |
| `32` | `FUNC_MAX` |  |

