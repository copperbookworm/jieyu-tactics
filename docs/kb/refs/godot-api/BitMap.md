# BitMap

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BitMap` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BitMap.md`

**摘要**：Boolean matrix.

## 描述

A two-dimensional array of boolean values, can be used to efficiently store a binary matrix (every matrix element takes only one bit) and query the values using natural cartesian coordinates.

## 方法

### `convert_to_image() -> Image`
- 限定：qualifiers=const

Returns an image of the same size as the bitmap and with an `Image.Format` of type `Image.FORMAT_L8`. `true` bits of the bitmap are being converted into white pixels, and `false` bits into black.

### `create(size: Vector2i) -> void`

Creates a bitmap with the specified size, filled with `false`.

### `create_from_image_alpha(image: Image, threshold: float = 0.1) -> void`

Creates a bitmap that matches the given image dimensions, every element of the bitmap is set to `false` if the alpha value of the image at that position is equal to `threshold` or less, and `true` in other case.

### `get_bit(x: int, y: int) -> bool`
- 限定：qualifiers=const

Returns bitmap's value at the specified position.

### `get_bitv(position: Vector2i) -> bool`
- 限定：qualifiers=const

Returns bitmap's value at the specified position.

### `get_size() -> Vector2i`
- 限定：qualifiers=const

Returns bitmap's dimensions.

### `get_true_bit_count() -> int`
- 限定：qualifiers=const

Returns the number of bitmap elements that are set to `true`.

### `grow_mask(pixels: int, rect: Rect2i) -> void`

Applies morphological dilation or erosion to the bitmap. If `pixels` is positive, dilation is applied to the bitmap. If `pixels` is negative, erosion is applied to the bitmap. `rect` defines the area where the morphological operation is applied. Pixels located outside the `rect` are unaffected by `grow_mask`.

### `opaque_to_polygons(rect: Rect2i, epsilon: float = 2.0) -> PackedVector2Array[]`
- 限定：qualifiers=const

Creates an `Array` of polygons covering a rectangular portion of the bitmap. It uses a marching squares algorithm, followed by Ramer-Douglas-Peucker (RDP) reduction of the number of vertices. Each polygon is described as a `PackedVector2Array` of its vertices.
				To get polygons covering the whole bitmap, pass:
				
```gdscript
				Rect2(Vector2(), get_size())
				
```

				`epsilon` is passed to RDP to control how accurately the polygons cover the bitmap: a lower `epsilon` corresponds to more points in the polygons.

### `resize(new_size: Vector2i) -> void`

Resizes the image to `new_size`.

### `set_bit(x: int, y: int, bit: bool) -> void`

Sets the bitmap's element at the specified position, to the specified value.

### `set_bit_rect(rect: Rect2i, bit: bool) -> void`

Sets a rectangular portion of the bitmap to the specified value.

### `set_bitv(position: Vector2i, bit: bool) -> void`

Sets the bitmap's element at the specified position, to the specified value.

