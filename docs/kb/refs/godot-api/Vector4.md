# Vector4

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Vector4`
> 自动生成，勿手改。文件：`refs/godot-api/Vector4.md`

**摘要**：A 4D vector using floating-point coordinates.

## 描述

A 4-element structure that can be used to represent 4D coordinates or any other quadruplet of numeric values.
		It uses floating-point coordinates. By default, these floating-point values use 32-bit precision, unlike `float` which is always 64-bit. If double precision is needed, compile the engine with the option `precision=double`.
		See `Vector4i` for its integer counterpart.
		**Note:** In a boolean context, a Vector4 will evaluate to `false` if it's equal to `Vector4(0, 0, 0, 0)`. Otherwise, a Vector4 will always evaluate to `true`.

## 属性

- **`w`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`x`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`y`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`z`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components in absolute values (i.e. positive).

### `ceil() -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components rounded up (towards positive infinity).

### `clamp(min: Vector4, max: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `clampf(min: float, max: float) -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components clamped between `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `cubic_interpolate(b: Vector4, pre_a: Vector4, post_b: Vector4, weight: float) -> Vector4`
- 限定：qualifiers=const

Performs a cubic interpolation between this vector and `b` using `pre_a` and `post_b` as handles, and returns the result at position `weight`. `weight` is on the range of 0.0 to 1.0, representing the amount of interpolation.

### `cubic_interpolate_in_time(b: Vector4, pre_a: Vector4, post_b: Vector4, weight: float, b_t: float, pre_a_t: float, post_b_t: float) -> Vector4`
- 限定：qualifiers=const

Performs a cubic interpolation between this vector and `b` using `pre_a` and `post_b` as handles, and returns the result at position `weight`. `weight` is on the range of 0.0 to 1.0, representing the amount of interpolation.
				It can perform smoother interpolation than `cubic_interpolate` by the time values.

### `direction_to(to: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns the normalized vector pointing from this vector to `to`. This is equivalent to using `(b - a).normalized()`.

### `distance_squared_to(to: Vector4) -> float`
- 限定：qualifiers=const

Returns the squared Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.
				This method runs faster than `distance_to`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `distance_to(to: Vector4) -> float`
- 限定：qualifiers=const

Returns the Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.

### `dot(with: Vector4) -> float`
- 限定：qualifiers=const

Returns the dot product of this vector and `with`.

### `floor() -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components rounded down (towards negative infinity).

### `inverse() -> Vector4`
- 限定：qualifiers=const

Returns the inverse of the vector. This is the same as `Vector4(1.0 / v.x, 1.0 / v.y, 1.0 / v.z, 1.0 / v.w)`.

### `is_equal_approx(to: Vector4) -> bool`
- 限定：qualifiers=const

Returns `true` if this vector and `to` are approximately equal, by running `@GlobalScope.is_equal_approx` on each component.

### `is_finite() -> bool`
- 限定：qualifiers=const

Returns `true` if this vector is finite, by calling `@GlobalScope.is_finite` on each component.

### `is_normalized() -> bool`
- 限定：qualifiers=const

Returns `true` if the vector is normalized, i.e. its length is approximately equal to 1.

### `is_zero_approx() -> bool`
- 限定：qualifiers=const

Returns `true` if this vector's values are approximately zero, by running `@GlobalScope.is_zero_approx` on each component.
				This method is faster than using `is_equal_approx` with one value as a zero vector.

### `length() -> float`
- 限定：keywords=size · qualifiers=const

Returns the length (magnitude) of this vector.

### `length_squared() -> float`
- 限定：qualifiers=const

Returns the squared length (squared magnitude) of this vector.
				This method runs faster than `length`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `lerp(to: Vector4, weight: float) -> Vector4`
- 限定：keywords=interpolate · qualifiers=const

Returns the result of the linear interpolation between this vector and `to` by amount `weight`. `weight` is on the range of `0.0` to `1.0`, representing the amount of interpolation.

### `max(with: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector4(maxf(x, with.x), maxf(y, with.y), maxf(z, with.z), maxf(w, with.w))`.

### `max_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's highest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_X`.

### `maxf(with: float) -> Vector4`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector4(maxf(x, with), maxf(y, with), maxf(z, with), maxf(w, with))`.

### `min(with: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector4(minf(x, with.x), minf(y, with.y), minf(z, with.z), minf(w, with.w))`.

### `min_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's lowest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_W`.

### `minf(with: float) -> Vector4`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector4(minf(x, with), minf(y, with), minf(z, with), minf(w, with))`.

