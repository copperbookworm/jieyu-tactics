# Tree

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Tree` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Tree.md`

**摘要**：A control used to show a set of internal `TreeItem`s in a hierarchical structure.

## 描述

A control used to show a set of internal `TreeItem`s in a hierarchical structure. The tree items can be selected, expanded and collapsed. The tree can have multiple columns with custom controls like `LineEdit`s, buttons and popups. It can be useful for structured displays and interactions.
		Trees are built via code, using `TreeItem` objects to create the structure. They have a single root, but multiple roots can be simulated with `hide_root`:
		`codeblocks`
		`gdscript`
		func _ready():
			var tree = Tree.new()
			var root = tree.create_item()
			tree.hide_root = true
			var child1 = tree.create_item(root)
			var child2 = tree.create_item(root)
			var subchild1 = tree.create_item(child1)
			subchild1.set_text(0, "Subchild1")
		
		`csharp`
		public override void _Ready()
		{
			var tree = new Tree();
			TreeItem root = tree.CreateItem();
			tree.HideRoot = true;
			TreeItem child1 = tree.CreateItem(root);
			TreeItem child2 = tree.CreateItem(root);
			TreeItem subchild1 = tree.CreateItem(child1);
			subchild1.SetText(0, "Subchild1");
		}
		
		
		To iterate over all the `TreeItem` objects in a `Tree` object, use `TreeItem.get_next` and `TreeItem.get_first_child` after getting the root through `get_root`. You can use `Object.free` on a `TreeItem` to remove it from the `Tree`.
		**Incremental search:** Like `ItemList` and `PopupMenu`, `Tree` supports searching within the list while the control is focused. Press a key that matches the first letter of an item's name to select the first item starting with the given letter. After that point, there are two ways to perform incremental search: 1) Press the same key again before the timeout duration to select the next item starting with the same letter. 2) Press letter keys that match the rest of the word before the timeout duration to match to select the item in question directly. Both of these actions will be reset to the beginning of the list if the timeout duration has passed since the last keystroke was registered. You can adjust the timeout duration by changing `ProjectSettings.gui/timers/incremental_search_max_interval_msec`.

## 属性

- **`allow_reselect`** `bool` = `false`
  - 其它属性：getter=get_allow_reselect · setter=set_allow_reselect
- **`allow_rmb_select`** `bool` = `false`
  - 其它属性：getter=get_allow_rmb_select · setter=set_allow_rmb_select
- **`allow_search`** `bool` = `true`
  - 其它属性：getter=get_allow_search · setter=set_allow_search
- **`auto_tooltip`** `bool` = `true`
  - 其它属性：getter=is_auto_tooltip_enabled · setter=set_auto_tooltip
- **`clip_contents`** `bool` = `true`
  - 其它属性：getter=is_clipping_contents · overrides=Control · setter=set_clip_contents
- **`column_titles_visible`** `bool` = `false`
  - 其它属性：getter=are_column_titles_visible · setter=set_column_titles_visible
- **`columns`** `int` = `1`
  - 其它属性：getter=get_columns · setter=set_columns
- **`drop_mode_flags`** `int` = `0`
  - 其它属性：getter=get_drop_mode_flags · setter=set_drop_mode_flags
- **`enable_drag_unfolding`** `bool` = `true`
  - 其它属性：getter=is_drag_unfolding_enabled · setter=set_enable_drag_unfolding
- **`enable_recursive_folding`** `bool` = `true`
  - 其它属性：getter=is_recursive_folding_enabled · setter=set_enable_recursive_folding
- **`focus_mode`** `int` = `2` · 枚举 `Control.FocusMode`
  - 其它属性：getter=get_focus_mode · overrides=Control · setter=set_focus_mode
- **`hide_folding`** `bool` = `false`
  - 其它属性：getter=is_folding_hidden · setter=set_hide_folding
- **`hide_root`** `bool` = `false`
  - 其它属性：getter=is_root_hidden · setter=set_hide_root
- **`scroll_hint_mode`** `int` = `0` · 枚举 `Tree.ScrollHintMode`
  - 其它属性：getter=get_scroll_hint_mode · setter=set_scroll_hint_mode
