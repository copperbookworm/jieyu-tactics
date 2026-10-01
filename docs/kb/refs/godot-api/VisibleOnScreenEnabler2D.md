# VisibleOnScreenEnabler2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisibleOnScreenEnabler2D` → `VisibleOnScreenNotifier2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisibleOnScreenEnabler2D.md`

**摘要**：A rectangular region of 2D space that, when visible on screen, enables a target node.

## 描述

`VisibleOnScreenEnabler2D` contains a rectangular region of 2D space and a target node. The target node will be automatically enabled (via its `Node.process_mode` property) when any part of this region becomes visible on the screen, and automatically disabled otherwise. This can for example be used to activate enemies only when the player approaches them.
		See `VisibleOnScreenNotifier2D` if you only want to be notified when the region is visible on screen.
		**Note:** `VisibleOnScreenEnabler2D` uses the render culling code to determine whether it's visible on screen, so it won't function unless `CanvasItem.visible` is set to `true`.

## 属性

- **`enable_mode`** `int` = `0` · 枚举 `VisibleOnScreenEnabler2D.EnableMode`
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

