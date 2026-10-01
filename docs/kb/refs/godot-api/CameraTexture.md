# CameraTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraTexture.md`

**摘要**：Texture provided by a `CameraFeed`.

## 描述

This texture gives access to the camera texture provided by a `CameraFeed`.
		**Note:** Many cameras supply YCbCr images which need to be converted in a shader.

## 属性

- **`camera_feed_id`** `int` = `0`
  - 其它属性：getter=get_camera_feed_id · setter=set_camera_feed_id
- **`camera_is_active`** `bool` = `false`
  - 其它属性：getter=get_camera_active · setter=set_camera_active
- **`resource_local_to_scene`** `bool` = `false`
  - 其它属性：getter=is_local_to_scene · overrides=Resource · setter=set_local_to_scene
- **`which_feed`** `int` = `0` · 枚举 `CameraServer.FeedImage`
  - 其它属性：getter=get_which_feed · setter=set_which_feed

