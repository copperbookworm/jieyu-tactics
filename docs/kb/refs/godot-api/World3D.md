# World3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`World3D` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/World3D.md`

**摘要**：A resource that holds all components of a 3D world, such as a visual scenario and a physics space.

## 描述

Class that has everything pertaining to a world: A physics space, a visual scenario, and a sound space. 3D nodes register their resources into the current 3D world.

## 属性

- **`camera_attributes`** `CameraAttributes`
  - 其它属性：getter=get_camera_attributes · setter=set_camera_attributes
- **`direct_space_state`** `PhysicsDirectSpaceState3D`
  - 其它属性：getter=get_direct_space_state · setter=
- **`environment`** `Environment`
  - 其它属性：getter=get_environment · setter=set_environment
- **`fallback_environment`** `Environment`
  - 其它属性：getter=get_fallback_environment · setter=set_fallback_environment
- **`navigation_map`** `RID`
  - 其它属性：getter=get_navigation_map · setter=
- **`scenario`** `RID`
  - 其它属性：getter=get_scenario · setter=
- **`space`** `RID`
  - 其它属性：getter=get_space · setter=

## 教程链接

- [Ray-casting](None)

