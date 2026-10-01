# Resource

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Resource.md`

**摘要**：Base class for serializable objects.

## 描述

Resource is the base class for all Godot-specific resource types, serving primarily as data containers. Since they inherit from `RefCounted`, resources are reference-counted and freed when no longer in use. They can also be nested within other resources, and saved on disk. `PackedScene`, one of the most common `Object`s in a Godot project, is also a resource, uniquely capable of storing and instantiating the `Node`s it contains as many times as desired.
		In GDScript, resources can loaded from disk by their `resource_path` using `@GDScript.load` or `@GDScript.preload`.
		The engine keeps a global cache of all loaded resources, referenced by paths (see `ResourceLoader.has_cached`). A resource will be cached when loaded for the first time and removed from cache once all references are released. When a resource is cached, subsequent loads using its path will return the cached reference.
		**Note:** In C#, resources will not be freed instantly after they are no longer in use. Instead, garbage collection will run periodically and will free resources that are no longer in use. This means that unused resources will remain in memory for a while before being removed.

## 属性

- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · setter=set_local_to_scene
- **`resource_name`** `String` = `""`
  - 其它属性：getter=get_name · setter=set_name
- **`resource_path`** `String` = `""`
  - 其它属性：getter=get_path · setter=set_path
- **`resource_scene_unique_id`** `String`
  - 其它属性：getter=get_scene_unique_id · setter=set_scene_unique_id

## 方法

### `_get_rid() -> RID`
- 限定：qualifiers=virtual const

Override this method to return a custom `RID` when `get_rid` is called.

### `_reset_state() -> void`
- 限定：qualifiers=virtual

For resources that store state in non-exported properties, such as via `Object._validate_property` or `Object._get_property_list`, this method must be implemented to clear them.

### `_set_path_cache(path: String) -> void`
- 限定：qualifiers=virtual const

Override this method to execute additional logic after `set_path_cache` is called on this object.

### `_setup_local_to_scene() -> void`
- 限定：qualifiers=virtual

Override this method to customize the newly duplicated resource created from `PackedScene.instantiate`, if the original's `resource_local_to_scene` is set to `true`.
				**Example:** Set a random `damage` value to every local resource from an instantiated scene:
				
```gdscript
				extends Resource

				var damage = 0

				func _setup_local_to_scene():
					damage = randi_range(10, 40)
				
```

### `copy_from_resource(resource: Resource) -> int`

Copies the data from `resource` into this resource. Both resources must share the same class.

### `duplicate(deep: bool = false) -> Resource`
- 限定：qualifiers=const

Duplicates this resource, returning a new resource with its `export`ed or `PROPERTY_USAGE_STORAGE` properties copied from the original.
				If `deep` is `false`, a **shallow** copy is returned: nested `Array`, `Dictionary`, and `Resource` properties are not duplicated and are shared with the original resource.
				If `deep` is `true`, a **deep** copy is returned: all nested arrays, dictionaries, and packed arrays are also duplicated (recursively). Any `Resource` found inside will only be duplicated if it's local, like `DEEP_DUPLICATE_INTERNAL` used with `duplicate_deep`.
				The following exceptions apply:
				- Subresource properties with the `PROPERTY_USAGE_ALWAYS_DUPLICATE` flag are always duplicated (recursively or not, depending on `deep`).
				- Subresource properties with the `PROPERTY_USAGE_NEVER_DUPLICATE` flag are never duplicated.
				**Note:** For custom resources, this method will fail if `Object._init` has been defined with required parameters.
				**Note:** When duplicating with `deep` set to `true`, each resource found, including the one on which this method is called, will be only duplicated once and referenced as many times as needed in the duplicate. For instance, if you are duplicating resource A that happens to have resource B referenced twice, you'll get a new resource A' referencing a new resource B' twice.

### `duplicate_deep(deep_subresources_mode: int = 1) -> Resource`
- 限定：qualifiers=const

Duplicates this resource, deeply, like `duplicate` when passing `true`, with extra control over how subresources are handled.

### `emit_changed() -> void`

Emits the `changed` signal. This method is called automatically for some built-in resources.
				**Note:** For custom resources, it's recommended to call this method whenever a meaningful change occurs, such as a modified property. This ensures that custom `Object`s depending on the resource are properly updated.
				
```gdscript
				var damage:
					set(new_value):
						if damage != new_value:
							damage = new_value
							emit_changed()
				
