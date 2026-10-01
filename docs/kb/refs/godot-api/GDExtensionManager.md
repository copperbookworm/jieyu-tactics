# GDExtensionManager

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDExtensionManager` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GDExtensionManager.md`

**摘要**：Provides access to GDExtension functionality.

## 描述

The GDExtensionManager loads, initializes, and keeps track of all available `GDExtension` libraries in the project.
		**Note:** Do not worry about GDExtension unless you know what you are doing.

## 方法

### `get_extension(path: String) -> GDExtension`

Returns the `GDExtension` at the given file `path`, or `null` if it has not been loaded or does not exist.

### `get_loaded_extensions() -> PackedStringArray`
- 限定：qualifiers=const

Returns the file paths of all currently loaded extensions.

### `is_extension_loaded(path: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the extension at the given file `path` has already been loaded successfully. See also `get_loaded_extensions`.

### `load_extension(path: String) -> int`

Loads an extension by absolute file path. The `path` needs to point to a valid `GDExtension`. Returns `LOAD_STATUS_OK` if successful.

### `load_extension_from_function(path: String, init_func: const GDExtensionInitializationFunction*) -> int`

Loads the extension already in address space via the given path and initialization function. The `path` needs to be unique and start with `"libgodot://"`. Returns `LOAD_STATUS_OK` if successful.

### `reload_extension(path: String) -> int`

Reloads the extension at the given file path. The `path` needs to point to a valid `GDExtension`, otherwise this method may return either `LOAD_STATUS_NOT_LOADED` or `LOAD_STATUS_FAILED`.
				**Note:** You can only reload extensions in the editor. In release builds, this method always fails and returns `LOAD_STATUS_FAILED`.

### `unload_extension(path: String) -> int`

Unloads an extension by file path. The `path` needs to point to an already loaded `GDExtension`, otherwise this method returns `LOAD_STATUS_NOT_LOADED`.

## 信号

### `extension_loaded(extension: GDExtension)`

Emitted after the editor has finished loading a new extension.
				**Note:** This signal is only emitted in editor builds.

### `extension_unloading(extension: GDExtension)`

Emitted before the editor starts unloading an extension.
				**Note:** This signal is only emitted in editor builds.

### `extensions_reloaded()`

Emitted after the editor has finished reloading one or more extensions.

## 枚举

### `LoadStatus`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOAD_STATUS_OK` |  |
| `1` | `LOAD_STATUS_FAILED` |  |
| `2` | `LOAD_STATUS_ALREADY_LOADED` |  |
| `3` | `LOAD_STATUS_NOT_LOADED` |  |
| `4` | `LOAD_STATUS_NEEDS_RESTART` |  |

## 教程链接

- [GDExtension overview](None)
- [GDExtension example in C++](None)

