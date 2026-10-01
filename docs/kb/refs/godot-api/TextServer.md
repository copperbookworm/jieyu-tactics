# TextServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextServer` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextServer.md`

**摘要**：A server interface for font management and text rendering.

## 描述

`TextServer` is the API backend for managing fonts and rendering text.
		**Note:** This is a low-level API, consider using `TextLine`, `TextParagraph`, and `Font` classes instead.
		This is an abstract class, so to get the currently active `TextServer` instance, use the following code:
		`codeblocks`
		`gdscript`
		var ts = TextServerManager.get_primary_interface()
		
		`csharp`
		var ts = TextServerManager.GetPrimaryInterface();

## 方法

### `create_font() -> RID`

Creates a new, empty font cache entry resource. To free the resulting resource, use the `free_rid` method.

### `create_font_linked_variation(font_rid: RID) -> RID`

Creates a new variation existing font which is reusing the same glyph cache and font data. To free the resulting resource, use the `free_rid` method.

### `create_shaped_text(direction: int = 0, orientation: int = 0) -> RID`

Creates a new buffer for complex text layout, with the given `direction` and `orientation`. To free the resulting buffer, use `free_rid` method.
				**Note:** Direction is ignored if server does not support `FEATURE_BIDI_LAYOUT` feature (supported by `TextServerAdvanced`).
				**Note:** Orientation is ignored if server does not support `FEATURE_VERTICAL_LAYOUT` feature (supported by `TextServerAdvanced`).

### `draw_hex_code_box(canvas: RID, size: int, pos: Vector2, index: int, color: Color) -> void`
- 限定：qualifiers=const

Draws box displaying character hexadecimal code. Used for replacing missing characters.

### `font_clear_glyphs(font_rid: RID, size: Vector2i) -> void`

Removes all rendered glyph information from the cache entry.
				**Note:** This function will not remove textures associated with the glyphs, use `font_remove_texture` to remove them manually.

### `font_clear_kerning_map(font_rid: RID, size: int) -> void`

Removes all kerning overrides.

### `font_clear_size_cache(font_rid: RID) -> void`

Removes all font sizes from the cache entry.

### `font_clear_system_fallback_cache() -> void`

Frees all automatically loaded system fonts.

### `font_clear_textures(font_rid: RID, size: Vector2i) -> void`

Removes all textures from font cache entry.
				**Note:** This function will not remove glyphs associated with the texture, use `font_remove_glyph` to remove them manually.

### `font_draw_glyph(font_rid: RID, canvas: RID, size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws single glyph into a canvas item at the position, using `font_rid` at the size `size`. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.
				**Note:** Glyph index is specific to the font, use glyphs indices returned by `shaped_text_get_glyphs` or `font_get_glyph_index`.
				**Note:** If there are pending glyphs to render, calling this function might trigger the texture cache update.

### `font_draw_glyph_outline(font_rid: RID, canvas: RID, size: int, outline_size: int, pos: Vector2, index: int, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draws single glyph outline of size `outline_size` into a canvas item at the position, using `font_rid` at the size `size`. If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.
				**Note:** Glyph index is specific to the font, use glyphs indices returned by `shaped_text_get_glyphs` or `font_get_glyph_index`.
				**Note:** If there are pending glyphs to render, calling this function might trigger the texture cache update.

### `font_get_antialiasing(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns font anti-aliasing mode.

### `font_get_ascent(font_rid: RID, size: int) -> float`
- 限定：qualifiers=const

Returns the font ascent (number of pixels above the baseline).

### `font_get_baseline_offset(font_rid: RID) -> float`
- 限定：qualifiers=const

Returns extra baseline offset (as a fraction of font height).

### `font_get_char_from_glyph_index(font_rid: RID, size: int, glyph_index: int) -> int`
- 限定：qualifiers=const

Returns character code associated with `glyph_index`, or `0` if `glyph_index` is invalid. See `font_get_glyph_index`.

### `font_get_descent(font_rid: RID, size: int) -> float`
- 限定：qualifiers=const

Returns the font descent (number of pixels below the baseline).

### `font_get_disable_embedded_bitmaps(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns whether the font's embedded bitmap loading is disabled.

### `font_get_embolden(font_rid: RID) -> float`
- 限定：qualifiers=const

Returns font embolden strength.

### `font_get_face_count(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns number of faces in the TrueType / OpenType collection.

### `font_get_face_index(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns an active face index in the TrueType / OpenType collection.

### `font_get_fixed_size(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns bitmap font fixed size.

### `font_get_fixed_size_scale_mode(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns bitmap font scaling mode.

### `font_get_generate_mipmaps(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if font texture mipmap generation is enabled.

### `font_get_global_oversampling() -> float`
- 限定：deprecated=Use [Viewport] oversampling, or the [code skip-lint]oversampling[/code] argument of the [code skip-lint]draw_*[/code] methods instead. · qualifiers=const

This method does nothing and always returns `1.0`.

### `font_get_glyph_advance(font_rid: RID, size: int, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns glyph advance (offset of the next glyph).
				**Note:** Advance for glyphs outlines is the same as the base glyph advance and is not saved.

### `font_get_glyph_contours(font: RID, size: int, index: int) -> Dictionary`
- 限定：qualifiers=const

Returns outline contours of the glyph as a `Dictionary` with the following contents:
				`points`         - `PackedVector3Array`, containing outline points. `x` and `y` are point coordinates. `z` is the type of the point, using the `ContourPointTag` values.
				`contours`       - `PackedInt32Array`, containing indices the end points of each contour.
				`orientation`    - `bool`, contour orientation. If `true`, clockwise contours must be filled.
				- Two successive `CONTOUR_CURVE_TAG_ON` points indicate a line segment.
				- One `CONTOUR_CURVE_TAG_OFF_CONIC` point between two `CONTOUR_CURVE_TAG_ON` points indicates a single conic (quadratic) Bézier arc.
				- Two `CONTOUR_CURVE_TAG_OFF_CUBIC` points between two `CONTOUR_CURVE_TAG_ON` points indicate a single cubic Bézier arc.
				- Two successive `CONTOUR_CURVE_TAG_OFF_CONIC` points indicate two successive conic (quadratic) Bézier arcs with a virtual `CONTOUR_CURVE_TAG_ON` point at their middle.
				- Each contour is closed. The last point of a contour uses the first point of a contour as its next point, and vice versa. The first point can be `CONTOUR_CURVE_TAG_OFF_CONIC` point.

### `font_get_glyph_index(font_rid: RID, size: int, char: int, variation_selector: int) -> int`
- 限定：qualifiers=const

Returns the glyph index of a `char`, optionally modified by the `variation_selector`. See `font_get_char_from_glyph_index`.

### `font_get_glyph_list(font_rid: RID, size: Vector2i) -> PackedInt32Array`
- 限定：qualifiers=const

