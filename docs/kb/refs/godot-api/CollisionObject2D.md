# CollisionObject2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionObject2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionObject2D.md`

**摘要**：Abstract base class for 2D physics objects.

## 描述

Abstract base class for 2D physics objects. `CollisionObject2D` can hold any number of `Shape2D`s for collision. Each shape must be assigned to a *shape owner*. Shape owners are not nodes and do not appear in the editor, but are accessible through code using the `shape_owner_*` methods.
		**Note:** Only collisions between objects within the same canvas (`Viewport` canvas or `CanvasLayer`) are supported. The behavior of collisions between objects in different canvases is undefined.

## 属性

- **`collision_layer`** `int` = `1`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`collision_priority`** `float` = `1.0`
  - 其它属性：getter=get_collision_priority · setter=set_collision_priority
- **`disable_mode`** `int` = `0` · 枚举 `CollisionObject2D.DisableMode`
  - 其它属性：getter=get_disable_mode · setter=set_disable_mode
- **`input_pickable`** `bool` = `true`
  - 其它属性：getter=is_pickable · setter=set_pickable

## 方法

### `_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void`
- 限定：qualifiers=virtual

Accepts unhandled `InputEvent`s. `shape_idx` is the child index of the clicked `Shape2D`. Connect to `input_event` to easily pick up these events.
				**Note:** `_input_event` requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set.

### `_mouse_enter() -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer enters any of this object's shapes. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject2D` won't cause this function to be called.

### `_mouse_exit() -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer exits all this object's shapes. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject2D` won't cause this function to be called.

### `_mouse_shape_enter(shape_idx: int) -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer enters any of this object's shapes or moves from one shape to another. `shape_idx` is the child index of the newly entered `Shape2D`. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be called.

### `_mouse_shape_exit(shape_idx: int) -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer exits any of this object's shapes. `shape_idx` is the child index of the exited `Shape2D`. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be called.

### `create_shape_owner(owner: Object) -> int`

Creates a new shape owner for the given object. Returns `owner_id` of the new owner for future reference.

### `get_collision_layer_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_layer` is enabled, given a `layer_number` between 1 and 32.

### `get_collision_mask_value(layer_number: int) -> bool`
- 限定：qualifiers=const

Returns whether or not the specified layer of the `collision_mask` is enabled, given a `layer_number` between 1 and 32.

### `get_rid() -> RID`
- 限定：qualifiers=const

Returns the object's `RID`.

### `get_shape_owner_one_way_collision_direction(owner_id: int) -> Vector2`
- 限定：qualifiers=const

Returns the `one_way_collision_direction` of the shape owner identified by the given `owner_id`.

### `get_shape_owner_one_way_collision_margin(owner_id: int) -> float`
- 限定：qualifiers=const

Returns the `one_way_collision_margin` of the shape owner identified by given `owner_id`.

### `get_shape_owners() -> PackedInt32Array`

Returns an `Array` of `owner_id` identifiers. You can use these ids in other methods that take `owner_id` as an argument.

### `is_shape_owner_disabled(owner_id: int) -> bool`
- 限定：qualifiers=const

If `true`, the shape owner and its shapes are disabled.

### `is_shape_owner_one_way_collision_enabled(owner_id: int) -> bool`
- 限定：qualifiers=const

Returns `true` if collisions for the shape owner originating from this `CollisionObject2D` will not be reported to collided with `CollisionObject2D`s.

### `remove_shape_owner(owner_id: int) -> void`

Removes the given shape owner.

### `set_collision_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_layer`, given a `layer_number` between 1 and 32.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

### `shape_find_owner(shape_index: int) -> int`
- 限定：qualifiers=const

Returns the `owner_id` of the given shape.

### `shape_owner_add_shape(owner_id: int, shape: Shape2D) -> void`

Adds a `Shape2D` to the shape owner.

### `shape_owner_clear_shapes(owner_id: int) -> void`

Removes all shapes from the shape owner.

### `shape_owner_get_owner(owner_id: int) -> Object`
- 限定：qualifiers=const

Returns the parent object of the given shape owner.

### `shape_owner_get_shape(owner_id: int, shape_id: int) -> Shape2D`
- 限定：qualifiers=const

Returns the `Shape2D` with the given ID from the given shape owner.

### `shape_owner_get_shape_count(owner_id: int) -> int`
- 限定：qualifiers=const

Returns the number of shapes the given shape owner contains.

### `shape_owner_get_shape_index(owner_id: int, shape_id: int) -> int`
- 限定：qualifiers=const

Returns the child index of the `Shape2D` with the given ID from the given shape owner.

### `shape_owner_get_transform(owner_id: int) -> Transform2D`
- 限定：qualifiers=const

Returns the shape owner's `Transform2D`.

### `shape_owner_remove_shape(owner_id: int, shape_id: int) -> void`

Removes a shape from the given shape owner.

### `shape_owner_set_disabled(owner_id: int, disabled: bool) -> void`

If `true`, disables the given shape owner.

### `shape_owner_set_one_way_collision(owner_id: int, enable: bool) -> void`

If `enable` is `true`, collisions for the shape owner originating from this `CollisionObject2D` will not be reported to collided with `CollisionObject2D`s.

### `shape_owner_set_one_way_collision_direction(owner_id: int, direction: Vector2) -> void`

Sets the `one_way_collision_direction` of the shape owner identified by the given `owner_id` to `direction`.

### `shape_owner_set_one_way_collision_margin(owner_id: int, margin: float) -> void`

Sets the `one_way_collision_margin` of the shape owner identified by given `owner_id` to `margin` pixels.

### `shape_owner_set_transform(owner_id: int, transform: Transform2D) -> void`

Sets the `Transform2D` of the given shape owner.

## 信号

### `input_event(viewport: Node, event: InputEvent, shape_idx: int)`

Emitted when an input event occurs. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set. See `_input_event` for details.

### `mouse_entered()`

Emitted when the mouse pointer enters any of this object's shapes. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject2D` won't cause this signal to be emitted.
				**Note:** Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the `CollisionObject2D`'s area is small. This signal may also not be emitted if another `CollisionObject2D` is overlapping the `CollisionObject2D` in question.

### `mouse_exited()`

Emitted when the mouse pointer exits all this object's shapes. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject2D` won't cause this signal to be emitted.
				**Note:** Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the `CollisionObject2D`'s area is small. This signal may also not be emitted if another `CollisionObject2D` is overlapping the `CollisionObject2D` in question.

### `mouse_shape_entered(shape_idx: int)`

Emitted when the mouse pointer enters any of this object's shapes or moves from one shape to another. `shape_idx` is the child index of the newly entered `Shape2D`. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set.

### `mouse_shape_exited(shape_idx: int)`

Emitted when the mouse pointer exits any of this object's shapes. `shape_idx` is the child index of the exited `Shape2D`. Requires `input_pickable` to be `true` and at least one `collision_layer` bit to be set.

## 枚举

### `DisableMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISABLE_MODE_REMOVE` |  |
| `1` | `DISABLE_MODE_MAKE_STATIC` |  |
| `2` | `DISABLE_MODE_KEEP_ACTIVE` |  |

