# @GlobalScope

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`@GlobalScope`
> 自动生成，勿手改。文件：`refs/godot-api/@GlobalScope.md`

**摘要**：Global scope constants and functions.

## 描述

A list of global scope enumerated constants and built-in functions. This is all that resides in the globals, constants regarding error codes, keycodes, property hints, etc.
		Singletons are also documented here, since they can be accessed from anywhere.
		For the entries that can only be accessed from scripts written in GDScript, see `@GDScript`.

## 属性

- **`AccessibilityServer`** `AccessibilityServer`
  - 其它属性：getter= · setter=
- **`AudioServer`** `AudioServer`
  - 其它属性：getter= · setter=
- **`CameraServer`** `CameraServer`
  - 其它属性：getter= · setter=
- **`ClassDB`** `ClassDB`
  - 其它属性：getter= · setter=
- **`DisplayServer`** `DisplayServer`
  - 其它属性：getter= · setter=
- **`EditorInterface`** `EditorInterface`
  - 其它属性：getter= · setter=
- **`Engine`** `Engine`
  - 其它属性：getter= · setter=
- **`EngineDebugger`** `EngineDebugger`
  - 其它属性：getter= · setter=
- **`GDExtensionManager`** `GDExtensionManager`
  - 其它属性：getter= · setter=
- **`GDScriptLanguageProtocol`** `GDScriptLanguageProtocol`
  - 其它属性：getter= · setter=
- **`Geometry2D`** `Geometry2D`
  - 其它属性：getter= · setter=
- **`Geometry3D`** `Geometry3D`
  - 其它属性：getter= · setter=
- **`IP`** `IP`
  - 其它属性：getter= · setter=
- **`Input`** `Input`
  - 其它属性：getter= · setter=
- **`InputMap`** `InputMap`
  - 其它属性：getter= · setter=
- **`JavaClassWrapper`** `JavaClassWrapper`
  - 其它属性：getter= · setter=
- **`JavaScriptBridge`** `JavaScriptBridge`
  - 其它属性：getter= · setter=
- **`Marshalls`** `Marshalls`
  - 其它属性：getter= · setter=
- **`NativeMenu`** `NativeMenu`
  - 其它属性：getter= · setter=
- **`NavigationMeshGenerator`** `NavigationMeshGenerator`
  - 其它属性：getter= · setter=
- **`NavigationServer2D`** `NavigationServer2D`
  - 其它属性：getter= · setter=
- **`NavigationServer2DManager`** `NavigationServer2DManager`
  - 其它属性：getter= · setter=
- **`NavigationServer3D`** `NavigationServer3D`
  - 其它属性：getter= · setter=
- **`NavigationServer3DManager`** `NavigationServer3DManager`
  - 其它属性：getter= · setter=
- **`OS`** `OS`
  - 其它属性：getter= · setter=
- **`Performance`** `Performance`
  - 其它属性：getter= · setter=
- **`PhysicsServer2D`** `PhysicsServer2D`
  - 其它属性：getter= · setter=
- **`PhysicsServer2DManager`** `PhysicsServer2DManager`
  - 其它属性：getter= · setter=
- **`PhysicsServer3D`** `PhysicsServer3D`
  - 其它属性：getter= · setter=
- **`PhysicsServer3DManager`** `PhysicsServer3DManager`
  - 其它属性：getter= · setter=
- **`ProjectSettings`** `ProjectSettings`
  - 其它属性：getter= · setter=
- **`RenderingServer`** `RenderingServer`
  - 其它属性：getter= · setter=
- **`ResourceLoader`** `ResourceLoader`
  - 其它属性：getter= · setter=
- **`ResourceSaver`** `ResourceSaver`
  - 其它属性：getter= · setter=
- **`ResourceUID`** `ResourceUID`
  - 其它属性：getter= · setter=
- **`TextServerManager`** `TextServerManager`
  - 其它属性：getter= · setter=
- **`ThemeDB`** `ThemeDB`
  - 其它属性：getter= · setter=
- **`Time`** `Time`
  - 其它属性：getter= · setter=
- **`TranslationServer`** `TranslationServer`
  - 其它属性：getter= · setter=
- **`WorkerThreadPool`** `WorkerThreadPool`
  - 其它属性：getter= · setter=
- **`XRServer`** `XRServer`
  - 其它属性：getter= · setter=

## 方法

### `abs(x: Variant) -> Variant`

Returns the absolute value of a `Variant` parameter `x` (i.e. non-negative value). Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				var a = abs(-1)
				# a is 1

				var b = abs(-1.2)
				# b is 1.2

				var c = abs(Vector2(-3.5, -4))
				# c is (3.5, 4)

				var d = abs(Vector2i(-5, -6))
				# d is (5, 6)

				var e = abs(Vector3(-7, 8.5, -3.8))
				# e is (7, 8.5, 3.8)

				var f = abs(Vector3i(-7, -8, -9))
				# f is (7, 8, 9)
				
```

				**Note:** For better type safety, use `absf`, `absi`, `Vector2.abs`, `Vector2i.abs`, `Vector3.abs`, `Vector3i.abs`, `Vector4.abs`, or `Vector4i.abs`.

### `absf(x: float) -> float`

Returns the absolute value of float parameter `x` (i.e. positive value).
				
```gdscript
				# a is 1.2
				var a = absf(-1.2)
				
```

### `absi(x: int) -> int`

Returns the absolute value of int parameter `x` (i.e. positive value).
				
```gdscript
				# a is 1
				var a = absi(-1)
				
```

### `acos(x: float) -> float`

Returns the arc cosine of `x` in radians. Use to get the angle of cosine `x`. `x` will be clamped between `-1.0` and `1.0` (inclusive), in order to prevent `acos` from returning `@GDScript.NAN`.
				
```gdscript
				# c is 0.523599 or 30 degrees if converted with rad_to_deg(c)
				var c = acos(0.866025)
				
```

### `acosh(x: float) -> float`

Returns the hyperbolic arc (also called inverse) cosine of `x`, returning a value in radians. Use it to get the angle from an angle's cosine in hyperbolic space if `x` is larger or equal to 1. For values of `x` lower than 1, it will return 0, in order to prevent `acosh` from returning `@GDScript.NAN`.
				
```gdscript
				var a = acosh(2) # Returns 1.31695789692482
				cosh(a) # Returns 2

				var b = acosh(-1) # Returns 0
				
```

### `angle_difference(from: float, to: float) -> float`

Returns the difference between the two angles (in radians), in the range of `[-PI, +PI]`. When `from` and `to` are opposite, returns `-PI` if `from` is smaller than `to`, or `PI` otherwise.

### `asin(x: float) -> float`

Returns the arc sine of `x` in radians. Use to get the angle of sine `x`. `x` will be clamped between `-1.0` and `1.0` (inclusive), in order to prevent `asin` from returning `@GDScript.NAN`.
				
```gdscript
				# s is 0.523599 or 30 degrees if converted with rad_to_deg(s)
				var s = asin(0.5)
				
```

### `asinh(x: float) -> float`

Returns the hyperbolic arc (also called inverse) sine of `x`, returning a value in radians. Use it to get the angle from an angle's sine in hyperbolic space.
				
```gdscript
				var a = asinh(0.9) # Returns 0.8088669356527824
				sinh(a) # Returns 0.9
				
```

### `atan(x: float) -> float`

Returns the arc tangent of `x` in radians. Use it to get the angle from an angle's tangent in trigonometry.
				The method cannot know in which quadrant the angle should fall. See `atan2` if you have both `y` and `skip-lint`x.
				
```gdscript
				var a = atan(0.5) # a is 0.463648
				
```

				If `x` is between `-PI / 2` and `PI / 2` (inclusive), `atan(tan(x))` is equal to `x`.

### `atan2(y: float, x: float) -> float`

Returns the arc tangent of `y/x` in radians. Use to get the angle of tangent `y/x`. To compute the value, the method takes into account the sign of both arguments in order to determine the quadrant.
				Important note: The Y coordinate comes first, by convention.
				
```gdscript
				var a = atan2(0, -1) # a is 3.141593
				
```

### `atanh(x: float) -> float`

Returns the hyperbolic arc (also called inverse) tangent of `x`, returning a value in radians. Use it to get the angle from an angle's tangent in hyperbolic space if `x` is between -1 and 1 (non-inclusive).
				In mathematics, the inverse hyperbolic tangent is only defined for -1 < `x` < 1 in the real set, so values equal or lower to -1 for `x` return negative `@GDScript.INF` and values equal or higher than 1 return positive `@GDScript.INF` in order to prevent `atanh` from returning `@GDScript.NAN`.
				
```gdscript
				var a = atanh(0.9) # Returns 1.47221948958322
				tanh(a) # Returns 0.9

				var b = atanh(-2) # Returns -inf
				tanh(b) # Returns -1
				
```

### `bezier_derivative(start: float, control_1: float, control_2: float, end: float, t: float) -> float`

Returns the derivative at the given `t` on a one-dimensional Bézier curve (https://en.wikipedia.org/wiki/B%C3%A9zier_curve) defined by the given `control_1`, `control_2`, and `end` points.

### `bezier_interpolate(start: float, control_1: float, control_2: float, end: float, t: float) -> float`

Returns the point at the given `t` on a one-dimensional Bézier curve (https://en.wikipedia.org/wiki/B%C3%A9zier_curve) defined by the given `control_1`, `control_2`, and `end` points.

### `bytes_to_var(bytes: PackedByteArray) -> Variant`

Decodes a byte array back to a `Variant` value, without decoding objects.
				**Note:** If you need object deserialization, see `bytes_to_var_with_objects`.

### `bytes_to_var_with_objects(bytes: PackedByteArray) -> Variant`

Decodes a byte array back to a `Variant` value. Decoding objects is allowed.
				**Warning:** Deserialized object can contain code which gets executed. Do not use this option if the serialized object comes from untrusted sources to avoid potential security threats (remote code execution).

### `ceil(x: Variant) -> Variant`

Rounds `x` upward (towards positive infinity), returning the smallest whole number that is not less than `x`. Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				var i = ceil(1.45) # i is 2.0
				i = ceil(1.001)    # i is 2.0
				
```

				See also `floor`, `round`, and `snapped`.
				**Note:** For better type safety, use `ceilf`, `ceili`, `Vector2.ceil`, `Vector3.ceil`, or `Vector4.ceil`.

### `ceilf(x: float) -> float`

Rounds `x` upward (towards positive infinity), returning the smallest whole number that is not less than `x`.
				A type-safe version of `ceil`, returning a `float`.

### `ceili(x: float) -> int`

Rounds `x` upward (towards positive infinity), returning the smallest whole number that is not less than `x`.
				A type-safe version of `ceil`, returning an `int`.

### `clamp(value: Variant, min: Variant, max: Variant) -> Variant`

Clamps the `value`, returning a `Variant` not less than `min` and not more than `max`. Any values that can be compared with the less than and greater than operators will work.
				
```gdscript
				var a = clamp(-10, -1, 5)
				# a is -1

				var b = clamp(8.1, 0.9, 5.5)
				# b is 5.5
				
```

				**Note:** For better type safety, use `clampf`, `clampi`, `Vector2.clamp`, `Vector2i.clamp`, `Vector3.clamp`, `Vector3i.clamp`, `Vector4.clamp`, `Vector4i.clamp`, or `Color.clamp` (not currently supported by this method).
				**Note:** When using this on vectors it will *not* perform component-wise clamping, and will pick `min` if `value < min` or `max` if `value > max`. To perform component-wise clamping use the methods listed above.

### `clampf(value: float, min: float, max: float) -> float`

Clamps the `value`, returning a `float` not less than `min` and not more than `max`.
				
```gdscript
				var speed = 42.1
				var a = clampf(speed, 1.0, 20.5) # a is 20.5

				speed = -10.0
				var b = clampf(speed, -1.0, 1.0) # b is -1.0
				
```

### `clampi(value: int, min: int, max: int) -> int`

Clamps the `value`, returning an `int` not less than `min` and not more than `max`.
				
```gdscript
				var speed = 42
				var a = clampi(speed, 1, 20) # a is 20

				speed = -10
				var b = clampi(speed, -1, 1) # b is -1
				
```

### `cos(angle_rad: float) -> float`

Returns the cosine of angle `angle_rad` in radians.
				
```gdscript
				cos(PI * 2)         # Returns 1.0
				cos(PI)             # Returns -1.0
				cos(deg_to_rad(90)) # Returns 0.0
				
```

### `cosh(x: float) -> float`

Returns the hyperbolic cosine of `x` in radians.
				
```gdscript
				print(cosh(1)) # Prints 1.543081
				
```

### `cubic_interpolate(from: float, to: float, pre: float, post: float, weight: float) -> float`

Cubic interpolates between two values by the factor defined in `weight` with `pre` and `post` values.

### `cubic_interpolate_angle(from: float, to: float, pre: float, post: float, weight: float) -> float`

Cubic interpolates between two rotation values with shortest path by the factor defined in `weight` with `pre` and `post` values. See also `lerp_angle`.

### `cubic_interpolate_angle_in_time(from: float, to: float, pre: float, post: float, weight: float, to_t: float, pre_t: float, post_t: float) -> float`

Cubic interpolates between two rotation values with shortest path by the factor defined in `weight` with `pre` and `post` values. See also `lerp_angle`.
				It can perform smoother interpolation than `cubic_interpolate` by the time values.

### `cubic_interpolate_in_time(from: float, to: float, pre: float, post: float, weight: float, to_t: float, pre_t: float, post_t: float) -> float`

Cubic interpolates between two values by the factor defined in `weight` with `pre` and `post` values.
				It can perform smoother interpolation than `cubic_interpolate` by the time values.

### `db_to_linear(db: float) -> float`

Converts from decibels to linear energy (audio).

### `deg_to_rad(deg: float) -> float`

Converts an angle expressed in degrees to radians.
				
```gdscript
				var r = deg_to_rad(180) # r is 3.141593
				
```

### `ease(x: float, curve: float) -> float`
- 限定：keywords=smooth

Returns an "eased" value of `x` based on an easing function defined with `curve`. This easing function is based on an exponent. The `curve` can be any floating-point number, with specific values leading to the following behaviors:
				`lang=text`
				- Lower than -1.0 (exclusive): Ease in-out
				- -1.0: Linear
				- Between -1.0 and 0.0 (exclusive): Ease out-in
				- 0.0: Constant
				- Between 0.0 to 1.0 (exclusive): Ease out
				- 1.0: Linear
				- Greater than 1.0 (exclusive): Ease in
				
				ease() curve values cheatsheet (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/ease_cheatsheet.png)
				See also `smoothstep`. If you need to perform more advanced transitions, use `Tween.interpolate_value`.

### `error_string(error: int) -> String`

Returns a human-readable name for the given `Error` code.
				
```gdscript
				print(OK)                              # Prints 0
				print(error_string(OK))                # Prints "OK"
				print(error_string(ERR_BUSY))          # Prints "Busy"
				print(error_string(ERR_OUT_OF_MEMORY)) # Prints "Out of memory"
				
```

### `exp(x: float) -> float`

The natural exponential function. It raises the mathematical constant *e* to the power of `x` and returns it.
				*e* has an approximate value of 2.71828, and can be obtained with `exp(1)`.
				For exponents to other bases use the method `pow`.
				
```gdscript
				var a = exp(2) # Approximately 7.39
				
```

### `floor(x: Variant) -> Variant`

Rounds `x` downward (towards negative infinity), returning the largest whole number that is not more than `x`. Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				var a = floor(2.99) # a is 2.0
				a = floor(-2.99)    # a is -3.0
				
```

				See also `ceil`, `round`, and `snapped`.
				**Note:** For better type safety, use `floorf`, `floori`, `Vector2.floor`, `Vector3.floor`, or `Vector4.floor`.

### `floorf(x: float) -> float`

Rounds `x` downward (towards negative infinity), returning the largest whole number that is not more than `x`.
				A type-safe version of `floor`, returning a `float`.

### `floori(x: float) -> int`

Rounds `x` downward (towards negative infinity), returning the largest whole number that is not more than `x`.
				A type-safe version of `floor`, returning an `int`.
				**Note:** This function is *not* the same as `int(x)`, which rounds towards 0.

### `fmod(x: float, y: float) -> float`

Returns the floating-point remainder of `x` divided by `y`, keeping the sign of `x`.
				
```gdscript
				var remainder = fmod(7, 5.5) # remainder is 1.5
				
```

				For the integer remainder operation, use the `%` operator.

### `fposmod(x: float, y: float) -> float`

Returns the floating-point modulus of `x` divided by `y`, wrapping equally in positive and negative.
				
```gdscript
				print(" (x)  (fmod(x, 1.5))   (fposmod(x, 1.5))")
				for i in 7:
					var x = i * 0.5 - 1.5
					print("%4.1f           %4.1f  | %4.1f" % [x, fmod(x, 1.5), fposmod(x, 1.5)])
				
```

				Prints:
				`lang=text`
				 (x)  (fmod(x, 1.5))   (fposmod(x, 1.5))
				-1.5           -0.0  |  0.0
				-1.0           -1.0  |  0.5
				-0.5           -0.5  |  1.0
				 0.0            0.0  |  0.0
				 0.5            0.5  |  0.5
				 1.0            1.0  |  1.0
				 1.5            0.0  |  0.0

### `hash(variable: Variant) -> int`

Returns the integer hash of the passed `variable`.
				`codeblocks`
				`gdscript`
				print(hash("a")) # Prints 177670
				
				`csharp`
				GD.Print(GD.Hash("a")); // Prints 177670

### `instance_from_id(instance_id: int) -> Object`

Returns the `Object` that corresponds to `instance_id`. All Objects have a unique instance ID. See also `Object.get_instance_id`.
				`codeblocks`
				`gdscript`
				var drink = "water"

				func _ready():
					var id = get_instance_id()
					var instance = instance_from_id(id)
					print(instance.drink) # Prints "water"
				
				`csharp`
				public partial class MyNode : Node
				{
					public string Drink { get; set; } = "water";

					public override void _Ready()
					{
						ulong id = GetInstanceId();
						var instance = (MyNode)InstanceFromId(Id);
						GD.Print(instance.Drink); // Prints "water"
					}
				}

### `inverse_lerp(from: float, to: float, weight: float) -> float`
- 限定：keywords=interpolate

Returns an interpolation or extrapolation factor considering the range specified in `from` and `to`, and the interpolated value specified in `weight`. The returned value will be between `0.0` and `1.0` if `weight` is between `from` and `to` (inclusive). If `weight` is located outside this range, then an extrapolation factor will be returned (return value lower than `0.0` or greater than `1.0`). Use `clamp` on the result of `inverse_lerp` if this is not desired.
				
```gdscript
				# The interpolation ratio in the `lerp()` call below is 0.75.
				var middle = lerp(20, 30, 0.75)
				# middle is now 27.5.

				# Now, we pretend to have forgotten the original ratio and want to get it back.
				var ratio = inverse_lerp(20, 30, 27.5)
				# ratio is now 0.75.
				
```

				See also `lerp`, which performs the reverse of this operation, and `remap` to map a continuous series of values to another.

### `is_equal_approx(a: float, b: float) -> bool`
- 限定：keywords=roughly

Returns `true` if `a` and `b` are approximately equal to each other.
				Here, "approximately equal" means that `a` and `b` are within a small internal epsilon of each other, which scales with the magnitude of the numbers.
				Infinity values of the same sign are considered equal.

### `is_finite(x: float) -> bool`

Returns whether `x` is a finite value, i.e. it is not `@GDScript.NAN`, positive infinity, or negative infinity. See also `is_inf` and `is_nan`.

### `is_inf(x: float) -> bool`

Returns `true` if `x` is either positive infinity or negative infinity. See also `is_finite` and `is_nan`.

### `is_instance_id_valid(id: int) -> bool`

Returns `true` if the Object that corresponds to `id` is a valid object (e.g. has not been deleted from memory). All Objects have a unique instance ID.

### `is_instance_valid(instance: Variant) -> bool`

Returns `true` if `instance` is a valid Object (e.g. has not been deleted from memory).

### `is_nan(x: float) -> bool`

Returns `true` if `x` is a NaN ("Not a Number" or invalid) value. This method is needed as `@GDScript.NAN` is not equal to itself, which means `x == NAN` can't be used to check whether a value is a NaN.

### `is_same(a: Variant, b: Variant) -> bool`

Returns `true`, for value types, if `a` and `b` share the same value. Returns `true`, for reference types, if the references of `a` and `b` are the same.
				
```gdscript
				# Vector2 is a value type
				var vec2_a = Vector2(0, 0)
				var vec2_b = Vector2(0, 0)
				var vec2_c = Vector2(1, 1)
				is_same(vec2_a, vec2_a)  # true
				is_same(vec2_a, vec2_b)  # true
				is_same(vec2_a, vec2_c)  # false

				# Array is a reference type
				var arr_a = []
				var arr_b = []
				is_same(arr_a, arr_a)  # true
				is_same(arr_a, arr_b)  # false
				
```

				These are `Variant` value types: `null`, `bool`, `int`, `float`, `String`, `StringName`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`, `Rect2`, `Rect2i`, `Transform2D`, `Transform3D`, `Plane`, `Quaternion`, `AABB`, `Basis`, `Projection`, `Color`, `NodePath`, `RID`, `Callable` and `Signal`.
				These are `Variant` reference types: `Object`, `Dictionary`, `Array`, `PackedByteArray`, `PackedInt32Array`, `PackedInt64Array`, `PackedFloat32Array`, `PackedFloat64Array`, `PackedStringArray`, `PackedVector2Array`, `PackedVector3Array`, `PackedVector4Array`, and `PackedColorArray`.

