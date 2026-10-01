# VisibleOnScreenEnabler3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisibleOnScreenEnabler3D` → `VisibleOnScreenNotifier3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisibleOnScreenEnabler3D.md`

**摘要**：A box-shaped region of 3D space that, when visible on screen, enables a target node.

## 描述

`VisibleOnScreenEnabler3D` contains a box-shaped region of 3D space and a target node. The target node will be automatically enabled (via its `Node.process_mode` property) when any part of this region becomes visible on the screen, and automatically disabled otherwise. This can for example be used to activate enemies only when the player approaches them.
		See `VisibleOnScreenNotifier3D` if you only want to be notified when the region is visible on screen.
		**Note:** `VisibleOnScreenEnabler3D` uses an approximate heuristic that doesn't take walls and other occlusion into account, unless occlusion culling is used. It also won't function unless `Node3D.visible` is set to `true`.

## 属性

- **`enable_mode`** `int` = `0` · 枚举 `VisibleOnScreenEnabler3D.EnableMode`
  - 其它属性：getter=get_enable_mode · setter=set_enable_mode
- **`enable_node_path`** `NodePath` = `NodePath("..")`
  - 其它属性：getter=get_enable_node_path · setter=set_enable_node_path

## 枚举

### `EnableMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ENABLE_MODE_INHERIT` |  |
| `1` | `ENABLE_MODE_ALWAYS` |  |
| `2` | `ENABLE_MODE_WHEN_PAUSED` |  |

