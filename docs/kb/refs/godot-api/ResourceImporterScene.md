# ResourceImporterScene

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ResourceImporterScene` → `ResourceImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/ResourceImporterScene.md`

**摘要**：Imports a glTF, FBX, COLLADA, or Blender 3D scene.

## 描述

See also `ResourceImporterOBJ`, which is used for OBJ models that can be imported as an independent `Mesh` or a scene.
		Additional options (such as extracting individual meshes or materials to files) are available in the **Advanced Import Settings** dialog. This dialog can be accessed by double-clicking a 3D scene in the FileSystem dock or by selecting a 3D scene in the FileSystem dock, going to the Import dock and choosing **Advanced**.
		**Note:** `ResourceImporterScene` is *not* used for `PackedScene`s, such as `.tscn` and `.scn` files.

## 属性

- **`_subresources`** `Dictionary` = `{}`
  - 其它属性：getter= · setter=
- **`animation/fps`** `float` = `30`
  - 其它属性：getter= · setter=
- **`animation/import`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`animation/import_rest_as_RESET`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`animation/remove_immutable_tracks`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`animation/trimming`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`array_mesh/deduplicate_surfaces`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`import_script/path`** `String` = `""`
  - 其它属性：getter= · setter=
- **`materials/extract`** `int` = `0`
  - 其它属性：getter= · setter=
- **`materials/extract_format`** `int` = `0`
  - 其它属性：getter= · setter=
- **`materials/extract_path`** `String` = `""`
  - 其它属性：getter= · setter=
- **`mesh_library/use_node_names_as_mesh_names`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`meshes/create_shadow_meshes`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`meshes/ensure_tangents`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`meshes/force_disable_compression`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`meshes/generate_lods`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`meshes/light_baking`** `int` = `1`
  - 其它属性：getter= · setter=
- **`meshes/lightmap_texel_size`** `float` = `0.2`
  - 其它属性：getter= · setter=
- **`nodes/apply_root_scale`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`nodes/import_as_skeleton_bones`** `bool` = `false`
  - 其它属性：getter= · setter=
- **`nodes/root_name`** `String` = `""`
  - 其它属性：getter= · setter=
- **`nodes/root_scale`** `float` = `1.0`
  - 其它属性：getter= · setter=
- **`nodes/root_script`** `Script` = `null`
  - 其它属性：getter= · setter=
- **`nodes/root_type`** `String` = `""`
  - 其它属性：getter= · setter=
- **`nodes/use_name_suffixes`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`nodes/use_node_type_suffixes`** `bool` = `true`
  - 其它属性：getter= · setter=
- **`skins/use_named_skins`** `bool` = `true`
  - 其它属性：getter= · setter=

## 教程链接

- [Importing 3D scenes](None)

