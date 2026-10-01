# VisibleOnScreenNotifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisibleOnScreenNotifier3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisibleOnScreenNotifier3D.md`

**摘要**：A box-shaped region of 3D space that detects whether it is visible on screen.

## 描述

`VisibleOnScreenNotifier3D` represents a box-shaped region of 3D space. When any part of this region becomes visible on screen or in a `Camera3D`'s view, it will emit a `screen_entered` signal, and likewise it will emit a `screen_exited` signal when no part of it remains visible.
		If you want a node to be enabled automatically when this region is visible on screen, use `VisibleOnScreenEnabler3D`.
		**Note:** `VisibleOnScreenNotifier3D` uses an approximate heuristic that doesn't take walls and other occlusion into account, unless occlusion culling is used. It also won't function unless `Node3D.visible` is set to `true`.

## 属性

- **`aabb`** `AABB` = `AABB(-1, -1, -1, 2, 2, 2)`
  - 其它属性：getter=get_aabb · setter=set_aabb

## 方法

### `is_on_screen() -> bool`
- 限定：qualifiers=const

Returns `true` if the bounding box is on the screen.
				**Note:** It takes one frame for the `VisibleOnScreenNotifier3D`'s visibility to be assessed once added to the scene tree, so this method will always return `false` right after it is instantiated.

## 信号

### `screen_entered()`

Emitted when the `VisibleOnScreenNotifier3D` enters the screen.

### `screen_exited()`

Emitted when the `VisibleOnScreenNotifier3D` exits the screen.

