# SubViewportContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SubViewportContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SubViewportContainer.md`

**摘要**：A container used for displaying the contents of a `SubViewport`.

## 描述

A container that displays the contents of underlying `SubViewport` child nodes. It uses the combined size of the `SubViewport`s as minimum size, unless `stretch` is enabled.
		**Note:** Changing a `SubViewportContainer`'s `Control.scale` will cause its contents to appear distorted. To change its visual size without causing distortion, adjust the node's margins instead (if it's not already in a container).
		**Note:** The `SubViewportContainer` forwards mouse-enter and mouse-exit notifications to its sub-viewports.

## 属性

- **`focus_mode`** `int` = `1` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`mouse_target`** `bool` = `false`
  - 其它属性：getter=is_mouse_target_enabled · setter=set_mouse_target
- **`stretch`** `bool` = `false`
  - 其它属性：getter=is_stretch_enabled · setter=set_stretch
- **`stretch_shrink`** `int` = `1`
  - 其它属性：getter=get_stretch_shrink · setter=set_stretch_shrink

## 方法

### `_propagate_input_event(event: InputEvent) -> bool`
- 限定：experimental= · qualifiers=virtual const

Virtual method to be implemented by the user. If it returns `true`, the `event` is propagated to `SubViewport` children. Propagation doesn't happen if it returns `false`. If the function is not implemented, all events are propagated to SubViewports.

