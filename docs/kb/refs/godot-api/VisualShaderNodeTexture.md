# VisualShaderNodeTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeTexture` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeTexture.md`

**摘要**：Performs a 2D texture lookup within the visual shader graph.

## 描述

Performs a lookup operation on the provided texture, with support for multiple texture sources to choose from.

## 属性

- **`source`** `int` = `0` · 枚举 `VisualShaderNodeTexture.Source`
  - 其它属性：getter=get_source · setter=set_source
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_type`** `int` = `0` · 枚举 `VisualShaderNodeTexture.TextureType`
  - 其它属性：getter=get_texture_type · setter=set_texture_type

## 枚举

### `Source`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SOURCE_TEXTURE` |  |
| `1` | `SOURCE_SCREEN` |  |
| `2` | `SOURCE_2D_TEXTURE` |  |
| `3` | `SOURCE_2D_NORMAL` |  |
| `4` | `SOURCE_DEPTH` |  |
| `5` | `SOURCE_PORT` |  |
| `6` | `SOURCE_3D_NORMAL` |  |
| `7` | `SOURCE_ROUGHNESS` |  |
| `8` | `SOURCE_MAX` |  |

### `TextureType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_DATA` |  |
| `1` | `TYPE_COLOR` |  |
| `2` | `TYPE_NORMAL_MAP` |  |
| `3` | `TYPE_MAX` |  |

