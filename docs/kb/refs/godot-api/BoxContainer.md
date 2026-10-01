# BoxContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`BoxContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/BoxContainer.md`

**摘要**：A container that arranges its child controls horizontally or vertically.

## 描述

A container that arranges its child controls horizontally or vertically, rearranging them automatically when their minimum size changes.

## 属性

- **`alignment`** `int` = `0` · 枚举 `BoxContainer.AlignmentMode`
  - 其它属性：getter=get_alignment · setter=set_alignment
- **`vertical`** `bool` = `false`
  - 其它属性：getter=is_vertical · setter=set_vertical

## 方法

### `add_spacer(begin: bool) -> Control`

Adds a `Control` node to the box as a spacer. If `begin` is `true`, it will insert the `Control` node in front of all other children.

## 枚举

### `AlignmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALIGNMENT_BEGIN` |  |
| `1` | `ALIGNMENT_CENTER` |  |
| `2` | `ALIGNMENT_END` |  |

## 主题属性

### `separation`
- data_type=constant · default=4 · type=int

## 教程链接

- [Using Containers](None)

