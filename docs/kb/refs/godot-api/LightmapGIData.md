# LightmapGIData

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LightmapGIData` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LightmapGIData.md`

**摘要**：Contains baked lightmap and dynamic object probe data for `LightmapGI`.

## 描述

`LightmapGIData` contains baked lightmap and dynamic object probe data for `LightmapGI`. It is replaced every time lightmaps are baked in `LightmapGI`.

## 属性

- **`light_texture`** `TextureLayered`
  - 其它属性：deprecated=The lightmap atlas can now contain multiple textures. See [member lightmap_textures]. · getter=get_light_texture · setter=set_light_texture
- **`lightmap_textures`** `TextureLayered[]` = `[]`
  - 其它属性：getter=get_lightmap_textures · setter=set_lightmap_textures
- **`shadowmask_textures`** `TextureLayered[]` = `[]`
  - 其它属性：getter=get_shadowmask_textures · setter=set_shadowmask_textures

## 方法

### `add_user(path: NodePath, uv_scale: Rect2, slice_index: int, sub_instance: int) -> void`

Adds an object that is considered baked within this `LightmapGIData`.

### `clear_users() -> void`

Clear all objects that are considered baked within this `LightmapGIData`.

### `get_user_count() -> int`
- 限定：qualifiers=const

Returns the number of objects that are considered baked within this `LightmapGIData`.

### `get_user_path(user_idx: int) -> NodePath`
- 限定：qualifiers=const

Returns the `NodePath` of the baked object at index `user_idx`.

### `is_using_spherical_harmonics() -> bool`
- 限定：qualifiers=const

If `true`, lightmaps were baked with directional information. See also `LightmapGI.directional`.

### `set_uses_spherical_harmonics(uses_spherical_harmonics: bool) -> void`

If `uses_spherical_harmonics` is `true`, tells the engine to treat the lightmap data as if it was baked with directional information.
				**Note:** Changing this value on already baked lightmaps will not cause them to be baked again. This means the material appearance will look incorrect until lightmaps are baked again, in which case the value set here is discarded as the entire `LightmapGIData` resource is replaced by the lightmapper.

## 枚举

### `ShadowmaskMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADOWMASK_MODE_NONE` |  |
| `1` | `SHADOWMASK_MODE_REPLACE` |  |
| `2` | `SHADOWMASK_MODE_OVERLAY` |  |

