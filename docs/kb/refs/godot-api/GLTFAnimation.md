# GLTFAnimation

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GLTFAnimation` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GLTFAnimation.md`

## 属性

- **`loop`** `bool` = `false`
  - 其它属性：getter=get_loop · setter=set_loop
- **`original_name`** `String` = `""`
  - 其它属性：getter=get_original_name · setter=set_original_name

## 方法

### `get_additional_data(extension_name: StringName) -> Variant`

Gets additional arbitrary data in this `GLTFAnimation` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the return value can be anything you set. If nothing was set, the return value is `null`.

### `set_additional_data(extension_name: StringName, additional_data: Variant) -> void`

Sets additional arbitrary data in this `GLTFAnimation` instance. This can be used to keep per-node state data in `GLTFDocumentExtension` classes, which is important because they are stateless.
				The first argument should be the `GLTFDocumentExtension` name (does not have to match the extension name in the glTF file), and the second argument can be anything you want.

## 教程链接

- [Runtime file loading and saving](None)

