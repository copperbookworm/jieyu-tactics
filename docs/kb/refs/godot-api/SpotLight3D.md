# SpotLight3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SpotLight3D` → `Light3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SpotLight3D.md`

**摘要**：A spotlight, such as a reflector spotlight or a lantern.

## 描述

A Spotlight is a type of `Light3D` node that emits lights in a specific direction, in the shape of a cone. The light is attenuated through the distance. This attenuation can be configured by changing the energy, radius and attenuation parameters of `Light3D`.
		Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see `Vector3.FORWARD` and `Vector3.MODEL_FRONT`).
		**Note:** When using the Mobile rendering method, only 8 spot lights can be displayed on each mesh resource. Attempting to display more than 8 spot lights on a single mesh resource will result in spot lights flickering in and out as the camera moves. When using the Compatibility rendering method, only 8 spot lights can be displayed on each mesh resource by default, but this can be increased by adjusting `ProjectSettings.rendering/limits/opengl/max_lights_per_object`.
		**Note:** When using the Mobile or Compatibility rendering methods, spot lights will only correctly affect meshes whose visibility AABB intersects with the light's AABB. If using a shader to deform the mesh in a way that makes it go outside its AABB, `GeometryInstance3D.extra_cull_margin` must be increased on the mesh. Otherwise, the light may not be visible on the mesh.

## 属性

- **`light_specular`** `float` = `0.5`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param
- **`shadow_bias`** `float` = `0.03`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param
- **`shadow_normal_bias`** `float` = `1.0`
  - 其它属性：getter=get_param · overrides=Light3D · setter=set_param
- **`spot_angle`** `float` = `45.0`
  - 其它属性：getter=get_param · setter=set_param
- **`spot_angle_attenuation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`spot_attenuation`** `float` = `1.0`
  - 其它属性：getter=get_param · setter=set_param
- **`spot_range`** `float` = `5.0`
  - 其它属性：getter=get_param · setter=set_param

## 教程链接

- [3D lights and shadows](None)
- [Faking global illumination](None)
- [Third Person Shooter (TPS) Demo](None)

