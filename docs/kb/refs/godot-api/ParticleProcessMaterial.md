# ParticleProcessMaterial

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`ParticleProcessMaterial` → `Material` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/ParticleProcessMaterial.md`

**摘要**：Holds a particle configuration for `GPUParticles2D` or `GPUParticles3D` nodes.

## 描述

`ParticleProcessMaterial` defines particle properties and behavior. It is used in the `process_material` of the `GPUParticles2D` and `GPUParticles3D` nodes. Some of this material's properties are applied to each particle when emitted, while others can have a `CurveTexture` or a `GradientTexture1D` applied to vary numerical or color values over the lifetime of the particle.

## 属性

- **`alpha_curve`** `Texture2D`
  - 其它属性：getter=get_alpha_curve · setter=set_alpha_curve
- **`angle_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`angle_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`angle_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`angular_velocity_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`angular_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`angular_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`anim_offset_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`anim_offset_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`anim_offset_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`anim_speed_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`anim_speed_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`anim_speed_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`attractor_interaction_enabled`** `bool` = `true`
  - 其它属性：getter=is_attractor_interaction_enabled · setter=set_attractor_interaction_enabled
- **`collision_bounce`** `float`
  - 其它属性：getter=get_collision_bounce · setter=set_collision_bounce
- **`collision_friction`** `float`
  - 其它属性：getter=get_collision_friction · setter=set_collision_friction
- **`collision_mode`** `int` = `0` · 枚举 `ParticleProcessMaterial.CollisionMode`
  - 其它属性：getter=get_collision_mode · setter=set_collision_mode
- **`collision_use_scale`** `bool` = `false`
  - 其它属性：getter=is_collision_using_scale · setter=set_collision_use_scale
- **`color`** `Color` = `Color(1, 1, 1, 1)`
  - 其它属性：getter=get_color · keywords=colour · setter=set_color
- **`color_initial_ramp`** `Texture2D`
  - 其它属性：getter=get_color_initial_ramp · setter=set_color_initial_ramp
- **`color_ramp`** `Texture2D`
  - 其它属性：getter=get_color_ramp · setter=set_color_ramp
- **`damping_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`damping_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`damping_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`direction`** `Vector3` = `Vector3(1, 0, 0)`
  - 其它属性：getter=get_direction · setter=set_direction
- **`directional_velocity_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`directional_velocity_max`** `float`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`directional_velocity_min`** `float`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`emission_box_extents`** `Vector3`
  - 其它属性：getter=get_emission_box_extents · setter=set_emission_box_extents
- **`emission_color_texture`** `Texture2D`
  - 其它属性：getter=get_emission_color_texture · setter=set_emission_color_texture
- **`emission_curve`** `Texture2D`
  - 其它属性：getter=get_emission_curve · setter=set_emission_curve
- **`emission_normal_texture`** `Texture2D`
  - 其它属性：getter=get_emission_normal_texture · setter=set_emission_normal_texture
- **`emission_point_count`** `int`
  - 其它属性：getter=get_emission_point_count · setter=set_emission_point_count
- **`emission_point_texture`** `Texture2D`
  - 其它属性：getter=get_emission_point_texture · setter=set_emission_point_texture
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
- **`emission_shape`** `int` = `0` · 枚举 `ParticleProcessMaterial.EmissionShape`
  - 其它属性：getter=get_emission_shape · setter=set_emission_shape
- **`emission_shape_offset`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_emission_shape_offset · setter=set_emission_shape_offset
- **`emission_shape_scale`** `Vector3` = `Vector3(1, 1, 1)`
  - 其它属性：getter=get_emission_shape_scale · setter=set_emission_shape_scale
- **`emission_sphere_radius`** `float`
  - 其它属性：getter=get_emission_sphere_radius · setter=set_emission_sphere_radius
- **`flatness`** `float` = `0.0`
  - 其它属性：getter=get_flatness · setter=set_flatness
- **`gravity`** `Vector3` = `Vector3(0, -9.8, 0)`
  - 其它属性：getter=get_gravity · setter=set_gravity
- **`hue_variation_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`hue_variation_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`hue_variation_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`inherit_velocity_ratio`** `float` = `0.0`
  - 其它属性：getter=get_inherit_velocity_ratio · setter=set_inherit_velocity_ratio
