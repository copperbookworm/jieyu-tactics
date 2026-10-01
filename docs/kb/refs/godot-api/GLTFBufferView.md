# GLTFBufferView

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFBufferView` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFBufferView.md`

**摘要**：Represents a glTF buffer view.

## 描述

GLTFBufferView is a data structure representing a glTF `bufferView` that would be found in the `"bufferViews"` array. A buffer is a blob of binary data. A buffer view is a slice of a buffer that can be used to identify and extract data from the buffer.
		Most custom uses of buffers only need to use the `buffer`, `byte_length`, and `byte_offset`. The `byte_stride` and `indices` properties are for more advanced use cases such as interleaved mesh data encoded for the GPU.

## 属性

- **`buffer`** `int` = `-1`
  - 其它属性：getter=get_buffer · setter=set_buffer
- **`byte_length`** `int` = `0`
  - 其它属性：getter=get_byte_length · setter=set_byte_length
- **`byte_offset`** `int` = `0`
  - 其它属性：getter=get_byte_offset · setter=set_byte_offset
- **`byte_stride`** `int` = `-1`
  - 其它属性：getter=get_byte_stride · setter=set_byte_stride
- **`indices`** `bool` = `false`
  - 其它属性：getter=get_indices · setter=set_indices
- **`vertex_attributes`** `bool` = `false`
  - 其它属性：getter=get_vertex_attributes · setter=set_vertex_attributes

## 方法

### `from_dictionary(dictionary: Dictionary) -> GLTFBufferView`
- 限定：qualifiers=static

Creates a new GLTFBufferView instance by parsing the given `Dictionary`.

### `load_buffer_view_data(state: GLTFState) -> PackedByteArray`
- 限定：qualifiers=const

Loads the buffer view data from the buffer referenced by this buffer view in the given `GLTFState`. Interleaved data with a byte stride is not yet supported by this method. The data is returned as a `PackedByteArray`.

### `to_dictionary() -> Dictionary`
- 限定：qualifiers=const

Serializes this GLTFBufferView instance into a `Dictionary`.

## 教程链接

- [Buffers, BufferViews, and Accessors in Khronos glTF specification](None)
- [Runtime file loading and saving](None)

