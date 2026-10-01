# EditorSceneFormatImporterFBX2GLTF

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSceneFormatImporterFBX2GLTF` → `EditorSceneFormatImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSceneFormatImporterFBX2GLTF.md`

**摘要**：Importer for the `.fbx` scene file format.

## 描述

Imports Autodesk FBX 3D scenes by way of converting them to glTF 2.0 using the FBX2glTF command line tool.
		The location of the FBX2glTF binary is set via the `EditorSettings.filesystem/import/fbx/fbx2gltf_path` editor setting.
		This importer is only used if `ProjectSettings.filesystem/import/fbx2gltf/enabled` is set to `true`.

