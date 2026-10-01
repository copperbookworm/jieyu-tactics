# EditorScenePostImport

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorScenePostImport` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorScenePostImport.md`

**摘要**：Post-processes scenes after import.

## 描述

Imported scenes can be automatically modified right after import by setting their **Custom Script** Import property to a `tool` script that inherits from this class.
		The `_post_import` callback receives the imported scene's root node and returns the modified version of the scene:
		`codeblocks`
		`gdscript`
		@tool # Needed so it runs in editor.
		extends EditorScenePostImport

		# This sample changes all node names.
		# Called right after the scene is imported and gets the root node.
		func _post_import(scene):
			# Change all node names to "modified_`oldnodename`"
			iterate(scene)
			return scene # Remember to return the imported scene

		func iterate(node):
			if node != null:
				node.name = "modified_" + node.name
				for child in node.get_children():
					iterate(child)
		
		`csharp`
		using Godot;

		// This sample changes all node names.
		// Called right after the scene is imported and gets the root node.
		`Tool`
		public partial class NodeRenamer : EditorScenePostImport
		{
			public override GodotObject _PostImport(Node scene)
			{
				// Change all node names to "modified_`oldnodename`"
				Iterate(scene);
				return scene; // Remember to return the imported scene
			}

			public void Iterate(Node node)
			{
				if (node != null)
				{
					node.Name = $"modified_{node.Name}";
					foreach (Node child in node.GetChildren())
					{
						Iterate(child);
					}
				}
			}
		}

## 方法

### `_post_import(scene: Node) -> Object`
- 限定：qualifiers=virtual

Called after the scene was imported. This method must return the modified version of the scene.

### `get_source_file() -> String`
- 限定：qualifiers=const

Returns the source file path which got imported (e.g. `res://scene.dae`).

## 教程链接

- [Importing 3D scenes: Configuration: Using import scripts for automation](None)

