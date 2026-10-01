# Vector3i

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Vector3i`
> 自动生成，勿手改。文件：`refs/godot-api/Vector3i.md`

**摘要**：A 3D vector using integer coordinates.

## 描述

A 3-element structure that can be used to represent 3D grid coordinates or any other triplet of integers.
		It uses integer coordinates and is therefore preferable to `Vector3` when exact precision is required. Note that the values are limited to 32 bits, and unlike `Vector3` this cannot be configured with an engine build option. Use `int` or `PackedInt64Array` if 64-bit values are needed.
		**Note:** In a boolean context, a Vector3i will evaluate to `false` if it's equal to `Vector3i(0, 0, 0)`. Otherwise, a Vector3i will always evaluate to `true`.

## 属性

- **`x`** `int` = `0`
  - 其它属性：getter= · setter=
- **`y`** `int` = `0`
  - 其它属性：getter= · setter=
- **`z`** `int` = `0`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with all components in absolute values (i.e. positive).

### `clamp(min: Vector3i, max: Vector3i) -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `clampi(min: int, max: int) -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `distance_squared_to(to: Vector3i) -> int`
- 限定：qualifiers=const

Returns the squared Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.
				This method runs faster than `distance_to`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `distance_to(to: Vector3i) -> float`
- 限定：qualifiers=const

Returns the Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.

### `length() -> float`
- 限定：keywords=size · qualifiers=const

Returns the length (magnitude) of this vector.

### `length_squared() -> int`
- 限定：qualifiers=const

Returns the squared length (squared magnitude) of this vector.
				This method runs faster than `length`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `max(with: Vector3i) -> Vector3i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector3i(maxi(x, with.x), maxi(y, with.y), maxi(z, with.z))`.

### `max_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's highest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_X`.

### `maxi(with: int) -> Vector3i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector3i(maxi(x, with), maxi(y, with), maxi(z, with))`.

### `min(with: Vector3i) -> Vector3i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector3i(mini(x, with.x), mini(y, with.y), mini(z, with.z))`.

### `min_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's lowest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_Z`.

### `mini(with: int) -> Vector3i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector3i(mini(x, with), mini(y, with), mini(z, with))`.

### `sign() -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with each component set to `1` if it's positive, `-1` if it's negative, and `0` if it's zero. The result is identical to calling `@GlobalScope.sign` on each component.

### `snapped(step: Vector3i) -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of the corresponding component in `step`.

### `snappedi(step: int) -> Vector3i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of `step`.

## 枚举

### `Axis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_X` |  |
| `1` | `AXIS_Y` |  |
| `2` | `AXIS_Z` |  |

## 常量

- **`ZERO`** = `Vector3i(0, 0, 0)`
- **`ONE`** = `Vector3i(1, 1, 1)`
- **`MIN`** = `Vector3i(-2147483648, -2147483648, -2147483648)`
- **`MAX`** = `Vector3i(2147483647, 2147483647, 2147483647)`
- **`LEFT`** = `Vector3i(-1, 0, 0)`
- **`RIGHT`** = `Vector3i(1, 0, 0)`
- **`UP`** = `Vector3i(0, 1, 0)`
- **`DOWN`** = `Vector3i(0, -1, 0)`
- **`FORWARD`** = `Vector3i(0, 0, -1)`
- **`BACK`** = `Vector3i(0, 0, 1)`
## 构造函数

### `Vector3i`

Constructs a default-initialized `Vector3i` with all components set to `0`.

### `Vector3i`

Constructs a `Vector3i` as a copy of the given `Vector3i`.

### `Vector3i`

Constructs a new `Vector3i` from the given `Vector3` by truncating components' fractional parts (rounding towards zero). For a different behavior consider passing the result of `Vector3.ceil`, `Vector3.floor` or `Vector3.round` to this constructor instead.

### `Vector3i`

Returns a `Vector3i` with the given components.

## 运算符

### `operator !=`

Returns `true` if the vectors are not equal.

### `operator %`

Gets the remainder of each component of the `Vector3i` with the components of the given `Vector3i`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector3i(10, -20, 30) % Vector3i(7, 8, 9)) # Prints (3, -4, 3)
				
```

### `operator %`

Gets the remainder of each component of the `Vector3i` with the given `int`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector3i(10, -20, 30) % 7) # Prints (3, -6, 2)
				
```

### `operator *`

Multiplies each component of the `Vector3i` by the components of the given `Vector3i`.
				
```gdscript
				print(Vector3i(10, 20, 30) * Vector3i(3, 4, 5)) # Prints (30, 80, 150)
				
```

### `operator *`

Multiplies each component of the `Vector3i` by the given `float`. Returns a `Vector3`.
				
```gdscript
				print(Vector3i(10, 15, 20) * 0.9) # Prints (9.0, 13.5, 18.0)
				
```

### `operator *`

Multiplies each component of the `Vector3i` by the given `int`.

### `operator +`

Adds each component of the `Vector3i` by the components of the given `Vector3i`.
				
```gdscript
				print(Vector3i(10, 20, 30) + Vector3i(3, 4, 5)) # Prints (13, 24, 35)
				
```

### `operator -`

Subtracts each component of the `Vector3i` by the components of the given `Vector3i`.
				
```gdscript
				print(Vector3i(10, 20, 30) - Vector3i(3, 4, 5)) # Prints (7, 16, 25)
				
```

### `operator /`

Divides each component of the `Vector3i` by the components of the given `Vector3i`.
				
```gdscript
				print(Vector3i(10, 20, 30) / Vector3i(2, 5, 3)) # Prints (5, 4, 10)
				
```

### `operator /`

Divides each component of the `Vector3i` by the given `float`. Returns a `Vector3`.
				
```gdscript
				print(Vector3i(1, 2, 3) / 2.5) # Prints (0.4, 0.8, 1.2)
				
```

### `operator /`

Divides each component of the `Vector3i` by the given `int`.

### `operator <`

Compares two `Vector3i` vectors by first checking if the X value of the left vector is less than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

### `operator <=`

Compares two `Vector3i` vectors by first checking if the X value of the left vector is less than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

### `operator ==`

Returns `true` if the vectors are equal.

### `operator >`

Compares two `Vector3i` vectors by first checking if the X value of the left vector is greater than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

### `operator >=`

Compares two `Vector3i` vectors by first checking if the X value of the left vector is greater than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors, and then with the Z values. This operator is useful for sorting vectors.

### `operator []`

Access vector components using their `index`. `v[0]` is equivalent to `v.x`, `v[1]` is equivalent to `v.y`, and `v[2]` is equivalent to `v.z`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Vector3i`. This is the same as writing `Vector3i(-v.x, -v.y, -v.z)`. This operation flips the direction of the vector while keeping the same magnitude.

## 教程链接

- [Math documentation index](None)
- [Vector math](None)
- [3Blue1Brown Essence of Linear Algebra](None)

