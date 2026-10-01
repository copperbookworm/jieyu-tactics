# RemoteTransform3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RemoteTransform3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RemoteTransform3D.md`

**摘要**：RemoteTransform3D pushes its own `Transform3D` to another `Node3D` derived Node in the scene.

## 描述

RemoteTransform3D pushes its own `Transform3D` to another `Node3D` derived Node (called the remote node) in the scene.
		It can be set to update another Node's position, rotation and/or scale. It can use either global or local coordinates.

## 属性

- **`remote_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_remote_node · setter=set_remote_node
- **`update_position`** `bool` = `true`
  - 其它属性：getter=get_update_position · setter=set_update_position
- **`update_rotation`** `bool` = `true`
  - 其它属性：getter=get_update_rotation · setter=set_update_rotation
- **`update_scale`** `bool` = `true`
  - 其它属性：getter=get_update_scale · setter=set_update_scale
- **`use_global_coordinates`** `bool` = `true`
  - 其它属性：getter=get_use_global_coordinates · setter=set_use_global_coordinates

## 方法

### `force_update_cache() -> void`

`RemoteTransform3D` caches the remote node. It may not notice if the remote node disappears; `force_update_cache` forces it to update the cache again.