- **`scroll_horizontal_enabled`** `bool` = `true`
  - 其它属性：getter=is_h_scroll_enabled · setter=set_h_scroll_enabled
- **`scroll_vertical_enabled`** `bool` = `true`
  - 其它属性：getter=is_v_scroll_enabled · setter=set_v_scroll_enabled
- **`select_mode`** `int` = `0` · 枚举 `Tree.SelectMode`
  - 其它属性：getter=get_select_mode · setter=set_select_mode
- **`tile_scroll_hint`** `bool` = `false`
  - 其它属性：getter=is_scroll_hint_tiled · setter=set_tile_scroll_hint

## 方法

### `clear() -> void`

Clears the tree. This removes all items.
				Prints an error and does not allow clearing the tree if called during mouse selection.

### `create_item(parent: TreeItem = null, index: int = -1) -> TreeItem`

Creates an item in the tree and adds it as a child of `parent`, which can be either a valid `TreeItem` or `null`.
				If `parent` is `null`, the root item will be the parent, or the new item will be the root itself if the tree is empty.
				The new item will be the `index`-th child of parent, or it will be the last child if there are not enough siblings.
				Prints an error and returns `null` if called during mouse selection, or if the `parent` does not belong to this tree.

### `deselect_all() -> void`

Deselects all tree items (rows and columns). In `SELECT_MULTI` mode also removes selection cursor.

### `edit_selected(force_edit: bool = false) -> bool`

Edits the selected tree item as if it was clicked.
				Either the item must be set editable with `TreeItem.set_editable` or `force_edit` must be `true`.
				Returns `true` if the item could be edited. Fails if no item is selected.

### `ensure_cursor_is_visible() -> void`

Makes the currently focused cell visible.
				This will scroll the tree if necessary. In `SELECT_ROW` mode, this will not do horizontal scrolling, as all the cells in the selected row is focused logically.
				**Note:** Despite the name of this method, the focus cursor itself is only visible in `SELECT_MULTI` mode.

### `get_button_id_at_position(position: Vector2) -> int`
- 限定：qualifiers=const

Returns the button ID at `position`, or -1 if no button is there.

### `get_column_at_position(position: Vector2) -> int`
- 限定：qualifiers=const

Returns the column index at `position`, or -1 if no item is there.

### `get_column_expand_ratio(column: int) -> int`
- 限定：qualifiers=const

Returns the expand ratio assigned to the column.

### `get_column_title(column: int) -> String`
- 限定：qualifiers=const

Returns the column's title.

### `get_column_title_alignment(column: int) -> int`
- 限定：qualifiers=const

Returns the column title alignment.

### `get_column_title_direction(column: int) -> int`
- 限定：qualifiers=const

Returns column title base writing direction.

### `get_column_title_language(column: int) -> String`
- 限定：qualifiers=const

Returns column title language code.

### `get_column_title_tooltip_text(column: int) -> String`
- 限定：qualifiers=const

Returns the column title's tooltip text.

### `get_column_width(column: int) -> int`
- 限定：qualifiers=const

Returns the column's width in pixels.

### `get_custom_drawing_canvas_item() -> RID`
- 限定：qualifiers=const

Returns the internal canvas item designated for custom drawing. See `TreeItem.set_custom_draw_callback`.
				**Note:** This canvas item clears automatically on each Tree draw call.

### `get_custom_popup_rect() -> Rect2`
- 限定：qualifiers=const

Returns the rectangle for custom popups. Helper to create custom cell controls that display a popup. See `TreeItem.set_cell_mode`.

### `get_drop_section_at_position(position: Vector2) -> int`
- 限定：qualifiers=const

Returns the drop section at `position`, as permitted by enabled `DropModeFlags`.
				- `-1` if the position is **above** the item. Typically used to insert as the item's previous sibling.
				- `0` if the position is **on** the item. Typically used to insert as the item's last child.
				- `1` if the position is **below** the item, when the item has no children. Typically used to insert as the item's next sibling. If the item *does* have children, this section is still reachable by hovering to the left of the item's collapse arrow, and below.
				- `2` if the position is **below** the item, when the item has children. Typically used to insert as the item's first child.
				- `-100` if the position is not over any item, or no `DropModeFlags` are set.
				See `DropModeFlags` for a description of each drop region. To get the item which the returned drop section refers to, use `get_item_at_position`.

