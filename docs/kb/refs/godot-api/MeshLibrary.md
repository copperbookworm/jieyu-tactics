# MeshLibrary

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshLibrary` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshLibrary.md`

**摘要**：Library of meshes.

## 描述

A library of meshes. Contains a list of `Mesh` resources, each with a name and ID. Each item can also include collision and navigation shapes. This resource is used in `GridMap`.

## 方法

### `clear() -> void`

Clears the library.

### `create_item(id: int) -> void`

Creates a new item in the library with the given ID.
				You can get an unused ID from `get_last_unused_item_id`.

### `find_item_by_name(name: String) -> int`
- 限定：qualifiers=const

Returns the first item with the given name, or `-1` if no item is found.

### `get_item_count() -> int`
- 限定：qualifiers=const

Returns the number of items present in the library.

### `get_item_list() -> PackedInt32Array`
- 限定：qualifiers=const

Returns the list of item IDs in use.

### `get_item_mesh(id: int) -> Mesh`
- 限定：qualifiers=const

Returns the item's mesh.

### `get_item_mesh_cast_shadow(id: int) -> int`
- 限定：qualifiers=const

Returns the item's shadow casting mode.

### `get_item_mesh_transform(id: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform applied to the item's mesh.

### `get_item_name(id: int) -> String`
- 限定：qualifiers=const

Returns the item's name.

### `get_item_navigation_layers(id: int) -> int`
- 限定：qualifiers=const

Returns the item's navigation layers bitmask.

### `get_item_navigation_mesh(id: int) -> NavigationMesh`
- 限定：qualifiers=const

Returns the item's navigation mesh.

### `get_item_navigation_mesh_transform(id: int) -> Transform3D`
- 限定：qualifiers=const

Returns the transform applied to the item's navigation mesh.

### `get_item_preview(id: int) -> Texture2D`
- 限定：qualifiers=const

When running in the editor, returns a generated item preview (a 3D rendering in isometric perspective). When used in a running project, returns the manually-defined item preview which can be set using `set_item_preview`. Returns an empty `Texture2D` if no preview was manually set in a running project.

### `get_item_shapes(id: int) -> Array`
- 限定：qualifiers=const

Returns an item's collision shapes.
				The array consists of each `Shape3D` followed by its `Transform3D`.

### `get_last_unused_item_id() -> int`
- 限定：qualifiers=const

Gets an unused ID for a new item.

### `remove_item(id: int) -> void`

Removes the item.

### `set_item_mesh(id: int, mesh: Mesh) -> void`

Sets the item's mesh.

### `set_item_mesh_cast_shadow(id: int, shadow_casting_setting: int) -> void`

Sets the item's shadow casting mode to `shadow_casting_setting`.

### `set_item_mesh_transform(id: int, mesh_transform: Transform3D) -> void`

Sets the transform to apply to the item's mesh.

### `set_item_name(id: int, name: String) -> void`

Sets the item's name.
				This name is shown in the editor. It can also be used to look up the item later using `find_item_by_name`.

### `set_item_navigation_layers(id: int, navigation_layers: int) -> void`

Sets the item's navigation layers bitmask.

### `set_item_navigation_mesh(id: int, navigation_mesh: NavigationMesh) -> void`

Sets the item's navigation mesh.

### `set_item_navigation_mesh_transform(id: int, navigation_mesh: Transform3D) -> void`

Sets the transform to apply to the item's navigation mesh.

### `set_item_preview(id: int, texture: Texture2D) -> void`

Sets a texture to use as the item's preview icon in the editor.

### `set_item_shapes(id: int, shapes: Array) -> void`

Sets an item's collision shapes.
				The array should consist of `Shape3D` objects, each followed by a `Transform3D` that will be applied to it. For shapes that should not have a transform, use `Transform3D.IDENTITY`.

## 教程链接

- [3D Kinematic Character Demo](None)
- [3D Platformer Demo](None)

