# XRFaceModifier3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRFaceModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/XRFaceModifier3D.md`

**摘要**：A node for driving standard face meshes from `XRFaceTracker` weights.

## 描述

This node applies weights from an `XRFaceTracker` to a mesh with supporting face blend shapes.
		The Unified Expressions (https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/unified-blendshapes) blend shapes are supported, as well as ARKit and SRanipal blend shapes.
		The node attempts to identify blend shapes based on name matching. Blend shapes should match the names listed in the Unified Expressions Compatibility (https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/compatibility/overview) chart.

## 属性

- **`face_tracker`** `StringName` = `&"/user/face_tracker"`
  - 其它属性：getter=get_face_tracker · setter=set_face_tracker
- **`target`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_target · setter=set_target

## 教程链接

- [XR documentation index](None)

