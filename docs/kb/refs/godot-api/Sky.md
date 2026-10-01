# Sky

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Sky` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Sky.md`

**摘要**：Defines a 3D environment's background by using a `Material`.

## 描述

The `Sky` class uses a `Material` to render a 3D environment's background and the light it emits by updating the reflection/radiance cubemaps.

## 属性

- **`process_mode`** `int` = `0` · 枚举 `Sky.ProcessMode`
  - 其它属性：getter=get_process_mode · setter=set_process_mode
- **`radiance_size`** `int` = `3` · 枚举 `Sky.RadianceSize`
  - 其它属性：getter=get_radiance_size · setter=set_radiance_size
- **`sky_material`** `Material`
  - 其它属性：getter=get_material · setter=set_material

## 枚举

### `RadianceSize`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RADIANCE_SIZE_32` |  |
| `1` | `RADIANCE_SIZE_64` |  |
| `2` | `RADIANCE_SIZE_128` |  |
| `3` | `RADIANCE_SIZE_256` |  |
| `4` | `RADIANCE_SIZE_512` |  |
| `5` | `RADIANCE_SIZE_1024` |  |
| `6` | `RADIANCE_SIZE_2048` |  |
| `7` | `RADIANCE_SIZE_MAX` |  |

### `ProcessMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROCESS_MODE_AUTOMATIC` |  |
| `1` | `PROCESS_MODE_QUALITY` |  |
| `2` | `PROCESS_MODE_INCREMENTAL` |  |
| `3` | `PROCESS_MODE_REALTIME` |  |

