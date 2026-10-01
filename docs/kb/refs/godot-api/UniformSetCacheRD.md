# UniformSetCacheRD

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`UniformSetCacheRD` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/UniformSetCacheRD.md`

**摘要**：Uniform set cache manager for Rendering Device based renderers.

## 描述

Uniform set cache manager for `RenderingDevice`-based renderers. Provides a way to create a uniform set and reuse it in subsequent calls for as long as the uniform set exists. Uniform set will automatically be cleaned up when dependent objects are freed.

## 方法

### `get_cache(shader: RID, set: int, uniforms: RDUniform[]) -> RID`
- 限定：qualifiers=static

Creates/returns a cached uniform set based on the provided uniforms for a given shader.

