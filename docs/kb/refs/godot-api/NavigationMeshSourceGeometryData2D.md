# NavigationMeshSourceGeometryData2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`NavigationMeshSourceGeometryData2D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/NavigationMeshSourceGeometryData2D.md`

**摘要**：Container for parsed source geometry data used in navigation mesh baking.

## 描述

Container for parsed source geometry data used in navigation mesh baking.

## 方法

### `add_obstruction_outline(shape_outline: PackedVector2Array) -> void`

Adds the outline points of a shape as obstructed area.

### `add_projected_obstruction(vertices: PackedVector2Array, carve: bool) -> void`

Adds a projected obstruction shape to the source geometry. If `carve` is `true` the carved shape will not be affected by additional offsets (e.g. agent radius) of the navigation mesh baking process.

### `add_traversable_outline(shape_outline: PackedVector2Array) -> void`

Adds the outline points of a shape as traversable area.

### `append_obstruction_outlines(obstruction_outlines: PackedVector2Array[]) -> void`

Appends another array of `obstruction_outlines` at the end of the existing obstruction outlines array.

### `append_traversable_outlines(traversable_outlines: PackedVector2Array[]) -> void`

Appends another array of `traversable_outlines` at the end of the existing traversable outlines array.

### `clear() -> void`

Clears the internal data.

### `clear_projected_obstructions() -> void`

Clears all projected obstructions.

### `get_bounds() -> Rect2`

Returns an axis-aligned bounding box that covers all the stored geometry data. The bounds are calculated when calling this function with the result cached until further geometry changes are made.

### `get_obstruction_outlines() -> PackedVector2Array[]`
- 限定：qualifiers=const

Returns all the obstructed area outlines arrays.

### `get_projected_obstructions() -> Array`
- 限定：qualifiers=const

Returns the projected obstructions as an `Array` of dictionaries. Each `Dictionary` contains the following entries:
				- `vertices` - A `PackedFloat32Array` that defines the outline points of the projected shape.
				- `carve` - A `bool` that defines how the projected shape affects the navigation mesh baking. If `true` the projected shape will not be affected by addition offsets, e.g. agent radius.

### `get_traversable_outlines() -> PackedVector2Array[]`
- 限定：qualifiers=const

Returns all the traversable area outlines arrays.

### `has_data() -> bool`

Returns `true` when parsed source geometry data exists.

### `merge(other_geometry: NavigationMeshSourceGeometryData2D) -> void`

Adds the geometry data of another `NavigationMeshSourceGeometryData2D` to the navigation mesh baking data.

### `set_obstruction_outlines(obstruction_outlines: PackedVector2Array[]) -> void`

Sets all the obstructed area outlines arrays.

### `set_projected_obstructions(projected_obstructions: Array) -> void`

Sets the projected obstructions with an Array of Dictionaries with the following key value pairs:
				`codeblocks`
				`gdscript`
				"vertices" : PackedFloat32Array
				"carve" : bool

### `set_traversable_outlines(traversable_outlines: PackedVector2Array[]) -> void`

Sets all the traversable area outlines arrays.

