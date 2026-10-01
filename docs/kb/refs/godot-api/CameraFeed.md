# CameraFeed

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CameraFeed` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CameraFeed.md`

**摘要**：A camera feed gives you access to a single physical camera attached to your device.

## 描述

A camera feed gives you access to a single physical camera attached to your device. When enabled, Godot will start capturing frames from the camera which can then be used. See also `CameraServer`.
		**Note:** Many cameras will return YCbCr images which are split into two textures and need to be combined in a shader. Godot does this automatically for you if you set the environment to show the camera image in the background.
		**Note:** This class is currently only implemented on Linux, Android, macOS, and iOS. On other platforms no `CameraFeed`s will be available. To get a `CameraFeed` on iOS, enable `EditorExportPlatformIOS.modules/camera`.

## 属性

- **`feed_is_active`** `bool` = `false`
  - 其它属性：getter=is_active · setter=set_active
- **`feed_transform`** `Transform2D` = `Transform2D(1, 0, 0, -1, 0, 1)`
  - 其它属性：getter=get_transform · setter=set_transform
- **`formats`** `Array` = `[]`
  - 其它属性：getter=get_formats · setter=

## 方法

### `_activate_feed() -> bool`
- 限定：qualifiers=virtual

Called when the camera feed is activated.

### `_deactivate_feed() -> void`
- 限定：qualifiers=virtual

Called when the camera feed is deactivated.

### `_get_formats() -> Array`
- 限定：qualifiers=virtual const

Override this method to define supported formats of the camera feed.

### `_set_format(index: int, parameters: Dictionary) -> bool`
- 限定：qualifiers=virtual

Override this method to set the format of the camera feed.

### `get_datatype() -> int`
- 限定：qualifiers=const

Returns feed image data type.

### `get_id() -> int`
- 限定：qualifiers=const

Returns the unique ID for this feed.

### `get_name() -> String`
- 限定：qualifiers=const

Returns the camera's name.

### `get_position() -> int`
- 限定：qualifiers=const

Returns the position of camera on the device.

### `get_texture_tex_id(feed_image_type: int) -> int`

Returns the texture backend ID (usable by some external libraries that need a handle to a texture to write data).

### `set_external(width: int, height: int) -> void`

Sets the feed as external feed provided by another library.

### `set_format(index: int, parameters: Dictionary) -> bool`

Sets the feed format parameters for the given `index` in the `formats` array. Returns `true` on success. By default, the YUYV encoded stream is transformed to `FEED_RGB`. The YUYV encoded stream output format can be changed by setting `parameters`'s `output` entry to one of the following:
				- `"separate"` will result in `FEED_YCBCR_SEP`;
				- `"grayscale"` will result in desaturated `FEED_RGB`;
				- `"copy"` will result in `FEED_YCBCR`.

### `set_name(name: String) -> void`

Sets the camera's name.

### `set_position(position: int) -> void`

Sets the position of this camera.

### `set_rgb_image(rgb_image: Image) -> void`

Sets RGB image for this feed.

### `set_ycbcr_image(ycbcr_image: Image) -> void`

Sets YCbCr image for this feed.

### `set_ycbcr_images(y_image: Image, cbcr_image: Image) -> void`

Sets Y and CbCr images for this feed.

## 信号

### `format_changed()`

Emitted when the format has changed.

### `frame_changed()`

Emitted when a new frame is available.

## 枚举

### `FeedDataType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEED_NOIMAGE` |  |
| `1` | `FEED_RGB` |  |
| `2` | `FEED_YCBCR` |  |
| `3` | `FEED_YCBCR_SEP` |  |
| `4` | `FEED_EXTERNAL` |  |

### `FeedPosition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEED_UNSPECIFIED` |  |
| `1` | `FEED_FRONT` |  |
| `2` | `FEED_BACK` |  |

