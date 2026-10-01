# XRControllerTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRControllerTracker` → `XRPositionalTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRControllerTracker.md`

**摘要**：A tracked controller.

## 描述

An instance of this object represents a controller that is tracked.
		As controllers are turned on and the `XRInterface` detects them, instances of this object are automatically added to this list of active tracking objects accessible through the `XRServer`.
		The `XRController3D` consumes objects of this type and should be used in your project.

## 属性

- **`type`** `int` = `2` · 枚举 `XRServer.TrackerType`
  - 其它属性：getter=get_tracker_type · overrides=XRTracker · setter=set_tracker_type

## 教程链接

- [XR documentation index](None)

