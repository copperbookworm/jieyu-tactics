# GLTFDocument

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFDocument` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFDocument.md`

**摘要**：Class for importing and exporting glTF files in and out of Godot.

## 描述

GLTFDocument supports reading data from a glTF file, buffer, or Godot scene. This data can then be written to the filesystem, buffer, or used to create a Godot scene.
		All of the data in a glTF scene is stored in the `GLTFState` class. GLTFDocument processes state objects, but does not contain any scene data itself. GLTFDocument has member variables to store export configuration settings such as the image format, but is otherwise stateless. Multiple scenes can be processed with the same settings using the same GLTFDocument object and different `GLTFState` objects.
		GLTFDocument can be extended with arbitrary functionality by extending the `GLTFDocumentExtension` class and registering it with GLTFDocument via `register_gltf_document_extension`. This allows for custom data to be imported and exported.

## 属性

- **`fallback_image_format`** `String` = `"None"`
  - 其它属性：getter=get_fallback_image_format · setter=set_fallback_image_format
- **`fallback_image_quality`** `float` = `0.25`
  - 其它属性：getter=get_fallback_image_quality · setter=set_fallback_image_quality
- **`image_format`** `String` = `"PNG"`
  - 其它属性：getter=get_image_format · setter=set_image_format
- **`lossy_quality`** `float` = `0.75`
  - 其它属性：getter=get_lossy_quality · setter=set_lossy_quality
- **`root_node_mode`** `int` = `0` · 枚举 `GLTFDocument.RootNodeMode`
  - 其它属性：getter=get_root_node_mode · setter=set_root_node_mode
- **`texture_map_mode`** `int` = `1` · 枚举 `GLTFDocument.TextureMapMode`
  - 其它属性：getter=get_texture_map_mode · setter=set_texture_map_mode
- **`visibility_mode`** `int` = `0` · 枚举 `GLTFDocument.VisibilityMode`
  - 其它属性：getter=get_visibility_mode · setter=set_visibility_mode

## 方法

### `append_from_buffer(bytes: PackedByteArray, base_path: String, state: GLTFState, flags: int = 0) -> int`

Takes a `PackedByteArray` defining a glTF and imports the data to the given `GLTFState` object through the `state` parameter.
				**Note:** The `base_path` tells `append_from_buffer` where to find dependencies and can be empty.

### `append_from_file(path: String, state: GLTFState, flags: int = 0, base_path: String = "") -> int`

Takes a path to a glTF file and imports the data at that file path to the given `GLTFState` object through the `state` parameter.
				**Note:** The `base_path` tells `append_from_file` where to find dependencies and can be empty.

### `append_from_scene(node: Node, state: GLTFState, flags: int = 0) -> int`

Takes a Godot Engine scene node and exports it and its descendants to the given `GLTFState` object through the `state` parameter.

### `export_object_model_property(state: GLTFState, node_path: NodePath, godot_node: Node, gltf_node_index: int) -> GLTFObjectModelProperty`
- 限定：qualifiers=static

Determines a mapping between the given Godot `node_path` and the corresponding glTF Object Model JSON pointer(s) in the generated glTF file. The details of this mapping are returned in a `GLTFObjectModelProperty` object. Additional mappings can be supplied via the `GLTFDocumentExtension._import_object_model_property` callback method.

### `generate_buffer(state: GLTFState) -> PackedByteArray`

Takes a `GLTFState` object through the `state` parameter and returns a glTF `PackedByteArray`.

### `generate_scene(state: GLTFState, bake_fps: float = 30, trimming: bool = false, remove_immutable_tracks: bool = true) -> Node`

Takes a `GLTFState` object through the `state` parameter and returns a Godot Engine scene node.
				The `bake_fps` parameter overrides the bake_fps in `state`.

### `get_supported_gltf_extensions() -> PackedStringArray`
- 限定：qualifiers=static

Returns a list of all support glTF extensions, including extensions supported directly by the engine, and extensions supported by user plugins registering `GLTFDocumentExtension` classes.
				**Note:** If this method is run before a GLTFDocumentExtension is registered, its extensions won't be included in the list. Be sure to only run this method after all extensions are registered. If you run this when the engine starts, consider waiting a frame before calling this method to ensure all extensions are registered.

### `import_object_model_property(state: GLTFState, json_pointer: String) -> GLTFObjectModelProperty`
- 限定：qualifiers=static

Determines a mapping between the given glTF Object Model `json_pointer` and the corresponding Godot node path(s) in the generated Godot scene. The details of this mapping are returned in a `GLTFObjectModelProperty` object. Additional mappings can be supplied via the `GLTFDocumentExtension._export_object_model_property` callback method.

### `register_gltf_document_extension(extension: GLTFDocumentExtension, first_priority: bool = false) -> void`
- 限定：qualifiers=static

Registers the given `GLTFDocumentExtension` instance with GLTFDocument. If `first_priority` is `true`, this extension will be run first. Otherwise, it will be run last.
				**Note:** Like GLTFDocument itself, all GLTFDocumentExtension classes must be stateless in order to function properly. If you need to store data, use the `set_additional_data` and `get_additional_data` methods in `GLTFState` or `GLTFNode`.

### `unregister_gltf_document_extension(extension: GLTFDocumentExtension) -> void`
- 限定：qualifiers=static

Unregisters the given `GLTFDocumentExtension` instance.

### `write_to_filesystem(state: GLTFState, path: String) -> int`

Takes a `GLTFState` object through the `state` parameter and writes a glTF file to the filesystem.
				**Note:** The extension of the glTF file determines if it is a .glb binary file or a .gltf text file.

## 枚举

### `RootNodeMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ROOT_NODE_MODE_SINGLE_ROOT` |  |
| `1` | `ROOT_NODE_MODE_KEEP_ROOT` |  |
| `2` | `ROOT_NODE_MODE_MULTI_ROOT` |  |

### `TextureMapMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_MAP_MODE_DO_NOT_REMAP` |  |
| `1` | `TEXTURE_MAP_MODE_REMAP_TO_STANDARD_MATERIAL` |  |

### `VisibilityMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VISIBILITY_MODE_INCLUDE_REQUIRED` |  |
| `1` | `VISIBILITY_MODE_INCLUDE_OPTIONAL` |  |
| `2` | `VISIBILITY_MODE_EXCLUDE` |  |

### `ImportFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `8` | `IMPORT_FLAG_GENERATE_TANGENT_ARRAYS` | （位标志） |
| `16` | `IMPORT_FLAG_USE_NAMED_SKIN_BINDS` | （位标志） |
| `32` | `IMPORT_FLAG_DISCARD_MESHES_AND_MATERIALS` | （位标志） |
| `64` | `IMPORT_FLAG_FORCE_DISABLE_MESH_COMPRESSION` | （位标志） |

## 教程链接

- [Runtime file loading and saving](None)
- [glTF 'What the duck?' guide](None)
- [Khronos glTF specification](None)

