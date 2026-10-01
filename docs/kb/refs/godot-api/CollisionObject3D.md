# CollisionObject3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CollisionObject3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CollisionObject3D.md`

**摘要**：Abstract base class for 3D physics objects.

## 描述

Abstract base class for 3D physics objects. `CollisionObject3D` can hold any number of `Shape3D`s for collision. Each shape must be assigned to a *shape owner*. Shape owners are not nodes and do not appear in the editor, but are accessible through code using the `shape_owner_*` methods.
		**Warning:** With a non-uniform scale, this node will likely not behave as expected. It is advised to keep its scale the same on all axes and adjust its collision shape(s) instead.

## 属性

- **`collision_layer`** `int` = `1`
  - 其它属性：getter=get_collision_layer · setter=set_collision_layer
- **`collision_mask`** `int` = `1`
  - 其它属性：getter=get_collision_mask · setter=set_collision_mask
- **`collision_priority`** `float` = `1.0`
  - 其它属性：getter=get_collision_priority · setter=set_collision_priority
- **`disable_mode`** `int` = `0` · 枚举 `CollisionObject3D.DisableMode`
  - 其它属性：getter=get_disable_mode · setter=set_disable_mode
- **`input_capture_on_drag`** `bool` = `false`
  - 其它属性：getter=get_capture_input_on_drag · setter=set_capture_input_on_drag
- **`input_ray_pickable`** `bool` = `true`
  - 其它属性：getter=is_ray_pickable · setter=set_ray_pickable

## 方法

### `_input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void`
- 限定：qualifiers=virtual

Receives unhandled `InputEvent`s. `event_position` is the location in world space of the mouse pointer on the surface of the shape with index `shape_idx` and `normal` is the normal vector of the surface at that point. Connect to the `input_event` signal to easily pick up these events.
				**Note:** `_input_event` requires `input_ray_pickable` to be `true` and at least one `collision_layer` bit to be set.

### `_mouse_enter() -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer enters any of this object's shapes. Requires `input_ray_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject3D` won't cause this function to be called.

### `_mouse_exit() -> void`
- 限定：qualifiers=virtual

Called when the mouse pointer exits all this object's shapes. Requires `input_ray_pickable` to be `true` and at least one `collision_layer` bit to be set. Note that moving between different shapes within a single `CollisionObject3D` won't cause this function to be called.

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

### `get_shape_owners() -> PackedInt32Array`

Returns an `Array` of `owner_id` identifiers. You can use these ids in other methods that take `owner_id` as an argument.

### `is_shape_owner_disabled(owner_id: int) -> bool`
- 限定：qualifiers=const

If `true`, the shape owner and its shapes are disabled.

### `remove_shape_owner(owner_id: int) -> void`

Removes the given shape owner.

### `set_collision_layer_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_layer`, given a `layer_number` between 1 and 32.

### `set_collision_mask_value(layer_number: int, value: bool) -> void`

Based on `value`, enables or disables the specified layer in the `collision_mask`, given a `layer_number` between 1 and 32.

### `shape_find_owner(shape_index: int) -> int`
- 限定：qualifiers=const

Returns the `owner_id` of the given shape.

### `shape_owner_add_shape(owner_id: int, shape: Shape3D) -> void`

Adds a `Shape3D` to the shape owner.

### `shape_owner_clear_shapes(owner_id: int) -> void`

Removes all shapes from the shape owner.

### `shape_owner_get_owner(owner_id: int) -> Object`
- 限定：qualifiers=const

Returns the parent object of the given shape owner.

### `shape_owner_get_shape(owner_id: int, shape_id: int) -> Shape3D`
- 限定：qualifiers=const

Returns the `Shape3D` with the given ID from the given shape owner.

### `shape_owner_get_shape_count(owner_id: int) -> int`
- 限定：qualifiers=const

Returns the number of shapes the given shape owner contains.

### `shape_owner_get_shape_index(owner_id: int, shape_id: int) -> int`
- 限定：qualifiers=const

Returns the child index of the `Shape3D` with the given ID from the given shape owner.

### `shape_owner_get_transform(owner_id: int) -> Transform3D`
- 限定：qualifiers=const

Returns the shape owner's `Transform3D`.

### `shape_owner_remove_shape(owner_id: int, shape_id: int) -> void`

Removes a shape from the given shape owner.

### `shape_owner_set_disabled(owner_id: int, disabled: bool) -> void`

If `true`, disables the given shape owner.

### `shape_owner_set_transform(owner_id: int, transform: Transform3D) -> void`

Sets the `Transform3D` of the given shape owner.

## 信号

### `input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int)`

Emitted when the object receives an unhandled `InputEvent`. `event_position` is the location in world space of the mouse pointer on the surface of the shape with index `shape_idx` and `normal` is the normal vector of the surface at that point.

### `mouse_entered()`

Emitted when the mouse pointer enters any of this object's shapes. Requires `input_ray_pickable` to be `true` and at least one `collision_layer` bit to be set.
				**Note:** Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the `CollisionObject3D`'s area is small. This signal may also not be emitted if another `CollisionObject3D` is overlapping the `CollisionObject3D` in question.

### `mouse_exited()`

Emitted when the mouse pointer exits all this object's shapes. Requires `input_ray_pickable` to be `true` and at least one `collision_layer` bit to be set.
				**Note:** Due to the lack of continuous collision detection, this signal may not be emitted in the expected order if the mouse moves fast enough and the `CollisionObject3D`'s area is small. This signal may also not be emitted if another `CollisionObject3D` is overlapping the `CollisionObject3D` in question.

## 枚举

### `DisableMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISABLE_MODE_REMOVE` |  |
| `1` | `DISABLE_MODE_MAKE_STATIC` |  |
| `2` | `DISABLE_MODE_KEEP_ACTIVE` |  |

