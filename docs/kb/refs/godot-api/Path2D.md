# Path2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Path2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Path2D.md`

**摘要**：Contains a `Curve2D` path for `PathFollow2D` nodes to follow.

## 描述

Can have `PathFollow2D` child nodes moving along the `Curve2D`. See `PathFollow2D` for more information on usage.
		**Note:** The path is considered as relative to the moved nodes (children of `PathFollow2D`). As such, the curve should usually start with a zero vector (`(0, 0)`).

## 属性

- **`curve`** `Curve2D`
  - 其它属性：getter=get_curve · setter=set_curve

