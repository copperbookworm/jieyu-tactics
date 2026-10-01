# PathFollow3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`PathFollow3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/PathFollow3D.md`

**摘要**：Point sampler for a `Path3D`.

## 描述

This node takes its parent `Path3D`, and returns the coordinates of a point within it, given a distance from the first vertex.
		It is useful for making other nodes follow a path, without coding the movement pattern. For that, the nodes must be children of this node. The descendant nodes will then move accordingly when setting the `progress` in this node.

## 属性

- **`cubic_interp`** `bool` = `true`
  - 其它属性：getter=get_cubic_interpolation · setter=set_cubic_interpolation
- **`h_offset`** `float` = `0.0`
  - 其它属性：getter=get_h_offset · setter=set_h_offset
- **`loop`** `bool` = `true`
  - 其它属性：getter=has_loop · setter=set_loop
- **`progress`** `float` = `0.0`
  - 其它属性：getter=get_progress · setter=set_progress
- **`progress_ratio`** `float` = `0.0`
  - 其它属性：getter=get_progress_ratio · setter=set_progress_ratio
- **`rotation_mode`** `int` = `3` · 枚举 `PathFollow3D.RotationMode`
  - 其它属性：getter=get_rotation_mode · setter=set_rotation_mode
- **`tilt_enabled`** `bool` = `true`
  - 其它属性：getter=is_tilt_enabled · setter=set_tilt_enabled
- **`use_model_front`** `bool` = `false`
  - 其它属性：getter=is_using_model_front · setter=set_use_model_front
- **`v_offset`** `float` = `0.0`
  - 其它属性：getter=get_v_offset · setter=set_v_offset

## 方法

### `correct_posture(transform: Transform3D, rotation_mode: int) -> Transform3D`
- 限定：qualifiers=static

Correct the `transform`. `rotation_mode` implicitly specifies how posture (forward, up and sideway direction) is calculated.

## 枚举

### `RotationMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ROTATION_NONE` |  |
| `1` | `ROTATION_Y` |  |
| `2` | `ROTATION_XY` |  |
| `3` | `ROTATION_XYZ` |  |
| `4` | `ROTATION_ORIENTED` |  |

