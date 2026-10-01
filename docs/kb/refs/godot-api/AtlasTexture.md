# AtlasTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AtlasTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AtlasTexture.md`

**摘要**：A texture that crops out part of another Texture2D.

## 描述

`Texture2D` resource that draws only part of its `atlas` texture, as defined by the `region`. An additional `margin` can also be set, which is useful for small adjustments.
		Multiple `AtlasTexture` resources can be cropped from the same `atlas`. Packing many smaller textures into a singular large texture helps to optimize video memory costs and render calls.
		**Note:** `AtlasTexture` cannot be used in an `AnimatedTexture`, and will not tile properly in nodes such as `TextureRect` or `Sprite2D`. To tile an `AtlasTexture`, modify its `region` instead.

## 属性

- **`atlas`** `Texture2D`
  - 其它属性：getter=get_atlas · setter=set_atlas
- **`filter_clip`** `bool` = `false`
  - 其它属性：getter=has_filter_clip · setter=set_filter_clip
- **`margin`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_margin · setter=set_margin
- **`region`** `Rect2` = `Rect2(0, 0, 0, 0)`
  - 其它属性：getter=get_region · setter=set_region
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene

