# RandomNumberGenerator

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RandomNumberGenerator` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RandomNumberGenerator.md`

**摘要**：Provides methods for generating pseudo-random numbers.

## 描述

RandomNumberGenerator is a class for generating pseudo-random numbers. It currently uses PCG32 (https://www.pcg-random.org/).
		**Note:** The underlying algorithm is an implementation detail and should not be depended upon.
		To generate a random float number (within a given range) based on a time-dependent seed:
		
```gdscript
		var rng = RandomNumberGenerator.new()
		func _ready():
			var my_random_number = rng.randf_range(-10.0, 10.0)
		
```

## 属性

- **`seed`** `int` = `0`
  - 其它属性：getter=get_seed · setter=set_seed
- **`state`** `int` = `0`
  - 其它属性：getter=get_state · setter=set_state

## 方法

### `rand_weighted(weights: PackedFloat32Array) -> int`

Returns a random integer between `0` and the size of the array that is passed as a parameter. Each value in the array should be a floating-point number that represents the relative likelihood that it will be returned as an index. A higher value means the value is more likely to be returned as an index, while a value of `0` means it will never be returned as an index.
				For example, if `skip-lint`[0.5, 1, 1, 2] is passed as a parameter, then the method is twice as likely to return `3` (the index of the value `2`) and twice as unlikely to return `0` (the index of the value `0.5`) compared to the indices `1` and `2`.
				Prints an error and returns `-1` if the array is empty.
				`codeblocks`
				`gdscript`
				var rng = RandomNumberGenerator.new()

				var my_array = ["one", "two", "three", "four"]
				var weights = PackedFloat32Array([0.5, 1, 1, 2])

				# Prints one of the four elements in `my_array`.
				# It is more likely to print "four", and less likely to print "one".
				print(my_array[rng.rand_weighted(weights)])

### `randf() -> float`

Returns a pseudo-random float between `0.0` and `1.0` (inclusive).

### `randf_range(from: float, to: float) -> float`

Returns a pseudo-random float between `from` and `to` (inclusive).

### `randfn(mean: float = 0.0, deviation: float = 1.0) -> float`

Returns a normally-distributed (https://en.wikipedia.org/wiki/Normal_distribution), pseudo-random floating-point number from the specified `mean` and a standard `deviation`. This is also known as a Gaussian distribution.
				**Note:** This method uses the Box-Muller transform (https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform) algorithm.

### `randi() -> int`

Returns a pseudo-random 32-bit unsigned integer between `0` and `4294967295` (inclusive).

### `randi_range(from: int, to: int) -> int`

Returns a pseudo-random 32-bit signed integer between `from` and `to` (inclusive).

### `randomize() -> void`

Sets up a time-based seed for this `RandomNumberGenerator` instance. Unlike the `@GlobalScope` random number generation functions, different `RandomNumberGenerator` instances can use different seeds.

## 教程链接

- [Random number generation](None)

