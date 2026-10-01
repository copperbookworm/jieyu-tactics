# VisualShaderNodeTextureParameter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTextureParameter` → `VisualShaderNodeParameter` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTextureParameter.md`

**摘要**：Performs a uniform texture lookup within the visual shader graph.

## 描述

Performs a lookup operation on the texture provided as a uniform for the shader.

## 属性

- **`color_default`** `int` = `0` · 枚举 `VisualShaderNodeTextureParameter.ColorDefault`
  - 其它属性：getter=get_color_default · setter=set_color_default
- **`texture_filter`** `int` = `0` · 枚举 `VisualShaderNodeTextureParameter.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`texture_repeat`** `int` = `0` · 枚举 `VisualShaderNodeTextureParameter.TextureRepeat`
  - 其它属性：getter=get_texture_repeat · setter=set_texture_repeat
- **`texture_source`** `int` = `0` · 枚举 `VisualShaderNodeTextureParameter.TextureSource`
  - 其它属性：getter=get_texture_source · setter=set_texture_source
- **`texture_type`** `int` = `0` · 枚举 `VisualShaderNodeTextureParameter.TextureType`
  - 其它属性：getter=get_texture_type · setter=set_texture_type

## 枚举

### `TextureType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_DATA` |  |
| `1` | `TYPE_COLOR` |  |
| `2` | `TYPE_NORMAL_MAP` |  |
| `3` | `TYPE_ANISOTROPY` |  |
| `4` | `TYPE_MAX` |  |

### `ColorDefault`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COLOR_DEFAULT_WHITE` |  |
| `1` | `COLOR_DEFAULT_BLACK` |  |
| `2` | `COLOR_DEFAULT_TRANSPARENT` |  |
| `3` | `COLOR_DEFAULT_MAX` |  |

### `TextureFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILTER_DEFAULT` |  |
| `1` | `FILTER_NEAREST` |  |
| `2` | `FILTER_LINEAR` |  |
| `3` | `FILTER_NEAREST_MIPMAP` |  |
| `4` | `FILTER_LINEAR_MIPMAP` |  |
| `5` | `FILTER_NEAREST_MIPMAP_ANISOTROPIC` |  |
| `6` | `FILTER_LINEAR_MIPMAP_ANISOTROPIC` |  |
| `7` | `FILTER_MAX` |  |

### `TextureRepeat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REPEAT_DEFAULT` |  |
| `1` | `REPEAT_ENABLED` |  |
| `2` | `REPEAT_DISABLED` |  |
| `3` | `REPEAT_MAX` |  |

### `TextureSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SOURCE_NONE` |  |
| `1` | `SOURCE_SCREEN` |  |
| `2` | `SOURCE_DEPTH` |  |
| `3` | `SOURCE_NORMAL_ROUGHNESS` |  |
| `4` | `SOURCE_MAX` |  |