### `get_edited() -> TreeItem`
- 限定：qualifiers=const

Returns the currently edited item. Can be used with `item_edited` to get the item that was modified.
				`codeblocks`
				`gdscript`
				func _ready():
					$Tree.item_edited.connect(on_Tree_item_edited)

				func on_Tree_item_edited():
					print($Tree.get_edited()) # This item just got edited (e.g. checked).
				
				`csharp`
				public override void _Ready()
				{
					GetNode<Tree>("Tree").ItemEdited += OnTreeItemEdited;
				}

				public void OnTreeItemEdited()
				{
					GD.Print(GetNode<Tree>("Tree").GetEdited()); // This item just got edited (e.g. checked).
				}

### `get_edited_column() -> int`
- 限定：qualifiers=const

Returns the column for the currently edited item.

### `get_item_area_rect(item: TreeItem, column: int = -1, button_index: int = -1) -> Rect2`
- 限定：qualifiers=const

Returns the rectangle area for the specified `TreeItem`. If `column` is specified, only get the position and size of that column, otherwise get the rectangle containing all columns. If a button index is specified, the rectangle of that button will be returned.

### `get_item_at_position(position: Vector2) -> TreeItem`
- 限定：qualifiers=const

Returns the tree item at the specified position (relative to the tree origin position).

### `get_next_selected(from: TreeItem) -> TreeItem`

Returns the next selected `TreeItem` after the given one, or `null` if the end is reached.
				If `from` is `null`, this returns the first selected item.

### `get_pressed_button() -> int`
- 限定：qualifiers=const

Returns the last pressed button's index.

### `get_root() -> TreeItem`
- 限定：qualifiers=const

Returns the tree's root item, or `null` if the tree is empty.

### `get_scroll() -> Vector2`
- 限定：qualifiers=const

Returns the current scrolling position.

### `get_selected() -> TreeItem`
- 限定：qualifiers=const

Returns the currently focused item, or `null` if no item is focused.
				In `SELECT_ROW` and `SELECT_SINGLE` modes, the focused item is same as the selected item. In `SELECT_MULTI` mode, the focused item is the item under the focus cursor, not necessarily selected.
				To get the currently selected item(s), use `get_next_selected`.

### `get_selected_column() -> int`
- 限定：qualifiers=const

Returns the currently focused column, or -1 if no column is focused.
				In `SELECT_SINGLE` mode, the focused column is the selected column. In `SELECT_ROW` mode, the focused column is always 0 if any item is selected. In `SELECT_MULTI` mode, the focused column is the column under the focus cursor, and there are not necessarily any column selected.
				To tell whether a column of an item is selected, use `TreeItem.is_selected`.

### `is_column_clipping_content(column: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the column has enabled clipping (see `set_column_clip_content`).

### `is_column_expanding(column: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the column has enabled expanding (see `set_column_expand`).

### `scroll_to_item(item: TreeItem, center_on_item: bool = false) -> void`

Causes the `Tree` to jump to the specified `TreeItem`.

### `set_column_clip_content(column: int, enable: bool) -> void`

Allows to enable clipping for column's content, making the content size ignored.

### `set_column_custom_minimum_width(column: int, min_width: int) -> void`

Overrides the calculated minimum width of a column. It can be set to `0` to restore the default behavior. Columns that have the "Expand" flag will use their "min_width" in a similar fashion to `Control.size_flags_stretch_ratio`.

### `set_column_expand(column: int, expand: bool) -> void`

If `true`, the column will have the "Expand" flag of `Control`. Columns that have the "Expand" flag will use their expand ratio in a similar fashion to `Control.size_flags_stretch_ratio` (see `set_column_expand_ratio`).

### `set_column_expand_ratio(column: int, ratio: int) -> void`

Sets the relative expand ratio for a column. See `set_column_expand`.

### `set_column_title(column: int, title: String) -> void`

Sets the title of a column.

### `set_column_title_alignment(column: int, title_alignment: int) -> void`

Sets the column title alignment. Note that `@GlobalScope.HORIZONTAL_ALIGNMENT_FILL` is not supported for column titles.

### `set_column_title_direction(column: int, direction: int) -> void`

