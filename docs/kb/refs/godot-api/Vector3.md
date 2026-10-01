# Vector3

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Vector3`
> 自动生成，勿手改。文件：`refs/godot-api/Vector3.md`

**摘要**：A 3D vector using floating-point coordinates.

## 描述

A 3-element structure that can be used to represent 3D coordinates or any other triplet of numeric values.
		It uses floating-point coordinates. By default, these floating-point values use 32-bit precision, unlike `float` which is always 64-bit. If double precision is needed, compile the engine with the option `precision=double`.
		See `Vector3i` for its integer counterpart.
		**Note:** In a boolean context, a Vector3 will evaluate to `false` if it's equal to `Vector3(0, 0, 0)`. Otherwise, a Vector3 will always evaluate to `true`.

## 属性

- **`x`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`y`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`z`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components in absolute values (i.e. positive).

### `angle_to(to: Vector3) -> float`
- 限定：qualifiers=const

Returns the unsigned minimum angle to the given vector, in radians.

### `bezier_derivative(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) -> Vector3`
- 限定：qualifiers=const

Returns the derivative at the given `t` on the Bézier curve (https://en.wikipedia.org/wiki/B%C3%A9zier_curve) defined by this vector and the given `control_1`, `control_2`, and `end` points.

### `bezier_interpolate(control_1: Vector3, control_2: Vector3, end: Vector3, t: float) -> Vector3`
- 限定：qualifiers=const

Returns the point at the given `t` on the Bézier curve (https://en.wikipedia.org/wiki/B%C3%A9zier_curve) defined by this vector and the given `control_1`, `control_2`, and `end` points.

### `bounce(n: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the vector "bounced off" from a plane defined by the given normal `n`.
				**Note:** `bounce` performs the operation that most engines and frameworks call `skip-lint`reflect().

### `ceil() -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components rounded up (towards positive infinity).

### `clamp(min: Vector3, max: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `clampf(min: float, max: float) -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components clamped between `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `cross(with: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the cross product of this vector and `with`.
				This returns a vector perpendicular to both this and `with`, which would be the normal vector of the plane defined by the two vectors. As there are two such vectors, in opposite directions, this method returns the vector defined by a right-handed coordinate system. If the two vectors are parallel this returns an empty vector, making it useful for testing if two vectors are parallel.

### `cubic_interpolate(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float) -> Vector3`
- 限定：qualifiers=const

Performs a cubic interpolation between this vector and `b` using `pre_a` and `post_b` as handles, and returns the result at position `weight`. `weight` is on the range of 0.0 to 1.0, representing the amount of interpolation.

### `cubic_interpolate_in_time(b: Vector3, pre_a: Vector3, post_b: Vector3, weight: float, b_t: float, pre_a_t: float, post_b_t: float) -> Vector3`
- 限定：qualifiers=const

Performs a cubic interpolation between this vector and `b` using `pre_a` and `post_b` as handles, and returns the result at position `weight`. `weight` is on the range of 0.0 to 1.0, representing the amount of interpolation.
				It can perform smoother interpolation than `cubic_interpolate` by the time values.

### `direction_to(to: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the normalized vector pointing from this vector to `to`. This is equivalent to using `(b - a).normalized()`.

### `distance_squared_to(to: Vector3) -> float`
- 限定：qualifiers=const

Returns the squared Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.
				This method runs faster than `distance_to`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `distance_to(to: Vector3) -> float`
- 限定：qualifiers=const

Returns the Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.

### `dot(with: Vector3) -> float`
- 限定：qualifiers=const

Returns the dot product of this vector and `with`. This can be used to compare the angle between two vectors. For example, this can be used to determine whether an enemy is facing the player.
				The dot product will be `0` for a right angle (90 degrees), greater than 0 for angles narrower than 90 degrees and lower than 0 for angles wider than 90 degrees.
				When using unit (normalized) vectors, the result will always be between `-1.0` (180 degree angle) when the vectors are facing opposite directions, and `1.0` (0 degree angle) when the vectors are aligned.
				**Note:** `a.dot(b)` is equivalent to `b.dot(a)`.

### `floor() -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components rounded down (towards negative infinity).

### `inverse() -> Vector3`
- 限定：qualifiers=const

Returns the inverse of the vector. This is the same as `Vector3(1.0 / v.x, 1.0 / v.y, 1.0 / v.z)`.

### `is_equal_approx(to: Vector3) -> bool`
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

### `lerp(to: Vector3, weight: float) -> Vector3`
- 限定：keywords=interpolate · qualifiers=const

Returns the result of the linear interpolation between this vector and `to` by amount `weight`. `weight` is on the range of `0.0` to `1.0`, representing the amount of interpolation.

### `limit_length(length: float = 1.0) -> Vector3`
- 限定：keywords=clamp, saturate, truncate · qualifiers=const

Returns the vector with a maximum length by limiting its length to `length`. If the vector is non-finite, the result is undefined.

### `max(with: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector3(maxf(x, with.x), maxf(y, with.y), maxf(z, with.z))`.

### `max_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's highest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_X`.

### `maxf(with: float) -> Vector3`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector3(maxf(x, with), maxf(y, with), maxf(z, with))`.

### `min(with: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector3(minf(x, with.x), minf(y, with.y), minf(z, with.z))`.

### `min_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's lowest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_Z`.

### `minf(with: float) -> Vector3`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector3(minf(x, with), minf(y, with), minf(z, with))`.

### `move_toward(to: Vector3, delta: float) -> Vector3`
- 限定：qualifiers=const

Returns a new vector moved toward `to` by the fixed `delta` amount. Will not go past the final value.

### `normalized() -> Vector3`
- 限定：qualifiers=const

Returns the result of scaling the vector to unit length. Equivalent to `v / v.length()`. Returns `(0, 0, 0)` if `v.length() == 0`. See also `is_normalized`.
				**Note:** This function may return incorrect values if the input vector length is near zero.

### `octahedron_decode(uv: Vector2) -> Vector3`
- 限定：qualifiers=static

Returns the `Vector3` from an octahedral-compressed form created using `octahedron_encode` (stored as a `Vector2`).

### `octahedron_encode() -> Vector2`
- 限定：qualifiers=const

Returns the octahedral-encoded (oct32) form of this `Vector3` as a `Vector2`. Since a `Vector2` occupies 1/3 less memory compared to `Vector3`, this form of compression can be used to pass greater amounts of `normalized` `Vector3`s without increasing storage or memory requirements. See also `octahedron_decode`.
				**Note:** `octahedron_encode` can only be used for `normalized` vectors. `octahedron_encode` does *not* check whether this `Vector3` is normalized, and will return a value that does not decompress to the original value if the `Vector3` is not normalized.
				**Note:** Octahedral compression is *lossy*, although visual differences are rarely perceptible in real world scenarios.

### `outer(with: Vector3) -> Basis`
- 限定：qualifiers=const

Returns the outer product with `with`.

### `posmod(mod: float) -> Vector3`
- 限定：qualifiers=const

Returns a vector composed of the `@GlobalScope.fposmod` of this vector's components and `mod`.

### `posmodv(modv: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns a vector composed of the `@GlobalScope.fposmod` of this vector's components and `modv`'s components.

### `project(b: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns a new vector resulting from projecting this vector onto the given vector `b`. The resulting new vector is parallel to `b`. See also `slide`.
				**Note:** If the vector `b` is a zero vector, the components of the resulting new vector will be `@GDScript.NAN`.

### `reflect(n: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns the result of reflecting the vector through a plane defined by the given normal vector `n`.
				**Note:** `reflect` differs from what other engines and frameworks call `skip-lint`reflect(). In other engines, `skip-lint`reflect() returns the result of the vector reflected by the given plane. The reflection thus passes through the given normal. While in Godot the reflection passes through the plane and can be thought of as bouncing off the normal. See also `bounce` which does what most engines call `skip-lint`reflect().

### `rotated(axis: Vector3, angle: float) -> Vector3`
- 限定：qualifiers=const

Returns the result of rotating this vector around a given axis by `angle` (in radians). The axis must be a normalized vector. See also `@GlobalScope.deg_to_rad`.

### `round() -> Vector3`
- 限定：qualifiers=const

Returns a new vector with all components rounded to the nearest integer, with halfway cases rounded away from zero.

### `sign() -> Vector3`
- 限定：qualifiers=const

Returns a new vector with each component set to `1.0` if it's positive, `-1.0` if it's negative, and `0.0` if it's zero. The result is identical to calling `@GlobalScope.sign` on each component.

### `signed_angle_to(to: Vector3, axis: Vector3) -> float`
- 限定：qualifiers=const

Returns the signed angle to the given vector, in radians. The sign of the angle is positive in a counter-clockwise direction and negative in a clockwise direction when viewed from the side specified by the `axis`.

### `slerp(to: Vector3, weight: float) -> Vector3`
- 限定：keywords=interpolate · qualifiers=const

Returns the result of spherical linear interpolation between this vector and `to`, by amount `weight`. `weight` is on the range of 0.0 to 1.0, representing the amount of interpolation.
				This method also handles interpolating the lengths if the input vectors have different lengths. For the special case of one or both input vectors having zero length, this method behaves like `lerp`.

### `slide(n: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns a new vector resulting from sliding this vector along a plane with normal `n`. The resulting new vector is perpendicular to `n`, and is equivalent to this vector minus its projection on `n`. See also `project`.
				**Note:** The vector `n` must be normalized. See also `normalized`.

### `snapped(step: Vector3) -> Vector3`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the nearest multiple of the corresponding component in `step`. This can also be used to round the components to an arbitrary number of decimals.

### `snappedf(step: float) -> Vector3`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the nearest multiple of `step`. This can also be used to round the components to an arbitrary number of decimals.

## 枚举

### `Axis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_X` |  |
| `1` | `AXIS_Y` |  |
| `2` | `AXIS_Z` |  |

## 常量

- **`ZERO`** = `Vector3(0, 0, 0)`
- **`ONE`** = `Vector3(1, 1, 1)`
- **`INF`** = `Vector3(inf, inf, inf)`
- **`LEFT`** = `Vector3(-1, 0, 0)`
- **`RIGHT`** = `Vector3(1, 0, 0)`
- **`UP`** = `Vector3(0, 1, 0)`
- **`DOWN`** = `Vector3(0, -1, 0)`
- **`FORWARD`** = `Vector3(0, 0, -1)`
- **`BACK`** = `Vector3(0, 0, 1)`
- **`MODEL_LEFT`** = `Vector3(1, 0, 0)`
- **`MODEL_RIGHT`** = `Vector3(-1, 0, 0)`
- **`MODEL_TOP`** = `Vector3(0, 1, 0)`
- **`MODEL_BOTTOM`** = `Vector3(0, -1, 0)`
- **`MODEL_FRONT`** = `Vector3(0, 0, 1)`
- **`MODEL_REAR`** = `Vector3(0, 0, -1)`
## 构造函数

### `Vector3`

Constructs a default-initialized `Vector3` with all components set to `0`.

### `Vector3`

Constructs a `Vector3` as a copy of the given `Vector3`.

### `Vector3`

Constructs a new `Vector3` from `Vector3i`.

### `Vector3`

Returns a `Vector3` with the given components.

## 运算符

### `operator !=`

Returns `true` if the vectors are not equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator *`

Inversely transforms (multiplies) the `Vector3` by the given `Basis` matrix, under the assumption that the basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).
				`vector * basis` is equivalent to `basis.transposed() * vector`. See `Basis.transposed`.
				For transforming by inverse of a non-orthonormal basis (e.g. with scaling) `basis.inverse() * vector` can be used instead. See `Basis.inverse`.

### `operator *`

Inversely transforms (multiplies) the `Vector3` by the given `Quaternion`.
				`vector * quaternion` is equivalent to `quaternion.inverse() * vector`. See `Quaternion.inverse`.

### `operator *`

Inversely transforms (multiplies) the `Vector3` by the given `Transform3D` transformation matrix, under the assumption that the transformation basis is orthonormal (i.e. rotation/reflection is fine, scaling/skew is not).
				`vector * transform` is equivalent to `transform.inverse() * vector`. See `Transform3D.inverse`.
				For transforming by inverse of an affine transformation (e.g. with scaling) `transform.affine_inverse() * vector` can be used instead. See `Transform3D.affine_inverse`.

### `operator *`

Multiplies each component of the `Vector3` by the components of the given `Vector3`.
				
```gdscript
				print(Vector3(10, 20, 30) * Vector3(3, 4, 5)) # Prints (30.0, 80.0, 150.0)
				
```

### `operator *`

Multiplies each component of the `Vector3` by the given `float`.

### `operator *`

Multiplies each component of the `Vector3` by the given `int`.

### `operator +`

Adds each component of the `Vector3` by the components of the given `Vector3`.
				
```gdscript
				print(Vector3(10, 20, 30) + Vector3(3, 4, 5)) # Prints (13.0, 24.0, 35.0)
				
```

### `operator -`

Subtracts each component of the `Vector3` by the components of the given `Vector3`.
				
```gdscript
				print(Vector3(10, 20, 30) - Vector3(3, 4, 5)) # Prints (7.0, 16.0, 25.0)
				
```

### `operator /`

Divides each component of the `Vector3` by the components of the given `Vector3`.
				
```gdscript
				print(Vector3(10, 20, 30) / Vector3(2, 5, 3)) # Prints (5.0, 4.0, 10.0)
				
```

### `operator /`

Divides each component of the `Vector3` by the given `float`.

### `operator /`

Divides each component of the `Vector3` by the given `int`.

### `operator <`

Compares two `Vector3` vectors by first checking if the X value of the left vector is less than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator <=`

Compares two `Vector3` vectors by first checking if the X value of the left vector is less than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator ==`

Returns `true` if the vectors are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >`

Compares two `Vector3` vectors by first checking if the X value of the left vector is greater than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >=`

Compares two `Vector3` vectors by first checking if the X value of the left vector is greater than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.
				**Note:** Vectors with `@GDScript.NAN` elements don't behave the same as other vectors. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator []`

Access vector components using their `index`. `v[0]` is equivalent to `v.x`, `v[1]` is equivalent to `v.y`, and `v[2]` is equivalent to `v.z`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Vector3`. This is the same as writing `Vector3(-v.x, -v.y, -v.z)`. This operation flips the direction of the vector while keeping the same magnitude. With floats, the number zero can be either positive or negative.

## 教程链接

- [Math documentation index](None)
- [Vector math](None)
- [Advanced vector math](None)
- [3Blue1Brown Essence of Linear Algebra](None)
- [Matrix Transform Demo](None)
- [All 3D Demos](None)

