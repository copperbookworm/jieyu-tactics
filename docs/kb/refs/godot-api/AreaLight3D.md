# AreaLight3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AreaLight3D` → `Light3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AreaLight3D.md`

**摘要**：An area light, such as a neon light tube or a screen.

## 描述

An area light is a type of `Light3D` node that emits light over a two-dimensional area, in the shape of a rectangle. The light is attenuated throughout the distance. This attenuation can be configured by changing the energy, `area_attenuation`, and `area_range`.
		Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see `Vector3.FORWARD` and `Vector3.MODEL_FRONT`).
		Area lights can cast soft shadows using PCSS, which you can control by tweaking the size parameter. The shadow map is drawn from the center of the light.
		**Note:** Area lights have limited support in the Mobile and Compatibility renderers. In the Mobile renderer, the size of the penumbra doesn't vary as it should with PCSS. In Compatibility, area lights cannot cast shadows.
		**Warning:** Shadows cast by an area light may look incorrect if the object casting shadows doesn't have enough subdivisions and it's very close to the area light. This is the same limitation as the Dual Paraboloid shadow mode on an `OmniLight3D`.
		**Performance:** Area lights are more demanding on the GPU compared to omni and spot lights. In Forward+, there is an additional GPU cost on *all* rendered objects as soon as one area light is present in the view frustum (due to the nature of clustered lighting). Consider using them only for cinematics or when targeting high-end devices.

## 属性

- **`area_attenuation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`area_normalize_energy`** `bool` = `true`
  - 其它属性：getter=is_area_normalizing_energy · setter=set_area_normalize_energy
- **`area_range`** `float` = `5.0`
  - 其它属性：getter=get_param · setter=set_param
- **`area_size`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_area_size · setter=set_area_size
- **`area_texture`** `Texture2D`
  - 其它属性：getter=get_area_texture · setter=set_area_texture
- **`light_size`** `float` = `0.5`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param
- **`shadow_normal_bias`** `float` = `1.0`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param

## 教程链接

- [3D lights and shadows](None)

