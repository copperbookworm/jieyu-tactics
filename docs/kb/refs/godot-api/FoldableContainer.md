# FoldableContainer

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FoldableContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core · keywords=expandable, collapsible, collapse, accordion, details
> 自动生成，勿手改。文件：`refs/godot-api/FoldableContainer.md`

**摘要**：A container that can be expanded/collapsed.

## 描述

A container that can be expanded/collapsed, with a title that can be filled with controls, such as buttons. This is also called an accordion.
		The title can be positioned at the top or bottom of the container. The container can be expanded or collapsed by clicking the title or by pressing `ui_accept` when focused. Child control nodes are hidden when the container is collapsed. Ignores non-control children.
		A FoldableContainer can be grouped with other FoldableContainers so that only one of them can be opened at a time; see `foldable_group` and `FoldableGroup`.

## 属性

- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`foldable_group`** `FoldableGroup`
  - 其它属性：getter=get_foldable_group · setter=set_foldable_group
- **`folded`** `bool` = `false`
  - 其它属性：getter=is_folded · setter=set_folded
- **`language`** `String` = `""`
  - 其它属性：getter=get_language · setter=set_language
- **`mouse_filter`** `int` = `0` · 枚举 `Control.MouseFilter`
  - 其它属性：getter=get_mouse_filter · overrides=Control · setter=set_mouse_filter
- **`title`** `String` = `""`
  - 其它属性：getter=get_title · setter=set_title
- **`title_alignment`** `int` = `0` · 枚举 `HorizontalAlignment`
  - 其它属性：getter=get_title_alignment · setter=set_title_alignment
- **`title_position`** `int` = `0` · 枚举 `FoldableContainer.TitlePosition`
  - 其它属性：getter=get_title_position · setter=set_title_position
- **`title_text_direction`** `int` = `0` · 枚举 `Control.TextDirection`
  - 其它属性：getter=get_title_text_direction · setter=set_title_text_direction
- **`title_text_overrun_behavior`** `int` = `0` · 枚举 `TextServer.OverrunBehavior`
  - 其它属性：getter=get_title_text_overrun_behavior · setter=set_title_text_overrun_behavior

## 方法

### `add_title_bar_control(control: Control) -> void`

Adds a `Control` that will be placed next to the container's title, obscuring the clickable area. Prime usage is adding `Button` nodes, but it can be any `Control`.
				The control will be added as a child of this container and removed from previous parent if necessary. The controls will be placed aligned to the right, with the first added control being the leftmost one.

### `expand() -> void`

Expands the container and emits `folding_changed`.

### `fold() -> void`

Folds the container and emits `folding_changed`.

### `remove_title_bar_control(control: Control) -> void`

Removes a `Control` added with `add_title_bar_control`. The node is not freed automatically, you need to use `Node.queue_free`.

## 信号

### `folding_changed(is_folded: bool)`

Emitted when the container is folded/expanded.

## 枚举

### `TitlePosition`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `POSITION_TOP` |  |
| `1` | `POSITION_BOTTOM` |  |

## 主题属性

### `collapsed_font_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `hover_font_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `h_separation`
- data_type=constant · default=2 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `expanded_arrow`
- data_type=icon · type=Texture2D

### `expanded_arrow_mirrored`
- data_type=icon · type=Texture2D

### `folded_arrow`
- data_type=icon · type=Texture2D

### `folded_arrow_mirrored`
- data_type=icon · type=Texture2D

### `focus`
- data_type=style · type=StyleBox

### `panel`
- data_type=style · type=StyleBox

### `title_collapsed_hover_panel`
- data_type=style · type=StyleBox

### `title_collapsed_panel`
- data_type=style · type=StyleBox

### `title_hover_panel`
- data_type=style · type=StyleBox

### `title_panel`
- data_type=style · type=StyleBox

