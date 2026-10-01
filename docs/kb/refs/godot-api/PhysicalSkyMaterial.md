# PhysicalSkyMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicalSkyMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicalSkyMaterial.md`

**摘要**：A material that defines a sky for a `Sky` resource by a set of physical properties.

## 描述

The `PhysicalSkyMaterial` uses the Preetham analytic daylight model to draw a sky based on physical properties. This results in a substantially more realistic sky than the `ProceduralSkyMaterial`, but it is slightly slower and less flexible.
		The `PhysicalSkyMaterial` only supports one sun. The color, energy, and direction of the sun are taken from the first `DirectionalLight3D` in the scene tree.

## 属性

- **`energy_multiplier`** `float` = `1.0`
  - 其它属性：getter=get_energy_multiplier · setter=set_energy_multiplier
- **`ground_color`** `Color` = `Color(0.1, 0.07, 0.034, 1)`
  - 其它属性：getter=get_ground_color · setter=set_ground_color
- **`mie_coefficient`** `float` = `0.005`
  - 其它属性：getter=get_mie_coefficient · setter=set_mie_coefficient
- **`mie_color`** `Color` = `Color(0.69, 0.729, 0.812, 1)`
  - 其它属性：getter=get_mie_color · setter=set_mie_color
- **`mie_eccentricity`** `float` = `0.8`
  - 其它属性：getter=get_mie_eccentricity · setter=set_mie_eccentricity
- **`night_sky`** `Texture2D`
  - 其它属性：getter=get_night_sky · setter=set_night_sky
- **`rayleigh_coefficient`** `float` = `2.0`
  - 其它属性：getter=get_rayleigh_coefficient · setter=set_rayleigh_coefficient
- **`rayleigh_color`** `Color` = `Color(0.3, 0.405, 0.6, 1)`
  - 其它属性：getter=get_rayleigh_color · setter=set_rayleigh_color
- **`sun_disk_scale`** `float` = `1.0`
  - 其它属性：getter=get_sun_disk_scale · setter=set_sun_disk_scale
- **`turbidity`** `float` = `10.0`
  - 其它属性：getter=get_turbidity · setter=set_turbidity
- **`use_debanding`** `bool` = `true`
  - 其它属性：getter=get_use_debanding · setter=set_use_debanding

