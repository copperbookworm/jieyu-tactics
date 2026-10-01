# BackBufferCopy

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BackBufferCopy` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BackBufferCopy.md`

**摘要**：A node that copies a region of the screen to a buffer for access in shader code.

## 描述

Node for back-buffering the currently-displayed screen. The region defined in the `BackBufferCopy` node is buffered with the content of the screen it covers, or the entire screen according to the `copy_mode`. It can be accessed in shader scripts using the screen texture (i.e. a uniform sampler with `hint_screen_texture`).
		**Note:** Since this node inherits from `Node2D` (and not `Control`), anchors and margins won't apply to child `Control`-derived nodes. This can be problematic when resizing the window. To avoid this, add `Control`-derived nodes as *siblings* to the `BackBufferCopy` node instead of adding them as children.

## 属性

- **`copy_mode`** `int` = `1` · 枚举 `BackBufferCopy.CopyMode`
  - 其它属性：getter=get_copy_mode · setter=set_copy_mode
- **`rect`** `Rect2` = `Rect2(-100, -100, 200, 200)`
  - 其它属性：getter=get_rect · setter=set_rect

## 枚举

### `CopyMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COPY_MODE_DISABLED` |  |
| `1` | `COPY_MODE_RECT` |  |
| `2` | `COPY_MODE_VIEWPORT` |  |

## 教程链接

- [Screen-reading shaders](None)

