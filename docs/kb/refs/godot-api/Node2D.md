# Node2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Node2D.md`

**摘要**：A 2D game object, inherited by all 2D-related nodes. Has a position, rotation, scale, and skew.

## 描述

A 2D game object, with a transform (position, rotation, and scale). All 2D nodes, including physics objects and sprites, inherit from Node2D. Use Node2D as a parent node to move, scale and rotate children in a 2D project. Also gives control of the node's render order.
		**Note:** Since both `Node2D` and `Control` inherit from `CanvasItem`, they share several concepts from the class such as the `CanvasItem.z_index` and `CanvasItem.visible` properties.

## 属性

- **`global_position`** `Vector2`
  - 其它属性：getter=get_global_position · setter=set_global_position
- **`global_rotation`** `float`
  - 其它属性：getter=get_global_rotation · setter=set_global_rotation
- **`global_rotation_degrees`** `float`
  - 其它属性：getter=get_global_rotation_degrees · setter=set_global_rotation_degrees
- **`global_scale`** `Vector2`
  - 其它属性：getter=get_global_scale · setter=set_global_scale
- **`global_skew`** `float`
  - 其它属性：getter=get_global_skew · setter=set_global_skew
- **`global_transform`** `Transform2D`
  - 其它属性：getter=get_global_transform · setter=set_global_transform
- **`position`** `Vector2` = `Vector2(0, 0)`
  - 其它属性：getter=get_position · setter=set_position
- **`rotation`** `float` = `0.0`
  - 其它属性：getter=get_rotation · setter=set_rotation
- **`rotation_degrees`** `float`
  - 其它属性：getter=get_rotation_degrees · setter=set_rotation_degrees
- **`scale`** `Vector2` = `Vector2(1, 1)`
  - 其它属性：getter=get_scale · setter=set_scale
- **`skew`** `float` = `0.0`
  - 其它属性：getter=get_skew · setter=set_skew
- **`transform`** `Transform2D`
  - 其它属性：getter=get_transform · setter=set_transform

## 方法

### `apply_scale(ratio: Vector2) -> void`

Multiplies the current scale by the `ratio` vector.

### `get_angle_to(point: Vector2) -> float`
- 限定：keywords=look_at · qualifiers=const

Returns the angle between the node and the `point` in radians. See also `look_at`.
				Illustration of the returned angle. (https://raw.githubusercontent.com/godotengine/godot-docs/master/img/node2d_get_angle_to.png)

### `get_relative_transform_to_parent(parent: Node) -> Transform2D`
- 限定：qualifiers=const

Returns the `Transform2D` relative to this node's parent.

### `global_translate(offset: Vector2) -> void`

Adds the `offset` vector to the node's global position.

### `look_at(point: Vector2) -> void`

Rotates the node so that its local +X axis points towards the `point`, which is expected to use global coordinates. This method is a combination of both `rotate` and `get_angle_to`.
				`point` should not be the same as the node's position, otherwise the node always looks to the right.

### `move_local_x(delta: float, scaled: bool = false) -> void`
- 限定：keywords=translate_object_local

Applies a local translation on the node's X axis with the amount specified in `delta`. If `scaled` is `false`, normalizes the movement to occur independently of the node's `scale`.

### `move_local_y(delta: float, scaled: bool = false) -> void`
- 限定：keywords=translate_object_local

Applies a local translation on the node's Y axis with the amount specified in `delta`. If `scaled` is `false`, normalizes the movement to occur independently of the node's `scale`.

### `rotate(radians: float) -> void`

Applies a rotation to the node, in radians, starting from its current rotation. This is equivalent to `rotation += radians`.

### `to_global(local_point: Vector2) -> Vector2`
- 限定：qualifiers=const

Transforms the provided local position into a position in global coordinate space. The input is expected to be local relative to the `Node2D` it is called on. e.g. Applying this method to the positions of child nodes will correctly transform their positions into the global coordinate space, but applying it to a node's own position will give an incorrect result, as it will incorporate the node's own transformation into its global position.

### `to_local(global_point: Vector2) -> Vector2`
- 限定：qualifiers=const

Transforms the provided global position into a position in local coordinate space. The output will be local relative to the `Node2D` it is called on. e.g. It is appropriate for determining the positions of child nodes, but it is not appropriate for determining its own position relative to its parent.

### `translate(offset: Vector2) -> void`

Translates the node by the given `offset` in local coordinates. This is equivalent to `position += offset`.

## 教程链接

- [Custom drawing in 2D](None)
- [All 2D Demos](None)

