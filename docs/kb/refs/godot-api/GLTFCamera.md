# GLTFCamera

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFCamera` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFCamera.md`

**摘要**：Represents a glTF camera.

## 描述

Represents a camera as defined by the base glTF spec.

## 属性

- **`depth_far`** `float` = `4000.0`
  - 其它属性：getter=get_depth_far · setter=set_depth_far
- **`depth_near`** `float` = `0.05`
  - 其它属性：getter=get_depth_near · setter=set_depth_near
- **`fov`** `float` = `1.3089969`
  - 其它属性：getter=get_fov · setter=set_fov
- **`perspective`** `bool` = `true`
  - 其它属性：getter=get_perspective · setter=set_perspective
- **`size_mag`** `float` = `0.5`
  - 其它属性：getter=get_size_mag · setter=set_size_mag

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFCamera`
- 限定：qualifiers=static

Creates a new GLTFCamera instance by parsing the given `Dictionary`.

### `from_node(camera_node: Camera3D) -> GLTFCamera`
- 限定：qualifiers=static

Create a new GLTFCamera instance from the given Godot `Camera3D` node.

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFCamera instance into a `Dictionary`.

### `to_node() -> Camera3D`
- 限定：qualifiers=const

Converts this GLTFCamera instance into a Godot `Camera3D` node.

## 教程链接

- [Runtime file loading and saving](None)
- [glTF camera detailed specification](None)
- [glTF camera spec and example file](None)

