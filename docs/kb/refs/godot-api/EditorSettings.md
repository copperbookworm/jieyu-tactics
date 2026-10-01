# EditorSettings

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`EditorSettings` → `Resource` → `RefCounted` → `Object`
> 附加属性：api_type=editor
> 自动生成，勿手改。文件：`refs/godot-api/EditorSettings.md`

**摘要**：Object that holds the project-independent editor settings.

## 描述

Object that holds the project-independent editor settings. These settings are generally visible in the **Editor > Editor Settings** menu.
		Property names use slash delimiters to distinguish sections. Setting values can be of any `Variant` type. It's recommended to use `snake_case` for editor settings to be consistent with the Godot editor itself.
		Editor settings are saved automatically when changed.
		Accessing the settings can be done using the following methods, such as:
		`codeblocks`
		`gdscript`
		var settings = EditorInterface.get_editor_settings()
		# `settings.set("some/property", 10)` also works as this class overrides `_set()` internally.
		settings.set_setting("some/property", 10)
		# `settings.get("some/property")` also works as this class overrides `_get()` internally.
		settings.get_setting("some/property")
		var list_of_settings = settings.get_property_list()
		
		`csharp`
		EditorSettings settings = EditorInterface.Singleton.GetEditorSettings();
		// `settings.set("some/property", value)` also works as this class overrides `_set()` internally.
		settings.SetSetting("some/property", Value);
		// `settings.get("some/property", value)` also works as this class overrides `_get()` internally.
		settings.GetSetting("some/property");
		Godot.Collections.Array<Godot.Collections.Dictionary> listOfSettings = settings.GetPropertyList();
		
		
		**Note:** This class shouldn't be instantiated directly. Instead, access the singleton using `EditorInterface.get_editor_settings`.

## 属性

- **`asset_store/available_urls`** `Dictionary`
  - 其它属性：getter= · setter=
- **`asset_store/use_threads`** `bool`
  - 其它属性：getter= · setter=
- **`debugger/auto_switch_to_remote_scene_tree`** `bool`
  - 其它属性：getter= · setter=
- **`debugger/auto_switch_to_stack_trace`** `bool`
  - 其它属性：getter= · setter=
- **`debugger/max_node_selection`** `int`
  - 其它属性：getter= · setter=
- **`debugger/profile_native_calls`** `bool`
  - 其它属性：getter= · setter=
- **`debugger/profiler_frame_history_size`** `int`
  - 其它属性：getter= · setter=
- **`debugger/profiler_frame_max_functions`** `int`
  - 其它属性：getter= · setter=
- **`debugger/profiler_target_fps`** `int`
  - 其它属性：getter= · setter=
- **`debugger/remote_inspect_refresh_interval`** `float`
  - 其它属性：getter= · setter=
- **`debugger/remote_scene_tree_refresh_interval`** `float`
  - 其它属性：getter= · setter=
- **`docks/filesystem/always_show_folders`** `bool`
  - 其它属性：getter= · setter=
- **`docks/filesystem/ask_before_moving_files`** `bool`
  - 其它属性：getter= · setter=
- **`docks/filesystem/automatically_open_created_scripts`** `bool`
  - 其它属性：getter= · setter=
- **`docks/filesystem/other_file_extensions`** `String`
  - 其它属性：getter= · setter=
- **`docks/filesystem/textfile_extensions`** `String`
  - 其它属性：getter= · setter=
- **`docks/filesystem/thumbnail_size`** `int`
  - 其它属性：getter= · setter=
- **`docks/property_editor/auto_refresh_interval`** `float`
  - 其它属性：getter= · setter=
- **`docks/property_editor/subresource_hue_tint`** `float`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/accessibility_warnings`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/ask_before_deleting_related_animation_tracks`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/ask_before_revoking_unique_name`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/auto_expand_to_selected`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/center_node_on_reparent`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/hide_filtered_out_parents`** `bool`
  - 其它属性：getter= · setter=
- **`docks/scene_tree/start_create_dialog_fully_expanded`** `bool`
  - 其它属性：getter= · setter=
- **`editors/2d/auto_resample_delay`** `float`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_color1`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_color2`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_ik_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_outline_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_outline_size`** `float`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_selected_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/bone_width`** `float`
  - 其它属性：getter= · setter=