```

### `generate_scene_unique_id() -> String`
- 限定：qualifiers=static

Generates a unique identifier for a resource to be contained inside a `PackedScene`, based on the current date, time, and a random value. The returned string is only composed of letters (`a` to `y`) and numbers (`0` to `8`). See also `resource_scene_unique_id`.

### `get_id_for_path(path: String) -> String`
- 限定：qualifiers=const

From the internal cache for scene-unique IDs, returns the ID of this resource for the scene at `path`. If there is no entry, an empty string is returned. Useful to keep scene-unique IDs the same when implementing a VCS-friendly custom resource format by extending `ResourceFormatLoader` and `ResourceFormatSaver`.
				**Note:** This method is only implemented when running in an editor context. At runtime, it returns an empty string.

### `get_local_scene() -> Node`
- 限定：qualifiers=const

If `resource_local_to_scene` is set to `true` and the resource has been loaded from a `PackedScene` instantiation, returns the root `Node` of the scene where this resource is used. Otherwise, returns `null`.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the `RID` of this resource (or an empty RID). Many resources (such as `Texture2D`, `Mesh`, and so on) are high-level abstractions of resources stored in a specialized server (`DisplayServer`, `RenderingServer`, etc.), so this function will return the original `RID`.

### `is_built_in() -> bool`
- 限定：qualifiers=const

Returns `true` if the resource is saved on disk as a part of another resource's file.

### `reset_state() -> void`

Makes the resource clear its non-exported properties. See also `_reset_state`. Useful when implementing a custom resource format by extending `ResourceFormatLoader` and `ResourceFormatSaver`.

### `set_id_for_path(path: String, id: String) -> void`

In the internal cache for scene-unique IDs, sets the ID of this resource to `id` for the scene at `path`. If `id` is empty, the cache entry for `path` is cleared. Useful to keep scene-unique IDs the same when implementing a VCS-friendly custom resource format by extending `ResourceFormatLoader` and `ResourceFormatSaver`.
				**Note:** This method is only implemented when running in an editor context.

### `set_path_cache(path: String) -> void`

Sets the resource's path to `path` without involving the resource cache. Useful for handling `ResourceFormatLoader.CacheMode` values when implementing a custom resource format by extending `ResourceFormatLoader` and `ResourceFormatSaver`.

### `setup_local_to_scene() -> void`
- 限定：deprecated=This method should only be called internally.

Calls `_setup_local_to_scene`. If `resource_local_to_scene` is set to `true`, this method is automatically called from `PackedScene.instantiate` by the newly duplicated resource within the scene instance.

### `take_over_path(path: String) -> void`

Sets the `resource_path` to `path`, potentially overriding an existing cache entry for this path. Further attempts to load an overridden resource by path will instead return this resource.

## 信号

### `changed()`

Emitted when the resource changes, usually when one of its properties is modified. See also `emit_changed`.
				**Note:** This signal is not emitted automatically for properties of custom resources. If necessary, a setter needs to be created to emit the signal.

### `setup_local_to_scene_requested()`

Emitted by a newly duplicated resource with `resource_local_to_scene` set to `true`.

## 枚举

### `DeepDuplicateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEEP_DUPLICATE_NONE` |  |
| `1` | `DEEP_DUPLICATE_INTERNAL` |  |
| `2` | `DEEP_DUPLICATE_ALL` |  |

## 教程链接

- [Resources](None)
- [When and how to avoid using nodes for everything](None)

