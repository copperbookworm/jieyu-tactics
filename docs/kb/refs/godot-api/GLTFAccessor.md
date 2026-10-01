# GLTFAccessor

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFAccessor` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFAccessor.md`

**摘要**：Represents a glTF accessor.

## 描述

GLTFAccessor is a data structure representing a glTF `accessor` that would be found in the `"accessors"` array. A buffer is a blob of binary data. A buffer view is a slice of a buffer. An accessor is a typed interpretation of the data in a buffer view.
		Most custom data stored in glTF does not need accessors, only buffer views (see `GLTFBufferView`). Accessors are for more advanced use cases such as interleaved mesh data encoded for the GPU.

## 属性

- **`accessor_type`** `int` = `0` · 枚举 `GLTFAccessor.GLTFAccessorType`
  - 其它属性：getter=get_accessor_type · setter=set_accessor_type
- **`buffer_view`** `int` = `-1`
  - 其它属性：getter=get_buffer_view · setter=set_buffer_view
- **`byte_offset`** `int` = `0`
  - 其它属性：getter=get_byte_offset · setter=set_byte_offset
- **`component_type`** `int` = `0` · 枚举 `GLTFAccessor.GLTFComponentType`
  - 其它属性：getter=get_component_type · setter=set_component_type
- **`count`** `int` = `0`
  - 其它属性：getter=get_count · setter=set_count
- **`max`** `PackedFloat64Array` = `PackedFloat64Array()`
  - 其它属性：getter=get_max · setter=set_max
- **`min`** `PackedFloat64Array` = `PackedFloat64Array()`
  - 其它属性：getter=get_min · setter=set_min
- **`normalized`** `bool` = `false`
  - 其它属性：getter=get_normalized · setter=set_normalized
- **`sparse_count`** `int` = `0`
  - 其它属性：getter=get_sparse_count · setter=set_sparse_count
- **`sparse_indices_buffer_view`** `int` = `0`
  - 其它属性：getter=get_sparse_indices_buffer_view · setter=set_sparse_indices_buffer_view
- **`sparse_indices_byte_offset`** `int` = `0`
  - 其它属性：getter=get_sparse_indices_byte_offset · setter=set_sparse_indices_byte_offset
- **`sparse_indices_component_type`** `int` = `0` · 枚举 `GLTFAccessor.GLTFComponentType`
  - 其它属性：getter=get_sparse_indices_component_type · setter=set_sparse_indices_component_type
- **`sparse_values_buffer_view`** `int` = `0`
  - 其它属性：getter=get_sparse_values_buffer_view · setter=set_sparse_values_buffer_view
- **`sparse_values_byte_offset`** `int` = `0`
  - 其它属性：getter=get_sparse_values_byte_offset · setter=set_sparse_values_byte_offset
- **`type`** `int`
  - 其它属性：deprecated=Use [member accessor_type] instead. · getter=get_type · setter=set_type

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFAccessor`
- 限定：qualifiers=static

Creates a new GLTFAccessor instance by parsing the given `Dictionary`.

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFAccessor instance into a `Dictionary`.

## 枚举

### `GLTFAccessorType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TYPE_SCALAR` |  |
| `1` | `TYPE_VEC2` |  |
| `2` | `TYPE_VEC3` |  |
| `3` | `TYPE_VEC4` |  |
| `4` | `TYPE_MAT2` |  |
| `5` | `TYPE_MAT3` |  |
| `6` | `TYPE_MAT4` |  |

### `GLTFComponentType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPONENT_TYPE_NONE` |  |
| `5120` | `COMPONENT_TYPE_SIGNED_BYTE` |  |
| `5121` | `COMPONENT_TYPE_UNSIGNED_BYTE` |  |
| `5122` | `COMPONENT_TYPE_SIGNED_SHORT` |  |
| `5123` | `COMPONENT_TYPE_UNSIGNED_SHORT` |  |
| `5124` | `COMPONENT_TYPE_SIGNED_INT` |  |
| `5125` | `COMPONENT_TYPE_UNSIGNED_INT` |  |
| `5126` | `COMPONENT_TYPE_SINGLE_FLOAT` |  |
| `5130` | `COMPONENT_TYPE_DOUBLE_FLOAT` |  |
| `5131` | `COMPONENT_TYPE_HALF_FLOAT` |  |
| `5134` | `COMPONENT_TYPE_SIGNED_LONG` |  |
| `5135` | `COMPONENT_TYPE_UNSIGNED_LONG` |  |

## 教程链接

- [Buffers, BufferViews, and Accessors in Khronos glTF specification](None)
- [Runtime file loading and saving](None)

