# DirectionalLight2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`DirectionalLight2D` → `Light2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=sun
> 自动生成，勿手改。文件：`refs/godot-api/DirectionalLight2D.md`

**摘要**：Directional 2D light from a distance.

## 描述

A directional light is a type of `Light2D` node that models an infinite number of parallel rays covering the entire scene. It is used for lights with strong intensity that are located far away from the scene (for example: to model sunlight or moonlight).
		Light is emitted in the +Y direction of the node's global basis. For an unrotated light, this means that the light is emitted downwards. The position of the node is ignored; only the basis is used to determine light direction.
		**Note:** `DirectionalLight2D` does not support light cull masks (but it supports shadow cull masks). It will always light up 2D nodes, regardless of the 2D node's `CanvasItem.light_mask`.

## 属性

- **`height`** `float` = `0.0`
  - 其它属性：getter=get_height · setter=set_height
- **`max_distance`** `float` = `10000.0`
  - 其它属性：getter=get_max_distance · setter=set_max_distance

## 教程链接

- [2D lights and shadows](None)

