# ScriptCreateDialog

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScriptCreateDialog` → `ConfirmationDialog` → `AcceptDialog` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ScriptCreateDialog.md`

**摘要**：Godot editor's popup dialog for creating new `Script` files.

## 描述

The `ScriptCreateDialog` creates script files according to a given template for a given scripting language. The standard use is to configure its fields prior to calling one of the `Window.popup` methods.
		`codeblocks`
		`gdscript`
		func _ready():
			var dialog = ScriptCreateDialog.new();
			dialog.config("Node", "res://new_node.gd") # For in-engine types.
			dialog.config("\"res://base_node.gd\"", "res://derived_node.gd") # For script types.
			dialog.popup_centered()
		
		`csharp`
		public override void _Ready()
		{
			var dialog = new ScriptCreateDialog();
			dialog.Config("Node", "res://NewNode.cs"); // For in-engine types.
			dialog.Config("\"res://BaseNode.cs\"", "res://DerivedNode.cs"); // For script types.
			dialog.PopupCentered();
		}

## 属性

- **`dialog_hide_on_ok`** `bool` = `false`
  - 其它属性：getter=get_hide_on_ok · overrides=AcceptDialog · setter=set_hide_on_ok
- **`ok_button_text`** `String` = `"Create"`
  - 其它属性：getter=get_ok_button_text · overrides=AcceptDialog · setter=set_ok_button_text
- **`title`** `String` = `"Attach Node Script"`
  - 其它属性：getter=get_title · overrides=Window · setter=set_title

## 方法

### `config(inherits: String, path: String, built_in_enabled: bool = true, load_enabled: bool = true) -> void`

Prefills required fields to configure the ScriptCreateDialog for use.

## 信号

### `script_created(script: Script)`

Emitted when the user clicks the OK button.

