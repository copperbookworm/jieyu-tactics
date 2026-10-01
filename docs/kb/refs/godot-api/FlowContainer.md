# FlowContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FlowContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FlowContainer.md`

**摘要**：A container that arranges its child controls horizontally or vertically and wraps them around at the borders.

## 描述

A container that arranges its child controls horizontally or vertically and wraps them around at the borders. This is similar to how text in a book wraps around when no more words can fit on a line.

## 属性

- **`alignment`** `int` = `0` · 枚举 `FlowContainer.AlignmentMode`
  - 其它属性：getter=get_alignment · setter=set_alignment
- **`last_wrap_alignment`** `int` = `0` · 枚举 `FlowContainer.LastWrapAlignmentMode`
  - 其它属性：getter=get_last_wrap_alignment · setter=set_last_wrap_alignment
- **`reverse_fill`** `bool` = `false`
  - 其它属性：getter=is_reverse_fill · setter=set_reverse_fill
- **`vertical`** `bool` = `false`
  - 其它属性：getter=is_vertical · setter=set_vertical

## 方法

### `get_line_count() -> int`
- 限定：qualifiers=const

Returns the current line count.

## 枚举

### `AlignmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ALIGNMENT_BEGIN` |  |
| `1` | `ALIGNMENT_CENTER` |  |
| `2` | `ALIGNMENT_END` |  |

### `LastWrapAlignmentMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LAST_WRAP_ALIGNMENT_INHERIT` |  |
| `1` | `LAST_WRAP_ALIGNMENT_BEGIN` |  |
| `2` | `LAST_WRAP_ALIGNMENT_CENTER` |  |
| `3` | `LAST_WRAP_ALIGNMENT_END` |  |

## 主题属性

### `h_separation`
- data_type=constant · default=4 · type=int

### `v_separation`
- data_type=constant · default=4 · type=int

## 教程链接

- [Using Containers](None)

