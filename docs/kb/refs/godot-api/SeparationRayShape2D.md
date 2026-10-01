# SeparationRayShape2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`SeparationRayShape2D` → `Shape2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/SeparationRayShape2D.md`

**摘要**：A 2D ray shape used for physics collision that tries to separate itself from any collider.

## 描述

A 2D ray shape, intended for use in physics. Usually used to provide a shape for a `CollisionShape2D`. When a `SeparationRayShape2D` collides with an object, it tries to separate itself from it by moving its endpoint to the collision point. For example, a `SeparationRayShape2D` next to a character can allow it to instantly move up when touching stairs.

## 属性

- **`length`** `float` = `20.0`
  - 其它属性：getter=get_length · setter=set_length
- **`slide_on_slope`** `bool` = `false`
  - 其它属性：getter=get_slide_on_slope · setter=set_slide_on_slope

