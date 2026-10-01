# EditorSceneFormatImporterBlend

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSceneFormatImporterBlend` → `EditorSceneFormatImporter` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSceneFormatImporterBlend.md`

**摘要**：Importer for Blender's `.blend` scene file format.

## 描述

Imports Blender scenes in the `.blend` file format through the glTF 2.0 3D import pipeline. This importer requires Blender to be installed by the user, so that it can be used to export the scene as glTF 2.0.
		The location of the Blender binary is set via the `EditorSettings.filesystem/import/blender/blender_path` setting.
		This importer is only used if `ProjectSettings.filesystem/import/blender/enabled` is enabled, otherwise `.blend` files present in the project folder are not imported.
		Blend import requires Blender 3.0.
		Internally, the EditorSceneFormatImporterBlend uses the Blender glTF "Use Original" mode to reference external textures.

