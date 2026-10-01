# GLTFState

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFState` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFState.md`

**摘要**：Represents all data of a glTF file.

## 描述

Contains all nodes and resources of a glTF file. This is used by `GLTFDocument` as data storage, which allows `GLTFDocument` and all `GLTFDocumentExtension` classes to remain stateless.
		GLTFState can be populated by `GLTFDocument` reading a file or by converting a Godot scene. Then the data can either be used to create a Godot scene or save to a glTF file. The code that converts to/from a Godot scene can be intercepted at arbitrary points by `GLTFDocumentExtension` classes. This allows for custom data to be stored in the glTF file or for custom data to be converted to/from Godot nodes.

## 属性

- **`bake_fps`** `float` = `30.0`
  - 其它属性：getter=get_bake_fps · setter=set_bake_fps
- **`base_path`** `String` = `""`
  - 其它属性：getter=get_base_path · setter=set_base_path
- **`buffers`** `PackedByteArray[]` = `[]`
  - 其它属性：getter=get_buffers · setter=set_buffers
- **`copyright`** `String` = `""`
  - 其它属性：getter=get_copyright · setter=set_copyright
- **`create_animations`** `bool` = `true`
  - 其它属性：getter=get_create_animations · setter=set_create_animations
- **`filename`** `String` = `""`
  - 其它属性：getter=get_filename · setter=set_filename
- **`glb_data`** `PackedByteArray` = `PackedByteArray()`
  - 其它属性：getter=get_glb_data · setter=set_glb_data
- **`handle_binary_image_mode`** `int` = `1` · 枚举 `GLTFState.HandleBinaryImageMode`
  - 其它属性：getter=get_handle_binary_image_mode · setter=set_handle_binary_image_mode
- **`import_as_skeleton_bones`** `bool` = `false`
  - 其它属性：getter=get_import_as_skeleton_bones · setter=set_import_as_skeleton_bones
- **`json`** `Dictionary` = `{}`
  - 其它属性：getter=get_json · setter=set_json
- **`major_version`** `int` = `0`
  - 其它属性：getter=get_major_version · setter=set_major_version
- **`minor_version`** `int` = `0`
  - 其它属性：getter=get_minor_version · setter=set_minor_version
- **`root_nodes`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_root_nodes · setter=set_root_nodes
- **`scene_name`** `String` = `""`
  - 其它属性：getter=get_scene_name · setter=set_scene_name
- **`use_named_skin_binds`** `bool` = `false`
  - 其它属性：getter=get_use_named_skin_binds · setter=set_use_named_skin_binds

## 方法

### `add_used_extension(extension_name: String, required: bool) -> void`

Appends an extension to the list of extensions used by this glTF file during serialization. If `required` is `true`, the extension will also be added to the list of required extensions. Do not run this in `GLTFDocumentExtension._export_post`, as that stage is too late to add extensions. The final list is sorted alphabetically.

### `append_data_to_buffers(data: PackedByteArray, deduplication: bool) -> int`

Appends the given byte array `data` to the buffers and creates a `GLTFBufferView` for it. The index of the destination `GLTFBufferView` is returned. If `deduplication` is `true`, the buffers are first searched for duplicate data, otherwise new bytes are always appended.

### `append_gltf_node(gltf_node: GLTFNode, godot_scene_node: Node, parent_node_index: int) -> int`

Appends the given `GLTFNode` to the state, and returns its new index. This can be used to export one Godot node as multiple glTF nodes, or inject new glTF nodes at import time. On import, this must be called before `GLTFDocumentExtension._generate_scene_node` finishes for the parent node. On export, this must be called before `GLTFDocumentExtension._export_node` runs for the parent node.
				The `godot_scene_node` parameter is the Godot scene node that corresponds to this glTF node. This is highly recommended to be set to a valid node, but may be `null` if there is no corresponding Godot scene node. One Godot scene node may be used for multiple glTF nodes, so if exporting multiple glTF nodes for one Godot scene node, use the same Godot scene node for each.
				The `parent_node_index` parameter is the index of the parent `GLTFNode` in the state. If `-1`, the node will be a root node, otherwise the new node will be added to the parent's list of children. The index will also be written to the `GLTFNode.parent` property of the new node.

