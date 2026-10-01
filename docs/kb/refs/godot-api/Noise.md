# Noise

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Noise` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Noise.md`

**摘要**：Abstract base class for noise generators.

## 描述

This class defines the interface for noise generation libraries to inherit from.
		A default `get_seamless_image` implementation is provided for libraries that do not provide seamless noise. This function requests a larger image from the `get_image` method, reverses the quadrants of the image, then uses the strips of extra width to blend over the seams.
		Inheriting noise classes can optionally override this function to provide a more optimal algorithm.

## 方法

### `get_image(width: int, height: int, invert: bool = false, in_3d_space: bool = false, normalize: bool = true) -> Image`
- 限定：qualifiers=const

Returns an `Image` containing 2D noise values.
				**Note:** With `normalize` set to `false`, the default implementation expects the noise generator to return values in the range `-1.0` to `1.0`.

### `get_image_3d(width: int, height: int, depth: int, invert: bool = false, normalize: bool = true) -> Image[]`
- 限定：qualifiers=const

Returns an `Array` of `Image`s containing 3D noise values for use with `ImageTexture3D.create`.
				**Note:** With `normalize` set to `false`, the default implementation expects the noise generator to return values in the range `-1.0` to `1.0`.

### `get_noise_1d(x: float) -> float`
- 限定：qualifiers=const

Returns the 1D noise value at the given (x) coordinate.

### `get_noise_2d(x: float, y: float) -> float`
- 限定：qualifiers=const

Returns the 2D noise value at the given position.

### `get_noise_2dv(v: Vector2) -> float`
- 限定：qualifiers=const

Returns the 2D noise value at the given position.

### `get_noise_3d(x: float, y: float, z: float) -> float`
- 限定：qualifiers=const

Returns the 3D noise value at the given position.

### `get_noise_3dv(v: Vector3) -> float`
- 限定：qualifiers=const

Returns the 3D noise value at the given position.

### `get_seamless_image(width: int, height: int, invert: bool = false, in_3d_space: bool = false, skirt: float = 0.1, normalize: bool = true) -> Image`
- 限定：qualifiers=const

Returns an `Image` containing seamless 2D noise values.
				**Note:** With `normalize` set to `false`, the default implementation expects the noise generator to return values in the range `-1.0` to `1.0`.

### `get_seamless_image_3d(width: int, height: int, depth: int, invert: bool = false, skirt: float = 0.1, normalize: bool = true) -> Image[]`
- 限定：qualifiers=const

Returns an `Array` of `Image`s containing seamless 3D noise values for use with `ImageTexture3D.create`.
				**Note:** With `normalize` set to `false`, the default implementation expects the noise generator to return values in the range `-1.0` to `1.0`.

