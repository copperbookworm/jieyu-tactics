# CanvasTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CanvasTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CanvasTexture.md`

**摘要**：Texture with optional normal and specular maps for use in 2D rendering.

## 描述

`CanvasTexture` is an alternative to `ImageTexture` for 2D rendering. It allows using normal maps and specular maps in any node that inherits from `CanvasItem`. `CanvasTexture` also allows overriding the texture's filter and repeat mode independently of the node's properties (or the project settings).
		**Note:** `CanvasTexture` cannot be used in 3D. It will not display correctly when applied to any `VisualInstance3D`, such as `Sprite3D` or `Decal`. For physically-based materials in 3D, use `BaseMaterial3D` instead.

## 属性

- **`diffuse_texture`** `Texture2D`
  - 其它属性：getter=get_diffuse_texture · setter=set_diffuse_texture
- **`normal_texture`** `Texture2D`
  - 其它属性：getter=get_normal_texture · setter=set_normal_texture
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`specular_color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_specular_color · setter=set_specular_color
- **`specular_shininess`** `float` = `1.0`
  - 其它属性：getter=get_specular_shininess · setter=set_specular_shininess
- **`specular_texture`** `Texture2D`
  - 其它属性：getter=get_specular_texture · setter=set_specular_texture
- **`texture_filter`** `int` = `0` · 枚举 `CanvasItem.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`texture_repeat`** `int` = `0` · 枚举 `CanvasItem.TextureRepeat`
  - 其它属性：getter=get_texture_repeat · setter=set_texture_repeat

## 教程链接

- [2D Lights and Shadows](None)