- **`editors/2d/grid_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/guides_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/locked_selection_rectangle_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/ruler_width`** `float`
  - 其它属性：getter= · setter=
- **`editors/2d/selection_rectangle_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/smart_snapping_line_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/use_integer_zoom_by_default`** `bool`
  - 其它属性：getter= · setter=
- **`editors/2d/viewport_border_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/2d/zoom_speed_factor`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/active_selection_box_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d/default_fov`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/default_z_far`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/default_z_near`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_activation_modifier`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_base_speed`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_inertia`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_invert_y_axis`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_navigation_scheme`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_sensitivity`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/freelook/freelook_speed_zoom_link`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_division_level_bias`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_division_level_max`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_division_level_min`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_size`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_xy_plane`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_xz_plane`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/grid_yz_plane`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/manipulator_gizmo_opacity`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/manipulator_gizmo_size`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/emulate_3_button_mouse`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/emulate_numpad`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/invert_x_axis`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/invert_y_axis`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/navigation_scheme`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/orbit_mouse_button`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/pan_mouse_button`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/show_viewport_navigation_gizmo`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/show_viewport_rotation_gizmo`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/warped_mouse_panning`** `bool`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/zoom_mouse_button`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation/zoom_style`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/angle_snap_threshold`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/orbit_inertia`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/orbit_sensitivity`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/translation_inertia`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/translation_sensitivity`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/navigation_feel/zoom_inertia`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d/primary_grid_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d/primary_grid_steps`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/secondary_grid_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d/selection_box_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d/show_gizmo_during_rotation`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d/view_plane_rotation_gizmo_scale`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/aabb`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/camera`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/csg`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/decal`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/fog_volume`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/gridmap_grid`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/ik_chain`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/instantiated`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/joint`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/joint_body_a`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/joint_body_b`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/lightmap_lines`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/lightprobe_lines`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/occluder`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/particle_attractor`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/particle_collision`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/particles`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/path_tilt`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/reflection_probe`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/selected_bone`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/skeleton`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/spring_bone_collision`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/spring_bone_inside_collision`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/spring_bone_joint`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/stream_player_3d`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/visibility_notifier`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_colors/voxel_gi`** `Color`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_settings/bone_axis_length`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_settings/bone_shape`** `int`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_settings/lightmap_gi_probe_size`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_settings/path3d_tilt_disk_size`** `float`
  - 其它属性：getter= · setter=
- **`editors/3d_gizmos/gizmo_settings/show_collision_shapes_only_when_selected`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/autorename_animation_tracks`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/confirm_insert_track`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/default_animation_step`** `float`
  - 其它属性：getter= · setter=
- **`editors/animation/default_create_bezier_tracks`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/default_create_reset_tracks`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/default_fps_compatibility`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/default_fps_mode`** `int`
  - 其它属性：getter= · setter=
- **`editors/animation/insert_at_current_time`** `bool`
  - 其它属性：getter= · setter=
- **`editors/animation/onion_layers_future_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/animation/onion_layers_past_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/active_max_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/active_min_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/active_normalized_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/inactive_max_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/inactive_min_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/inactive_normalized_db_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/tint_over_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/audio_buses/tint_under_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/bone_mapper/handle_colors/error`** `Color`
  - 其它属性：getter= · setter=
- **`editors/bone_mapper/handle_colors/missing`** `Color`
  - 其它属性：getter= · setter=
- **`editors/bone_mapper/handle_colors/set`** `Color`
  - 其它属性：getter= · setter=
- **`editors/bone_mapper/handle_colors/unset`** `Color`
  - 其它属性：getter= · setter=
- **`editors/grid_map/pick_distance`** `float`
  - 其它属性：getter= · setter=
- **`editors/grid_map/preview_size`** `int`
  - 其它属性：getter= · setter=
- **`editors/panning/2d_editor_pan_speed`** `int`
  - 其它属性：getter= · setter=
- **`editors/panning/2d_editor_panning_scheme`** `int`
  - 其它属性：getter= · setter=
- **`editors/panning/animation_editors_panning_scheme`** `int`
  - 其它属性：getter= · setter=
- **`editors/panning/simple_panning`** `bool`
  - 其它属性：getter= · setter=
- **`editors/panning/sub_editors_panning_scheme`** `int`
  - 其它属性：getter= · setter=
- **`editors/panning/warped_mouse_panning`** `bool`
  - 其它属性：getter= · setter=
- **`editors/panning/zoom_style`** `int`
  - 其它属性：getter= · setter=
- **`editors/polygon_editor/auto_bake_delay`** `float`
  - 其它属性：getter= · setter=
- **`editors/polygon_editor/point_grab_radius`** `int`
  - 其它属性：getter= · setter=
- **`editors/polygon_editor/show_previous_outline`** `bool`
  - 其它属性：getter= · setter=
- **`editors/shader_editor/behavior/files/restore_shaders_on_load`** `bool`
  - 其它属性：getter= · setter=
- **`editors/tiles_editor/display_grid`** `bool`
  - 其它属性：getter= · setter=
- **`editors/tiles_editor/grid_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/tiles_editor/highlight_selected_layer`** `bool`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/color_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/conditional_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/input_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/output_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/particle_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/scalar_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/special_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/textures_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/transform_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/utility_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/category_colors/vector_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/color_theme`** `String`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/boolean_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/sampler_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/scalar_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/transform_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/vector2_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/vector3_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/connection_colors/vector4_color`** `Color`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/grid_pattern`** `int`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/lines_curvature`** `float`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/minimap_opacity`** `float`
  - 其它属性：getter= · setter=
