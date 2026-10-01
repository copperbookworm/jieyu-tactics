# GPUParticlesCollisionSDF3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticlesCollisionSDF3D` → `GPUParticlesCollision3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticlesCollisionSDF3D.md`

**摘要**：A baked signed distance field 3D particle collision shape affecting `GPUParticles3D` nodes.

## 描述

A baked signed distance field 3D particle collision shape affecting `GPUParticles3D` nodes.
		Signed distance fields (SDF) allow for efficiently representing approximate collision shapes for convex and concave objects of any shape. This is more flexible than `GPUParticlesCollisionHeightField3D`, but it requires a baking step.
		**Baking:** The signed distance field texture can be baked by selecting the `GPUParticlesCollisionSDF3D` node in the editor, then clicking **Bake SDF** at the top of the 3D viewport. Any *visible* `MeshInstance3D`s within the `size` will be taken into account for baking, regardless of their `GeometryInstance3D.gi_mode`.
		**Note:** Baking a `GPUParticlesCollisionSDF3D`'s `texture` is only possible within the editor, as there is no bake method exposed for use in exported projects. However, it's still possible to load pre-baked `Texture3D`s into its `texture` property in an exported project.
		**Note:** `ParticleProcessMaterial.collision_mode` must be `ParticleProcessMaterial.COLLISION_RIGID` or `ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT` on the `GPUParticles3D`'s process material for collision to work.
		**Note:** Particle collision only affects `GPUParticles3D`, not `CPUParticles3D`.

## 属性

- **`bake_mask`** `int` = `4294967295`
  - 其它属性：getter=get_bake_mask · setter=set_bake_mask
- **`resolution`** `int` = `2` · 枚举 `GPUParticlesCollisionSDF3D.Resolution`
  - 其它属性：getter=get_resolution · setter=set_resolution
- **`size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_size · setter=set_size
- **`texture`** `Texture3D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`thickness`** `float` = `1.0`
  - 其它属性：getter=get_thickness · setter=set_thickness

## 方法

### `get_bake_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `bake_mask` is enabled, given a `layer_number` between 1 and 32.

### `set_bake_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `bake_mask`, given a `layer_number` between 1 and 32.

## 枚举

### `Resolution`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESOLUTION_16` |  |
| `1` | `RESOLUTION_32` |  |
| `2` | `RESOLUTION_64` |  |
| `3` | `RESOLUTION_128` |  |
| `4` | `RESOLUTION_256` |  |
| `5` | `RESOLUTION_512` |  |
| `6` | `RESOLUTION_MAX` |  |

