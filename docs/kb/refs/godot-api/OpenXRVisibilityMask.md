# OpenXRVisibilityMask

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRVisibilityMask` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRVisibilityMask.md`

**摘要**：Draws a stereo correct visibility mask.

## 描述

The visibility mask allows us to black out the part of the render result that is invisible due to lens distortion.
		As this is rendered first, it prevents fragments with expensive lighting calculations to be processed as they are discarded through z-checking.

