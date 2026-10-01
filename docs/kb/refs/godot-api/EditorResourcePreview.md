# EditorResourcePreview

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorResourcePreview` → `Node` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorResourcePreview.md`

**摘要**：A node used to generate previews of resources or files.

## 描述

This node is used to generate previews for resources or files.
		**Note:** This class shouldn't be instantiated directly. Instead, access the singleton using `EditorInterface.get_resource_previewer`.

## 方法

### `add_preview_generator(generator: EditorResourcePreviewGenerator) -> void`

Create an own, custom preview generator.

### `check_for_invalidation(path: String) -> void`

Check if the resource changed, if so, it will be invalidated and the corresponding signal emitted.

### `queue_edited_resource_preview(resource: Resource, receiver: Object, receiver_func: StringName, userdata: Variant) -> void`

Queue the `resource` being edited for preview. Once the preview is ready, the `receiver`'s `receiver_func` will be called. The `receiver_func` must take the following four arguments: `String` path, `Texture2D` preview, `Texture2D` thumbnail_preview, `Variant` userdata. `userdata` can be anything, and will be returned when `receiver_func` is called.
				**Note:** If it was not possible to create the preview the `receiver_func` will still be called, but the preview will be `null`.

### `queue_resource_preview(path: String, receiver: Object, receiver_func: StringName, userdata: Variant) -> void`

Queue a resource file located at `path` for preview. Once the preview is ready, the `receiver`'s `receiver_func` will be called. The `receiver_func` must take the following four arguments: `String` path, `Texture2D` preview, `Texture2D` thumbnail_preview, `Variant` userdata. `userdata` can be anything, and will be returned when `receiver_func` is called.
				**Note:** If it was not possible to create the preview the `receiver_func` will still be called, but the preview will be `null`.

### `remove_preview_generator(generator: EditorResourcePreviewGenerator) -> void`

Removes a custom preview generator.

## 信号

### `preview_invalidated(path: String)`

Emitted if a preview was invalidated (changed). `path` corresponds to the path of the preview.

