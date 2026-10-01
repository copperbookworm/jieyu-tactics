# AspectRatioContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`AspectRatioContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/AspectRatioContainer.md`

**摘要**：A container that preserves the proportions of its child controls.

## 描述

A container type that arranges its child controls in a way that preserves their proportions automatically when the container is resized. Useful when a container has a dynamic size and the child nodes must adjust their sizes accordingly without losing their aspect ratios.

## 属性

- **`alignment_horizontal`** `int` = `1` · 枚举 `AspectRatioContainer.AlignmentMode`
  - 其它属性：getter=get_alignment_horizontal · setter=set_alignment_horizontal
- **`alignment_vertical`** `int` = `1` · 枚举 `AspectRatioContainer.AlignmentMode`
  - 其它属性：getter=get_alignment_vertical · setter=set_alignment_vertical
- **`ratio`** `float` = `1.0`
  - 其它属性：getter=get_ratio · setter=set_ratio
- **`stretch_mode`** `int` = `2` · 枚举 `AspectRatioContainer.StretchMode`
  - 其它属性：getter=get_stretch_mode · setter=set_stretch_mode

## 枚举

### `StretchMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STRETCH_WIDTH_CONTROLS_HEIGHT` |  |
| `1` | `STRETCH_HEIGHT_CONTROLS_WIDTH` |  |
| `2` | `STRETCH_FIT` |  |
| `3` | `STRETCH_COVER` |  |

### `AlignmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALIGNMENT_BEGIN` |  |
| `1` | `ALIGNMENT_CENTER` |  |
| `2` | `ALIGNMENT_END` |  |

## 教程链接

- [Using Containers](None)

