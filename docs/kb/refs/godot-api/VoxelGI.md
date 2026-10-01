# VoxelGI

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VoxelGI` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VoxelGI.md`

**摘要**：Real-time global illumination (GI) probe.

## 描述

`VoxelGI`s are used to provide high-quality real-time indirect light and reflections to scenes. They precompute the effect of objects that emit light and the effect of static geometry to simulate the behavior of complex light in real-time. `VoxelGI`s need to be baked before having a visible effect. However, once baked, dynamic objects will receive light from them. Furthermore, lights can be fully dynamic or baked.
		**Note:** `VoxelGI` is only supported in the Forward+ rendering method, not Mobile or Compatibility.
		**Procedural generation:** `VoxelGI` can be baked in an exported project, which makes it suitable for procedurally generated or user-built levels as long as all the geometry is generated in advance. For games where geometry is generated at any time during gameplay, SDFGI is more suitable (see `Environment.sdfgi_enabled`).
		**Performance:** `VoxelGI` is relatively demanding on the GPU and is not suited to low-end hardware such as integrated graphics (consider `LightmapGI` instead). To improve performance, adjust `ProjectSettings.rendering/global_illumination/voxel_gi/quality` and enable `ProjectSettings.rendering/global_illumination/gi/use_half_resolution` in the Project Settings. To provide a fallback for low-end hardware, consider adding an option to disable `VoxelGI` in your project's options menus. A `VoxelGI` node can be disabled by hiding it.
		**Note:** Meshes should have sufficiently thick walls to avoid light leaks (avoid one-sided walls). For interior levels, enclose your level geometry in a sufficiently large box and bridge the loops to close the mesh. To further prevent light leaks, you can also strategically place temporary `MeshInstance3D` nodes with their `GeometryInstance3D.gi_mode` set to `GeometryInstance3D.GI_MODE_STATIC`. These temporary nodes can then be hidden after baking the `VoxelGI` node.

## 属性

- **`camera_attributes`** `CameraAttributes`
  - 其它属性：getter=get_camera_attributes · setter=set_camera_attributes
- **`data`** `VoxelGIData`
  - 其它属性：getter=get_probe_data · setter=set_probe_data
- **`size`** `Vector3` = `Vector3(20, 20, 20)`
  - 其它属性：getter=get_size · setter=set_size
- **`subdiv`** `int` = `1` · 枚举 `VoxelGI.Subdiv`
  - 其它属性：getter=get_subdiv · setter=set_subdiv

## 方法

### `bake(from_node: Node = null, create_visual_debug: bool = false) -> void`

Bakes the effect from all `GeometryInstance3D`s marked with `GeometryInstance3D.GI_MODE_STATIC` and `Light3D`s marked with either `Light3D.BAKE_STATIC` or `Light3D.BAKE_DYNAMIC`. If `create_visual_debug` is `true`, after baking the light, this will generate a `MultiMesh` that has a cube representing each solid cell with each cube colored to the cell's albedo color. This can be used to visualize the `VoxelGI`'s data and debug any issues that may be occurring.
				**Note:** `bake` works from the editor and in exported projects. This makes it suitable for procedurally generated or user-built levels. Baking a `VoxelGI` node generally takes from 5 to 20 seconds in most scenes. Reducing `subdiv` can speed up baking.
				**Note:** `GeometryInstance3D`s and `Light3D`s must be fully ready before `bake` is called. If you are procedurally creating those and some meshes or lights are missing from your baked `VoxelGI`, use `call_deferred("bake")` instead of calling `bake` directly.

### `debug_bake() -> void`

Calls `bake` with `create_visual_debug` enabled.

## 枚举

### `Subdiv`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SUBDIV_64` |  |
| `1` | `SUBDIV_128` |  |
| `2` | `SUBDIV_256` |  |
| `3` | `SUBDIV_512` |  |
| `4` | `SUBDIV_MAX` |  |

## 教程链接

- [Using Voxel global illumination](None)
- [Third Person Shooter (TPS) Demo](None)

