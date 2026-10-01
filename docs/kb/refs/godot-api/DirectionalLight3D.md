# DirectionalLight3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`DirectionalLight3D` → `Light3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sun
> 自动生成，勿手改。文件：`refs/godot-api/DirectionalLight3D.md`

**摘要**：Directional light from a distance, as from the Sun.

## 描述

A directional light is a type of `Light3D` node that models an infinite number of parallel rays covering the entire scene. It is used for lights with strong intensity that are located far away from the scene to model sunlight or moonlight.
		Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see `Vector3.FORWARD` and `Vector3.MODEL_FRONT`). The position of the node is ignored; only the basis is used to determine light direction.

## 属性

- **`directional_shadow_blend_splits`** `bool` = `false`
  - 其它属性：getter=is_blend_splits_enabled · setter=set_blend_splits
- **`directional_shadow_fade_start`** `float` = `0.8`
  - 其它属性：getter=get_param · setter=set_param
- **`directional_shadow_max_distance`** `float` = `100.0`
  - 其它属性：getter=get_param · setter=set_param
- **`directional_shadow_mode`** `int` = `2` · 枚举 `DirectionalLight3D.ShadowMode`
  - 其它属性：getter=get_shadow_mode · setter=set_shadow_mode
- **`directional_shadow_pancake_size`** `float` = `20.0`
  - 其它属性：getter=get_param · setter=set_param
- **`directional_shadow_split_1`** `float` = `0.1`
  - 其它属性：getter=get_param · setter=set_param
- **`directional_shadow_split_2`** `float` = `0.2`
  - 其它属性：getter=get_param · setter=set_param
- **`directional_shadow_split_3`** `float` = `0.5`
  - 其它属性：getter=get_param · setter=set_param
- **`sky_mode`** `int` = `0` · 枚举 `DirectionalLight3D.SkyMode`
  - 其它属性：getter=get_sky_mode · setter=set_sky_mode

## 枚举

### `ShadowMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_ORTHOGONAL` |  |
| `1` | `SHADOW_PARALLEL_2_SPLITS` |  |
| `2` | `SHADOW_PARALLEL_4_SPLITS` |  |

### `SkyMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SKY_MODE_LIGHT_AND_SKY` |  |
| `1` | `SKY_MODE_LIGHT_ONLY` |  |
| `2` | `SKY_MODE_SKY_ONLY` |  |

## 教程链接

- [3D lights and shadows](None)
- [Faking global illumination](None)

