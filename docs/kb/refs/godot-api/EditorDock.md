# EditorDock

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorDock` → `MarginContainer` → `Container` → `Control` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=editor · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/EditorDock.md`

**摘要**：Dockable container for the editor.

## 描述

EditorDock is a `Container` node that can be docked in one of the editor's dock slots. Docks are added by plugins to provide space for controls related to an `EditorPlugin`. The editor comes with a few built-in docks, such as the Scene dock, FileSystem dock, etc.
		You can add a dock by using `EditorPlugin.add_dock`. The dock can be customized by changing its properties.
		
```gdscript
		@tool
		extends EditorPlugin

		# Dock reference.
		var dock

		# Plugin initialization.
		func _enter_tree():
			dock = EditorDock.new()
			dock.title = "My Dock"
			dock.dock_icon = preload("./dock_icon.png")
			dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_UL
			var dock_content = preload("./dock_content.tscn").instantiate()
			dock.add_child(dock_content)
			add_dock(dock)

		# Plugin clean-up.
		func _exit_tree():
			remove_dock(dock)
			dock.queue_free()
			dock = null
		
```

## 属性

- **`accessibility_region`** `bool` = `true`
  - 其它属性：getter=is_accessibility_region · overrides=Container · setter=set_accessibility_region
- **`available_layouts`** `int` = `5` · 枚举 `EditorDock.DockLayout` · 位标志
  - 其它属性：getter=get_available_layouts · is_bitfield=true · setter=set_available_layouts
- **`closable`** `bool` = `false`
  - 其它属性：getter=is_closable · setter=set_closable
- **`default_slot`** `int` = `-1` · 枚举 `EditorDock.DockSlot`
  - 其它属性：getter=get_default_slot · setter=set_default_slot
- **`dock_icon`** `Texture2D`
  - 其它属性：getter=get_dock_icon · setter=set_dock_icon
- **`dock_shortcut`** `Shortcut`
  - 其它属性：getter=get_dock_shortcut · setter=set_dock_shortcut
- **`force_show_icon`** `bool` = `false`
  - 其它属性：getter=get_force_show_icon · setter=set_force_show_icon
- **`global`** `bool` = `true`
  - 其它属性：getter=is_global · setter=set_global
- **`icon_name`** `StringName` = `&""`
  - 其它属性：getter=get_icon_name · setter=set_icon_name
- **`layout_key`** `String` = `""`
  - 其它属性：getter=get_layout_key · setter=set_layout_key
- **`title`** `String` = `""`
  - 其它属性：getter=get_title · setter=set_title
- **`title_color`** `Color` = `Color(0, 0, 0, 0)`
  - 其它属性：getter=get_title_color · setter=set_title_color
- **`transient`** `bool` = `false`
  - 其它属性：getter=is_transient · setter=set_transient

## 方法

### `_load_layout_from_config(config: ConfigFile, section: String) -> void`
- 限定：qualifiers=virtual

Implement this method to handle loading this dock's layout. It's equivalent to `EditorPlugin._set_window_layout`. `section` is a unique section based on `layout_key`.

### `_save_layout_to_config(config: ConfigFile, section: String) -> void`
- 限定：qualifiers=virtual const

Implement this method to handle saving this dock's layout. It's equivalent to `EditorPlugin._get_window_layout`. `section` is a unique section based on `layout_key`.

### `_update_layout(layout: int) -> void`
- 限定：qualifiers=virtual

Implement this method to handle the layout switching for this dock. `layout` is one of the `DockLayout` constants.
				
```gdscript
				func _update_layout(layout):
					box_container.vertical = (layout == DOCK_LAYOUT_VERTICAL)
				
```

### `close() -> void`

Closes the dock, making its tab hidden.

### `make_visible() -> void`

Focuses the dock's tab (or window if it's floating). If the dock was closed, it will be opened. If it's a bottom dock, makes the bottom panel visible.

### `open() -> void`

Opens the dock. It will appear in the last used dock slot. If the dock has no default slot, it will be opened floating.
				**Note:** This does not focus the dock. If you want to open and focus the dock, use `make_visible`.

## 信号

### `closed()`

Emitted when the dock is closed with the Close button in the context popup, before it's removed from its parent. See `closable`.

### `opened()`

Emitted when the dock is opened via the Editor > Editor Docks menu, before it's made visible.

## 枚举

### `DockLayout`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `DOCK_LAYOUT_VERTICAL` | （位标志） |
| `2` | `DOCK_LAYOUT_HORIZONTAL` | （位标志） |
| `4` | `DOCK_LAYOUT_FLOATING` | （位标志） |
| `7` | `DOCK_LAYOUT_ALL` | （位标志） |

### `DockSlot`

| 值 | 名称 | 说明 |
|---|---|---|
| `-1` | `DOCK_SLOT_NONE` |  |
| `0` | `DOCK_SLOT_LEFT_UL` |  |
| `1` | `DOCK_SLOT_LEFT_BL` |  |
| `2` | `DOCK_SLOT_LEFT_UR` |  |
| `3` | `DOCK_SLOT_LEFT_BR` |  |
| `4` | `DOCK_SLOT_RIGHT_UL` |  |
| `5` | `DOCK_SLOT_RIGHT_BL` |  |
| `6` | `DOCK_SLOT_RIGHT_UR` |  |
| `7` | `DOCK_SLOT_RIGHT_BR` |  |
| `8` | `DOCK_SLOT_BOTTOM` |  |
| `9` | `DOCK_SLOT_BOTTOM_L` |  |
| `10` | `DOCK_SLOT_BOTTOM_R` |  |
| `11` | `DOCK_SLOT_MAX` |  |

## 教程链接

- [Making plugins](None)

