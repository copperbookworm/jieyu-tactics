# GPUParticlesCollisionHeightField3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticlesCollisionHeightField3D` → `GPUParticlesCollision3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticlesCollisionHeightField3D.md`

**摘要**：A real-time heightmap-shaped 3D particle collision shape affecting `GPUParticles3D` nodes.

## 描述

A real-time heightmap-shaped 3D particle collision shape affecting `GPUParticles3D` nodes.
		Heightmap shapes allow for efficiently representing collisions for convex and concave objects with a single "floor" (such as terrain). This is less flexible than `GPUParticlesCollisionSDF3D`, but it doesn't require a baking step.
		`GPUParticlesCollisionHeightField3D` can also be regenerated in real-time when it is moved, when the camera moves, or even continuously. This makes `GPUParticlesCollisionHeightField3D` a good choice for weather effects such as rain and snow and games with highly dynamic geometry. However, this class is limited since heightmaps cannot represent overhangs (e.g. indoors or caves).
		**Note:** `ParticleProcessMaterial.collision_mode` must be `true` on the `GPUParticles3D`'s process material for collision to work.
		**Note:** Particle collision only affects `GPUParticles3D`, not `CPUParticles3D`.

## 属性

- **`follow_camera_enabled`** `bool` = `false`
  - 其它属性：getter=is_follow_camera_enabled · setter=set_follow_camera_enabled
- **`heightfield_mask`** `int` = `1048575`
  - 其它属性：getter=get_heightfield_mask · setter=set_heightfield_mask
- **`resolution`** `int` = `2` · 枚举 `GPUParticlesCollisionHeightField3D.Resolution`
  - 其它属性：getter=get_resolution · setter=set_resolution
- **`size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_size · setter=set_size
- **`update_mode`** `int` = `0` · 枚举 `GPUParticlesCollisionHeightField3D.UpdateMode`
  - 其它属性：getter=get_update_mode · setter=set_update_mode

## 方法

### `get_heightfield_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified layer of the `heightfield_mask` is enabled, given a `layer_number` between `1` and `20`, inclusive.

### `set_heightfield_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `heightfield_mask`, given a `layer_number` between `1` and `20`, inclusive.

## 枚举

### `Resolution`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RESOLUTION_256` |  |
| `1` | `RESOLUTION_512` |  |
| `2` | `RESOLUTION_1024` |  |
| `3` | `RESOLUTION_2048` |  |
| `4` | `RESOLUTION_4096` |  |
| `5` | `RESOLUTION_8192` |  |
| `6` | `RESOLUTION_MAX` |  |

### `UpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UPDATE_MODE_WHEN_MOVED` |  |
| `1` | `UPDATE_MODE_ALWAYS` |  |

