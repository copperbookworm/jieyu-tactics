# Joint2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Joint2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Joint2D.md`

**摘要**：Abstract base class for all 2D physics joints.

## 描述

Abstract base class for all joints in 2D physics. 2D joints bind together two physics bodies (`node_a` and `node_b`) and apply a constraint.

## 属性

- **`bias`** `float` = `0.0`
  - 其它属性：getter=get_bias · setter=set_bias
- **`disable_collision`** `bool` = `true`
  - 其它属性：getter=get_exclude_nodes_from_collision · setter=set_exclude_nodes_from_collision
- **`node_a`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_node_a · setter=set_node_a
- **`node_b`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_node_b · setter=set_node_b

## 方法

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the joint's internal `RID` from the `PhysicsServer2D`.

