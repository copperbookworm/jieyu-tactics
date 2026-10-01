# ThemeDB

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ThemeDB` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ThemeDB.md`

**摘要**：A singleton that provides access to static information about `Theme` resources used by the engine and by your project.

## 描述

This singleton provides access to static information about `Theme` resources used by the engine and by your projects. You can fetch the default engine theme, as well as your project configured theme.
		`ThemeDB` also contains fallback values for theme properties.

## 属性

- **`fallback_base_scale`** `float` = `1.0`
  - 其它属性：getter=get_fallback_base_scale · setter=set_fallback_base_scale
- **`fallback_font`** `Font`
  - 其它属性：getter=get_fallback_font · setter=set_fallback_font
- **`fallback_font_size`** `int` = `16`
  - 其它属性：getter=get_fallback_font_size · setter=set_fallback_font_size
- **`fallback_icon`** `Texture2D`
  - 其它属性：getter=get_fallback_icon · setter=set_fallback_icon
- **`fallback_stylebox`** `StyleBox`
  - 其它属性：getter=get_fallback_stylebox · setter=set_fallback_stylebox

## 方法

### `get_default_theme() -> Theme`

Returns a reference to the default engine `Theme`. This theme resource is responsible for the out-of-the-box look of `Control` nodes and cannot be overridden.

### `get_project_theme() -> Theme`

Returns a reference to the custom project `Theme`. This theme resources allows to override the default engine theme for every control node in the project.
				To set the project theme, see `ProjectSettings.gui/theme/custom`.

## 信号

### `fallback_changed()`

Emitted when one of the fallback values had been changed. Use it to refresh the look of controls that may rely on the fallback theme items.

