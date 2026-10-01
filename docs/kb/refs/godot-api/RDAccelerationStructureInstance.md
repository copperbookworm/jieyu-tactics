# RDAccelerationStructureInstance

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RDAccelerationStructureInstance` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/RDAccelerationStructureInstance.md`

**摘要**：Acceleration structure instance (used by `RenderingDevice`).

## 描述

`RDAccelerationStructureInstance` describes an instance of a Bottom-Level Acceleration Structure (BLAS) used in the `RenderingDevice.tlas_build` method.

## 属性

- **`blas`** `RID` = `RID()`
  - 其它属性：getter=get_blas · setter=set_blas
- **`flags`** `int` = `0` · 枚举 `RenderingDevice.AccelerationStructureInstanceFlagBits` · 位标志
  - 其它属性：getter=get_flags · is_bitfield=true · setter=set_flags
- **`hit_sbt_range`** `int` = `0`
  - 其它属性：getter=get_hit_sbt_range · setter=set_hit_sbt_range
- **`id`** `int` = `0`
  - 其它属性：getter=get_id · setter=set_id
- **`mask`** `int` = `255`
  - 其它属性：getter=get_mask · setter=set_mask
- **`transform`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_transform · setter=set_transform

