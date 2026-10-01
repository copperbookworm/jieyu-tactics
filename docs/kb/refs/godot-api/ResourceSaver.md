# ResourceSaver

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceSaver` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourceSaver.md`

**摘要**：A singleton for saving `Resource`s to the filesystem.

## 描述

A singleton for saving resource types to the filesystem.
		It uses the many `ResourceFormatSaver` classes registered in the engine (either built-in or from a plugin) to save resource data to text-based (e.g. `.tres` or `.tscn`) or binary files (e.g. `.res` or `.scn`).

## 方法

### `add_resource_format_saver(format_saver: ResourceFormatSaver, at_front: bool = false) -> void`

Registers a new `ResourceFormatSaver`. The ResourceSaver will use the ResourceFormatSaver as described in `save`.
				This method is performed implicitly for ResourceFormatSavers written in GDScript (see `ResourceFormatSaver` for more information).

### `get_recognized_extensions(type: Resource) -> PackedStringArray`

Returns the list of extensions available for saving a resource of a given type.

### `get_resource_id_for_path(path: String, generate: bool = false) -> int`

Returns the resource ID for the given path. If `generate` is `true`, a new resource ID will be generated if one for the path is not found. If `generate` is `false` and the path is not found, `ResourceUID.INVALID_ID` is returned.

### `remove_resource_format_saver(format_saver: ResourceFormatSaver) -> void`

Unregisters the given `ResourceFormatSaver`.

### `save(resource: Resource, path: String = "", flags: int = 0) -> int`

Saves a resource to disk to the given path, using a `ResourceFormatSaver` that recognizes the resource object. If `path` is empty, `ResourceSaver` will try to use `Resource.resource_path`.
				The `flags` bitmask can be specified to customize the save behavior.
				Returns `OK` on success.
				**Note:** When the project is running, any generated UID associated with the resource will not be saved as the required code is only executed in editor mode.

### `set_uid(resource: String, uid: int) -> int`

Sets the UID of the given `resource` path to `uid`. You can generate a new UID using `ResourceUID.create_id`.
				Since resources will normally get a UID automatically, this method is only useful in very specific cases.

## 枚举

### `SaverFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FLAG_NONE` | （位标志） |
| `1` | `FLAG_RELATIVE_PATHS` | （位标志） |
| `2` | `FLAG_BUNDLE_RESOURCES` | （位标志） |
| `4` | `FLAG_CHANGE_PATH` | （位标志） |
| `8` | `FLAG_OMIT_EDITOR_PROPERTIES` | （位标志） |
| `16` | `FLAG_SAVE_BIG_ENDIAN` | （位标志） |
| `32` | `FLAG_COMPRESS` | （位标志） |
| `64` | `FLAG_REPLACE_SUBRESOURCE_PATHS` | （位标志） |

