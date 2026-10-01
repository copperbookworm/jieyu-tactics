# Vector4i

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Vector4i`
> 自动生成，勿手改。文件：`refs/godot-api/Vector4i.md`

**摘要**：A 4D vector using integer coordinates.

## 描述

A 4-element structure that can be used to represent 4D grid coordinates or any other quadruplet of integers.
		It uses integer coordinates and is therefore preferable to `Vector4` when exact precision is required. Note that the values are limited to 32 bits, and unlike `Vector4` this cannot be configured with an engine build option. Use `int` or `PackedInt64Array` if 64-bit values are needed.
		**Note:** In a boolean context, a Vector4i will evaluate to `false` if it's equal to `Vector4i(0, 0, 0, 0)`. Otherwise, a Vector4i will always evaluate to `true`.

## 属性

- **`w`** `int` = `0`
  - 其它属性：getter= · setter=
- **`x`** `int` = `0`
  - 其它属性：getter= · setter=
- **`y`** `int` = `0`
  - 其它属性：getter= · setter=
- **`z`** `int` = `0`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with all components in absolute values (i.e. positive).

### `clamp(min: Vector4i, max: Vector4i) -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `clampi(min: int, max: int) -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `distance_squared_to(to: Vector4i) -> int`
- 限定：qualifiers=const

Returns the squared Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.
				This method runs faster than `distance_to`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `distance_to(to: Vector4i) -> float`
- 限定：qualifiers=const

Returns the Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.

### `length() -> float`
- 限定：keywords=size · qualifiers=const

Returns the length (magnitude) of this vector.

### `length_squared() -> int`
- 限定：qualifiers=const

Returns the squared length (squared magnitude) of this vector.
				This method runs faster than `length`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `max(with: Vector4i) -> Vector4i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector4i(maxi(x, with.x), maxi(y, with.y), maxi(z, with.z), maxi(w, with.w))`.

### `max_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's highest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_X`.

### `maxi(with: int) -> Vector4i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector4i(maxi(x, with), maxi(y, with), maxi(z, with), maxi(w, with))`.

### `min(with: Vector4i) -> Vector4i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector4i(mini(x, with.x), mini(y, with.y), mini(z, with.z), mini(w, with.w))`.

### `min_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's lowest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_W`.

### `mini(with: int) -> Vector4i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector4i(mini(x, with), mini(y, with), mini(z, with), mini(w, with))`.

### `sign() -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with each component set to `1` if it's positive, `-1` if it's negative, and `0` if it's zero. The result is identical to calling `@GlobalScope.sign` on each component.

### `snapped(step: Vector4i) -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of the corresponding component in `step`.

### `snappedi(step: int) -> Vector4i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of `step`.

## 枚举

### `Axis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_X` |  |
| `1` | `AXIS_Y` |  |
| `2` | `AXIS_Z` |  |
| `3` | `AXIS_W` |  |

## 常量

- **`ZERO`** = `Vector4i(0, 0, 0, 0)`
- **`ONE`** = `Vector4i(1, 1, 1, 1)`
- **`MIN`** = `Vector4i(-2147483648, -2147483648, -2147483648, -2147483648)`
- **`MAX`** = `Vector4i(2147483647, 2147483647, 2147483647, 2147483647)`
## 构造函数

### `Vector4i`

Constructs a default-initialized `Vector4i` with all components set to `0`.

### `Vector4i`

Constructs a `Vector4i` as a copy of the given `Vector4i`.

### `Vector4i`

Constructs a new `Vector4i` from the given `Vector4` by truncating components' fractional parts (rounding towards zero). For a different behavior consider passing the result of `Vector4.ceil`, `Vector4.floor` or `Vector4.round` to this constructor instead.

### `Vector4i`

Returns a `Vector4i` with the given components.

## 运算符

### `operator !=`

Returns `true` if the vectors are not equal.

### `operator %`

Gets the remainder of each component of the `Vector4i` with the components of the given `Vector4i`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector4i(10, -20, 30, -40) % Vector4i(7, 8, 9, 10)) # Prints (3, -4, 3, 0)
				
```

### `operator %`

Gets the remainder of each component of the `Vector4i` with the given `int`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector4i(10, -20, 30, -40) % 7) # Prints (3, -6, 2, -5)
				
```

### `operator *`

Multiplies each component of the `Vector4i` by the components of the given `Vector4i`.
				
```gdscript
				print(Vector4i(10, 20, 30, 40) * Vector4i(3, 4, 5, 6)) # Prints (30, 80, 150, 240)
				
```

### `operator *`

Multiplies each component of the `Vector4i` by the given `float`.
				Returns a Vector4 value due to floating-point operations.
				
```gdscript
				print(Vector4i(10, 20, 30, 40) * 2) # Prints (20.0, 40.0, 60.0, 80.0)
				
```

### `operator *`

Multiplies each component of the `Vector4i` by the given `int`.

### `operator +`

Adds each component of the `Vector4i` by the components of the given `Vector4i`.
				
```gdscript
				print(Vector4i(10, 20, 30, 40) + Vector4i(3, 4, 5, 6)) # Prints (13, 24, 35, 46)
				
```

### `operator -`

Subtracts each component of the `Vector4i` by the components of the given `Vector4i`.
				
```gdscript
				print(Vector4i(10, 20, 30, 40) - Vector4i(3, 4, 5, 6)) # Prints (7, 16, 25, 34)
				
```

### `operator /`

Divides each component of the `Vector4i` by the components of the given `Vector4i`.
				
```gdscript
				print(Vector4i(10, 20, 30, 40) / Vector4i(2, 5, 3, 4)) # Prints (5, 4, 10, 10)
				
```

### `operator /`

Divides each component of the `Vector4i` by the given `float`.
				Returns a Vector4 value due to floating-point operations.
				
```gdscript
				print(Vector4i(1, 2, 3, 4) / 2.5) # Prints (0.4, 0.8, 1.2, 1.6)
				
```

### `operator /`

Divides each component of the `Vector4i` by the given `int`.

### `operator <`

Compares two `Vector4i` vectors by first checking if the X value of the left vector is less than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

### `operator <=`

Compares two `Vector4i` vectors by first checking if the X value of the left vector is less than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

### `operator ==`

Returns `true` if the vectors are exactly equal.

### `operator >`

Compares two `Vector4i` vectors by first checking if the X value of the left vector is greater than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

### `operator >=`

Compares two `Vector4i` vectors by first checking if the X value of the left vector is greater than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, Z values of the two vectors, and then with the W values. This operator is useful for sorting vectors.

### `operator []`

Access vector components using their `index`. `v[0]` is equivalent to `v.x`, `v[1]` is equivalent to `v.y`, `v[2]` is equivalent to `v.z`, and `v[3]` is equivalent to `v.w`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Vector4i`. This is the same as writing `Vector4i(-v.x, -v.y, -v.z, -v.w)`. This operation flips the direction of the vector while keeping the same magnitude.