- **`editors/visual_editors/visual_shader/port_preview_size`** `int`
  - 其它属性：getter= · setter=
- **`export/ssh/scp`** `String`
  - 其它属性：getter= · setter=
- **`export/ssh/ssh`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/directories/autoscan_project_path`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/directories/default_project_path`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/3d_model_editor`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/audio_editor`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/raster_image_editor`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/terminal_emulator`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/terminal_emulator_flags`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/external_programs/vector_image_editor`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/file_dialog/display_mode`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/file_dialog/show_hidden_files`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/file_dialog/thumbnail_size`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/file_server/password`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/file_server/port`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/import/blender/blender_path`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/import/blender/rpc_port`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/import/blender/rpc_server_uptime`** `float`
  - 其它属性：getter= · setter=
- **`filesystem/import/fbx/fbx2gltf_path`** `String`
  - 其它属性：getter= · setter=
- **`filesystem/on_save/compress_binary_resources`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/on_save/safe_save_on_backup_then_rename`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/on_save/warn_on_saving_large_text_resources`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/default_display_mode`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/enable_fuzzy_matching`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/include_addons`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/instant_preview`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/max_fuzzy_misses`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/max_results`** `int`
  - 其它属性：getter= · setter=
- **`filesystem/quick_open_dialog/show_search_highlight`** `bool`
  - 其它属性：getter= · setter=
- **`filesystem/tools/oidn/oidn_denoise_path`** `String`
  - 其它属性：getter= · setter=
- **`input/buffering/agile_event_flushing`** `bool`
  - 其它属性：getter= · setter=
- **`input/buffering/use_accumulated_input`** `bool`
  - 其它属性：getter= · setter=
- **`interface/accessibility/accessibility_support`** `int`
  - 其它属性：getter= · setter=
- **`interface/accessibility/property_descriptions`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/accept_dialog_cancel_ok_buttons`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/collapse_main_menu`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/custom_display_scale`** `float`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/display_scale`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/editor_screen`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/expand_to_title`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/project_manager_screen`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/show_renderer_selector`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/show_update_spinner`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/use_embedded_menu`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/appearance/use_native_file_dialogs`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/automatically_open_screenshots`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/import_resources_when_unfocused`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/save_each_scene_on_quit`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/save_on_focus_loss`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/separate_distraction_mode`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/behavior/show_internal_errors_in_toast_notifications`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/display/keep_screen_on`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/display/single_window_mode`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/display/update_continuously`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/display/vsync_mode`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/docks/bottom_dock_tab_style`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/docks/dock_tab_style`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/code_font`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/code_font_contextual_ligatures`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/code_font_custom_opentype_features`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/code_font_custom_variations`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/code_font_size`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/font_allow_msdf`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/font_antialiasing`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/font_disable_embedded_bitmaps`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/font_hinting`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/font_subpixel_positioning`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/main_font`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/main_font_bold`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/main_font_custom_opentype_features`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/fonts/main_font_size`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/input/mouse_extra_buttons_navigate_history`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/input/tablet_driver`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/localization/editor_language`** `String`
  - 其它属性：getter= · setter=
