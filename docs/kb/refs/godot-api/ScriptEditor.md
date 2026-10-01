# ScriptEditor

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ScriptEditor` → `PanelContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ScriptEditor.md`

**摘要**：Godot editor's script editor.

## 描述

Godot editor's script editor.
		**Note:** This class shouldn't be instantiated directly. Instead, access the singleton using `EditorInterface.get_script_editor`.

## 方法

### `clear_docs_from_script(script: Script) -> void`

Removes the documentation for the given `script`.
				**Note:** This should be called whenever the script is changed to keep the open documentation state up to date.

### `close_file(path: String) -> int`

Closes the file at the given `path`, discarding any unsaved changes.
				Returns `OK` on success or `ERR_FILE_NOT_FOUND` if the file is not found.

### `get_breakpoints() -> PackedStringArray`

Returns array of breakpoints.

### `get_current_editor() -> ScriptEditorBase`
- 限定：qualifiers=const

Returns the `ScriptEditorBase` object that the user is currently editing.

### `get_current_script() -> Script`

Returns a `Script` that is currently active in editor.

### `get_open_script_editors() -> ScriptEditorBase[]`
- 限定：qualifiers=const

Returns an array with all `ScriptEditorBase` objects which are currently open in editor.

### `get_open_scripts() -> Script[]`
- 限定：qualifiers=const

Returns an array with all `Script` objects which are currently open in editor.

### `get_unsaved_files() -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of file paths of scripts with unsaved changes open in the editor.

### `goto_help(topic: String) -> void`

Opens help for the given topic. The `topic` is an encoded string that controls which class, method, constant, signal, annotation, property, or theme item should be focused.
				The supported `topic` formats include `class_name:class`, `class_method:class:method`, `class_constant:class:constant`, `class_signal:class:signal`, `class_annotation:class:@annotation`, `class_property:class:property`, and `class_theme_item:class:item`, where `class` is the class name, `method` is the method name, `constant` is the constant name, `signal` is the signal name, `annotation` is the annotation name, `property` is the property name, and `item` is the theme item.
				
```gdscript
				# Shows help for the Node class.
				class_name:Node
				# Shows help for the global min function.
				# Global objects are accessible in the `@GlobalScope` namespace, shown here.
				class_method:@GlobalScope:min
				# Shows help for get_viewport in the Node class.
				class_method:Node:get_viewport
				# Shows help for the Input constant MOUSE_BUTTON_MIDDLE.
				class_constant:Input:MOUSE_BUTTON_MIDDLE
				# Shows help for the BaseButton signal pressed.
				class_signal:BaseButton:pressed
				# Shows help for the CanvasItem property visible.
				class_property:CanvasItem:visible
				# Shows help for the GDScript annotation export.
				# Annotations should be prefixed with the `@` symbol in the descriptor, as shown here.
				class_annotation:@GDScript:@export
				# Shows help for the GraphNode theme item named panel_selected.
				class_theme_item:GraphNode:panel_selected
				
```

### `goto_line(line_number: int) -> void`

Goes to the specified line in the current script.

### `open_script_create_dialog(base_name: String, base_path: String) -> void`

Opens the script create dialog. The script will extend `base_name`. The file extension can be omitted from `base_path`. It will be added based on the selected scripting language.

### `register_syntax_highlighter(syntax_highlighter: EditorSyntaxHighlighter) -> void`

Registers the `EditorSyntaxHighlighter` to the editor, the `EditorSyntaxHighlighter` will be available on all open scripts.
				**Note:** Does not apply to scripts that are already opened.

### `reload_open_files() -> void`

Reloads all currently opened files. This should be used when opened files are changed outside of the script editor. The user may be prompted to resolve file conflicts, see `EditorSettings.text_editor/behavior/files/auto_reload_scripts_on_external_change`.

### `save_all_scripts() -> void`

Saves all open scripts.

### `unregister_syntax_highlighter(syntax_highlighter: EditorSyntaxHighlighter) -> void`

Unregisters the `EditorSyntaxHighlighter` from the editor.
				**Note:** The `EditorSyntaxHighlighter` will still be applied to scripts that are already opened.

### `update_docs_from_script(script: Script) -> void`

Updates the documentation for the given `script`.
				**Note:** This should be called whenever the script is changed to keep the open documentation state up to date.

## 信号

### `editor_script_changed(script: Script)`

Emitted when user changed active script. Argument is a freshly activated `Script`.

### `script_close(script: Script)`

Emitted when editor is about to close the active script. Argument is a `Script` that is going to be closed.