Returns list of rendered glyphs in the cache entry.

### `font_get_glyph_offset(font_rid: RID, size: Vector2i, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns glyph offset from the baseline.

### `font_get_glyph_size(font_rid: RID, size: Vector2i, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns size of the glyph.

### `font_get_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int) -> int`
- 限定：qualifiers=const

Returns index of the cache texture containing the glyph.

### `font_get_glyph_texture_rid(font_rid: RID, size: Vector2i, glyph: int) -> RID`
- 限定：qualifiers=const

Returns resource ID of the cache texture containing the glyph.
				**Note:** If there are pending glyphs to render, calling this function might trigger the texture cache update.

### `font_get_glyph_texture_size(font_rid: RID, size: Vector2i, glyph: int) -> Vector2`
- 限定：qualifiers=const

Returns size of the cache texture containing the glyph.
				**Note:** If there are pending glyphs to render, calling this function might trigger the texture cache update.

### `font_get_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int) -> Rect2`
- 限定：qualifiers=const

Returns rectangle in the cache texture containing the glyph.

### `font_get_hinting(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns the font hinting mode. Used by dynamic fonts only.

### `font_get_keep_rounding_remainders(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns glyph position rounding behavior. If set to `true`, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

### `font_get_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) -> Vector2`
- 限定：qualifiers=const

Returns kerning for the pair of glyphs.

### `font_get_kerning_list(font_rid: RID, size: int) -> Vector2i[]`
- 限定：qualifiers=const

Returns list of the kerning overrides.

### `font_get_language_support_override(font_rid: RID, language: String) -> bool`

Returns `true` if support override is enabled for the `language`.

### `font_get_language_support_overrides(font_rid: RID) -> PackedStringArray`

Returns list of language support overrides.

### `font_get_msdf_pixel_range(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns the width of the range around the shape between the minimum and maximum representable signed distance.

### `font_get_msdf_size(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns source font size used to generate MSDF textures.

### `font_get_name(font_rid: RID) -> String`
- 限定：qualifiers=const

Returns font family name.

### `font_get_opentype_feature_overrides(font_rid: RID) -> Dictionary`
- 限定：qualifiers=const

Returns font OpenType feature set override.

### `font_get_ot_name_strings(font_rid: RID) -> Dictionary`
- 限定：qualifiers=const

Returns `Dictionary` with OpenType font name strings (localized font names, version, description, license information, sample text, etc.).

### `font_get_oversampling(font_rid: RID) -> float`
- 限定：qualifiers=const

Returns oversampling factor override. If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See `Viewport.oversampling`. This value doesn't override the `skip-lint`oversampling parameter of `skip-lint`draw_* methods. Used by dynamic fonts only.

### `font_get_palette_colors(font_rid: RID, index: int) -> PackedColorArray`
- 限定：qualifiers=const

Returns the array in the predefined color palette at `index`. Palette contains all colors used to render font glyphs. Each palette has the same number of colors. Colors can be overridden using `font_set_palette_custom_colors`.

### `font_get_palette_count(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns the number of predefined color palettes. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

### `font_get_palette_custom_colors(font_rid: RID) -> PackedColorArray`
- 限定：qualifiers=const

Returns array of custom colors to override predefined palette.

### `font_get_palette_name(font_rid: RID, index: int) -> String`
- 限定：qualifiers=const

Returns the name of the predefined color palette at `index`. Palette contains all colors used to render font glyphs. Each palette has the same number of colors.

### `font_get_scale(font_rid: RID, size: int) -> float`
- 限定：qualifiers=const

Returns scaling factor of the color bitmap font.

### `font_get_script_support_override(font_rid: RID, script: String) -> bool`

Returns `true` if support override is enabled for the `script`.

### `font_get_script_support_overrides(font_rid: RID) -> PackedStringArray`

Returns list of script support overrides.

### `font_get_size_cache_info(font_rid: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns font cache information, each entry contains the following fields: `Vector2i size_px` - font size in pixels, `float viewport_oversampling` - viewport oversampling factor, `int glyphs` - number of rendered glyphs, `int textures` - number of used textures, `int textures_size` - size of texture data in bytes.

### `font_get_size_cache_list(font_rid: RID) -> Vector2i[]`
- 限定：qualifiers=const

Returns list of the font sizes in the cache. Each size is `Vector2i` with font size and outline size.

### `font_get_spacing(font_rid: RID, spacing: int) -> int`
- 限定：qualifiers=const

Returns the spacing for `spacing` in pixels (not relative to the font size).

### `font_get_stretch(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns font stretch amount, compared to a normal width. A percentage value between `50%` and `200%`.

### `font_get_style(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns font style flags.

### `font_get_style_name(font_rid: RID) -> String`
- 限定：qualifiers=const

Returns font style name.

### `font_get_subpixel_positioning(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns font subpixel glyph positioning mode.

### `font_get_supported_chars(font_rid: RID) -> String`
- 限定：qualifiers=const

Returns a string containing all the characters available in the font.

### `font_get_supported_glyphs(font_rid: RID) -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array containing all glyph indices in the font.

### `font_get_texture_count(font_rid: RID, size: Vector2i) -> int`
- 限定：qualifiers=const

Returns number of textures used by font cache entry.

### `font_get_texture_image(font_rid: RID, size: Vector2i, texture_index: int) -> Image`
- 限定：qualifiers=const

Returns font cache texture image data.

### `font_get_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int) -> PackedInt32Array`
- 限定：qualifiers=const

Returns array containing glyph packing data.

### `font_get_transform(font_rid: RID) -> Transform2D`
- 限定：qualifiers=const

Returns 2D transform applied to the font outlines.

### `font_get_underline_position(font_rid: RID, size: int) -> float`
- 限定：qualifiers=const

Returns pixel offset of the underline below the baseline.

### `font_get_underline_thickness(font_rid: RID, size: int) -> float`
- 限定：qualifiers=const

Returns thickness of the underline in pixels.

### `font_get_used_palette(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns used palette index.

### `font_get_variation_coordinates(font_rid: RID) -> Dictionary`
- 限定：qualifiers=const

Returns variation coordinates for the specified font cache entry. See `font_supported_variation_list` for more info.

### `font_get_weight(font_rid: RID) -> int`
- 限定：qualifiers=const

Returns weight (boldness) of the font. A value in the `100...999` range, normal font weight is `400`, bold font weight is `700`.

### `font_has_char(font_rid: RID, char: int) -> bool`
- 限定：qualifiers=const

Returns `true` if a Unicode `char` is available in the font.

### `font_is_allow_system_fallback(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if system fonts can be automatically used as fallbacks.

### `font_is_force_autohinter(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if auto-hinting is supported and preferred over font built-in hinting. Used by dynamic fonts only.

