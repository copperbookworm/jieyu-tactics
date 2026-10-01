# Image

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Image` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Image.md`

**摘要**：Image datatype.

## 描述

Native image datatype. Contains image data which can be converted to an `ImageTexture` and provides commonly used *image processing* methods. The maximum width and height for an `Image` are `MAX_WIDTH` and `MAX_HEIGHT`.
		An `Image` cannot be assigned to a texture property of an object directly (such as `Sprite2D.texture`), and has to be converted manually to an `ImageTexture` first.
		**Note:** Methods that modify the image data cannot be used on VRAM-compressed images. Use `decompress` to convert the image to an uncompressed format first.
		**Note:** The maximum image size is 16384×16384 pixels due to graphics hardware limitations. Larger images may fail to import.

## 属性

- **`data`** `Dictionary` = `{ "data": PackedByteArray(), "format": "Lum8", "height": 0, "mipmaps": false, "width": 0 }`
  - 其它属性：getter=_get_data · setter=_set_data

## 方法

### `adjust_bcs(brightness: float, contrast: float, saturation: float) -> void`

Adjusts this image's `brightness`, `contrast`, and `saturation` by the given values. Does not work if the image is compressed (see `is_compressed`).

### `blend_rect(src: Image, src_rect: Rect2i, dst: Vector2i) -> void`

Alpha-blends `src_rect` from `src` image to this image at coordinates `dst`, clipped accordingly to both image bounds. This image and `src` image **must** have the same format. `src_rect` with non-positive size is treated as empty.

### `blend_rect_mask(src: Image, mask: Image, src_rect: Rect2i, dst: Vector2i) -> void`

Alpha-blends `src_rect` from `src` image to this image using `mask` image at coordinates `dst`, clipped accordingly to both image bounds. Alpha channels are required for both `src` and `mask`. `dst` pixels and `src` pixels will blend if the corresponding mask pixel's alpha value is not 0. This image and `src` image **must** have the same format. `src` image and `mask` image **must** have the same size (width and height) but they can have different formats. `src_rect` with non-positive size is treated as empty.

### `blit_rect(src: Image, src_rect: Rect2i, dst: Vector2i) -> void`

Copies `src_rect` from `src` image to this image at coordinates `dst`, clipped accordingly to both image bounds. This image and `src` image **must** have the same format. `src_rect` with non-positive size is treated as empty.
				**Note:** The alpha channel data in `src` will overwrite the corresponding data in this image at the target position. To blend alpha channels, use `blend_rect` instead.

### `blit_rect_mask(src: Image, mask: Image, src_rect: Rect2i, dst: Vector2i) -> void`

Blits `src_rect` area from `src` image to this image at the coordinates given by `dst`, clipped accordingly to both image bounds. `src` pixel is copied onto `dst` if the corresponding `mask` pixel's alpha value is not 0. This image and `src` image **must** have the same format. `src` image and `mask` image **must** have the same size (width and height) but they can have different formats. `src_rect` with non-positive size is treated as empty.

### `bump_map_to_normal_map(bump_scale: float = 1.0) -> void`

Converts a bump map to a normal map. A bump map provides a height offset per-pixel, while a normal map provides a normal direction per pixel.

### `clear_mipmaps() -> void`

Removes the image's mipmaps.

### `compress(mode: int, source: int = 0, astc_format: int = 0) -> int`

Compresses the image with a VRAM-compressed format to use less memory. Can not directly access pixel data while the image is compressed. Returns error if the chosen compression mode is not available.
				The `source` parameter helps to pick the best compression method for DXT and ETC2 formats. It is ignored for ASTC compression.
				The `astc_format` parameter is only taken into account when using ASTC compression; it is ignored for all other formats.
				**Note:** `compress` is only supported in editor builds. When run in an exported project, this method always returns `ERR_UNAVAILABLE`.

### `compress_from_channels(mode: int, channels: int, astc_format: int = 0) -> int`

