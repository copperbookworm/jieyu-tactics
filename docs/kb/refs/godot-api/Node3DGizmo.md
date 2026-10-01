# Node3DGizmo

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Node3DGizmo` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Node3DGizmo.md`

**摘要**：Abstract class to expose editor gizmos for `Node3D`.

## 描述

This abstract class helps connect the `Node3D` scene with the editor-specific `EditorNode3DGizmo` class.
		`Node3DGizmo` by itself has no exposed API, refer to `Node3D.add_gizmo` and pass it an `EditorNode3DGizmo` instance.

