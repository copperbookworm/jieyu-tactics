# AudioListener3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AudioListener3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sound
> 自动生成，勿手改。文件：`refs/godot-api/AudioListener3D.md`

**摘要**：Overrides the location sounds are heard from.

## 描述

Once added to the scene tree and enabled using `make_current`, this node will override the location sounds are heard from. This can be used to listen from a location different from the `Camera3D`.

## 属性

- **`doppler_tracking`** `int` = `0` · 枚举 `AudioListener3D.DopplerTracking`
  - 其它属性：getter=get_doppler_tracking · setter=set_doppler_tracking

## 方法

### `clear_current() -> void`

Disables the listener to use the current camera's listener instead.

### `get_listener_transform() -> Transform3D`
- 限定：qualifiers=const

Returns the listener's global orthonormalized `Transform3D`.

### `is_current() -> bool`
- 限定：qualifiers=const

Returns `true` if the listener was made current using `make_current`, `false` otherwise.
				**Note:** There may be more than one AudioListener3D marked as "current" in the scene tree, but only the one that was made current last will be used.

### `make_current() -> void`

Enables the listener. This will override the current camera's listener.

## 枚举

### `DopplerTracking`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DOPPLER_TRACKING_DISABLED` |  |
| `1` | `DOPPLER_TRACKING_IDLE_STEP` |  |
| `2` | `DOPPLER_TRACKING_PHYSICS_STEP` |  |

