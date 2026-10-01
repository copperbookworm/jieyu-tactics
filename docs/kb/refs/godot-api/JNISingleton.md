# JNISingleton

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`JNISingleton` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/JNISingleton.md`

**摘要**：Singleton that connects the engine with Android plugins to interface with native Android code.

## 描述

The JNISingleton is implemented only in the Android export. It's used to call methods and connect signals from an Android plugin written in Java or Kotlin. Methods and signals can be called and connected to the JNISingleton as if it is a Node. See Java Native Interface - Wikipedia (https://en.wikipedia.org/wiki/Java_Native_Interface) for more information.

## 方法

### `has_java_method(method: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the given `method` name exists in the JNISingleton's Java methods.

## 教程链接

- [Creating Android plugins](None)

