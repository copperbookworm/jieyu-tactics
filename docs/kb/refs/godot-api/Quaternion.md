# Quaternion

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Quaternion`
> 自动生成，勿手改。文件：`refs/godot-api/Quaternion.md`

**摘要**：A unit quaternion used for representing 3D rotations.

## 描述

The `Quaternion` built-in `Variant` type is a 4D data structure that represents rotation in the form of a Hamilton convention quaternion (https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation). Compared to the `Basis` type which can store both rotation and scale, quaternions can *only* store rotation.
		A `Quaternion` is composed by 4 floating-point components: `w`, `x`, `y`, and `z`. These components are very compact in memory, and because of this some operations are more efficient and less likely to cause floating-point errors. Methods such as `get_angle`, `get_axis`, and `slerp` are faster than their `Basis` counterparts.
		For a great introduction to quaternions, see this video by 3Blue1Brown (https://www.youtube.com/watch?v=d4EgbgTm0Bg). You do not need to know the math behind quaternions, as Godot provides several helper methods that handle it for you. These include `slerp` and `spherical_cubic_interpolate`, as well as the `*` operator.
		**Note:** Quaternions must be normalized before being used for rotation (see `normalized`).
		**Note:** Similarly to `Vector2` and `Vector3`, the components of a quaternion use 32-bit precision by default, unlike `float` which is always 64-bit. If double precision is needed, compile the engine with the option `precision=double`.
		**Note:** In a boolean context, a quaternion will evaluate to `false` if it's equal to `IDENTITY`. Otherwise, a quaternion will always evaluate to `true`.

## 属性

- **`w`** `float` = `1.0`
  - 其它属性：getter= · setter=
- **`x`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`y`** `float` = `0.0`
  - 其它属性：getter= · setter=
- **`z`** `float` = `0.0`
  - 其它属性：getter= · setter=

## 方法

### `angle_to(to: Quaternion) -> float`
- 限定：qualifiers=const

Returns the angle between this quaternion and `to`. This is the magnitude of the angle you would need to rotate by to get from one to the other.
				**Note:** The magnitude of the floating-point error for this method is abnormally high, so methods such as `is_zero_approx` will not work reliably.

### `dot(with: Quaternion) -> float`
- 限定：qualifiers=const

Returns the dot product between this quaternion and `with`.
				This is equivalent to `(quat.x * with.x) + (quat.y * with.y) + (quat.z * with.z) + (quat.w * with.w)`.

### `exp() -> Quaternion`
- 限定：qualifiers=const

Returns the exponential of this quaternion. The rotation axis of the result is the normalized rotation axis of this quaternion, the angle of the result is the length of the vector part of this quaternion.

### `from_euler(euler: Vector3) -> Quaternion`
- 限定：qualifiers=static

Constructs a new `Quaternion` from the given `Vector3` of Euler angles (https://en.wikipedia.org/wiki/Euler_angles), in radians. In Godot, Euler angles always use intrinsic order. This method always uses the intrinsic YXZ convention (`EULER_ORDER_YXZ`).

### `get_angle() -> float`
- 限定：qualifiers=const

Returns the angle of the rotation represented by this quaternion.
				**Note:** The quaternion must be normalized.

### `get_axis() -> Vector3`
- 限定：qualifiers=const

Returns the rotation axis of the rotation represented by this quaternion.

### `get_euler(order: int = 2) -> Vector3`
- 限定：qualifiers=const

Returns this quaternion's rotation as a `Vector3` of Euler angles (https://en.wikipedia.org/wiki/Euler_angles), in radians.
				The order of each consecutive rotation can be changed with `order` (see `EulerOrder` constants). In Godot, Euler angles always use intrinsic order. By default, the intrinsic YXZ convention is used (`EULER_ORDER_YXZ`): since we are decomposing, local Z (roll) is calculated first, then local X (pitch), and lastly local Y (yaw). When using the opposite method `from_euler` to compose a rotation, this order is reversed.

### `inverse() -> Quaternion`
- 限定：qualifiers=const

Returns the inverse version of this quaternion, inverting the sign of every component except `w`.

### `is_equal_approx(to: Quaternion) -> bool`
- 限定：qualifiers=const

Returns `true` if this quaternion and `to` are approximately equal, by calling `@GlobalScope.is_equal_approx` on each component.

### `is_finite() -> bool`
- 限定：qualifiers=const

Returns `true` if this quaternion is finite, by calling `@GlobalScope.is_finite` on each component.

### `is_normalized() -> bool`
- 限定：qualifiers=const

Returns `true` if this quaternion is normalized. See also `normalized`.

### `length() -> float`
- 限定：keywords=size · qualifiers=const

Returns this quaternion's length, also called magnitude.

### `length_squared() -> float`
- 限定：qualifiers=const

Returns this quaternion's length, squared.
				**Note:** This method is faster than `length`, so prefer it if you only need to compare quaternion lengths.

### `log() -> Quaternion`
- 限定：qualifiers=const

Returns the logarithm of this quaternion. Multiplies this quaternion's rotation axis by its rotation angle, and stores the result in the returned quaternion's vector part (`x`, `y`, and `z`). The returned quaternion's real part (`w`) is always `0.0`.

### `normalized() -> Quaternion`
- 限定：qualifiers=const

Returns a copy of this quaternion, normalized so that its length is `1.0`. See also `is_normalized`.

### `slerp(to: Quaternion, weight: float) -> Quaternion`
- 限定：keywords=interpolate · qualifiers=const

Performs a spherical-linear interpolation with the `to` quaternion, given a `weight` and returns the result. Both this quaternion and `to` must be normalized.

### `slerpni(to: Quaternion, weight: float) -> Quaternion`
- 限定：qualifiers=const

Performs a spherical-linear interpolation with the `to` quaternion, given a `weight` and returns the result. Unlike `slerp`, this method does not check if the rotation path is smaller than 90 degrees. Both this quaternion and `to` must be normalized.

### `spherical_cubic_interpolate(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float) -> Quaternion`
- 限定：qualifiers=const

Performs a spherical cubic interpolation between quaternions `pre_a`, this vector, `b`, and `post_b`, by the given amount `weight`.

### `spherical_cubic_interpolate_in_time(b: Quaternion, pre_a: Quaternion, post_b: Quaternion, weight: float, b_t: float, pre_a_t: float, post_b_t: float) -> Quaternion`
- 限定：qualifiers=const

Performs a spherical cubic interpolation between quaternions `pre_a`, this vector, `b`, and `post_b`, by the given amount `weight`.
				It can perform smoother interpolation than `spherical_cubic_interpolate` by the time values.

## 常量

- **`IDENTITY`** = `Quaternion(0, 0, 0, 1)`
## 构造函数

### `Quaternion`

Constructs a `Quaternion` identical to `IDENTITY`.
				**Note:** In C#, this constructs a `Quaternion` with all of its components set to `0.0`.

### `Quaternion`

Constructs a `Quaternion` as a copy of the given `Quaternion`.

### `Quaternion`

Constructs a `Quaternion` representing the shortest arc between `arc_from` and `arc_to`. These can be imagined as two points intersecting a sphere's surface, with a radius of `1.0`.

### `Quaternion`

Constructs a `Quaternion` representing rotation around the `axis` by the given `angle`, in radians. The axis must be a normalized vector.

### `Quaternion`

Constructs a `Quaternion` from the given rotation `Basis`.
				This constructor is faster than `Basis.get_rotation_quaternion`, but the given basis must be *orthonormalized* (see `Basis.orthonormalized`). Otherwise, the constructor fails and returns `IDENTITY`.

### `Quaternion`

Constructs a `Quaternion` defined by the given values.
				**Note:** Only normalized quaternions represent rotation; if these values are not normalized, the new `Quaternion` will not be a valid rotation.

## 运算符

### `operator !=`

Returns `true` if the components of both quaternions are not exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator *`

