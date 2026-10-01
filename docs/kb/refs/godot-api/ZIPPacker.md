# ZIPPacker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ZIPPacker` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ZIPPacker.md`

**摘要**：Allows the creation of ZIP files.

## 描述

This class implements a writer that allows storing the multiple blobs in a ZIP archive. See also `ZIPReader` and `PCKPacker`.
		
```gdscript
		# Create a ZIP archive with a single file at its root.
		func write_zip_file():
			var writer = ZIPPacker.new()
			var err = writer.open("user://archive.zip")
			if err != OK:
				return err
			writer.start_file("hello.txt")
			writer.write_file("Hello World".to_utf8_buffer())
			writer.close_file()

			writer.close()
			return OK
		
```

## 属性

- **`compression_level`** `int` = `-1`
  - 其它属性：getter=get_compression_level · setter=set_compression_level

## 方法

### `add_directory(path: String, permissions: int = 493, modified_time: int = 0) -> int`

Adds directory to the archive. If `modified_time` is set to `0`, current system time is used.
				**Note:** Directories are automatically created when `start_file` is called, use this function before adding files to create directories with custom permissions and modification time.

### `close() -> int`

Closes the underlying resources used by this instance.

### `close_file() -> int`

Stops writing to a file within the archive.
				It will fail if there is no open file.

### `open(path: String, append: int = 0) -> int`

Opens a zip file for writing at the given path using the specified write mode.
				This must be called before everything else.

### `start_file(path: String, permissions: int = 420, modified_time: int = 0) -> int`

Starts writing to a file within the archive. Only one file can be written at the same time. If `modified_time` is set to `0`, current system time is used.
				Must be called after `open`.

### `write_file(data: PackedByteArray) -> int`

Write the given `data` to the file.
				Needs to be called after `start_file`.

## 枚举

### `ZipAppend`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `APPEND_CREATE` |  |
| `1` | `APPEND_CREATEAFTER` |  |
| `2` | `APPEND_ADDINZIP` |  |

### `CompressionLevel`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `COMPRESSION_DEFAULT` |  |
| `0` | `COMPRESSION_NONE` |  |
| `1` | `COMPRESSION_FAST` |  |
| `9` | `COMPRESSION_BEST` |  |

