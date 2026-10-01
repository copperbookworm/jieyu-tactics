# EditorExportPlatform

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorExportPlatform` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorExportPlatform.md`

**摘要**：Identifies a supported export platform, and internally provides the functionality of exporting to that platform.

## 描述

Base resource that provides the functionality of exporting a release build of a project to a platform, from the editor. Stores platform-specific metadata such as the name and supported features of the platform, and performs the exporting of projects, PCK files, and ZIP files. Uses an export template for the platform provided at the time of project exporting.
		Used in scripting by `EditorExportPlugin` to configure platform-specific customization of scenes and resources. See `EditorExportPlugin._begin_customize_scenes` and `EditorExportPlugin._begin_customize_resources` for more details.

## 方法

### `add_message(type: int, category: String, message: String) -> void`

Adds a message to the export log that will be displayed when exporting ends.

### `clear_messages() -> void`

Clears the export log.

### `create_preset() -> EditorExportPreset`

Create a new preset for this platform.

### `export_pack(preset: EditorExportPreset, debug: bool, path: String, flags: int = 0) -> int`

Creates a PCK archive at `path` for the specified `preset`.

### `export_pack_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: int = 0) -> int`

Creates a patch PCK archive at `path` for the specified `preset`, containing only the files that have changed since the last patch.
				**Note:** `patches` is an optional override of the set of patches defined in the export preset. When empty the patches defined in the export preset will be used instead.

### `export_project(preset: EditorExportPreset, debug: bool, path: String, flags: int = 0, notify: bool = true) -> int`

Creates a full project at `path` for the specified `preset`. If `notify` is `true`, plugins using `EditorExportPlugin._export_begin` will be called during the process.

### `export_project_files(preset: EditorExportPreset, debug: bool, save_cb: Callable, shared_cb: Callable = Callable()) -> int`

Exports project files for the specified preset. This method can be used to implement custom export format, other than PCK and ZIP. One of the callbacks is called for each exported file.
				`save_cb` is called for all exported files and have the following arguments: `file_path: String`, `file_data: PackedByteArray`, `file_index: int`, `file_count: int`, `encryption_include_filters: PackedStringArray`, `encryption_exclude_filters: PackedStringArray`, `encryption_key: PackedByteArray`.
				`shared_cb` is called for exported native shared/static libraries and have the following arguments: `file_path: String`, `tags: PackedStringArray`, `target_folder: String`.
				**Note:** `file_index` and `file_count` are intended for progress tracking only and aren't necessarily unique and precise.

### `export_zip(preset: EditorExportPreset, debug: bool, path: String, flags: int = 0) -> int`

Create a ZIP archive at `path` for the specified `preset`.

### `export_zip_patch(preset: EditorExportPreset, debug: bool, path: String, patches: PackedStringArray = PackedStringArray(), flags: int = 0) -> int`

Create a patch ZIP archive at `path` for the specified `preset`, containing only the files that have changed since the last patch.
				**Note:** `patches` is an optional override of the set of patches defined in the export preset. When empty the patches defined in the export preset will be used instead.

### `find_export_template(template_file_name: String) -> Dictionary`
- 限定：qualifiers=const

Locates export template for the platform, and returns `Dictionary` with the following keys: `path: String` and `error: String`. This method is provided for convenience and custom export platforms aren't required to use it or keep export templates stored in the same way official templates are.

### `gen_export_flags(flags: int) -> PackedStringArray`

Generates array of command line arguments for the default export templates for the debug flags and editor settings.

### `get_current_presets() -> Array`
- 限定：qualifiers=const

Returns array of `EditorExportPreset`s for this platform.

### `get_forced_export_files(preset: EditorExportPreset = null) -> PackedStringArray`
- 限定：qualifiers=static

Returns array of core file names that always should be exported regardless of preset config.

### `get_internal_export_files(preset: EditorExportPreset, debug: bool) -> Dictionary`

Returns additional files that should always be exported regardless of preset configuration, and are not part of the project source. The returned `Dictionary` contains filename keys (`String`) and their corresponding raw data (`PackedByteArray`).

