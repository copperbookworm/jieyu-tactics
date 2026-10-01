# GLTFLight

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFLight` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFLight.md`

**摘要**：Represents a glTF light.

## 描述

Represents a light as defined by the `KHR_lights_punctual` glTF extension.

## 属性

- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`inner_cone_angle`** `float` = `0.0`
  - 其它属性：getter=get_inner_cone_angle · setter=set_inner_cone_angle
- **`intensity`** `float` = `1.0`
  - 其它属性：getter=get_intensity · setter=set_intensity
- **`light_type`** `String` = `""`
  - 其它属性：getter=get_light_type · setter=set_light_type
- **`outer_cone_angle`** `float` = `0.7853982`
  - 其它属性：getter=get_outer_cone_angle · setter=set_outer_cone_angle
- **`range`** `float` = `inf`
  - 其它属性：getter=get_range · setter=set_range

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFLight`
- 限定：qualifiers=static

Creates a new GLTFLight instance by parsing the given `Dictionary`.

### `from_node(light_node: Light3D) -> GLTFLight`
- 限定：qualifiers=static

Create a new GLTFLight instance from the given Godot `Light3D` node.

### `get_additional_data(extension_name: StringName) -> Variant`

### `set_additional_data(extension_name: StringName, additional_data: Variant) -> void`

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFLight instance into a `Dictionary`.

### `to_node() -> Light3D`
- 限定：qualifiers=const

Converts this GLTFLight instance into a Godot `Light3D` node.

## 教程链接

- [Runtime file loading and saving](None)
- [KHR_lights_punctual glTF extension spec](None)

