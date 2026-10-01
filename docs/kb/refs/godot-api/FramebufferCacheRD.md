# FramebufferCacheRD

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`FramebufferCacheRD` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/FramebufferCacheRD.md`

**摘要**：Framebuffer cache manager for Rendering Device based renderers.

## 描述

Framebuffer cache manager for `RenderingDevice`-based renderers. Provides a way to create a framebuffer and reuse it in subsequent calls for as long as the used textures exists. Framebuffers will automatically be cleaned up when dependent objects are freed.

## 方法

### `get_cache_multipass(textures: RID[], passes: RDFramebufferPass[], views: int) -> RID`
- 限定：qualifiers=static

Creates, or obtains a cached, framebuffer. `textures` lists textures accessed. `passes` defines the subpasses and texture allocation, if left empty a single pass is created and textures are allocated depending on their usage flags. `views` defines the number of views used when rendering.

