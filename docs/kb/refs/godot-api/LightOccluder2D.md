# LightOccluder2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`LightOccluder2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/LightOccluder2D.md`

**摘要**：Occludes light cast by a Light2D, casting shadows.

## 描述

Occludes light cast by a Light2D, casting shadows. The LightOccluder2D must be provided with an `OccluderPolygon2D` in order for the shadow to be computed.

## 属性

- **`occluder`** `OccluderPolygon2D`
  - 其它属性：getter=get_occluder_polygon · setter=set_occluder_polygon
- **`occluder_light_mask`** `int` = `1`
  - 其它属性：getter=get_occluder_light_mask · setter=set_occluder_light_mask
- **`sdf_collision`** `bool` = `true`
  - 其它属性：getter=is_set_as_sdf_collision · setter=set_as_sdf_collision

## 教程链接

- [2D lights and shadows](None)

