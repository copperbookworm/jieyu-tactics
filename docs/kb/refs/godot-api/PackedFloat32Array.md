# PackedFloat32Array

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PackedFloat32Array`
> 自动生成，勿手改。文件：`refs/godot-api/PackedFloat32Array.md`

**摘要**：A packed array of 32-bit floating-point values.

## 描述

An array specifically designed to hold 32-bit floating-point values (float). Packs data tightly, so it saves memory for large array sizes.
		If you need to pack 64-bit floats tightly, see `PackedFloat64Array`.
		**Note:** Packed arrays are always passed by reference. To get a copy of an array that can be modified independently of the original array, use `duplicate`. This is *not* the case for built-in properties and methods. In these cases the returned packed array is a copy, and changing it will *not* affect the original value. To update a built-in property of this type, modify the returned array and then assign it to the property again.
		**Note:** In a boolean context, a packed array will evaluate to `false` if it's empty. Otherwise, a packed array will always evaluate to `true`.

## 方法

### `append(value: float) -> bool`

Appends an element at the end of the array (alias of `push_back`).

### `append_array(array: PackedFloat32Array) -> void`

Appends a `PackedFloat32Array` at the end of this array.

### `bsearch(value: float, before: bool = true) -> int`
- 限定：qualifiers=const

Finds the index of an existing value (or the insertion index that maintains sorting order, if the value is not yet present in the array) using binary search. Optionally, a `before` specifier can be passed. If `false`, the returned index comes after all existing entries of the value in the array.
				**Note:** Calling `bsearch` on an unsorted array results in unexpected behavior.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `clear() -> void`

Clears the array. This is equivalent to using `resize` with a size of `0`.

### `count(value: float) -> int`
- 限定：qualifiers=const

Returns the number of times an element is in the array.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `duplicate() -> PackedFloat32Array`
- 限定：qualifiers=const

Creates a copy of the array, and returns it.

### `erase(value: float) -> bool`

Removes the first occurrence of a value from the array and returns `true`. If the value does not exist in the array, nothing happens and `false` is returned. To remove an element by index, use `remove_at` instead.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `fill(value: float) -> void`

Assigns the given value to all elements in the array. This can typically be used together with `resize` to create an array with a given size and initialized elements.

### `find(value: float, from: int = 0) -> int`
- 限定：qualifiers=const

Searches the array for a value and returns its index or `-1` if not found. Optionally, the initial search index can be passed.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `get(index: int) -> float`
- 限定：qualifiers=const

Returns the 32-bit float at the given `index` in the array. If `index` is out-of-bounds or negative, this method fails and returns `0.0`.
				This method is similar (but not identical) to the `[]` operator. Most notably, when this method fails, it doesn't pause project execution if run from the editor.

### `has(value: float) -> bool`
- 限定：qualifiers=const

Returns `true` if the array contains `value`.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `insert(at_index: int, value: float) -> int`

Inserts a new element at a given position in the array. The position must be valid, or at the end of the array (`idx == size()`).

### `is_empty() -> bool`
- 限定：qualifiers=const

Returns `true` if the array is empty.

### `push_back(value: float) -> bool`

Appends an element at the end of the array.

### `remove_at(index: int) -> void`

Removes an element from the array by index.

### `resize(new_size: int) -> int`

Sets the size of the array. If the array is grown, reserves elements at the end of the array. If the array is shrunk, truncates the array to the new size. Calling `resize` once and assigning the new values is faster than adding new elements one by one.
				Returns `OK` on success, or one of the following `Error` constants if this method fails: `ERR_INVALID_PARAMETER` if the size is negative, or `ERR_OUT_OF_MEMORY` if allocations fail. Use `size` to find the actual size of the array after resize.

### `reverse() -> void`

Reverses the order of the elements in the array.

### `rfind(value: float, from: int = -1) -> int`
- 限定：qualifiers=const

Searches the array in reverse order. Optionally, a start search index can be passed. If negative, the start index is considered relative to the end of the array.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `set(index: int, value: float) -> void`

Changes the float at the given index.

### `size() -> int`
- 限定：qualifiers=const

Returns the number of elements in the array.

### `slice(begin: int, end: int = 2147483647) -> PackedFloat32Array`
- 限定：qualifiers=const

Returns the slice of the `PackedFloat32Array`, from `begin` (inclusive) to `end` (exclusive), as a new `PackedFloat32Array`.
				The absolute value of `begin` and `end` will be clamped to the array size, so the default value for `end` makes it slice to the size of the array by default (i.e. `arr.slice(1)` is a shorthand for `arr.slice(1, arr.size())`).
				If either `begin` or `end` are negative, they will be relative to the end of the array (i.e. `arr.slice(0, -2)` is a shorthand for `arr.slice(0, arr.size() - 2)`).

### `sort() -> void`

Sorts the elements of the array in ascending order.
				**Note:** `@GDScript.NAN` doesn't behave the same as other numbers. Therefore, the results from this method may not be accurate if NaNs are included.

### `to_byte_array() -> PackedByteArray`
- 限定：qualifiers=const

Returns a copy of the data converted to a `PackedByteArray`, where each element has been encoded as 4 bytes.
				The size of the new array will be `float32_array.size() * 4`.

## 构造函数

### `PackedFloat32Array`

Constructs an empty `PackedFloat32Array`.

### `PackedFloat32Array`

Constructs a `PackedFloat32Array` as a copy of the given `PackedFloat32Array`.

### `PackedFloat32Array`

Constructs a new `PackedFloat32Array`. Optionally, you can pass in a generic `Array` that will be converted.

## 运算符

### `operator !=`

Returns `true` if contents of the arrays differ.

### `operator +`

Returns a new `PackedFloat32Array` with contents of `right` added at the end of this array. For better performance, consider using `append_array` instead.

### `operator ==`

Returns `true` if contents of both arrays are the same, i.e. they have all equal floats at the corresponding indices.

### `operator []`

Returns the `float` at index `index`. Negative indices can be used to access the elements starting from the end. Using index out of array's bounds will result in an error.
				Note that `float` type is 64-bit, unlike the values stored in the array.

