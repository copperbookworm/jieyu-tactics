# EncodedObjectAsID

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EncodedObjectAsID` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/EncodedObjectAsID.md`

**摘要**：Holds a reference to an `Object`'s instance ID.

## 描述

Utility class which holds a reference to the internal identifier of an `Object` instance, as given by `Object.get_instance_id`. This ID can then be used to retrieve the object instance with `@GlobalScope.instance_from_id`.
		This class is used internally by the editor inspector and script debugger, but can also be used in plugins to pass and display objects as their IDs.

## 属性

- **`object_id`** `int` = `0`
  - 其它属性：getter=get_object_id · setter=set_object_id

