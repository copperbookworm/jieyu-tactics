# RibbonTrailMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RibbonTrailMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RibbonTrailMesh.md`

**摘要**：Represents a straight ribbon-shaped `PrimitiveMesh` with variable width.

## 描述

`RibbonTrailMesh` represents a straight ribbon-shaped mesh with variable width. The ribbon is composed of a number of flat or cross-shaped sections, each with the same `section_length` and number of `section_segments`. A `curve` is sampled along the total length of the ribbon, meaning that the curve determines the size of the ribbon along its length.
		This primitive mesh is usually used for particle trails.

## 属性

- **`curve`** `Curve`
  - 其它属性：getter=get_curve · setter=set_curve
- **`section_length`** `float` = `0.2`
  - 其它属性：getter=get_section_length · setter=set_section_length
- **`section_segments`** `int` = `3`
  - 其它属性：getter=get_section_segments · setter=set_section_segments
- **`sections`** `int` = `5`
  - 其它属性：getter=get_sections · setter=set_sections
- **`shape`** `int` = `1` · 枚举 `RibbonTrailMesh.Shape`
  - 其它属性：getter=get_shape · setter=set_shape
- **`size`** `float` = `1.0`
  - 其它属性：getter=get_size · setter=set_size

## 枚举

### `Shape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHAPE_FLAT` |  |
| `1` | `SHAPE_CROSS` |  |

## 教程链接

- [3D Particle trails](None)
- [Particle systems (3D)](None)

