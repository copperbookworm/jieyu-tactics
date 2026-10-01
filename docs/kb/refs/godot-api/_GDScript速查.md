# GDScript 速查（Godot 4.7.1）

> 自动生成，勿手改。完整描述、参数说明见 `refs/godot-api/@GDScript.md`。
> 生成于 2026-09-14 11:40 · 注解 36 条 / 内置函数 16 个 / 常量 4 个
> 用法：查某个注解怎么用 → 先看这里；要细节再读 `@GDScript.md`。

## 注解（36 条）

| 注解 | 说明 |
|---|---|
| `@abstract` | Marks a class or a method as abstract. |
| `@export` | Mark the following property as exported (editable in the Inspector dock and saved to disk). To control the typ… |
| `@export_category` | Define a new category for the following exported properties. This helps to organize properties in the Inspecto… |
| `@export_color_no_alpha` | Export a `Color`, `Array`[`Color`], or `PackedColorArray` property without allowing its transparency (`Color.a… |
| `@export_custom` | Allows you to set a custom hint, hint string, and usage flags for the exported property. Note that there's no … |
| `@export_dir` | Export a `String`, `Array`[`String`], or `PackedStringArray` property as a path to a directory. The path will … |
| `@export_enum` | Export an `int`, `String`, `Array`[`int`], `Array`[`String`], `PackedByteArray`, `PackedInt32Array`, `PackedIn… |
| `@export_exp_easing` | Export a floating-point property with an easing editor widget. Additional hints can be provided to adjust the … |
| `@export_file` | Export a `String`, `Array`[`String`], or `PackedStringArray` property as a path to a file. The path will be li… |
| `@export_file_path` | Same as `@export_file`, except the file will be stored as a raw path. This means that it may become invalid wh… |
| `@export_flags` | Export an integer property as a bit flag field. This allows to store several "checked" or `true` values with o… |
| `@export_flags_2d_navigation` | Export an integer property as a bit flag field for 2D navigation layers. The widget in the Inspector dock will… |
| `@export_flags_2d_physics` | Export an integer property as a bit flag field for 2D physics layers. The widget in the Inspector dock will us… |
| `@export_flags_2d_render` | Export an integer property as a bit flag field for 2D render layers. The widget in the Inspector dock will use… |
| `@export_flags_3d_navigation` | Export an integer property as a bit flag field for 3D navigation layers. The widget in the Inspector dock will… |
| `@export_flags_3d_physics` | Export an integer property as a bit flag field for 3D physics layers. The widget in the Inspector dock will us… |
| `@export_flags_3d_render` | Export an integer property as a bit flag field for 3D render layers. The widget in the Inspector dock will use… |
| `@export_flags_avoidance` | Export an integer property as a bit flag field for navigation avoidance layers. The widget in the Inspector do… |
| `@export_global_dir` | Export a `String`, `Array`[`String`], or `PackedStringArray` property as an absolute path to a directory. The … |
| `@export_global_file` | Export a `String`, `Array`[`String`], or `PackedStringArray` property as an absolute path to a file. The path … |
| `@export_group` | Define a new group for the following exported properties. This helps to organize properties in the Inspector d… |
| `@export_multiline` | Export a `String`, `Array`[`String`], `PackedStringArray`, `Dictionary` or `Array`[`Dictionary`] property with… |
| `@export_node_path` | Export a `NodePath` or `Array`[`NodePath`] property with a filter for allowed node types. |
| `@export_placeholder` | Export a `String`, `Array`[`String`], or `PackedStringArray` property with a placeholder text displayed in the… |
| `@export_range` | Export an `int`, `float`, `Array`[`int`], `Array`[`float`], `PackedByteArray`, `PackedInt32Array`, `PackedInt6… |
| `@export_storage` | Export a property with `PROPERTY_USAGE_STORAGE` flag. The property is not displayed in the editor, but it is s… |
| `@export_subgroup` | Define a new subgroup for the following exported properties. This helps to organize properties in the Inspecto… |
| `@export_tool_button` | Export a `Callable` property as a clickable button with the label `text`. When the button is pressed, the call… |
| `@icon` | Add a custom icon to the current script. The icon specified at `icon_path` is displayed in the Scene dock for … |
| `@onready` | Mark the following property as assigned when the `Node` is ready. Values for these properties are not assigned… |
| `@rpc` | Mark the following method for remote procedure calls. See High-level multiplayer ($DOCS_URL/tutorials/networki… |
| `@static_unload` | Make a script with static variables to not persist after all references are lost. If the script is loaded agai… |
| `@tool` | Mark the current script as a tool script, allowing it to be loaded and executed by the editor. See Running cod… |
| `@warning_ignore` | Mark the following statement to ignore the specified `warning`. See GDScript warning system ($DOCS_URL/tutoria… |
| `@warning_ignore_restore` | Stops ignoring the listed warning types after `@warning_ignore_start`. Ignoring the specified warning types wi… |
| `@warning_ignore_start` | Starts ignoring the listed warning types until the end of the file or the `@warning_ignore_restore` annotation… |

## 内置函数（16 个）

| 函数 | 说明 |
|---|---|
| `Color8(r8: int, g8: int, b8: int, a8: int = 255) -> Color` | Returns a `Color` constructed from red (`r8`), green (`g8`), blue (`b8`), and optionally alpha (`a8`) integer … |
| `assert(condition: bool, message: String = "") -> void` | Asserts that the `condition` is `true`. If the `condition` is `false`, an error is generated and the current m… |
| `char(code: int) -> String` | Returns a single character (as a `String` of length 1) of the given Unicode code point `code`. |
| `convert(what: Variant, type: int) -> Variant` | Converts `what` to `type` in the best way possible. The `type` uses the `Variant.Type` values. |
| `dict_to_inst(dictionary: Dictionary) -> Object` | Converts a `dictionary` (created with `inst_to_dict`) back to an Object instance. Can be useful for deserializ… |
| `get_stack() -> Array` | Returns an array of dictionaries representing the current call stack. |
| `inst_to_dict(instance: Object) -> Dictionary` | Returns the passed `instance` converted to a `Dictionary`. Can be useful for serializing. |
| `is_instance_of(value: Variant, type: Variant) -> bool` | Returns `true` if `value` is an instance of `type`. The `type` value must be one of the following: |
| `len(var: Variant) -> int` | Returns the length of the given Variant `var`. The length can be the character count of a `String` or `StringN… |
| `load(path: String) -> Resource` | Returns a `Resource` from the filesystem located at the absolute `path`. Unless it's already referenced elsewh… |
| `ord(char: String) -> int` | Returns an integer representing the Unicode code point of the given character `char`, which should be a string… |
| `preload(path: String) -> Resource` | Returns a `Resource` from the filesystem located at `path`. During run-time, the resource is loaded when the s… |
| `print_debug() -> void` | Like `@GlobalScope.print`, but includes the current stack frame when running with the debugger turned on. |
| `print_stack() -> void` | Prints a stack trace at the current code location. |
| `range() -> Array` | Returns an array with the given range. `range` can be called in three ways: |
| `type_exists(type: StringName) -> bool` | Returns `true` if the given `Object`-derived class exists in `ClassDB`. Note that `Variant` data types are not… |

## 常量（4 个）

`PI` `TAU` `INF` `NAN`
