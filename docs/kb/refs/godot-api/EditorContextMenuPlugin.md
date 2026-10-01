# EditorContextMenuPlugin

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorContextMenuPlugin` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorContextMenuPlugin.md`

**摘要**：Plugin for adding custom context menus in the editor.

## 描述

`EditorContextMenuPlugin` allows for the addition of custom options in the editor's context menu.
		Currently, context menus are supported for three commonly used areas: the file system, scene tree, and editor script list panel.

## 方法

### `_popup_menu(paths: PackedStringArray) -> void`
- 限定：qualifiers=virtual

Called when creating a context menu, custom options can be added by using the `add_context_menu_item` or `add_context_menu_item_from_shortcut` functions. `paths` contains currently selected paths (depending on menu), which can be used to conditionally add options.

### `add_context_menu_item(name: String, callback: Callable, icon: Texture2D = null) -> void`

Add custom option to the context menu of the plugin's specified slot. When the option is activated, `callback` will be called. Callback should take single `Array` argument; array contents depend on context menu slot.
				
```gdscript
				func _popup_menu(paths):
					add_context_menu_item("File Custom options", handle, ICON)
				
```

				If you want to assign shortcut to the menu item, use `add_context_menu_item_from_shortcut` instead.

### `add_context_menu_item_from_shortcut(name: String, shortcut: Shortcut, icon: Texture2D = null) -> void`

Add custom option to the context menu of the plugin's specified slot. The option will have the `shortcut` assigned and reuse its callback. The shortcut has to be registered beforehand with `add_menu_shortcut`.
				
```gdscript
				func _init():
					add_menu_shortcut(SHORTCUT, handle)

				func _popup_menu(paths):
					add_context_menu_item_from_shortcut("File Custom options", SHORTCUT, ICON)
				
```

### `add_context_submenu_item(name: String, menu: PopupMenu, icon: Texture2D = null) -> void`

Add a submenu to the context menu of the plugin's specified slot. The submenu is not automatically handled, you need to connect to its signals yourself. Also the submenu is freed on every popup, so provide a new `PopupMenu` every time.
				
```gdscript
				func _popup_menu(paths):
					var popup_menu = PopupMenu.new()
					popup_menu.add_item("Blue")
					popup_menu.add_item("White")
					popup_menu.id_pressed.connect(_on_color_submenu_option)

					add_context_submenu_item("Set Node Color", popup_menu)
				
```

### `add_menu_shortcut(shortcut: Shortcut, callback: Callable) -> void`

Registers a shortcut associated with the plugin's context menu. This method should be called once (e.g. in plugin's `Object._init`). `callback` will be called when user presses the specified `shortcut` while the menu's context is in effect (e.g. FileSystem dock is focused). Callback should take single `Array` argument; array contents depend on context menu slot.
				
```gdscript
				func _init():
					add_menu_shortcut(SHORTCUT, handle)
				
```

## 枚举

### `ContextMenuSlot`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CONTEXT_SLOT_SCENE_TREE` |  |
| `1` | `CONTEXT_SLOT_FILESYSTEM` |  |
| `2` | `CONTEXT_SLOT_SCRIPT_EDITOR` |  |
| `3` | `CONTEXT_SLOT_FILESYSTEM_CREATE` |  |
| `4` | `CONTEXT_SLOT_SCRIPT_EDITOR_CODE` |  |
| `5` | `CONTEXT_SLOT_SCENE_TABS` |  |
| `6` | `CONTEXT_SLOT_2D_EDITOR` |  |
| `7` | `CONTEXT_SLOT_INSPECTOR_PROPERTY` |  |

