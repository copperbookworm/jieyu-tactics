# GDExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDExtension` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GDExtension.md`

**摘要**：A native library for GDExtension.

## 描述

The `GDExtension` resource type represents a shared library (https://en.wikipedia.org/wiki/Shared_library) which can expand the functionality of the engine. The `GDExtensionManager` singleton is responsible for loading, reloading, and unloading `GDExtension` resources.
		**Note:** GDExtension itself is not a scripting language and has no relation to `GDScript` resources.

## 方法

### `get_minimum_library_initialization_level() -> int`
- 限定：qualifiers=const

Returns the lowest level required for this extension to be properly initialized (see the `InitializationLevel` enum).

### `is_library_open() -> bool`
- 限定：qualifiers=const

Returns `true` if this extension's library has been opened.

## 枚举

### `InitializationLevel`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INITIALIZATION_LEVEL_CORE` |  |
| `1` | `INITIALIZATION_LEVEL_SERVERS` |  |
| `2` | `INITIALIZATION_LEVEL_SCENE` |  |
| `3` | `INITIALIZATION_LEVEL_EDITOR` |  |

## 教程链接

- [GDExtension overview](None)
- [GDExtension example in C++](None)