Sets column title base writing direction.

### `set_column_title_language(column: int, language: String) -> void`

Sets the language code of the given `column`'s title to `language`. This is used for line-breaking and text shaping algorithms. If `language` is empty, the current locale is used.

### `set_column_title_tooltip_text(column: int, tooltip_text: String) -> void`

Sets the column title's tooltip text.

### `set_selected(item: TreeItem, column: int) -> void`

Selects the specified `TreeItem` and column.

## 信号

### `button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int)`

Emitted when a button on the tree was pressed (see `TreeItem.add_button`).

### `cell_selected()`

Emitted when a cell is selected.

### `check_propagated_to_item(item: TreeItem, column: int)`

Emitted when `TreeItem.propagate_check` is called. Connect to this signal to process the items that are affected when `TreeItem.propagate_check` is invoked. The order that the items affected will be processed is as follows: the item that invoked the method, children of that item, and finally parents of that item.

### `column_title_clicked(column: int, mouse_button_index: int)`

Emitted when a column's title is clicked with either `MOUSE_BUTTON_LEFT` or `MOUSE_BUTTON_RIGHT`.

### `custom_item_clicked(mouse_button_index: int)`

Emitted when an item with `TreeItem.CELL_MODE_CUSTOM` is clicked with a mouse button.

### `custom_popup_edited(arrow_clicked: bool)`

Emitted when a cell with the `TreeItem.CELL_MODE_CUSTOM` is clicked to be edited.

### `empty_clicked(click_position: Vector2, mouse_button_index: int)`

Emitted when a mouse button is clicked in the empty space of the tree.

### `item_activated()`

Emitted when an item is double-clicked, or selected with a `ui_accept` input event (e.g. using Enter or Space on the keyboard).

### `item_collapsed(item: TreeItem)`

Emitted when an item is expanded or collapsed by clicking on the folding arrow or through code.
				**Note:** Despite its name, this signal is also emitted when an item is expanded.

### `item_edited()`

Emitted when an item is edited.

### `item_icon_double_clicked()`

Emitted when an item's icon is double-clicked. For a signal that emits when any part of the item is double-clicked, see `item_activated`.

### `item_mouse_selected(mouse_position: Vector2, mouse_button_index: int)`

Emitted when an item is selected with a mouse button.

### `item_selected()`

Emitted when an item is selected.

### `multi_selected(item: TreeItem, column: int, selected: bool)`

Emitted instead of `item_selected` if `select_mode` is set to `SELECT_MULTI`.

### `nothing_selected()`

Emitted when a left mouse button click does not select any item.

## 枚举

### `SelectMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SELECT_SINGLE` |  |
| `1` | `SELECT_ROW` |  |
| `2` | `SELECT_MULTI` |  |

### `DropModeFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DROP_MODE_DISABLED` |  |
| `1` | `DROP_MODE_ON_ITEM` |  |
| `2` | `DROP_MODE_INBETWEEN` |  |

### `ScrollHintMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SCROLL_HINT_MODE_DISABLED` |  |
| `1` | `SCROLL_HINT_MODE_BOTH` |  |
| `2` | `SCROLL_HINT_MODE_TOP` |  |
| `3` | `SCROLL_HINT_MODE_BOTTOM` |  |

## 主题属性

### `children_hl_line_color`
- data_type=color · default=Color(0.27, 0.27, 0.27, 1) · type=Color

### `custom_button_font_highlight`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `drop_on_item_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `drop_position_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_color`
- data_type=color · default=Color(0.7, 0.7, 0.7, 1) · type=Color

### `font_disabled_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 0.5) · type=Color

### `font_hovered_color`
- data_type=color · default=Color(0.95, 0.95, 0.95, 1) · type=Color

### `font_hovered_dimmed_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `font_hovered_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `font_outline_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `font_selected_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `guide_color`
- data_type=color · default=Color(0.7, 0.7, 0.7, 0.25) · type=Color

### `parent_hl_line_color`
- data_type=color · default=Color(0.27, 0.27, 0.27, 1) · type=Color

### `relationship_line_color`
- data_type=color · default=Color(0.27, 0.27, 0.27, 1) · type=Color

### `scroll_hint_color`
- data_type=color · default=Color(0, 0, 0, 1) · type=Color

