# EditorSyntaxHighlighter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSyntaxHighlighter` → `SyntaxHighlighter` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSyntaxHighlighter.md`

**摘要**：Base class for `SyntaxHighlighter` used by the `ScriptEditor`.

## 描述

Base class that all `SyntaxHighlighter`s used by the `ScriptEditor` extend from.
		Add a syntax highlighter to an individual script by calling `ScriptEditorBase.add_syntax_highlighter`. To apply to all scripts on open, call `ScriptEditor.register_syntax_highlighter`.

## 方法

### `_create() -> EditorSyntaxHighlighter`
- 限定：qualifiers=virtual const

Virtual method which creates a new instance of the syntax highlighter.

### `_get_name() -> String`
- 限定：qualifiers=virtual const

Virtual method which can be overridden to return the syntax highlighter name.

### `_get_supported_languages() -> PackedStringArray`
- 限定：qualifiers=virtual const

Virtual method which can be overridden to return the supported language names.

