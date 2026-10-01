# GLTFPhysicsBody

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFPhysicsBody` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFPhysicsBody.md`

**摘要**：Represents a glTF physics body.

## 描述

Represents a physics body as an intermediary between the `OMI_physics_body` glTF data and Godot's nodes, and it's abstracted in a way that allows adding support for different glTF physics extensions in the future.

## 属性

- **`angular_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_angular_velocity · setter=set_angular_velocity
- **`body_type`** `String` = `"rigid"`
  - 其它属性：getter=get_body_type · setter=set_body_type
- **`center_of_mass`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_center_of_mass · setter=set_center_of_mass
- **`inertia_diagonal`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_inertia_diagonal · setter=set_inertia_diagonal
- **`inertia_orientation`** `Quaternion` = `Quaternion(0, 0, 0, 1)`
  - 其它属性：getter=get_inertia_orientation · setter=set_inertia_orientation
- **`inertia_tensor`** `Basis` = `Basis(0, 0, 0, 0, 0, 0, 0, 0, 0)`
  - 其它属性：deprecated= · getter=get_inertia_tensor · setter=set_inertia_tensor
- **`linear_velocity`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_linear_velocity · setter=set_linear_velocity
- **`mass`** `float` = `1.0`
  - 其它属性：getter=get_mass · setter=set_mass

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFPhysicsBody`
- 限定：qualifiers=static

Creates a new GLTFPhysicsBody instance by parsing the given `Dictionary` in the `OMI_physics_body` glTF extension format.

### `from_node(body_node: CollisionObject3D) -> GLTFPhysicsBody`
- 限定：qualifiers=static

Creates a new GLTFPhysicsBody instance from the given Godot `CollisionObject3D` node.

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFPhysicsBody instance into a `Dictionary`. It will be in the format expected by the `OMI_physics_body` glTF extension.

### `to_node() -> CollisionObject3D`
- 限定：qualifiers=const

Converts this GLTFPhysicsBody instance into a Godot `CollisionObject3D` node.

## 教程链接

- [Runtime file loading and saving](None)
- [OMI_physics_body glTF extension](None)

