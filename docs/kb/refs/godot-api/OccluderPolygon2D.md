# OccluderPolygon2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OccluderPolygon2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OccluderPolygon2D.md`

**摘要**：Defines a 2D polygon for LightOccluder2D.

## 描述

Editor facility that helps you draw a 2D polygon used as resource for `LightOccluder2D`.

## 属性

- **`closed`** `bool` = `true`
  - 其它属性：getter=is_closed · setter=set_closed
- **`cull_mode`** `int` = `0` · 枚举 `OccluderPolygon2D.CullMode`
  - 其它属性：getter=get_cull_mode · setter=set_cull_mode
- **`polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_polygon · setter=set_polygon

## 枚举

### `CullMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CULL_DISABLED` |  |
| `1` | `CULL_CLOCKWISE` |  |
| `2` | `CULL_COUNTER_CLOCKWISE` |  |

