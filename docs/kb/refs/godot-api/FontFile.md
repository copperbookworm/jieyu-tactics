# FontFile

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FontFile` → `Font` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FontFile.md`

**摘要**：Holds font source data and prerendered glyph cache, imported from a dynamic or a bitmap font.

## 描述

`FontFile` contains a set of glyphs to represent Unicode characters imported from a font file, as well as a cache of rasterized glyphs, and a set of fallback `Font`s to use.
		Use `FontVariation` to access specific OpenType variation of the font, create simulated bold / slanted version, and draw lines of text.
		For more complex text processing, use `FontVariation` in conjunction with `TextLine` or `TextParagraph`.
		Supported font formats:
		- Dynamic font importer: TrueType (.ttf), TrueType collection (.ttc), OpenType (.otf), OpenType collection (.otc), WOFF (.woff), WOFF2 (.woff2), Type 1 (.pfb, .pfm).
		- Bitmap font importer: AngelCode BMFont (.fnt, .font), text and binary (version 3) format variants.
		- Monospace image font importer: All supported image formats.
		**Note:** A character is a symbol that represents an item (letter, digit etc.) in an abstract way.
		**Note:** A glyph is a bitmap or a shape used to draw one or more characters in a context-dependent manner. Glyph indices are bound to the specific font data source.
		**Note:** If none of the font data sources contain glyphs for a character used in a string, the character in question will be replaced with a box displaying its hexadecimal code.
		`codeblocks`
		`gdscript`
		var f = load("res://BarlowCondensed-Bold.ttf")
		$Label.add_theme_font_override("font", f)
		$Label.add_theme_font_size_override("font_size", 64)
		
		`csharp`
		var f = ResourceLoader.Load<FontFile>("res://BarlowCondensed-Bold.ttf");
		GetNode("Label").AddThemeFontOverride("font", f);
		GetNode("Label").AddThemeFontSizeOverride("font_size", 64);

## 属性

- **`allow_system_fallback`** `bool` = `true`
  - 其它属性：getter=is_allow_system_fallback · setter=set_allow_system_fallback
- **`antialiasing`** `int` = `1` · 枚举 `TextServer.FontAntialiasing`
  - 其它属性：getter=get_antialiasing · setter=set_antialiasing
- **`data`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_data · setter=set_data
- **`disable_embedded_bitmaps`** `bool` = `true`
  - 其它属性：getter=get_disable_embedded_bitmaps · setter=set_disable_embedded_bitmaps
- **`fixed_size`** `int` = `0`
  - 其它属性：getter=get_fixed_size · setter=set_fixed_size
- **`fixed_size_scale_mode`** `int` = `0` · 枚举 `TextServer.FixedSizeScaleMode`
  - 其它属性：getter=get_fixed_size_scale_mode · setter=set_fixed_size_scale_mode
- **`font_name`** `String` = `""`
  - 其它属性：getter=get_font_name · setter=set_font_name
- **`font_stretch`** `int` = `100`
  - 其它属性：getter=get_font_stretch · setter=set_font_stretch
- **`font_style`** `int` = `0` · 枚举 `TextServer.FontStyle` · 位标志
  - 其它属性：getter=get_font_style · is_bitfield=true · setter=set_font_style
- **`font_weight`** `int` = `400`
  - 其它属性：getter=get_font_weight · setter=set_font_weight
- **`force_autohinter`** `bool` = `false`
  - 其它属性：getter=is_force_autohinter · setter=set_force_autohinter
- **`generate_mipmaps`** `bool` = `false`
  - 其它属性：getter=get_generate_mipmaps · setter=set_generate_mipmaps
- **`hinting`** `int` = `1` · 枚举 `TextServer.Hinting`
  - 其它属性：getter=get_hinting · setter=set_hinting
- **`keep_rounding_remainders`** `bool` = `true`
  - 其它属性：getter=get_keep_rounding_remainders · setter=set_keep_rounding_remainders
- **`modulate_color_glyphs`** `bool` = `false`
  - 其它属性：getter=is_modulate_color_glyphs · setter=set_modulate_color_glyphs
- **`msdf_pixel_range`** `int` = `16`
  - 其它属性：getter=get_msdf_pixel_range · setter=set_msdf_pixel_range
- **`msdf_size`** `int` = `48`
  - 其它属性：getter=get_msdf_size · setter=set_msdf_size
- **`multichannel_signed_distance_field`** `bool` = `false`
  - 其它属性：getter=is_multichannel_signed_distance_field · setter=set_multichannel_signed_distance_field
- **`opentype_feature_overrides`** `Dictionary` = `{}`
  - 其它属性：getter=get_opentype_feature_overrides · setter=set_opentype_feature_overrides
- **`oversampling`** `float` = `0.0`
  - 其它属性：getter=get_oversampling · setter=set_oversampling
- **`style_name`** `String` = `""`
  - 其它属性：getter=get_font_style_name · setter=set_font_style_name
- **`subpixel_positioning`** `int` = `1` · 枚举 `TextServer.SubpixelPositioning`
  - 其它属性：getter=get_subpixel_positioning · setter=set_subpixel_positioning