### `font_is_language_supported(font_rid: RID, language: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the font supports the given language (as a ISO 639 (https://en.wikipedia.org/wiki/ISO_639-1) code).

### `font_is_modulate_color_glyphs(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if color modulation is applied when drawing the font's colored glyphs.

### `font_is_multichannel_signed_distance_field(font_rid: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data.

### `font_is_script_supported(font_rid: RID, script: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the font supports the given script (as a ISO 15924 (https://en.wikipedia.org/wiki/ISO_15924) code).

### `font_remove_glyph(font_rid: RID, size: Vector2i, glyph: int) -> void`

Removes specified rendered glyph information from the cache entry.
				**Note:** This function will not remove textures associated with the glyphs, use `font_remove_texture` to remove them manually.

### `font_remove_kerning(font_rid: RID, size: int, glyph_pair: Vector2i) -> void`

Removes kerning override for the pair of glyphs.

### `font_remove_language_support_override(font_rid: RID, language: String) -> void`

Remove language support override.

### `font_remove_script_support_override(font_rid: RID, script: String) -> void`

Removes script support override.

### `font_remove_size_cache(font_rid: RID, size: Vector2i) -> void`

Removes specified font size from the cache entry.

### `font_remove_texture(font_rid: RID, size: Vector2i, texture_index: int) -> void`

Removes specified texture from the cache entry.
				**Note:** This function will not remove glyphs associated with the texture, remove them manually, using `font_remove_glyph`.

### `font_render_glyph(font_rid: RID, size: Vector2i, index: int) -> void`

Renders specified glyph to the font cache texture.

### `font_render_range(font_rid: RID, size: Vector2i, start: int, end: int) -> void`

Renders the range of characters to the font cache texture.

### `font_set_allow_system_fallback(font_rid: RID, allow_system_fallback: bool) -> void`

If set to `true`, system fonts can be automatically used as fallbacks.

### `font_set_antialiasing(font_rid: RID, antialiasing: int) -> void`

Sets font anti-aliasing mode.

### `font_set_ascent(font_rid: RID, size: int, ascent: float) -> void`

Sets the font ascent (number of pixels above the baseline).

### `font_set_baseline_offset(font_rid: RID, baseline_offset: float) -> void`

Sets extra baseline offset (as a fraction of font height).

### `font_set_data(font_rid: RID, data: PackedByteArray) -> void`

Sets font source data, e.g contents of the dynamic font source file.

### `font_set_descent(font_rid: RID, size: int, descent: float) -> void`

Sets the font descent (number of pixels below the baseline).

### `font_set_disable_embedded_bitmaps(font_rid: RID, disable_embedded_bitmaps: bool) -> void`

If set to `true`, embedded font bitmap loading is disabled (bitmap-only and color fonts ignore this property).

### `font_set_embolden(font_rid: RID, strength: float) -> void`

Sets font embolden strength. If `strength` is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

### `font_set_face_index(font_rid: RID, face_index: int) -> void`

Sets an active face index in the TrueType / OpenType collection.

### `font_set_fixed_size(font_rid: RID, fixed_size: int) -> void`

Sets bitmap font fixed size. If set to value greater than zero, same cache entry will be used for all font sizes.

### `font_set_fixed_size_scale_mode(font_rid: RID, fixed_size_scale_mode: int) -> void`

Sets bitmap font scaling mode. This property is used only if `fixed_size` is greater than zero.

### `font_set_force_autohinter(font_rid: RID, force_autohinter: bool) -> void`

If set to `true` auto-hinting is preferred over font built-in hinting.

### `font_set_generate_mipmaps(font_rid: RID, generate_mipmaps: bool) -> void`

If set to `true` font texture mipmap generation is enabled.

### `font_set_global_oversampling(oversampling: float) -> void`
- 限定：deprecated=Use [Viewport] oversampling, or the [code skip-lint]oversampling[/code] argument of the [code skip-lint]draw_*[/code] methods instead.

This method does nothing.

### `font_set_glyph_advance(font_rid: RID, size: int, glyph: int, advance: Vector2) -> void`

Sets glyph advance (offset of the next glyph).
				**Note:** Advance for glyphs outlines is the same as the base glyph advance and is not saved.

### `font_set_glyph_offset(font_rid: RID, size: Vector2i, glyph: int, offset: Vector2) -> void`

Sets glyph offset from the baseline.

### `font_set_glyph_size(font_rid: RID, size: Vector2i, glyph: int, gl_size: Vector2) -> void`

Sets size of the glyph.

### `font_set_glyph_texture_idx(font_rid: RID, size: Vector2i, glyph: int, texture_idx: int) -> void`

Sets index of the cache texture containing the glyph.

### `font_set_glyph_uv_rect(font_rid: RID, size: Vector2i, glyph: int, uv_rect: Rect2) -> void`

Sets rectangle in the cache texture containing the glyph.

### `font_set_hinting(font_rid: RID, hinting: int) -> void`

Sets font hinting mode. Used by dynamic fonts only.

### `font_set_keep_rounding_remainders(font_rid: RID, keep_rounding_remainders: bool) -> void`

Sets glyph position rounding behavior. If set to `true`, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

### `font_set_kerning(font_rid: RID, size: int, glyph_pair: Vector2i, kerning: Vector2) -> void`

Sets kerning for the pair of glyphs.

### `font_set_language_support_override(font_rid: RID, language: String, supported: bool) -> void`

Adds override for `font_is_language_supported`.

### `font_set_modulate_color_glyphs(font_rid: RID, modulate: bool) -> void`

If set to `true`, color modulation is applied when drawing colored glyphs, otherwise it's applied to the monochrome glyphs only.

### `font_set_msdf_pixel_range(font_rid: RID, msdf_pixel_range: int) -> void`

Sets the width of the range around the shape between the minimum and maximum representable signed distance.

### `font_set_msdf_size(font_rid: RID, msdf_size: int) -> void`

Sets source font size used to generate MSDF textures.

### `font_set_multichannel_signed_distance_field(font_rid: RID, msdf: bool) -> void`

If set to `true`, glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data. MSDF rendering allows displaying the font at any scaling factor without blurriness, and without incurring a CPU cost when the font size changes (since the font no longer needs to be rasterized on the CPU). As a downside, font hinting is not available with MSDF. The lack of font hinting may result in less crisp and less readable fonts at small sizes.
				**Note:** MSDF font rendering does not render glyphs with overlapping shapes correctly. Overlapping shapes are not valid per the OpenType standard, but are still commonly found in many font files, especially those converted by Google Fonts. To avoid issues with overlapping glyphs, consider downloading the font file directly from the type foundry instead of relying on Google Fonts.

### `font_set_name(font_rid: RID, name: String) -> void`

Sets the font family name.

### `font_set_opentype_feature_overrides(font_rid: RID, overrides: Dictionary) -> void`

Sets font OpenType feature set override.

