# JavaClass

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`JavaClass` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/JavaClass.md`

**摘要**：Represents a class from the Java Native Interface.

## 描述

Represents a class from the Java Native Interface. It is returned from `JavaClassWrapper.wrap`.
		**Note:** This class only works on Android. On any other platform, this class does nothing.
		**Note:** This class is not to be confused with `JavaScriptObject`.

## 方法

### `get_java_class_name() -> String`
- 限定：qualifiers=const

Returns the Java class name.

### `get_java_method_list() -> Dictionary[]`
- 限定：qualifiers=const

Returns the object's Java methods and their signatures as an `Array` of dictionaries, in the same format as `Object.get_method_list`.

### `get_java_parent_class() -> JavaClass`
- 限定：qualifiers=const

Returns a `JavaClass` representing the Java parent class of this class.

### `has_java_method(method: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `method` name exists in the object's Java methods.

