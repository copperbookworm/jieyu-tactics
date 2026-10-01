# CPUParticles3D

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`CPUParticles3D` → `GeometryInstance3D` → `VisualInstance3D` → `Node3D` → `Node` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/CPUParticles3D.md`

**摘要**：A CPU-based 3D particle emitter.

## 描述

CPU-based 3D particle node used to create a variety of particle systems and effects.
		See also `GPUParticles3D`, which provides the same functionality with hardware acceleration, but may not run on older devices.

## 属性

- **`amount`** `int` = `8`
  - 其它属性：getter=get_amount · setter=set_amount
- **`angle_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`angle_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`angle_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`angular_velocity_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`angular_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`angular_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`anim_offset_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`anim_offset_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`anim_offset_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`anim_speed_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`anim_speed_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`anim_speed_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`color_initial_ramp`** `Gradient`
  - 其它属性：getter=get_color_initial_ramp · setter=set_color_initial_ramp
- **`color_ramp`** `Gradient`
  - 其它属性：getter=get_color_ramp · setter=set_color_ramp
- **`damping_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`damping_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`damping_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`direction`** `Vector3` = `Vector3(1, 0, 0)`
  - 其它属性：getter=get_direction · setter=set_direction
- **`draw_order`** `int` = `0` · 枚举 `CPUParticles3D.DrawOrder`
  - 其它属性：getter=get_draw_order · setter=set_draw_order
- **`emission_box_extents`** `Vector3`
  - 其它属性：getter=get_emission_box_extents · setter=set_emission_box_extents
- **`emission_colors`** `PackedColorArray` = `PackedColorArray()`
  - 其它属性：getter=get_emission_colors · setter=set_emission_colors
- **`emission_normals`** `PackedVector3Array`
  - 其它属性：getter=get_emission_normals · setter=set_emission_normals
- **`emission_points`** `PackedVector3Array`
  - 其它属性：getter=get_emission_points · setter=set_emission_points
- **`emission_ring_axis`** `Vector3`
  - 其它属性：getter=get_emission_ring_axis · setter=set_emission_ring_axis
- **`emission_ring_cone_angle`** `float`
  - 其它属性：getter=get_emission_ring_cone_angle · setter=set_emission_ring_cone_angle
- **`emission_ring_height`** `float`
  - 其它属性：getter=get_emission_ring_height · setter=set_emission_ring_height
- **`emission_ring_inner_radius`** `float`
  - 其它属性：getter=get_emission_ring_inner_radius · setter=set_emission_ring_inner_radius
- **`emission_ring_radius`** `float`
  - 其它属性：getter=get_emission_ring_radius · setter=set_emission_ring_radius
- **`emission_shape`** `int` = `0` · 枚举 `CPUParticles3D.EmissionShape`
  - 其它属性：getter=get_emission_shape · setter=set_emission_shape
- **`emission_sphere_radius`** `float`
  - 其它属性：getter=get_emission_sphere_radius · setter=set_emission_sphere_radius
- **`emitting`** `bool` = `true`
  - 其它属性：getter=is_emitting · setter=set_emitting
- **`explosiveness`** `float` = `0.0`
  - 其它属性：getter=get_explosiveness_ratio · setter=set_explosiveness_ratio
- **`fixed_fps`** `int` = `0`
  - 其它属性：getter=get_fixed_fps · setter=set_fixed_fps
- **`flatness`** `float` = `0.0`
  - 其它属性：getter=get_flatness · setter=set_flatness
- **`fract_delta`** `bool` = `true`
  - 其它属性：getter=get_fractional_delta · setter=set_fractional_delta
- **`gravity`** `Vector3` = `Vector3(0, -9.8, 0)`
  - 其它属性：getter=get_gravity · setter=set_gravity
- **`hue_variation_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`hue_variation_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`hue_variation_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`initial_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`initial_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`lifetime`** `float` = `1.0`
  - 其它属性：getter=get_lifetime · setter=set_lifetime
- **`lifetime_randomness`** `float` = `0.0`
  - 其它属性：getter=get_lifetime_randomness · setter=set_lifetime_randomness
- **`linear_accel_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`linear_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`linear_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`local_coords`** `bool` = `false`
  - 其它属性：getter=get_use_local_coordinates · setter=set_use_local_coordinates
- **`mesh`** `Mesh`
  - 其它属性：getter=get_mesh · setter=set_mesh
- **`one_shot`** `bool` = `false`
  - 其它属性：getter=get_one_shot · setter=set_one_shot
- **`orbit_velocity_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`orbit_velocity_max`** `float`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`orbit_velocity_min`** `float`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`particle_flag_align_y`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_disable_z`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_rotate_y`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`preprocess`** `float` = `0.0`
  - 其它属性：getter=get_pre_process_time · setter=set_pre_process_time
- **`radial_accel_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`radial_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`radial_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`randomness`** `float` = `0.0`
  - 其它属性：getter=get_randomness_ratio · setter=set_randomness_ratio