Compresses the image with a VRAM-compressed format to use less memory. Can not directly access pixel data while the image is compressed. Returns error if the chosen compression mode is not available.
				This is an alternative to `compress` that lets the user supply the channels used in order for the compressor to pick the best DXT and ETC2 formats. For other formats (non DXT or ETC2), this argument is ignored.
				The `astc_format` parameter is only taken into account when using ASTC compression; it is ignored for all other formats.
				**Note:** `compress_from_channels` is only supported in editor builds. When run in an exported project, this method always returns `ERR_UNAVAILABLE`.

### `compute_image_metrics(compared_image: Image, use_luma: bool) -> Dictionary`

Compute image metrics on the current image and the compared image. This can be used to calculate the similarity between two images.
				The dictionary contains `max`, `mean`, `mean_squared`, `root_mean_squared` and `peak_snr`.

### `convert(format: int) -> void`

Converts this image's format to the given `format`.

### `copy_from(src: Image) -> void`

Copies `src` image to this image.

### `create(width: int, height: int, use_mipmaps: bool, format: int) -> Image`
- 限定：deprecated=Use [method create_empty]. · qualifiers=static

Creates an empty image of the given size and format. If `use_mipmaps` is `true`, generates mipmaps for this image (see `generate_mipmaps`).

### `create_empty(width: int, height: int, use_mipmaps: bool, format: int) -> Image`
- 限定：qualifiers=static

Creates an empty image of the given size and format. If `use_mipmaps` is `true`, generates mipmaps for this image (see `generate_mipmaps`).

### `create_from_data(width: int, height: int, use_mipmaps: bool, format: int, data: PackedByteArray) -> Image`
- 限定：qualifiers=static

Creates a new image of the given size and format. Fills the image with the given raw data. If `use_mipmaps` is `true`, loads the mipmaps for this image from `data`. See `generate_mipmaps`.

### `crop(width: int, height: int) -> void`

Crops the image to the given `width` and `height`. If the specified size is larger than the current size, the extra area is filled with black pixels.

### `decompress() -> int`

Decompresses the image if it is VRAM-compressed in a supported format. This increases memory utilization, but allows modifying the image. Returns `OK` if the format is supported, otherwise `ERR_UNAVAILABLE`. All VRAM-compressed formats supported by Godot can be decompressed with this method, except `FORMAT_ETC2_R11S`, `FORMAT_ETC2_RG11S`, and `FORMAT_ETC2_RGB8A1`.

### `detect_alpha() -> int`
- 限定：qualifiers=const

Returns `ALPHA_BLEND` if the image has data for alpha values. Returns `ALPHA_BIT` if all the alpha values are stored in a single bit. Returns `ALPHA_NONE` if no data for alpha values is found.

### `detect_used_channels(source: int = 0) -> int`
- 限定：qualifiers=const

Returns the color channels used by this image. If the image is compressed, the original `source` must be specified.

### `fill(color: Color) -> void`

Fills the image with `color`.

### `fill_rect(rect: Rect2i, color: Color) -> void`

Fills `rect` with `color`.

### `fix_alpha_edges() -> void`

Blends low-alpha pixels with nearby pixels.

### `flip_x() -> void`

Flips the image horizontally.

### `flip_y() -> void`

Flips the image vertically.

### `generate_mipmaps(renormalize: bool = false) -> int`

Generates mipmaps for the image. Mipmaps are precalculated lower-resolution copies of the image that are automatically used if the image needs to be scaled down when rendered. They help improve image quality and performance when rendering. This method returns an error if the image is compressed, in a custom format, or if the image's width/height is `0`. Enabling `renormalize` when generating mipmaps for normal map textures will make sure all resulting vector values are normalized.
				It is possible to check if the image has mipmaps by calling `has_mipmaps` or `get_mipmap_count`. Calling `generate_mipmaps` on an image that already has mipmaps will replace existing mipmaps in the image.