### `normalized() -> Vector4`
- 限定：qualifiers=const

Returns the result of scaling the vector to unit length. Equivalent to `v / v.length()`. Returns `(0, 0, 0, 0)` if `v.length() == 0`. See also `is_normalized`.
				**Note:** This function may return incorrect values if the input vector length is near zero.

### `posmod(mod: float) -> Vector4`
- 限定：qualifiers=const

Returns a vector composed of the `@GlobalScope.fposmod` of this vector's components and `mod`.

### `posmodv(modv: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns a vector composed of the `@GlobalScope.fposmod` of this vector's components and `modv`'s components.

### `round() -> Vector4`
- 限定：qualifiers=const

Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.

### `sign() -> Vector4`
- 限定：qualifiers=const

Returns a new vector with each component set to `1.0` if it's positive, `-1.0` if it's negative, and `0.0` if it's zero. The result is identical to calling `@GlobalScope.sign` on each component.

### `snapped(step: Vector4) -> Vector4`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the nearest multiple of the corresponding component in `step`. This can also be used to round the components to an arbitrary number of decimals.

### `snappedf(step: float) -> Vector4`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the nearest multiple of `step`. This can also be used to round the components to an arbitrary number of decimals.

## 枚举

### `Axis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_X` |  |
| `1` | `AXIS_Y` |  |
| `2` | `AXIS_Z` |  |
| `3` | `AXIS_W` |  |

## 常量

- **`ZERO`** = `Vector4(0, 0, 0, 0)`
- **`ONE`** = `Vector4(1, 1, 1, 1)`
- **`INF`** = `Vector4(inf, inf, inf, inf)`
## 构造函数

### `Vector4`

Constructs a default-initialized `Vector4` with all components set to `0`.

### `Vector4`

Constructs a `Vector4` as a copy of the given `Vector4`.

### `Vector4`

Constructs a new `Vector4` from the given `Vector4i`.

### `Vector4`

Returns a `Vector4` with the given components.

## 运算符

### `operator !=`

Returns `true` if the vectors are not equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator *`

Transforms (multiplies) the `Vector4` by the transpose of the given `Projection` matrix.
				For transforming by inverse of a projection `projection.inverse() * vector` can be used instead. See `Projection.inverse`.

### `operator *`

Multiplies each component of the `Vector4` by the components of the given `Vector4`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) * Vector4(3, 4, 5, 6)) # Prints (30.0, 80.0, 150.0, 240.0)
				
```

### `operator *`

Multiplies each component of the `Vector4` by the given `float`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) * 2) # Prints (20.0, 40.0, 60.0, 80.0)
				
```

### `operator *`

Multiplies each component of the `Vector4` by the given `int`.

### `operator +`

Adds each component of the `Vector4` by the components of the given `Vector4`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) + Vector4(3, 4, 5, 6)) # Prints (13.0, 24.0, 35.0, 46.0)
				
```

### `operator -`

Subtracts each component of the `Vector4` by the components of the given `Vector4`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) - Vector4(3, 4, 5, 6)) # Prints (7.0, 16.0, 25.0, 34.0)
				
```

### `operator /`

Divides each component of the `Vector4` by the components of the given `Vector4`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) / Vector4(2, 5, 3, 4)) # Prints (5.0, 4.0, 10.0, 10.0)
				
```

### `operator /`

Divides each component of the `Vector4` by the given `float`.
				
```gdscript
				print(Vector4(10, 20, 30, 40) / 2) # Prints (5.0, 10.0, 15.0, 20.0)
				
```

### `operator /`

Divides each component of the `Vector4` by the given `int`.

### `operator <`

Compares two `Vector4` vectors by first checking if the X value of the left vector is less than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator <=`

Compares two `Vector4` vectors by first checking if the X value of the left vector is less than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator ==`

Returns `true` if the vectors are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >`

Compares two `Vector4` vectors by first checking if the X value of the left vector is greater than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >=`

Compares two `Vector4` vectors by first checking if the X value of the left vector is greater than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator []`

Access vector components using their `index`. `v[0]` is equivalent to `v.x`, `v[1]` is equivalent to `v.y`, `v[2]` is equivalent to `v.z`, and `v[3]` is equivalent to `v.w`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Vector4`. This is the same as writing `Vector4(-v.x, -v.y, -v.z, -v.w)`. This operation flips the direction of the vector while keeping the same magnitude. With floats, the number zero can be either positive or negative.

