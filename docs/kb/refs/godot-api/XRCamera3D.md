# XRCamera3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRCamera3D` → `Camera3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/XRCamera3D.md`

**摘要**：A camera node which automatically positions itself based on XR tracking data.

## 描述

A camera node which automatically positions itself based on XR tracking data.
		In contrast to `XRController3D`, the render thread has access to more up-to-date tracking data, and the location of the `XRCamera3D` node can lag a few milliseconds behind what is used for rendering.
		**Note:** If `Viewport.use_xr` is `true`, most of the camera properties are overridden by the active `XRInterface`. The only properties that can be trusted are the near and far planes.

## 属性

- **`physics_interpolation_mode`** `int` = `2` · 枚举 `Node.PhysicsInterpolationMode`
  - 其它属性：getter=get_physics_interpolation_mode · overrides=Node · setter=set_physics_interpolation_mode

## 教程链接

- [XR documentation index](None)

