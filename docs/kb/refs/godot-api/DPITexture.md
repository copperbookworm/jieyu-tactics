# DPITexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`DPITexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/DPITexture.md`

**摘要**：An automatically scalable `Texture2D` based on an SVG image.

## 描述

An automatically scalable `Texture2D` based on an SVG image. `DPITexture`s are used to automatically re-rasterize icons and other texture based UI theme elements to match viewport scale and font oversampling. See also `ProjectSettings.display/window/stretch/mode` ("canvas_items" mode) and `Viewport.oversampling_override`.

## 属性

- **`base_scale`** `float` = `1.0`
  - 其它属性：getter=get_base_scale · setter=set_base_scale
- **`color_map`** `Dictionary` = `{}`
  - 其它属性：getter=get_color_map · setter=set_color_map
- **`fix_alpha_border`** `bool` = `false`
  - 其它属性：getter=get_fix_alpha_border · setter=set_fix_alpha_border
- **`premult_alpha`** `bool` = `false`
  - 其它属性：getter=get_premult_alpha · setter=set_premult_alpha
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`saturation`** `float` = `1.0`
  - 其它属性：getter=get_saturation · setter=set_saturation

## 方法

### `create_from_string(source: String, scale: float = 1.0, saturation: float = 1.0, color_map: Dictionary = {}) -> DPITexture`
- 限定：qualifiers=static

Creates a new `DPITexture` and initializes it by allocating and setting the SVG data to `source`.

### `get_scaled_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of the texture rasterized to match the oversampling of the currently drawn canvas item.

### `get_source() -> String`
- 限定：qualifiers=const

Returns this SVG texture's source code.

### `set_size_override(size: Vector2i) -> void`

Resizes the texture to the specified dimensions.

### `set_source(source: String) -> void`

Sets this SVG texture's source code.

