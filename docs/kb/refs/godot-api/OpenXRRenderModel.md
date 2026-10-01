# OpenXRRenderModel

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRRenderModel` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRRenderModel.md`

**摘要**：This node will display an OpenXR render model.

## 描述

This node will display an OpenXR render model by accessing the associated GLTF and processes all animation data (if supported by the XR runtime).
		Render models were introduced to allow showing the correct model for the controller (or other device) the user has in hand, since the OpenXR action map does not provide information about the hardware used by the user. Note that while the controller (or device) can be somewhat inferred by the bound action map profile, this is a dangerous approach as the user may be using hardware not known at time of development and OpenXR will simply simulate an available interaction profile.

## 属性

- **`render_model`** `RID` = `RID()`
  - 其它属性：getter=get_render_model · setter=set_render_model

## 方法

### `get_top_level_path() -> String`
- 限定：qualifiers=const

Returns the top level path related to this render model.

## 信号

### `render_model_top_level_path_changed()`

Emitted when the top level path of this render model has changed.

