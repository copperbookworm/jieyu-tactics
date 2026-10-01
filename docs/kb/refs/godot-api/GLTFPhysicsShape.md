# GLTFPhysicsShape

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFPhysicsShape` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFPhysicsShape.md`

**摘要**：Represents a glTF physics shape.

## 描述

Represents a physics shape as defined by the `OMI_physics_shape` or `OMI_collider` glTF extensions. This class is an intermediary between the glTF data and Godot's nodes, and it's abstracted in a way that allows adding support for different glTF physics extensions in the future.

## 属性

- **`height`** `float` = `2.0`
  - 其它属性：getter=get_height · setter=set_height
- **`importer_mesh`** `ImporterMesh`
  - 其它属性：getter=get_importer_mesh · setter=set_importer_mesh
- **`is_trigger`** `bool` = `false`
  - 其它属性：getter=get_is_trigger · setter=set_is_trigger
- **`mesh_index`** `int` = `-1`
  - 其它属性：getter=get_mesh_index · setter=set_mesh_index
- **`radius`** `float` = `0.5`
  - 其它属性：getter=get_radius · setter=set_radius
- **`shape_type`** `String` = `""`
  - 其它属性：getter=get_shape_type · setter=set_shape_type
- **`size`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_size · setter=set_size

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFPhysicsShape`
- 限定：qualifiers=static

Creates a new GLTFPhysicsShape instance by parsing the given `Dictionary`.

### `from_node(shape_node: CollisionShape3D) -> GLTFPhysicsShape`
- 限定：qualifiers=static

Creates a new GLTFPhysicsShape instance from the given Godot `CollisionShape3D` node.

### `from_resource(shape_resource: Shape3D) -> GLTFPhysicsShape`
- 限定：qualifiers=static

Creates a new GLTFPhysicsShape instance from the given Godot `Shape3D` resource.

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFPhysicsShape instance into a `Dictionary` in the format defined by `OMI_physics_shape`.

### `to_node(cache_shapes: bool = false) -> CollisionShape3D`

Converts this GLTFPhysicsShape instance into a Godot `CollisionShape3D` node.

### `to_resource(cache_shapes: bool = false) -> Shape3D`

Converts this GLTFPhysicsShape instance into a Godot `Shape3D` resource.

## 教程链接

- [Runtime file loading and saving](None)
- [OMI_physics_shape glTF extension](None)
- [OMI_collider glTF extension](None)

