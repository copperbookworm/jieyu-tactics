# FontVariation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FontVariation` → `Font` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FontVariation.md`

**摘要**：A variation of a font with additional settings.

## 描述

Provides OpenType variations, simulated bold / slant, and additional font settings like OpenType features and extra spacing.
		To use simulated bold font variant:
		`codeblocks`
		`gdscript`
		var fv = FontVariation.new()
		fv.base_font = load("res://BarlowCondensed-Regular.ttf")
		fv.variation_embolden = 1.2
		$Label.add_theme_font_override("font", fv)
		$Label.add_theme_font_size_override("font_size", 64)
		
		`csharp`
		var fv = new FontVariation();
		fv.SetBaseFont(ResourceLoader.Load<FontFile>("res://BarlowCondensed-Regular.ttf"));
		fv.SetVariationEmbolden(1.2);
		GetNode("Label").AddThemeFontOverride("font", fv);
		GetNode("Label").AddThemeFontSizeOverride("font_size", 64);
		
		
		To set the coordinate of multiple variation axes:
		
```gdscript
		var fv = FontVariation.new();
		var ts = TextServerManager.get_primary_interface()
		fv.base_font = load("res://BarlowCondensed-Regular.ttf")
		fv.variation_opentype = { ts.name_to_tag("wght"): 900, ts.name_to_tag("custom_hght"): 900 }
		
```

## 属性

- **`base_font`** `Font`
  - 其它属性：getter=get_base_font · setter=set_base_font
- **`baseline_offset`** `float` = `0.0`
  - 其它属性：getter=get_baseline_offset · setter=set_baseline_offset
- **`opentype_features`** `Dictionary` = `{}`
  - 其它属性：getter=get_opentype_features · setter=set_opentype_features
- **`palette_custom_colors`** `PackedColorArray` = `PackedColorArray()`
  - 其它属性：getter=get_palette_custom_colors · setter=set_palette_custom_colors
- **`palette_index`** `int` = `0`
  - 其它属性：getter=get_palette_index · setter=set_palette_index
- **`spacing_bottom`** `int` = `0`
  - 其它属性：getter=get_spacing · setter=set_spacing
- **`spacing_glyph`** `int` = `0`
  - 其它属性：getter=get_spacing · setter=set_spacing
- **`spacing_space`** `int` = `0`
  - 其它属性：getter=get_spacing · setter=set_spacing
- **`spacing_top`** `int` = `0`
  - 其它属性：getter=get_spacing · setter=set_spacing
- **`variation_embolden`** `float` = `0.0`
  - 其它属性：getter=get_variation_embolden · setter=set_variation_embolden
- **`variation_face_index`** `int` = `0`
  - 其它属性：getter=get_variation_face_index · setter=set_variation_face_index
- **`variation_opentype`** `Dictionary` = `{}`
  - 其它属性：getter=get_variation_opentype · setter=set_variation_opentype
- **`variation_transform`** `Transform2D` = `Transform2D(1, 0, 0, 1, 0, 0)`
  - 其它属性：getter=get_variation_transform · setter=set_variation_transform

## 方法

### `set_spacing(spacing: int, value: int) -> void`

Sets the spacing for `spacing` to `value` in pixels (not relative to the font size).