- **`interface/editor/localization/localize_settings`** `bool`
  - 其它属性：getter= · setter=
- **`interface/editor/localization/ui_layout_direction`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/timers/dragging_hover_wait_seconds`** `float`
  - 其它属性：getter= · setter=
- **`interface/editor/timers/low_processor_mode_sleep_usec`** `int`
  - 其它属性：getter= · setter=
- **`interface/editor/timers/unfocused_low_processor_mode_sleep_usec`** `int`
  - 其它属性：getter= · setter=
- **`interface/editors/derive_script_globals_by_name`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/auto_unfold_foreign_scenes`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/color_picker_show_intensity`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/default_color_picker_mode`** `int`
  - 其它属性：getter= · setter=
- **`interface/inspector/default_color_picker_shape`** `int`
  - 其它属性：getter= · setter=
- **`interface/inspector/default_float_step`** `float`
  - 其它属性：getter= · setter=
- **`interface/inspector/default_property_name_style`** `int`
  - 其它属性：getter= · setter=
- **`interface/inspector/delimitate_all_container_and_resources`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/disable_folding`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/float_drag_speed`** `float`
  - 其它属性：getter= · setter=
- **`interface/inspector/horizontal_vector2_editing`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/horizontal_vector_types_editing`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/integer_drag_speed`** `float`
  - 其它属性：getter= · setter=
- **`interface/inspector/max_array_dictionary_items_per_page`** `int`
  - 其它属性：getter= · setter=
- **`interface/inspector/nested_color_mode`** `int`
  - 其它属性：getter= · setter=
- **`interface/inspector/open_resources_in_current_inspector`** `bool`
  - 其它属性：getter= · setter=
- **`interface/inspector/resources_to_open_in_new_inspector`** `PackedStringArray`
  - 其它属性：getter= · setter=
- **`interface/inspector/show_low_level_opentype_features`** `bool`
  - 其它属性：getter= · setter=
- **`interface/multi_window/enable`** `bool`
  - 其它属性：getter= · setter=
- **`interface/multi_window/maximize_window`** `bool`
  - 其它属性：getter= · setter=
- **`interface/multi_window/restore_windows_on_load`** `bool`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/auto_select_current_scene_file`** `bool`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/display_close_button`** `int`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/maximum_width`** `int`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/restore_scenes_on_load`** `bool`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/show_script_button`** `bool`
  - 其它属性：getter= · setter=
- **`interface/scene_tabs/show_thumbnail_on_hover`** `bool`
  - 其它属性：getter= · setter=
- **`interface/theme/accent_color`** `Color`
  - 其它属性：getter= · setter=
- **`interface/theme/additional_spacing`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/base_color`** `Color`
  - 其它属性：getter= · setter=
- **`interface/theme/base_spacing`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/border_size`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/color_preset`** `String`
  - 其它属性：getter= · setter=
- **`interface/theme/contrast`** `float`
  - 其它属性：getter= · setter=
- **`interface/theme/corner_radius`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/custom_theme`** `String`
  - 其它属性：getter= · setter=
- **`interface/theme/draw_extra_borders`** `bool`
  - 其它属性：getter= · setter=
- **`interface/theme/draw_relationship_lines`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/follow_system_theme`** `bool`
  - 其它属性：getter= · setter=
- **`interface/theme/icon_and_font_color`** `int`
  - 其它属性：getter= · setter=
- **`interface/theme/icon_saturation`** `float`
  - 其它属性：getter= · setter=
- **`interface/theme/relationship_line_opacity`** `float`
  - 其它属性：getter= · setter=
- **`interface/theme/spacing_preset`** `String`
  - 其它属性：getter= · setter=
- **`interface/theme/style`** `String`
  - 其它属性：getter= · setter=
- **`interface/theme/use_monospace_font_for_editor_symbols`** `bool`
  - 其它属性：getter= · setter=
