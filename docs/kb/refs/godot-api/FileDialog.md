# FileDialog

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FileDialog` → `ConfirmationDialog` → `AcceptDialog` → `Window` → `Viewport` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FileDialog.md`

**摘要**：A dialog for selecting files or directories in the filesystem.

## 描述

`FileDialog` is a preset dialog used to choose files and directories in the filesystem. It supports filter masks. `FileDialog` automatically sets its window title according to the `file_mode`. If you want to use a custom title, disable this by setting `mode_overrides_title` to `false`.
		**Note:** `FileDialog` is invisible by default. To make it visible, call one of the `popup_*` methods from `Window` on the node, such as `Window.popup_centered_clamped`.

## 属性

- **`access`** `int` = `0` · 枚举 `FileDialog.Access`
  - 其它属性：getter=get_access · setter=set_access
- **`current_dir`** `String`
  - 其它属性：getter=get_current_dir · setter=set_current_dir
- **`current_file`** `String`
  - 其它属性：getter=get_current_file · setter=set_current_file
- **`current_path`** `String`
  - 其它属性：getter=get_current_path · setter=set_current_path
- **`deleting_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`dialog_hide_on_ok`** `bool` = `false`
  - 其它属性：getter=get_hide_on_ok · overrides=AcceptDialog · setter=set_hide_on_ok
- **`display_mode`** `int` = `0` · 枚举 `FileDialog.DisplayMode`
  - 其它属性：getter=get_display_mode · setter=set_display_mode
- **`favorites_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`file_filter_toggle_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`file_mode`** `int` = `4` · 枚举 `FileDialog.FileMode`
  - 其它属性：getter=get_file_mode · setter=set_file_mode
- **`file_sort_options_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`filename_filter`** `String` = `""`
  - 其它属性：getter=get_filename_filter · setter=set_filename_filter
- **`filters`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter=get_filters · setter=set_filters
- **`folder_creation_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`hidden_files_toggle_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`layout_toggle_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`mode_overrides_title`** `bool` = `true`
  - 其它属性：getter=is_mode_overriding_title · setter=set_mode_overrides_title
- **`option_count`** `int` = `0`
  - 其它属性：getter=get_option_count · setter=set_option_count
- **`option_{index}/default`** `int` = `0`
  - 其它属性：getter= · setter=
- **`option_{index}/name`** `String` = `""`
  - 其它属性：getter= · setter=
- **`option_{index}/values`** `PackedStringArray` = `PackedStringArray()`
  - 其它属性：getter= · setter=
- **`overwrite_warning_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`recent_list_enabled`** `bool` = `true`
  - 其它属性：getter=is_customization_flag_enabled · setter=set_customization_flag_enabled
- **`root_subfolder`** `String` = `""`
  - 其它属性：getter=get_root_subfolder · setter=set_root_subfolder
- **`show_hidden_files`** `bool` = `false`
  - 其它属性：getter=is_showing_hidden_files · setter=set_show_hidden_files
- **`size`** `Vector2i` = `Vector2i(640, 360)`
  - 其它属性：getter=get_size · overrides=Window · setter=set_size
- **`title`** `String` = `"Save a File"`
  - 其它属性：getter=get_title · overrides=Window · setter=set_title
- **`use_native_dialog`** `bool` = `false`
  - 其它属性：getter=get_use_native_dialog · setter=set_use_native_dialog

## 方法

### `add_filter(filter: String, description: String = "", mime_type: String = "") -> void`

Adds a comma-separated file extension `filter` and comma-separated MIME type `mime_type` option to the `FileDialog` with an optional `description`, which restricts what files can be picked.
				A `filter` should be of the form `"filename.extension"`, where filename and extension can be `*` to match any string. Filters starting with `.` (i.e. empty filenames) are not allowed.
				For example, a `filter` of `"*.png, *.jpg"`, a `mime_type` of `image/png, image/jpeg`, and a `description` of `"Images"` results in filter text "Images (*.png, *.jpg)".
				**Note:** Embedded file dialogs and Windows file dialogs support only file extensions, while Android, Linux, and macOS file dialogs also support MIME types.

### `add_option(name: String, values: PackedStringArray, default_value_index: int) -> void`

