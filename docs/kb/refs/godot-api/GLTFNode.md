# GLTFNode

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFNode.md`

**摘要**：glTF node class.

## 描述

Represents a glTF node. glTF nodes may have names, transforms, children (other glTF nodes), and more specialized properties (represented by their own classes).
		glTF nodes generally exist inside of `GLTFState` which represents all data of a glTF file. Most of GLTFNode's properties are indices of other data in the glTF file. You can extend a glTF node with additional properties by using `get_additional_data` and `set_additional_data`.

## 属性

- **`camera`** `int` = `-1`
  - 其它属性：getter=get_camera · setter=set_camera
- **`children`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_children · setter=set_children
- **`height`** `int` = `-1`
  - 其它属性：getter=get_height · setter=set_height
- **`light`** `int` = `-1`
  - 其它属性：getter=get_light · setter=set_light
- **`mesh`** `int` = `-1`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`original_name`** `String` = `""`
  - 其它属性：getter=get_original_name · setter=set_original_name
- **`parent`** `int` = `-1`
  - 其它属性：getter=get_parent · setter=set_parent
- **`position`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_position · setter=set_position
- **`rotation`** `Quaternion` = `Quaternion(0, 0, 0, 1)`
  - 其它属性：getter=get_rotation · setter=set_rotation
- **`scale`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_scale · setter=set_scale
- **`skeleton`** `int` = `-1`
  - 其它属性：getter=get_skeleton · setter=set_skeleton
- **`skin`** `int` = `-1`
  - 其它属性：getter=get_skin · setter=set_skin
- **`visible`** `bool` = `true`
  - 其它属性：getter=get_visible · setter=set_visible
- **`xform`** `Transform3D` = `Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)`
  - 其它属性：getter=get_xform · setter=set_xform

## 方法

### `append_child_index(child_index: int) -> void`

Appends the given child node index to the `children` array.

### `get_additional_data(extension_name: StringName) -> Variant`

Gets additional arbitrary data in this `GLTFNode` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is `null`.

### `get_scene_node_path(gltf_state: GLTFState, handle_skeletons: bool = true) -> NodePath`

Returns the `NodePath` that this GLTF node will have in the Godot scene tree after being imported. This is useful when importing glTF object model pointers with `GLTFObjectModelProperty`, for handling extensions such as `KHR_animation_pointer` or `KHR_interactivity`.
				If `handle_skeletons` is `true`, paths to skeleton bone glTF nodes will be resolved properly. For example, a path that would be `^"A/B/C/Bone1/Bone2/Bone3"` if `false` will become `^"A/B/C/Skeleton3D:Bone3"`.

### `set_additional_data(extension_name: StringName, additional_data: Variant) -> void`

Sets additional arbitrary data in this `GLTFNode` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The first argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.

## 教程链接

- [Runtime file loading and saving](None)
- [glTF scene and node spec](None)

