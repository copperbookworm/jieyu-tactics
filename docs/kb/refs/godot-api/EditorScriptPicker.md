# EditorScriptPicker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorScriptPicker` → `EditorResourcePicker` → `HBoxContainer` → `BoxContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorScriptPicker.md`

**摘要**：Godot editor's control for selecting the `script` property of a `Node`.

## 描述

Similar to `EditorResourcePicker` this `Control` node is used in the editor's Inspector dock, but only to edit the `script` property of a `Node`. Default options for creating new resources of all possible subtypes are replaced with dedicated buttons that open the "Attach Node Script" dialog. Can be used with `EditorInspectorPlugin` to recreate the same behavior.
		**Note:** You must set the `script_owner` for the custom context menu items to work.

## 属性

- **`script_owner`** `Node`
  - 其它属性：getter=get_script_owner · setter=set_script_owner

