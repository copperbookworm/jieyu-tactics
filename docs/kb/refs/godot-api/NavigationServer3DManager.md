# NavigationServer3DManager

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationServer3DManager` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/NavigationServer3DManager.md`

**摘要**：A singleton for managing `NavigationServer3D` implementations.

## 描述

`NavigationServer3DManager` is the API for registering `NavigationServer3D` implementations and setting the default implementation.
		**Note:** It is not possible to switch servers at runtime. This class is only used on startup at the server initialization level.

## 方法

### `register_server(name: String, create_callback: Callable) -> void`

Registers a `NavigationServer3D` implementation by passing a `name` and a `Callable` that returns a `NavigationServer3D` object.

### `set_default_server(name: String, priority: int) -> void`

Sets the default `NavigationServer3D` implementation to the one identified by `name`, if `priority` is greater than the priority of the current default implementation.

