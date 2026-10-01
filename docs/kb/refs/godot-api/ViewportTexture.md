# ViewportTexture

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ViewportTexture` → `Texture2D` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ViewportTexture.md`

**摘要**：Provides the content of a `Viewport` as a dynamic texture.

## 描述

A `ViewportTexture` provides the content of a `Viewport` as a dynamic `Texture2D`. This can be used to combine the rendering of `Control`, `Node2D` and `Node3D` nodes. For example, you can use this texture to display a 3D scene inside a `TextureRect`, or a 2D overlay in a `Sprite3D`.
		To get a `ViewportTexture` in code, use the `Viewport.get_texture` method on the target viewport.
		**Note:** A `ViewportTexture` is always local to its scene (see `Resource.resource_local_to_scene`). If the scene root is not ready, it may return incorrect data (see `Node.ready`).
		**Note:** Instantiating scenes containing a high-resolution `ViewportTexture` may cause noticeable stutter.
		**Note:** When using a `Viewport` with `Viewport.use_hdr_2d` set to `true`, the returned texture will be an HDR image that uses linear encoding. This may look darker than normal when displayed directly on screen. To convert to nonlinear sRGB encoding, you can do the following:
		
```gdscript
		img.convert(Image.FORMAT_RGBA8)
		img.linear_to_srgb()
		
```

		**Note:** Some nodes such as `Decal`, `Light3D`, and `PointLight2D` do not support using `ViewportTexture` directly. To use texture data from a `ViewportTexture` in these nodes, you need to create an `ImageTexture` by calling `Texture2D.get_image` on the `ViewportTexture` and passing the result to `ImageTexture.create_from_image`. This conversion is a slow operation, so it should not be performed every frame.

## 属性

- **`viewport_path`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_viewport_path_in_scene · setter=set_viewport_path_in_scene

## 教程链接

- [GUI in 3D Viewport Demo](None)
- [3D in 2D Viewport Demo](None)
- [2D in 3D Viewport Demo](None)
- [3D Resolution Scaling Demo](None)