- **`interface/theme/use_system_accent_color`** `bool`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/enable_long_press_as_right_click`** `bool`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/enable_pan_and_scale_gestures`** `bool`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/enable_touch_optimizations`** `bool`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/haptic_on_long_press`** `bool`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/scale_gizmo_handles`** `float`
  - 其它属性：getter= · setter=
- **`interface/touchscreen/touch_actions_panel`** `int`
  - 其它属性：getter= · setter=
- **`network/connection/check_for_updates`** `int`
  - 其它属性：getter= · setter=
- **`network/connection/network_mode`** `int`
  - 其它属性：getter= · setter=
- **`network/debug/remote_host`** `String`
  - 其它属性：getter= · setter=
- **`network/debug/remote_port`** `int`
  - 其它属性：getter= · setter=
- **`network/http_proxy/host`** `String`
  - 其它属性：getter= · setter=
- **`network/http_proxy/port`** `int`
  - 其它属性：getter= · setter=
- **`network/language_server/enable_smart_resolve`** `bool`
  - 其它属性：getter= · setter=
- **`network/language_server/poll_limit_usec`** `int`
  - 其它属性：getter= · setter=
- **`network/language_server/remote_host`** `String`
  - 其它属性：getter= · setter=
- **`network/language_server/remote_port`** `int`
  - 其它属性：getter= · setter=
- **`network/language_server/show_native_symbols_in_editor`** `bool`
  - 其它属性：getter= · setter=
- **`network/language_server/use_thread`** `bool`
  - 其它属性：getter= · setter=
- **`network/tls/editor_tls_certificates`** `String`
  - 其它属性：getter= · setter=
- **`network/tls/enable_tls_v1.3`** `bool`
  - 其它属性：getter= · setter=
- **`project_manager/default_renderer`** `String`
  - 其它属性：getter= · setter=
- **`project_manager/directory_naming_convention`** `int`
  - 其它属性：getter= · setter=
- **`project_manager/sorting_order`** `int`
  - 其它属性：getter= · setter=
- **`run/auto_save/save_before_running`** `bool`
  - 其它属性：getter= · setter=
- **`run/bottom_panel/action_on_play`** `int`
  - 其它属性：getter= · setter=
- **`run/bottom_panel/action_on_stop`** `int`
  - 其它属性：getter= · setter=
- **`run/output/always_clear_output_on_play`** `bool`
  - 其它属性：getter= · setter=
- **`run/output/font_size`** `int`
  - 其它属性：getter= · setter=
- **`run/output/max_lines`** `int`
  - 其它属性：getter= · setter=
- **`run/platforms/linuxbsd/prefer_wayland`** `bool`
  - 其它属性：getter= · setter=
- **`run/window_placement/android_window`** `int`
  - 其它属性：getter= · setter=
- **`run/window_placement/game_embed_mode`** `int`
  - 其它属性：getter= · setter=
- **`run/window_placement/rect`** `int`
  - 其它属性：getter= · setter=
- **`run/window_placement/rect_custom_position`** `Vector2`
  - 其它属性：getter= · setter=
- **`run/window_placement/screen`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/caret/caret_blink`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/caret/caret_blink_interval`** `float`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/caret/highlight_all_occurrences`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/caret/highlight_current_line`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/caret/type`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/drag_and_drop_info/show_drag_and_drop_info`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/enable_inline_color_picker`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/guidelines/line_length_guideline_hard_column`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/guidelines/line_length_guideline_soft_column`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/guidelines/show_line_length_guidelines`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/gutters/highlight_type_safe_lines`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/gutters/line_numbers_zero_padded`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/gutters/show_info_gutter`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/gutters/show_line_numbers`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/lines/autowrap_mode`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/lines/code_folding`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/lines/word_wrap`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/minimap/minimap_width`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/minimap/show_minimap`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/whitespace/draw_spaces`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/whitespace/draw_tabs`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/appearance/whitespace/line_spacing`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/documentation/enable_tooltips`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/auto_reload_and_parse_scripts_on_save`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/auto_reload_scripts_on_external_change`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/autosave_interval_secs`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/convert_indent_on_save`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/drop_preload_resources_as_uid`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/open_dominant_script_on_scene_change`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/restore_scripts_on_load`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/trim_final_newlines_on_save`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/files/trim_trailing_whitespace_on_save`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/general/empty_selection_clipboard`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/indent/auto_indent`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/indent/indent_wrapped_lines`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/indent/size`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/indent/type`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/custom_word_separators`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/drag_and_drop_selection`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/move_caret_on_right_click`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/open_script_when_connecting_signal_to_existing_method`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/scroll_past_end_of_file`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/smooth_scrolling`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/stay_in_script_editor_on_node_selected`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/use_custom_word_separators`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/use_default_word_separators`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/behavior/navigation/v_scroll_speed`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/completion/add_node_path_literals`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/add_string_name_literals`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/add_type_hints`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/auto_brace_complete`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/code_complete_delay`** `float`
  - 其它属性：getter= · setter=
- **`text_editor/completion/code_complete_enabled`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/colorize_suggestions`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/complete_file_paths`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/idle_parse_delay`** `float`
  - 其它属性：getter= · setter=
