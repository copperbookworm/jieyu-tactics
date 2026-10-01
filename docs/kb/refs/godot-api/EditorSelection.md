# EditorSelection

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSelection` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSelection.md`

**摘要**：Manages the SceneTree selection in the editor.

## 描述

This object manages the SceneTree selection in the editor.
		**Note:** This class shouldn't be instantiated directly. Instead, access the singleton using `EditorInterface.get_selection`.

## 方法

### `add_node(node: Node) -> void`

Adds a node to the selection.
				**Note:** The newly selected node will not be automatically edited in the inspector. If you want to edit a node, use `EditorInterface.edit_node`.

### `clear() -> void`

Clear the selection.

### `get_selected_nodes() -> Node[]`

Returns the list of selected nodes.

### `get_top_selected_nodes() -> Node[]`

Returns the list of top selected nodes only, excluding any children. This is useful for performing transform operations (moving them, rotating, etc.).
				For example, if there is a node A with a child B and a sibling C, then selecting all three will cause this method to return only A and C. Changing the global transform of A will affect the global transform of B, so there is no need to change B separately.

### `get_transformable_selected_nodes() -> Node[]`
- 限定：deprecated=Use [method get_top_selected_nodes] instead.

Returns the list of top selected nodes only, excluding any children. This is useful for performing transform operations (moving them, rotating, etc.). See `get_top_selected_nodes`.

### `remove_node(node: Node) -> void`

Removes a node from the selection.

## 信号

### `selection_changed()`

Emitted when the selection changes.

