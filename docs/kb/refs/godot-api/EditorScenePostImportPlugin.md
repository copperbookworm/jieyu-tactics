# EditorScenePostImportPlugin

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorScenePostImportPlugin` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorScenePostImportPlugin.md`

**摘要**：Plugin to control and modifying the process of importing a scene.

## 描述

This plugin type exists to modify the process of importing scenes, allowing to change the content as well as add importer options at every stage of the process.

## 方法

### `_get_import_options(path: String) -> void`
- 限定：qualifiers=virtual

Override to add general import options. These will appear in the main import dock on the editor. Add options via `add_import_option` and `add_import_option_advanced`.

### `_get_internal_import_options(category: int) -> void`
- 限定：qualifiers=virtual

Override to add internal import options. These will appear in the 3D scene import dialog. Add options via `add_import_option` and `add_import_option_advanced`.

### `_get_internal_option_update_view_required(category: int, option: String) -> Variant`
- 限定：qualifiers=virtual const

Should return `true` if the 3D view of the import dialog needs to update when changing the given option.

### `_get_internal_option_visibility(category: int, for_animation: bool, option: String) -> Variant`
- 限定：qualifiers=virtual const

Should return `true` to show the given option, `false` to hide the given option, or `null` to ignore.

### `_get_option_visibility(path: String, for_animation: bool, option: String) -> Variant`
- 限定：qualifiers=virtual const

Should return `true` to show the given option, `false` to hide the given option, or `null` to ignore.

### `_internal_process(category: int, base_node: Node, node: Node, resource: Resource) -> void`
- 限定：qualifiers=virtual

Process a specific node or resource for a given category.

### `_post_process(scene: Node) -> void`
- 限定：qualifiers=virtual

Post-process the scene. This function is called after the final scene has been configured.

### `_pre_process(scene: Node) -> void`
- 限定：qualifiers=virtual

Pre-process the scene. This function is called right after the scene format loader loaded the scene and no changes have been made.
				Pre-process may be used to adjust internal import options in the `"nodes"`, `"meshes"`, `"animations"` or `"materials"` keys inside `get_option_value("_subresources")`.

### `add_import_option(name: String, value: Variant) -> void`

Add a specific import option (name and default value only). This function can only be called from `_get_import_options` and `_get_internal_import_options`.

### `add_import_option_advanced(type: int, name: String, default_value: Variant, hint: int = 0, hint_string: String = "", usage_flags: int = 6) -> void`

Add a specific import option. This function can only be called from `_get_import_options` and `_get_internal_import_options`.

### `get_option_value(name: StringName) -> Variant`
- 限定：qualifiers=const

Query the value of an option. This function can only be called from those querying visibility, or processing.

## 枚举

### `InternalImportCategory`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INTERNAL_IMPORT_CATEGORY_NODE` |  |
| `1` | `INTERNAL_IMPORT_CATEGORY_MESH_3D_NODE` |  |
| `2` | `INTERNAL_IMPORT_CATEGORY_MESH` |  |
| `3` | `INTERNAL_IMPORT_CATEGORY_MATERIAL` |  |
| `4` | `INTERNAL_IMPORT_CATEGORY_ANIMATION` |  |
| `5` | `INTERNAL_IMPORT_CATEGORY_ANIMATION_NODE` |  |
| `6` | `INTERNAL_IMPORT_CATEGORY_SKELETON_3D_NODE` |  |
| `7` | `INTERNAL_IMPORT_CATEGORY_MAX` |  |

