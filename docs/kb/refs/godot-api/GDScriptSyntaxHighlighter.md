# GDScriptSyntaxHighlighter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDScriptSyntaxHighlighter` → `EditorSyntaxHighlighter` → `SyntaxHighlighter` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/GDScriptSyntaxHighlighter.md`

**摘要**：A GDScript syntax highlighter that can be used with `TextEdit` and `CodeEdit` nodes.

## 描述

**Note:** This class can only be used for editor plugins because it relies on editor settings.
		`codeblocks`
		`gdscript`
		var code_preview = TextEdit.new()
		var highlighter = GDScriptSyntaxHighlighter.new()
		code_preview.syntax_highlighter = highlighter
		
		`csharp`
		var codePreview = new TextEdit();
		var highlighter = new GDScriptSyntaxHighlighter();
		codePreview.SyntaxHighlighter = highlighter;

