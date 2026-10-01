# EditorScript

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorScript` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorScript.md`

**摘要**：Base script that can be used to add extension functions to the editor.

## 描述

Scripts extending this class and implementing its `_run` method can be executed from the Script Editor's **File > Run** menu option (or by pressing Ctrl + Shift + X) while the editor is running. This is useful for adding custom in-editor functionality to Godot. For more complex additions, consider using `EditorPlugin`s instead.
		If a script extending this class also has a global class name, it will be included in the editor's command palette.
		**Note:** Extending scripts need to have `tool` mode enabled.
		**Example:** Running the following script prints "Hello from the Godot Editor!":
		`codeblocks`
		`gdscript`
		@tool
		extends EditorScript

		func _run():
			print("Hello from the Godot Editor!")
		
		`csharp`
		using Godot;

		`Tool`
		public partial class HelloEditor : EditorScript
		{
			public override void _Run()
			{
				GD.Print("Hello from the Godot Editor!");
			}
		}
		
		
		**Note:** EditorScript is `RefCounted`, meaning it is destroyed when nothing references it. This can cause errors during asynchronous operations if there are no references to the script.

## 方法

### `_run() -> void`
- 限定：qualifiers=virtual required

This method is executed by the Editor when **File > Run** is used.

### `add_root_node(node: Node) -> void`
- 限定：deprecated=Use [method EditorInterface.add_root_node] instead.

Makes `node` root of the currently opened scene. Only works if the scene is empty. If the `node` is a scene instance, an inheriting scene will be created.

### `get_editor_interface() -> EditorInterface`
- 限定：deprecated=[EditorInterface] is a global singleton and can be accessed directly by its name. · qualifiers=const

Returns the `EditorInterface` singleton instance.

### `get_scene() -> Node`
- 限定：deprecated=Use [method EditorInterface.get_edited_scene_root] instead. · qualifiers=const

Returns the edited (current) scene's root `Node`. Equivalent of `EditorInterface.get_edited_scene_root`.