## 方法

### `clear_cache() -> void`

Removes all font cache entries.

### `clear_glyphs(cache_index: int, size: Vector2i) -> void`

Removes all rendered glyph information from the cache entry.
				**Note:** This function will not remove textures associated with the glyphs, use `remove_texture` to remove them manually.

### `clear_kerning_map(cache_index: int, size: int) -> void`

Removes all kerning overrides.

### `clear_size_cache(cache_index: int) -> void`

Removes all font sizes from the cache entry.

### `clear_textures(cache_index: int, size: Vector2i) -> void`

Removes all textures from font cache entry.
				**Note:** This function will not remove glyphs associated with the texture, use `remove_glyph` to remove them manually.

### `get_cache_ascent(cache_index: int, size: int) -> float`
- 限定：qualifiers=const

Returns the font ascent (number of pixels above the baseline).

### `get_cache_count() -> int`
- 限定：qualifiers=const

Returns number of the font cache entries.

### `get_cache_descent(cache_index: int, size: int) -> float`
- 限定：qualifiers=const

Returns the font descent (number of pixels below the baseline).

### `get_cache_scale(cache_index: int, size: int) -> float`
- 限定：qualifiers=const

Returns scaling factor of the color bitmap font.

### `get_cache_underline_position(cache_index: int, size: int) -> float`
- 限定：qualifiers=const

Returns pixel offset of the underline below the baseline.

### `get_cache_underline_thickness(cache_index: int, size: int) -> float`
- 限定：qualifiers=const

Returns thickness of the underline in pixels.

### `get_char_from_glyph_index(size: int, glyph_index: int) -> int`
- 限定：qualifiers=const

Returns character code associated with `glyph_index`, or `0` if `glyph_index` is invalid. See `get_glyph_index`.

### `get_embolden(cache_index: int) -> float`
- 限定：qualifiers=const

Returns embolden strength, if is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

### `get_extra_baseline_offset(cache_index: int) -> float`
- 限定：qualifiers=const

Returns extra baseline offset (as a fraction of font height).

### `get_extra_spacing(cache_index: int, spacing: int) -> int`
- 限定：qualifiers=const

Returns spacing for `spacing` in pixels (not relative to the font size).

### `get_face_index(cache_index: int) -> int`
- 限定：qualifiers=const

Returns an active face index in the TrueType / OpenType collection.

### `get_glyph_advance(cache_index: int, size: int, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns glyph advance (offset of the next glyph).
				**Note:** Advance for glyphs outlines is the same as the base glyph advance and is not saved.

### `get_glyph_index(size: int, char: int, variation_selector: int) -> int`
- 限定：qualifiers=const

Returns the glyph index of a `char`, optionally modified by the `variation_selector`.

### `get_glyph_list(cache_index: int, size: Vector2i) -> PackedInt32Array`
- 限定：qualifiers=const

Returns list of rendered glyphs in the cache entry.

### `get_glyph_offset(cache_index: int, size: Vector2i, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns glyph offset from the baseline.

### `get_glyph_size(cache_index: int, size: Vector2i, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns glyph size.

### `get_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int) -> int`
- 限定：qualifiers=const

Returns index of the cache texture containing the glyph.

### `get_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int) -> Rect2`
- 限定：qualifiers=const

Returns rectangle in the cache texture containing the glyph.

### `get_kerning(cache_index: int, size: int, glyph_pair: Vector2i) -> Vector2`
- 限定：qualifiers=const

Returns kerning for the pair of glyphs.

### `get_kerning_list(cache_index: int, size: int) -> Vector2i[]`
- 限定：qualifiers=const

Returns list of the kerning overrides.

### `get_language_support_override(language: String) -> bool`
- 限定：qualifiers=const

Returns `true` if support override is enabled for the `language`.

### `get_language_support_overrides() -> PackedStringArray`
- 限定：qualifiers=const

Returns list of language support overrides.

### `get_script_support_override(script: String) -> bool`
- 限定：qualifiers=const

Returns `true` if support override is enabled for the `script`.

### `get_script_support_overrides() -> PackedStringArray`
- 限定：qualifiers=const

Returns list of script support overrides.

### `get_size_cache_list(cache_index: int) -> Vector2i[]`
- 限定：qualifiers=const

Returns list of the font sizes in the cache. Each size is `Vector2i` with font size and outline size.

### `get_texture_count(cache_index: int, size: Vector2i) -> int`
- 限定：qualifiers=const

Returns number of textures used by font cache entry.

### `get_texture_image(cache_index: int, size: Vector2i, texture_index: int) -> Image`
- 限定：qualifiers=const

Returns a copy of the font cache texture image.

### `get_texture_offsets(cache_index: int, size: Vector2i, texture_index: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns a copy of the array containing glyph packing data.

### `get_transform(cache_index: int) -> Transform2D`
- 限定：qualifiers=const

Returns 2D transform, applied to the font outlines, can be used for slanting, flipping and rotating glyphs.