Adds an additional `OptionButton` to the file dialog. If `values` is empty, a `CheckBox` is added instead.
				`default_value_index` should be an index of the value in the `values`. If `values` is empty it should be either `1` (checked), or `0` (unchecked).

### `clear_filename_filter() -> void`

Clear the filter for file names.

### `clear_filters() -> void`

Clear all the added filters in the dialog.

### `deselect_all() -> void`

Clear all currently selected items in the dialog.

### `get_favorite_list() -> PackedStringArray`
- 限定：qualifiers=static

Returns the list of favorite directories, which is shared by all `FileDialog` nodes. Useful to store the list of favorites between project sessions. This method can be called only from the main thread.

### `get_line_edit() -> LineEdit`

Returns the LineEdit for the selected file.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.

### `get_option_default(option: int) -> int`
- 限定：qualifiers=const

Returns the default value index of the `OptionButton` or `CheckBox` with index `option`.

### `get_option_name(option: int) -> String`
- 限定：qualifiers=const

Returns the name of the `OptionButton` or `CheckBox` with index `option`.

### `get_option_values(option: int) -> PackedStringArray`
- 限定：qualifiers=const

Returns an array of values of the `OptionButton` with index `option`.

### `get_recent_list() -> PackedStringArray`
- 限定：qualifiers=static

Returns the list of recent directories, which is shared by all `FileDialog` nodes. Useful to store the list of recents between project sessions. This method can be called only from the main thread.

### `get_selected_options() -> Dictionary`
- 限定：qualifiers=const

Returns a `Dictionary` with the selected values of the additional `OptionButton`s and/or `CheckBox`es. `Dictionary` keys are names and values are selected value indices.

### `get_vbox() -> VBoxContainer`

Returns the vertical box container of the dialog, custom controls can be added to it.
				**Warning:** This is a required internal node, removing and freeing it may cause a crash. If you wish to hide it or any of its children, use their `CanvasItem.visible` property.
				**Note:** Changes to this node are ignored by native file dialogs, use `add_option` to add custom elements to the dialog instead.

### `invalidate() -> void`

Invalidates and updates this dialog's content list.
				**Note:** This method does nothing on native file dialogs.

### `is_customization_flag_enabled(flag: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the provided `flag` is enabled.

### `popup_file_dialog() -> void`

Shows the `FileDialog` using the default size and position for file dialogs, and selects the file name if there is a current file.

### `set_customization_flag_enabled(flag: int, enabled: bool) -> void`

Sets the specified customization `flag`, allowing to customize the features available in this `FileDialog`.

### `set_favorite_list(favorites: PackedStringArray) -> void`
- 限定：qualifiers=static

Sets the list of favorite directories, which is shared by all `FileDialog` nodes. Useful to restore the list of favorites saved with `get_favorite_list`. This method can be called only from the main thread.
				**Note:** `FileDialog` will update its internal `ItemList` of favorites when its visibility changes. Be sure to call this method earlier if you want your changes to have effect.

### `set_get_icon_callback(callback: Callable) -> void`
- 限定：qualifiers=static

Sets the callback used by the `FileDialog` nodes to get a file icon, when `DISPLAY_LIST` mode is used. The callback should take a single `String` argument (file path), and return a `Texture2D`. If an invalid texture is returned, the `file` icon will be used instead.

### `set_get_thumbnail_callback(callback: Callable) -> void`
- 限定：qualifiers=static

Sets the callback used by the `FileDialog` nodes to get a file icon, when `DISPLAY_THUMBNAILS` mode is used. The callback should take a single `String` argument (file path), and return a `Texture2D`. If an invalid texture is returned, the `file_thumbnail` icon will be used instead.
				Thumbnails are usually more complex and may take a while to load. To avoid stalling the application, you can use `ImageTexture` to asynchronously create the thumbnail.
				
```gdscript
				func _ready():
					FileDialog.set_get_thumbnail_callback(thumbnail_method)

				func thumbnail_method(path):
					var image_texture = ImageTexture.new()
					make_thumbnail_async(path, image_texture)
					return image_texture

				func make_thumbnail_async(path, image_texture):
					var thumbnail_texture = await generate_thumbnail(path) # Some method that generates a thumbnail.
					image_texture.set_image(thumbnail_texture.get_image())
				
```

