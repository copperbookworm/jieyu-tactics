# Decal

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Decal` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=stain
> 自动生成，勿手改。文件：`refs/godot-api/Decal.md`

**摘要**：Node that projects a texture onto a `MeshInstance3D`.

## 描述

`Decal`s are used to project a texture onto a `Mesh` in the scene. Use Decals to add detail to a scene without affecting the underlying `Mesh`. They are often used to add weathering to building, add dirt or mud to the ground, or add variety to props. Decals can be moved at any time, making them suitable for things like blob shadows or laser sight dots.
		They are made of an `AABB` and a group of `Texture2D`s specifying `Color`, normal, ORM (ambient occlusion, roughness, metallic), and emission. Decals are projected within their `AABB` so altering the orientation of the Decal affects the direction in which they are projected. By default, Decals are projected down (i.e. from positive Y to negative Y).
		The `Texture2D`s associated with the Decal are automatically stored in a texture atlas which is used for drawing the decals so all decals can be drawn at once. Godot uses clustered decals, meaning they are stored in cluster data and drawn when the mesh is drawn, they are not drawn as a post-processing effect after.
		**Note:** Decals cannot affect an underlying material's transparency, regardless of its transparency mode (alpha blend, alpha scissor, alpha hash, opaque pre-pass). This means translucent or transparent areas of a material will remain translucent or transparent even if an opaque decal is applied on them.
		**Note:** Decals are only supported in the Forward+ and Mobile rendering methods, not Compatibility. When using the Mobile rendering method, only 8 decals can be displayed on each mesh resource. Attempting to display more than 8 decals on a single mesh resource will result in decals flickering in and out as the camera moves.
		**Note:** When using the Mobile rendering method, decals will only correctly affect meshes whose visibility AABB intersects with the decal's AABB. If using a shader to deform the mesh in a way that makes it go outside its AABB, `GeometryInstance3D.extra_cull_margin` must be increased on the mesh. Otherwise, the decal may not be visible on the mesh.

## 属性

- **`albedo_mix`** `float` = `1.0`
  - 其它属性：getter=get_albedo_mix · setter=set_albedo_mix
- **`cull_mask`** `int` = `1048575`
  - 其它属性：getter=get_cull_mask · setter=set_cull_mask
- **`distance_fade_begin`** `float` = `40.0`
  - 其它属性：getter=get_distance_fade_begin · keywords=lod_begin · setter=set_distance_fade_begin
- **`distance_fade_enabled`** `bool` = `false`
  - 其它属性：getter=is_distance_fade_enabled · keywords=lod_enabled · setter=set_enable_distance_fade
- **`distance_fade_length`** `float` = `10.0`
  - 其它属性：getter=get_distance_fade_length · keywords=lod_length · setter=set_distance_fade_length
- **`emission_energy`** `float` = `1.0`
  - 其它属性：getter=get_emission_energy · setter=set_emission_energy
- **`lower_fade`** `float` = `0.3`
  - 其它属性：getter=get_lower_fade · setter=set_lower_fade
- **`modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · keywords=color, colour · setter=set_modulate
- **`normal_fade`** `float` = `0.0`
  - 其它属性：getter=get_normal_fade · setter=set_normal_fade
- **`size`** `Vector3` = `Vector3(2, 2, 2)`
  - 其它属性：getter=get_size · setter=set_size
- **`texture_albedo`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_emission`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_normal`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_orm`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`upper_fade`** `float` = `0.3`
  - 其它属性：getter=get_upper_fade · setter=set_upper_fade

## 方法

### `get_texture(type: int) -> Texture2D`
- 限定：qualifiers=const

Returns the `Texture2D` associated with the specified `DecalTexture`. This is a convenience method, in most cases you should access the texture directly.
				For example, instead of `albedo_tex = $Decal.get_texture(Decal.TEXTURE_ALBEDO)`, use `albedo_tex = $Decal.texture_albedo`.
				One case where this is better than accessing the texture directly is when you want to copy one Decal's textures to another. For example:
				`codeblocks`
				`gdscript`
				for i in Decal.TEXTURE_MAX:
					$NewDecal.set_texture(i, $OldDecal.get_texture(i))
				
				`csharp`
				for (int i = 0; i < (int)Decal.DecalTexture.Max; i++)
				{
					GetNode<Decal>("NewDecal").SetTexture(i, GetNode<Decal>("OldDecal").GetTexture(i));
				}

### `set_texture(type: int, texture: Texture2D) -> void`

Sets the `Texture2D` associated with the specified `DecalTexture`. This is a convenience method, in most cases you should access the texture directly.
				For example, instead of `$Decal.set_texture(Decal.TEXTURE_ALBEDO, albedo_tex)`, use `$Decal.texture_albedo = albedo_tex`.
				One case where this is better than accessing the texture directly is when you want to copy one Decal's textures to another. For example:
				`codeblocks`
				`gdscript`
				for i in Decal.TEXTURE_MAX:
					$NewDecal.set_texture(i, $OldDecal.get_texture(i))
				
				`csharp`
				for (int i = 0; i < (int)Decal.DecalTexture.Max; i++)
				{
					GetNode<Decal>("NewDecal").SetTexture(i, GetNode<Decal>("OldDecal").GetTexture(i));
				}

## 枚举

### `DecalTexture`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_ALBEDO` |  |
| `1` | `TEXTURE_NORMAL` |  |
| `2` | `TEXTURE_ORM` |  |
| `3` | `TEXTURE_EMISSION` |  |
| `4` | `TEXTURE_MAX` |  |