### `get_accessors() -> GLTFAccessor[]`
- 限定：qualifiers=const

### `get_additional_data(extension_name: StringName) -> Variant`
- 限定：qualifiers=const

Gets additional arbitrary data in this `GLTFState` instance. This can be used to keep per-file state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is `null`.

### `get_animation_player(anim_player_index: int) -> AnimationPlayer`
- 限定：qualifiers=const

Returns the `AnimationPlayer` node with the given index. These nodes are only used during the export process when converting Godot `AnimationPlayer` nodes to glTF animations.

### `get_animation_players_count(anim_player_index: int) -> int`
- 限定：qualifiers=const

Returns the number of `AnimationPlayer` nodes in this `GLTFState`. These nodes are only used during the export process when converting Godot `AnimationPlayer` nodes to glTF animations.

### `get_animations() -> GLTFAnimation[]`
- 限定：qualifiers=const

Returns an array of all `GLTFAnimation`s in the glTF file. When importing, these will be generated as animations in an `AnimationPlayer` node. When exporting, these will be generated from Godot `AnimationPlayer` nodes.

### `get_buffer_views() -> GLTFBufferView[]`
- 限定：qualifiers=const

### `get_cameras() -> GLTFCamera[]`
- 限定：qualifiers=const

Returns an array of all `GLTFCamera`s in the glTF file. These are the cameras that the `GLTFNode.camera` index refers to.

### `get_handle_binary_image() -> int`
- 限定：deprecated=Use [member handle_binary_image_mode] instead. · qualifiers=const

Deprecated untyped alias for `handle_binary_image_mode`. When importing a glTF file with unimported raw binary images embedded inside of binary blob buffers, in data URIs, or separate files not imported by Godot, this controls how the images are handled.

### `get_images() -> Texture2D[]`
- 限定：qualifiers=const

Gets the images of the glTF file as an array of `Texture2D`s. These are the images that the `GLTFTexture.src_image` index refers to.

### `get_lights() -> GLTFLight[]`
- 限定：qualifiers=const

Returns an array of all `GLTFLight`s in the glTF file. These are the lights that the `GLTFNode.light` index refers to.

### `get_materials() -> Material[]`
- 限定：qualifiers=const

### `get_meshes() -> GLTFMesh[]`
- 限定：qualifiers=const

Returns an array of all `GLTFMesh`es in the glTF file. These are the meshes that the `GLTFNode.mesh` index refers to.

### `get_node_index(scene_node: Node) -> int`
- 限定：qualifiers=const

Returns the index of the `GLTFNode` corresponding to this Godot scene node. This is the inverse of `get_scene_node`. Useful during the export process.
				**Note:** Not every Godot scene node will have a corresponding `GLTFNode`, and not every `GLTFNode` will have a scene node generated. If there is no `GLTFNode` index for this scene node, `-1` is returned.

### `get_nodes() -> GLTFNode[]`
- 限定：qualifiers=const

Returns an array of all `GLTFNode`s in the glTF file. These are the nodes that `GLTFNode.children` and `root_nodes` refer to. This includes nodes that may not be generated in the Godot scene, or nodes that may generate multiple Godot scene nodes.

### `get_scene_node(gltf_node_index: int) -> Node`
- 限定：qualifiers=const

Returns the Godot scene node that corresponds to the same index as the `GLTFNode` it was generated from. This is the inverse of `get_node_index`. Useful during the import process.
				**Note:** Not every `GLTFNode` will have a scene node generated, and not every generated scene node will have a corresponding `GLTFNode`. If there is no scene node for this `GLTFNode` index, `null` is returned.

### `get_skeletons() -> GLTFSkeleton[]`
- 限定：qualifiers=const

Returns an array of all `GLTFSkeleton`s in the glTF file. These are the skeletons that the `GLTFNode.skeleton` index refers to.

### `get_skins() -> GLTFSkin[]`
- 限定：qualifiers=const

Returns an array of all `GLTFSkin`s in the glTF file. These are the skins that the `GLTFNode.skin` index refers to.

### `get_texture_samplers() -> GLTFTextureSampler[]`
- 限定：qualifiers=const

