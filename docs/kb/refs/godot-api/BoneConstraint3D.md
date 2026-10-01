# BoneConstraint3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoneConstraint3D` → `SkeletonModifier3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoneConstraint3D.md`

**摘要**：A node that may modify Skeleton3D's bone with associating the two bones.

## 描述

Base class of `SkeletonModifier3D` that modifies the bone set in `set_apply_bone` based on the transform of the bone retrieved by `get_reference_bone`.
		**Note:** Most methods in this class take an `index` parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. `settings/<index>/amount`).

## 方法

### `clear_setting() -> void`

Clear all settings.

### `get_amount(index: int) -> float`
- 限定：qualifiers=const

Returns the apply amount of the setting at `index`.

### `get_apply_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the apply bone of the setting at `index`. This bone will be modified.

### `get_apply_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the apply bone name of the setting at `index`. This bone will be modified.

### `get_reference_bone(index: int) -> int`
- 限定：qualifiers=const

Returns the reference bone of the setting at `index`.
				This bone will be only referenced and not modified by this modifier.

### `get_reference_bone_name(index: int) -> String`
- 限定：qualifiers=const

Returns the reference bone name of the setting at `index`.
				This bone will be only referenced and not modified by this modifier.

### `get_reference_node(index: int) -> NodePath`
- 限定：qualifiers=const

Returns the reference node path of the setting at `index`.
				This node will be only referenced and not modified by this modifier.

### `get_reference_type(index: int) -> int`
- 限定：qualifiers=const

Returns the reference target type of the setting at `index`. See also `ReferenceType`.

### `get_setting_count() -> int`
- 限定：qualifiers=const

Returns the number of settings in the modifier.

### `set_amount(index: int, amount: float) -> void`

Sets the apply amount of the setting at `index` to `amount`.

### `set_apply_bone(index: int, bone: int) -> void`

Sets the apply bone of the setting at `index` to `bone`. This bone will be modified.

### `set_apply_bone_name(index: int, bone_name: String) -> void`

Sets the apply bone of the setting at `index` to `bone_name`. This bone will be modified.

### `set_reference_bone(index: int, bone: int) -> void`

Sets the reference bone of the setting at `index` to `bone`.
				This bone will be only referenced and not modified by this modifier.

### `set_reference_bone_name(index: int, bone_name: String) -> void`

Sets the reference bone of the setting at `index` to `bone_name`.
				This bone will be only referenced and not modified by this modifier.

### `set_reference_node(index: int, node: NodePath) -> void`

Sets the reference node path of the setting at `index` to `node`.
				This node will be only referenced and not modified by this modifier.

### `set_reference_type(index: int, type: int) -> void`

Sets the reference target type of the setting at `index` to `type`. See also `ReferenceType`.

### `set_setting_count(count: int) -> void`

Sets the number of settings in the modifier.

## 枚举

### `ReferenceType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `REFERENCE_TYPE_BONE` |  |
| `1` | `REFERENCE_TYPE_NODE` |  |