### `font_set_oversampling(font_rid: RID, oversampling: float) -> void`

If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See `Viewport.oversampling`. This value doesn't override the `skip-lint`oversampling parameter of `skip-lint`draw_* methods. Used by dynamic fonts only.

### `font_set_palette_custom_colors(font_rid: RID, colors: PackedColorArray) -> void`

Sets array of custom colors to override predefined palette. Set to empty array to reset overrides. Use `Color(0, 0, 0, 0)`, to keep predefined palette color at specific position.

### `font_set_scale(font_rid: RID, size: int, scale: float) -> void`

Sets scaling factor of the color bitmap font.

### `font_set_script_support_override(font_rid: RID, script: String, supported: bool) -> void`

Adds override for `font_is_script_supported`.

### `font_set_spacing(font_rid: RID, spacing: int, value: int) -> void`

Sets the spacing for `spacing` to `value` in pixels (not relative to the font size).

### `font_set_stretch(font_rid: RID, weight: int) -> void`

Sets font stretch amount, compared to a normal width. A percentage value between `50%` and `200%`.
				**Note:** This value is used for font matching only and will not affect font rendering. Use `font_set_face_index`, `font_set_variation_coordinates`, or `font_set_transform` instead.

### `font_set_style(font_rid: RID, style: int) -> void`

Sets the font style flags.
				**Note:** This value is used for font matching only and will not affect font rendering. Use `font_set_face_index`, `font_set_variation_coordinates`, `font_set_embolden`, or `font_set_transform` instead.

### `font_set_style_name(font_rid: RID, name: String) -> void`

Sets the font style name.

### `font_set_subpixel_positioning(font_rid: RID, subpixel_positioning: int) -> void`

Sets font subpixel glyph positioning mode.

### `font_set_texture_image(font_rid: RID, size: Vector2i, texture_index: int, image: Image) -> void`

Sets font cache texture image data.

### `font_set_texture_offsets(font_rid: RID, size: Vector2i, texture_index: int, offset: PackedInt32Array) -> void`

Sets array containing glyph packing data.

### `font_set_transform(font_rid: RID, transform: Transform2D) -> void`

Sets 2D transform, applied to the font outlines, can be used for slanting, flipping, and rotating glyphs.
				For example, to simulate italic typeface by slanting, apply the following transform `Transform2D(1.0, slant, 0.0, 1.0, 0.0, 0.0)`.

### `font_set_underline_position(font_rid: RID, size: int, underline_position: float) -> void`

Sets pixel offset of the underline below the baseline.

### `font_set_underline_thickness(font_rid: RID, size: int, underline_thickness: float) -> void`

Sets thickness of the underline in pixels.

### `font_set_used_palette(font_rid: RID, index: int) -> void`

Sets used palette index.

### `font_set_variation_coordinates(font_rid: RID, variation_coordinates: Dictionary) -> void`

Sets variation coordinates for the specified font cache entry. See `font_supported_variation_list` for more info.

### `font_set_weight(font_rid: RID, weight: int) -> void`

Sets weight (boldness) of the font. A value in the `100...999` range, normal font weight is `400`, bold font weight is `700`.
				**Note:** This value is used for font matching only and will not affect font rendering. Use `font_set_face_index`, `font_set_variation_coordinates`, or `font_set_embolden` instead.

### `font_supported_feature_list(font_rid: RID) -> Dictionary`
- 限定：qualifiers=const

Returns the dictionary of the supported OpenType features.

### `font_supported_variation_list(font_rid: RID) -> Dictionary`
- 限定：qualifiers=const

Returns the dictionary of the supported OpenType variation coordinates.

### `format_number(number: String, language: String = "") -> String`
- 限定：deprecated=Use [method TranslationServer.format_number] instead. · qualifiers=const

Converts a number from Western Arabic (0..9) to the numeral system used in the given `language`.
				If `language` is an empty string, the active locale will be used.

### `free_rid(rid: RID) -> void`

Frees an object created by this `TextServer`.

### `get_features() -> int`
- 限定：qualifiers=const

Returns text server features, see `Feature`.

### `get_hex_code_box_size(size: int, index: int) -> Vector2`
- 限定：qualifiers=const

Returns size of the replacement character (box with character hexadecimal code that is drawn in place of invalid characters).

### `get_name() -> String`
- 限定：qualifiers=const

Returns the name of the server interface.

### `get_support_data() -> PackedByteArray`
- 限定：qualifiers=const

Returns default TextServer database (e.g. ICU break iterators and dictionaries).

### `get_support_data_filename() -> String`
- 限定：qualifiers=const

Returns default TextServer database (e.g. ICU break iterators and dictionaries) filename.

### `get_support_data_info() -> String`
- 限定：qualifiers=const

Returns TextServer database (e.g. ICU break iterators and dictionaries) description.

### `has(rid: RID) -> bool`

Returns `true` if `rid` is valid resource owned by this text server.

### `has_feature(feature: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the server supports a feature.

### `is_confusable(string: String, dict: PackedStringArray) -> int`
- 限定：qualifiers=const

Returns index of the first string in `dict` which is visually confusable with the `string`, or `-1` if none is found.
				**Note:** This method doesn't detect invisible characters, for spoof detection use it in combination with `spoof_check`.
				**Note:** Always returns `-1` if the server does not support the `FEATURE_UNICODE_SECURITY` feature.

### `is_locale_right_to_left(locale: String) -> bool`
- 限定：qualifiers=const

Returns `true` if locale is right-to-left.

### `is_locale_using_support_data(locale: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the locale requires text server support data for line/word breaking.

### `is_valid_identifier(string: String) -> bool`
- 限定：qualifiers=const

Returns `true` if `string` is a valid identifier.
				If the text server supports the `FEATURE_UNICODE_IDENTIFIERS` feature, a valid identifier must:
				- Conform to normalization form C.
				- Begin with a Unicode character of class XID_Start or `"_"`.
				- May contain Unicode characters of class XID_Continue in the other positions.
				- Use UAX #31 recommended scripts only (mixed scripts are allowed).
				If the `FEATURE_UNICODE_IDENTIFIERS` feature is not supported, a valid identifier must:
				- Begin with a Unicode character of class XID_Start or `"_"`.
				- May contain Unicode characters of class XID_Continue in the other positions.

### `is_valid_letter(unicode: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the given code point is a valid letter, i.e. it belongs to the Unicode category "L".

### `load_support_data(filename: String) -> bool`

Loads optional TextServer database (e.g. ICU break iterators and dictionaries).
				**Note:** This function should be called before any other TextServer functions used, otherwise it won't have any effect.

### `name_to_tag(name: String) -> int`
- 限定：qualifiers=const

Converts the given readable name of a feature, variation, script, or language to an OpenType tag.

### `parse_number(number: String, language: String = "") -> String`
- 限定：deprecated=Use [method TranslationServer.parse_number] instead. · qualifiers=const

