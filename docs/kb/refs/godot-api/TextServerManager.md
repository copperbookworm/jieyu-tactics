# TextServerManager

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextServerManager` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextServerManager.md`

**摘要**：A singleton for managing `TextServer` implementations.

## 描述

`TextServerManager` is the API backend for loading, enumerating, and switching `TextServer`s.
		**Note:** Switching text server at runtime is possible, but will invalidate all fonts and text buffers. Make sure to unload all controls, fonts, and themes before doing so.

## 方法

### `add_interface(interface: TextServer) -> void`

Registers a `TextServer` interface.

### `find_interface(name: String) -> TextServer`
- 限定：qualifiers=const

Finds an interface by its `name`.

### `get_interface(idx: int) -> TextServer`
- 限定：qualifiers=const

Returns the interface registered at a given index.

### `get_interface_count() -> int`
- 限定：qualifiers=const

Returns the number of interfaces currently registered.

### `get_interfaces() -> Dictionary[]`
- 限定：qualifiers=const

Returns a list of available interfaces, with the index and name of each interface.

### `get_primary_interface() -> TextServer`
- 限定：qualifiers=const

Returns the primary `TextServer` interface currently in use.

### `remove_interface(interface: TextServer) -> void`

Removes an interface. All fonts and shaped text caches should be freed before removing an interface.

### `set_primary_interface(index: TextServer) -> void`

Sets the primary `TextServer` interface.

## 信号

### `interface_added(interface_name: StringName)`

Emitted when a new interface has been added.

### `interface_removed(interface_name: StringName)`

Emitted when an interface is removed.