Retrieves the array of texture samplers that are used by the textures contained in the glTF.

### `get_textures() -> GLTFTexture[]`
- 限定：qualifiers=const

### `get_unique_animation_names() -> String[]`
- 限定：qualifiers=const

Returns an array of unique animation names. This is only used during the import process.

### `get_unique_names() -> String[]`
- 限定：qualifiers=const

Returns an array of unique node names. This is used in both the import process and export process.

### `set_accessors(accessors: GLTFAccessor[]) -> void`

### `set_additional_data(extension_name: StringName, additional_data: Variant) -> void`

Sets additional arbitrary data in this `GLTFState` instance. This can be used to keep per-file state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The first argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.

### `set_animations(animations: GLTFAnimation[]) -> void`

Sets the `GLTFAnimation`s in the state. When importing, these will be generated as animations in an `AnimationPlayer` node. When exporting, these will be generated from Godot `AnimationPlayer` nodes.

### `set_buffer_views(buffer_views: GLTFBufferView[]) -> void`

### `set_cameras(cameras: GLTFCamera[]) -> void`

Sets the `GLTFCamera`s in the state. These are the cameras that the `GLTFNode.camera` index refers to.

### `set_handle_binary_image(method: int) -> void`
- 限定：deprecated=Use [member handle_binary_image_mode] instead.

Deprecated untyped alias for `handle_binary_image_mode`. When importing a glTF file with unimported raw binary images embedded inside of binary blob buffers, in data URIs, or separate files not imported by Godot, this controls how the images are handled.

### `set_images(images: Texture2D[]) -> void`

Sets the images in the state stored as an array of `Texture2D`s. This can be used during export. These are the images that the `GLTFTexture.src_image` index refers to.

### `set_lights(lights: GLTFLight[]) -> void`

Sets the `GLTFLight`s in the state. These are the lights that the `GLTFNode.light` index refers to.

### `set_materials(materials: Material[]) -> void`

### `set_meshes(meshes: GLTFMesh[]) -> void`

Sets the `GLTFMesh`es in the state. These are the meshes that the `GLTFNode.mesh` index refers to.

### `set_nodes(nodes: GLTFNode[]) -> void`

Sets the `GLTFNode`s in the state. These are the nodes that `GLTFNode.children` and `root_nodes` refer to. Some of the nodes set here may not be generated in the Godot scene, or may generate multiple Godot scene nodes.

### `set_skeletons(skeletons: GLTFSkeleton[]) -> void`

Sets the `GLTFSkeleton`s in the state. These are the skeletons that the `GLTFNode.skeleton` index refers to.

### `set_skins(skins: GLTFSkin[]) -> void`

Sets the `GLTFSkin`s in the state. These are the skins that the `GLTFNode.skin` index refers to.

### `set_texture_samplers(texture_samplers: GLTFTextureSampler[]) -> void`

Sets the array of texture samplers that are used by the textures contained in the glTF.

### `set_textures(textures: GLTFTexture[]) -> void`

### `set_unique_animation_names(unique_animation_names: String[]) -> void`

Sets the unique animation names in the state. This is only used during the import process.

### `set_unique_names(unique_names: String[]) -> void`

Sets the unique node names in the state. This is used in both the import process and export process.

## 枚举

### `HandleBinaryImageMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `HANDLE_BINARY_IMAGE_MODE_DISCARD_TEXTURES` |  |
| `1` | `HANDLE_BINARY_IMAGE_MODE_EXTRACT_TEXTURES` |  |
| `2` | `HANDLE_BINARY_IMAGE_MODE_EMBED_AS_BASISU` |  |
| `3` | `HANDLE_BINARY_IMAGE_MODE_EMBED_AS_UNCOMPRESSED` |  |

## 常量

- **`HANDLE_BINARY_DISCARD_TEXTURES`** = `0`
- **`HANDLE_BINARY_EXTRACT_TEXTURES`** = `1`
- **`HANDLE_BINARY_EMBED_AS_BASISU`** = `2`
- **`HANDLE_BINARY_EMBED_AS_UNCOMPRESSED`** = `3`
## 教程链接

- [Runtime file loading and saving](None)
- [glTF asset header schema](None)

