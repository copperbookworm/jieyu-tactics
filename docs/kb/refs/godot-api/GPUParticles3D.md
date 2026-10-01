# GPUParticles3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`GPUParticles3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/GPUParticles3D.md`

**摘要**：A 3D particle emitter.

## 描述

3D particle node used to create a variety of particle systems and effects. `GPUParticles3D` features an emitter that generates some number of particles at a given rate.
		Use `process_material` to add a `ParticleProcessMaterial` to configure particle appearance and behavior. Alternatively, you can add a `ShaderMaterial` which will be applied to all particles.

## 属性

- **`amount`** `int` = `8`
  - 其它属性：getter=get_amount · setter=set_amount
- **`amount_ratio`** `float` = `1.0`
  - 其它属性：getter=get_amount_ratio · setter=set_amount_ratio
- **`collision_base_size`** `float` = `0.01`
  - 其它属性：getter=get_collision_base_size · setter=set_collision_base_size
- **`draw_order`** `int` = `0` · 枚举 `GPUParticles3D.DrawOrder`
  - 其它属性：getter=get_draw_order · setter=set_draw_order
- **`draw_pass_1`** `Mesh`
  - 其它属性：getter=get_draw_pass_mesh · setter=set_draw_pass_mesh
- **`draw_pass_2`** `Mesh`
  - 其它属性：getter=get_draw_pass_mesh · setter=set_draw_pass_mesh
- **`draw_pass_3`** `Mesh`
  - 其它属性：getter=get_draw_pass_mesh · setter=set_draw_pass_mesh
- **`draw_pass_4`** `Mesh`
  - 其它属性：getter=get_draw_pass_mesh · setter=set_draw_pass_mesh
- **`draw_passes`** `int` = `1`
  - 其它属性：getter=get_draw_passes · setter=set_draw_passes
- **`draw_skin`** `Skin`
  - 其它属性：getter=get_skin · setter=set_skin
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
- **`trail_enabled`** `bool` = `false`
  - 其它属性：getter=is_trail_enabled · setter=set_trail_enabled
- **`trail_lifetime`** `float` = `0.3`
  - 其它属性：getter=get_trail_lifetime · setter=set_trail_lifetime
- **`transform_align`** `int` = `0` · 枚举 `GPUParticles3D.TransformAlign`
  - 其它属性：getter=get_transform_align · setter=set_transform_align
- **`transform_align_axis`** `int` · 枚举 `RenderingServer.ParticlesTransformAlignAxis`
  - 其它属性：getter=get_transform_align_axis · setter=set_transform_align_axis
- **`transform_align_channel_filter`** `int` · 枚举 `RenderingServer.ParticlesTransformAlignCustomSrc`
  - 其它属性：getter=get_transform_align_channel_filter · setter=set_transform_align_channel_filter
- **`use_fixed_seed`** `bool` = `false`
  - 其它属性：getter=get_use_fixed_seed · setter=set_use_fixed_seed
- **`visibility_aabb`** `AABB` = `AABB(-4, -4, -4, 8, 8, 8)`
  - 其它属性：getter=get_visibility_aabb · setter=set_visibility_aabb

## 方法

### `capture_aabb() -> AABB`
- 限定：qualifiers=const

Returns the axis-aligned bounding box that contains all the particles that are active in the current frame.

### `convert_from_particles(particles: Node) -> void`

Sets this node's properties to match a given `CPUParticles3D` node.

### `emit_particle(xform: Transform3D, velocity: Vector3, color: Color, custom: Color, flags: int) -> void`

Emits a single particle. Whether `xform`, `velocity`, `color` and `custom` are applied depends on the value of `flags`. See `EmitFlags`.
				The default ParticleProcessMaterial will overwrite `color` and use the contents of `custom` as `(rotation, age, animation, lifetime)`.
				**Note:** `emit_particle` is only supported on the Forward+ and Mobile rendering methods, not Compatibility.

### `get_draw_pass_mesh(pass: int) -> Mesh`
- 限定：qualifiers=const

Returns the `Mesh` that is drawn at index `pass`.

### `request_particles_process(process_time: float, process_time_residual: float = 0.0) -> void`

Requests the particles to process for extra process time during a single frame.
				`process_time` defines the time that the particles will process while emitting is on. `process_time_residual` defines the time that particles will process with emitting turned off for the simulation. When combined with `speed_scale` set to `0.0`, this is useful to be able to seek a particle system timeline.

### `restart(keep_seed: bool = false) -> void`

Restarts the particle emission cycle, clearing existing particles. To avoid particles vanishing from the viewport, wait for the `finished` signal before calling.
				**Note:** The `finished` signal is only emitted by `one_shot` emitters.
				If `keep_seed` is `true`, the current random seed will be preserved. Useful for seeking and playback.

### `set_draw_pass_mesh(pass: int, mesh: Mesh) -> void`

Sets the `Mesh` that is drawn at index `pass`.

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
| `3` | `DRAW_ORDER_VIEW_DEPTH` |  |

### `EmitFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `EMIT_FLAG_POSITION` |  |
| `2` | `EMIT_FLAG_ROTATION_SCALE` |  |
| `4` | `EMIT_FLAG_VELOCITY` |  |
| `8` | `EMIT_FLAG_COLOR` |  |
| `16` | `EMIT_FLAG_CUSTOM` |  |

### `TransformAlign`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TRANSFORM_ALIGN_DISABLED` |  |
| `1` | `TRANSFORM_ALIGN_Z_BILLBOARD` |  |
| `2` | `TRANSFORM_ALIGN_Y_TO_VELOCITY` |  |
| `3` | `TRANSFORM_ALIGN_Z_BILLBOARD_Y_TO_VELOCITY` |  |
| `4` | `TRANSFORM_ALIGN_LOCAL_BILLBOARD` |  |

## 常量

- **`MAX_DRAW_PASSES`** = `4`
## 教程链接

- [Particle systems (3D)](None)
- [Controlling thousands of fish with Particles](None)
- [Third Person Shooter (TPS) Demo](None)