Converts `number` from the numeral system used in the given `language` to Western Arabic (0..9).
				If `language` is an empty string, the active locale will be used.

### `parse_structured_text(parser_type: int, args: Array, text: String) -> Vector3i[]`
- 限定：qualifiers=const

Default implementation of the BiDi algorithm override function.

### `percent_sign(language: String = "") -> String`
- 限定：deprecated=Use [method TranslationServer.get_percent_sign] instead. · qualifiers=const

Returns the percent sign used in the given `language`.
				If `language` is an empty string, the active locale will be used.

### `save_support_data(filename: String) -> bool`
- 限定：qualifiers=const

Saves optional TextServer database (e.g. ICU break iterators and dictionaries) to the file.
				**Note:** This function is used by during project export, to include TextServer database.

### `shaped_get_run_count(shaped: RID) -> int`
- 限定：qualifiers=const

Returns the number of uniform text runs in the buffer.

### `shaped_get_run_direction(shaped: RID, index: int) -> int`
- 限定：qualifiers=const

Returns the direction of the `index` text run (in visual order).

### `shaped_get_run_font_rid(shaped: RID, index: int) -> RID`
- 限定：qualifiers=const

Returns the font RID of the `index` text run (in visual order).

### `shaped_get_run_font_size(shaped: RID, index: int) -> int`
- 限定：qualifiers=const

Returns the font size of the `index` text run (in visual order).

### `shaped_get_run_glyph_range(shaped: RID, index: int) -> Vector2i`
- 限定：qualifiers=const

Returns the glyph range of the `index` text run (in visual order).

### `shaped_get_run_language(shaped: RID, index: int) -> String`
- 限定：qualifiers=const

Returns the language of the `index` text run (in visual order).

### `shaped_get_run_object(shaped: RID, index: int) -> Variant`
- 限定：qualifiers=const

Returns the embedded object of the `index` text run (in visual order).

### `shaped_get_run_range(shaped: RID, index: int) -> Vector2i`
- 限定：qualifiers=const

Returns the source text range of the `index` text run (in visual order).

### `shaped_get_run_text(shaped: RID, index: int) -> String`
- 限定：qualifiers=const

Returns the source text of the `index` text run (in visual order).

### `shaped_get_span_count(shaped: RID) -> int`
- 限定：qualifiers=const

Returns number of text spans added using `shaped_text_add_string` or `shaped_text_add_object`.

### `shaped_get_span_embedded_object(shaped: RID, index: int) -> Variant`
- 限定：qualifiers=const

Returns text embedded object key.

### `shaped_get_span_meta(shaped: RID, index: int) -> Variant`
- 限定：qualifiers=const

Returns text span metadata.

### `shaped_get_span_object(shaped: RID, index: int) -> Variant`
- 限定：qualifiers=const

Returns the text span embedded object key.

### `shaped_get_span_text(shaped: RID, index: int) -> String`
- 限定：qualifiers=const

Returns the text span source text.

### `shaped_get_text(shaped: RID) -> String`
- 限定：qualifiers=const

Returns the text buffer source text, including object replacement characters.

### `shaped_set_span_update_font(shaped: RID, index: int, fonts: RID[], size: int, opentype_features: Dictionary = {}) -> void`

Changes text span font, font size, and OpenType features, without changing the text.

### `shaped_text_add_object(shaped: RID, key: Variant, size: Vector2, inline_align: int = 5, length: int = 1, baseline: float = 0.0) -> bool`

Adds inline object to the text buffer, `key` must be unique. In the text, object is represented as `length` object replacement characters.

### `shaped_text_add_string(shaped: RID, text: String, fonts: RID[], size: int, opentype_features: Dictionary = {}, language: String = "", meta: Variant = null) -> bool`

Adds text span and font to draw it to the text buffer.

### `shaped_text_clear(rid: RID) -> void`

Clears text buffer (removes text and inline objects).

### `shaped_text_closest_character_pos(shaped: RID, pos: int) -> int`
- 限定：qualifiers=const

Returns composite character position closest to the `pos`.

### `shaped_text_draw(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw shaped text into a canvas item at a given position, with `color`. `pos` specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.
				`clip_l` and `clip_r` are offsets relative to `pos`, going to the right in horizontal layout and downward in vertical layout. If `clip_l` is not negative, glyphs starting before the offset are clipped. If `clip_r` is not negative, glyphs ending after the offset are clipped.

### `shaped_text_draw_outline(shaped: RID, canvas: RID, pos: Vector2, clip_l: float = -1, clip_r: float = -1, outline_size: int = 1, color: Color = Color(1, 1, 1, 1), oversampling: float = 0.0) -> void`
- 限定：qualifiers=const

Draw the outline of the shaped text into a canvas item at a given position, with `color`. `pos` specifies the leftmost point of the baseline (for horizontal layout) or topmost point of the baseline (for vertical layout). If `oversampling` is greater than zero, it is used as font oversampling factor, otherwise viewport oversampling settings are used.
				`clip_l` and `clip_r` are offsets relative to `pos`, going to the right in horizontal layout and downward in vertical layout. If `clip_l` is not negative, glyphs starting before the offset are clipped. If `clip_r` is not negative, glyphs ending after the offset are clipped.

### `shaped_text_duplicate(rid: RID) -> RID`

Duplicates shaped text buffer.

### `shaped_text_fit_to_width(shaped: RID, width: float, justification_flags: int = 3) -> float`

Adjusts text width to fit to specified width, returns new text width.

### `shaped_text_get_ascent(shaped: RID) -> float`
- 限定：qualifiers=const

Returns the text ascent (number of pixels above the baseline for horizontal layout or to the left of baseline for vertical).
				**Note:** Overall ascent can be higher than font ascent, if some glyphs are displaced from the baseline.

### `shaped_text_get_carets(shaped: RID, position: int) -> Dictionary`
- 限定：qualifiers=const

Returns shapes of the carets corresponding to the character offset `position` in the text. Returned caret shape is 1 pixel wide rectangle.

### `shaped_text_get_character_breaks(shaped: RID) -> PackedInt32Array`
- 限定：qualifiers=const

Returns array of the composite character boundaries.

### `shaped_text_get_custom_ellipsis(shaped: RID) -> int`
- 限定：qualifiers=const

Returns ellipsis character used for text clipping.

### `shaped_text_get_custom_punctuation(shaped: RID) -> String`
- 限定：qualifiers=const

Returns custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

### `shaped_text_get_descent(shaped: RID) -> float`
- 限定：qualifiers=const

Returns the text descent (number of pixels below the baseline for horizontal layout or to the right of baseline for vertical).
				**Note:** Overall descent can be higher than font descent, if some glyphs are displaced from the baseline.

### `shaped_text_get_direction(shaped: RID) -> int`
- 限定：qualifiers=const

