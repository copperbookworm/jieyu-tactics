# TubeTrailMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TubeTrailMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TubeTrailMesh.md`

**摘要**：Represents a straight tube-shaped `PrimitiveMesh` with variable width.

## 描述

`TubeTrailMesh` represents a straight tube-shaped mesh with variable width. The tube is composed of a number of cylindrical sections, each with the same `section_length` and number of `section_rings`. A `curve` is sampled along the total length of the tube, meaning that the curve determines the radius of the tube along its length.
		This primitive mesh is usually used for particle trails.

## 属性

- **`cap_bottom`** `bool` = `true`
  - 其它属性：getter=is_cap_bottom · setter=set_cap_bottom
- **`cap_top`** `bool` = `true`
  - 其它属性：getter=is_cap_top · setter=set_cap_top
- **`curve`** `Curve`
  - 其它属性：getter=get_curve · setter=set_curve
- **`radial_steps`** `int` = `8`
  - 其它属性：getter=get_radial_steps · setter=set_radial_steps
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius
- **`section_length`** `float` = `0.2`
  - 其它属性：getter=get_section_length · setter=set_section_length
- **`section_rings`** `int` = `3`
  - 其它属性：getter=get_section_rings · setter=set_section_rings
- **`sections`** `int` = `5`
  - 其它属性：getter=get_sections · setter=set_sections

## 教程链接

- [3D Particle trails](None)
- [Particle systems (3D)](None)

