# ResourceFormatSaver

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceFormatSaver` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourceFormatSaver.md`

**摘要**：Saves a specific resource type to a file.

## 描述

The engine can save resources when you do it from the editor, or when you use the `ResourceSaver` singleton. This is accomplished thanks to multiple `ResourceFormatSaver`s, each handling its own format and called automatically by the engine.
		By default, Godot saves resources as `.tres` (text-based), `.res` (binary) or another built-in format, but you can choose to create your own format by extending this class. Be sure to respect the documented return types and values. You should give it a global class name with `class_name` for it to be registered. Like built-in ResourceFormatSavers, it will be called automatically when saving resources of its recognized type(s). You may also implement a `ResourceFormatLoader`.

## 方法

### `_get_recognized_extensions(resource: Resource) -> PackedStringArray`
- 限定：qualifiers=virtual const

Returns the list of extensions available for saving the resource object, provided it is recognized (see `_recognize`).

### `_recognize(resource: Resource) -> bool`
- 限定：qualifiers=virtual const

Returns whether the given resource object can be saved by this saver.

### `_recognize_path(resource: Resource, path: String) -> bool`
- 限定：qualifiers=virtual const

Returns `true` if this saver handles a given save path and `false` otherwise.
				If this method is not implemented, the default behavior returns whether the path's extension is within the ones provided by `_get_recognized_extensions`.

### `_save(resource: Resource, path: String, flags: int) -> int`
- 限定：qualifiers=virtual

Saves the given resource object to a file at the target `path`. `flags` is a bitmask composed with `ResourceSaver.SaverFlags` constants.
				Returns `OK` on success, or an `Error` constant in case of failure.

### `_set_uid(path: String, uid: int) -> int`
- 限定：qualifiers=virtual

Sets a new UID for the resource at the given `path`. Returns `OK` on success, or an `Error` constant in case of failure.

