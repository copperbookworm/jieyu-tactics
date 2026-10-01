# PlaneMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PlaneMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PlaneMesh.md`

**摘要**：Class representing a planar `PrimitiveMesh`.

## 描述

Class representing a planar `PrimitiveMesh`. This flat mesh does not have a thickness. By default, this mesh is aligned on the X and Z axes; this default rotation isn't suited for use with billboarded materials. For billboarded materials, change `orientation` to `FACE_Z`.
		**Note:** When using a large textured `PlaneMesh` (e.g. as a floor), you may stumble upon UV jittering issues depending on the camera angle. To solve this, increase `subdivide_depth` and `subdivide_width` until you no longer notice UV jittering.

## 属性

- **`center_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_center_offset · setter=set_center_offset
- **`orientation`** `int` = `1` · 枚举 `PlaneMesh.Orientation`
  - 其它属性：getter=get_orientation · setter=set_orientation
- **`size`** `Vector2` = `Vector2(2, 2)`
  - 其它属性：getter=get_size · setter=set_size
- **`subdivide_depth`** `int` = `0`
  - 其它属性：getter=get_subdivide_depth · setter=set_subdivide_depth
- **`subdivide_width`** `int` = `0`
  - 其它属性：getter=get_subdivide_width · setter=set_subdivide_width

## 枚举

### `Orientation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FACE_X` |  |
| `1` | `FACE_Y` |  |
| `2` | `FACE_Z` |  |

