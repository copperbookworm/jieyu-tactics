# BoxMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoxMesh` → `PrimitiveMesh` → `Mesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoxMesh.md`

**摘要**：Generate an axis-aligned box `PrimitiveMesh`.

## 描述

Generate an axis-aligned box `PrimitiveMesh`.
		The box's UV layout is arranged in a 3×2 layout that allows texturing each face individually. To apply the same texture on all faces, change the material's UV property to `Vector3(3, 2, 1)`. This is equivalent to adding `UV *= vec2(3.0, 2.0)` in a vertex shader.
		**Note:** When using a large textured `BoxMesh` (e.g. as a floor), you may stumble upon UV jittering issues depending on the camera angle. To solve this, increase `subdivide_depth`, `subdivide_height` and `subdivide_width` until you no longer notice UV jittering.

## 属性

- **`size`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_size · setter=set_size
- **`subdivide_depth`** `int` = `0`
  - 其它属性：getter=get_subdivide_depth · setter=set_subdivide_depth
- **`subdivide_height`** `int` = `0`
  - 其它属性：getter=get_subdivide_height · setter=set_subdivide_height
- **`subdivide_width`** `int` = `0`
  - 其它属性：getter=get_subdivide_width · setter=set_subdivide_width

