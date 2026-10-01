# OpenXRAnchorTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRAnchorTracker` → `OpenXRSpatialEntityTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRAnchorTracker.md`

**摘要**：Positional tracker for our spatial entity anchor extension.

## 描述

Positional tracker for our OpenXR spatial entity anchor extension, it tracks a user defined location in real space and maps it to our virtual space.

## 属性

- **`uuid`** `String` = `""`
  - 其它属性：getter=get_uuid · setter=set_uuid

## 方法

### `has_uuid() -> bool`
- 限定：qualifiers=const

Returns `true` if a non-zero UUID is set.

## 信号

### `uuid_changed()`

Emitted when the UUID for this anchor was changed.