- **`initial_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`initial_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`lifetime_randomness`** `float` = `0.0`
  - 其它属性：getter=get_lifetime_randomness · setter=set_lifetime_randomness
- **`linear_accel_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`linear_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`linear_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`orbit_velocity_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`orbit_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`orbit_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`particle_flag_align_y`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_damping_as_friction`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_disable_z`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_inherit_emitter_scale`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`particle_flag_rotate_y`** `bool` = `false`
  - 其它属性：getter=get_particle_flag · setter=set_particle_flag
- **`radial_accel_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`radial_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`radial_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`radial_velocity_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`radial_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`radial_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`rotation_3d_max`** `Vector3`
  - 其它属性：getter=get_rotation_3d_max · setter=set_rotation_3d_max
- **`rotation_3d_min`** `Vector3`
  - 其它属性：getter=get_rotation_3d_min · setter=set_rotation_3d_min
- **`rotation_velocity_3d_curve`** `Texture2D`
  - 其它属性：getter=get_rotation_velocity_3d_curve · setter=set_rotation_velocity_3d_curve
- **`rotation_velocity_3d_max`** `Vector3`
  - 其它属性：getter=get_rotation_velocity_3d_max · setter=set_rotation_velocity_3d_max
- **`rotation_velocity_3d_min`** `Vector3`
  - 其它属性：getter=get_rotation_velocity_3d_min · setter=set_rotation_velocity_3d_min
- **`scale_3d_max`** `Vector3`
  - 其它属性：getter=get_scale_3d_max · setter=set_scale_3d_max
- **`scale_3d_min`** `Vector3`
  - 其它属性：getter=get_scale_3d_min · setter=set_scale_3d_min
- **`scale_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`scale_max`** `float` = `1.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`scale_min`** `float` = `1.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`scale_over_velocity_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`scale_over_velocity_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`scale_over_velocity_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`spread`** `float` = `45.0`
  - 其它属性：getter=get_spread · setter=set_spread
- **`sub_emitter_amount_at_collision`** `int`
  - 其它属性：getter=get_sub_emitter_amount_at_collision · setter=set_sub_emitter_amount_at_collision
- **`sub_emitter_amount_at_end`** `int`
  - 其它属性：getter=get_sub_emitter_amount_at_end · setter=set_sub_emitter_amount_at_end
- **`sub_emitter_amount_at_start`** `int`
  - 其它属性：getter=get_sub_emitter_amount_at_start · setter=set_sub_emitter_amount_at_start
- **`sub_emitter_frequency`** `float`
  - 其它属性：getter=get_sub_emitter_frequency · setter=set_sub_emitter_frequency
- **`sub_emitter_keep_velocity`** `bool` = `false`
  - 其它属性：getter=get_sub_emitter_keep_velocity · setter=set_sub_emitter_keep_velocity
- **`sub_emitter_mode`** `int` = `0` · 枚举 `ParticleProcessMaterial.SubEmitterMode`
  - 其它属性：getter=get_sub_emitter_mode · setter=set_sub_emitter_mode
- **`tangential_accel_curve`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`tangential_accel_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`tangential_accel_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`turbulence_enabled`** `bool` = `false`
  - 其它属性：getter=get_turbulence_enabled · setter=set_turbulence_enabled
- **`turbulence_influence_max`** `float` = `0.1`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`turbulence_influence_min`** `float` = `0.1`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`turbulence_influence_over_life`** `Texture2D`
  - 其它属性：getter=get_param_texture · setter=set_param_texture
- **`turbulence_initial_displacement_max`** `float` = `0.0`
  - 其它属性：getter=get_param_max · setter=set_param_max
- **`turbulence_initial_displacement_min`** `float` = `0.0`
  - 其它属性：getter=get_param_min · setter=set_param_min
- **`turbulence_noise_scale`** `float` = `9.0`
  - 其它属性：getter=get_turbulence_noise_scale · setter=set_turbulence_noise_scale
- **`turbulence_noise_speed`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_turbulence_noise_speed · setter=set_turbulence_noise_speed
- **`turbulence_noise_speed_random`** `float` = `0.2`
  - 其它属性：getter=get_turbulence_noise_speed_random · setter=set_turbulence_noise_speed_random
- **`turbulence_noise_strength`** `float` = `1.0`
  - 其它属性：getter=get_turbulence_noise_strength · setter=set_turbulence_noise_strength
- **`use_rotation_3d`** `bool` = `false`
  - 其它属性：getter=is_using_rotation_3d · setter=set_use_rotation_3d
- **`use_rotation_velocity_3d`** `bool` = `false`
  - 其它属性：getter=is_using_rotation_velocity_3d · setter=set_using_rotation_velocity_3d
- **`use_scale_3d`** `bool` = `false`
  - 其它属性：getter=is_using_scale_3d · setter=set_use_scale_3d
- **`velocity_limit_curve`** `Texture2D`
  - 其它属性：getter=get_velocity_limit_curve · setter=set_velocity_limit_curve
- **`velocity_pivot`** `Vector3` = `Vector3(0, 0, 0)`
  - 其它属性：getter=get_velocity_pivot · setter=set_velocity_pivot

## 方法

### `get_param(param: int) -> Vector2`
- 限定：qualifiers=const

Returns the minimum and maximum values of the given `param` as a vector.
				The `x` component of the returned vector corresponds to minimum and the `y` component corresponds to maximum.

### `get_param_max(param: int) -> float`
- 限定：qualifiers=const

Returns the maximum value range for the given parameter.

### `get_param_min(param: int) -> float`
- 限定：qualifiers=const

Returns the minimum value range for the given parameter.

### `get_param_texture(param: int) -> Texture2D`
- 限定：qualifiers=const

Returns the `Texture2D` used by the specified parameter.

### `get_particle_flag(particle_flag: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified particle flag is enabled.

### `set_param(param: int, value: Vector2) -> void`

Sets the minimum and maximum values of the given `param`.
				The `x` component of the argument vector corresponds to minimum and the `y` component corresponds to maximum.

### `set_param_max(param: int, value: float) -> void`

Sets the maximum value range for the given parameter.

### `set_param_min(param: int, value: float) -> void`

Sets the minimum value range for the given parameter.

### `set_param_texture(param: int, texture: Texture2D) -> void`

Sets the `Texture2D` for the specified `Parameter`.

### `set_particle_flag(particle_flag: int, enable: bool) -> void`

Sets the `particle_flag` to `enable`.

## 信号

### `emission_shape_changed()`

Emitted when this material's emission shape is changed in any way. This includes changes to `emission_shape`, `emission_shape_scale`, or `emission_sphere_radius`, and any other property that affects the emission shape's offset, size, scale, or orientation.
				**Note:** This signal is only emitted inside the editor for performance reasons.

## 枚举

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
| `15` | `PARAM_RADIAL_VELOCITY` |  |
| `16` | `PARAM_DIRECTIONAL_VELOCITY` |  |
| `17` | `PARAM_SCALE_OVER_VELOCITY` |  |
| `18` | `PARAM_MAX` |  |
| `13` | `PARAM_TURB_VEL_INFLUENCE` |  |
| `14` | `PARAM_TURB_INIT_DISPLACEMENT` |  |
| `12` | `PARAM_TURB_INFLUENCE_OVER_LIFE` |  |

### `ParticleFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PARTICLE_FLAG_ALIGN_Y_TO_VELOCITY` |  |
| `1` | `PARTICLE_FLAG_ROTATE_Y` |  |
| `2` | `PARTICLE_FLAG_DISABLE_Z` |  |
| `3` | `PARTICLE_FLAG_DAMPING_AS_FRICTION` |  |
| `4` | `PARTICLE_FLAG_INHERIT_EMITTER_SCALE` |  |
| `5` | `PARTICLE_FLAG_MAX` |  |

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

### `SubEmitterMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SUB_EMITTER_DISABLED` |  |
| `1` | `SUB_EMITTER_CONSTANT` |  |
| `2` | `SUB_EMITTER_AT_END` |  |
| `3` | `SUB_EMITTER_AT_COLLISION` |  |
| `4` | `SUB_EMITTER_AT_START` |  |
| `5` | `SUB_EMITTER_MAX` |  |

### `CollisionMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COLLISION_DISABLED` |  |
| `1` | `COLLISION_RIGID` |  |
| `2` | `COLLISION_HIDE_ON_CONTACT` |  |
| `3` | `COLLISION_MAX` |  |

