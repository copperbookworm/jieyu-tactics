# GridMapEditorPlugin

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GridMapEditorPlugin` → `EditorPlugin` → `Node` → `Object`
> 附加属性：api_type=editor · keywords=tilemap
> 自动生成，勿手改。文件：`refs/godot-api/GridMapEditorPlugin.md`

**摘要**：Editor for `GridMap` nodes.

## 描述

GridMapEditorPlugin provides access to the `GridMap` editor functionality.

## 方法

### `clear_selection() -> void`

Deselects any currently selected cells.

### `get_current_grid_map() -> GridMap`
- 限定：qualifiers=const

Returns the `GridMap` node currently edited by the grid map editor.

### `get_selected_cells() -> Array`
- 限定：qualifiers=const

Returns an array of `Vector3i`s with the selected cells' coordinates.

### `get_selected_palette_item() -> int`
- 限定：qualifiers=const

Returns the index of the selected `MeshLibrary` item in the grid map editor's palette or `-1` if no item is selected.
				**Note:** The indices might not be in the same order as they appear in the editor's interface.

### `get_selection() -> AABB`
- 限定：qualifiers=const

Returns the cell coordinate bounds of the current selection. Use `has_selection` to check if there is an active selection.

### `has_selection() -> bool`
- 限定：qualifiers=const

Returns `true` if there are selected cells.

### `set_selected_palette_item(item: int) -> void`
- 限定：qualifiers=const

Selects the `MeshLibrary` item with the given index in the grid map editor's palette. If a negative index is given, no item will be selected. If a value greater than the last index is given, the last item will be selected.
				**Note:** The indices might not be in the same order as they appear in the editor's interface.

### `set_selection(begin: Vector3i, end: Vector3i) -> void`

Selects the cells inside the given bounds from `begin` to `end`.

