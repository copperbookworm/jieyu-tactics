# ResourceImporterTextureAtlas

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterTextureAtlas` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterTextureAtlas.md`

**摘要**：Imports a collection of textures from a PNG image into an optimized `AtlasTexture` for 2D rendering.

## 描述

This imports a collection of textures from a PNG image into an `AtlasTexture` or 2D `ArrayMesh`. This can be used to save memory when importing 2D animations from spritesheets. Texture atlases are only supported in 2D rendering, not 3D. See also `ResourceImporterTexture` and `ResourceImporterLayeredTexture`.
		**Note:** `ResourceImporterTextureAtlas` does not handle importing `TileSetAtlasSource`, which is created using the `TileSet` editor instead.

## 属性

- **`atlas_file`** `String` = `""`
  - 其它属性：getter= · setter=
- **`crop_to_region`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`import_mode`** `int` = `0`
  - 其它属性：getter= · setter=
- **`trim_alpha_border_from_region`** `bool` = `true`
  - 其它属性：getter= · setter=

