# FileSystemDock

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FileSystemDock` → `EditorDock` → `MarginContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/FileSystemDock.md`

**摘要**：Godot editor's dock for managing files in the project.

## 描述

This class is available only in `EditorPlugin`s and can't be instantiated. You can access it using `EditorInterface.get_file_system_dock`.
		While `FileSystemDock` doesn't expose any methods for file manipulation, it can listen for various file-related signals.

## 方法

### `add_resource_tooltip_plugin(plugin: EditorResourceTooltipPlugin) -> void`

Registers a new `EditorResourceTooltipPlugin`.

### `navigate_to_path(path: String) -> void`

Sets the given `path` as currently selected, ensuring that the selected file/directory is visible.

### `remove_resource_tooltip_plugin(plugin: EditorResourceTooltipPlugin) -> void`

Removes an `EditorResourceTooltipPlugin`. Fails if the plugin wasn't previously added.

## 信号

### `display_mode_changed()`

Emitted when the user switches file display mode or split mode.

### `file_removed(file: String)`

Emitted when the given `file` was removed.

### `files_moved(old_file: String, new_file: String)`

Emitted when a file is moved from `old_file` path to `new_file` path.

### `folder_color_changed()`

Emitted when folders change color.

### `folder_moved(old_folder: String, new_folder: String)`

Emitted when a folder is moved from `old_folder` path to `new_folder` path.

### `folder_removed(folder: String)`

Emitted when the given `folder` was removed.

### `inherit(file: String)`

Emitted when a new scene is created that inherits the scene at `file` path.

### `instantiate(files: PackedStringArray)`

Emitted when the given scenes are being instantiated in the editor.

### `resource_removed(resource: Resource)`

Emitted when an external `resource` had its file removed.

### `selection_changed()`

Emitted when the selection changes. Use `EditorInterface.get_selected_paths` in the connected method to get the selected paths.

