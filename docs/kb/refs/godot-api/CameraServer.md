# CameraServer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraServer` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraServer.md`

**摘要**：Server keeping track of different cameras accessible in Godot.

## 描述

The `CameraServer` keeps track of different cameras accessible in Godot. These are external cameras such as webcams or the cameras on your phone.
		It is notably used to provide AR modules with a video feed from the camera.
		**Note:** This class is currently only implemented on Linux, Android, macOS, and iOS. On other platforms no `CameraFeed`s will be available. To get a `CameraFeed` on iOS, enable `EditorExportPlatformIOS.modules/camera`.

## 属性

- **`monitoring_feeds`** `bool` = `false`
  - 其它属性：getter=is_monitoring_feeds · setter=set_monitoring_feeds

## 方法

### `add_feed(feed: CameraFeed) -> void`

Adds the camera `feed` to the camera server.

### `feeds() -> CameraFeed[]`

Returns an array of `CameraFeed`s.

### `get_feed(index: int) -> CameraFeed`

Returns the `CameraFeed` corresponding to the camera with the given `index`.

### `get_feed_count() -> int`

Returns the number of `CameraFeed`s registered.

### `remove_feed(feed: CameraFeed) -> void`

Removes the specified camera `feed`.

## 信号

### `camera_feed_added(id: int)`

Emitted when a `CameraFeed` is added (e.g. a webcam is plugged in).

### `camera_feed_removed(id: int)`

Emitted when a `CameraFeed` is removed (e.g. a webcam is unplugged).

### `camera_feeds_updated()`

Emitted when camera feeds are updated.

## 枚举

### `FeedImage`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEED_RGBA_IMAGE` |  |
| `0` | `FEED_YCBCR_IMAGE` |  |
| `0` | `FEED_Y_IMAGE` |  |
| `1` | `FEED_CBCR_IMAGE` |  |

