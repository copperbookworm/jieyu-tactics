# CSGPolygon3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CSGPolygon3D` → `CSGPrimitive3D` → `CSGShape3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CSGPolygon3D.md`

**摘要**：Extrudes a 2D polygon shape to create a 3D mesh.

## 描述

An array of 2D points is extruded to quickly and easily create a variety of 3D meshes. See also `CSGMesh3D` for using 3D meshes as CSG nodes.
		**Note:** CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a `MeshInstance3D` with a `PrimitiveMesh`. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## 属性

- **`depth`** `float` = `1.0`
  - 其它属性：getter=get_depth · setter=set_depth
- **`material`** `Material`
  - 其它属性：getter=get_material · setter=set_material
- **`mode`** `int` = `0` · 枚举 `CSGPolygon3D.Mode`
  - 其它属性：getter=get_mode · setter=set_mode
- **`path_continuous_u`** `bool`
  - 其它属性：getter=is_path_continuous_u · setter=set_path_continuous_u
- **`path_interval`** `float`
  - 其它属性：getter=get_path_interval · setter=set_path_interval
- **`path_interval_type`** `int` · 枚举 `CSGPolygon3D.PathIntervalType`
  - 其它属性：getter=get_path_interval_type · setter=set_path_interval_type
- **`path_joined`** `bool`
  - 其它属性：getter=is_path_joined · setter=set_path_joined
- **`path_local`** `bool`
  - 其它属性：getter=is_path_local · setter=set_path_local
- **`path_node`** `NodePath`
  - 其它属性：getter=get_path_node · setter=set_path_node
- **`path_rotation`** `int` · 枚举 `CSGPolygon3D.PathRotation`
  - 其它属性：getter=get_path_rotation · setter=set_path_rotation
- **`path_rotation_accurate`** `bool`
  - 其它属性：getter=get_path_rotation_accurate · setter=set_path_rotation_accurate
- **`path_simplify_angle`** `float`
  - 其它属性：getter=get_path_simplify_angle · setter=set_path_simplify_angle
- **`path_u_distance`** `float`
  - 其它属性：getter=get_path_u_distance · setter=set_path_u_distance
- **`polygon`** `PackedVector2Array` = `PackedVector2Array(0, 0, 0, 1, 1, 1, 1, 0)`
  - 其它属性：getter=get_polygon · setter=set_polygon
- **`smooth_faces`** `bool` = `false`
  - 其它属性：getter=get_smooth_faces · setter=set_smooth_faces
- **`spin_degrees`** `float`
  - 其它属性：getter=get_spin_degrees · setter=set_spin_degrees
- **`spin_sides`** `int`
  - 其它属性：getter=get_spin_sides · setter=set_spin_sides

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_DEPTH` |  |
| `1` | `MODE_SPIN` |  |
| `2` | `MODE_PATH` |  |

### `PathRotation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATH_ROTATION_POLYGON` |  |
| `1` | `PATH_ROTATION_PATH` |  |
| `2` | `PATH_ROTATION_PATH_FOLLOW` |  |

### `PathIntervalType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PATH_INTERVAL_DISTANCE` |  |
| `1` | `PATH_INTERVAL_SUBDIVIDE` |  |

## 教程链接

- [Prototyping levels with CSG](None)