- **`scale_amount_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`scale_amount_max`** `float` = `1.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`scale_amount_min`** `float` = `1.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`scale_curve_x`** `Curve`
  - 其它属性：getter=get_scale_curve_x · setter=set_scale_curve_x
- **`scale_curve_y`** `Curve`
  - 其它属性：getter=get_scale_curve_y · setter=set_scale_curve_y
- **`scale_curve_z`** `Curve`
  - 其它属性：getter=get_scale_curve_z · setter=set_scale_curve_z
- **`seed`** `int` = `0`
  - 其它属性：getter=get_seed · setter=set_seed
- **`speed_scale`** `float` = `1.0`
  - 其它属性：getter=get_speed_scale · setter=set_speed_scale
- **`split_scale`** `bool` = `false`
  - 其它属性：getter=get_split_scale · setter=set_split_scale
- **`spread`** `float` = `45.0`
  - 其它属性：getter=get_spread · setter=set_spread
- **`tangential_accel_curve`** `Curve`
  - 其它属性：getter=get_param_curve · setter=set_param_curve
- **`tangential_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`tangential_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`use_fixed_seed`** `bool` = `false`
  - 其它属性：getter=get_use_fixed_seed · setter=set_use_fixed_seed
- **`visibility_aabb`** `AABB` = `AABB(0, 0, 0, 0, 0, 0)`
  - 其它属性：getter=get_visibility_aabb · setter=set_visibility_aabb

## 方法

### `capture_aabb() -> AABB`
- 限定：qualifiers=const

Returns the axis-aligned bounding box that contains all the particles that are active in the current frame.

### `convert_from_particles(particles: Node) -> void`

Sets this node's properties to match a given `GPUParticles3D` node with an assigned `ParticleProcessMaterial`.

### `get_param_curve(param: int) -> Curve`
- 限定：qualifiers=const

Returns the `Curve` of the parameter specified by `Parameter`.

### `get_param_max(param: int) -> float`
- 限定：qualifiers=const

Returns the maximum value range for the given parameter.

### `get_param_min(param: int) -> float`
- 限定：qualifiers=const

Returns the minimum value range for the given parameter.

### `get_particle_flag(particle_flag: int) -> bool`
- 限定：qualifiers=const

Returns the enabled state of the given particle flag.

### `request_particles_process(process_time: float, process_time_residual: float = 0.0) -> void`

Requests the particles to process for extra process time during a single frame.
				`process_time` defines the time that the particles will process while emitting is on. `process_time_residual` defines the time that particles will process with emitting turned off for the simulation. When combined with `speed_scale` set to `0.0`, this is useful to be able to seek a particle system timeline.

### `restart(keep_seed: bool = false) -> void`

Restarts the particle emitter.
				If `keep_seed` is `true`, the current random seed will be preserved. Useful for seeking and playback.

### `set_param_curve(param: int, curve: Curve) -> void`

Sets the `Curve` of the parameter specified by `Parameter`. Should be a unit `Curve`.

### `set_param_max(param: int, value: float) -> void`

Sets the maximum value for the given parameter.

### `set_param_min(param: int, value: float) -> void`

Sets the minimum value for the given parameter.

### `set_particle_flag(particle_flag: int, enable: bool) -> void`

Enables or disables the given particle flag.

## 信号

### `finished()`

Emitted when all active particles have finished processing. When `one_shot` is disabled, particles will process continuously, so this is never emitted.

## 枚举

### `DrawOrder`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAW_ORDER_INDEX` |  |
| `1` | `DRAW_ORDER_LIFETIME` |  |
| `2` | `DRAW_ORDER_VIEW_DEPTH` |  |

### `Parameter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARAM_INITIAL_LINEAR_VELOCITY` |  |
| `1` | `PARAM_ANGULAR_VELOCITY` |  |
| `2` | `PARAM_ORBIT_VELOCITY` |  |
| `3` | `PARAM_LINEAR_ACCEL` |  |
| `4` | `PARAM_RADIAL_ACCEL` |  |
| `5` | `PARAM_TANGENTIAL_ACCEL` |  |
| `6` | `PARAM_DAMPING` |  |
| `7` | `PARAM_ANGLE` |  |
| `8` | `PARAM_SCALE` |  |
| `9` | `PARAM_HUE_VARIATION` |  |
| `10` | `PARAM_ANIM_SPEED` |  |
| `11` | `PARAM_ANIM_OFFSET` |  |
| `12` | `PARAM_MAX` |  |

### `ParticleFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLE_FLAG_ALIGN_Y_TO_VELOCITY` |  |
| `1` | `PARTICLE_FLAG_ROTATE_Y` |  |
| `2` | `PARTICLE_FLAG_DISABLE_Z` |  |
| `3` | `PARTICLE_FLAG_MAX` |  |

### `EmissionShape`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `EMISSION_SHAPE_POINT` |  |
| `1` | `EMISSION_SHAPE_SPHERE` |  |
| `2` | `EMISSION_SHAPE_SPHERE_SURFACE` |  |
| `3` | `EMISSION_SHAPE_BOX` |  |
| `4` | `EMISSION_SHAPE_POINTS` |  |
| `5` | `EMISSION_SHAPE_DIRECTED_POINTS` |  |
| `6` | `EMISSION_SHAPE_RING` |  |
| `7` | `EMISSION_SHAPE_MAX` |  |

## 教程链接

- [Particle systems (3D)](None)

