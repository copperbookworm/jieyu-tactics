# ImageFormatLoaderExtension

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ImageFormatLoaderExtension` → `ImageFormatLoader` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ImageFormatLoaderExtension.md`

**摘要**：Base class for creating `ImageFormatLoader` extensions (adding support for extra image formats).

## 描述

The engine supports multiple image formats out of the box (PNG, SVG, JPEG, WebP to name a few), but you can choose to implement support for additional image formats by extending this class.
		Be sure to respect the documented return types and values. You should create an instance of it, and call `add_format_loader` to register that loader during the initialization phase.

## 方法

### `_get_recognized_extensions() -> PackedStringArray`
- 限定：qualifiers=virtual const

Returns the list of file extensions for this image format. Files with the given extensions will be treated as image file and loaded using this class.

### `_load_image(image: Image, fileaccess: FileAccess, flags: int, scale: float) -> int`
- 限定：qualifiers=virtual

Loads the content of `fileaccess` into the provided `image`.

### `add_format_loader() -> void`

Add this format loader to the engine, allowing it to recognize the file extensions returned by `_get_recognized_extensions`.

### `remove_format_loader() -> void`

Remove this format loader from the engine.