### `get_variation_coordinates(cache_index: int) -> Dictionary`
- 限定：qualifiers=const

Returns variation coordinates for the specified font cache entry. See `Font.get_supported_variation_list` for more info.

### `load_bitmap_font(path: String) -> int`

Loads an AngelCode BMFont (.fnt, .font) bitmap font from file `path`.
				**Warning:** This method should only be used in the editor or in cases when you need to load external fonts at run-time, such as fonts located at the `user://` directory.

### `load_dynamic_font(path: String) -> int`

Loads a TrueType (.ttf), OpenType (.otf), WOFF (.woff), WOFF2 (.woff2) or Type 1 (.pfb, .pfm) dynamic font from file `path`.
				**Warning:** This method should only be used in the editor or in cases when you need to load external fonts at run-time, such as fonts located at the `user://` directory.

### `remove_cache(cache_index: int) -> void`

Removes specified font cache entry.

### `remove_glyph(cache_index: int, size: Vector2i, glyph: int) -> void`

Removes specified rendered glyph information from the cache entry.
				**Note:** This function will not remove textures associated with the glyphs, use `remove_texture` to remove them manually.

### `remove_kerning(cache_index: int, size: int, glyph_pair: Vector2i) -> void`

Removes kerning override for the pair of glyphs.

### `remove_language_support_override(language: String) -> void`

Remove language support override.

### `remove_script_support_override(script: String) -> void`

Removes script support override.

### `remove_size_cache(cache_index: int, size: Vector2i) -> void`

Removes specified font size from the cache entry.

### `remove_texture(cache_index: int, size: Vector2i, texture_index: int) -> void`

Removes specified texture from the cache entry.
				**Note:** This function will not remove glyphs associated with the texture. Remove them manually using `remove_glyph`.

### `render_glyph(cache_index: int, size: Vector2i, index: int) -> void`

Renders specified glyph to the font cache texture.

### `render_range(cache_index: int, size: Vector2i, start: int, end: int) -> void`

Renders the range of characters to the font cache texture.

### `set_cache_ascent(cache_index: int, size: int, ascent: float) -> void`

Sets the font ascent (number of pixels above the baseline).

### `set_cache_descent(cache_index: int, size: int, descent: float) -> void`

Sets the font descent (number of pixels below the baseline).

### `set_cache_scale(cache_index: int, size: int, scale: float) -> void`

Sets scaling factor of the color bitmap font.

### `set_cache_underline_position(cache_index: int, size: int, underline_position: float) -> void`

Sets pixel offset of the underline below the baseline.

### `set_cache_underline_thickness(cache_index: int, size: int, underline_thickness: float) -> void`

Sets thickness of the underline in pixels.

### `set_embolden(cache_index: int, strength: float) -> void`

Sets embolden strength, if is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

### `set_extra_baseline_offset(cache_index: int, baseline_offset: float) -> void`

Sets extra baseline offset (as a fraction of font height).

### `set_extra_spacing(cache_index: int, spacing: int, value: int) -> void`

Sets the spacing for `spacing` to `value` in pixels (not relative to the font size).

### `set_face_index(cache_index: int, face_index: int) -> void`

Sets an active face index in the TrueType / OpenType collection.

### `set_glyph_advance(cache_index: int, size: int, glyph: int, advance: Vector2) -> void`

Sets glyph advance (offset of the next glyph).
				**Note:** Advance for glyphs outlines is the same as the base glyph advance and is not saved.

### `set_glyph_offset(cache_index: int, size: Vector2i, glyph: int, offset: Vector2) -> void`

Sets glyph offset from the baseline.

### `set_glyph_size(cache_index: int, size: Vector2i, glyph: int, gl_size: Vector2) -> void`

Sets glyph size.

### `set_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int, texture_idx: int) -> void`

Sets index of the cache texture containing the glyph.

### `set_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int, uv_rect: Rect2) -> void`

Sets rectangle in the cache texture containing the glyph.

### `set_kerning(cache_index: int, size: int, glyph_pair: Vector2i, kerning: Vector2) -> void`

Sets kerning for the pair of glyphs.

### `set_language_support_override(language: String, supported: bool) -> void`

Adds override for `Font.is_language_supported`.

### `set_script_support_override(script: String, supported: bool) -> void`

Adds override for `Font.is_script_supported`.

### `set_texture_image(cache_index: int, size: Vector2i, texture_index: int, image: Image) -> void`

Sets font cache texture image.

### `set_texture_offsets(cache_index: int, size: Vector2i, texture_index: int, offset: PackedInt32Array) -> void`

Sets array containing glyph packing data.

### `set_transform(cache_index: int, transform: Transform2D) -> void`

Sets 2D transform, applied to the font outlines, can be used for slanting, flipping, and rotating glyphs.

### `set_variation_coordinates(cache_index: int, variation_coordinates: Dictionary) -> void`

Sets variation coordinates for the specified font cache entry. See `Font.get_supported_variation_list` for more info.

## 教程链接

- [Runtime file loading and saving](None)

