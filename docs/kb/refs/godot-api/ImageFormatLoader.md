# ImageFormatLoader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ImageFormatLoader` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ImageFormatLoader.md`

**摘要**：Base class to add support for specific image formats.

## 描述

The engine supports multiple image formats out of the box (PNG, SVG, JPEG, WebP to name a few), but you can choose to implement support for additional image formats by extending `ImageFormatLoaderExtension`.

## 枚举

### `LoaderFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_NONE` | （位标志） |
| `1` | `FLAG_FORCE_LINEAR` | （位标志） |
| `2` | `FLAG_CONVERT_COLORS` | （位标志） |

