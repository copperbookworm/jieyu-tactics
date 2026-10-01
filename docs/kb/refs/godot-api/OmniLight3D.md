# OmniLight3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OmniLight3D` → `Light3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=point
> 自动生成，勿手改。文件：`refs/godot-api/OmniLight3D.md`

**摘要**：Omnidirectional light, such as a light bulb or a candle.

## 描述

An Omnidirectional light is a type of `Light3D` that emits light in all directions. The light is attenuated by distance and this attenuation can be configured by changing its energy, radius, and attenuation parameters.
		**Note:** When using the Mobile rendering method, only 8 omni lights can be displayed on each mesh resource. Attempting to display more than 8 omni lights on a single mesh resource will result in omni lights flickering in and out as the camera moves. When using the Compatibility rendering method, only 8 omni lights can be displayed on each mesh resource by default, but this can be increased by adjusting `ProjectSettings.rendering/limits/opengl/max_lights_per_object`.
		**Note:** When using the Mobile or Compatibility rendering methods, omni lights will only correctly affect meshes whose visibility AABB intersects with the light's AABB. If using a shader to deform the mesh in a way that makes it go outside its AABB, `GeometryInstance3D.extra_cull_margin` must be increased on the mesh. Otherwise, the light may not be visible on the mesh.

## 属性

- **`light_specular`** `float` = `0.5`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param
- **`omni_attenuation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`omni_range`** `float` = `5.0`
  - 其它属性：getter=get_param · setter=set_param
- **`omni_shadow_mode`** `int` = `1` · 枚举 `OmniLight3D.ShadowMode`
  - 其它属性：getter=get_shadow_mode · setter=set_shadow_mode
- **`shadow_normal_bias`** `float` = `1.0`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param

## 枚举

### `ShadowMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOW_DUAL_PARABOLOID` |  |
| `1` | `SHADOW_CUBE` |  |

## 教程链接

- [3D lights and shadows](None)
- [Faking global illumination](None)

