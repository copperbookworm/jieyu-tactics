# TextureRect

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextureRect` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextureRect.md`

**摘要**：A control that displays a texture.

## 描述

A control that displays a texture, for example an icon inside a GUI. The texture's placement can be controlled with the `stretch_mode` property. It can scale, tile, or stay centered inside its bounding rectangle.

## 属性

- **`expand_mode`** `int` = `0` · 枚举 `TextureRect.ExpandMode`
  - 其它属性：experimental=Using [constant EXPAND_FIT_WIDTH], [constant EXPAND_FIT_WIDTH_PROPORTIONAL], [constant EXPAND_FIT_HEIGHT], or [constant EXPAND_FIT_HEIGHT_PROPORTIONAL] may result in unstable behavior in some [Container] controls. This behavior may be re-evaluated and changed in the future. · getter=get_expand_mode · setter=set_expand_mode
- **`flip_h`** `bool` = `false`
  - 其它属性：getter=is_flipped_h · setter=set_flip_h
- **`flip_v`** `bool` = `false`
  - 其它属性：getter=is_flipped_v · setter=set_flip_v
- **`mouse_filter`** `int` = `1` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`stretch_mode`** `int` = `0` · 枚举 `TextureRect.StretchMode`
  - 其它属性：getter=get_stretch_mode · setter=set_stretch_mode
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture

## 枚举

### `ExpandMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EXPAND_KEEP_SIZE` |  |
| `1` | `EXPAND_IGNORE_SIZE` |  |
| `2` | `EXPAND_FIT_WIDTH` |  |
| `3` | `EXPAND_FIT_WIDTH_PROPORTIONAL` |  |
| `4` | `EXPAND_FIT_HEIGHT` |  |
| `5` | `EXPAND_FIT_HEIGHT_PROPORTIONAL` |  |

### `StretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STRETCH_SCALE` |  |
| `1` | `STRETCH_TILE` |  |
| `2` | `STRETCH_KEEP` |  |
| `3` | `STRETCH_KEEP_CENTERED` |  |
| `4` | `STRETCH_KEEP_ASPECT` |  |
| `5` | `STRETCH_KEEP_ASPECT_CENTERED` |  |
| `6` | `STRETCH_KEEP_ASPECT_COVERED` |  |

## 教程链接

- [3D Voxel Demo](None)

