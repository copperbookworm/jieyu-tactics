# LinkButton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LinkButton` → `BaseButton` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LinkButton.md`

**摘要**：A button that represents a link.

## 描述

A button that represents a link. This type of button is primarily used for interactions that cause a context change (like linking to a web page).
		See also `BaseButton` which contains common properties and methods associated with this node.

## 属性

- **`ellipsis_char`** `String` = `"…"`
  - 其它属性：getter=get_ellipsis_char · setter=set_ellipsis_char
- **`focus_mode`** `int` = `3` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`mouse_default_cursor_shape`** `int` = `2` · 枚举 `Control.CursorShape`
  - 其它属性：getter=get_default_cursor_shape · overrides=Control · setter=set_default_cursor_shape
- **`structured_text_bidi_override`** `int` = `0` · 枚举 `TextServer.StructuredTextParser`
  - 其它属性：getter=get_structured_text_bidi_override · setter=set_structured_text_bidi_override
- **`structured_text_bidi_override_options`** `Array` = `[]`
  - 其它属性：getter=get_structured_text_bidi_override_options · setter=set_structured_text_bidi_override_options
- **`text`** `String` = `""`
  - 其它属性：getter=get_text · setter=set_text
- **`text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_text_direction · setter=set_text_direction
- **`text_overrun_behavior`** `int` = `0` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_text_overrun_behavior · setter=set_text_overrun_behavior
- **`underline`** `int` = `0` · 枚举 `LinkButton.UnderlineMode`
  - 其它属性：getter=get_underline_mode · setter=set_underline_mode
- **`uri`** `String` = `""`
  - 其它属性：getter=get_uri · setter=set_uri

## 枚举

### `UnderlineMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UNDERLINE_MODE_ALWAYS` |  |
| `1` | `UNDERLINE_MODE_ON_HOVER` |  |
| `2` | `UNDERLINE_MODE_NEVER` |  |

## 主题属性

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_disabled_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_focus_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hover_pressed_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_pressed_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `outline_size`
- data_type=constant · default=0 · type=int

### `underline_spacing`
- data_type=constant · default=2 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `focus`
- data_type=style · type=StyleBox

