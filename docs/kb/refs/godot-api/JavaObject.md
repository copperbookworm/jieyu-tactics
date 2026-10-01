# JavaObject

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`JavaObject` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/JavaObject.md`

**摘要**：Represents an object from the Java Native Interface.

## 描述

Represents an object from the Java Native Interface. It can be returned from Java methods called on `JavaClass` or other `JavaObject`s. See `JavaClassWrapper` for an example.
		**Note:** This class only works on Android. On any other platform, this class does nothing.
		**Note:** This class is not to be confused with `JavaScriptObject`.

## 方法

### `get_java_class() -> JavaClass`
- 限定：qualifiers=const

Returns the `JavaClass` that this object is an instance of.

### `has_java_method(method: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `method` name exists in the object's Java methods.

