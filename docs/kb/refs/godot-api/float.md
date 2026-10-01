# float

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`float`
> 自动生成，勿手改。文件：`refs/godot-api/float.md`

**摘要**：A built-in type for floating-point numbers.

## 描述

The `float` built-in type is a 64-bit double-precision floating-point number, equivalent to `double` in C++. This type has 14 reliable decimal digits of precision. The maximum value of `float` is approximately `1.79769e308`, and the minimum is approximately `-1.79769e308`.
		Many methods and properties in the engine use 32-bit single-precision floating-point numbers instead, equivalent to `skip-lint`float in C++, which have 6 reliable decimal digits of precision. For data structures such as `Vector2` and `Vector3`, Godot uses 32-bit floating-point numbers by default, but it can be changed to use 64-bit doubles if Godot is compiled with the `precision=double` option.
		Math done using the `float` type is not guaranteed to be exact and will often result in small errors. You should usually use the `@GlobalScope.is_equal_approx` and `@GlobalScope.is_zero_approx` methods instead of `==` to compare `float` values for equality.
		**Note:** In a boolean context, a `float` will evaluate to `false` if it's exactly equal to `0.0`, and to `true` otherwise.

## 构造函数

### `float`

Constructs a default-initialized `float` set to `0.0`.

### `float`

Constructs a `float` as a copy of the given `float`.

### `float`

Converts a `String` to a `float`, following the same rules as `String.to_float`.

### `float`

Cast a `bool` value to a floating-point value, `float(true)` will be equal to 1.0 and `float(false)` will be equal to 0.0.

### `float`

Cast an `int` value to a floating-point value, `float(1)` will be equal to `1.0`.

## 运算符

### `operator !=`

Returns `true` if two floats are different from each other.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator !=`

Returns `true` if the integer has different value than the float.

### `operator *`

Multiplies each component of the `Color`, including the alpha, by the given `float`.
				
```gdscript
				print(1.5 * Color(0.5, 0.5, 0.5)) # Prints (0.75, 0.75, 0.75, 1.5)
				
```

### `operator *`

Multiplies each component of the `Quaternion` by the given `float`. This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator *`

Multiplies each component of the `Vector2` by the given `float`.
				
```gdscript
				print(2.5 * Vector2(1, 3)) # Prints (2.5, 7.5)
				
```

### `operator *`

Multiplies each component of the `Vector2i` by the given `float`. Returns a `Vector2`.
				
```gdscript
				print(0.9 * Vector2i(10, 15)) # Prints (9.0, 13.5)
				
```

### `operator *`

Multiplies each component of the `Vector3` by the given `float`.

### `operator *`

Multiplies each component of the `Vector3i` by the given `float`. Returns a `Vector3`.
				
```gdscript
				print(0.9 * Vector3i(10, 15, 20)) # Prints (9.0, 13.5, 18.0)
				
```

### `operator *`

Multiplies each component of the `Vector4` by the given `float`.

### `operator *`

Multiplies each component of the `Vector4i` by the given `float`. Returns a `Vector4`.
				
```gdscript
				print(0.9 * Vector4i(10, 15, 20, -10)) # Prints (9.0, 13.5, 18.0, -9.0)
				
```

### `operator *`

Multiplies two `float`s.

### `operator *`

Multiplies a `float` and an `int`. The result is a `float`.

### `operator **`

Raises a `float` to a power of a `float`.
				
```gdscript
				print(39.0625**0.25) # 2.5
				
```

### `operator **`

Raises a `float` to a power of an `int`. The result is a `float`.
				
```gdscript
				print(0.9**3) # 0.729
				
```

### `operator +`

Adds two floats.

### `operator +`

Adds a `float` and an `int`. The result is a `float`.

### `operator -`

Subtracts a float from a float.

### `operator -`

Subtracts an `int` from a `float`. The result is a `float`.

### `operator /`

Divides two floats.

### `operator /`

Divides a `float` by an `int`. The result is a `float`.

### `operator <`

Returns `true` if the left float is less than the right one.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator <`

Returns `true` if this `float` is less than the given `int`.

### `operator <=`

Returns `true` if the left float is less than or equal to the right one.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator <=`

Returns `true` if this `float` is less than or equal to the given `int`.

### `operator ==`

Returns `true` if both floats are exactly equal.
				**Note:** Due to floating-point precision errors, consider using `@GlobalScope.is_equal_approx` or `@GlobalScope.is_zero_approx` instead, which are more reliable.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator ==`

Returns `true` if the `float` and the given `int` are equal.

### `operator >`

Returns `true` if the left float is greater than the right one.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >`

Returns `true` if this `float` is greater than the given `int`.

### `operator >=`

Returns `true` if the left float is greater than or equal to the right one.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this operator may not be accurate if NaNs are included.

### `operator >=`

Returns `true` if this `float` is greater than or equal to the given `int`.

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negative value of the `float`. If positive, turns the number negative. If negative, turns the number positive. With floats, the number zero can be either positive or negative.

## 教程链接

- [Wikipedia: Double-precision floating-point format](None)
- [Wikipedia: Single-precision floating-point format](None)

