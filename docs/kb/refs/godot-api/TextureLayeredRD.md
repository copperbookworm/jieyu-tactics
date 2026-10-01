# TextureLayeredRD

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`TextureLayeredRD` → `TextureLayered` → `Texture` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/TextureLayeredRD.md`

**摘要**：Abstract base class for layered texture RD types.

## 描述

Base class for `Texture2DArrayRD`, `TextureCubemapRD` and `TextureCubemapArrayRD`. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types.
		**Note:** `TextureLayeredRD` is intended for low-level usage with `RenderingDevice`. For most use cases, use `TextureLayered` instead.

## 属性

- **`texture_rd_rid`** `RID`
  - 其它属性：getter=get_texture_rd_rid · setter=set_texture_rd_rid

## 教程链接

- [Compute Texture demo](None)

