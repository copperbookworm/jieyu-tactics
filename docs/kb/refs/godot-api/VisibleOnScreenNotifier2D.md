# VisibleOnScreenNotifier2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisibleOnScreenNotifier2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisibleOnScreenNotifier2D.md`

**摘要**：A rectangular region of 2D space that detects whether it is visible on screen.

## 描述

`VisibleOnScreenNotifier2D` represents a rectangular region of 2D space. When any part of this region becomes visible on screen or in a viewport, it will emit a `screen_entered` signal, and likewise it will emit a `screen_exited` signal when no part of it remains visible.
		If you want a node to be enabled automatically when this region is visible on screen, use `VisibleOnScreenEnabler2D`.
		**Note:** `VisibleOnScreenNotifier2D` uses the render culling code to determine whether it's visible on screen, so it won't function unless `CanvasItem.visible` is set to `true`.

## 属性

- **`rect`** `Rect2` = `Rect2(-10, -10, 20, 20)`
  - 其它属性：getter=get_rect · setter=set_rect
- **`show_rect`** `bool` = `true`
  - 其它属性：getter=is_showing_rect · setter=set_show_rect

## 方法

### `is_on_screen() -> bool`
- 限定：qualifiers=const

If `true`, the bounding rectangle is on the screen.
				**Note:** It takes one frame for the `VisibleOnScreenNotifier2D`'s visibility to be determined once added to the scene tree, so this method will always return `false` right after it is instantiated, before the draw pass.

## 信号

### `screen_entered()`

Emitted when the VisibleOnScreenNotifier2D enters the screen.

### `screen_exited()`

Emitted when the VisibleOnScreenNotifier2D exits the screen.

## 教程链接

- [2D Dodge The Creeps Demo](None)

