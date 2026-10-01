# ResourcePreloader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourcePreloader` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ResourcePreloader.md`

**摘要**：A node used to preload sub-resources inside a scene.

## 描述

This node is used to preload sub-resources inside a scene, so when the scene is loaded, all the resources are ready to use and can be retrieved from the preloader. You can add the resources using the ResourcePreloader tab when the node is selected.
		GDScript has a simplified `@GDScript.preload` built-in method which can be used in most situations, leaving the use of `ResourcePreloader` for more advanced scenarios.

## 方法

### `add_resource(name: StringName, resource: Resource) -> void`

Adds a resource to the preloader with the given `name`. If a resource with the given `name` already exists, the new resource will be renamed to "`name` N" where N is an incrementing number starting from 2.

### `get_resource(name: StringName) -> Resource`
- 限定：qualifiers=const

Returns the resource associated to `name`.

### `get_resource_list() -> PackedStringArray`
- 限定：qualifiers=const

Returns the list of resources inside the preloader.

### `has_resource(name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the preloader contains a resource associated to `name`.

### `remove_resource(name: StringName) -> void`

Removes the resource associated to `name` from the preloader.

### `rename_resource(name: StringName, newname: StringName) -> void`

Renames a resource inside the preloader from `name` to `newname`.

