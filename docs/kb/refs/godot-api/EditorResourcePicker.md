# EditorResourcePicker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorResourcePicker` → `HBoxContainer` → `BoxContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorResourcePicker.md`

**摘要**：Godot editor's control for selecting `Resource` type properties.

## 描述

This `Control` node is used in the editor's Inspector dock to allow editing of `Resource` type properties. It provides options for creating, loading, saving and converting resources. Can be used with `EditorInspectorPlugin` to recreate the same behavior.
		**Note:** This `Control` does not include any editor for the resource, as editing is controlled by the Inspector dock itself or sub-Inspectors.

## 属性

- **`base_type`** `String` = `""`
  - 其它属性：getter=get_base_type · setter=set_base_type
- **`editable`** `bool` = `true`
  - 其它属性：getter=is_editable · keywords=readonly, disabled, enabled · setter=set_editable
- **`edited_resource`** `Resource`
  - 其它属性：getter=get_edited_resource · setter=set_edited_resource
- **`toggle_mode`** `bool` = `false`
  - 其它属性：getter=is_toggle_mode · setter=set_toggle_mode

## 方法

### `_handle_menu_selected(id: int) -> bool`
- 限定：qualifiers=virtual

This virtual method can be implemented to handle context menu items not handled by default. See `_set_create_options`.

### `_set_create_options(menu_node: Object) -> void`
- 限定：qualifiers=virtual

This virtual method is called when updating the context menu of an `editable` `EditorResourcePicker`. Implement this method to override the "New" items section with your own options. `menu_node` is a reference to the `PopupMenu` node.
				**Note:** Implement `_handle_menu_selected` to handle these custom items.
				**Note:** Relevant built-in options ("Load", "Copy", "Paste", etc.) are automatically added to the `menu_node` afterwards, using their hard-coded IDs starting from `0`. Custom options need to use non-colliding IDs to be handled properly. Using `id = 100 + custom_option_index` is safe (this is what the default items in the "New" section use).

### `get_allowed_types() -> PackedStringArray`
- 限定：qualifiers=const

Returns a list of all allowed types and subtypes corresponding to the `base_type`. If the `base_type` is empty, an empty list is returned.

### `set_toggle_pressed(pressed: bool) -> void`

Sets the toggle mode state for the main button. Works only if `toggle_mode` is set to `true`.

## 信号

### `resource_changed(resource: Resource)`

Emitted when the value of the edited resource was changed.

### `resource_selected(resource: Resource, inspect: bool)`

Emitted when the resource value was set and user clicked to edit it. When `inspect` is `true`, the signal was caused by the context menu "Edit" or "Inspect" option.

