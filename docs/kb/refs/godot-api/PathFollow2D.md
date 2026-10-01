# PathFollow2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PathFollow2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PathFollow2D.md`

**摘要**：Point sampler for a `Path2D`.

## 描述

This node takes its parent `Path2D`, and returns the coordinates of a point within it, given a distance from the first vertex.
		It is useful for making other nodes follow a path, without coding the movement pattern. For that, the nodes must be children of this node. The descendant nodes will then move accordingly when setting the `progress` in this node.

## 属性

- **`cubic_interp`** `bool` = `true`
  - 其它属性：getter=get_cubic_interpolation · setter=set_cubic_interpolation
- **`h_offset`** `float` = `0.0`
  - 其它属性：getter=get_h_offset · setter=set_h_offset
- **`loop`** `bool` = `true`
  - 其它属性：getter=has_loop · setter=set_loop
- **`progress`** `float` = `0.0`
  - 其它属性：getter=get_progress · setter=set_progress
- **`progress_ratio`** `float` = `0.0`
  - 其它属性：getter=get_progress_ratio · setter=set_progress_ratio
- **`rotates`** `bool` = `true`
  - 其它属性：getter=is_rotating · setter=set_rotates
- **`v_offset`** `float` = `0.0`
  - 其它属性：getter=get_v_offset · setter=set_v_offset

