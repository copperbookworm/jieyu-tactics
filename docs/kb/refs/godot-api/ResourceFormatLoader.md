# ResourceFormatLoader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceFormatLoader` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourceFormatLoader.md`

**摘要**：Loads a specific resource type from a file.

## 描述

Godot loads resources in the editor or in exported games using ResourceFormatLoaders. They are queried automatically via the `ResourceLoader` singleton, or when a resource with internal dependencies is loaded. Each file type may load as a different resource type, so multiple ResourceFormatLoaders are registered in the engine.
		Extending this class allows you to define your own loader. Be sure to respect the documented return types and values. You should give it a global class name with `class_name` for it to be registered. Like built-in ResourceFormatLoaders, it will be called automatically when loading resources of its handled type(s). You may also implement a `ResourceFormatSaver`.
		**Note:** You can also extend `EditorImportPlugin` if the resource type you need exists but Godot is unable to load its format. Choosing one way over another depends on if the format is suitable or not for the final exported game. For example, it's better to import `.png` textures as `.ctex` (`CompressedTexture2D`) first, so they can be loaded with better efficiency on the graphics card.

## 方法

### `_exists(path: String) -> bool`
- 限定：qualifiers=virtual const

### `_get_classes_used(path: String) -> PackedStringArray`
- 限定：qualifiers=virtual const

### `_get_dependencies(path: String, add_types: bool) -> PackedStringArray`
- 限定：qualifiers=virtual const

Should return the dependencies for the resource at the given `path`. Each dependency is a string composed of one to three sections separated by `::`, with trailing empty sections omitted:
				- The first section should contain the UID if the resource has one. Otherwise, it should contain the file path.
				- The second section should contain the class name of the dependency if `add_types` is `true`. Otherwise, it should be empty.
				- The third section should contain the fallback path if the resource has a UID. Otherwise, it should be empty.
				
```gdscript
				func _get_dependencies(path, add_types):
					return [
						"uid://fqgvuwrkuixh::Script::res://script.gd",
						"uid://fqgvuwrkuixh::::res://script.gd",
						"res://script.gd::Script",
						"res://script.gd",
					]
				
```

				**Note:** Custom resource types defined by scripts aren't known by the `ClassDB`, so `"Resource"` can be used for the class name.

### `_get_recognized_extensions() -> PackedStringArray`
- 限定：qualifiers=virtual const

Gets the list of extensions for files this loader is able to read.

### `_get_resource_script_class(path: String) -> String`
- 限定：qualifiers=virtual const

Returns the script class name associated with the `Resource` under the given `path`. If the resource has no script or the script isn't a named class, it should return `""`.

### `_get_resource_type(path: String) -> String`
- 限定：qualifiers=virtual const

Gets the class name of the resource associated with the given path. If the loader cannot handle it, it should return `""`.
				**Note:** Custom resource types defined by scripts aren't known by the `ClassDB`, so you might just return `"Resource"` for them.

### `_get_resource_uid(path: String) -> int`
- 限定：qualifiers=virtual const

Should return the unique ID for the resource associated with the given path. If this method is not overridden, a `.uid` file is generated along with the resource file, containing the unique ID.

### `_handles_type(type: StringName) -> bool`
- 限定：qualifiers=virtual const

Tells which resource class this loader can load.
				**Note:** Custom resource types defined by scripts aren't known by the `ClassDB`, so you might just handle `"Resource"` for them.

### `_load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant`
- 限定：qualifiers=virtual required const

Loads a resource when the engine finds this loader to be compatible. If the loaded resource is the result of an import, `original_path` will target the source file. Returns a `Resource` object on success, or an `Error` constant in case of failure.
				The `cache_mode` property defines whether and how the cache should be used or updated when loading the resource. See `CacheMode` for details.

### `_recognize_path(path: String, type: StringName) -> bool`
- 限定：qualifiers=virtual const

Tells whether or not this loader should load a resource from its resource path for a given type.
				If it is not implemented, the default behavior returns whether the path's extension is within the ones provided by `_get_recognized_extensions`, and if the type is within the ones provided by `_get_resource_type`.

### `_rename_dependencies(path: String, renames: Dictionary) -> int`
- 限定：qualifiers=virtual const

If implemented, renames dependencies within the given resource and saves it. `renames` is a dictionary `{ String => String }` mapping old dependency paths to new paths.
				Returns `OK` on success, or an `Error` constant in case of failure.

## 枚举

### `CacheMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CACHE_MODE_IGNORE` |  |
| `1` | `CACHE_MODE_REUSE` |  |
| `2` | `CACHE_MODE_REPLACE` |  |
| `3` | `CACHE_MODE_IGNORE_DEEP` |  |
| `4` | `CACHE_MODE_REPLACE_DEEP` |  |

