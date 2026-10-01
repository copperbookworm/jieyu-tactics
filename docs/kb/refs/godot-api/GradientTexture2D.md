# GradientTexture2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GradientTexture2D` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GradientTexture2D.md`

**摘要**：A 2D texture that creates a pattern with colors obtained from a `Gradient`.

## 描述

A 2D texture that obtains colors from a `Gradient` to fill the texture data. This texture is able to transform a color transition into different patterns such as a linear or a radial gradient. The texture is filled by interpolating colors starting from `fill_from` to `fill_to` offsets by default, but the gradient fill can be repeated to cover the entire texture.
		The gradient is sampled individually for each pixel so it does not necessarily represent an exact copy of the gradient (see `width` and `height`). See also `GradientTexture1D`, `CurveTexture` and `CurveXYZTexture`.

## 属性

- **`fill`** `int` = `0` · 枚举 `GradientTexture2D.Fill`
  - 其它属性：getter=get_fill · setter=set_fill
- **`fill_from`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_fill_from · setter=set_fill_from
- **`fill_to`** `Vector2` = `Vector2(1, 0)`
  - 其它属性：getter=get_fill_to · setter=set_fill_to
- **`gradient`** `Gradient`
  - 其它属性：getter=get_gradient · setter=set_gradient
- **`height`** `int` = `64`
  - 其它属性：getter=get_height · setter=set_height
- **`repeat`** `int` = `0` · 枚举 `GradientTexture2D.Repeat`
  - 其它属性：getter=get_repeat · setter=set_repeat
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`use_hdr`** `bool` = `false`
  - 其它属性：getter=is_using_hdr · setter=set_use_hdr
- **`width`** `int` = `64`
  - 其它属性：getter=get_width · setter=set_width

## 枚举

### `Fill`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILL_LINEAR` |  |
| `1` | `FILL_RADIAL` |  |
| `2` | `FILL_SQUARE` |  |
| `3` | `FILL_CONIC` |  |

### `Repeat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REPEAT_NONE` |  |
| `1` | `REPEAT` |  |
| `2` | `REPEAT_MIRROR` |  |

