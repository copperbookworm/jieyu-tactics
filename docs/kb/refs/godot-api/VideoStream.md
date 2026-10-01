# VideoStream

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VideoStream` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VideoStream.md`

**摘要**：Base resource for video streams.

## 描述

Base resource type for all video streams. Classes that derive from `VideoStream` can all be used as resource types to play back videos in `VideoStreamPlayer`.

## 属性

- **`file`** `String` = `""`
  - 其它属性：getter=get_file · setter=set_file

## 方法

### `_instantiate_playback() -> VideoStreamPlayback`
- 限定：qualifiers=virtual required

Called when the video starts playing, to initialize and return a subclass of `VideoStreamPlayback`.

## 教程链接

- [Playing videos](None)
- [Runtime file loading and saving](None)