### `get_message_category(index: int) -> String`
- 限定：qualifiers=const

Returns the message category for the message with the given `index`.

### `get_message_count() -> int`
- 限定：qualifiers=const

Returns the number of messages in the export log.

### `get_message_text(index: int) -> String`
- 限定：qualifiers=const

Returns the text for the message with the given `index`.

### `get_message_type(index: int) -> int`
- 限定：qualifiers=const

Returns the type for the message with the given `index`.

### `get_os_name() -> String`
- 限定：qualifiers=const

Returns the name of the export operating system handled by this `EditorExportPlatform` class, as a friendly string. Possible return values are `Windows`, `Linux`, `macOS`, `Android`, `iOS`, and `Web`.

### `get_worst_message_type() -> int`
- 限定：qualifiers=const

Returns most severe message type currently present in the export log.

### `save_pack(preset: EditorExportPreset, debug: bool, path: String, embed: bool = false) -> Dictionary`

Saves PCK archive and returns `Dictionary` with the following keys: `result: Error`, `so_files: Array` (array of the shared/static objects which contains dictionaries with the following keys: `path: String`, `tags: PackedStringArray`, and `target_folder: String`).
				If `embed` is `true`, PCK content is appended to the end of `path` file and return `Dictionary` additionally include following keys: `embedded_start: int` (embedded PCK offset) and `embedded_size: int` (embedded PCK size).

### `save_pack_patch(preset: EditorExportPreset, debug: bool, path: String) -> Dictionary`

Saves patch PCK archive and returns `Dictionary` with the following keys: `result: Error`, `so_files: Array` (array of the shared/static objects which contains dictionaries with the following keys: `path: String`, `tags: PackedStringArray`, and `target_folder: String`).

### `save_zip(preset: EditorExportPreset, debug: bool, path: String) -> Dictionary`

Saves ZIP archive and returns `Dictionary` with the following keys: `result: Error`, `so_files: Array` (array of the shared/static objects which contains dictionaries with the following keys: `path: String`, `tags: PackedStringArray`, and `target_folder: String`).

### `save_zip_patch(preset: EditorExportPreset, debug: bool, path: String) -> Dictionary`

Saves patch ZIP archive and returns `Dictionary` with the following keys: `result: Error`, `so_files: Array` (array of the shared/static objects which contains dictionaries with the following keys: `path: String`, `tags: PackedStringArray`, and `target_folder: String`).

### `ssh_push_to_remote(host: String, port: String, scp_args: PackedStringArray, src_file: String, dst_file: String) -> int`
- 限定：qualifiers=const

Uploads specified file over SCP protocol to the remote host.

### `ssh_run_on_remote(host: String, port: String, ssh_arg: PackedStringArray, cmd_args: String, output: Array = [], port_fwd: int = -1) -> int`
- 限定：qualifiers=const

Executes specified command on the remote host via SSH protocol and returns command output in the `output`.

### `ssh_run_on_remote_no_wait(host: String, port: String, ssh_args: PackedStringArray, cmd_args: String, port_fwd: int = -1) -> int`
- 限定：qualifiers=const

Executes specified command on the remote host via SSH protocol and returns process ID (on the remote host) without waiting for command to finish.

## 枚举

### `ExportMessageType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EXPORT_MESSAGE_NONE` |  |
| `1` | `EXPORT_MESSAGE_INFO` |  |
| `2` | `EXPORT_MESSAGE_WARNING` |  |
| `3` | `EXPORT_MESSAGE_ERROR` |  |

### `DebugFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `DEBUG_FLAG_DUMB_CLIENT` | （位标志） |
| `2` | `DEBUG_FLAG_REMOTE_DEBUG` | （位标志） |
| `4` | `DEBUG_FLAG_REMOTE_DEBUG_LOCALHOST` | （位标志） |
| `8` | `DEBUG_FLAG_VIEW_COLLISIONS` | （位标志） |
| `16` | `DEBUG_FLAG_VIEW_NAVIGATION` | （位标志） |

