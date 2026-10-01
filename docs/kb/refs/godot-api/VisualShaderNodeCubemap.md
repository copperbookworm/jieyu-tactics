# VisualShaderNodeCubemap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeCubemap` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeCubemap.md`

**摘要**：A `Cubemap` sampling node to be used within the visual shader graph.

## 描述

Translated to `texture(cubemap, vec3)` in the shader language. Returns a color vector and alpha channel as scalar.

## 属性

- **`cube_map`** `TextureLayered`
  - 其它属性：getter=get_cube_map · setter=set_cube_map
- **`source`** `int` = `0` · 枚举 `VisualShaderNodeCubemap.Source`
  - 其它属性：getter=get_source · setter=set_source
- **`texture_type`** `int` = `0` · 枚举 `VisualShaderNodeCubemap.TextureType`
  - 其它属性：getter=get_texture_type · setter=set_texture_type

## 枚举

### `Source`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SOURCE_TEXTURE` |  |
| `1` | `SOURCE_PORT` |  |
| `2` | `SOURCE_MAX` |  |

### `TextureType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_DATA` |  |
| `1` | `TYPE_COLOR` |  |
| `2` | `TYPE_NORMAL_MAP` |  |
| `3` | `TYPE_MAX` |  |

