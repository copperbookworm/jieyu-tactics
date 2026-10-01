# Vector2i

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Vector2i`
> 自动生成，勿手改。文件：`refs/godot-api/Vector2i.md`

**摘要**：A 2D vector using integer coordinates.

## 描述

A 2-element structure that can be used to represent 2D grid coordinates or any other pair of integers.
		It uses integer coordinates and is therefore preferable to `Vector2` when exact precision is required. Note that the values are limited to 32 bits, and unlike `Vector2` this cannot be configured with an engine build option. Use `int` or `PackedInt64Array` if 64-bit values are needed.
		**Note:** In a boolean context, a Vector2i will evaluate to `false` if it's equal to `Vector2i(0, 0)`. Otherwise, a Vector2i will always evaluate to `true`.

## 属性

- **`x`** `int` = `0`
  - 其它属性：getter= · setter=
- **`y`** `int` = `0`
  - 其它属性：getter= · setter=

## 方法

### `abs() -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with all components in absolute values (i.e. positive).

### `aspect() -> float`
- 限定：qualifiers=const

Returns the aspect ratio of this vector, the ratio of `x` to `y`.

### `clamp(min: Vector2i, max: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between the components of `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `clampi(min: int, max: int) -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with all components clamped between `min` and `max`, by running `@GlobalScope.clamp` on each component.

### `distance_squared_to(to: Vector2i) -> int`
- 限定：qualifiers=const

Returns the squared Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.
				This method runs faster than `distance_to`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `distance_to(to: Vector2i) -> float`
- 限定：qualifiers=const

Returns the Euclidean distance (https://en.wikipedia.org/wiki/Euclidean_distance) between this vector and `to`.

### `length() -> float`
- 限定：keywords=size · qualifiers=const

Returns the length (magnitude) of this vector.

### `length_squared() -> int`
- 限定：qualifiers=const

Returns the squared length (squared magnitude) of this vector.
				This method runs faster than `length`, so prefer it if you need to compare vectors or need the squared distance for some formula.

### `max(with: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector2i(maxi(x, with.x), maxi(y, with.y))`.

### `max_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's highest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_X`.

### `maxi(with: int) -> Vector2i`
- 限定：qualifiers=const

Returns the component-wise maximum of this and `with`, equivalent to `Vector2i(maxi(x, with), maxi(y, with))`.

### `min(with: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector2i(mini(x, with.x), mini(y, with.y))`.

### `min_axis_index() -> int`
- 限定：qualifiers=const

Returns the axis of the vector's lowest value. See `AXIS_*` constants. If all components are equal, this method returns `AXIS_Y`.

### `mini(with: int) -> Vector2i`
- 限定：qualifiers=const

Returns the component-wise minimum of this and `with`, equivalent to `Vector2i(mini(x, with), mini(y, with))`.

### `sign() -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with each component set to `1` if it's positive, `-1` if it's negative, and `0` if it's zero. The result is identical to calling `@GlobalScope.sign` on each component.

### `snapped(step: Vector2i) -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of the corresponding component in `step`.

### `snappedi(step: int) -> Vector2i`
- 限定：qualifiers=const

Returns a new vector with each component snapped to the closest multiple of `step`.

## 枚举

### `Axis`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `AXIS_X` |  |
| `1` | `AXIS_Y` |  |

## 常量

- **`ZERO`** = `Vector2i(0, 0)`
- **`ONE`** = `Vector2i(1, 1)`
- **`MIN`** = `Vector2i(-2147483648, -2147483648)`
- **`MAX`** = `Vector2i(2147483647, 2147483647)`
- **`LEFT`** = `Vector2i(-1, 0)`
- **`RIGHT`** = `Vector2i(1, 0)`
- **`UP`** = `Vector2i(0, -1)`
- **`DOWN`** = `Vector2i(0, 1)`
## 构造函数

### `Vector2i`

Constructs a default-initialized `Vector2i` with all components set to `0`.

### `Vector2i`

Constructs a `Vector2i` as a copy of the given `Vector2i`.

### `Vector2i`

Constructs a new `Vector2i` from the given `Vector2` by truncating components' fractional parts (rounding towards zero). For a different behavior consider passing the result of `Vector2.ceil`, `Vector2.floor` or `Vector2.round` to this constructor instead.

### `Vector2i`

Constructs a new `Vector2i` from the given `x` and `y`.

## 运算符

### `operator !=`

Returns `true` if the vectors are not equal.

### `operator %`

Gets the remainder of each component of the `Vector2i` with the components of the given `Vector2i`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector2i(10, -20) % Vector2i(7, 8)) # Prints (3, -4)
				
```

### `operator %`

Gets the remainder of each component of the `Vector2i` with the given `int`. This operation uses truncated division, which is often not desired as it does not work well with negative numbers. Consider using `@GlobalScope.posmod` instead if you want to handle negative numbers.
				
```gdscript
				print(Vector2i(10, -20) % 7) # Prints (3, -6)
				
```

### `operator *`

Multiplies each component of the `Vector2i` by the components of the given `Vector2i`.
				
```gdscript
				print(Vector2i(10, 20) * Vector2i(3, 4)) # Prints (30, 80)
				
```

### `operator *`

Multiplies each component of the `Vector2i` by the given `float`. Returns a `Vector2`.
				
```gdscript
				print(Vector2i(10, 15) * 0.9) # Prints (9.0, 13.5)
				
```

### `operator *`

Multiplies each component of the `Vector2i` by the given `int`.

### `operator +`

Adds each component of the `Vector2i` by the components of the given `Vector2i`.
				
```gdscript
				print(Vector2i(10, 20) + Vector2i(3, 4)) # Prints (13, 24)
				
```

### `operator -`

Subtracts each component of the `Vector2i` by the components of the given `Vector2i`.
				
```gdscript
				print(Vector2i(10, 20) - Vector2i(3, 4)) # Prints (7, 16)
				
```

### `operator /`

Divides each component of the `Vector2i` by the components of the given `Vector2i`.
				
```gdscript
				print(Vector2i(10, 20) / Vector2i(2, 5)) # Prints (5, 4)
				
```

### `operator /`

Divides each component of the `Vector2i` by the given `float`. Returns a `Vector2`.
				
```gdscript
				print(Vector2i(1, 2) / 2.5) # Prints (0.4, 0.8)
				
```

### `operator /`

Divides each component of the `Vector2i` by the given `int`.

### `operator <`

Compares two `Vector2i` vectors by first checking if the X value of the left vector is less than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

### `operator <=`

Compares two `Vector2i` vectors by first checking if the X value of the left vector is less than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

### `operator ==`

Returns `true` if the vectors are equal.

### `operator >`

Compares two `Vector2i` vectors by first checking if the X value of the left vector is greater than the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

### `operator >=`

Compares two `Vector2i` vectors by first checking if the X value of the left vector is greater than or equal to the X value of the `right` vector. If the X values are exactly equal, then it repeats this check with the Y values of the two vectors. This operator is useful for sorting vectors.

### `operator []`

Access vector components using their `index`. `v[0]` is equivalent to `v.x`, and `v[1]` is equivalent to `v.y`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `Vector2i`. This is the same as writing `Vector2i(-v.x, -v.y)`. This operation flips the direction of the vector while keeping the same magnitude.

## 教程链接

- [Math documentation index](None)
- [Vector math](None)
- [3Blue1Brown Essence of Linear Algebra](None)

