# Label3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Label3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=text
> 自动生成，勿手改。文件：`refs/godot-api/Label3D.md`

**摘要**：A node for displaying plain text in 3D space.

## 描述

A node for displaying plain text in 3D space. By adjusting various properties of this node, you can configure things such as the text's appearance and whether it always faces the camera.

## 属性

- **`alpha_antialiasing_edge`** `float` = `0.0`
  - 其它属性：getter=get_alpha_antialiasing_edge · setter=set_alpha_antialiasing_edge
- **`alpha_antialiasing_mode`** `int` = `0` · 枚举 `BaseMaterial3D.AlphaAntiAliasing`
  - 其它属性：getter=get_alpha_antialiasing · setter=set_alpha_antialiasing
- **`alpha_cut`** `int` = `0` · 枚举 `Label3D.AlphaCutMode`
  - 其它属性：getter=get_alpha_cut_mode · setter=set_alpha_cut_mode
- **`alpha_hash_scale`** `float` = `1.0`
  - 其它属性：getter=get_alpha_hash_scale · setter=set_alpha_hash_scale
- **`alpha_scissor_threshold`** `float` = `0.5`
  - 其它属性：getter=get_alpha_scissor_threshold · setter=set_alpha_scissor_threshold
- **`autowrap_mode`** `int` = `0` · 枚举 `TextServer.AutowrapMode`
  - 其它属性：getter=get_autowrap_mode · setter=set_autowrap_mode
- **`autowrap_trim_flags`** `int` = `192` · 枚举 `TextServer.LineBreakFlag` · 位标志
  - 其它属性：getter=get_autowrap_trim_flags · is_bitfield=true · setter=set_autowrap_trim_flags
- **`billboard`** `int` = `0` · 枚举 `BaseMaterial3D.BillboardMode`
  - 其它属性：getter=get_billboard_mode · setter=set_billboard_mode
- **`cast_shadow`** `int` = `0` · 枚举 `GeometryInstance3D.ShadowCastingSetting`
  - 其它属性：getter=get_cast_shadows_setting · overrides=GeometryInstance3D · setter=set_cast_shadows_setting
- **`double_sided`** `bool` = `true`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`fixed_size`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`font`** `Font`
  - 其它属性：getter=get_font · setter=set_font
- **`font_size`** `int` = `32`
  - 其它属性：getter=get_font_size · setter=set_font_size
- **`gi_mode`** `int` = `0` · 枚举 `GeometryInstance3D.GIMode`
  - 其它属性：getter=get_gi_mode · overrides=GeometryInstance3D · setter=set_gi_mode
- **`horizontal_alignment`** `int` = `1` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_horizontal_alignment · setter=set_horizontal_alignment
- **`justification_flags`** `int` = `163` · 枚举 `TextServer.JustificationFlag` · 位标志
  - 其它属性：getter=get_justification_flags · is_bitfield=true · setter=set_justification_flags
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`line_spacing`** `float` = `0.0`
  - 其它属性：getter=get_line_spacing · setter=set_line_spacing
- **`modulate`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_modulate · keywords=color, colour · setter=set_modulate
- **`no_depth_test`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`outline_modulate`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_outline_modulate · setter=set_outline_modulate
- **`outline_render_priority`** `int` = `-1`
  - 其它属性：getter=get_outline_render_priority · setter=set_outline_render_priority
- **`outline_size`** `int` = `12`
  - 其它属性：getter=get_outline_size · setter=set_outline_size
- **`pixel_size`** `float` = `0.005`
  - 其它属性：getter=get_pixel_size · setter=set_pixel_size
- **`render_priority`** `int` = `0`
  - 其它属性：getter=get_render_priority · setter=set_render_priority
- **`shaded`** `bool` = `false`
  - 其它属性：getter=get_draw_flag · setter=set_draw_flag
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `TextServer.Direction`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`texture_filter`** `int` = `3` · 枚举 `BaseMaterial3D.TextureFilter`
  - 其它属性：getter=get_texture_filter · setter=set_texture_filter
- **`uppercase`** `bool` = `false`
  - 其它属性：getter=is_uppercase · setter=set_uppercase
- **`vertical_alignment`** `int` = `1` · 枚举 `VerticalAlignment`
  - 其它属性：getter=get_vertical_alignment · setter=set_vertical_alignment
- **`width`** `float` = `500.0`
  - 其它属性：getter=get_width · setter=set_width

## 方法

### `generate_triangle_mesh() -> TriangleMesh`
- 限定：qualifiers=const

Returns a `TriangleMesh` with the label's vertices following its current configuration (such as its `pixel_size`).

### `get_draw_flag(flag: int) -> bool`
- 限定：qualifiers=const

Returns the value of the specified flag.

### `set_draw_flag(flag: int, enabled: bool) -> void`

If `true`, the specified `flag` will be enabled.

## 枚举

### `DrawFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_SHADED` |  |
| `1` | `FLAG_DOUBLE_SIDED` |  |
| `2` | `FLAG_DISABLE_DEPTH_TEST` |  |
| `3` | `FLAG_FIXED_SIZE` |  |
| `4` | `FLAG_MAX` |  |

### `AlphaCutMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALPHA_CUT_DISABLED` |  |
| `1` | `ALPHA_CUT_DISCARD` |  |
| `2` | `ALPHA_CUT_OPAQUE_PREPASS` |  |
| `3` | `ALPHA_CUT_HASH` |  |

## 教程链接

- [3D text](None)

