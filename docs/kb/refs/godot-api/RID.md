# RID

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RID`
> 自动生成，勿手改。文件：`refs/godot-api/RID.md`

**摘要**：A handle for a `Resource`'s unique identifier.

## 描述

The RID `Variant` type is used to access a low-level resource by its unique ID. RIDs are opaque, which means they do not grant access to the resource by themselves. They are used by the low-level server classes, such as `DisplayServer`, `RenderingServer`, `TextServer`, etc.
		A low-level resource may correspond to a high-level `Resource`, such as `Texture` or `Mesh`.
		**Note:** RIDs are only useful during the current session. It won't correspond to a similar resource if sent over a network, or loaded from a file at a later time.
		**Note:** In a boolean context, an RID will evaluate to `false` if it has the invalid ID `0`. Otherwise, an RID will always evaluate to `true`. This is equivalent to calling `is_valid`.

## 方法

### `get_id() -> int`
- 限定：qualifiers=const

Returns the ID of the referenced low-level resource.

### `is_valid() -> bool`
- 限定：qualifiers=const

Returns `true` if the `RID` is not `0`.

## 构造函数

### `RID`

Constructs an empty `RID` with the invalid ID `0`.

### `RID`

Constructs an `RID` as a copy of the given `RID`.

## 运算符

### `operator !=`

Returns `true` if the `RID`s are not equal.

### `operator <`

Returns `true` if the `RID`'s ID is less than `right`'s ID.

### `operator <=`

Returns `true` if the `RID`'s ID is less than or equal to `right`'s ID.

### `operator ==`

Returns `true` if both `RID`s are equal, which means they both refer to the same low-level resource.

### `operator >`

Returns `true` if the `RID`'s ID is greater than `right`'s ID.

### `operator >=`

Returns `true` if the `RID`'s ID is greater than or equal to `right`'s ID.

