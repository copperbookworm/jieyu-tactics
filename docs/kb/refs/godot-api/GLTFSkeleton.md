# GLTFSkeleton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFSkeleton` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFSkeleton.md`

## 属性

- **`joints`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_joints · setter=set_joints
- **`roots`** `PackedInt32Array` = `PackedInt32Array()`
  - 其它属性：getter=get_roots · setter=set_roots

## 方法

### `get_bone_attachment(idx: int) -> BoneAttachment3D`

### `get_bone_attachment_count() -> int`

### `get_godot_bone_node() -> Dictionary`

Returns a `Dictionary` that maps skeleton bone indices to the indices of glTF nodes. This property is unused during import, and only set during export. In a glTF file, a bone is a node, so Godot converts skeleton bones to glTF nodes.

### `get_godot_skeleton() -> Skeleton3D`

### `get_unique_names() -> String[]`

### `set_godot_bone_node(godot_bone_node: Dictionary) -> void`

Sets a `Dictionary` that maps skeleton bone indices to the indices of glTF nodes. This property is unused during import, and only set during export. In a glTF file, a bone is a node, so Godot converts skeleton bones to glTF nodes.

### `set_unique_names(unique_names: String[]) -> void`

## 教程链接

- [Runtime file loading and saving](None)

