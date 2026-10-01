# ResourceUID

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceUID` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourceUID.md`

**摘要**：A singleton that manages the unique identifiers of all resources within a project.

## 描述

Resource UIDs (Unique IDentifiers) allow the engine to keep references between resources intact, even if files are renamed or moved. They can be accessed with `uid://`.
		`ResourceUID` keeps track of all registered resource UIDs in a project, generates new UIDs, and converts between their string and integer representations.

## 方法

### `add_id(id: int, path: String) -> void`

Adds a new UID value which is mapped to the given resource path.
				Fails with an error if the UID already exists, so be sure to check `has_id` beforehand, or use `set_id` instead.

### `create_id() -> int`

Generates a random resource UID which is guaranteed to be unique within the list of currently loaded UIDs.
				In order for this UID to be registered, you must call `add_id` or `set_id`.

### `create_id_for_path(path: String) -> int`

Like `create_id`, but the UID is seeded with the provided `path` and project name. UIDs generated for that path will be always the same within the current project.

### `ensure_path(path_or_uid: String) -> String`
- 限定：qualifiers=static

Returns a path, converting `path_or_uid` if necessary. Fails and returns an empty string if an invalid UID is provided.

### `get_id_path(id: int) -> String`
- 限定：qualifiers=const

Returns the path that the given UID value refers to.
				Fails with an error if the UID does not exist, so be sure to check `has_id` beforehand.

### `has_id(id: int) -> bool`
- 限定：qualifiers=const

Returns whether the given UID value is known to the cache.

### `id_to_text(id: int) -> String`
- 限定：qualifiers=const

Converts the given UID to a `uid://` string value.

### `path_to_uid(path: String) -> String`
- 限定：qualifiers=static

Converts the provided resource `path` to a UID. Returns the unchanged path if it has no associated UID.

### `remove_id(id: int) -> void`

Removes a loaded UID value from the cache.
				Fails with an error if the UID does not exist, so be sure to check `has_id` beforehand.

### `set_id(id: int, path: String) -> void`

Updates the resource path of an existing UID.
				Fails with an error if the UID does not exist, so be sure to check `has_id` beforehand, or use `add_id` instead.

### `text_to_id(text_id: String) -> int`
- 限定：qualifiers=const

Extracts the UID value from the given `uid://` string.

### `uid_to_path(uid: String) -> String`
- 限定：qualifiers=static

Converts the provided `uid` to a path. Prints an error if the UID is invalid.

## 常量

- **`INVALID_ID`** = `-1`