- **`text_editor/completion/idle_parse_delay_with_errors_found`** `float`
  - 其它属性：getter= · setter=
- **`text_editor/completion/put_callhint_tooltip_below_current_line`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/completion/use_single_quotes`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/external/exec_flags`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/external/exec_path`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/external/use_external_editor`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/help/class_reference_examples`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/help/help_font_size`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/help/help_source_font_size`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/help/help_title_font_size`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/help/show_help_index`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/help/sort_functions_alphabetically`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/group_help_pages`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/highlight_scene_scripts`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/list_script_names_as`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/script_temperature_enabled`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/script_temperature_history_size`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/show_members_overview`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/sort_members_outline_alphabetically`** `bool`
  - 其它属性：getter= · setter=
- **`text_editor/script_list/sort_scripts_by`** `int`
  - 其它属性：getter= · setter=
- **`text_editor/theme/color_theme`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/background_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/base_type_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/bookmark_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/brace_mismatch_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/breakpoint_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/caret_background_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/caret_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/code_folding_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/critical_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/critical_list`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/notice_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/notice_list`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/warning_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/comment_markers/warning_list`** `String`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_background_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_existing_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_font_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_scroll_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_scroll_hovered_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/completion_selected_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/control_flow_keyword_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/current_line_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/doc_comment_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/engine_type_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/executing_line_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/folded_code_region_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/function_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/annotation_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/function_definition_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/global_function_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/node_path_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/node_reference_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/gdscript/string_name_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/keyword_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/line_length_guideline_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/line_number_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/mark_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/member_variable_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/number_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/safe_line_number_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/search_result_border_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/search_result_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/selection_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/string_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/string_placeholder_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/symbol_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/text_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/text_selected_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/user_type_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/warning_color`** `Color`
  - 其它属性：getter= · setter=
- **`text_editor/theme/highlighting/word_highlighted_color`** `Color`
  - 其它属性：getter= · setter=
- **`version_control/ssh_private_key_path`** `String`
  - 其它属性：getter= · setter=
- **`version_control/ssh_public_key_path`** `String`
  - 其它属性：getter= · setter=
- **`version_control/username`** `String`
  - 其它属性：getter= · setter=

## 方法

### `add_property_info(info: Dictionary) -> void`

Adds a custom property info to a property. The dictionary must contain:
				- `name`: `String` (the name of the property)
				- `type`: `int` (see `Variant.Type`)
				- optionally `hint`: `int` (see `PropertyHint`) and `hint_string`: `String`
				`codeblocks`
				`gdscript`
				var settings = EditorInterface.get_editor_settings()
				settings.set("category/property_name", 0)

				var property_info = {
					"name": "category/property_name",
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": "one,two,three"
				}

				settings.add_property_info(property_info)
				
				`csharp`
				var settings = GetEditorInterface().GetEditorSettings();
				settings.Set("category/property_name", 0);

				var propertyInfo = new Godot.Collections.Dictionary
				{
					{ "name", "category/propertyName" },
					{ "type", Variant.Type.Int },
					{ "hint", PropertyHint.Enum },
					{ "hint_string", "one,two,three" },
				};

				settings.AddPropertyInfo(propertyInfo);

### `add_shortcut(path: String, shortcut: Shortcut) -> void`

Adds a `shortcut` whose path is specified by `path`.
				The `path` determines how the shortcut is organized and displayed in the editor's shortcut settings. The path format affects the display as follows:
				- `"name"` (no slash): Creates a category named `name` with the shortcut displayed as `name`.
				- `"category/name"` (single slash): Displays as `name` in the `category` section.
				- `"category/name/extra"` (multiple slashes): Extra path components are ignored, so this behaves the same as `"category/name"`.
				**Note:** Shortcuts are only saved to the editor settings if they differ from their original/default state. This means empty shortcuts that were originally empty will not persist between editor sessions and must be re-added. If a shortcut with the same `path` already exists, this method will update it with the new `shortcut` instead of creating a duplicate.
				
```gdscript
				# Add a custom shortcut for a plugin action.
				var my_shortcut = Shortcut.new()
				var input_event = InputEventKey.new()
				input_event.keycode = KEY_F5
				input_event.ctrl_pressed = true
				my_shortcut.events.append(input_event)

				# This will appear under the "My Plugin" category as "Reload Data".
				EditorInterface.get_editor_settings().add_shortcut("my_plugin/reload_data", my_shortcut)

				# This will appear under the "Test Action" category as "Test Action".
				EditorInterface.get_editor_settings().add_shortcut("test_action", my_shortcut)
				