Returns direction of the text.

### `shaped_text_get_dominant_direction_in_range(shaped: RID, start: int, end: int) -> int`
- 限定：qualifiers=const

Returns dominant direction of in the range of text.

### `shaped_text_get_ellipsis_glyph_count(shaped: RID) -> int`
- 限定：qualifiers=const

Returns number of glyphs in the ellipsis.

### `shaped_text_get_ellipsis_glyphs(shaped: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns array of the glyphs in the ellipsis.

### `shaped_text_get_ellipsis_pos(shaped: RID) -> int`
- 限定：qualifiers=const

Returns position of the ellipsis.

### `shaped_text_get_glyph_count(shaped: RID) -> int`
- 限定：qualifiers=const

Returns number of glyphs in the buffer.

### `shaped_text_get_glyphs(shaped: RID) -> Dictionary[]`
- 限定：qualifiers=const

Returns an array of glyphs in the visual order.

### `shaped_text_get_grapheme_bounds(shaped: RID, pos: int) -> Vector2`
- 限定：qualifiers=const

Returns composite character's bounds as offsets from the start of the line.

### `shaped_text_get_inferred_direction(shaped: RID) -> int`
- 限定：qualifiers=const

Returns direction of the text, inferred by the BiDi algorithm.

### `shaped_text_get_line_breaks(shaped: RID, width: float, start: int = 0, break_flags: int = 3) -> PackedInt32Array`
- 限定：qualifiers=const

Breaks text to the lines and returns character ranges for each line.

### `shaped_text_get_line_breaks_adv(shaped: RID, width: PackedFloat32Array, start: int = 0, once: bool = true, break_flags: int = 3) -> PackedInt32Array`
- 限定：qualifiers=const

Breaks text to the lines and columns. Returns character ranges for each segment.

### `shaped_text_get_object_glyph(shaped: RID, key: Variant) -> int`
- 限定：qualifiers=const

Returns the glyph index of the inline object.

### `shaped_text_get_object_range(shaped: RID, key: Variant) -> Vector2i`
- 限定：qualifiers=const

Returns the character range of the inline object.

### `shaped_text_get_object_rect(shaped: RID, key: Variant) -> Rect2`
- 限定：qualifiers=const

Returns bounding rectangle of the inline object.

### `shaped_text_get_objects(shaped: RID) -> Array`
- 限定：qualifiers=const

Returns array of inline objects.

### `shaped_text_get_orientation(shaped: RID) -> int`
- 限定：qualifiers=const

Returns text orientation.

### `shaped_text_get_parent(shaped: RID) -> RID`
- 限定：qualifiers=const

Returns the parent buffer from which the substring originates.

### `shaped_text_get_preserve_control(shaped: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if text buffer is configured to display control characters.

### `shaped_text_get_preserve_invalid(shaped: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if text buffer is configured to display hexadecimal codes in place of invalid characters.
				**Note:** If set to `false`, nothing is displayed in place of invalid characters.

### `shaped_text_get_range(shaped: RID) -> Vector2i`
- 限定：qualifiers=const

Returns substring buffer character range in the parent buffer.

### `shaped_text_get_selection(shaped: RID, start: int, end: int) -> PackedVector2Array`
- 限定：qualifiers=const

Returns selection rectangles for the specified character range.

### `shaped_text_get_size(shaped: RID) -> Vector2`
- 限定：qualifiers=const

Returns size of the text.

### `shaped_text_get_spacing(shaped: RID, spacing: int) -> int`
- 限定：qualifiers=const

Returns extra spacing added between glyphs or lines in pixels.

### `shaped_text_get_trim_pos(shaped: RID) -> int`
- 限定：qualifiers=const

Returns the position of the overrun trim.

### `shaped_text_get_underline_position(shaped: RID) -> float`
- 限定：qualifiers=const

Returns pixel offset of the underline below the baseline.

### `shaped_text_get_underline_thickness(shaped: RID) -> float`
- 限定：qualifiers=const

Returns thickness of the underline.

### `shaped_text_get_width(shaped: RID) -> float`
- 限定：qualifiers=const

Returns width (for horizontal layout) or height (for vertical) of the text.

### `shaped_text_get_word_breaks(shaped: RID, grapheme_flags: int = 264, skip_grapheme_flags: int = 4) -> PackedInt32Array`
- 限定：qualifiers=const

Breaks text into words and returns array of character ranges. Use `grapheme_flags` to set what characters are used for breaking.

### `shaped_text_has_object(shaped: RID, key: Variant) -> bool`
- 限定：qualifiers=const

Returns `true` if an object with `key` is embedded in this shaped text buffer.

### `shaped_text_has_visible_chars(shaped: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if text buffer contains any visible characters.

### `shaped_text_hit_test_grapheme(shaped: RID, coords: float) -> int`
- 限定：qualifiers=const

Returns grapheme index at the specified pixel offset at the baseline, or `-1` if none is found.

### `shaped_text_hit_test_position(shaped: RID, coords: float) -> int`
- 限定：qualifiers=const

Returns caret character offset at the specified pixel offset at the baseline. This function always returns a valid position.

### `shaped_text_is_ready(shaped: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if buffer is successfully shaped.

### `shaped_text_next_character_pos(shaped: RID, pos: int) -> int`
- 限定：qualifiers=const

Returns composite character end position closest to the `pos`.

### `shaped_text_next_grapheme_pos(shaped: RID, pos: int) -> int`
- 限定：qualifiers=const

Returns grapheme end position closest to the `pos`.

### `shaped_text_overrun_trim_to_width(shaped: RID, width: float = 0, overrun_trim_flags: int = 0) -> void`

Trims text if it exceeds the given width.

### `shaped_text_prev_character_pos(shaped: RID, pos: int) -> int`
- 限定：qualifiers=const

Returns composite character start position closest to the `pos`.

### `shaped_text_prev_grapheme_pos(shaped: RID, pos: int) -> int`
- 限定：qualifiers=const

Returns grapheme start position closest to the `pos`.

### `shaped_text_resize_object(shaped: RID, key: Variant, size: Vector2, inline_align: int = 5, baseline: float = 0.0) -> bool`

Sets new size and alignment of embedded object.

### `shaped_text_set_bidi_override(shaped: RID, override: Array) -> void`

Overrides BiDi for the structured text.
				Override ranges should cover full source text without overlaps. BiDi algorithm will be used on each range separately.

### `shaped_text_set_custom_ellipsis(shaped: RID, char: int) -> void`

Sets ellipsis character used for text clipping.

### `shaped_text_set_custom_punctuation(shaped: RID, punct: String) -> void`

Sets custom punctuation character list, used for word breaking. If set to empty string, server defaults are used.

### `shaped_text_set_direction(shaped: RID, direction: int = 0) -> void`

