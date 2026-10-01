# RDHitGroup

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDHitGroup` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/RDHitGroup.md`

**摘要**：Hit group (used by `RenderingDevice`).

## 描述

Defines a hit group for use with `RenderingDevice.raytracing_pipeline_create`.
		A hit group combines shaders that are executed when a ray intersects geometry. It may include a closest-hit shader, any-hit shader, and intersection shader.
		Hit groups are referenced by index when populating hit shader binding tables using `RenderingDevice.hit_sbt_range_update`.

## 属性

- **`any_hit_shader`** `RDPipelineShader`
  - 其它属性：getter=get_any_hit_shader · setter=set_any_hit_shader
- **`closest_hit_shader`** `RDPipelineShader`
  - 其它属性：getter=get_closest_hit_shader · setter=set_closest_hit_shader
- **`intersection_shader`** `RDPipelineShader`
  - 其它属性：getter=get_intersection_shader · setter=set_intersection_shader

