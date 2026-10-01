# Joint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Joint3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Joint3D.md`

**摘要**：Abstract base class for all 3D physics joints.

## 描述

Abstract base class for all joints in 3D physics. 3D joints bind together two physics bodies (`node_a` and `node_b`) and apply a constraint. If only one body is defined, it is attached to a fixed `StaticBody3D` without collision shapes.

## 属性

- **`exclude_nodes_from_collision`** `bool` = `true`
  - 其它属性：getter=get_exclude_nodes_from_collision · setter=set_exclude_nodes_from_collision
- **`node_a`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_node_a · setter=set_node_a
- **`node_b`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_node_b · setter=set_node_b
- **`solver_priority`** `int` = `1`
  - 其它属性：getter=get_solver_priority · setter=set_solver_priority

## 方法

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the joint's internal `RID` from the `PhysicsServer3D`.

## 教程链接

- [3D Truck Town Demo](None)

