# ProceduralSkyMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ProceduralSkyMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ProceduralSkyMaterial.md`

**摘要**：A material that defines a simple sky for a `Sky` resource.

## 描述

`ProceduralSkyMaterial` provides a way to create an effective background quickly by defining procedural parameters for the sun, the sky and the ground. The sky and ground are defined by a main color, a color at the horizon, and an easing curve to interpolate between them. Suns are described by a position in the sky, a color, and a max angle from the sun at which the easing curve ends. The max angle therefore defines the size of the sun in the sky.
		`ProceduralSkyMaterial` supports up to 4 suns, using the color, and energy, direction, and angular distance of the first four `DirectionalLight3D` nodes in the scene. This means that the suns are defined individually by the properties of their corresponding `DirectionalLight3D`s and globally by `sun_angle_max` and `sun_curve`.
		`ProceduralSkyMaterial` uses a lightweight shader to draw the sky and is therefore suited for real-time updates. This makes it a great option for a sky that is simple and computationally cheap, but unrealistic. If you need a more realistic procedural option, use `PhysicalSkyMaterial`.

## 属性

- **`energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_energy_multiplier · setter=set_energy_multiplier
- **`ground_bottom_color`** `Color` = `Color(0.2, 0.169, 0.133, 1)`
  - 其它属性：getter=get_ground_bottom_color · setter=set_ground_bottom_color
- **`ground_curve`** `float` = `0.02`
  - 其它属性：getter=get_ground_curve · setter=set_ground_curve
- **`ground_energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_ground_energy_multiplier · setter=set_ground_energy_multiplier
- **`ground_horizon_color`** `Color` = `Color(0.6463, 0.6558, 0.6708, 1)`
  - 其它属性：getter=get_ground_horizon_color · setter=set_ground_horizon_color
- **`sky_cover`** `Texture2D`
  - 其它属性：getter=get_sky_cover · setter=set_sky_cover
- **`sky_cover_modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_sky_cover_modulate · setter=set_sky_cover_modulate
- **`sky_curve`** `float` = `0.15`
  - 其它属性：getter=get_sky_curve · setter=set_sky_curve
- **`sky_energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_sky_energy_multiplier · setter=set_sky_energy_multiplier
- **`sky_horizon_color`** `Color` = `Color(0.6463, 0.6558, 0.6708, 1)`
  - 其它属性：getter=get_sky_horizon_color · setter=set_sky_horizon_color
- **`sky_top_color`** `Color` = `Color(0.385, 0.454, 0.55, 1)`
  - 其它属性：getter=get_sky_top_color · setter=set_sky_top_color
- **`sun_angle_max`** `float` = `30.0`
  - 其它属性：getter=get_sun_angle_max · setter=set_sun_angle_max
- **`sun_curve`** `float` = `0.15`
  - 其它属性：getter=get_sun_curve · setter=set_sun_curve
- **`use_debanding`** `bool` = `true`
  - 其它属性：getter=get_use_debanding · setter=set_use_debanding

