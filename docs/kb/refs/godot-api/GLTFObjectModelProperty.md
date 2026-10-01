# GLTFObjectModelProperty

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFObjectModelProperty` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFObjectModelProperty.md`

**摘要**：Describes how to access a property as defined in the glTF object model.

## 描述

GLTFObjectModelProperty defines a mapping between a property in the glTF object model and a NodePath in the Godot scene tree. This can be used to animate properties in a glTF file using the `KHR_animation_pointer` extension, or to access them through an engine-agnostic script such as a behavior graph as defined by the `KHR_interactivity` extension.
		The glTF property is identified by JSON pointer(s) stored in `json_pointers`, while the Godot property it maps to is defined by `node_paths`. In most cases `json_pointers` and `node_paths` will each only have one item, but in some cases a single glTF JSON pointer will map to multiple Godot properties, or a single Godot property will be mapped to multiple glTF JSON pointers, or it might be a many-to-many relationship.
		`Expression` objects can be used to define conversions between the data, such as when glTF defines an angle in radians and Godot uses degrees. The `object_model_type` property defines the type of data stored in the glTF file as defined by the object model, see `GLTFObjectModelType` for possible values.

## 属性

- **`gltf_to_godot_expression`** `Expression`
  - 其它属性：getter=get_gltf_to_godot_expression · setter=set_gltf_to_godot_expression
- **`godot_to_gltf_expression`** `Expression`
  - 其它属性：getter=get_godot_to_gltf_expression · setter=set_godot_to_gltf_expression
- **`json_pointers`** `PackedStringArray[]` = `[]`
  - 其它属性：getter=get_json_pointers · setter=set_json_pointers
- **`node_paths`** `NodePath[]` = `[]`
  - 其它属性：getter=get_node_paths · setter=set_node_paths
- **`object_model_type`** `int` = `0` · 枚举 `GLTFObjectModelProperty.GLTFObjectModelType`
  - 其它属性：getter=get_object_model_type · setter=set_object_model_type
- **`variant_type`** `int` = `0` · 枚举 `Variant.Type`
  - 其它属性：getter=get_variant_type · setter=set_variant_type

## 方法

### `append_node_path(node_path: NodePath) -> void`

Appends a `NodePath` to `node_paths`. This can be used by `GLTFDocumentExtension` classes to define how a glTF object model property maps to a Godot property, or multiple Godot properties. Prefer using `append_path_to_property` for simple cases. Be sure to also call `set_types` once (the order does not matter).

### `append_path_to_property(node_path: NodePath, prop_name: StringName) -> void`

High-level wrapper over `append_node_path` that handles the most common cases. It constructs a new `NodePath` using `node_path` as a base and appends `prop_name` to the subpath. Be sure to also call `set_types` once (the order does not matter).

### `get_accessor_type() -> int`
- 限定：qualifiers=const

The GLTF accessor type associated with this property's `object_model_type`. See `GLTFAccessor.accessor_type` for possible values, and see `GLTFObjectModelType` for how the object model type maps to accessor types.

### `has_json_pointers() -> bool`
- 限定：qualifiers=const

Returns `true` if `json_pointers` is not empty. This is used during export to determine if a `GLTFObjectModelProperty` can handle converting a Godot property to a glTF object model property.

### `has_node_paths() -> bool`
- 限定：qualifiers=const

Returns `true` if `node_paths` is not empty. This is used during import to determine if a `GLTFObjectModelProperty` can handle converting a glTF object model property to a Godot property.

### `set_types(variant_type: int, obj_model_type: int) -> void`

Sets the `variant_type` and `object_model_type` properties. This is a convenience method to set both properties at once, since they are almost always known at the same time. This method should be called once. Calling it again with the same values will have no effect.

## 枚举

### `GLTFObjectModelType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `GLTF_OBJECT_MODEL_TYPE_UNKNOWN` |  |
| `1` | `GLTF_OBJECT_MODEL_TYPE_BOOL` |  |
| `2` | `GLTF_OBJECT_MODEL_TYPE_FLOAT` |  |
| `3` | `GLTF_OBJECT_MODEL_TYPE_FLOAT_ARRAY` |  |
| `4` | `GLTF_OBJECT_MODEL_TYPE_FLOAT2` |  |
| `5` | `GLTF_OBJECT_MODEL_TYPE_FLOAT3` |  |
| `6` | `GLTF_OBJECT_MODEL_TYPE_FLOAT4` |  |
| `7` | `GLTF_OBJECT_MODEL_TYPE_FLOAT2X2` |  |
| `8` | `GLTF_OBJECT_MODEL_TYPE_FLOAT3X3` |  |
| `9` | `GLTF_OBJECT_MODEL_TYPE_FLOAT4X4` |  |
| `10` | `GLTF_OBJECT_MODEL_TYPE_INT` |  |

## 教程链接

- [GLTF Object Model](None)
- [KHR_animation_pointer GLTF extension](None)