### `get_data() -> PackedByteArray`
- 限定：qualifiers=const

Returns a copy of the image's raw data.

### `get_data_size() -> int`
- 限定：qualifiers=const

Returns size (in bytes) of the image's raw data.

### `get_format() -> int`
- 限定：qualifiers=const

Returns this image's format.

### `get_height() -> int`
- 限定：qualifiers=const

Returns the image's height.

### `get_mipmap_count() -> int`
- 限定：qualifiers=const

Returns the number of mipmap levels or 0 if the image has no mipmaps. The largest main level image is not counted as a mipmap level by this method, so if you want to include it you can add 1 to this count.

### `get_mipmap_offset(mipmap: int) -> int`
- 限定：qualifiers=const

Returns the offset where the image's mipmap with index `mipmap` is stored in the `data` dictionary.

### `get_pixel(x: int, y: int) -> Color`
- 限定：qualifiers=const

Returns the color of the pixel at `(x, y)`.
				This is the same as `get_pixelv`, but with two integer arguments instead of a `Vector2i` argument.

### `get_pixelv(point: Vector2i) -> Color`
- 限定：qualifiers=const

Returns the color of the pixel at `point`.
				This is the same as `get_pixel`, but with a `Vector2i` argument instead of two integer arguments.

### `get_region(region: Rect2i) -> Image`
- 限定：qualifiers=const

Returns a new `Image` that is a copy of this `Image`'s area specified with `region`.

### `get_size() -> Vector2i`
- 限定：qualifiers=const

Returns the image's size (width and height).

### `get_used_rect() -> Rect2i`
- 限定：qualifiers=const

Returns a `Rect2i` enclosing the visible portion of the image, considering each pixel with a non-zero alpha channel as visible.

### `get_width() -> int`
- 限定：qualifiers=const

Returns the image's width.

### `has_mipmaps() -> bool`
- 限定：qualifiers=const

Returns `true` if the image has generated mipmaps.

### `is_compressed() -> bool`
- 限定：qualifiers=const

Returns `true` if the image is compressed.

### `is_empty() -> bool`
- 限定：qualifiers=const

Returns `true` if the image has no data.

### `is_invisible() -> bool`
- 限定：qualifiers=const

Returns `true` if all the image's pixels have an alpha value of 0. Returns `false` if any pixel has an alpha value higher than 0.

### `linear_to_srgb() -> void`

Converts the entire image from linear encoding to nonlinear sRGB encoding by using a lookup table. Only works on images with `FORMAT_RGB8` or `FORMAT_RGBA8` formats.

### `load(path: String) -> int`

