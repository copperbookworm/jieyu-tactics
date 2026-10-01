# EditorSceneFormatImporter

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSceneFormatImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSceneFormatImporter.md`

**摘要**：Imports scenes from third-parties' 3D files.

## 描述

`EditorSceneFormatImporter` allows to define an importer script for a third-party 3D format.
		To use `EditorSceneFormatImporter`, register it using the `EditorPlugin.add_scene_format_importer_plugin` method first.

## 方法

### `_get_extensions() -> PackedStringArray`
- 限定：qualifiers=virtual required const

Return supported file extensions for this scene importer.

### `_get_import_options(path: String) -> void`
- 限定：qualifiers=virtual

Override to add general import options. These will appear in the main import dock on the editor. Add options via `add_import_option` and `add_import_option_advanced`.
				**Note:** All `EditorSceneFormatImporter` and `EditorScenePostImportPlugin` instances will add options for all files. It is good practice to check the file extension when `path` is non-empty.
				When the user is editing project settings, `path` will be empty. It is recommended to add all options when `path` is empty to allow the user to customize Import Defaults.

### `_get_option_visibility(path: String, for_animation: bool, option: String) -> Variant`
- 限定：qualifiers=virtual const

Should return `true` to show the given option, `false` to hide the given option, or `null` to ignore.

### `_import_scene(path: String, flags: int, options: Dictionary) -> Object`
- 限定：qualifiers=virtual required

Perform the bulk of the scene import logic here, for example using `GLTFDocument` or `FBXDocument`.

### `add_import_option(name: String, value: Variant) -> void`

Add a specific import option (name and default value only). This function can only be called from `_get_import_options`.

### `add_import_option_advanced(type: int, name: String, default_value: Variant, hint: int = 0, hint_string: String = "", usage_flags: int = 6) -> void`

Add a specific import option. This function can only be called from `_get_import_options`.

## 枚举

### `ImportFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `IMPORT_SCENE` | （位标志） |
| `2` | `IMPORT_ANIMATION` | （位标志） |
| `4` | `IMPORT_FAIL_ON_MISSING_DEPENDENCIES` | （位标志） |
| `8` | `IMPORT_GENERATE_TANGENT_ARRAYS` | （位标志） |
| `16` | `IMPORT_USE_NAMED_SKIN_BINDS` | （位标志） |
| `32` | `IMPORT_DISCARD_MESHES_AND_MATERIALS` | （位标志） |
| `64` | `IMPORT_FORCE_DISABLE_MESH_COMPRESSION` | （位标志） |