Sets desired text direction. If set to `DIRECTION_AUTO`, direction will be detected based on the buffer contents and current locale.
				**Note:** Direction is ignored if server does not support `FEATURE_BIDI_LAYOUT` feature (supported by `TextServerAdvanced`).

### `shaped_text_set_orientation(shaped: RID, orientation: int = 0) -> void`

Sets desired text orientation.
				**Note:** Orientation is ignored if server does not support `FEATURE_VERTICAL_LAYOUT` feature (supported by `TextServerAdvanced`).

### `shaped_text_set_preserve_control(shaped: RID, enabled: bool) -> void`

If set to `true` text buffer will display control characters.

### `shaped_text_set_preserve_invalid(shaped: RID, enabled: bool) -> void`

If set to `true` text buffer will display invalid characters as hexadecimal codes, otherwise nothing is displayed.

### `shaped_text_set_spacing(shaped: RID, spacing: int, value: int) -> void`

Sets extra spacing added between glyphs or lines in pixels.

### `shaped_text_shape(shaped: RID) -> bool`

Shapes buffer if it's not shaped. Returns `true` if the string is shaped successfully.
				**Note:** It is not necessary to call this function manually, buffer will be shaped automatically as soon as any of its output data is requested.

### `shaped_text_sort_logical(shaped: RID) -> Dictionary[]`

Returns text glyphs in the logical order.

### `shaped_text_substr(shaped: RID, start: int, length: int) -> RID`
- 限定：qualifiers=const

Returns text buffer for the substring of the text in the `shaped` text buffer (including inline objects).

### `shaped_text_tab_align(shaped: RID, tab_stops: PackedFloat32Array) -> float`

Aligns shaped text to the given tab-stops.

### `spoof_check(string: String) -> bool`
- 限定：qualifiers=const

Returns `true` if `string` is likely to be an attempt at confusing the reader.
				**Note:** Always returns `false` if the server does not support the `FEATURE_UNICODE_SECURITY` feature.

### `string_get_character_breaks(string: String, language: String = "") -> PackedInt32Array`
- 限定：qualifiers=const

Returns array of the composite character boundaries.
				
```gdscript
				var ts = TextServerManager.get_primary_interface()
				print(ts.string_get_character_breaks("Test ❤️‍🔥 Test")) # Prints [1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14]
				
```

### `string_get_word_breaks(string: String, language: String = "", chars_per_line: int = 0) -> PackedInt32Array`
- 限定：qualifiers=const

Returns an array of the word break boundaries. Elements in the returned array are the offsets of the start and end of words. Therefore the length of the array is always even.
				When `chars_per_line` is greater than zero, line break boundaries are returned instead.
				
```gdscript
				var ts = TextServerManager.get_primary_interface()
				# Corresponds to the substrings "The", "Godot", "Engine", and "4".
				print(ts.string_get_word_breaks("The Godot Engine, 4")) # Prints [0, 3, 4, 9, 10, 16, 18, 19]
				# Corresponds to the substrings "The", "Godot", "Engin", and "e, 4".
				print(ts.string_get_word_breaks("The Godot Engine, 4", "en", 5)) # Prints [0, 3, 4, 9, 10, 15, 15, 19]
				# Corresponds to the substrings "The Godot" and "Engine, 4".
				print(ts.string_get_word_breaks("The Godot Engine, 4", "en", 10)) # Prints [0, 9, 10, 19]
				
```

### `string_to_lower(string: String, language: String = "") -> String`
- 限定：qualifiers=const

Returns the string converted to `lowercase`.
				**Note:** Casing is locale dependent and context sensitive if server support `FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION` feature (supported by `TextServerAdvanced`).
				**Note:** The result may be longer or shorter than the original.

### `string_to_title(string: String, language: String = "") -> String`
- 限定：qualifiers=const

Returns the string converted to `Title Case`.
				**Note:** Casing is locale dependent and context sensitive if server support `FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION` feature (supported by `TextServerAdvanced`).
				**Note:** The result may be longer or shorter than the original.

### `string_to_upper(string: String, language: String = "") -> String`
- 限定：qualifiers=const

Returns the string converted to `UPPERCASE`.
				**Note:** Casing is locale dependent and context sensitive if server support `FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION` feature (supported by `TextServerAdvanced`).
				**Note:** The result may be longer or shorter than the original.

### `strip_diacritics(string: String) -> String`
- 限定：qualifiers=const

Strips diacritics from the string.
				**Note:** The result may be longer or shorter than the original.

### `tag_to_name(tag: int) -> String`
- 限定：qualifiers=const

Converts the given OpenType tag to the readable name of a feature, variation, script, or language.

## 枚举

### `FontAntialiasing`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FONT_ANTIALIASING_NONE` |  |
| `1` | `FONT_ANTIALIASING_GRAY` |  |
| `2` | `FONT_ANTIALIASING_LCD` |  |

### `FontLCDSubpixelLayout`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FONT_LCD_SUBPIXEL_LAYOUT_NONE` |  |
| `1` | `FONT_LCD_SUBPIXEL_LAYOUT_HRGB` |  |
| `2` | `FONT_LCD_SUBPIXEL_LAYOUT_HBGR` |  |
| `3` | `FONT_LCD_SUBPIXEL_LAYOUT_VRGB` |  |
| `4` | `FONT_LCD_SUBPIXEL_LAYOUT_VBGR` |  |
| `5` | `FONT_LCD_SUBPIXEL_LAYOUT_MAX` |  |

### `Direction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DIRECTION_AUTO` |  |
| `1` | `DIRECTION_LTR` |  |
| `2` | `DIRECTION_RTL` |  |
| `3` | `DIRECTION_INHERITED` |  |

### `Orientation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ORIENTATION_HORIZONTAL` |  |
| `1` | `ORIENTATION_VERTICAL` |  |

### `JustificationFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `JUSTIFICATION_NONE` | （位标志） |
| `1` | `JUSTIFICATION_KASHIDA` | （位标志） |
| `2` | `JUSTIFICATION_WORD_BOUND` | （位标志） |
| `4` | `JUSTIFICATION_TRIM_EDGE_SPACES` | （位标志） |
| `8` | `JUSTIFICATION_AFTER_LAST_TAB` | （位标志） |
| `16` | `JUSTIFICATION_CONSTRAIN_ELLIPSIS` | （位标志） |
| `32` | `JUSTIFICATION_SKIP_LAST_LINE` | （位标志） |
| `64` | `JUSTIFICATION_SKIP_LAST_LINE_WITH_VISIBLE_CHARS` | （位标志） |
| `128` | `JUSTIFICATION_DO_NOT_SKIP_SINGLE_LINE` | （位标志） |

### `AutowrapMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AUTOWRAP_OFF` |  |
| `1` | `AUTOWRAP_ARBITRARY` |  |
| `2` | `AUTOWRAP_WORD` |  |
| `3` | `AUTOWRAP_WORD_SMART` |  |

