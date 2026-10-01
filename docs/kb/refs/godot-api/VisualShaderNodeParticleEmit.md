# VisualShaderNodeParticleEmit

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeParticleEmit` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeParticleEmit.md`

**摘要**：A visual shader node that forces to emit a particle from a sub-emitter.

## 描述

This node internally calls `emit_subparticle` shader method. It will emit a particle from the configured sub-emitter and also allows to customize how its emitted. Requires a sub-emitter assigned to the particles node with this shader.

## 属性

- **`flags`** `int` = `31` · 枚举 `VisualShaderNodeParticleEmit.EmitFlags`
  - 其它属性：getter=get_flags · setter=set_flags

## 枚举

### `EmitFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `EMIT_FLAG_POSITION` |  |
| `2` | `EMIT_FLAG_ROT_SCALE` |  |
| `4` | `EMIT_FLAG_VELOCITY` |  |
| `8` | `EMIT_FLAG_COLOR` |  |
| `16` | `EMIT_FLAG_CUSTOM` |  |

