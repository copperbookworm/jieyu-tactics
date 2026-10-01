# EditorFeatureProfile

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorFeatureProfile` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorFeatureProfile.md`

**摘要**：An editor feature profile which can be used to disable specific features.

## 描述

An editor feature profile can be used to disable specific features of the Godot editor. When disabled, the features won't appear in the editor, which makes the editor less cluttered. This is useful in education settings to reduce confusion or when working in a team. For example, artists and level designers could use a feature profile that disables the script editor to avoid accidentally making changes to files they aren't supposed to edit.
		To manage editor feature profiles visually, use **Editor > Manage Feature Profiles...** at the top of the editor window.

## 方法

### `get_feature_name(feature: int) -> String`

Returns the specified `feature`'s human-readable name.

### `is_class_disabled(class_name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the class specified by `class_name` is disabled. When disabled, the class won't appear in the Create New Node dialog.

### `is_class_editor_disabled(class_name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if editing for the class specified by `class_name` is disabled. When disabled, the class will still appear in the Create New Node dialog but the Inspector will be read-only when selecting a node that extends the class.

### `is_class_property_disabled(class_name: StringName, property: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if `property` is disabled in the class specified by `class_name`. When a property is disabled, it won't appear in the Inspector when selecting a node that extends the class specified by `class_name`.

### `is_feature_disabled(feature: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the `feature` is disabled. When a feature is disabled, it will disappear from the editor entirely.

### `load_from_file(path: String) -> int`

Loads an editor feature profile from a file. The file must follow the JSON format obtained by using the feature profile manager's **Export** button or the `save_to_file` method.
				**Note:** Feature profiles created via the user interface are loaded from the `feature_profiles` directory, as a file with the `.profile` extension. The editor configuration folder can be found by using `EditorPaths.get_config_dir`.

### `save_to_file(path: String) -> int`

Saves the editor feature profile to a file in JSON format. It can then be imported using the feature profile manager's **Import** button or the `load_from_file` method.
				**Note:** Feature profiles created via the user interface are saved in the `feature_profiles` directory, as a file with the `.profile` extension. The editor configuration folder can be found by using `EditorPaths.get_config_dir`.

### `set_disable_class(class_name: StringName, disable: bool) -> void`

If `disable` is `true`, disables the class specified by `class_name`. When disabled, the class won't appear in the Create New Node dialog.

### `set_disable_class_editor(class_name: StringName, disable: bool) -> void`

If `disable` is `true`, disables editing for the class specified by `class_name`. When disabled, the class will still appear in the Create New Node dialog but the Inspector will be read-only when selecting a node that extends the class.

### `set_disable_class_property(class_name: StringName, property: StringName, disable: bool) -> void`

If `disable` is `true`, disables editing for `property` in the class specified by `class_name`. When a property is disabled, it won't appear in the Inspector when selecting a node that extends the class specified by `class_name`.

### `set_disable_feature(feature: int, disable: bool) -> void`

If `disable` is `true`, disables the editor feature specified in `feature`. When a feature is disabled, it will disappear from the editor entirely.

## 枚举

### `Feature`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FEATURE_3D` |  |
| `1` | `FEATURE_SCRIPT` |  |
| `2` | `FEATURE_ASSET_LIB` |  |
| `3` | `FEATURE_SCENE_TREE` |  |
| `4` | `FEATURE_NODE_DOCK` |  |
| `5` | `FEATURE_FILESYSTEM_DOCK` |  |
| `6` | `FEATURE_IMPORT_DOCK` |  |
| `7` | `FEATURE_HISTORY_DOCK` |  |
| `8` | `FEATURE_GAME` |  |
| `9` | `FEATURE_SIGNALS_DOCK` |  |
| `10` | `FEATURE_GROUPS_DOCK` |  |
| `11` | `FEATURE_MAX` |  |

