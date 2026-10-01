# FogVolume

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FogVolume` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FogVolume.md`

**摘要**：A region that contributes to the default volumetric fog from the world environment.

## 描述

`FogVolume`s are used to add localized fog into the global volumetric fog effect. `FogVolume`s can also remove volumetric fog from specific areas if using a `FogMaterial` with a negative `FogMaterial.density`.
		Performance of `FogVolume`s is directly related to their relative size on the screen and the complexity of their attached `FogMaterial`. It is best to keep `FogVolume`s relatively small and simple where possible.
		**Note:** `FogVolume`s only have a visible effect if `Environment.volumetric_fog_enabled` is `true`. If you don't want fog to be globally visible (but only within `FogVolume` nodes), set `Environment.volumetric_fog_density` to `0.0`.

## 属性

- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`shape`** `int` = `3` · 枚举 `RenderingServer.FogVolumeShape`
  - 其它属性：getter=get_shape · setter=set_shape
- **`size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_size · setter=set_size

## 教程链接

- [Volumetric fog and fog volumes](None)

