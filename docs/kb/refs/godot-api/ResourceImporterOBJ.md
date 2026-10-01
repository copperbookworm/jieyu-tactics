# ResourceImporterOBJ

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterOBJ` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterOBJ.md`

**摘要**：Imports an OBJ 3D model as an independent `Mesh` or scene.

## 描述

Unlike `ResourceImporterScene`, `ResourceImporterOBJ` will import a single `Mesh` resource by default instead of importing a `PackedScene`. This makes it easier to use the `Mesh` resource in nodes that expect direct `Mesh` resources, such as `GridMap`, `GPUParticles3D` or `CPUParticles3D`. Note that it is still possible to save mesh resources from 3D scenes using the **Advanced Import Settings** dialog, regardless of the source format.
		See also `ResourceImporterScene`, which is used for more advanced 3D formats such as glTF.

## 属性

- **`force_disable_mesh_compression`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`generate_lightmap_uv2`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`generate_lightmap_uv2_texel_size`** `float` = `0.2`
  - 其它属性：getter= · setter=
- **`generate_lods`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`generate_shadow_mesh`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`generate_tangents`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`offset_mesh`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter= · setter=
- **`scale_mesh`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter= · setter=

## 教程链接

- [Importing 3D scenes](None)

