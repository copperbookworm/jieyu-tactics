# FastNoiseLite

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FastNoiseLite` → `Noise` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FastNoiseLite.md`

**摘要**：Generates noise using the FastNoiseLite library.

## 描述

This class generates noise using the FastNoiseLite library, which is a collection of several noise algorithms including Cellular, Perlin, Value, and more.
		Most generated noise values are in the range of `[-1, 1]`, but not always. Some of the cellular noise algorithms return results above `1`.

## 属性

- **`cellular_distance_function`** `int` = `0` · 枚举 `FastNoiseLite.CellularDistanceFunction`
  - 其它属性：getter=get_cellular_distance_function · setter=set_cellular_distance_function
- **`cellular_jitter`** `float` = `1.0`
  - 其它属性：getter=get_cellular_jitter · setter=set_cellular_jitter
- **`cellular_return_type`** `int` = `1` · 枚举 `FastNoiseLite.CellularReturnType`
  - 其它属性：getter=get_cellular_return_type · setter=set_cellular_return_type
- **`domain_warp_amplitude`** `float` = `30.0`
  - 其它属性：getter=get_domain_warp_amplitude · setter=set_domain_warp_amplitude
- **`domain_warp_enabled`** `bool` = `false`
  - 其它属性：getter=is_domain_warp_enabled · setter=set_domain_warp_enabled
- **`domain_warp_fractal_gain`** `float` = `0.5`
  - 其它属性：getter=get_domain_warp_fractal_gain · setter=set_domain_warp_fractal_gain
- **`domain_warp_fractal_lacunarity`** `float` = `6.0`
  - 其它属性：getter=get_domain_warp_fractal_lacunarity · setter=set_domain_warp_fractal_lacunarity
- **`domain_warp_fractal_octaves`** `int` = `5`
  - 其它属性：getter=get_domain_warp_fractal_octaves · setter=set_domain_warp_fractal_octaves
- **`domain_warp_fractal_type`** `int` = `1` · 枚举 `FastNoiseLite.DomainWarpFractalType`
  - 其它属性：getter=get_domain_warp_fractal_type · setter=set_domain_warp_fractal_type
- **`domain_warp_frequency`** `float` = `0.05`
  - 其它属性：getter=get_domain_warp_frequency · setter=set_domain_warp_frequency
- **`domain_warp_type`** `int` = `0` · 枚举 `FastNoiseLite.DomainWarpType`
  - 其它属性：getter=get_domain_warp_type · setter=set_domain_warp_type
- **`fractal_gain`** `float` = `0.5`
  - 其它属性：getter=get_fractal_gain · setter=set_fractal_gain
- **`fractal_lacunarity`** `float` = `2.0`
  - 其它属性：getter=get_fractal_lacunarity · setter=set_fractal_lacunarity
- **`fractal_octaves`** `int` = `5`
  - 其它属性：getter=get_fractal_octaves · setter=set_fractal_octaves
- **`fractal_ping_pong_strength`** `float` = `2.0`
  - 其它属性：getter=get_fractal_ping_pong_strength · setter=set_fractal_ping_pong_strength
- **`fractal_type`** `int` = `1` · 枚举 `FastNoiseLite.FractalType`
  - 其它属性：getter=get_fractal_type · setter=set_fractal_type
- **`fractal_weighted_strength`** `float` = `0.0`
  - 其它属性：getter=get_fractal_weighted_strength · setter=set_fractal_weighted_strength
- **`frequency`** `float` = `0.01`
  - 其它属性：getter=get_frequency · setter=set_frequency
- **`noise_type`** `int` = `1` · 枚举 `FastNoiseLite.NoiseType`
  - 其它属性：getter=get_noise_type · setter=set_noise_type
- **`offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`seed`** `int` = `0`
  - 其它属性：getter=get_seed · setter=set_seed

## 枚举

### `NoiseType`

| 值 | 名称 | 说明 |
|---|---|---|
| `5` | `TYPE_VALUE` |  |
| `4` | `TYPE_VALUE_CUBIC` |  |
| `3` | `TYPE_PERLIN` |  |
| `2` | `TYPE_CELLULAR` |  |
| `0` | `TYPE_SIMPLEX` |  |
| `1` | `TYPE_SIMPLEX_SMOOTH` |  |

### `FractalType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FRACTAL_NONE` |  |
| `1` | `FRACTAL_FBM` |  |
| `2` | `FRACTAL_RIDGED` |  |
| `3` | `FRACTAL_PING_PONG` |  |

### `CellularDistanceFunction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISTANCE_EUCLIDEAN` |  |
| `1` | `DISTANCE_EUCLIDEAN_SQUARED` |  |
| `2` | `DISTANCE_MANHATTAN` |  |
| `3` | `DISTANCE_HYBRID` |  |

### `CellularReturnType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RETURN_CELL_VALUE` |  |
| `1` | `RETURN_DISTANCE` |  |
| `2` | `RETURN_DISTANCE2` |  |
| `3` | `RETURN_DISTANCE2_ADD` |  |
| `4` | `RETURN_DISTANCE2_SUB` |  |
| `5` | `RETURN_DISTANCE2_MUL` |  |
| `6` | `RETURN_DISTANCE2_DIV` |  |

### `DomainWarpType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOMAIN_WARP_SIMPLEX` |  |
| `1` | `DOMAIN_WARP_SIMPLEX_REDUCED` |  |
| `2` | `DOMAIN_WARP_BASIC_GRID` |  |

### `DomainWarpFractalType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOMAIN_WARP_FRACTAL_NONE` |  |
| `1` | `DOMAIN_WARP_FRACTAL_PROGRESSIVE` |  |
| `2` | `DOMAIN_WARP_FRACTAL_INDEPENDENT` |  |

