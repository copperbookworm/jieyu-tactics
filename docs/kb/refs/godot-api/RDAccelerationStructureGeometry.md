# RDAccelerationStructureGeometry

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDAccelerationStructureGeometry` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/RDAccelerationStructureGeometry.md`

**摘要**：Acceleration structure geometry (used by `RenderingDevice`).

## 描述

`RDAccelerationStructureGeometry` describes a set of triangles used as raytracing geometry in the `RenderingDevice.blas_create` method.
		The geometry is always in triangle list form, either indexed or non-indexed. Triangle strips are not supported.

## 属性

- **`flags`** `int` = `0` · 枚举 `RenderingDevice.AccelerationStructureGeometryFlagBits` · 位标志
  - 其它属性：getter=get_flags · is_bitfield=true · setter=set_flags
- **`index_buffer`** `RID` = `RID()`
  - 其它属性：getter=get_index_buffer · setter=set_index_buffer
- **`index_count`** `int` = `0`
  - 其它属性：getter=get_index_count · setter=set_index_count
- **`index_offset`** `int` = `0`
  - 其它属性：getter=get_index_offset · setter=set_index_offset
- **`vertex_buffer`** `RID` = `RID()`
  - 其它属性：getter=get_vertex_buffer · setter=set_vertex_buffer
- **`vertex_count`** `int` = `0`
  - 其它属性：getter=get_vertex_count · setter=set_vertex_count
- **`vertex_format`** `int` = `232` · 枚举 `RenderingDevice.DataFormat`
  - 其它属性：getter=get_vertex_format · setter=set_vertex_format
- **`vertex_offset`** `int` = `0`
  - 其它属性：getter=get_vertex_offset · setter=set_vertex_offset
- **`vertex_stride`** `int` = `0`
  - 其它属性：getter=get_vertex_stride · setter=set_vertex_stride

