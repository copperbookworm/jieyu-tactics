# MissingResource

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`MissingResource` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/MissingResource.md`

**摘要**：An internal editor class intended for keeping the data of unrecognized resources.

## 描述

This is an internal editor class intended for keeping data of resources of unknown type (most likely this type was supplied by an extension that is no longer loaded). It can't be manually instantiated or placed in a scene.
		**Warning:** Ignore missing resources unless you know what you are doing. Existing properties on a missing resource can be freely modified in code, regardless of the type they are intended to be.

## 属性

- **`original_class`** `String`
  - 其它属性：getter=get_original_class · setter=set_original_class
- **`recording_properties`** `bool`
  - 其它属性：getter=is_recording_properties · setter=set_recording_properties