### `is_zero_approx(x: float) -> bool`

Returns `true` if `x` is zero or almost zero. The comparison is done using a tolerance calculation with a small internal epsilon.
				This function is faster than using `is_equal_approx` with one value as zero.

### `lerp(from: Variant, to: Variant, weight: Variant) -> Variant`
- 限定：keywords=interpolate

Linearly interpolates between two values by the factor defined in `weight`. To perform interpolation, `weight` should be between `0.0` and `1.0` (inclusive). However, values outside this range are allowed and can be used to perform *extrapolation*. If this is not desired, use `clampf` to limit `weight`.
				Both `from` and `to` must be the same type. Supported types: `int`, `float`, `Vector2`, `Vector3`, `Vector4`, `Color`, `Quaternion`, `Basis`, `Transform2D`, `Transform3D`.
				
```gdscript
				lerp(0, 4, 0.75) # Returns 3.0
				
```

				See also `inverse_lerp` which performs the reverse of this operation. To perform eased interpolation with `lerp`, combine it with `ease` or `smoothstep`. See also `remap` to map a continuous series of values to another.
				**Note:** For better type safety, use `lerpf`, `Vector2.lerp`, `Vector3.lerp`, `Vector4.lerp`, `Color.lerp`, `Quaternion.slerp`, `Basis.slerp`, `Transform2D.interpolate_with`, or `Transform3D.interpolate_with`.

### `lerp_angle(from: float, to: float, weight: float) -> float`
- 限定：keywords=interpolate

Linearly interpolates between two angles (in radians) by a `weight` value between 0.0 and 1.0.
				Similar to `lerp`, but interpolates correctly when the angles wrap around `@GDScript.TAU`. To perform eased interpolation with `lerp_angle`, combine it with `ease` or `smoothstep`.
				
```gdscript
				extends Sprite
				var elapsed = 0.0
				func _process(delta):
					var min_angle = deg_to_rad(0.0)
					var max_angle = deg_to_rad(90.0)
					rotation = lerp_angle(min_angle, max_angle, elapsed)
					elapsed += delta
				
```

				**Note:** This function lerps through the shortest path between `from` and `to`. However, when these two angles are approximately `PI + k * TAU` apart for any integer `k`, it's not obvious which way they lerp due to floating-point precision errors. For example, `lerp_angle(0, PI, weight)` lerps counter-clockwise, while `lerp_angle(0, PI + 5 * TAU, weight)` lerps clockwise.

### `lerpf(from: float, to: float, weight: float) -> float`

Linearly interpolates between two values by the factor defined in `weight`. To perform interpolation, `weight` should be between `0.0` and `1.0` (inclusive). However, values outside this range are allowed and can be used to perform *extrapolation*. If this is not desired, use `clampf` on the result of this function.
				
```gdscript
				lerpf(0, 4, 0.75) # Returns 3.0
				
```

				See also `inverse_lerp` which performs the reverse of this operation. To perform eased interpolation with `lerp`, combine it with `ease` or `smoothstep`.

### `linear_to_db(lin: float) -> float`

Converts from linear energy to decibels (audio). Since volume is not normally linear, this can be used to implement volume sliders that behave as expected.
				**Example:** Change the Master bus's volume through a `Slider` node, which ranges from `0.0` to `1.0`:
				
```gdscript
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($Slider.value))
				
```

### `log(x: float) -> float`

