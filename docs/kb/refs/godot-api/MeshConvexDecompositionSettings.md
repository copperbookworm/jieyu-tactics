# MeshConvexDecompositionSettings

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MeshConvexDecompositionSettings` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MeshConvexDecompositionSettings.md`

**摘要**：Parameters to be used with a `Mesh` convex decomposition operation.

## 描述

Parameters to be used with a `Mesh` convex decomposition operation.

## 属性

- **`convex_hull_approximation`** `bool` = `true`
  - 其它属性：getter=get_convex_hull_approximation · setter=set_convex_hull_approximation
- **`convex_hull_downsampling`** `int` = `4`
  - 其它属性：getter=get_convex_hull_downsampling · setter=set_convex_hull_downsampling
- **`max_concavity`** `float` = `1.0`
  - 其它属性：getter=get_max_concavity · setter=set_max_concavity
- **`max_convex_hulls`** `int` = `1`
  - 其它属性：getter=get_max_convex_hulls · setter=set_max_convex_hulls
- **`max_num_vertices_per_convex_hull`** `int` = `32`
  - 其它属性：getter=get_max_num_vertices_per_convex_hull · setter=set_max_num_vertices_per_convex_hull
- **`min_volume_per_convex_hull`** `float` = `0.0001`
  - 其它属性：getter=get_min_volume_per_convex_hull · setter=set_min_volume_per_convex_hull
- **`mode`** `int` = `0` · 枚举 `MeshConvexDecompositionSettings.Mode`
  - 其它属性：getter=get_mode · setter=set_mode
- **`normalize_mesh`** `bool` = `false`
  - 其它属性：getter=get_normalize_mesh · setter=set_normalize_mesh
- **`plane_downsampling`** `int` = `4`
  - 其它属性：getter=get_plane_downsampling · setter=set_plane_downsampling
- **`project_hull_vertices`** `bool` = `true`
  - 其它属性：getter=get_project_hull_vertices · setter=set_project_hull_vertices
- **`resolution`** `int` = `10000`
  - 其它属性：getter=get_resolution · setter=set_resolution
- **`revolution_axes_clipping_bias`** `float` = `0.05`
  - 其它属性：getter=get_revolution_axes_clipping_bias · setter=set_revolution_axes_clipping_bias
- **`symmetry_planes_clipping_bias`** `float` = `0.05`
  - 其它属性：getter=get_symmetry_planes_clipping_bias · setter=set_symmetry_planes_clipping_bias

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONVEX_DECOMPOSITION_MODE_VOXEL` |  |
| `1` | `CONVEX_DECOMPOSITION_MODE_TETRAHEDRON` |  |

