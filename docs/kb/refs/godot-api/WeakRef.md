# WeakRef

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`WeakRef` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/WeakRef.md`

**摘要**：Holds an `Object`. If the object is `RefCounted`, it doesn't update the reference count.

## 描述

A weakref can hold a `RefCounted` without contributing to the reference counter. A weakref can be created from an `Object` using `@GlobalScope.weakref`. If this object is not a reference, weakref still works, however, it does not have any effect on the object. Weakrefs are useful in cases where multiple classes have variables that refer to each other. Without weakrefs, using these classes could lead to memory leaks, since both references keep each other from being released. Making part of the variables a weakref can prevent this cyclic dependency, and allows the references to be released.

## 方法

### `get_ref() -> Variant`
- 限定：qualifiers=const

Returns the `Object` this weakref is referring to. Returns `null` if that object no longer exists.

