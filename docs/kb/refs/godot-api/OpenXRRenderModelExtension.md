# OpenXRRenderModelExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRRenderModelExtension` → `OpenXRExtensionWrapper` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRRenderModelExtension.md`

**摘要**：This class implements the OpenXR Render Model Extension.

## 描述

This class implements the OpenXR Render Model Extension, if enabled it will maintain a list of active render models and provides an interface to the render model data.

## 方法

### `is_active() -> bool`
- 限定：qualifiers=const

Returns `true` if OpenXR's render model extension is supported and enabled.
				**Note:** This only returns a valid value after OpenXR has been initialized.

### `render_model_create(render_model_id: int) -> RID`

Creates a render model object within OpenXR using a render model id.
				**Note:** This function is exposed for dependent OpenXR extensions that provide render model ids to be used with the render model extension.

### `render_model_destroy(render_model: RID) -> void`

Destroys a render model object within OpenXR that was previously created with `render_model_create`.
				**Note:** This function is exposed for dependent OpenXR extensions that provide render model ids to be used with the render model extension.

### `render_model_get_all() -> RID[]`

Returns an array of all currently active render models registered with this extension.

### `render_model_get_animatable_node_count(render_model: RID) -> int`
- 限定：qualifiers=const

Returns the number of animatable nodes this render model has.

### `render_model_get_animatable_node_name(render_model: RID, index: int) -> String`
- 限定：qualifiers=const

Returns the name of the given animatable node.

### `render_model_get_animatable_node_transform(render_model: RID, index: int) -> Transform3D`
- 限定：qualifiers=const

Returns the current local transform for an animatable node. This is updated every frame.

### `render_model_get_confidence(render_model: RID) -> int`
- 限定：qualifiers=const

Returns the tracking confidence of the tracking data for the render model.

### `render_model_get_root_transform(render_model: RID) -> Transform3D`
- 限定：qualifiers=const

Returns the root transform of a render model. This is the tracked position relative to our `XROrigin3D` node.

### `render_model_get_subaction_paths(render_model: RID) -> PackedStringArray`

Returns a list of active subaction paths for this `render_model`.
				**Note:** If different devices are bound to your actions than available in suggested interaction bindings, this information shows paths related to the interaction bindings being mimicked by that device.

### `render_model_get_top_level_path(render_model: RID) -> String`
- 限定：qualifiers=const

Returns the top level path associated with this `render_model`. If provided this identifies whether the render model is associated with the player's hands or other body part.

### `render_model_is_animatable_node_visible(render_model: RID, index: int) -> bool`
- 限定：qualifiers=const

Returns `true` if this animatable node should be visible.

### `render_model_new_scene_instance(render_model: RID) -> Node3D`
- 限定：qualifiers=const

Returns an instance of a subscene that contains all `MeshInstance3D` nodes that allow you to visualize the render model.

## 信号

### `render_model_added(render_model: RID)`

Emitted when a new render model is added.

### `render_model_removed(render_model: RID)`

Emitted when a render model is removed.

### `render_model_top_level_path_changed(render_model: RID)`

Emitted when the top level path associated with a render model changed.

