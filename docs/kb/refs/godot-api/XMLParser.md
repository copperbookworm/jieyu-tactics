# XMLParser

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XMLParser` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XMLParser.md`

**摘要**：Provides a low-level interface for creating parsers for XML files.

## 描述

Provides a low-level interface for creating parsers for XML (https://en.wikipedia.org/wiki/XML) files. This class can serve as base to make custom XML parsers.
		To parse XML, you must open a file with the `open` method or a buffer with the `open_buffer` method. Then, the `read` method must be called to parse the next nodes. Most of the methods take into consideration the currently parsed node.
		Here is an example of using `XMLParser` to parse an SVG file (which is based on XML), printing each element and its attributes as a dictionary:
		`codeblocks`
		`gdscript`
		var parser = XMLParser.new()
		parser.open("path/to/file.svg")
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				var node_name = parser.get_node_name()
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				print("The ", node_name, " element has the following attributes: ", attributes_dict)
		
		`csharp`
		var parser = new XmlParser();
		parser.Open("path/to/file.svg");
		while (parser.Read() != Error.FileEof)
		{
			if (parser.GetNodeType() == XmlParser.NodeType.Element)
			{
				var nodeName = parser.GetNodeName();
				var attributesDict = new Godot.Collections.Dictionary();
				for (int idx = 0; idx < parser.GetAttributeCount(); idx++)
				{
					attributesDict[parser.GetAttributeName(idx)] = parser.GetAttributeValue(idx);
				}
				GD.Print($"The {nodeName} element has the following attributes: {attributesDict}");
			}
		}

## 方法

### `get_attribute_count() -> int`
- 限定：qualifiers=const

Returns the number of attributes in the currently parsed element.
				**Note:** If this method is used while the currently parsed node is not `NODE_ELEMENT` or `NODE_ELEMENT_END`, this count will not be updated and will still reflect the last element.

### `get_attribute_name(idx: int) -> String`
- 限定：qualifiers=const

Returns the name of an attribute of the currently parsed element, specified by the `idx` index.

### `get_attribute_value(idx: int) -> String`
- 限定：qualifiers=const

Returns the value of an attribute of the currently parsed element, specified by the `idx` index.

### `get_current_line() -> int`
- 限定：qualifiers=const

Returns the current line in the parsed file, counting from 0.

### `get_named_attribute_value(name: String) -> String`
- 限定：qualifiers=const

Returns the value of an attribute of the currently parsed element, specified by its `name`. This method will raise an error if the element has no such attribute.

### `get_named_attribute_value_safe(name: String) -> String`
- 限定：qualifiers=const

Returns the value of an attribute of the currently parsed element, specified by its `name`. This method will return an empty string if the element has no such attribute.

### `get_node_data() -> String`
- 限定：qualifiers=const

Returns the contents of a text node. This method will raise an error if the current parsed node is of any other type.

### `get_node_name() -> String`
- 限定：qualifiers=const

Returns the name of a node. This method will raise an error if the currently parsed node is a text node.
				**Note:** The content of a `NODE_CDATA` node and the comment string of a `NODE_COMMENT` node are also considered names.

### `get_node_offset() -> int`
- 限定：qualifiers=const

Returns the byte offset of the currently parsed node since the beginning of the file or buffer. This is usually equivalent to the number of characters before the read position.

### `get_node_type() -> int`

Returns the type of the current node. Compare with `NodeType` constants.

### `has_attribute(name: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the currently parsed element has an attribute with the `name`.

### `is_empty() -> bool`
- 限定：qualifiers=const

Returns `true` if the currently parsed element is empty, e.g. `<element />`.

### `open(file: String) -> int`

Opens an XML `file` for parsing. This method returns an error code.

### `open_buffer(buffer: PackedByteArray) -> int`

Opens an XML raw `buffer` for parsing. This method returns an error code.

### `read() -> int`

Parses the next node in the file. This method returns an error code.

### `seek(position: int) -> int`

Moves the buffer cursor to a certain offset (since the beginning) and reads the next node there. This method returns an error code.

### `skip_section() -> void`

Skips the current section. If the currently parsed node contains more inner nodes, they will be ignored and the cursor will go to the closing of the current element.

## 枚举

### `NodeType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `NODE_NONE` |  |
| `1` | `NODE_ELEMENT` |  |
| `2` | `NODE_ELEMENT_END` |  |
| `3` | `NODE_TEXT` |  |
| `4` | `NODE_COMMENT` |  |
| `5` | `NODE_CDATA` |  |
| `6` | `NODE_UNKNOWN` |  |