### `set_option_default(option: int, default_value_index: int) -> void`

Sets the default value index of the `OptionButton` or `CheckBox` with index `option`.

### `set_option_name(option: int, name: String) -> void`

Sets the name of the `OptionButton` or `CheckBox` with index `option`.

### `set_option_values(option: int, values: PackedStringArray) -> void`

Sets the option values of the `OptionButton` with index `option`.

### `set_recent_list(recents: PackedStringArray) -> void`
- 限定：qualifiers=static

Sets the list of recent directories, which is shared by all `FileDialog` nodes. Useful to restore the list of recents saved with `set_recent_list`. This method can be called only from the main thread.
				**Note:** `FileDialog` will update its internal `ItemList` of recent directories when its visibility changes. Be sure to call this method earlier if you want your changes to have effect.

## 信号

### `dir_selected(dir: String)`

Emitted when the user selects a directory.

### `file_selected(path: String)`

Emitted when the user selects a file by double-clicking it or pressing the **OK** button.

### `filename_filter_changed(filter: String)`

Emitted when the filter for file names changes.

### `files_selected(paths: PackedStringArray)`

Emitted when the user selects multiple files.

## 枚举

### `FileMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FILE_MODE_OPEN_FILE` |  |
| `1` | `FILE_MODE_OPEN_FILES` |  |
| `2` | `FILE_MODE_OPEN_DIR` |  |
| `3` | `FILE_MODE_OPEN_ANY` |  |
| `4` | `FILE_MODE_SAVE_FILE` |  |

### `Access`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `ACCESS_RESOURCES` |  |
| `1` | `ACCESS_USERDATA` |  |
| `2` | `ACCESS_FILESYSTEM` |  |

### `DisplayMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DISPLAY_THUMBNAILS` |  |
| `1` | `DISPLAY_LIST` |  |

### `Customization`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `CUSTOMIZATION_HIDDEN_FILES` |  |
| `1` | `CUSTOMIZATION_CREATE_FOLDER` |  |
| `2` | `CUSTOMIZATION_FILE_FILTER` |  |
| `3` | `CUSTOMIZATION_FILE_SORT` |  |
| `4` | `CUSTOMIZATION_FAVORITES` |  |
| `5` | `CUSTOMIZATION_RECENT` |  |
| `6` | `CUSTOMIZATION_LAYOUT` |  |
| `7` | `CUSTOMIZATION_OVERWRITE_WARNING` |  |
| `8` | `CUSTOMIZATION_DELETE` |  |

## 主题属性

### `file_disabled_color`
- data_type=color · default=Color(1, 1, 1, 0.25) · type=Color

### `file_icon_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `folder_icon_color`
- data_type=color · default=Color(1, 1, 1, 1) · type=Color

### `thumbnail_size`
- data_type=constant · default=64 · type=int

### `back_folder`
- data_type=icon · type=Texture2D

### `create_folder`
- data_type=icon · type=Texture2D

### `favorite`
- data_type=icon · type=Texture2D

### `favorite_down`
- data_type=icon · type=Texture2D

### `favorite_up`
- data_type=icon · type=Texture2D

### `file`
- data_type=icon · type=Texture2D

### `file_thumbnail`
- data_type=icon · type=Texture2D

### `folder`
- data_type=icon · type=Texture2D

### `folder_thumbnail`
- data_type=icon · type=Texture2D

### `forward_folder`
- data_type=icon · type=Texture2D

### `list_mode`
- data_type=icon · type=Texture2D

### `menu_copy_path`
- data_type=icon · type=Texture2D

### `menu_delete`
- data_type=icon · type=Texture2D

### `menu_new_folder`
- data_type=icon · type=Texture2D

### `menu_open_bundle`
- data_type=icon · type=Texture2D

### `menu_refresh`
- data_type=icon · type=Texture2D

### `menu_show_in_file_manager`
- data_type=icon · type=Texture2D

### `parent_folder`
- data_type=icon · type=Texture2D

### `reload`
- data_type=icon · type=Texture2D

### `sort`
- data_type=icon · type=Texture2D

### `thumbnail_mode`
- data_type=icon · type=Texture2D

### `toggle_filename_filter`
- data_type=icon · type=Texture2D

### `toggle_hidden`
- data_type=icon · type=Texture2D