```

### `check_changed_settings_in_group(setting_prefix: String) -> bool`
- 限定：qualifiers=const

Checks if any settings with the prefix `setting_prefix` exist in the set of changed settings. See also `get_changed_settings`.

### `erase(property: String) -> void`

Erases the setting whose name is specified by `property`.

### `get_changed_settings() -> PackedStringArray`
- 限定：qualifiers=const

Gets an array of the settings which have been changed since the last save. Note that internally `changed_settings` is cleared after a successful save, so generally the most appropriate place to use this method is when processing `NOTIFICATION_EDITOR_SETTINGS_CHANGED`.

### `get_favorites() -> PackedStringArray`
- 限定：qualifiers=const

Returns the list of favorite files and directories for this project.

### `get_project_metadata(section: String, key: String, default: Variant = null) -> Variant`
- 限定：qualifiers=const

Returns project-specific metadata for the `section` and `key` specified. If the metadata doesn't exist, `default` will be returned instead. See also `set_project_metadata`.

### `get_recent_dirs() -> PackedStringArray`
- 限定：qualifiers=const

Returns the list of recently visited folders in the file dialog for this project.

### `get_setting(name: String) -> Variant`
- 限定：qualifiers=const

Returns the value of the setting specified by `name`. This is equivalent to using `Object.get` on the EditorSettings instance.

### `get_shortcut(path: String) -> Shortcut`
- 限定：qualifiers=const

Returns the shortcut specified by `path`. Tries to find a built-in action if no shortcut with the provided path is found in the shortcut list. If found, adds it to the list and returns it, otherwise returns `null`.

### `get_shortcut_list() -> PackedStringArray`

Returns the list of stored shortcut paths.

### `has_setting(name: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the setting specified by `name` exists, `false` otherwise.

### `has_shortcut(path: String) -> bool`
- 限定：qualifiers=const

Returns `true` if the shortcut specified by `path` exists, `false` otherwise.

### `is_shortcut(path: String, event: InputEvent) -> bool`
- 限定：qualifiers=const

Returns `true` if the shortcut specified by `path` matches the event specified by `event`, `false` otherwise.

### `mark_setting_changed(setting: String) -> void`

Marks the passed editor setting as being changed, see `get_changed_settings`. Only settings which exist (see `has_setting`) will be accepted.

### `remove_shortcut(path: String) -> void`

Removes the shortcut specified by `path`.

### `set_builtin_action_override(name: String, actions_list: InputEvent[]) -> void`

Overrides the built-in editor action `name` with the input actions defined in `actions_list`.

### `set_favorites(dirs: PackedStringArray) -> void`

Sets the list of favorite files and directories for this project.

### `set_initial_value(name: StringName, value: Variant, update_current: bool) -> void`

Sets the initial value of the setting specified by `name` to `value`. This is used to provide a value for the Revert button in the Editor Settings. If `update_current` is `true`, the setting is reset to `value` as well.

### `set_project_metadata(section: String, key: String, data: Variant) -> void`

Sets project-specific metadata with the `section`, `key` and `data` specified. This metadata is stored outside the project folder and therefore won't be checked into version control. See also `get_project_metadata`.

### `set_recent_dirs(dirs: PackedStringArray) -> void`

Sets the list of recently visited folders in the file dialog for this project.

### `set_setting(name: String, value: Variant) -> void`

Sets the `value` of the setting specified by `name`. This is equivalent to using `Object.set` on the EditorSettings instance.

## 信号

### `settings_changed()`

Emitted after any editor setting has changed.

## 常量

- **`NOTIFICATION_EDITOR_SETTINGS_CHANGED`** = `10000`
