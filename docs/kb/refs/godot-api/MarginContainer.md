# MarginContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MarginContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=padding
> 自动生成，勿手改。文件：`refs/godot-api/MarginContainer.md`

**摘要**：A container that keeps a margin around its child controls.

## 描述

`MarginContainer` adds an adjustable margin on each side of its child controls. The margins are added around all children, not around each individual one. To control the `MarginContainer`'s margins, use the `margin_*` theme properties listed below.
		**Note:** The margin sizes are theme overrides, not normal properties. This is an example of how to change them in code:
		`codeblocks`
		`gdscript`
		# This code sample assumes the current script is extending MarginContainer.
		var margin_value = 100
		add_theme_constant_override("margin_top", margin_value)
		add_theme_constant_override("margin_left", margin_value)
		add_theme_constant_override("margin_bottom", margin_value)
		add_theme_constant_override("margin_right", margin_value)
		
		`csharp`
		// This code sample assumes the current script is extending MarginContainer.
		int marginValue = 100;
		AddThemeConstantOverride("margin_top", marginValue);
		AddThemeConstantOverride("margin_left", marginValue);
		AddThemeConstantOverride("margin_bottom", marginValue);
		AddThemeConstantOverride("margin_right", marginValue);

## 主题属性

### `margin_bottom`
- data_type=constant · default=0 · type=int

### `margin_left`
- data_type=constant · default=0 · type=int

### `margin_right`
- data_type=constant · default=0 · type=int

### `margin_top`
- data_type=constant · default=0 · type=int

## 教程链接

- [Using Containers](None)

