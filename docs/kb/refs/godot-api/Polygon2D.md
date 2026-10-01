# Polygon2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Polygon2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Polygon2D.md`

**摘要**：A 2D polygon.

## 描述

A Polygon2D is defined by a set of points. Each point is connected to the next, with the final point being connected to the first, resulting in a closed polygon. Polygon2Ds can be filled with color (solid or gradient) or filled with a given texture.

## 属性

- **`antialiased`** `bool` = `false`
  - 其它属性：getter=get_antialiased · setter=set_antialiased
- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`internal_vertex_count`** `int` = `0`
  - 其它属性：getter=get_internal_vertex_count · setter=set_internal_vertex_count
- **`invert_border`** `float` = `100.0`
  - 其它属性：getter=get_invert_border · setter=set_invert_border
- **`invert_enabled`** `bool` = `false`
  - 其它属性：getter=get_invert_enabled · setter=set_invert_enabled
- **`offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_offset · setter=set_offset
- **`polygon`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_polygon · setter=set_polygon
- **`polygons`** `Array` = `[]`
  - 其它属性：getter=get_polygons · setter=set_polygons
- **`skeleton`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_skeleton · setter=set_skeleton
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`texture_offset`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_texture_offset · setter=set_texture_offset
- **`texture_rotation`** `float` = `0.0`
  - 其它属性：getter=get_texture_rotation · setter=set_texture_rotation
- **`texture_scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_texture_scale · setter=set_texture_scale
- **`uv`** `PackedVector2Array` = `PackedVector2Array()`
  - 其它属性：getter=get_uv · setter=set_uv
- **`vertex_colors`** `PackedColorArray` = `PackedColorArray()`
  - 其它属性：getter=get_vertex_colors · setter=set_vertex_colors

## 方法

### `add_bone(path: NodePath, weights: PackedFloat32Array) -> void`

Adds a bone with the specified `path` and `weights`.

### `clear_bones() -> void`

Removes all bones from this `Polygon2D`.

### `erase_bone(index: int) -> void`

Removes the specified bone from this `Polygon2D`.

### `get_bone_count() -> int`
- 限定：qualifiers=const

Returns the number of bones in this `Polygon2D`.

### `get_bone_path(index: int) -> NodePath`
- 限定：qualifiers=const

Returns the path to the node associated with the specified bone.

### `get_bone_weights(index: int) -> PackedFloat32Array`
- 限定：qualifiers=const

Returns the weight values of the specified bone.

### `set_bone_path(index: int, path: NodePath) -> void`

Sets the path to the node associated with the specified bone.

### `set_bone_weights(index: int, weights: PackedFloat32Array) -> void`

Sets the weight values for the specified bone.