### `title_button_color`
- data_type=color · default=Color(0.875, 0.875, 0.875, 1) · type=Color

### `button_margin`
- data_type=constant · default=4 · type=int

### `check_h_separation`
- data_type=constant · default=4 · type=int

### `children_hl_line_width`
- data_type=constant · default=1 · type=int

### `dragging_unfold_wait_msec`
- data_type=constant · default=500 · type=int

### `draw_guides`
- data_type=constant · default=1 · type=int

### `draw_relationship_lines`
- data_type=constant · default=0 · type=int

### `h_separation`
- data_type=constant · default=4 · type=int

### `icon_h_separation`
- data_type=constant · default=4 · type=int

### `icon_max_width`
- data_type=constant · default=0 · type=int

### `inner_item_margin_bottom`
- data_type=constant · default=0 · type=int

### `inner_item_margin_left`
- data_type=constant · default=0 · type=int

### `inner_item_margin_right`
- data_type=constant · default=0 · type=int

### `inner_item_margin_top`
- data_type=constant · default=0 · type=int

### `item_margin`
- data_type=constant · default=16 · type=int

### `outline_size`
- data_type=constant · default=0 · type=int

### `parent_hl_line_margin`
- data_type=constant · default=0 · type=int

### `parent_hl_line_width`
- data_type=constant · default=1 · type=int

### `relationship_line_width`
- data_type=constant · default=1 · type=int

### `scroll_border`
- data_type=constant · default=4 · type=int

### `scroll_speed`
- data_type=constant · default=12 · type=int

### `scrollbar_h_separation`
- data_type=constant · default=4 · type=int

### `scrollbar_margin_bottom`
- data_type=constant · default=-1 · type=int

### `scrollbar_margin_left`
- data_type=constant · default=-1 · type=int

### `scrollbar_margin_right`
- data_type=constant · default=-1 · type=int

### `scrollbar_margin_top`
- data_type=constant · default=-1 · type=int

### `scrollbar_v_separation`
- data_type=constant · default=4 · type=int

### `v_separation`
- data_type=constant · default=4 · type=int

### `font`
- data_type=font · type=Font

### `title_button_font`
- data_type=font · type=Font

### `font_size`
- data_type=font_size · type=int

### `title_button_font_size`
- data_type=font_size · type=int

### `arrow`
- data_type=icon · type=Texture2D

### `arrow_collapsed`
- data_type=icon · type=Texture2D

### `arrow_collapsed_mirrored`
- data_type=icon · type=Texture2D

### `checked`
- data_type=icon · type=Texture2D

### `checked_disabled`
- data_type=icon · type=Texture2D

### `indeterminate`
- data_type=icon · type=Texture2D

### `indeterminate_disabled`
- data_type=icon · type=Texture2D

### `scroll_hint`
- data_type=icon · type=Texture2D

### `select_arrow`
- data_type=icon · type=Texture2D

### `unchecked`
- data_type=icon · type=Texture2D

### `unchecked_disabled`
- data_type=icon · type=Texture2D

### `updown`
- data_type=icon · type=Texture2D

### `button_hover`
- data_type=style · type=StyleBox

### `button_pressed`
- data_type=style · type=StyleBox

### `cursor`
- data_type=style · type=StyleBox

### `cursor_unfocused`
- data_type=style · type=StyleBox

### `custom_button`
- data_type=style · type=StyleBox

### `custom_button_hover`
- data_type=style · type=StyleBox

### `custom_button_pressed`
- data_type=style · type=StyleBox

### `focus`
- data_type=style · type=StyleBox

### `hovered`
- data_type=style · type=StyleBox

### `hovered_dimmed`
- data_type=style · type=StyleBox

### `hovered_selected`
- data_type=style · type=StyleBox

### `hovered_selected_focus`
- data_type=style · type=StyleBox

### `panel`
- data_type=style · type=StyleBox

### `selected`
- data_type=style · type=StyleBox

### `selected_focus`
- data_type=style · type=StyleBox

### `title_button_hover`
- data_type=style · type=StyleBox

### `title_button_normal`
- data_type=style · type=StyleBox

### `title_button_pressed`
- data_type=style · type=StyleBox

