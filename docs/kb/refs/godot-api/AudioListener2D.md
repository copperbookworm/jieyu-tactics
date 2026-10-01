# AudioListener2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioListener2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sound
> 自动生成，勿手改。文件：`refs/godot-api/AudioListener2D.md`

**摘要**：Overrides the location sounds are heard from.

## 描述

Once added to the scene tree and enabled using `make_current`, this node will override the location sounds are heard from. Only one `AudioListener2D` can be current. Using `make_current` will disable the previous `AudioListener2D`.
		If there is no active `AudioListener2D` in the current `Viewport`, center of the screen will be used as a hearing point for the audio. `AudioListener2D` needs to be inside `SceneTree` to function.

## 方法

### `clear_current() -> void`

Disables the `AudioListener2D`. If it's not set as current, this method will have no effect.

### `is_current() -> bool`
- 限定：qualifiers=const

Returns `true` if this `AudioListener2D` is currently active.

### `make_current() -> void`

Makes the `AudioListener2D` active, setting it as the hearing point for the sounds. If there is already another active `AudioListener2D`, it will be disabled.
				This method will have no effect if the `AudioListener2D` is not added to `SceneTree`.

