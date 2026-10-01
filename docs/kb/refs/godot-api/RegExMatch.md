# RegExMatch

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RegExMatch` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RegExMatch.md`

**摘要**：Contains the results of a `RegEx` search.

## 描述

Contains the results of a single `RegEx` match returned by `RegEx.search` and `RegEx.search_all`. It can be used to find the position and range of the match and its capturing groups, and it can extract its substring for you.

## 属性

- **`names`** `Dictionary` = `{}`
  - 其它属性：getter=get_names · setter=
- **`strings`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_strings · setter=
- **`subject`** `String` = `""`
  - 其它属性：getter=get_subject · setter=

## 方法

### `get_end(name: Variant = 0) -> int`
- 限定：qualifiers=const

Returns the end position of the match within the source string. The end position of capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.
				Returns -1 if the group did not match or doesn't exist.

### `get_group_count() -> int`
- 限定：qualifiers=const

Returns the number of capturing groups.

### `get_start(name: Variant = 0) -> int`
- 限定：qualifiers=const

Returns the starting position of the match within the source string. The starting position of capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.
				Returns -1 if the group did not match or doesn't exist.

### `get_string(name: Variant = 0) -> String`
- 限定：qualifiers=const

Returns the substring of the match from the source string. Capturing groups can be retrieved by providing its group number as an integer or its string name (if it's a named group). The default value of 0 refers to the whole pattern.
				Returns an empty string if the group did not match or doesn't exist.

