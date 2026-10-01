# XROrigin3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XROrigin3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XROrigin3D.md`

**摘要**：The origin point in AR/VR.

## 描述

This is a special node within the AR/VR system that maps the physical location of the center of our tracking space to the virtual location within our game world.
		Multiple origin points can be added to the scene tree, but only one can used at a time. All the `XRCamera3D`, `XRController3D`, and `XRAnchor3D` nodes should be direct children of this node for spatial tracking to work correctly.
		It is the position of this node that you update when your character needs to move through your game world while we're not moving in the real world. Movement in the real world is always in relation to this origin point.
		For example, if your character is driving a car, the `XROrigin3D` node should be a child node of this car. Or, if you're implementing a teleport system to move your character, you should change the position of this node.

## 属性

- **`current`** `bool` = `false`
  - 其它属性：getter=is_current · setter=set_current
- **`world_scale`** `float` = `1.0`
  - 其它属性：getter=get_world_scale · setter=set_world_scale

## 教程链接

- [XR documentation index](None)

