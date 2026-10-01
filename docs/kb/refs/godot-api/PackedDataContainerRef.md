# PackedDataContainerRef

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PackedDataContainerRef` → `RefCounted` → `Object`
> 附加属性：api_type=core · deprecated=Use [method @GlobalScope.var_to_bytes] or [method FileAccess.store_var] instead. To enable data compression, use [method PackedByteArray.compress] or [method FileAccess.open_compressed].
> 自动生成，勿手改。文件：`refs/godot-api/PackedDataContainerRef.md`

**摘要**：An internal class used by `PackedDataContainer` to pack nested arrays and dictionaries.

## 描述

When packing nested containers using `PackedDataContainer`, they are recursively packed into `PackedDataContainerRef` (only applies to `Array` and `Dictionary`). Their data can be retrieved the same way as from `PackedDataContainer`.
		
```gdscript
		var packed = PackedDataContainer.new()
		packed.pack([1, 2, 3, ["nested1", "nested2"], 4, 5, 6])

		for element in packed:
			if element is PackedDataContainerRef:
				for subelement in element:
					print("::", subelement)
			else:
				print(element)
		
```

		Prints:
		`lang=text`
		1
		2
		3
		::nested1
		::nested2
		4
		5
		6

## 方法

### `size() -> int`
- 限定：qualifiers=const

Returns the size of the packed container (see `Array.size` and `Dictionary.size`).

