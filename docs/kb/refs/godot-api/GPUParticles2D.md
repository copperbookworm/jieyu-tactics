# GPUParticles2D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticles2D` → `Node2D` → `CanvasItem` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticles2D.md`

**摘要**：A 2D particle emitter.

## 描述

2D particle node used to create a variety of particle systems and effects. `GPUParticles2D` features an emitter that generates some number of particles at a given rate.
		Use the `process_material` property to add a `ParticleProcessMaterial` to configure particle appearance and behavior. Alternatively, you can add a `ShaderMaterial` which will be applied to all particles.
		2D particles can optionally collide with `LightOccluder2D`, but they don't collide with `PhysicsBody2D` nodes.

## 属性

- **`amount`** `int` = `8`
  - 其它属性：getter=get_amount · setter=set_amount
- **`amount_ratio`** `float` = `1.0`
  - 其它属性：getter=get_amount_ratio · setter=set_amount_ratio
- **`collision_base_size`** `float` = `1.0`
  - 其它属性：getter=get_collision_base_size · setter=set_collision_base_size
- **`draw_order`** `int` = `1` · 枚举 `GPUParticles2D.DrawOrder`
  - 其它属性：getter=get_draw_order · setter=set_draw_order
- **`emitting`** `bool` = `true`
  - 其它属性：getter=is_emitting · setter=set_emitting
- **`explosiveness`** `float` = `0.0`
  - 其它属性：getter=get_explosiveness_ratio · setter=set_explosiveness_ratio
- **`fixed_fps`** `int` = `30`
  - 其它属性：getter=get_fixed_fps · setter=set_fixed_fps
- **`fract_delta`** `bool` = `true`
  - 其它属性：getter=get_fractional_delta · setter=set_fractional_delta
- **`interp_to_end`** `float` = `0.0`
  - 其它属性：getter=get_interp_to_end · setter=set_interp_to_end
- **`interpolate`** `bool` = `true`
  - 其它属性：getter=get_interpolate · setter=set_interpolate
- **`lifetime`** `float` = `1.0`
  - 其它属性：getter=get_lifetime · setter=set_lifetime
- **`local_coords`** `bool` = `false`
  - 其它属性：getter=get_use_local_coordinates · setter=set_use_local_coordinates
- **`one_shot`** `bool` = `false`
  - 其它属性：getter=get_one_shot · setter=set_one_shot
- **`preprocess`** `float` = `0.0`
  - 其它属性：getter=get_pre_process_time · setter=set_pre_process_time
- **`process_material`** `Material`
  - 其它属性：getter=get_process_material · setter=set_process_material
- **`randomness`** `float` = `0.0`
  - 其它属性：getter=get_randomness_ratio · setter=set_randomness_ratio
- **`seed`** `int` = `0`
  - 其它属性：getter=get_seed · setter=set_seed
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale
- **`sub_emitter`** `NodePath` = `NodePath("")`
  - 其它属性：getter=get_sub_emitter · setter=set_sub_emitter
- **`texture`** `Texture2D`
  - 其它属性：getter=get_texture · setter=set_texture
- **`trail_enabled`** `bool` = `false`
  - 其它属性：getter=is_trail_enabled · setter=set_trail_enabled
- **`trail_lifetime`** `float` = `0.3`
  - 其它属性：getter=get_trail_lifetime · setter=set_trail_lifetime
- **`trail_section_subdivisions`** `int` = `4`
  - 其它属性：getter=get_trail_section_subdivisions · setter=set_trail_section_subdivisions
- **`trail_sections`** `int` = `8`
  - 其它属性：getter=get_trail_sections · setter=set_trail_sections
- **`use_fixed_seed`** `bool` = `false`
  - 其它属性：getter=get_use_fixed_seed · setter=set_use_fixed_seed
- **`visibility_rect`** `Rect2` = `Rect2(-100, -100, 200, 200)`
  - 其它属性：getter=get_visibility_rect · setter=set_visibility_rect

## 方法

### `capture_rect() -> Rect2`
- 限定：qualifiers=const

Returns a rectangle containing the positions of all existing particles.
				**Note:** When using threaded rendering this method synchronizes the rendering thread. Calling it often may have a negative impact on performance.

### `convert_from_particles(particles: Node) -> void`

Sets this node's properties to match a given `CPUParticles2D` node.

### `emit_particle(xform: Transform2D, velocity: Vector2, color: Color, custom: Color, flags: int) -> void`

Emits a single particle. Whether `xform`, `velocity`, `color` and `custom` are applied depends on the value of `flags`. See `EmitFlags`.
				The default ParticleProcessMaterial will overwrite `color` and use the contents of `custom` as `(rotation, age, animation, lifetime)`.
				**Note:** `emit_particle` is only supported on the Forward+ and Mobile rendering methods, not Compatibility.

### `request_particles_process(process_time: float, process_time_residual: float = 0) -> void`

Requests the particles to process for extra process time during a single frame.
				`process_time` defines the time that the particles will process while emitting is on. `process_time_residual` defines the time that particles will process with emitting turned off for the simulation. When combined with `speed_scale` set to `0.0`, this is useful to be able to seek a particle system timeline.

### `restart(keep_seed: bool = false) -> void`

Restarts the particle emission cycle, clearing existing particles. To avoid particles vanishing from the viewport, wait for the `finished` signal before calling.
				**Note:** The `finished` signal is only emitted by `one_shot` emitters.
				If `keep_seed` is `true`, the current random seed will be preserved. Useful for seeking and playback.

## 信号

### `finished()`

Emitted when all active particles have finished processing. To immediately restart the emission cycle, call `restart`.
				This signal is never emitted when `one_shot` is disabled, as particles will be emitted and processed continuously.
				**Note:** For `one_shot` emitters, due to the particles being computed on the GPU, there may be a short period after receiving the signal during which setting `emitting` to `true` will not restart the emission cycle. This delay is avoided by instead calling `restart`.

## 枚举

### `DrawOrder`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAW_ORDER_INDEX` |  |
| `1` | `DRAW_ORDER_LIFETIME` |  |
| `2` | `DRAW_ORDER_REVERSE_LIFETIME` |  |

### `EmitFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `EMIT_FLAG_POSITION` |  |
| `2` | `EMIT_FLAG_ROTATION_SCALE` |  |
| `4` | `EMIT_FLAG_VELOCITY` |  |
| `8` | `EMIT_FLAG_COLOR` |  |
| `16` | `EMIT_FLAG_CUSTOM` |  |

## 教程链接

- [Particle systems (2D)](None)
- [2D Particles Demo](None)
- [2D Dodge The Creeps Demo (uses GPUParticles2D for the trail behind the player)](None)

