# GodotInstance

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GodotInstance` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GodotInstance.md`

**摘要**：Provides access to an embedded Godot instance.

## 描述

GodotInstance represents a running Godot instance that is controlled from an outside codebase, without a perpetual main loop. It is created by the C API `libgodot_create_godot_instance`. Only one may be created per process.

## 方法

### `focus_in() -> void`

Notifies the instance that it is now in focus.

### `focus_out() -> void`

Notifies the instance that it is now not in focus.

### `is_started() -> bool`

Returns `true` if this instance has been fully started.

### `iteration() -> bool`

Runs a single iteration of the main loop. Returns `true` if the engine is attempting to quit.

### `pause() -> void`

Notifies the instance that it is going to be paused.

### `resume() -> void`

Notifies the instance that it is being resumed.

### `start() -> bool`

Finishes this instance's startup sequence. Returns `true` on success.

