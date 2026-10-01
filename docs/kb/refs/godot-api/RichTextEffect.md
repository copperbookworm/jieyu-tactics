# RichTextEffect

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RichTextEffect` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RichTextEffect.md`

**摘要**：A custom effect for a `RichTextLabel`.

## 描述

A custom effect for a `RichTextLabel`, which can be loaded in the `RichTextLabel` inspector or using `RichTextLabel.install_effect`.
		**Note:** For a `RichTextEffect` to be usable, a BBCode tag must be defined as a member variable called `bbcode` in the script.
		`codeblocks`
		`skip-lint`
		# The RichTextEffect will be usable like this: ``example`Some text`
		var bbcode = "example"
		
		`skip-lint`
		// The RichTextEffect will be usable like this: ``example`Some text`
		string bbcode = "example";
		
		
		**Note:** As soon as a `RichTextLabel` contains at least one `RichTextEffect`, it will continuously process the effect unless the project is paused. This may impact battery life negatively.

## 方法

### `_process_custom_fx(char_fx: CharFXTransform) -> bool`
- 限定：qualifiers=virtual const

Override this method to modify properties in `char_fx`. The method must return `true` if the character could be transformed successfully. If the method returns `false`, it will skip transformation to avoid displaying broken text.

## 教程链接

- [BBCode in RichTextLabel](None)

