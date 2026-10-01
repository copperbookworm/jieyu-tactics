# PackedDataContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PackedDataContainer` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core · deprecated=Use [method @GlobalScope.var_to_bytes] or [method FileAccess.store_var] instead. To enable data compression, use [method PackedByteArray.compress] or [method FileAccess.open_compressed].
> 自动生成，勿手改。文件：`refs/godot-api/PackedDataContainer.md`

**摘要**：Efficiently packs and serializes `Array` or `Dictionary`.

## 描述

`PackedDataContainer` can be used to efficiently store data from untyped containers. The data is packed into raw bytes and can be saved to file. Only `Array` and `Dictionary` can be stored this way.
		You can retrieve the data by iterating on the container, which will work as if iterating on the packed data itself. If the packed container is a `Dictionary`, the data can be retrieved by key names (`String`/`StringName` only).
		
```gdscript
		var data = { "key": "value", "another_key": 123, "lock": Vector2() }
		var packed = PackedDataContainer.new()
		packed.pack(data)
		ResourceSaver.save(packed, "packed_data.res")
		
```

		
```gdscript
		var container = load("packed_data.res")
		for key in container:
			prints(key, container`key`)
		
```

		Prints:
		`lang=text`
		key value
		lock (0, 0)
		another_key 123
		
		Nested containers will be packed recursively. While iterating, they will be returned as `PackedDataContainerRef`.

## 方法

### `pack(value: Variant) -> int`

Packs the given container into a binary representation. The `value` must be either `Array` or `Dictionary`, any other type will result in invalid data error.
				**Note:** Subsequent calls to this method will overwrite the existing data.
- `<returns_error number=0>`
- `<returns_error number=30>`

### `size() -> int`
- 限定：qualifiers=const

Returns the size of the packed container (see `Array.size` and `Dictionary.size`).

