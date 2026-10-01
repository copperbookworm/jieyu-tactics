# Light2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Light2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Light2D.md`

**摘要**：Casts light in a 2D environment.

## 描述

Casts light in a 2D environment. A light is defined as a color, an energy value, a mode (see constants), and various other parameters (range and shadows-related).

## 属性

- **`blend_mode`** `int` = `0` · 枚举 `Light2D.BlendMode`
  - 其它属性：getter=get_blend_mode · setter=set_blend_mode
- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`editor_only`** `bool` = `false`
  - 其它属性：getter=is_editor_only · setter=set_editor_only
- **`enabled`** `bool` = `true`
  - 其它属性：getter=is_enabled · setter=set_enabled
- **`energy`** `float` = `1.0`
  - 其它属性：getter=get_energy · setter=set_energy
- **`range_item_cull_mask`** `int` = `1`
  - 其它属性：getter=get_item_cull_mask · setter=set_item_cull_mask
- **`range_layer_max`** `int` = `0`
  - 其它属性：getter=get_layer_range_max · setter=set_layer_range_max
- **`range_layer_min`** `int` = `0`
  - 其它属性：getter=get_layer_range_min · setter=set_layer_range_min
- **`range_z_max`** `int` = `1024`
  - 其它属性：getter=get_z_range_max · setter=set_z_range_max
- **`range_z_min`** `int` = `-1024`
  - 其它属性：getter=get_z_range_min · setter=set_z_range_min
- **`shadow_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_shadow_color · setter=set_shadow_color
- **`shadow_enabled`** `bool` = `false`
  - 其它属性：getter=is_shadow_enabled · setter=set_shadow_enabled
- **`shadow_filter`** `int` = `0` · 枚举 `Light2D.ShadowFilter`
  - 其它属性：getter=get_shadow_filter · setter=set_shadow_filter
- **`shadow_filter_smooth`** `float` = `0.0`
  - 其它属性：getter=get_shadow_smooth · setter=set_shadow_smooth
- **`shadow_item_cull_mask`** `int` = `1`
  - 其它属性：getter=get_item_shadow_cull_mask · setter=set_item_shadow_cull_mask

## 方法

### `get_height() -> float`
- 限定：qualifiers=const

Returns the light's height, which is used in 2D normal mapping. See `PointLight2D.height` and `DirectionalLight2D.height`.

### `set_height(height: float) -> void`

Sets the light's height, which is used in 2D normal mapping. See `PointLight2D.height` and `DirectionalLight2D.height`.

## 枚举

### `ShadowFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_FILTER_NONE` |  |
| `1` | `SHADOW_FILTER_PCF5` |  |
| `2` | `SHADOW_FILTER_PCF13` |  |

### `BlendMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_MODE_ADD` |  |
| `1` | `BLEND_MODE_SUB` |  |
| `2` | `BLEND_MODE_MIX` |  |

## 教程链接

- [2D lights and shadows](None)

