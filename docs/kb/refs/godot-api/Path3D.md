# Path3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Path3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Path3D.md`

**摘要**：Contains a `Curve3D` path for `PathFollow3D` nodes to follow.

## 描述

Can have `PathFollow3D` child nodes moving along the `Curve3D`. See `PathFollow3D` for more information on the usage.
		Note that the path is considered as relative to the moved nodes (children of `PathFollow3D`). As such, the curve should usually start with a zero vector `(0, 0, 0)`.

## 属性

- **`curve`** `Curve3D`
  - 其它属性：getter=get_curve · setter=set_curve
- **`debug_custom_color`** `Color` = `Color(0, 0, 0, 1)`
  - 其它属性：getter=get_debug_custom_color · setter=set_debug_custom_color

## 信号

### `curve_changed()`

Emitted when the `curve` changes.

### `debug_color_changed()`

Emitted when the `debug_custom_color` changes.