Returns the natural logarithm (https://en.wikipedia.org/wiki/Natural_logarithm) of `x` (base e (https://en.wikipedia.org/wiki/E_(mathematical_constant)), with *e* being approximately 2.71828). This is the amount of time needed to reach a certain level of continuous growth.
				**Note:** This is not the same as the "log" function on most calculators, which uses a base 10 logarithm. To use base 10 logarithm, use `log(x) / log(10)`.
				
```gdscript
				log(10) # Returns 2.302585
				
```

				**Note:** The logarithm of `0` returns `-inf`, while negative values return `-nan`.

### `max() -> Variant`
- 限定：qualifiers=vararg

Returns the maximum of the given numeric values. This function can take any number of arguments.
				
```gdscript
				max(1, 7, 3, -6, 5) # Returns 7
				
```

				**Note:** When using this on vectors it will *not* perform component-wise maximum, and will pick the largest value when compared using `x < y`. To perform component-wise maximum, use `Vector2.max`, `Vector2i.max`, `Vector3.max`, `Vector3i.max`, `Vector4.max`, and `Vector4i.max`.

### `maxf(a: float, b: float) -> float`

Returns the maximum of two `float` values.
				
```gdscript
				maxf(3.6, 24)   # Returns 24.0
				maxf(-3.99, -4) # Returns -3.99
				
```

### `maxi(a: int, b: int) -> int`

Returns the maximum of two `int` values.
				
```gdscript
				maxi(1, 2)   # Returns 2
				maxi(-3, -4) # Returns -3
				
```

### `min() -> Variant`
- 限定：qualifiers=vararg

Returns the minimum of the given numeric values. This function can take any number of arguments.
				
```gdscript
				min(1, 7, 3, -6, 5) # Returns -6
				
```

				**Note:** When using this on vectors it will *not* perform component-wise minimum, and will pick the smallest value when compared using `x < y`. To perform component-wise minimum, use `Vector2.min`, `Vector2i.min`, `Vector3.min`, `Vector3i.min`, `Vector4.min`, and `Vector4i.min`.

### `minf(a: float, b: float) -> float`

Returns the minimum of two `float` values.
				
```gdscript
				minf(3.6, 24)   # Returns 3.6
				minf(-3.99, -4) # Returns -4.0
				
```

### `mini(a: int, b: int) -> int`

Returns the minimum of two `int` values.
				
```gdscript
				mini(1, 2)   # Returns 1
				mini(-3, -4) # Returns -4
				
```

### `move_toward(from: float, to: float, delta: float) -> float`

Moves `from` toward `to` by the `delta` amount. Will not go past `to`.
				Use a negative `delta` value to move away.
				
```gdscript
				move_toward(5, 10, 4)    # Returns 9
				move_toward(10, 5, 4)    # Returns 6
				move_toward(5, 10, 9)    # Returns 10
				move_toward(10, 5, -1.5) # Returns 11.5
				
```

### `nearest_po2(value: int) -> int`

Returns the smallest integer power of 2 that is greater than or equal to `value`.
				
```gdscript
				nearest_po2(3) # Returns 4
				nearest_po2(4) # Returns 4
				nearest_po2(5) # Returns 8

				nearest_po2(0)  # Returns 0 (this may not be expected)
				nearest_po2(-1) # Returns 0 (this may not be expected)
				
```

				**Warning:** Due to its implementation, this method returns `0` rather than `1` for values less than or equal to `0`, with an exception for `value` being the smallest negative 64-bit integer (`-9223372036854775808`) in which case the `value` is returned unchanged.

### `pingpong(value: float, length: float) -> float`

Wraps `value` between `0` and the `length`. If the limit is reached, the next value the function returns is decreased to the `0` side or increased to the `length` side (like a triangle wave). If `length` is less than zero, it becomes positive.
				
```gdscript
				pingpong(-3.0, 3.0) # Returns 3.0
				pingpong(-2.0, 3.0) # Returns 2.0
				pingpong(-1.0, 3.0) # Returns 1.0
				pingpong(0.0, 3.0)  # Returns 0.0
				pingpong(1.0, 3.0)  # Returns 1.0
				pingpong(2.0, 3.0)  # Returns 2.0
				pingpong(3.0, 3.0)  # Returns 3.0
				pingpong(4.0, 3.0)  # Returns 2.0
				pingpong(5.0, 3.0)  # Returns 1.0
				pingpong(6.0, 3.0)  # Returns 0.0
				
```

### `posmod(x: int, y: int) -> int`

Returns the integer modulus of `x` divided by `y` that wraps equally in positive and negative.
				
```gdscript
				print("#(i)  (i % 3)   (posmod(i, 3))")
				for i in range(-3, 4):
					print("%2d       %2d  | %2d" % [i, i % 3, posmod(i, 3)])
				
```

				Prints:
				`lang=text`
				(i)  (i % 3)   (posmod(i, 3))
				-3        0  |  0
				-2       -2  |  1
				-1       -1  |  2
				 0        0  |  0
				 1        1  |  1
				 2        2  |  2
				 3        0  |  0

### `pow(base: float, exp: float) -> float`

Returns the result of `base` raised to the power of `exp`.
				In GDScript, this is the equivalent of the `**` operator.
				
```gdscript
				pow(2, 5)   # Returns 32.0
				pow(4, 1.5) # Returns 8.0
				
```

### `print() -> void`
- 限定：qualifiers=vararg

Converts one or more arguments of any type to string in the best way possible and prints them to the console.
				`codeblocks`
				`gdscript`
				var a = [1, 2, 3]
				print("a", "b", a) # Prints "ab[1, 2, 3]"
				
				`csharp`
				Godot.Collections.Array a = [1, 2, 3];
				GD.Print("a", "b", a); // Prints "ab[1, 2, 3]"
				
				
				**Note:** Consider using `push_error` and `push_warning` to print error and warning messages instead of `print` or `print_rich`. This distinguishes them from print messages used for debugging purposes, while also displaying a stack trace when an error or warning is printed. See also `Engine.print_to_stdout` and `ProjectSettings.application/run/disable_stdout`.

### `print_rich() -> void`
- 限定：qualifiers=vararg

Converts one or more arguments of any type to string in the best way possible and prints them to the console.
				The following BBCode tags are supported: `b`, `i`, `u`, `s`, `indent`, `code`, `url`, `center`, `right`, `color`, `bgcolor`, `fgcolor`.
				URL tags only support URLs wrapped by a URL tag, not URLs with a different title.
				When printing to standard output, the supported subset of BBCode is converted to ANSI escape codes for the terminal emulator to display. Support for ANSI escape codes varies across terminal emulators, especially for italic and strikethrough. In standard output, `code` is represented with faint text but without any font change. Unsupported tags are left as-is in standard output.
				`codeblocks`
				`skip-lint`
				print_rich("[color=green]**Hello world!**") # Prints "Hello world!", in green with a bold font.
				
				`skip-lint`
				GD.PrintRich("[color=green]**Hello world!**"); // Prints "Hello world!", in green with a bold font.
				
				
				**Note:** Consider using `push_error` and `push_warning` to print error and warning messages instead of `print` or `print_rich`. This distinguishes them from print messages used for debugging purposes, while also displaying a stack trace when an error or warning is printed.
				**Note:** Output displayed in the editor supports clickable `skip-lint`text (address) tags. The `skip-lint``url` tag's `address` value is handled by `OS.shell_open` when clicked.

### `print_verbose() -> void`
- 限定：qualifiers=vararg

If verbose mode is enabled (`OS.is_stdout_verbose` returning `true`), converts one or more arguments of any type to string in the best way possible and prints them to the console.

### `printerr() -> void`
- 限定：qualifiers=vararg

Prints one or more arguments to strings in the best way possible to standard error line.
				`codeblocks`
				`gdscript`
				printerr("prints to stderr")
				
				`csharp`
				GD.PrintErr("prints to stderr");

### `printraw() -> void`
- 限定：qualifiers=vararg

Prints one or more arguments to strings in the best way possible to the OS terminal. Unlike `print`, no newline is automatically added at the end.
				**Note:** The OS terminal is *not* the same as the editor's Output dock. The output sent to the OS terminal can be seen when running Godot from a terminal. On Windows, this requires using the `console.exe` executable.
				`codeblocks`
				`gdscript`
				# Prints "ABC" to terminal.
				printraw("A")
				printraw("B")
				printraw("C")
				
				`csharp`
				// Prints "ABC" to terminal.
				GD.PrintRaw("A");
				GD.PrintRaw("B");
				GD.PrintRaw("C");

### `prints() -> void`
- 限定：qualifiers=vararg

Prints one or more arguments to the console with a space between each argument.
				`codeblocks`
				`gdscript`
				prints("A", "B", "C") # Prints "A B C"
				
				`csharp`
				GD.PrintS("A", "B", "C"); // Prints "A B C"

### `printt() -> void`
- 限定：qualifiers=vararg

Prints one or more arguments to the console with a tab between each argument.
				`codeblocks`
				`gdscript`
				printt("A", "B", "C") # Prints "A       B       C"
				
				`csharp`
				GD.PrintT("A", "B", "C"); // Prints "A       B       C"

### `push_error() -> void`
- 限定：qualifiers=vararg

Pushes an error message to Godot's built-in debugger and to the OS terminal.
				`codeblocks`
				`gdscript`
				push_error("test error") # Prints "test error" to debugger and terminal as an error.
				
				`csharp`
				GD.PushError("test error"); // Prints "test error" to debugger and terminal as an error.
				
				
				**Note:** This function does not pause project execution. To print an error message and pause project execution in debug builds, use `assert(false, "test error")` instead.

### `push_warning() -> void`
- 限定：qualifiers=vararg

Pushes a warning message to Godot's built-in debugger and to the OS terminal.
				`codeblocks`
				`gdscript`
				push_warning("test warning") # Prints "test warning" to debugger and terminal as a warning.
				
				`csharp`
				GD.PushWarning("test warning"); // Prints "test warning" to debugger and terminal as a warning.

### `rad_to_deg(rad: float) -> float`

Converts an angle expressed in radians to degrees.
				
```gdscript
				rad_to_deg(0.523599) # Returns 30
				rad_to_deg(PI)       # Returns 180
				rad_to_deg(PI * 2)   # Returns 360
				
```

### `rand_from_seed(seed: int) -> PackedInt64Array`

Given a `seed`, returns a `PackedInt64Array` of size `2`, where its first element is the randomized `int` value, and the second element is the same as `seed`. Passing the same `seed` consistently returns the same array.
				**Note:** "Seed" here refers to the internal state of the pseudo random number generator, currently implemented as a 64 bit integer.
				
```gdscript
				var a = rand_from_seed(4)

				print(a[0]) # Prints 2879024997
				print(a[1]) # Prints 4
				
```

### `randf() -> float`

Returns a random floating-point value between `0.0` and `1.0` (inclusive).
				`codeblocks`
				`gdscript`
				randf() # Returns e.g. 0.375671
				
				`csharp`
				GD.Randf(); // Returns e.g. 0.375671

### `randf_range(from: float, to: float) -> float`

Returns a random floating-point value between `from` and `to` (inclusive).
				`codeblocks`
				`gdscript`
				randf_range(0, 20.5) # Returns e.g. 7.45315
				randf_range(-10, 10) # Returns e.g. -3.844535
				
				`csharp`
				GD.RandRange(0.0, 20.5);   // Returns e.g. 7.45315
				GD.RandRange(-10.0, 10.0); // Returns e.g. -3.844535

### `randfn(mean: float, deviation: float) -> float`

Returns a normally-distributed (https://en.wikipedia.org/wiki/Normal_distribution), pseudo-random floating-point value from the specified `mean` and a standard `deviation`. This is also known as a Gaussian distribution.
				**Note:** This method uses the Box-Muller transform (https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform) algorithm.

### `randi() -> int`

Returns a random unsigned 32-bit integer. Use remainder to obtain a random value in the interval `[0, N - 1]` (where N is smaller than 2^32).
				`codeblocks`
				`gdscript`
				randi()           # Returns random integer between 0 and 2^32 - 1
				randi() % 20      # Returns random integer between 0 and 19
				randi() % 100     # Returns random integer between 0 and 99
				randi() % 100 + 1 # Returns random integer between 1 and 100
				
				`csharp`
				GD.Randi();           // Returns random integer between 0 and 2^32 - 1
				GD.Randi() % 20;      // Returns random integer between 0 and 19
				GD.Randi() % 100;     // Returns random integer between 0 and 99
				GD.Randi() % 100 + 1; // Returns random integer between 1 and 100

### `randi_range(from: int, to: int) -> int`

Returns a random signed 32-bit integer between `from` and `to` (inclusive). If `to` is lesser than `from`, they are swapped.
				`codeblocks`
				`gdscript`
				randi_range(0, 1)      # Returns either 0 or 1
				randi_range(-10, 1000) # Returns random integer between -10 and 1000
				
				`csharp`
				GD.RandRange(0, 1);      // Returns either 0 or 1
				GD.RandRange(-10, 1000); // Returns random integer between -10 and 1000

### `randomize() -> void`

Randomizes the seed (or the internal state) of the random number generator. The current implementation uses a number based on the device's time.
				**Note:** This function is called automatically when the project is run. If you need to fix the seed to have consistent, reproducible results, use `seed` to initialize the random number generator.

### `remap(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float`
- 限定：keywords=range, lerp, interpolate

Maps a `value` from range `[istart, istop]` to `[ostart, ostop]`. See also `lerp` and `inverse_lerp`. If `value` is outside `[istart, istop]`, then the resulting value will also be outside `[ostart, ostop]`. If this is not desired, use `clamp` on the result of this function.
				
```gdscript
				remap(75, 0, 100, -1, 1) # Returns 0.5
				
```

				For complex use cases where multiple ranges are needed, consider using `Curve` or `Gradient` instead.
				**Note:** If `istart == istop`, the return value is undefined (most likely NaN, INF, or -INF).

### `rid_allocate_id() -> int`

Allocates a unique ID which can be used by the implementation to construct an RID. This is used mainly from native extensions to implement servers.

### `rid_from_int64(base: int) -> RID`

Creates an RID from a `base`. This is used mainly from native extensions to build servers.

### `rotate_toward(from: float, to: float, delta: float) -> float`

Rotates `from` toward `to` by the `delta` amount. Will not go past `to`.
				Similar to `move_toward`, but interpolates correctly when the angles wrap around `@GDScript.TAU`.
				If `delta` is negative, this function will rotate away from `to`, toward the opposite angle, and will not go past the opposite angle.

### `round(x: Variant) -> Variant`

Rounds `x` to the nearest whole number, with halfway cases rounded away from 0. Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				round(2.4) # Returns 2
				round(2.5) # Returns 3
				round(2.6) # Returns 3
				
```

				See also `floor`, `ceil`, and `snapped`.
				**Note:** For better type safety, use `roundf`, `roundi`, `Vector2.round`, `Vector3.round`, or `Vector4.round`.

### `roundf(x: float) -> float`

Rounds `x` to the nearest whole number, with halfway cases rounded away from 0.
				A type-safe version of `round`, returning a `float`.

### `roundi(x: float) -> int`

Rounds `x` to the nearest whole number, with halfway cases rounded away from 0.
				A type-safe version of `round`, returning an `int`.

### `seed(base: int) -> void`

Sets the seed for the random number generator to `base`. Setting the seed manually can ensure consistent, repeatable results for most random functions.
				`codeblocks`
				`gdscript`
				var my_seed = "Godot Rocks".hash()
				seed(my_seed)
				var a = randf() + randi()
				seed(my_seed)
				var b = randf() + randi()
				# a and b are now identical
				
				`csharp`
				ulong mySeed = (ulong)GD.Hash("Godot Rocks");
				GD.Seed(mySeed);
				var a = GD.Randf() + GD.Randi();
				GD.Seed(mySeed);
				var b = GD.Randf() + GD.Randi();
				// a and b are now identical

### `sign(x: Variant) -> Variant`

Returns the same type of `Variant` as `x`, with `-1` for negative values, `1` for positive values, and `0` for zeros. For `nan` values it returns 0.
				Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				sign(-6.0) # Returns -1
				sign(0.0)  # Returns 0
				sign(6.0)  # Returns 1
				sign(NAN)  # Returns 0

				sign(Vector3(-6.0, 0.0, 6.0)) # Returns (-1, 0, 1)
				
```

				**Note:** For better type safety, use `signf`, `signi`, `Vector2.sign`, `Vector2i.sign`, `Vector3.sign`, `Vector3i.sign`, `Vector4.sign`, or `Vector4i.sign`.

### `signf(x: float) -> float`

Returns `-1.0` if `x` is negative, `1.0` if `x` is positive, and `0.0` if `x` is zero. For `nan` values of `x` it returns 0.0.
				
```gdscript
				signf(-6.5) # Returns -1.0
				signf(0.0)  # Returns 0.0
				signf(6.5)  # Returns 1.0
				signf(NAN)  # Returns 0.0
				
```

### `signi(x: int) -> int`

Returns `-1` if `x` is negative, `1` if `x` is positive, and `0` if `x` is zero.
				
```gdscript
				signi(-6) # Returns -1
				signi(0)  # Returns 0
				signi(6)  # Returns 1
				
```

### `sin(angle_rad: float) -> float`

Returns the sine of angle `angle_rad` in radians.
				
```gdscript
				sin(0.523599)       # Returns 0.5
				sin(deg_to_rad(90)) # Returns 1.0
				
```

### `sinh(x: float) -> float`

Returns the hyperbolic sine of `x`.
				
```gdscript
				var a = log(2.0) # Returns 0.693147
				sinh(a) # Returns 0.75
				
```

### `smoothstep(from: float, to: float, x: float) -> float`

Returns a smooth cubic Hermite interpolation between `0` and `1`.
				For positive ranges (when `from <= to`) the return value is `0` when `x <= from`, and `1` when `x >= to`. If `x` lies between `from` and `to`, the return value follows an S-shaped curve that smoothly transitions from `0` to `1`.
				For negative ranges (when `from > to`) the function is mirrored and returns `1` when `x <= to` and `0` when `x >= from`.
				This S-shaped curve is the cubic Hermite interpolator, given by `f(y) = 3*y^2 - 2*y^3` where `y = (x-from) / (to-from)`.
				
```gdscript
				smoothstep(0, 2, -5.0) # Returns 0.0
				smoothstep(0, 2, 0.5) # Returns 0.15625
				smoothstep(0, 2, 1.0) # Returns 0.5
				smoothstep(0, 2, 2.0) # Returns 1.0
				
```

				Compared to `ease` with a curve value of `-1.6521`, `smoothstep` returns the smoothest possible curve with no sudden changes in the derivative. If you need to perform more advanced transitions, use `Tween` or `AnimationPlayer`.
				Comparison between smoothstep() and ease(x, -1.6521) return values (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/smoothstep_ease_comparison.png)
				Smoothstep() return values with positive, zero, and negative ranges (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/smoothstep_range.webp)

### `snapped(x: Variant, step: Variant) -> Variant`

Returns the multiple of `step` that is the closest to `x`. This can also be used to round a floating-point number to an arbitrary number of decimals.
				The returned value is the same type of `Variant` as `step`. Supported types: `int`, `float`, `Vector2`, `Vector2i`, `Vector3`, `Vector3i`, `Vector4`, `Vector4i`.
				
```gdscript
				snapped(100, 32)  # Returns 96
				snapped(3.14159, 0.01)  # Returns 3.14

				snapped(Vector2(34, 70), Vector2(8, 8))  # Returns (32, 72)
				
```

				See also `ceil`, `floor`, and `round`.
				**Note:** For better type safety, use `snappedf`, `snappedi`, `Vector2.snapped`, `Vector2i.snapped`, `Vector3.snapped`, `Vector3i.snapped`, `Vector4.snapped`, or `Vector4i.snapped`.

### `snappedf(x: float, step: float) -> float`

Returns the multiple of `step` that is the closest to `x`. This can also be used to round a floating-point number to an arbitrary number of decimals.
				A type-safe version of `snapped`, returning a `float`.
				
```gdscript
				snappedf(32.0, 2.5)  # Returns 32.5
				snappedf(3.14159, 0.01)  # Returns 3.14
				
```

### `snappedi(x: float, step: int) -> int`

Returns the multiple of `step` that is the closest to `x`.
				A type-safe version of `snapped`, returning an `int`.
				
```gdscript
				snappedi(53, 16)  # Returns 48
				snappedi(4096, 100)  # Returns 4100
				
```

### `sqrt(x: float) -> float`

Returns the square root of `x`, where `x` is a non-negative number.
				
```gdscript
				sqrt(9)     # Returns 3
				sqrt(10.24) # Returns 3.2
				sqrt(-1)    # Returns NaN
				
```

				**Note:** Negative values of `x` return NaN ("Not a Number"). In C#, if you need negative inputs, use `System.Numerics.Complex`.

### `step_decimals(x: float) -> int`

Returns the position of the first non-zero digit, after the decimal point. Note that the maximum return value is 10, which is a design decision in the implementation.
				
```gdscript
				var n = step_decimals(5)       # n is 0
				n = step_decimals(1.0005)      # n is 4
				n = step_decimals(0.000000005) # n is 9
				
```

### `str() -> String`
- 限定：qualifiers=vararg

Converts one or more arguments of any `Variant` type to a `String` in the best way possible.
				
```gdscript
				var a = [10, 20, 30]
				var b = str(a)
				print(len(a)) # Prints 3 (the number of elements in the array).
				print(len(b)) # Prints 12 (the length of the string "[10, 20, 30]").
				
```

### `str_to_var(string: String) -> Variant`

Converts a formatted `string` that was returned by `var_to_str` to the original `Variant`.
				`codeblocks`
				`gdscript`
				var data = '{ "a": 1, "b": 2 }' # data is a String
				var dict = str_to_var(data)     # dict is a Dictionary
				print(dict["a"])                # Prints 1
				
				`csharp`
				string data = "{ \"a\": 1, \"b\": 2 }";           // data is a string
				var dict = GD.StrToVar(data).AsGodotDictionary(); // dict is a Dictionary
				GD.Print(dict["a"]);                              // Prints 1

### `tan(angle_rad: float) -> float`

Returns the tangent of angle `angle_rad` in radians.
				
```gdscript
				tan(deg_to_rad(45)) # Returns 1
				
```

### `tanh(x: float) -> float`

Returns the hyperbolic tangent of `x`.
				
```gdscript
				var a = log(2.0) # Returns 0.693147
				tanh(a)          # Returns 0.6
				
```

### `type_convert(variant: Variant, type: int) -> Variant`

Converts the given `variant` to the given `type`, using the `Variant.Type` values. This method is generous with how it handles types, it can automatically convert between array types, convert numeric `String`s to `int`, and converting most things to `String`.
				If the type conversion cannot be done, this method will return the default value for that type, for example converting `Rect2` to `Vector2` will always return `Vector2.ZERO`. This method will never show error messages as long as `type` is a valid Variant type.
				The returned value is a `Variant`, but the data inside and its type will be the same as the requested type.
				
```gdscript
				type_convert("Hi!", TYPE_INT) # Returns 0
				type_convert("123", TYPE_INT) # Returns 123
				type_convert(123.4, TYPE_INT) # Returns 123
				type_convert(5, TYPE_VECTOR2) # Returns (0, 0)
				type_convert("Hi!", TYPE_NIL) # Returns null
				
```

### `type_string(type: int) -> String`

Returns a human-readable name of the given `type`, using the `Variant.Type` values.
				
```gdscript
				print(TYPE_INT) # Prints 2
				print(type_string(TYPE_INT)) # Prints "int"
				print(type_string(TYPE_STRING)) # Prints "String"
				
```

				See also `typeof`.

### `typeof(variable: Variant) -> int`

Returns the internal type of the given `variable`, using the `Variant.Type` values.
				
```gdscript
				var json = JSON.new()
				json.parse('["a", "b", "c"]')
				var result = json.get_data()
				if typeof(result) == TYPE_ARRAY:
					print(result[0]) # Prints "a"
				else:
					print("Unexpected result!")
				
```

				See also `type_string`.

### `var_to_bytes(variable: Variant) -> PackedByteArray`

Encodes a `Variant` value to a byte array, without encoding objects. Deserialization can be done with `bytes_to_var`.
				**Note:** If you need object serialization, see `var_to_bytes_with_objects`.
				**Note:** Encoding `Callable` is not supported and will result in an empty value, regardless of the data.

### `var_to_bytes_with_objects(variable: Variant) -> PackedByteArray`

Encodes a `Variant` value to a byte array. Encoding objects is allowed (and can potentially include executable code). Deserialization can be done with `bytes_to_var_with_objects`.
				**Note:** Encoding `Callable` is not supported and will result in an empty value, regardless of the data.

### `var_to_str(variable: Variant) -> String`

Converts a `Variant` `variable` to a formatted `String` that can then be parsed using `str_to_var`.
				`codeblocks`
				`gdscript`
				var a = { "a": 1, "b": 2 }
				print(var_to_str(a))
				
				`csharp`
				var a = new Godot.Collections.Dictionary { ["a"] = 1, ["b"] = 2 };
				GD.Print(GD.VarToStr(a));
				
				
				Prints:
				`lang=text`
				{
					"a": 1,
					"b": 2
				}
				
				**Note:** Converting `Signal` or `Callable` is not supported and will result in an empty value for these types, regardless of their data.

### `weakref(obj: Variant) -> Variant`

Returns a `WeakRef` instance holding a weak reference to `obj`. Returns an empty `WeakRef` instance if `obj` is `null`. Prints an error and returns `null` if `obj` is neither `Object`-derived nor `null`.
				A weak reference to an object is not enough to keep the object alive: when the only remaining references to a referent are weak references, garbage collection is free to destroy the referent and reuse its memory for something else. However, until the object is actually destroyed the weak reference may return the object even if there are no strong references to it.

### `wrap(value: Variant, min: Variant, max: Variant) -> Variant`

Wraps the `Variant` `value` between `min` and `max`. `min` is *inclusive* while `max` is *exclusive*. This can be used for creating loop-like behavior or infinite surfaces.
				Variant types `int` and `float` are supported. If any of the arguments is `float`, this function returns a `float`, otherwise it returns an `int`.
				
```gdscript
				var a = wrap(4, 5, 10)
				# a is 9 (int)

				var a = wrap(7, 5, 10)
				# a is 7 (int)

				var a = wrap(10.5, 5, 10)
				# a is 5.5 (float)
				
```

### `wrapf(value: float, min: float, max: float) -> float`

Wraps the float `value` between `min` and `max`. `min` is *inclusive* while `max` is *exclusive*. This can be used for creating loop-like behavior or infinite surfaces.
				
```gdscript
				# Infinite loop between 5.0 and 9.9
				value = wrapf(value + 0.1, 5.0, 10.0)
				
```

				
```gdscript
				# Infinite rotation (in radians)
				angle = wrapf(angle + 0.1, 0.0, TAU)
				
```

				
```gdscript
				# Infinite rotation (in radians)
				angle = wrapf(angle + 0.1, -PI, PI)
				
```

				**Note:** If `min` is `0`, this is equivalent to `fposmod`, so prefer using that instead. `wrapf` is more flexible than using the `fposmod` approach by giving the user control over the minimum value.

### `wrapi(value: int, min: int, max: int) -> int`

Wraps the integer `value` between `min` and `max`. `min` is *inclusive* while `max` is *exclusive*. This can be used for creating loop-like behavior or infinite surfaces.
				
```gdscript
				# Infinite loop between 5 and 9
				frame = wrapi(frame + 1, 5, 10)
				
```

				
```gdscript
				# result is -2
				var result = wrapi(-6, -5, -1)
				
```

## 枚举

### `Side`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SIDE_LEFT` |  |
| `1` | `SIDE_TOP` |  |
| `2` | `SIDE_RIGHT` |  |
| `3` | `SIDE_BOTTOM` |  |

### `Corner`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CORNER_TOP_LEFT` |  |
| `1` | `CORNER_TOP_RIGHT` |  |
| `2` | `CORNER_BOTTOM_RIGHT` |  |
| `3` | `CORNER_BOTTOM_LEFT` |  |

### `Orientation`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `VERTICAL` |  |
| `0` | `HORIZONTAL` |  |

### `ClockDirection`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CLOCKWISE` |  |
| `1` | `COUNTERCLOCKWISE` |  |

### `HorizontalAlignment`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HORIZONTAL_ALIGNMENT_LEFT` |  |
| `1` | `HORIZONTAL_ALIGNMENT_CENTER` |  |
| `2` | `HORIZONTAL_ALIGNMENT_RIGHT` |  |
| `3` | `HORIZONTAL_ALIGNMENT_FILL` |  |

### `VerticalAlignment`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VERTICAL_ALIGNMENT_TOP` |  |
| `1` | `VERTICAL_ALIGNMENT_CENTER` |  |
| `2` | `VERTICAL_ALIGNMENT_BOTTOM` |  |
| `3` | `VERTICAL_ALIGNMENT_FILL` |  |

### `InlineAlignment`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INLINE_ALIGNMENT_TOP_TO` |  |
| `1` | `INLINE_ALIGNMENT_CENTER_TO` |  |
| `3` | `INLINE_ALIGNMENT_BASELINE_TO` |  |
| `2` | `INLINE_ALIGNMENT_BOTTOM_TO` |  |
| `0` | `INLINE_ALIGNMENT_TO_TOP` |  |
| `4` | `INLINE_ALIGNMENT_TO_CENTER` |  |
| `8` | `INLINE_ALIGNMENT_TO_BASELINE` |  |
| `12` | `INLINE_ALIGNMENT_TO_BOTTOM` |  |
| `0` | `INLINE_ALIGNMENT_TOP` |  |
| `5` | `INLINE_ALIGNMENT_CENTER` |  |
| `14` | `INLINE_ALIGNMENT_BOTTOM` |  |
| `3` | `INLINE_ALIGNMENT_IMAGE_MASK` |  |
| `12` | `INLINE_ALIGNMENT_TEXT_MASK` |  |

### `EulerOrder`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EULER_ORDER_XYZ` |  |
| `1` | `EULER_ORDER_XZY` |  |
| `2` | `EULER_ORDER_YXZ` |  |
| `3` | `EULER_ORDER_YZX` |  |
| `4` | `EULER_ORDER_ZXY` |  |
| `5` | `EULER_ORDER_ZYX` |  |

### `Key`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `KEY_NONE` |  |
| `4194304` | `KEY_SPECIAL` |  |
| `4194305` | `KEY_ESCAPE` |  |
| `4194306` | `KEY_TAB` |  |
| `4194307` | `KEY_BACKTAB` |  |
| `4194308` | `KEY_BACKSPACE` |  |
| `4194309` | `KEY_ENTER` |  |
| `4194310` | `KEY_KP_ENTER` |  |
| `4194311` | `KEY_INSERT` |  |
| `4194312` | `KEY_DELETE` |  |
| `4194313` | `KEY_PAUSE` |  |
| `4194314` | `KEY_PRINT` |  |
| `4194315` | `KEY_SYSREQ` |  |
| `4194316` | `KEY_CLEAR` |  |
| `4194317` | `KEY_HOME` |  |
| `4194318` | `KEY_END` |  |
| `4194319` | `KEY_LEFT` |  |
| `4194320` | `KEY_UP` |  |
| `4194321` | `KEY_RIGHT` |  |
| `4194322` | `KEY_DOWN` |  |
| `4194323` | `KEY_PAGEUP` |  |
| `4194324` | `KEY_PAGEDOWN` |  |
| `4194325` | `KEY_SHIFT` |  |
| `4194326` | `KEY_CTRL` |  |
| `4194327` | `KEY_META` |  |
| `4194328` | `KEY_ALT` |  |
| `4194329` | `KEY_CAPSLOCK` |  |
| `4194330` | `KEY_NUMLOCK` |  |
| `4194331` | `KEY_SCROLLLOCK` |  |
| `4194332` | `KEY_F1` |  |
| `4194333` | `KEY_F2` |  |
| `4194334` | `KEY_F3` |  |
| `4194335` | `KEY_F4` |  |
| `4194336` | `KEY_F5` |  |
| `4194337` | `KEY_F6` |  |
| `4194338` | `KEY_F7` |  |
| `4194339` | `KEY_F8` |  |
| `4194340` | `KEY_F9` |  |
| `4194341` | `KEY_F10` |  |
| `4194342` | `KEY_F11` |  |
| `4194343` | `KEY_F12` |  |
| `4194344` | `KEY_F13` |  |
| `4194345` | `KEY_F14` |  |
| `4194346` | `KEY_F15` |  |
| `4194347` | `KEY_F16` |  |
| `4194348` | `KEY_F17` |  |
| `4194349` | `KEY_F18` |  |
| `4194350` | `KEY_F19` |  |
| `4194351` | `KEY_F20` |  |
| `4194352` | `KEY_F21` |  |
| `4194353` | `KEY_F22` |  |
| `4194354` | `KEY_F23` |  |
| `4194355` | `KEY_F24` |  |
| `4194356` | `KEY_F25` |  |
| `4194357` | `KEY_F26` |  |
| `4194358` | `KEY_F27` |  |
| `4194359` | `KEY_F28` |  |
| `4194360` | `KEY_F29` |  |
| `4194361` | `KEY_F30` |  |
| `4194362` | `KEY_F31` |  |
| `4194363` | `KEY_F32` |  |
| `4194364` | `KEY_F33` |  |
| `4194365` | `KEY_F34` |  |
| `4194366` | `KEY_F35` |  |
| `4194433` | `KEY_KP_MULTIPLY` |  |
| `4194434` | `KEY_KP_DIVIDE` |  |
| `4194435` | `KEY_KP_SUBTRACT` |  |
| `4194436` | `KEY_KP_PERIOD` |  |
| `4194437` | `KEY_KP_ADD` |  |
| `4194438` | `KEY_KP_0` |  |
| `4194439` | `KEY_KP_1` |  |
| `4194440` | `KEY_KP_2` |  |
| `4194441` | `KEY_KP_3` |  |
| `4194442` | `KEY_KP_4` |  |
| `4194443` | `KEY_KP_5` |  |
| `4194444` | `KEY_KP_6` |  |
| `4194445` | `KEY_KP_7` |  |
| `4194446` | `KEY_KP_8` |  |
| `4194447` | `KEY_KP_9` |  |
| `4194370` | `KEY_MENU` |  |
| `4194371` | `KEY_HYPER` |  |
| `4194373` | `KEY_HELP` |  |
| `4194376` | `KEY_BACK` |  |
| `4194377` | `KEY_FORWARD` |  |
| `4194378` | `KEY_STOP` |  |
| `4194379` | `KEY_REFRESH` |  |
| `4194380` | `KEY_VOLUMEDOWN` |  |
| `4194381` | `KEY_VOLUMEMUTE` |  |
| `4194382` | `KEY_VOLUMEUP` |  |
| `4194388` | `KEY_MEDIAPLAY` |  |
| `4194389` | `KEY_MEDIASTOP` |  |
| `4194390` | `KEY_MEDIAPREVIOUS` |  |
| `4194391` | `KEY_MEDIANEXT` |  |
| `4194392` | `KEY_MEDIARECORD` |  |
| `4194393` | `KEY_HOMEPAGE` |  |
| `4194394` | `KEY_FAVORITES` |  |
| `4194395` | `KEY_SEARCH` |  |
| `4194396` | `KEY_STANDBY` |  |
| `4194397` | `KEY_OPENURL` |  |
| `4194398` | `KEY_LAUNCHMAIL` |  |
| `4194399` | `KEY_LAUNCHMEDIA` |  |
| `4194400` | `KEY_LAUNCH0` |  |
| `4194401` | `KEY_LAUNCH1` |  |
| `4194402` | `KEY_LAUNCH2` |  |
| `4194403` | `KEY_LAUNCH3` |  |
| `4194404` | `KEY_LAUNCH4` |  |
| `4194405` | `KEY_LAUNCH5` |  |
| `4194406` | `KEY_LAUNCH6` |  |
| `4194407` | `KEY_LAUNCH7` |  |
| `4194408` | `KEY_LAUNCH8` |  |
| `4194409` | `KEY_LAUNCH9` |  |
| `4194410` | `KEY_LAUNCHA` |  |
| `4194411` | `KEY_LAUNCHB` |  |
| `4194412` | `KEY_LAUNCHC` |  |
| `4194413` | `KEY_LAUNCHD` |  |
| `4194414` | `KEY_LAUNCHE` |  |
| `4194415` | `KEY_LAUNCHF` |  |
| `4194416` | `KEY_GLOBE` |  |
| `4194417` | `KEY_KEYBOARD` |  |
| `4194418` | `KEY_JIS_EISU` |  |
| `4194419` | `KEY_JIS_KANA` |  |
| `8388607` | `KEY_UNKNOWN` |  |
| `32` | `KEY_SPACE` |  |
| `33` | `KEY_EXCLAM` |  |
| `34` | `KEY_QUOTEDBL` |  |
| `35` | `KEY_NUMBERSIGN` |  |
| `36` | `KEY_DOLLAR` |  |
| `37` | `KEY_PERCENT` |  |
| `38` | `KEY_AMPERSAND` |  |
| `39` | `KEY_APOSTROPHE` |  |
| `40` | `KEY_PARENLEFT` |  |
| `41` | `KEY_PARENRIGHT` |  |
| `42` | `KEY_ASTERISK` |  |
| `43` | `KEY_PLUS` |  |
| `44` | `KEY_COMMA` |  |
| `45` | `KEY_MINUS` |  |
| `46` | `KEY_PERIOD` |  |
| `47` | `KEY_SLASH` |  |
| `48` | `KEY_0` |  |
| `49` | `KEY_1` |  |
| `50` | `KEY_2` |  |
| `51` | `KEY_3` |  |
| `52` | `KEY_4` |  |
| `53` | `KEY_5` |  |
| `54` | `KEY_6` |  |
| `55` | `KEY_7` |  |
| `56` | `KEY_8` |  |
| `57` | `KEY_9` |  |
| `58` | `KEY_COLON` |  |
| `59` | `KEY_SEMICOLON` |  |
| `60` | `KEY_LESS` |  |
| `61` | `KEY_EQUAL` |  |
| `62` | `KEY_GREATER` |  |
| `63` | `KEY_QUESTION` |  |
| `64` | `KEY_AT` |  |
| `65` | `KEY_A` |  |
| `66` | `KEY_B` |  |
| `67` | `KEY_C` |  |
| `68` | `KEY_D` |  |
| `69` | `KEY_E` |  |
| `70` | `KEY_F` |  |
| `71` | `KEY_G` |  |
| `72` | `KEY_H` |  |
| `73` | `KEY_I` |  |
| `74` | `KEY_J` |  |
| `75` | `KEY_K` |  |
| `76` | `KEY_L` |  |
| `77` | `KEY_M` |  |
| `78` | `KEY_N` |  |
| `79` | `KEY_O` |  |
| `80` | `KEY_P` |  |
| `81` | `KEY_Q` |  |
| `82` | `KEY_R` |  |
| `83` | `KEY_S` |  |
| `84` | `KEY_T` |  |
| `85` | `KEY_U` |  |
| `86` | `KEY_V` |  |
| `87` | `KEY_W` |  |
| `88` | `KEY_X` |  |
| `89` | `KEY_Y` |  |
| `90` | `KEY_Z` |  |
| `91` | `KEY_BRACKETLEFT` |  |
| `92` | `KEY_BACKSLASH` |  |
| `93` | `KEY_BRACKETRIGHT` |  |
| `94` | `KEY_ASCIICIRCUM` |  |
| `95` | `KEY_UNDERSCORE` |  |
| `96` | `KEY_QUOTELEFT` |  |
| `123` | `KEY_BRACELEFT` |  |
| `124` | `KEY_BAR` |  |
| `125` | `KEY_BRACERIGHT` |  |
| `126` | `KEY_ASCIITILDE` |  |
| `165` | `KEY_YEN` |  |
| `167` | `KEY_SECTION` |  |

### `KeyModifierMask`

| 值 | 名称 | 说明 |
|---|---|---|
| `8388607` | `KEY_CODE_MASK` | （位标志） |
| `2130706432` | `KEY_MODIFIER_MASK` | （位标志） |
| `16777216` | `KEY_MASK_CMD_OR_CTRL` | （位标志） |
| `33554432` | `KEY_MASK_SHIFT` | （位标志） |
| `67108864` | `KEY_MASK_ALT` | （位标志） |
| `134217728` | `KEY_MASK_META` | （位标志） |
| `268435456` | `KEY_MASK_CTRL` | （位标志） |
| `536870912` | `KEY_MASK_KPAD` | （位标志） |
| `1073741824` | `KEY_MASK_GROUP_SWITCH` | （位标志） |

### `KeyLocation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `KEY_LOCATION_UNSPECIFIED` |  |
| `1` | `KEY_LOCATION_LEFT` |  |
| `2` | `KEY_LOCATION_RIGHT` |  |

### `MouseButton`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MOUSE_BUTTON_NONE` |  |
| `1` | `MOUSE_BUTTON_LEFT` |  |
| `2` | `MOUSE_BUTTON_RIGHT` |  |
| `3` | `MOUSE_BUTTON_MIDDLE` |  |
| `4` | `MOUSE_BUTTON_WHEEL_UP` |  |
| `5` | `MOUSE_BUTTON_WHEEL_DOWN` |  |
| `6` | `MOUSE_BUTTON_WHEEL_LEFT` |  |
| `7` | `MOUSE_BUTTON_WHEEL_RIGHT` |  |
| `8` | `MOUSE_BUTTON_XBUTTON1` |  |
| `9` | `MOUSE_BUTTON_XBUTTON2` |  |

### `MouseButtonMask`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `MOUSE_BUTTON_MASK_LEFT` | （位标志） |
| `2` | `MOUSE_BUTTON_MASK_RIGHT` | （位标志） |
| `4` | `MOUSE_BUTTON_MASK_MIDDLE` | （位标志） |
| `128` | `MOUSE_BUTTON_MASK_MB_XBUTTON1` | （位标志） |
| `256` | `MOUSE_BUTTON_MASK_MB_XBUTTON2` | （位标志） |

### `JoyButton`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `JOY_BUTTON_INVALID` |  |
| `0` | `JOY_BUTTON_A` |  |
| `1` | `JOY_BUTTON_B` |  |
| `2` | `JOY_BUTTON_X` |  |
| `3` | `JOY_BUTTON_Y` |  |
| `4` | `JOY_BUTTON_BACK` |  |
| `5` | `JOY_BUTTON_GUIDE` |  |
| `6` | `JOY_BUTTON_START` |  |
| `7` | `JOY_BUTTON_LEFT_STICK` |  |
| `8` | `JOY_BUTTON_RIGHT_STICK` |  |
| `9` | `JOY_BUTTON_LEFT_SHOULDER` |  |
| `10` | `JOY_BUTTON_RIGHT_SHOULDER` |  |
| `11` | `JOY_BUTTON_DPAD_UP` |  |
| `12` | `JOY_BUTTON_DPAD_DOWN` |  |
| `13` | `JOY_BUTTON_DPAD_LEFT` |  |
| `14` | `JOY_BUTTON_DPAD_RIGHT` |  |
| `15` | `JOY_BUTTON_MISC1` |  |
| `16` | `JOY_BUTTON_PADDLE1` |  |
| `17` | `JOY_BUTTON_PADDLE2` |  |
| `18` | `JOY_BUTTON_PADDLE3` |  |
| `19` | `JOY_BUTTON_PADDLE4` |  |
| `20` | `JOY_BUTTON_TOUCHPAD` |  |
| `21` | `JOY_BUTTON_MISC2` |  |
| `22` | `JOY_BUTTON_MISC3` |  |
| `23` | `JOY_BUTTON_MISC4` |  |
| `24` | `JOY_BUTTON_MISC5` |  |
| `25` | `JOY_BUTTON_MISC6` |  |
| `26` | `JOY_BUTTON_SDL_MAX` |  |
| `128` | `JOY_BUTTON_MAX` |  |

### `JoyAxis`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `JOY_AXIS_INVALID` |  |
| `0` | `JOY_AXIS_LEFT_X` |  |
| `1` | `JOY_AXIS_LEFT_Y` |  |
| `2` | `JOY_AXIS_RIGHT_X` |  |
| `3` | `JOY_AXIS_RIGHT_Y` |  |
| `4` | `JOY_AXIS_TRIGGER_LEFT` |  |
| `5` | `JOY_AXIS_TRIGGER_RIGHT` |  |
| `6` | `JOY_AXIS_SDL_MAX` |  |
| `10` | `JOY_AXIS_MAX` |  |

### `MIDIMessage`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MIDI_MESSAGE_NONE` |  |
| `8` | `MIDI_MESSAGE_NOTE_OFF` |  |
| `9` | `MIDI_MESSAGE_NOTE_ON` |  |
| `10` | `MIDI_MESSAGE_AFTERTOUCH` |  |
| `11` | `MIDI_MESSAGE_CONTROL_CHANGE` |  |
| `12` | `MIDI_MESSAGE_PROGRAM_CHANGE` |  |
| `13` | `MIDI_MESSAGE_CHANNEL_PRESSURE` |  |
| `14` | `MIDI_MESSAGE_PITCH_BEND` |  |
| `240` | `MIDI_MESSAGE_SYSTEM_EXCLUSIVE` |  |
| `241` | `MIDI_MESSAGE_QUARTER_FRAME` |  |
| `242` | `MIDI_MESSAGE_SONG_POSITION_POINTER` |  |
| `243` | `MIDI_MESSAGE_SONG_SELECT` |  |
| `246` | `MIDI_MESSAGE_TUNE_REQUEST` |  |
| `248` | `MIDI_MESSAGE_TIMING_CLOCK` |  |
| `250` | `MIDI_MESSAGE_START` |  |
| `251` | `MIDI_MESSAGE_CONTINUE` |  |
| `252` | `MIDI_MESSAGE_STOP` |  |
| `254` | `MIDI_MESSAGE_ACTIVE_SENSING` |  |
| `255` | `MIDI_MESSAGE_SYSTEM_RESET` |  |

### `Error`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OK` |  |
| `1` | `FAILED` |  |
| `2` | `ERR_UNAVAILABLE` |  |
| `3` | `ERR_UNCONFIGURED` |  |
| `4` | `ERR_UNAUTHORIZED` |  |
| `5` | `ERR_PARAMETER_RANGE_ERROR` |  |
| `6` | `ERR_OUT_OF_MEMORY` |  |
| `7` | `ERR_FILE_NOT_FOUND` |  |
| `8` | `ERR_FILE_BAD_DRIVE` |  |
| `9` | `ERR_FILE_BAD_PATH` |  |
| `10` | `ERR_FILE_NO_PERMISSION` |  |
| `11` | `ERR_FILE_ALREADY_IN_USE` |  |
| `12` | `ERR_FILE_CANT_OPEN` |  |
| `13` | `ERR_FILE_CANT_WRITE` |  |
| `14` | `ERR_FILE_CANT_READ` |  |
| `15` | `ERR_FILE_UNRECOGNIZED` |  |
| `16` | `ERR_FILE_CORRUPT` |  |
| `17` | `ERR_FILE_MISSING_DEPENDENCIES` |  |
| `18` | `ERR_FILE_EOF` |  |
| `19` | `ERR_CANT_OPEN` |  |
| `20` | `ERR_CANT_CREATE` |  |
| `21` | `ERR_QUERY_FAILED` |  |
| `22` | `ERR_ALREADY_IN_USE` |  |
| `23` | `ERR_LOCKED` |  |
| `24` | `ERR_TIMEOUT` |  |
| `25` | `ERR_CANT_CONNECT` |  |
| `26` | `ERR_CANT_RESOLVE` |  |
| `27` | `ERR_CONNECTION_ERROR` |  |
| `28` | `ERR_CANT_ACQUIRE_RESOURCE` |  |
| `29` | `ERR_CANT_FORK` |  |
| `30` | `ERR_INVALID_DATA` |  |
| `31` | `ERR_INVALID_PARAMETER` |  |
| `32` | `ERR_ALREADY_EXISTS` |  |
| `33` | `ERR_DOES_NOT_EXIST` |  |
| `34` | `ERR_DATABASE_CANT_READ` |  |
| `35` | `ERR_DATABASE_CANT_WRITE` |  |
| `36` | `ERR_COMPILATION_FAILED` |  |
| `37` | `ERR_METHOD_NOT_FOUND` |  |
| `38` | `ERR_LINK_FAILED` |  |
| `39` | `ERR_SCRIPT_FAILED` |  |
| `40` | `ERR_CYCLIC_LINK` |  |
| `41` | `ERR_INVALID_DECLARATION` |  |
| `42` | `ERR_DUPLICATE_SYMBOL` |  |
| `43` | `ERR_PARSE_ERROR` |  |
| `44` | `ERR_BUSY` |  |
| `45` | `ERR_SKIP` |  |
| `46` | `ERR_HELP` |  |
| `47` | `ERR_BUG` |  |
| `48` | `ERR_PRINTER_ON_FIRE` |  |

### `PropertyHint`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROPERTY_HINT_NONE` |  |
| `1` | `PROPERTY_HINT_RANGE` |  |
| `2` | `PROPERTY_HINT_ENUM` |  |
| `3` | `PROPERTY_HINT_ENUM_SUGGESTION` |  |
| `4` | `PROPERTY_HINT_EXP_EASING` |  |
| `5` | `PROPERTY_HINT_LINK` |  |
| `6` | `PROPERTY_HINT_FLAGS` |  |
| `7` | `PROPERTY_HINT_LAYERS_2D_RENDER` |  |
| `8` | `PROPERTY_HINT_LAYERS_2D_PHYSICS` |  |
| `9` | `PROPERTY_HINT_LAYERS_2D_NAVIGATION` |  |
| `10` | `PROPERTY_HINT_LAYERS_3D_RENDER` |  |
| `11` | `PROPERTY_HINT_LAYERS_3D_PHYSICS` |  |
| `12` | `PROPERTY_HINT_LAYERS_3D_NAVIGATION` |  |
| `37` | `PROPERTY_HINT_LAYERS_AVOIDANCE` |  |
| `13` | `PROPERTY_HINT_FILE` |  |
| `14` | `PROPERTY_HINT_DIR` |  |
| `15` | `PROPERTY_HINT_GLOBAL_FILE` |  |
| `16` | `PROPERTY_HINT_GLOBAL_DIR` |  |
| `17` | `PROPERTY_HINT_RESOURCE_TYPE` |  |
| `18` | `PROPERTY_HINT_MULTILINE_TEXT` |  |
| `19` | `PROPERTY_HINT_EXPRESSION` |  |
| `20` | `PROPERTY_HINT_PLACEHOLDER_TEXT` |  |
| `21` | `PROPERTY_HINT_COLOR_NO_ALPHA` |  |
| `22` | `PROPERTY_HINT_OBJECT_ID` |  |
| `23` | `PROPERTY_HINT_TYPE_STRING` |  |
| `24` | `PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE` |  |
| `25` | `PROPERTY_HINT_OBJECT_TOO_BIG` |  |
| `26` | `PROPERTY_HINT_NODE_PATH_VALID_TYPES` |  |
| `27` | `PROPERTY_HINT_SAVE_FILE` |  |
| `28` | `PROPERTY_HINT_GLOBAL_SAVE_FILE` |  |
| `29` | `PROPERTY_HINT_INT_IS_OBJECTID` |  |
| `30` | `PROPERTY_HINT_INT_IS_POINTER` |  |
| `31` | `PROPERTY_HINT_ARRAY_TYPE` |  |
| `38` | `PROPERTY_HINT_DICTIONARY_TYPE` |  |
| `32` | `PROPERTY_HINT_LOCALE_ID` |  |
| `33` | `PROPERTY_HINT_LOCALIZABLE_STRING` |  |
| `34` | `PROPERTY_HINT_NODE_TYPE` |  |
| `35` | `PROPERTY_HINT_HIDE_QUATERNION_EDIT` |  |
| `36` | `PROPERTY_HINT_PASSWORD` |  |
| `39` | `PROPERTY_HINT_TOOL_BUTTON` |  |
| `40` | `PROPERTY_HINT_ONESHOT` |  |
| `42` | `PROPERTY_HINT_GROUP_ENABLE` |  |
| `43` | `PROPERTY_HINT_INPUT_NAME` |  |
| `44` | `PROPERTY_HINT_FILE_PATH` |  |
| `45` | `PROPERTY_HINT_MAX` |  |

### `PropertyUsageFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PROPERTY_USAGE_NONE` | （位标志） |
| `2` | `PROPERTY_USAGE_STORAGE` | （位标志） |
| `4` | `PROPERTY_USAGE_EDITOR` | （位标志） |
| `8` | `PROPERTY_USAGE_INTERNAL` | （位标志） |
| `16` | `PROPERTY_USAGE_CHECKABLE` | （位标志） |
| `32` | `PROPERTY_USAGE_CHECKED` | （位标志） |
| `64` | `PROPERTY_USAGE_GROUP` | （位标志） |
| `128` | `PROPERTY_USAGE_CATEGORY` | （位标志） |
| `256` | `PROPERTY_USAGE_SUBGROUP` | （位标志） |
| `512` | `PROPERTY_USAGE_CLASS_IS_BITFIELD` | （位标志） |
| `1024` | `PROPERTY_USAGE_NO_INSTANCE_STATE` | （位标志） |
| `2048` | `PROPERTY_USAGE_RESTART_IF_CHANGED` | （位标志） |
| `4096` | `PROPERTY_USAGE_SCRIPT_VARIABLE` | （位标志） |
| `8192` | `PROPERTY_USAGE_STORE_IF_NULL` | （位标志） |
| `16384` | `PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED` | （位标志） |
| `32768` | `PROPERTY_USAGE_SCRIPT_DEFAULT_VALUE` | （位标志） |
| `65536` | `PROPERTY_USAGE_CLASS_IS_ENUM` | （位标志） |
| `131072` | `PROPERTY_USAGE_NIL_IS_VARIANT` | （位标志） |
| `262144` | `PROPERTY_USAGE_ARRAY` | （位标志） |
| `524288` | `PROPERTY_USAGE_ALWAYS_DUPLICATE` | （位标志） |
| `1048576` | `PROPERTY_USAGE_NEVER_DUPLICATE` | （位标志） |
| `2097152` | `PROPERTY_USAGE_HIGH_END_GFX` | （位标志） |
| `4194304` | `PROPERTY_USAGE_NODE_PATH_FROM_SCENE_ROOT` | （位标志） |
| `8388608` | `PROPERTY_USAGE_RESOURCE_NOT_PERSISTENT` | （位标志） |
| `16777216` | `PROPERTY_USAGE_KEYING_INCREMENTS` | （位标志） |
| `33554432` | `PROPERTY_USAGE_DEFERRED_SET_RESOURCE` | （位标志） |
| `67108864` | `PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT` | （位标志） |
| `134217728` | `PROPERTY_USAGE_EDITOR_BASIC_SETTING` | （位标志） |
| `268435456` | `PROPERTY_USAGE_READ_ONLY` | （位标志） |
| `536870912` | `PROPERTY_USAGE_SECRET` | （位标志） |
| `6` | `PROPERTY_USAGE_DEFAULT` | （位标志） |
| `2` | `PROPERTY_USAGE_NO_EDITOR` | （位标志） |

### `MethodFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `METHOD_FLAG_NORMAL` | （位标志） |
| `2` | `METHOD_FLAG_EDITOR` | （位标志） |
| `4` | `METHOD_FLAG_CONST` | （位标志） |
| `8` | `METHOD_FLAG_VIRTUAL` | （位标志） |
| `16` | `METHOD_FLAG_VARARG` | （位标志） |
| `32` | `METHOD_FLAG_STATIC` | （位标志） |
| `64` | `METHOD_FLAG_OBJECT_CORE` | （位标志） |
| `128` | `METHOD_FLAG_VIRTUAL_REQUIRED` | （位标志） |
| `1` | `METHOD_FLAGS_DEFAULT` | （位标志） |

### `Variant.Type`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_NIL` |  |
| `1` | `TYPE_BOOL` |  |
| `2` | `TYPE_INT` |  |
| `3` | `TYPE_FLOAT` |  |
| `4` | `TYPE_STRING` |  |
| `5` | `TYPE_VECTOR2` |  |
| `6` | `TYPE_VECTOR2I` |  |
| `7` | `TYPE_RECT2` |  |
| `8` | `TYPE_RECT2I` |  |
| `9` | `TYPE_VECTOR3` |  |
| `10` | `TYPE_VECTOR3I` |  |
| `11` | `TYPE_TRANSFORM2D` |  |
| `12` | `TYPE_VECTOR4` |  |
| `13` | `TYPE_VECTOR4I` |  |
| `14` | `TYPE_PLANE` |  |
| `15` | `TYPE_QUATERNION` |  |
| `16` | `TYPE_AABB` |  |
| `17` | `TYPE_BASIS` |  |
| `18` | `TYPE_TRANSFORM3D` |  |
| `19` | `TYPE_PROJECTION` |  |
| `20` | `TYPE_COLOR` |  |
| `21` | `TYPE_STRING_NAME` |  |
| `22` | `TYPE_NODE_PATH` |  |
| `23` | `TYPE_RID` |  |
| `24` | `TYPE_OBJECT` |  |
| `25` | `TYPE_CALLABLE` |  |
| `26` | `TYPE_SIGNAL` |  |
| `27` | `TYPE_DICTIONARY` |  |
| `28` | `TYPE_ARRAY` |  |
| `29` | `TYPE_PACKED_BYTE_ARRAY` |  |
| `30` | `TYPE_PACKED_INT32_ARRAY` |  |
| `31` | `TYPE_PACKED_INT64_ARRAY` |  |
| `32` | `TYPE_PACKED_FLOAT32_ARRAY` |  |
| `33` | `TYPE_PACKED_FLOAT64_ARRAY` |  |
| `34` | `TYPE_PACKED_STRING_ARRAY` |  |
| `35` | `TYPE_PACKED_VECTOR2_ARRAY` |  |
| `36` | `TYPE_PACKED_VECTOR3_ARRAY` |  |
| `37` | `TYPE_PACKED_COLOR_ARRAY` |  |
| `38` | `TYPE_PACKED_VECTOR4_ARRAY` |  |
| `39` | `TYPE_MAX` |  |

### `Variant.Operator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `OP_EQUAL` |  |
| `1` | `OP_NOT_EQUAL` |  |
| `2` | `OP_LESS` |  |
| `3` | `OP_LESS_EQUAL` |  |
| `4` | `OP_GREATER` |  |
| `5` | `OP_GREATER_EQUAL` |  |
| `6` | `OP_ADD` |  |
| `7` | `OP_SUBTRACT` |  |
| `8` | `OP_MULTIPLY` |  |
| `9` | `OP_DIVIDE` |  |
| `10` | `OP_NEGATE` |  |
| `11` | `OP_POSITIVE` |  |
| `12` | `OP_MODULE` |  |
| `13` | `OP_POWER` |  |
| `14` | `OP_SHIFT_LEFT` |  |
| `15` | `OP_SHIFT_RIGHT` |  |
| `16` | `OP_BIT_AND` |  |
| `17` | `OP_BIT_OR` |  |
| `18` | `OP_BIT_XOR` |  |
| `19` | `OP_BIT_NEGATE` |  |
| `20` | `OP_AND` |  |
| `21` | `OP_OR` |  |
| `22` | `OP_XOR` |  |
| `23` | `OP_NOT` |  |
| `24` | `OP_IN` |  |
| `25` | `OP_MAX` |  |

## 常量

- **`UINT8_MAX`** = `255`
- **`UINT16_MAX`** = `65535`
- **`UINT32_MAX`** = `4294967295`
- **`INT8_MIN`** = `-128`
- **`INT8_MAX`** = `127`
- **`INT16_MIN`** = `-32768`
- **`INT16_MAX`** = `32767`
- **`INT32_MIN`** = `-2147483648`
- **`INT32_MAX`** = `2147483647`
- **`INT64_MIN`** = `-9223372036854775808`
- **`INT64_MAX`** = `9223372036854775807`
## 教程链接

- [Random number generation](None)

