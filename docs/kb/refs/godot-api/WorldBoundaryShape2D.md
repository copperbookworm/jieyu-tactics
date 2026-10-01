# WorldBoundaryShape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WorldBoundaryShape2D` → `Shape2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WorldBoundaryShape2D.md`

**摘要**：A 2D world boundary (half-plane) shape used for physics collision.

## 描述

A 2D world boundary shape, intended for use in physics. `WorldBoundaryShape2D` works like an infinite straight line that forces all physics bodies to stay above it. The line's normal determines which direction is considered as "above" and in the editor, the smaller line over it represents this direction. It can for example be used for endless flat floors.

## 属性

- **`distance`** `float` = `0.0`
  - 其它属性：getter=get_distance · setter=set_distance
- **`normal`** `Vector2` = `Vector2(0, -1)`
  - 其它属性：getter=get_normal · setter=set_normal

