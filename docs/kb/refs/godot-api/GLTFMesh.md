# GLTFMesh

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFMesh` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFMesh.md`

**摘要**：GLTFMesh represents a glTF mesh.

## 描述

GLTFMesh handles 3D mesh data imported from glTF files. It includes properties for blend channels, blend weights, instance materials, and the mesh itself.

## 属性

- **`blend_weights`** `PackedFloat32Array` = `PackedFloat32Array()`
  - 其它属性：getter=get_blend_weights · setter=set_blend_weights
- **`instance_materials`** `Material[]` = `[]`
  - 其它属性：getter=get_instance_materials · setter=set_instance_materials
- **`mesh`** `ImporterMesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`original_name`** `String` = `""`
  - 其它属性：getter=get_original_name · setter=set_original_name

## 方法

### `get_additional_data(extension_name: StringName) -> Variant`

Gets additional arbitrary data in this `GLTFMesh` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is `null`.

### `set_additional_data(extension_name: StringName, additional_data: Variant) -> void`

Sets additional arbitrary data in this `GLTFMesh` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The first argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.

## 教程链接

- [Runtime file loading and saving](None)

