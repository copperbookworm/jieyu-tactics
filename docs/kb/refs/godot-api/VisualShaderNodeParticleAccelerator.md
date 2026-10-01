# VisualShaderNodeParticleAccelerator

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`VisualShaderNodeParticleAccelerator` → `VisualShaderNode` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/VisualShaderNodeParticleAccelerator.md`

**摘要**：A visual shader node that accelerates particles.

## 描述

Particle accelerator can be used in "process" step of particle shader. It will accelerate the particles. Connect it to the Velocity output port.

## 属性

- **`mode`** `int` = `0` · 枚举 `VisualShaderNodeParticleAccelerator.Mode`
  - 其它属性：getter=get_mode · setter=set_mode

## 枚举

### `Mode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MODE_LINEAR` |  |
| `1` | `MODE_RADIAL` |  |
| `2` | `MODE_TANGENTIAL` |  |
| `3` | `MODE_MAX` |  |

