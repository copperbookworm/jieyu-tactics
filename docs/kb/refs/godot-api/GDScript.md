# GDScript

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GDScript` → `Script` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GDScript.md`

**摘要**：A script implemented in the GDScript programming language.

## 描述

A script implemented in the GDScript programming language, saved with the `.gd` extension. The script extends the functionality of all objects that instantiate it.
		Calling `new` creates a new instance of the script. `Object.set_script` extends an existing object, if that object's class matches one of the script's base classes.
		If you are looking for GDScript's built-in functions, see `@GDScript` instead.

## 方法

### `new() -> Variant`
- 限定：qualifiers=vararg

Returns a new instance of the script.
				
```gdscript
				var MyClass = load("myclass.gd")
				var instance = MyClass.new()
				print(instance.get_script() == MyClass) # Prints true
				
```

## 教程链接

- [GDScript documentation index](None)

