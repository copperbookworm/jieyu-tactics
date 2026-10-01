# HeightMapShape3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`HeightMapShape3D` → `Shape3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/HeightMapShape3D.md`

**摘要**：A 3D heightmap shape used for physics collision.

## 描述

A 3D heightmap shape, intended for use in physics to provide a shape for a `CollisionShape3D`. This type is most commonly used for terrain with vertices placed in a fixed-width grid.
		The heightmap is represented as a 2D grid of height values, which represent the position of grid points on the Y axis. Grid points are spaced 1 unit apart on the X and Z axes, and the grid is centered on the origin of the `CollisionShape3D` node. Internally, each grid square is divided into two triangles.
		Due to the nature of the heightmap, it cannot be used to model overhangs or caves, which would require multiple vertices at the same vertical location. Holes can be punched through the collision by assigning `@GDScript.NAN` to the height of the desired vertices (this is supported in both GodotPhysics3D and Jolt Physics). You could then insert meshes with their own separate collision to provide overhangs, caves, and so on.
		**Performance:** `HeightMapShape3D` is faster to check collisions against than `ConcavePolygonShape3D`, but it is significantly slower than primitive shapes like `BoxShape3D`.
		A heightmap collision shape can also be built by using an `Image` reference:
		`codeblocks`
		`gdscript`
		var heightmap_texture = ResourceLoader.load("res://heightmap_image.exr")
		var heightmap_image = heightmap_texture.get_image()
		heightmap_image.convert(Image.FORMAT_RF)

		var height_min = 0.0
		var height_max = 10.0

		update_map_data_from_image(heightmap_image, height_min, height_max)
		
		
		**Note:** If you need to use a spacing different than 1 unit, you can adjust the `Node3D.scale` of the shape. However, keep in mind that GodotPhysics3D does not support non-uniform scaling: you'll need to scale the Y axis by the same amount as the X and Z axes, which means the values in `map_data` will need to be pre-scaled by the inverse of that scale. Also note that GodotPhysics3D does not support scaling at all for dynamic bodies (that is, non-frozen `RigidBody3D` nodes); to use a scaled `HeightMapShape3D` with those, you will need to use Jolt Physics.

## 属性

- **`map_data`** `PackedFloat32Array` = `PackedFloat32Array(0, 0, 0, 0)`
  - 其它属性：getter=get_map_data · setter=set_map_data
- **`map_depth`** `int` = `2`
  - 其它属性：getter=get_map_depth · setter=set_map_depth
- **`map_width`** `int` = `2`
  - 其它属性：getter=get_map_width · setter=set_map_width

## 方法

### `get_max_height() -> float`
- 限定：qualifiers=const

Returns the largest height value found in `map_data`. Recalculates only when `map_data` changes.

### `get_min_height() -> float`
- 限定：qualifiers=const

Returns the smallest height value found in `map_data`. Recalculates only when `map_data` changes.

### `update_map_data_from_image(image: Image, height_min: float, height_max: float) -> void`

Updates `map_data` with data read from an `Image` reference. Automatically resizes heightmap `map_width` and `map_depth` to fit the full image width and height.
				The image needs to be in either `Image.FORMAT_RF` (32 bit), `Image.FORMAT_RH` (16 bit), or `Image.FORMAT_R8` (8 bit).
				Each image pixel is read in as a float on the range from `0.0` (black pixel) to `1.0` (white pixel). This range value gets remapped to `height_min` and `height_max` to form the final height value.
				**Note:** Using a heightmap with 16-bit or 32-bit data, stored in EXR or HDR format is recommended. Using 8-bit height data, or a format like PNG that Godot imports as 8-bit, will result in a terraced terrain.

