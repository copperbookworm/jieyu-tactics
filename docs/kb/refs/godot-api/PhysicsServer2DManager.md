# PhysicsServer2DManager

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PhysicsServer2DManager` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PhysicsServer2DManager.md`

**摘要**：A singleton for managing `PhysicsServer2D` implementations.

## 描述

`PhysicsServer2DManager` is the API for registering `PhysicsServer2D` implementations and for setting the default implementation.
		**Note:** It is not possible to switch physics servers at runtime. This class is only used on startup at the server initialization level, by Godot itself and possibly by GDExtensions.

## 方法

### `register_server(name: String, create_callback: Callable) -> void`

Register a `PhysicsServer2D` implementation by passing a `name` and a `Callable` that returns a `PhysicsServer2D` object.

### `set_default_server(name: String, priority: int) -> void`

Set the default `PhysicsServer2D` implementation to the one identified by `name`, if `priority` is greater than the priority of the current default implementation.