### `LineBreakFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BREAK_NONE` | （位标志） |
| `1` | `BREAK_MANDATORY` | （位标志） |
| `2` | `BREAK_WORD_BOUND` | （位标志） |
| `4` | `BREAK_GRAPHEME_BOUND` | （位标志） |
| `8` | `BREAK_ADAPTIVE` | （位标志） |
| `16` | `BREAK_TRIM_EDGE_SPACES` | （位标志） |
| `32` | `BREAK_TRIM_INDENT` | （位标志） |
| `64` | `BREAK_TRIM_START_EDGE_SPACES` | （位标志） |
| `128` | `BREAK_TRIM_END_EDGE_SPACES` | （位标志） |

### `VisibleCharactersBehavior`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VC_CHARS_BEFORE_SHAPING` |  |
| `1` | `VC_CHARS_AFTER_SHAPING` |  |
| `2` | `VC_GLYPHS_AUTO` |  |
| `3` | `VC_GLYPHS_LTR` |  |
| `4` | `VC_GLYPHS_RTL` |  |

### `OverrunBehavior`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OVERRUN_NO_TRIMMING` |  |
| `1` | `OVERRUN_TRIM_CHAR` |  |
| `2` | `OVERRUN_TRIM_WORD` |  |
| `3` | `OVERRUN_TRIM_ELLIPSIS` |  |
| `4` | `OVERRUN_TRIM_WORD_ELLIPSIS` |  |
| `5` | `OVERRUN_TRIM_ELLIPSIS_FORCE` |  |
| `6` | `OVERRUN_TRIM_WORD_ELLIPSIS_FORCE` |  |

### `TextOverrunFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OVERRUN_NO_TRIM` | （位标志） |
| `1` | `OVERRUN_TRIM` | （位标志） |
| `2` | `OVERRUN_TRIM_WORD_ONLY` | （位标志） |
| `4` | `OVERRUN_ADD_ELLIPSIS` | （位标志） |
| `8` | `OVERRUN_ENFORCE_ELLIPSIS` | （位标志） |
| `16` | `OVERRUN_JUSTIFICATION_AWARE` | （位标志） |
| `32` | `OVERRUN_SHORT_STRING_ELLIPSIS` | （位标志） |

### `GraphemeFlag`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `GRAPHEME_IS_VALID` | （位标志） |
| `2` | `GRAPHEME_IS_RTL` | （位标志） |
| `4` | `GRAPHEME_IS_VIRTUAL` | （位标志） |
| `8` | `GRAPHEME_IS_SPACE` | （位标志） |
| `16` | `GRAPHEME_IS_BREAK_HARD` | （位标志） |
| `32` | `GRAPHEME_IS_BREAK_SOFT` | （位标志） |
| `64` | `GRAPHEME_IS_TAB` | （位标志） |
| `128` | `GRAPHEME_IS_ELONGATION` | （位标志） |
| `256` | `GRAPHEME_IS_PUNCTUATION` | （位标志） |
| `512` | `GRAPHEME_IS_UNDERSCORE` | （位标志） |
| `1024` | `GRAPHEME_IS_CONNECTED` | （位标志） |
| `2048` | `GRAPHEME_IS_SAFE_TO_INSERT_TATWEEL` | （位标志） |
| `4096` | `GRAPHEME_IS_EMBEDDED_OBJECT` | （位标志） |
| `8192` | `GRAPHEME_IS_SOFT_HYPHEN` | （位标志） |

### `Hinting`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HINTING_NONE` |  |
| `1` | `HINTING_LIGHT` |  |
| `2` | `HINTING_NORMAL` |  |

### `SubpixelPositioning`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SUBPIXEL_POSITIONING_DISABLED` |  |
| `1` | `SUBPIXEL_POSITIONING_AUTO` |  |
| `2` | `SUBPIXEL_POSITIONING_ONE_HALF` |  |
| `3` | `SUBPIXEL_POSITIONING_ONE_QUARTER` |  |
| `20` | `SUBPIXEL_POSITIONING_ONE_HALF_MAX_SIZE` |  |
| `16` | `SUBPIXEL_POSITIONING_ONE_QUARTER_MAX_SIZE` |  |

### `Feature`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `FEATURE_SIMPLE_LAYOUT` |  |
| `2` | `FEATURE_BIDI_LAYOUT` |  |
| `4` | `FEATURE_VERTICAL_LAYOUT` |  |
| `8` | `FEATURE_SHAPING` |  |
| `16` | `FEATURE_KASHIDA_JUSTIFICATION` |  |
| `32` | `FEATURE_BREAK_ITERATORS` |  |
| `64` | `FEATURE_FONT_BITMAP` |  |
| `128` | `FEATURE_FONT_DYNAMIC` |  |
| `256` | `FEATURE_FONT_MSDF` |  |
| `512` | `FEATURE_FONT_SYSTEM` |  |
| `1024` | `FEATURE_FONT_VARIABLE` |  |
| `2048` | `FEATURE_CONTEXT_SENSITIVE_CASE_CONVERSION` |  |
| `4096` | `FEATURE_USE_SUPPORT_DATA` |  |
| `8192` | `FEATURE_UNICODE_IDENTIFIERS` |  |
| `16384` | `FEATURE_UNICODE_SECURITY` |  |

### `ContourPointTag`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `CONTOUR_CURVE_TAG_ON` |  |
| `0` | `CONTOUR_CURVE_TAG_OFF_CONIC` |  |
| `2` | `CONTOUR_CURVE_TAG_OFF_CUBIC` |  |

### `SpacingType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SPACING_GLYPH` |  |
| `1` | `SPACING_SPACE` |  |
| `2` | `SPACING_TOP` |  |
| `3` | `SPACING_BOTTOM` |  |
| `4` | `SPACING_MAX` |  |

### `FontStyle`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `FONT_BOLD` | （位标志） |
| `2` | `FONT_ITALIC` | （位标志） |
| `4` | `FONT_FIXED_WIDTH` | （位标志） |

### `StructuredTextParser`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STRUCTURED_TEXT_DEFAULT` |  |
| `1` | `STRUCTURED_TEXT_URI` |  |
| `2` | `STRUCTURED_TEXT_FILE` |  |
| `3` | `STRUCTURED_TEXT_EMAIL` |  |
| `4` | `STRUCTURED_TEXT_LIST` |  |
| `5` | `STRUCTURED_TEXT_GDSCRIPT` |  |
| `6` | `STRUCTURED_TEXT_CUSTOM` |  |

### `FixedSizeScaleMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FIXED_SIZE_SCALE_DISABLE` |  |
| `1` | `FIXED_SIZE_SCALE_INTEGER_ONLY` |  |
| `2` | `FIXED_SIZE_SCALE_ENABLED` |  |

