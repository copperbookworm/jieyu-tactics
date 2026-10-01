# int

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`int`
> 自动生成，勿手改。文件：`refs/godot-api/int.md`

**摘要**：A built-in type for integers.

## 描述

Signed 64-bit integer type. This means that it can take values from `-2^63` to `2^63 - 1`, i.e. from `-9223372036854775808` to `9223372036854775807`. When it exceeds these bounds, it will wrap around.
		`int`s can be automatically converted to `float`s when necessary, for example when passing them as arguments in functions. The `float` will be as close to the original integer as possible.
		Likewise, `float`s can be automatically converted into `int`s. This will truncate the `float`, discarding anything after the floating-point.
		**Note:** In a boolean context, an `int` will evaluate to `false` if it equals `0`, and to `true` otherwise.
		`codeblocks`
		`gdscript`
		var x: int = 1 # x is 1
		x = 4.2 # x is 4, because 4.2 gets truncated
		var max_int = 9223372036854775807 # Biggest value an int can store
		max_int += 1 # max_int is -9223372036854775808, because it wrapped around
		
		`csharp`
		int x = 1; // x is 1
		x = (int)4.2; // x is 4, because 4.2 gets truncated
		// We use long below, because GDScript's int is 64-bit while C#'s int is 32-bit.
		long maxLong = 9223372036854775807; // Biggest value a long can store
		maxLong++; // maxLong is now -9223372036854775808, because it wrapped around.

		// Alternatively with C#'s 32-bit int type, which has a smaller maximum value.
		int maxInt = 2147483647; // Biggest value an int can store
		maxInt++; // maxInt is now -2147483648, because it wrapped around
		
		
		You can use the `0b` literal for binary representation, the `0x` literal for hexadecimal representation, and the `_` symbol to separate long numbers and improve readability.
		`codeblocks`
		`gdscript`
		var x = 0b1001 # x is 9
		var y = 0xF5 # y is 245
		var z = 10_000_000 # z is 10000000
		
		`csharp`
		int x = 0b1001; // x is 9
		int y = 0xF5; // y is 245
		int z = 10_000_000; // z is 10000000

## 构造函数

### `int`

Constructs an `int` set to `0`.

### `int`

Constructs an `int` as a copy of the given `int`.

### `int`

Constructs a new `int` from a `String`, following the same rules as `String.to_int`.

### `int`

Constructs a new `int` from a `bool`. `true` is converted to `1` and `false` is converted to `0`.

### `int`

Constructs a new `int` from a `float`. This will truncate the `float`, discarding anything after the floating point.

## 运算符

### `operator !=`

Returns `true` if the `int` is not equivalent to the `float`.

### `operator !=`

Returns `true` if the `int`s are not equal.

### `operator %`

Returns the remainder after dividing two `int`s. Uses truncated division, which returns a negative number if the dividend is negative. If this is not desired, consider using `@GlobalScope.posmod`.
				
```gdscript
				print(6 % 2) # Prints 0
				print(11 % 4) # Prints 3
				print(-5 % 3) # Prints -2
				
```

### `operator &`

Performs the bitwise `AND` operation.
				
```gdscript
				print(0b1100 & 0b1010) # Prints 8 (binary 1000)
				
```

				This is useful for retrieving binary flags from a variable.
				
```gdscript
				var flags = 0b101
				# Check if the first or second bit are enabled.
				if flags & 0b011:
					do_stuff() # This line will run.
				
```

### `operator *`

Multiplies each component of the `Color` by the `int`.

### `operator *`

Multiplies each component of the `Quaternion` by the `int`. This operation is not meaningful on its own, but it can be used as a part of a larger expression.

### `operator *`

Multiplies each component of the `Vector2` by the `int`.
				
```gdscript
				print(2 * Vector2(1, 4)) # Prints (2, 8)
				
```

### `operator *`

Multiplies each component of the `Vector2i` by the `int`.

### `operator *`

Multiplies each component of the `Vector3` by the `int`.

### `operator *`

Multiplies each component of the `Vector3i` by the `int`.

### `operator *`

Multiplies each component of the `Vector4` by the `int`.

### `operator *`

Multiplies each component of the `Vector4i` by the `int`.

### `operator *`

Multiplies the `float` by the `int`. The result is a `float`.

### `operator *`

Multiplies the two `int`s.

### `operator **`

Raises an `int` to a power of a `float`. The result is a `float`.
				
```gdscript
				print(2 ** 0.5) # Prints 1.4142135623731
				
```

### `operator **`

Raises the left `int` to a power of the right `int`.
				
```gdscript
				print(3 ** 4) # Prints 81
				
```

### `operator +`

Adds the `int` and the `float`. The result is a `float`.

### `operator +`

Adds the two `int`s.

### `operator -`

Subtracts the `float` from the `int`. The result is a `float`.

### `operator -`

Subtracts the two `int`s.

### `operator /`

Divides the `int` by the `float`. The result is a `float`.
				
```gdscript
				print(10 / 3.0) # Prints 3.33333333333333
				
```

### `operator /`

Divides the two `int`s. The result is an `int`. This will truncate the `float`, discarding anything after the floating point.
				
```gdscript
				print(6 / 2) # Prints 3
				print(5 / 3) # Prints 1
				
```

### `operator <`

Returns `true` if the `int` is less than the `float`.

### `operator <`

Returns `true` if the left `int` is less than the right `int`.

### `operator <<`

Performs the bitwise shift left operation. Effectively the same as multiplying by a power of 2.
				
```gdscript
				print(0b1010 << 1) # Prints 20 (binary 10100)
				print(0b1010 << 3) # Prints 80 (binary 1010000)
				
```

### `operator <=`

Returns `true` if the `int` is less than or equal to the `float`.

### `operator <=`

Returns `true` if the left `int` is less than or equal to the right `int`.

### `operator ==`

Returns `true` if the `int` is equal to the `float`.

### `operator ==`

Returns `true` if the two `int`s are equal.

### `operator >`

Returns `true` if the `int` is greater than the `float`.

### `operator >`

Returns `true` if the left `int` is greater than the right `int`.

### `operator >=`

Returns `true` if the `int` is greater than or equal to the `float`.

### `operator >=`

Returns `true` if the left `int` is greater than or equal to the right `int`.

### `operator >>`

Performs the bitwise shift right operation. Effectively the same as dividing by a power of 2.
				
```gdscript
				print(0b1010 >> 1) # Prints 5 (binary 101)
				print(0b1010 >> 2) # Prints 2 (binary 10)
				
```

### `operator ^`

Performs the bitwise `XOR` operation.
				
```gdscript
				print(0b1100 ^ 0b1010) # Prints 6 (binary 110)
				
```

### `operator unary+`

Returns the same value as if the `+` was not there. Unary `+` does nothing, but sometimes it can make your code more readable.

### `operator unary-`

Returns the negated value of the `int`. If positive, turns the number negative. If negative, turns the number positive. If zero, does nothing.

### `operator |`

Performs the bitwise `OR` operation.
				
```gdscript
				print(0b1100 | 0b1010) # Prints 14 (binary 1110)
				
```

				This is useful for storing binary flags in a variable.
				
```gdscript
				var flags = 0
				flags |= 0b101 # Turn the first and third bits on.
				
```

### `operator ~`

Performs the bitwise `NOT` operation on the `int`. Due to 2's complement (https://en.wikipedia.org/wiki/Two%27s_complement), it's effectively equal to `-(int + 1)`.
				
```gdscript
				print(~4) # Prints -5
				print(~(-7)) # Prints 6
				
```

