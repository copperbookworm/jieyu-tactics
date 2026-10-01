# EditorExportPreset

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorExportPreset` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorExportPreset.md`

**摘要**：Export preset configuration.

## 描述

Represents the configuration of an export preset, as created by the editor's export dialog. An `EditorExportPreset` instance is intended to be used a read-only configuration passed to the `EditorExportPlatform` methods when exporting the project.

## 方法

### `are_advanced_options_enabled() -> bool`
- 限定：qualifiers=const

Returns `true` if the "Advanced" toggle is enabled in the export dialog.

### `get_custom_features() -> String`
- 限定：qualifiers=const

Returns a comma-separated list of custom features added to this preset, as a string. See Feature tags ($DOCS_URL/tutorials/export/feature_tags.html) in the documentation for more information.

### `get_customized_files() -> Dictionary`
- 限定：qualifiers=const

Returns a dictionary of files selected in the "Resources" tab of the export dialog. The dictionary's keys are file paths, and its values are the corresponding export modes: `"strip"`, `"keep"`, or `"remove"`. See also `get_file_export_mode`.

### `get_customized_files_count() -> int`
- 限定：qualifiers=const

Returns the number of files selected in the "Resources" tab of the export dialog.

### `get_encrypt_directory() -> bool`
- 限定：qualifiers=const

Returns `true` if PCK directory encryption is enabled in the export dialog.

### `get_encrypt_pck() -> bool`
- 限定：qualifiers=const

Returns `true` if PCK encryption is enabled in the export dialog.

### `get_encryption_ex_filter() -> String`
- 限定：qualifiers=const

Returns file filters to exclude during PCK encryption.

### `get_encryption_in_filter() -> String`
- 限定：qualifiers=const

Returns file filters to include during PCK encryption.

### `get_encryption_key() -> String`
- 限定：qualifiers=const

Returns PCK encryption key.

### `get_exclude_filter() -> String`
- 限定：qualifiers=const

Returns file filters to exclude during export.

### `get_export_filter() -> int`
- 限定：qualifiers=const

Returns export file filter mode selected in the "Resources" tab of the export dialog.

### `get_export_path() -> String`
- 限定：qualifiers=const

Returns export target path.

### `get_file_export_mode(path: String, default: int = 0) -> int`
- 限定：qualifiers=const

Returns file export mode for the specified file.

### `get_files_to_export() -> PackedStringArray`
- 限定：qualifiers=const

Returns array of files to export.

### `get_include_filter() -> String`
- 限定：qualifiers=const

Returns file filters to include during export.

### `get_or_env(name: StringName, env_var: String) -> Variant`
- 限定：qualifiers=const

Returns export option value or value of environment variable if it is set.

### `get_patches() -> PackedStringArray`
- 限定：qualifiers=const

Returns the list of packs on which to base a patch export on.

### `get_preset_name() -> String`
- 限定：qualifiers=const

Returns this export preset's name.

### `get_project_setting(name: StringName) -> Variant`

Returns the value of the setting identified by `name` using export preset feature tag overrides instead of current OS features.

### `get_script_export_mode() -> int`
- 限定：qualifiers=const

Returns the export mode used by GDScript files. `0` for "Text", `1` for "Binary tokens", and `2` for "Compressed binary tokens (smaller files)".

### `get_version(name: StringName, windows_version: bool) -> String`
- 限定：qualifiers=const

Returns the preset's version number, or fall back to the `ProjectSettings.application/config/version` project setting if set to an empty string.
				If `windows_version` is `true`, formats the returned version number to be compatible with Windows executable metadata.

### `has(property: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the preset has the property named `property`.

### `has_export_file(path: String) -> bool`

Returns `true` if the file at the specified `path` will be exported.

### `is_dedicated_server() -> bool`
- 限定：qualifiers=const

Returns `true` if the dedicated server export mode is selected in the export dialog.

### `is_runnable() -> bool`
- 限定：qualifiers=const

Returns `true` if the "Runnable" toggle is enabled in the export dialog.

## 枚举

### `ExportFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EXPORT_ALL_RESOURCES` |  |
| `1` | `EXPORT_SELECTED_SCENES` |  |
| `2` | `EXPORT_SELECTED_RESOURCES` |  |
| `3` | `EXCLUDE_SELECTED_RESOURCES` |  |
| `4` | `EXPORT_CUSTOMIZED` |  |

### `FileExportMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_FILE_NOT_CUSTOMIZED` |  |
| `1` | `MODE_FILE_STRIP` |  |
| `2` | `MODE_FILE_KEEP` |  |
| `3` | `MODE_FILE_REMOVE` |  |

### `ScriptExportMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_SCRIPT_TEXT` |  |
| `1` | `MODE_SCRIPT_BINARY_TOKENS` |  |
| `2` | `MODE_SCRIPT_BINARY_TOKENS_COMPRESSED` |  |