Composes (multiplies) two quaternions. This rotates the `right` quaternion (the child) by this quaternion (the parent).

### `operator *`

Rotates (multiplies) the `right` vector by this quaternion, returning a `Vector3`.

### `operator *`

Multiplies each component of the `Quaternion` by the right `float` value.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator *`

Multiplies each component of the `Quaternion` by the right `int` value.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator +`

Adds each component of the left `Quaternion` to the right `Quaternion`.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression, such as approximating an intermediate rotation between two nearby rotations.

### `operator -`

Subtracts each component of the left `Quaternion` by the right `Quaternion`.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator /`

Divides each component of the `Quaternion` by the right `float` value.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator /`

Divides each component of the `Quaternion` by the right `int` value.
				This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator ==`

Returns `true` if the components of both quaternions are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `is_equal_approx` instead, which is more reliable.

### `operator []`

Accesses each component of this quaternion by their index.
				Index `0` is the same as `x`, index `1` is the same as `y`, index `2` is the same as `z`, and index `3` is the same as `w`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Quaternion`. This is the same as multiplying all components by `-1`. This operation results in a quaternion that represents the same rotation.

## 教程链接

- [3Blue1Brown's video on Quaternions](None)
- [Online Quaternion Visualization](None)
- [Using 3D transforms](None)
- [Third Person Shooter (TPS) Demo](None)
- [Advanced Quaternion Visualization](None)