Loads an image from file `path`. See Supported image formats ($DOCS_URL/tutorials/assets_pipeline/importing_images.html#supported-image-formats) for a list of supported image formats and limitations.
				**Warning:** This method should only be used in the editor or in cases when you need to load external images at run-time, such as images located at the `user://` directory, and may not work in exported projects.
				See also `ImageTexture` description for usage examples.

### `load_bmp_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a BMP file.
				**Note:** Godot's BMP module doesn't support 16-bit per pixel images. Only 1-bit, 4-bit, 8-bit, 24-bit, and 32-bit per pixel images are supported.
				**Note:** This method is only available in engine builds with the BMP module enabled. By default, the BMP module is enabled, but it can be disabled at build-time using the `module_bmp_enabled=no` SCons option.

### `load_dds_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a DDS file.
				**Note:** This method is only available in engine builds with the DDS module enabled. By default, the DDS module is enabled, but it can be disabled at build-time using the `module_dds_enabled=no` SCons option.

### `load_exr_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of an OpenEXR file.

### `load_from_file(path: String) -> Image`
- 限定：qualifiers=static

Creates a new `Image` and loads data from the specified file.

### `load_jpg_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a JPEG file.

### `load_ktx_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a KTX (https://github.com/KhronosGroup/KTX-Software) file. Unlike most image formats, KTX can store VRAM-compressed data and embed mipmaps.
				**Note:** Godot's libktx implementation only supports 2D images. Cubemaps, texture arrays, and de-padding are not supported.
				**Note:** This method is only available in engine builds with the KTX module enabled. By default, the KTX module is enabled, but it can be disabled at build-time using the `module_ktx_enabled=no` SCons option.

### `load_png_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a PNG file.

### `load_svg_from_buffer(buffer: PackedByteArray, scale: float = 1.0) -> int`

Loads an image from the UTF-8 binary contents of an **uncompressed** SVG file (**.svg**).
				**Note:** Beware when using compressed SVG files (like **.svgz**), they need to be `decompressed` before loading.
				**Note:** This method is only available in engine builds with the SVG module enabled. By default, the SVG module is enabled, but it can be disabled at build-time using the `module_svg_enabled=no` SCons option.

### `load_svg_from_string(svg_str: String, scale: float = 1.0) -> int`

Loads an image from the string contents of an SVG file (**.svg**).
				**Note:** This method is only available in engine builds with the SVG module enabled. By default, the SVG module is enabled, but it can be disabled at build-time using the `module_svg_enabled=no` SCons option.

### `load_tga_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a TGA file.
				**Note:** This method is only available in engine builds with the TGA module enabled. By default, the TGA module is enabled, but it can be disabled at build-time using the `module_tga_enabled=no` SCons option.

### `load_webp_from_buffer(buffer: PackedByteArray) -> int`

Loads an image from the binary contents of a WebP file.

### `normal_map_to_xy() -> void`

Converts the image's data to represent coordinates on a 3D plane. This is used when the image represents a normal map. A normal map can add lots of detail to a 3D surface without increasing the polygon count.

### `premultiply_alpha() -> void`

Multiplies color values with alpha values. Resulting color values for a pixel are `(color * alpha)/256`. See also `CanvasItemMaterial.blend_mode`.

### `resize(width: int, height: int, interpolation: int = 1) -> void`

Resizes the image to the given `width` and `height`. New pixels are calculated using the `interpolation` mode defined via `Interpolation` constants.
				**Note:** If the image's format is `FORMAT_RGBA4444`, `FORMAT_RGB565`, or `FORMAT_RGBE9995`, it will be temporarily converted to either `FORMAT_RGBA8` or `FORMAT_RGBAH`. This can affect the quality of the resized image.

### `resize_to_po2(square: bool = false, interpolation: int = 1) -> void`

Resizes the image to the nearest power of 2 for the width and height. If `square` is `true`, sets width and height to be the same. New pixels are calculated using the `interpolation` mode defined via `Interpolation` constants.

### `rgbe_to_srgb() -> Image`

Converts a standard linear RGBE (Red Green Blue Exponent) image to an image that uses nonlinear sRGB encoding.

### `rotate_90(direction: int) -> void`

Rotates the image in the specified `direction` by `90` degrees. The width and height of the image must be greater than `1`. If the width and height are not equal, the image will be resized.

### `rotate_180() -> void`

Rotates the image by `180` degrees. The width and height of the image must be greater than `1`.

### `save_dds(path: String) -> int`
- 限定：qualifiers=const

Saves the image as a DDS (DirectDraw Surface) file to `path`. DDS is a container format that can store textures in various compression formats, such as DXT1, DXT5, or BC7. This function will return `ERR_UNAVAILABLE` if Godot was compiled without the DDS module.
				**Note:** The DDS module may be disabled in certain builds, which means `save_dds` will return `ERR_UNAVAILABLE` when it is called from an exported project.

### `save_dds_to_buffer() -> PackedByteArray`
- 限定：qualifiers=const

Saves the image as a DDS (DirectDraw Surface) file to a byte array. DDS is a container format that can store textures in various compression formats, such as DXT1, DXT5, or BC7. This function will return an empty byte array if Godot was compiled without the DDS module.
				**Note:** The DDS module may be disabled in certain builds, which means `save_dds_to_buffer` will return an empty byte array when it is called from an exported project.

### `save_exr(path: String, grayscale: bool = false, color_image: bool = false, max_linear_value: float = -1.0) -> int`
- 限定：qualifiers=const

Saves the image as an EXR file to `path`. If `grayscale` is `true` and the image has only one channel, it will be saved explicitly as monochrome rather than one red channel. Set `color_image` to `true` when saving a color image, such as a screenshot. Negative values will be included when `color_image` is `false`, which may be useful for saving raw floating point data such as a lightmap that includes negative light information. Color component values in the resulting EXR file will not exceed `max_linear_value` if `max_linear_value` is not negative. This function will return `ERR_UNAVAILABLE` if Godot was compiled without the TinyEXR module.
				When saving screenshots of a project that uses HDR output, use `Window.get_output_max_linear_value` for `max_linear_value`.

### `save_exr_to_buffer(grayscale: bool = false, color_image: bool = false, max_linear_value: float = -1.0) -> PackedByteArray`
- 限定：qualifiers=const

Saves the image as an EXR file to a byte array. If `grayscale` is `true` and the image has only one channel, it will be saved explicitly as monochrome rather than one red channel. Set `color_image` to `true` when saving a color image, such as a screenshot. Negative values will be included when `color_image` is `false`, which may be useful for saving raw floating point data such as a lightmap that includes negative light information. Color component values in the resulting EXR file will not exceed `max_linear_value` if `max_linear_value` is not negative. This function will return an empty byte array if Godot was compiled without the TinyEXR module.
				When saving screenshots of a project that uses HDR output, use `Window.get_output_max_linear_value` for `max_linear_value`.

### `save_jpg(path: String, quality: float = 0.75) -> int`
- 限定：qualifiers=const

Saves the image as a JPEG file to `path` with the specified `quality` between `0.01` and `1.0` (inclusive). Higher `quality` values result in better-looking output at the cost of larger file sizes. Recommended `quality` values are between `0.75` and `0.90`. Even at quality `1.00`, JPEG compression remains lossy.
				**Note:** JPEG does not save an alpha channel. If the `Image` contains an alpha channel, the image will still be saved, but the resulting JPEG file won't contain the alpha channel.

### `save_jpg_to_buffer(quality: float = 0.75) -> PackedByteArray`
- 限定：qualifiers=const

Saves the image as a JPEG file to a byte array with the specified `quality` between `0.01` and `1.0` (inclusive). Higher `quality` values result in better-looking output at the cost of larger byte array sizes (and therefore memory usage). Recommended `quality` values are between `0.75` and `0.90`. Even at quality `1.00`, JPEG compression remains lossy.
				**Note:** JPEG does not save an alpha channel. If the `Image` contains an alpha channel, the image will still be saved, but the resulting byte array won't contain the alpha channel.

### `save_png(path: String) -> int`
- 限定：qualifiers=const

Saves the image as a PNG file to the file at `path`.

### `save_png_to_buffer() -> PackedByteArray`
- 限定：qualifiers=const

Saves the image as a PNG file to a byte array.

### `save_webp(path: String, lossy: bool = false, quality: float = 0.75) -> int`
- 限定：qualifiers=const

Saves the image as a WebP (Web Picture) file to the file at `path`. By default it will save lossless. If `lossy` is `true`, the image will be saved lossy, using the `quality` setting between `0.0` and `1.0` (inclusive). Lossless WebP offers more efficient compression than PNG.
				**Note:** The WebP format is limited to a size of 16383×16383 pixels, while PNG can save larger images.

### `save_webp_to_buffer(lossy: bool = false, quality: float = 0.75) -> PackedByteArray`
- 限定：qualifiers=const

Saves the image as a WebP (Web Picture) file to a byte array. By default it will save lossless. If `lossy` is `true`, the image will be saved lossy, using the `quality` setting between `0.0` and `1.0` (inclusive). Lossless WebP offers more efficient compression than PNG.
				**Note:** The WebP format is limited to a size of 16383×16383 pixels, while PNG can save larger images.

### `set_data(width: int, height: int, use_mipmaps: bool, format: int, data: PackedByteArray) -> void`

Overwrites data of an existing `Image`. Non-static equivalent of `create_from_data`.

### `set_pixel(x: int, y: int, color: Color) -> void`

Sets the `Color` of the pixel at `(x, y)` to `color`.
				`codeblocks`
				`gdscript`
				var img_width = 10
				var img_height = 5
				var img = Image.create(img_width, img_height, false, Image.FORMAT_RGBA8)

				img.set_pixel(1, 2, Color.RED) # Sets the color at (1, 2) to red.
				
				`csharp`
				int imgWidth = 10;
				int imgHeight = 5;
				var img = Image.Create(imgWidth, imgHeight, false, Image.Format.Rgba8);

				img.SetPixel(1, 2, Colors.Red); // Sets the color at (1, 2) to red.
				
				
				This is the same as `set_pixelv`, but with a two integer arguments instead of a `Vector2i` argument.
				**Note:** Depending on the image's format, the color set here may be clamped or lose precision. Do not assume the color returned by `get_pixel` to be identical to the one set here; any comparisons will likely need to use an approximation like `Color.is_equal_approx`.
				**Note:** On grayscale image formats, only the red channel of `color` is used (and alpha if relevant). The green and blue channels are ignored.

### `set_pixelv(point: Vector2i, color: Color) -> void`

Sets the `Color` of the pixel at `point` to `color`.
				`codeblocks`
				`gdscript`
				var img_width = 10
				var img_height = 5
				var img = Image.create(img_width, img_height, false, Image.FORMAT_RGBA8)

				img.set_pixelv(Vector2i(1, 2), Color.RED) # Sets the color at (1, 2) to red.
				
				`csharp`
				int imgWidth = 10;
				int imgHeight = 5;
				var img = Image.Create(imgWidth, imgHeight, false, Image.Format.Rgba8);

				img.SetPixelv(new Vector2I(1, 2), Colors.Red); // Sets the color at (1, 2) to red.
				
				
				This is the same as `set_pixel`, but with a `Vector2i` argument instead of two integer arguments.
				**Note:** Depending on the image's format, the color set here may be clamped or lose precision. Do not assume the color returned by `get_pixelv` to be identical to the one set here; any comparisons will likely need to use an approximation like `Color.is_equal_approx`.
				**Note:** On grayscale image formats, only the red channel of `color` is used (and alpha if relevant). The green and blue channels are ignored.

### `shrink_x2() -> void`

Shrinks the image by a factor of 2 on each axis (this divides the pixel count by 4).

### `srgb_to_linear() -> void`

Converts the raw data from nonlinear sRGB encoding to linear encoding using a lookup table. Only works on images with `FORMAT_RGB8` or `FORMAT_RGBA8` formats.
				**Note:** The 8-bit formats required by this method are not suitable for storing linearly encoded values; a significant amount of color information will be lost in darker values. To maintain image quality, this method should not be used.

## 枚举

### `Format`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FORMAT_L8` |  |
| `1` | `FORMAT_LA8` |  |
| `2` | `FORMAT_R8` |  |
| `3` | `FORMAT_RG8` |  |
| `4` | `FORMAT_RGB8` |  |
| `5` | `FORMAT_RGBA8` |  |
| `6` | `FORMAT_RGBA4444` |  |
| `7` | `FORMAT_RGB565` |  |
| `8` | `FORMAT_RF` |  |
| `9` | `FORMAT_RGF` |  |
| `10` | `FORMAT_RGBF` |  |
| `11` | `FORMAT_RGBAF` |  |
| `12` | `FORMAT_RH` |  |
| `13` | `FORMAT_RGH` |  |
| `14` | `FORMAT_RGBH` |  |
| `15` | `FORMAT_RGBAH` |  |
| `16` | `FORMAT_RGBE9995` |  |
| `17` | `FORMAT_DXT1` |  |
| `18` | `FORMAT_DXT3` |  |
| `19` | `FORMAT_DXT5` |  |
| `20` | `FORMAT_RGTC_R` |  |
| `21` | `FORMAT_RGTC_RG` |  |
| `22` | `FORMAT_BPTC_RGBA` |  |
| `23` | `FORMAT_BPTC_RGBF` |  |
| `24` | `FORMAT_BPTC_RGBFU` |  |
| `25` | `FORMAT_ETC` |  |
| `26` | `FORMAT_ETC2_R11` |  |
| `27` | `FORMAT_ETC2_R11S` |  |
| `28` | `FORMAT_ETC2_RG11` |  |
| `29` | `FORMAT_ETC2_RG11S` |  |
| `30` | `FORMAT_ETC2_RGB8` |  |
| `31` | `FORMAT_ETC2_RGBA8` |  |
| `32` | `FORMAT_ETC2_RGB8A1` |  |
| `33` | `FORMAT_ETC2_RA_AS_RG` |  |
| `34` | `FORMAT_DXT5_RA_AS_RG` |  |
| `35` | `FORMAT_ASTC_4x4` |  |
| `36` | `FORMAT_ASTC_4x4_HDR` |  |
| `37` | `FORMAT_ASTC_8x8` |  |
| `38` | `FORMAT_ASTC_8x8_HDR` |  |
| `39` | `FORMAT_R16` |  |
| `40` | `FORMAT_RG16` |  |
| `41` | `FORMAT_RGB16` |  |
| `42` | `FORMAT_RGBA16` |  |
| `43` | `FORMAT_R16I` |  |
| `44` | `FORMAT_RG16I` |  |
| `45` | `FORMAT_RGB16I` |  |
| `46` | `FORMAT_RGBA16I` |  |
| `47` | `FORMAT_MAX` |  |

### `Interpolation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INTERPOLATE_NEAREST` |  |
| `1` | `INTERPOLATE_BILINEAR` |  |
| `2` | `INTERPOLATE_CUBIC` |  |
| `3` | `INTERPOLATE_TRILINEAR` |  |
| `4` | `INTERPOLATE_LANCZOS` |  |

### `AlphaMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALPHA_NONE` |  |
| `1` | `ALPHA_BIT` |  |
| `2` | `ALPHA_BLEND` |  |

### `CompressMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPRESS_S3TC` |  |
| `1` | `COMPRESS_ETC` |  |
| `2` | `COMPRESS_ETC2` |  |
| `3` | `COMPRESS_BPTC` |  |
| `4` | `COMPRESS_ASTC` |  |
| `5` | `COMPRESS_MAX` |  |

### `UsedChannels`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `USED_CHANNELS_L` |  |
| `1` | `USED_CHANNELS_LA` |  |
| `2` | `USED_CHANNELS_R` |  |
| `3` | `USED_CHANNELS_RG` |  |
| `4` | `USED_CHANNELS_RGB` |  |
| `5` | `USED_CHANNELS_RGBA` |  |

### `CompressSource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPRESS_SOURCE_GENERIC` |  |
| `1` | `COMPRESS_SOURCE_SRGB` |  |
| `2` | `COMPRESS_SOURCE_NORMAL` |  |

### `ASTCFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ASTC_FORMAT_4x4` |  |
| `1` | `ASTC_FORMAT_8x8` |  |

## 常量

- **`MAX_WIDTH`** = `16777216`
- **`MAX_HEIGHT`** = `16777216`
## 教程链接

- [Importing images](None)
- [Runtime file loading and saving](None)

