# SubViewport

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SubViewport` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SubViewport.md`

**摘要**：An interface to a game world that doesn't create a window or draw to the screen directly.

## 描述

`SubViewport` Isolates a rectangular region of a scene to be displayed independently. This can be used, for example, to display UI in 3D space.
		**Note:** `SubViewport` is a `Viewport` that isn't a `Window`, i.e. it doesn't draw anything by itself. To display anything, `SubViewport` must have a non-zero size and be either put inside a `SubViewportContainer` or assigned to a `ViewportTexture`.
		**Note:** `InputEvent`s are not passed to a standalone `SubViewport` by default. To ensure `InputEvent` propagation, a `SubViewport` can be placed inside of a `SubViewportContainer`.

## 属性

- **`render_target_clear_mode`** `int` = `0` · 枚举 `SubViewport.ClearMode`
  - 其它属性：getter=get_clear_mode · setter=set_clear_mode
- **`render_target_update_mode`** `int` = `2` · 枚举 `SubViewport.UpdateMode`
  - 其它属性：getter=get_update_mode · setter=set_update_mode
- **`size`** `Vector2i` = `Vector2i(512, 512)`
  - 其它属性：getter=get_size · setter=set_size
- **`size_2d_override`** `Vector2i` = `Vector2i(0, 0)`
  - 其它属性：getter=get_size_2d_override · setter=set_size_2d_override
- **`size_2d_override_stretch`** `bool` = `false`
  - 其它属性：getter=is_size_2d_override_stretch_enabled · setter=set_size_2d_override_stretch
- **`view_count`** `int` = `1`
  - 其它属性：getter=get_view_count · setter=set_view_count

## 枚举

### `ClearMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CLEAR_MODE_ALWAYS` |  |
| `1` | `CLEAR_MODE_NEVER` |  |
| `2` | `CLEAR_MODE_ONCE` |  |

### `UpdateMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UPDATE_DISABLED` |  |
| `1` | `UPDATE_ONCE` |  |
| `2` | `UPDATE_WHEN_VISIBLE` |  |
| `3` | `UPDATE_WHEN_PARENT_VISIBLE` |  |
| `4` | `UPDATE_ALWAYS` |  |

## 教程链接

- [Using Viewports](None)
- [Viewport and canvas transforms](None)
- [GUI in 3D Viewport Demo](None)
- [3D in 2D Viewport Demo](None)
- [2D in 3D Viewport Demo](None)
- [Screen Capture Demo](None)
- [Dynamic Split Screen Demo](None)
- [3D Resolution Scaling Demo](None)

