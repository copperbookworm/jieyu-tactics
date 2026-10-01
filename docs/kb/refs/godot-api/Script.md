# Script

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`Script` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/Script.md`

**摘要**：A class stored as a resource.

## 描述

A class stored as a resource. A script extends the functionality of all objects that instantiate it.
		This is the base class for all scripts and should not be used directly. Trying to create a new script with this class will result in an error.
		The `new` method of a script subclass creates a new instance. `Object.set_script` extends an existing object, if that object's class matches one of the script's base classes.

## 属性

- **`source_code`** `String`
  - 其它属性：getter=get_source_code · setter=set_source_code

## 方法

### `can_instantiate() -> bool`
- 限定：qualifiers=const

Returns `true` if the script can be instantiated.

### `get_base_script() -> Script`
- 限定：qualifiers=const

Returns the script directly inherited by this script.

### `get_global_name() -> StringName`
- 限定：qualifiers=const

Returns the class name associated with the script, if there is one. Returns an empty string otherwise.
				To give the script a global name, you can use the `class_name` keyword in GDScript and the ``GlobalClass`` attribute in C#.
				`codeblocks`
				`gdscript`
				class_name MyNode
				extends Node
				
				`csharp`
				using Godot;

				`GlobalClass`
				public partial class MyNode : Node
				{
				}

### `get_instance_base_type() -> StringName`
- 限定：qualifiers=const

Returns the script's base type.

### `get_property_default_value(property: StringName) -> Variant`

Returns the default value of the specified property.

### `get_rpc_config() -> Variant`
- 限定：qualifiers=const

Returns a `Dictionary` mapping method names to their RPC configuration defined by this script.

### `get_script_constant_map() -> Dictionary`

Returns a dictionary containing constant names and their values.

### `get_script_method_list() -> Dictionary[]`

Returns the list of methods in this `Script`.
				**Note:** The dictionaries returned by this method are formatted identically to those returned by `Object.get_method_list`.

### `get_script_property_list() -> Dictionary[]`

Returns the list of properties in this `Script`.
				**Note:** The dictionaries returned by this method are formatted identically to those returned by `Object.get_property_list`.

### `get_script_signal_list() -> Dictionary[]`

Returns the list of signals defined in this `Script`.
				**Note:** The dictionaries returned by this method are formatted identically to those returned by `Object.get_signal_list`.

### `has_script_method(method_name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the script, or a base class, defines a method with the given name.

### `has_script_signal(signal_name: StringName) -> bool`
- 限定：qualifiers=const

Returns `true` if the script, or a base class, defines a signal with the given name.

### `has_source_code() -> bool`
- 限定：qualifiers=const

Returns `true` if the script contains non-empty source code.
				**Note:** If a script does not have source code, this does not mean that it is invalid or unusable. For example, a `GDScript` that was exported with binary tokenization has no source code, but still behaves as expected and could be instantiated. This can be checked with `can_instantiate`.

### `instance_has(base_object: Object) -> bool`
- 限定：deprecated=Compare this script with [method Object.get_script] instead. · qualifiers=const

Returns `true` if `base_object` is an instance of this script.

### `is_abstract() -> bool`
- 限定：qualifiers=const

Returns `true` if the script is an abstract script. An abstract script does not have a constructor and cannot be instantiated.

### `is_tool() -> bool`
- 限定：qualifiers=const

Returns `true` if the script is a tool script. A tool script can run in the editor.

### `reload(keep_state: bool = false) -> int`

Reloads the script's class implementation. Returns an error code.

## 教程链接

- [Scripting documentation index](None)

