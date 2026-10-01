# WorldBoundaryShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WorldBoundaryShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WorldBoundaryShape3D.md`

**摘要**：A 3D world boundary (half-space) shape used for physics collision.

## 描述

A 3D world boundary shape, intended for use in physics. `WorldBoundaryShape3D` works like an infinite plane that forces all physics bodies to stay above it. The `plane`'s normal determines which direction is considered as "above" and in the editor, the line over the plane represents this direction. It can for example be used for endless flat floors.
		**Note:** When the physics engine is set to **Jolt Physics** in the project settings (`ProjectSettings.physics/3d/physics_engine`), `WorldBoundaryShape3D` has a finite size (centered at the shape's origin). It can be adjusted by changing `ProjectSettings.physics/jolt_physics_3d/limits/world_boundary_shape_size`.

## 属性

- **`plane`** `Plane` = `Plane(0, 1, 0, 0)`
  - 其它属性：getter=get_plane · setter=set_plane

