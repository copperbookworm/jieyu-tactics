# OpenXRRenderModelManager

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRRenderModelManager` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRRenderModelManager.md`

**摘要**：Helper node that will automatically manage displaying render models.

## 描述

This helper node will automatically manage displaying render models. It will create new `OpenXRRenderModel` nodes as controllers and other hand held devices are detected, and remove those nodes when they are deactivated.
		**Note:** If you want more control over this logic you can alternatively call `OpenXRRenderModelExtension.render_model_get_all` to obtain a list of active render model ids and create `OpenXRRenderModel` instances for each render model id provided.

## 属性

- **`make_local_to_pose`** `String` = `""`
  - 其它属性：getter=get_make_local_to_pose · setter=set_make_local_to_pose
- **`tracker`** `int` = `0` · 枚举 `OpenXRRenderModelManager.RenderModelTracker`
  - 其它属性：getter=get_tracker · setter=set_tracker

## 信号

### `render_model_added(render_model: OpenXRRenderModel)`

Emitted when a render model node is added as a child to this node.

### `render_model_removed(render_model: OpenXRRenderModel)`

Emitted when a render model child node is about to be removed from this node.

## 枚举

### `RenderModelTracker`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RENDER_MODEL_TRACKER_ANY` |  |
| `1` | `RENDER_MODEL_TRACKER_NONE_SET` |  |
| `2` | `RENDER_MODEL_TRACKER_LEFT_HAND` |  |
| `3` | `RENDER_MODEL_TRACKER_RIGHT_HAND` |  |

