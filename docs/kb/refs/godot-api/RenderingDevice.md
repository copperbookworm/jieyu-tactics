# RenderingDevice

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`RenderingDevice` → `Object`
> 附加属性：api_type=core
> 自动生成，勿手改。文件：`refs/godot-api/RenderingDevice.md`

**摘要**：Abstraction for working with modern low-level graphics APIs.

## 描述

`RenderingDevice` is an abstraction for working with modern low-level graphics APIs such as Vulkan. Compared to `RenderingServer` (which works with Godot's own rendering subsystems), `RenderingDevice` is much lower-level and allows working more directly with the underlying graphics APIs. `RenderingDevice` is used in Godot to provide support for several modern low-level graphics APIs while reducing the amount of code duplication required. `RenderingDevice` can also be used in your own projects to perform things that are not exposed by `RenderingServer` or high-level nodes, such as using compute shaders.
		On startup, Godot creates a global `RenderingDevice` which can be retrieved using `RenderingServer.get_rendering_device`. This global `RenderingDevice` performs drawing to the screen.
		**Local RenderingDevices:** Using `RenderingServer.create_local_rendering_device`, you can create "secondary" rendering devices to perform drawing and GPU compute operations on separate threads.
		**Note:** `RenderingDevice` assumes intermediate knowledge of modern graphics APIs such as Vulkan, Direct3D 12, Metal or WebGPU. These graphics APIs are lower-level than OpenGL or Direct3D 11, requiring you to perform what was previously done by the graphics driver itself. If you have difficulty understanding the concepts used in this class, follow the Vulkan Tutorial (https://vulkan-tutorial.com/) or Vulkan Guide (https://vkguide.dev/). It's recommended to have existing modern OpenGL or Direct3D 11 knowledge before attempting to learn a low-level graphics API.
		**Note:** `RenderingDevice` is not available when running in headless mode or when using the Compatibility rendering method.

## 方法

### `barrier(from: int = 32767, to: int = 32767) -> void`
- 限定：deprecated=Barriers are automatically inserted by RenderingDevice.

This method does nothing.

### `blas_build(blas: RID) -> int`
- 限定：experimental=

Builds the `blas`.

### `blas_create(geometries: RDAccelerationStructureGeometry[], flags: int) -> RID`
- 限定：experimental=

Creates a new Bottom-Level Acceleration Structure (BLAS). It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `buffer_clear(buffer: RID, offset: int, size_bytes: int) -> int`

Clears the contents of the `buffer`, clearing `size_bytes` bytes, starting at `offset`.
				Prints an error if:
				- the size isn't a multiple of four
				- the region specified by `offset` + `size_bytes` exceeds the buffer
				- a draw list is currently active (created by `draw_list_begin`)
				- a compute list is currently active (created by `compute_list_begin`)

### `buffer_copy(src_buffer: RID, dst_buffer: RID, src_offset: int, dst_offset: int, size: int) -> int`

Copies `size` bytes from the `src_buffer` at `src_offset` into `dst_buffer` at `dst_offset`.
				Prints an error if:
				- `size` exceeds the size of either `src_buffer` or `dst_buffer` at their corresponding offsets
				- a draw list is currently active (created by `draw_list_begin`)
				- a compute list is currently active (created by `compute_list_begin`)

### `buffer_get_data(buffer: RID, offset_bytes: int = 0, size_bytes: int = 0) -> PackedByteArray`

Returns a copy of the data of the specified `buffer`, optionally `offset_bytes` and `size_bytes` can be set to copy only a portion of the buffer.
				**Note:** This method will block the GPU from working until the data is retrieved. Refer to `buffer_get_data_async` for an alternative that returns the data in more performant way.

### `buffer_get_data_async(buffer: RID, callback: Callable, offset_bytes: int = 0, size_bytes: int = 0) -> int`

Asynchronous version of `buffer_get_data`. RenderingDevice will call `callback` in a certain amount of frames with the data the buffer had at the time of the request.
				**Note:** At the moment, the delay corresponds to the amount of frames specified by `ProjectSettings.rendering/rendering_device/vsync/frame_queue_size`.
				**Note:** Downloading large buffers can have a prohibitive cost for real-time even when using the asynchronous method due to hardware bandwidth limitations. When dealing with large resources, you can adjust settings such as `ProjectSettings.rendering/rendering_device/staging_buffer/block_size_kb` to improve the transfer speed at the cost of extra memory.
				
```gdscript
				func _buffer_get_data_callback(array):
					value = array.decode_u32(0)

				...

				rd.buffer_get_data_async(buffer, _buffer_get_data_callback)
				
```

### `buffer_get_device_address(buffer: RID) -> int`

Returns the address of the given `buffer` which can be passed to shaders in any way to access underlying data. Buffer must have been created with this feature enabled.
				**Note:** You must check that the GPU supports this functionality by calling `has_feature` with `SUPPORTS_BUFFER_DEVICE_ADDRESS` as a parameter.

### `buffer_update(buffer: RID, offset: int, size_bytes: int, data: PackedByteArray) -> int`

Updates a region of `size_bytes` bytes, starting at `offset`, in the buffer, with the specified `data`.
				Prints an error if:
				- the region specified by `offset` + `size_bytes` exceeds the buffer
				- a draw list is currently active (created by `draw_list_begin`)
				- a compute list is currently active (created by `compute_list_begin`)

### `capture_timestamp(name: String) -> void`

Creates a timestamp marker with the specified `name`. This is used for performance reporting with the `get_captured_timestamp_cpu_time`, `get_captured_timestamp_gpu_time` and `get_captured_timestamp_name` methods.

### `compute_list_add_barrier(compute_list: int) -> void`

Raises a Vulkan compute barrier in the specified `compute_list`.

### `compute_list_begin() -> int`

Starts a list of compute commands created with the `compute_*` methods. The returned value should be passed to other `compute_list_*` functions.
				Multiple compute lists cannot be created at the same time; you must finish the previous compute list first using `compute_list_end`.
				A simple compute operation might look like this (code is not a complete example):
				
```gdscript
				var rd = RenderingDevice.new()
				var compute_list = rd.compute_list_begin()

				rd.compute_list_bind_compute_pipeline(compute_list, compute_shader_dilate_pipeline)
				rd.compute_list_bind_uniform_set(compute_list, compute_base_uniform_set, 0)
				rd.compute_list_bind_uniform_set(compute_list, dilate_uniform_set, 1)

				for i in atlas_slices:
					rd.compute_list_set_push_constant(compute_list, push_constant, push_constant.size())
					rd.compute_list_dispatch(compute_list, group_size.x, group_size.y, group_size.z)
					# No barrier, let them run all together.

				rd.compute_list_end()
				
```

### `compute_list_bind_compute_pipeline(compute_list: int, compute_pipeline: RID) -> void`

Tells the GPU what compute pipeline to use when processing the compute list. If the shader has changed since the last time this function was called, Godot will unbind all descriptor sets and will re-bind them inside `compute_list_dispatch`.

### `compute_list_bind_uniform_set(compute_list: int, uniform_set: RID, set_index: int) -> void`

Binds the `uniform_set` to this `compute_list`. Godot ensures that all textures in the uniform set have the correct Vulkan access masks. If Godot had to change access masks of textures, it will raise a Vulkan image memory barrier.

### `compute_list_dispatch(compute_list: int, x_groups: int, y_groups: int, z_groups: int) -> void`

Submits the compute list for processing on the GPU. This is the compute equivalent to `draw_list_draw`.

### `compute_list_dispatch_indirect(compute_list: int, buffer: RID, offset: int) -> void`

Submits the compute list for processing on the GPU with the given group counts stored in the `buffer` at `offset`. Buffer must have been created with `STORAGE_BUFFER_USAGE_DISPATCH_INDIRECT` flag.

### `compute_list_end() -> void`

Finishes a list of compute commands created with the `compute_*` methods.

### `compute_list_set_push_constant(compute_list: int, buffer: PackedByteArray, size_bytes: int) -> void`

Sets the push constant data to `buffer` for the specified `compute_list`. The shader determines how this binary data is used. The buffer's size in bytes must also be specified in `size_bytes` (this can be obtained by calling the `PackedByteArray.size` method on the passed `buffer`).

### `compute_pipeline_create(shader: RID, specialization_constants: RDPipelineSpecializationConstant[] = []) -> RID`

Creates a new compute pipeline. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when the `shader` is freed.

### `compute_pipeline_is_valid(compute_pipeline: RID) -> bool`

Returns `true` if the compute pipeline specified by the `compute_pipeline` RID is valid, `false` otherwise.

### `create_local_device() -> RenderingDevice`

Create a new local `RenderingDevice`. This is most useful for performing compute operations on the GPU independently from the rest of the engine.

### `draw_command_begin_label(name: String, color: Color) -> void`

Create a command buffer debug label region that can be displayed in third-party tools such as RenderDoc (https://renderdoc.org/). All regions must be ended with a `draw_command_end_label` call. When viewed from the linear series of submissions to a single queue, calls to `draw_command_begin_label` and `draw_command_end_label` must be matched and balanced.
				The `VK_EXT_DEBUG_UTILS_EXTENSION_NAME` Vulkan extension must be available and enabled for command buffer debug label region to work. See also `draw_command_end_label`.

### `draw_command_end_label() -> void`

Ends the command buffer debug label region started by a `draw_command_begin_label` call.

### `draw_command_insert_label(name: String, color: Color) -> void`
- 限定：deprecated=Inserting labels no longer applies due to command reordering.

This method does nothing.

### `draw_list_begin(framebuffer: RID, draw_flags: int = 0, clear_color_values: PackedColorArray = PackedColorArray(), clear_depth_value: float = 1.0, clear_stencil_value: int = 0, region: Rect2 = Rect2(0, 0, 0, 0), breadcrumb: int = 0) -> int`

Starts a list of raster drawing commands created with the `draw_*` methods. The returned value should be passed to other `draw_list_*` functions.
				Multiple draw lists cannot be created at the same time; you must finish the previous draw list first using `draw_list_end`.
				A simple drawing operation might look like this (code is not a complete example):
				
```gdscript
				var rd = RenderingDevice.new()
				var clear_colors = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 0)])
				var draw_list = rd.draw_list_begin(framebuffers`i`, RenderingDevice.CLEAR_COLOR_ALL, clear_colors, true, 1.0f, true, 0, Rect2(), RenderingDevice.OPAQUE_PASS)

				# Draw opaque.
				rd.draw_list_bind_render_pipeline(draw_list, raster_pipeline)
				rd.draw_list_bind_uniform_set(draw_list, raster_base_uniform, 0)
				rd.draw_list_set_push_constant(draw_list, raster_push_constant, raster_push_constant.size())
				rd.draw_list_draw(draw_list, false, 1, slice_triangle_count`i` * 3)
				# Draw wire.
				rd.draw_list_bind_render_pipeline(draw_list, raster_pipeline_wire)
				rd.draw_list_bind_uniform_set(draw_list, raster_base_uniform, 0)
				rd.draw_list_set_push_constant(draw_list, raster_push_constant, raster_push_constant.size())
				rd.draw_list_draw(draw_list, false, 1, slice_triangle_count`i` * 3)

				rd.draw_list_end()
				
```

				The `draw_flags` indicates if the texture attachments of the framebuffer should be cleared or ignored. Only one of the two flags can be used for each individual attachment. Ignoring an attachment means that any contents that existed before the draw list will be completely discarded, reducing the memory bandwidth used by the render pass but producing garbage results if the pixels aren't replaced. The default behavior allows the engine to figure out the right operation to use if the texture is discardable, which can result in increased performance. See `RDTextureFormat` or `texture_set_discardable`.
				The `breadcrumb` parameter can be an arbitrary 32-bit integer that is useful to diagnose GPU crashes. If Godot is built in dev or debug mode; when the GPU crashes Godot will dump all shaders that were being executed at the time of the crash and the breadcrumb is useful to diagnose what passes did those shaders belong to.
				It does not affect rendering behavior and can be set to 0. It is recommended to use `BreadcrumbMarker` enumerations for consistency but it's not required. It is also possible to use bitwise operations to add extra data. e.g.
				
```gdscript
				rd.draw_list_begin(fb`i`, RenderingDevice.CLEAR_COLOR_ALL, clear_colors, true, 1.0f, true, 0, Rect2(), RenderingDevice.OPAQUE_PASS | 5)
				
```

### `draw_list_begin_for_screen(screen: int = 0, clear_color: Color = Color(0, 0, 0, 1)) -> int`

High-level variant of `draw_list_begin`, with the parameters automatically being adjusted for drawing onto the window specified by the `screen` ID.
				**Note:** Cannot be used with local RenderingDevices, as these don't have a screen. If called on a local RenderingDevice, `draw_list_begin_for_screen` returns `INVALID_ID`.

### `draw_list_begin_split(framebuffer: RID, splits: int, initial_color_action: int, final_color_action: int, initial_depth_action: int, final_depth_action: int, clear_color_values: PackedColorArray = PackedColorArray(), clear_depth: float = 1.0, clear_stencil: int = 0, region: Rect2 = Rect2(0, 0, 0, 0), storage_textures: RID[] = []) -> PackedInt64Array`
- 限定：deprecated=Split draw lists are used automatically by RenderingDevice.

This method does nothing and always returns an empty `PackedInt64Array`.

### `draw_list_bind_index_array(draw_list: int, index_array: RID) -> void`

Binds `index_array` to the specified `draw_list`.

### `draw_list_bind_render_pipeline(draw_list: int, render_pipeline: RID) -> void`

Binds `render_pipeline` to the specified `draw_list`.

### `draw_list_bind_uniform_set(draw_list: int, uniform_set: RID, set_index: int) -> void`

Binds `uniform_set` to the specified `draw_list`. A `set_index` must also be specified, which is an identifier starting from `0` that must match the one expected by the draw list.

### `draw_list_bind_vertex_array(draw_list: int, vertex_array: RID) -> void`

Binds `vertex_array` to the specified `draw_list`.

### `draw_list_bind_vertex_buffers_format(draw_list: int, vertex_format: int, vertex_count: int, vertex_buffers: RID[], offsets: PackedInt64Array = PackedInt64Array()) -> void`

Binds a set of `vertex_buffers` directly to the specified `draw_list` using `vertex_format` without creating a vertex array RID. Provide the number of vertices in `vertex_count`; optional per-buffer byte `offsets` may also be supplied.

### `draw_list_disable_scissor(draw_list: int) -> void`

Removes and disables the scissor rectangle for the specified `draw_list`. See also `draw_list_enable_scissor`.

### `draw_list_draw(draw_list: int, use_indices: bool, instances: int, procedural_vertex_count: int = 0) -> void`

Submits `draw_list` for rendering on the GPU. This is the raster equivalent to `compute_list_dispatch`.

### `draw_list_draw_indirect(draw_list: int, use_indices: bool, buffer: RID, offset: int = 0, draw_count: int = 1, stride: int = 0) -> void`

Submits `draw_list` for rendering on the GPU with the given parameters stored in the `buffer` at `offset`. Parameters being integers: vertex count, instance count, first vertex, first instance. And when using indices: index count, instance count, first index, vertex offset, first instance. Buffer must have been created with `STORAGE_BUFFER_USAGE_DISPATCH_INDIRECT` flag.

### `draw_list_enable_scissor(draw_list: int, rect: Rect2 = Rect2(0, 0, 0, 0)) -> void`

Creates a scissor rectangle and enables it for the specified `draw_list`. Scissor rectangles are used for clipping by discarding fragments that fall outside a specified rectangular portion of the screen. See also `draw_list_disable_scissor`.
				**Note:** The specified `rect` is automatically intersected with the screen's dimensions, which means it cannot exceed the screen's dimensions.

### `draw_list_end() -> void`

Finishes a list of raster drawing commands created with the `draw_*` methods.

### `draw_list_set_blend_constants(draw_list: int, color: Color) -> void`

Sets blend constants for the specified `draw_list` to `color`. Blend constants are used only if the graphics pipeline is created with `DYNAMIC_STATE_BLEND_CONSTANTS` flag set.

### `draw_list_set_push_constant(draw_list: int, buffer: PackedByteArray, size_bytes: int) -> void`

Sets the push constant data to `buffer` for the specified `draw_list`. The shader determines how this binary data is used. The buffer's size in bytes must also be specified in `size_bytes` (this can be obtained by calling the `PackedByteArray.size` method on the passed `buffer`).

### `draw_list_switch_to_next_pass() -> int`

Switches to the next draw pass.

### `draw_list_switch_to_next_pass_split(splits: int) -> PackedInt64Array`
- 限定：deprecated=Split draw lists are used automatically by RenderingDevice.

This method does nothing and always returns an empty `PackedInt64Array`.

### `framebuffer_create(textures: RID[], validate_with_format: int = -1, view_count: int = 1) -> RID`

Creates a new framebuffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when any of the `textures` is freed.

### `framebuffer_create_empty(size: Vector2i, samples: int = 0, validate_with_format: int = -1) -> RID`

Creates a new empty framebuffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `framebuffer_create_multipass(textures: RID[], passes: RDFramebufferPass[], validate_with_format: int = -1, view_count: int = 1) -> RID`

Creates a new multipass framebuffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when any of the `textures` is freed.

### `framebuffer_format_create(attachments: RDAttachmentFormat[], view_count: int = 1) -> int`

Creates a new framebuffer format with the specified `attachments` and `view_count`. Returns the new framebuffer's unique framebuffer format ID.
				If `view_count` is greater than or equal to `2`, enables multiview which is used for VR rendering. This requires support for the Vulkan multiview extension.

### `framebuffer_format_create_empty(samples: int = 0) -> int`

Creates a new empty framebuffer format with the specified number of `samples` and returns its ID.

### `framebuffer_format_create_multipass(attachments: RDAttachmentFormat[], passes: RDFramebufferPass[], view_count: int = 1) -> int`

Creates a multipass framebuffer format with the specified `attachments`, `passes` and `view_count` and returns its ID. If `view_count` is greater than or equal to `2`, enables multiview which is used for VR rendering. This requires support for the Vulkan multiview extension.

### `framebuffer_format_get_texture_samples(format: int, render_pass: int = 0) -> int`

Returns the number of texture samples used for the given framebuffer `format` ID (returned by `framebuffer_get_format`).

### `framebuffer_get_format(framebuffer: RID) -> int`

Returns the format ID of the framebuffer specified by the `framebuffer` RID. This ID is guaranteed to be unique for the same formats and does not need to be freed.

### `framebuffer_is_valid(framebuffer: RID) -> bool`
- 限定：qualifiers=const

Returns `true` if the framebuffer specified by the `framebuffer` RID is valid, `false` otherwise.

### `free_rid(rid: RID) -> void`

Tries to free an object in the RenderingDevice. To avoid memory leaks, this should be called after using an object as memory management does not occur automatically when using RenderingDevice directly.

### `full_barrier() -> void`
- 限定：deprecated=Barriers are automatically inserted by RenderingDevice.

This method does nothing.

### `get_captured_timestamp_cpu_time(index: int) -> int`
- 限定：qualifiers=const

Returns the timestamp in CPU time for the rendering step specified by `index` (in microseconds since the engine started). See also `get_captured_timestamp_gpu_time` and `capture_timestamp`.

### `get_captured_timestamp_gpu_time(index: int) -> int`
- 限定：qualifiers=const

Returns the timestamp in GPU time for the rendering step specified by `index` (in microseconds since the engine started). See also `get_captured_timestamp_cpu_time` and `capture_timestamp`.

### `get_captured_timestamp_name(index: int) -> String`
- 限定：qualifiers=const

Returns the timestamp's name for the rendering step specified by `index`. See also `capture_timestamp`.

### `get_captured_timestamps_count() -> int`
- 限定：qualifiers=const

Returns the total number of timestamps (rendering steps) available for profiling.

### `get_captured_timestamps_frame() -> int`
- 限定：qualifiers=const

Returns the index of the last frame rendered that has rendering timestamps available for querying.

### `get_device_allocation_count() -> int`
- 限定：qualifiers=const

Returns how many allocations the GPU has performed for internal driver structures.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_device_allocs_by_object_type(type: int) -> int`
- 限定：qualifiers=const

Same as `get_device_allocation_count` but filtered for a given object type.
				The type argument must be in range `[0; get_tracked_object_type_count - 1]`. If `get_tracked_object_type_count` is 0, then type argument is ignored and always returns 0.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_device_memory_by_object_type(type: int) -> int`
- 限定：qualifiers=const

Same as `get_device_total_memory` but filtered for a given object type.
				The type argument must be in range `[0; get_tracked_object_type_count - 1]`. If `get_tracked_object_type_count` is 0, then type argument is ignored and always returns 0.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_device_name() -> String`
- 限定：qualifiers=const

Returns the name of the video adapter (e.g. "GeForce GTX 1080/PCIe/SSE2"). Equivalent to `RenderingServer.get_video_adapter_name`. See also `get_device_vendor_name`.

### `get_device_pipeline_cache_uuid() -> String`
- 限定：qualifiers=const

Returns the universally unique identifier for the pipeline cache. This is used to cache shader files on disk, which avoids shader recompilations on subsequent engine runs. This UUID varies depending on the graphics card model, but also the driver version. Therefore, updating graphics drivers will invalidate the shader cache.

### `get_device_total_memory() -> int`
- 限定：qualifiers=const

Returns how much bytes the GPU is using.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_device_vendor_name() -> String`
- 限定：qualifiers=const

Returns the vendor of the video adapter (e.g. "NVIDIA Corporation"). Equivalent to `RenderingServer.get_video_adapter_vendor`. See also `get_device_name`.

### `get_driver_allocation_count() -> int`
- 限定：qualifiers=const

Returns how many allocations the GPU driver has performed for internal driver structures.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_driver_allocs_by_object_type(type: int) -> int`
- 限定：qualifiers=const

Same as `get_driver_allocation_count` but filtered for a given object type.
				The type argument must be in range `[0; get_tracked_object_type_count - 1]`. If `get_tracked_object_type_count` is 0, then type argument is ignored and always returns 0.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_driver_and_device_memory_report() -> String`
- 限定：qualifiers=const

Returns string report in CSV format using the following methods:
				- `get_tracked_object_name`
				- `get_tracked_object_type_count`
				- `get_driver_total_memory`
				- `get_driver_allocation_count`
				- `get_driver_memory_by_object_type`
				- `get_driver_allocs_by_object_type`
				- `get_device_total_memory`
				- `get_device_allocation_count`
				- `get_device_memory_by_object_type`
				- `get_device_allocs_by_object_type`
				This is only used by Vulkan in debug builds. Godot must also be started with the `--extra-gpu-memory-tracking` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html).

### `get_driver_memory_by_object_type(type: int) -> int`
- 限定：qualifiers=const

Same as `get_driver_total_memory` but filtered for a given object type.
				The type argument must be in range `[0; get_tracked_object_type_count - 1]`. If `get_tracked_object_type_count` is 0, then type argument is ignored and always returns 0.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_driver_resource(resource: int, rid: RID, index: int) -> int`

Returns the unique identifier of the driver `resource` for the specified `rid`. Some driver resource types ignore the specified `rid`. `index` is always ignored but must be specified anyway.

### `get_driver_total_memory() -> int`
- 限定：qualifiers=const

Returns how much bytes the GPU driver is using for internal driver structures.
				This is only used by Vulkan in debug builds and can return 0 when this information is not tracked or unknown.

### `get_frame_delay() -> int`
- 限定：qualifiers=const

Returns the frame count kept by the graphics API. Higher values result in higher input lag, but with more consistent throughput. For the main `RenderingDevice`, frames are cycled (usually 3 with triple-buffered V-Sync enabled). However, local `RenderingDevice`s only have 1 frame.

### `get_memory_usage(type: int) -> int`
- 限定：qualifiers=const

Returns the memory usage in bytes corresponding to the given `type`. When using Vulkan, these statistics are calculated by Vulkan Memory Allocator (https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator).

### `get_perf_report() -> String`
- 限定：qualifiers=const

Returns a string with a performance report from the past frame. Updates every frame.

### `get_tracked_object_name(type_index: int) -> String`
- 限定：qualifiers=const

Returns the name of the type of object for the given `type_index`. This value must be in range `[0; get_tracked_object_type_count - 1]`. If `get_tracked_object_type_count` is 0, then type argument is ignored and always returns the same string.
				The return value is important because it gives meaning to the types passed to `get_driver_memory_by_object_type`, `get_driver_allocs_by_object_type`, `get_device_memory_by_object_type`, and `get_device_allocs_by_object_type`. Examples of strings it can return (not exhaustive):
				- DEVICE_MEMORY
				- PIPELINE_CACHE
				- SWAPCHAIN_KHR
				- COMMAND_POOL
				Thus if e.g. `get_tracked_object_name(5)` returns "COMMAND_POOL", then `get_device_memory_by_object_type(5)` returns the bytes used by the GPU for command pools.
				This is only used by Vulkan in debug builds. Godot must also be started with the `--extra-gpu-memory-tracking` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html).

### `get_tracked_object_type_count() -> int`
- 限定：qualifiers=const

Returns how many types of trackable objects there are.
				This is only used by Vulkan in debug builds. Godot must also be started with the `--extra-gpu-memory-tracking` command line argument ($DOCS_URL/tutorials/editor/command_line_tutorial.html).

### `has_feature(feature: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the `feature` is supported by the GPU.

### `hit_sbt_create(raytracing_pipeline: RID, initial_hit_group_capacity: int) -> RID`
- 限定：experimental=

Creates a new hit shader binding table (SBT). It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when the `raytracing_pipeline` is freed.
				The hit SBT resizes itself as needed. `initial_hit_group_capacity` is used to allocate the initial backing memory.

### `hit_sbt_range_alloc(hit_sbt: RID, hit_group_count: int) -> int`
- 限定：experimental=

Allocates a contiguous range of SBT entries from `hit_sbt`.
				The returned value should be assigned to `RDAccelerationStructureInstance.hit_sbt_range`.
				During ray traversal, hit group index is computed as:
					(geometry index in `RDAccelerationStructureInstance.blas`)
					× (SBT stride used in `traceRayEXT`)
					+ (SBT offset used in `traceRayEXT`)
					+ (range offset)
				`hit_group_count` must be large enough to cover all SBT entries that may be indexed by this equation. This typically corresponds to:
					(geometry count in `RDAccelerationStructureInstance.blas`)
					× (SBT stride used in `traceRayEXT`)
				The allocated range is uninitialized and must be filled using `hit_sbt_range_update`.

### `hit_sbt_range_free(hit_sbt: RID, range: int) -> int`
- 限定：experimental=

Frees a hit SBT range previously allocated with `hit_sbt_range_alloc`.
				The range must not be in use by any acceleration structure after being freed.

### `hit_sbt_range_update(hit_sbt: RID, range: int, offset: int, hit_group_indices: PackedInt32Array) -> int`
- 限定：experimental=

Updates the contents of a hit SBT range.
				`hit_group_indices` specifies indices into the hit group array provided in `raytracing_pipeline_create`.
				The `offset` parameter specifies where within the allocated range the writing begins. This allows partial updates of a range. However, the complete range must be fully initialized before it is used in a raytracing dispatch.

### `hit_sbt_set_pipeline(hit_sbt: RID, raytracing_pipeline: RID) -> int`
- 限定：experimental=

Sets a new `raytracing_pipeline` for `hit_sbt`.
				The new pipeline must be a superset of the previous one. Existing hit groups must keep the same order and new hit groups should be appended to the end. This preserves existing SBT entries.
				The previous pipeline must remain valid during the call.

### `index_array_create(index_buffer: RID, index_offset: int, index_count: int) -> RID`

Creates a new index array. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when the `index_buffer` is freed.

### `index_buffer_create(size_indices: int, format: int, data: PackedByteArray = PackedByteArray(), use_restart_indices: bool = false, creation_bits: int = 0) -> RID`

Creates a new index buffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `limit_get(limit: int) -> int`
- 限定：qualifiers=const

Returns the value of the specified `limit`. This limit varies depending on the current graphics hardware (and sometimes the driver version). If the given limit is exceeded, rendering errors will occur.
				Limits for various graphics hardware can be found in the Vulkan Hardware Database (https://vulkan.gpuinfo.org/).

### `raytracing_list_begin() -> int`
- 限定：experimental=

Starts a list of raytracing commands. The returned value should be passed to other `raytracing_list_*` functions.
				Multiple raytracing lists cannot be created at the same time; you must finish the previous raytracing list first using `raytracing_list_end`.
				A simple raytracing operation might look like this (code is not a complete example):
				`codeblocks`
				`gdscript`
				var rd = RenderingDevice.new()
				assert(rd.has_feature(RenderingDevice.SUPPORTS_RAYTRACING_PIPELINE))

				# Create a BLAS for a mesh.
				var geometry = RDAccelerationStructureGeometry.new()
				geometry.flags = RenderingDevice.ACCELERATION_STRUCTURE_GEOMETRY_OPAQUE_BIT
				geometry.vertex_buffer = vertex_buffer
				geometry.vertex_stride = 12
				geometry.vertex_format = RenderingDevice.DATA_FORMAT_R32G32B32_SFLOAT
				geometry.vertex_count = 3
				geometry.index_buffer = index_buffer
				geometry.index_count = 3
				geometries.push_back(geometry)

				blas = rd.blas_create(`geometry`, 0)

				# Create TLAS.
				tlas = rd.tlas_create(1, 0)

				# Build acceleration structures.
				rd.blas_build(blas)

				var instance = RDAccelerationStructureInstance.new()
				instance.blas = blas

				instance.hit_sbt_range = rd.hit_sbt_range_alloc(hit_sbt, 1)
				rd.hit_sbt_range_update(hit_sbt, instance.hit_sbt_range, 0, [0])

				rd.tlas_build(tlas, `instance`)

				var raylist = rd.raytracing_list_begin()

				# Bind pipeline and uniforms.
				rd.raytracing_list_bind_raytracing_pipeline(raylist, raytracing_pipeline)
				rd.raytracing_list_bind_uniform_set(raylist, uniform_set, 0)

				# Trace rays.
				var width = get_viewport().size.x
				var height = get_viewport().size.y
				rd.raytracing_list_trace_rays(raylist, 0, hit_sbt, width, height, 1)

				rd.raytracing_list_end()

### `raytracing_list_bind_raytracing_pipeline(raytracing_list: int, raytracing_pipeline: RID) -> void`
- 限定：experimental=

Binds `raytracing_pipeline` to the specified `raytracing_list`.

### `raytracing_list_bind_uniform_set(raytracing_list: int, uniform_set: RID, set_index: int) -> void`
- 限定：experimental=

Binds the `uniform_set` to this `raytracing_list`.

### `raytracing_list_end() -> void`
- 限定：experimental=

Finishes a list of raytracing commands created with the `raytracing_*` methods.

### `raytracing_list_set_push_constant(raytracing_list: int, buffer: PackedByteArray, size_bytes: int) -> void`
- 限定：experimental=

Sets the push constant data to `buffer` for the specified `raytracing_list`. The shader determines how this binary data is used. The buffer's size in bytes must also be specified in `size_bytes` (this can be obtained by calling the `PackedByteArray.size` method on the passed `buffer`).

### `raytracing_list_trace_rays(raytracing_list: int, raygen_shader_index: int, hit_sbt: RID, width: int, height: int, depth: int) -> void`
- 限定：experimental=

Initializes a raytracing dispatch for `raytracing_list`, launching `width` × `height` × `depth` rays.
				`raygen_shader_index` selects the ray generation shader from the pipeline bound with `raytracing_list_bind_raytracing_pipeline`.
				`hit_sbt` must use the same pipeline bound to `raytracing_list`.

### `raytracing_pipeline_create(raygen_shaders: RDPipelineShader[], miss_shaders: RDPipelineShader[], hit_groups: RDHitGroup[], max_trace_recursion_depth: int) -> RID`
- 限定：experimental=

Creates a new raytracing pipeline. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				Each shader must provide the required stage. All stages must use compatible pipeline layouts. The pipeline selects the required stage from each shader.
				Input order defines stable indices used by the API:
				- `raygen_shaders` is indexed in `raytracing_list_trace_rays`.
				- `miss_shaders` is indexed in `traceRayEXT`.
				- `hit_groups` is indexed in `hit_sbt_range_update`.

### `raytracing_pipeline_is_valid(raytracing_pipeline: RID) -> bool`
- 限定：experimental=

Returns `true` if the raytracing pipeline specified by the `raytracing_pipeline` RID is valid, `false` otherwise.

### `render_pipeline_create(shader: RID, framebuffer_format: int, vertex_format: int, primitive: int, rasterization_state: RDPipelineRasterizationState, multisample_state: RDPipelineMultisampleState, stencil_state: RDPipelineDepthStencilState, color_blend_state: RDPipelineColorBlendState, dynamic_state_flags: int = 0, for_render_pass: int = 0, specialization_constants: RDPipelineSpecializationConstant[] = []) -> RID`

Creates a new render pipeline. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when the `shader` is freed.

### `render_pipeline_is_valid(render_pipeline: RID) -> bool`

Returns `true` if the render pipeline specified by the `render_pipeline` RID is valid, `false` otherwise.

### `sampler_create(state: RDSamplerState) -> RID`

Creates a new sampler. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `sampler_is_format_supported_for_filter(format: int, sampler_filter: int) -> bool`
- 限定：qualifiers=const

Returns `true` if implementation supports using a texture of `format` with the given `sampler_filter`.

### `screen_get_framebuffer_format(screen: int = 0) -> int`
- 限定：qualifiers=const

Returns the framebuffer format of the given screen.
				**Note:** Only the main `RenderingDevice` returned by `RenderingServer.get_rendering_device` has a format. If called on a local `RenderingDevice`, this method prints an error and returns `INVALID_ID`.

### `screen_get_height(screen: int = 0) -> int`
- 限定：qualifiers=const

Returns the window height matching the graphics API context for the given window ID (in pixels). Despite the parameter being named `screen`, this returns the *window* size. See also `screen_get_width`.
				**Note:** Only the main `RenderingDevice` returned by `RenderingServer.get_rendering_device` has a height. If called on a local `RenderingDevice`, this method prints an error and returns `INVALID_ID`.

### `screen_get_width(screen: int = 0) -> int`
- 限定：qualifiers=const

Returns the window width matching the graphics API context for the given window ID (in pixels). Despite the parameter being named `screen`, this returns the *window* size. See also `screen_get_height`.
				**Note:** Only the main `RenderingDevice` returned by `RenderingServer.get_rendering_device` has a width. If called on a local `RenderingDevice`, this method prints an error and returns `INVALID_ID`.

### `set_resource_name(id: RID, name: String) -> void`

Sets the resource name for `id` to `name`. This is used for debugging with third-party tools such as RenderDoc (https://renderdoc.org/).
				The following types of resources can be named: texture, sampler, vertex buffer, index buffer, uniform buffer, texture buffer, storage buffer, uniform set buffer, shader, render pipeline and compute pipeline. Framebuffers cannot be named. Attempting to name an incompatible resource type will print an error.
				**Note:** Resource names are only set when the engine runs in verbose mode (`OS.is_stdout_verbose` = `true`), or when using an engine build compiled with the `dev_mode=yes` SCons option. The graphics driver must also support the `VK_EXT_DEBUG_UTILS_EXTENSION_NAME` Vulkan extension for named resources to work.

### `shader_compile_binary_from_spirv(spirv_data: RDShaderSPIRV, name: String = "") -> PackedByteArray`

Compiles a binary shader from `spirv_data` and returns the compiled binary data as a `PackedByteArray`. This compiled shader is specific to the GPU model and driver version used; it will not work on different GPU models or even different driver versions. See also `shader_compile_spirv_from_source`.
				`name` is an optional human-readable name that can be given to the compiled shader for organizational purposes.

### `shader_compile_spirv_from_source(shader_source: RDShaderSource, allow_cache: bool = true) -> RDShaderSPIRV`

Compiles a SPIR-V from the shader source code in `shader_source` and returns the SPIR-V as an `RDShaderSPIRV`. This intermediate language shader is portable across different GPU models and driver versions, but cannot be run directly by GPUs until compiled into a binary shader using `shader_compile_binary_from_spirv`.
				If `allow_cache` is `true`, make use of the shader cache generated by Godot. This avoids a potentially lengthy shader compilation step if the shader is already in cache. If `allow_cache` is `false`, Godot's shader cache is ignored and the shader will always be recompiled.

### `shader_create_from_bytecode(binary_data: PackedByteArray, placeholder_rid: RID = RID()) -> RID`

Creates a new shader instance from a binary compiled shader. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method. See also `shader_compile_binary_from_spirv` and `shader_create_from_spirv`.

### `shader_create_from_spirv(spirv_data: RDShaderSPIRV, name: String = "") -> RID`

Creates a new shader instance from SPIR-V intermediate code. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method. See also `shader_compile_spirv_from_source` and `shader_create_from_bytecode`.

### `shader_create_placeholder() -> RID`

Create a placeholder RID by allocating an RID without initializing it for use in `shader_create_from_bytecode`. This allows you to create an RID for a shader and pass it around, but defer compiling the shader to a later time.

### `shader_get_vertex_input_attribute_mask(shader: RID) -> int`

Returns the internal vertex input mask. Internally, the vertex input mask is an unsigned integer consisting of the locations (specified in GLSL via. `layout(location = ...)`) of the input variables (specified in GLSL by the `in` keyword).

### `storage_buffer_create(size_bytes: int, data: PackedByteArray = PackedByteArray(), usage: int = 0, creation_bits: int = 0) -> RID`

Creates a storage buffer (https://vkguide.dev/docs/chapter-4/storage_buffers/) with the specified `data` and `usage`. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `submit() -> void`

Pushes the frame setup and draw command buffers then marks the local device as currently processing (which allows calling `sync`).
				**Note:** Only available in local RenderingDevices.

### `sync() -> void`

Forces a synchronization between the CPU and GPU, which may be required in certain cases. Only call this when needed, as CPU-GPU synchronization has a performance cost.
				**Note:** Only available in local RenderingDevices.
				**Note:** `sync` can only be called after a `submit`.

### `texture_buffer_create(size_bytes: int, format: int, data: PackedByteArray = PackedByteArray()) -> RID`

Creates a new texture buffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `texture_clear(texture: RID, color: Color, base_mipmap: int, mipmap_count: int, base_layer: int, layer_count: int) -> int`

Clears the specified `texture` by replacing all of its pixels with the specified `color`. `base_mipmap` and `mipmap_count` determine which mipmaps of the texture are affected by this clear operation, while `base_layer` and `layer_count` determine which layers of a 3D texture (or texture array) are affected by this clear operation. For 2D textures (which only have one layer by design), `base_layer` must be `0` and `layer_count` must be `1`.
				**Note:** `texture` can't be cleared while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to clear this texture.

### `texture_copy(from_texture: RID, to_texture: RID, from_pos: Vector3, to_pos: Vector3, size: Vector3, src_mipmap: int, dst_mipmap: int, src_layer: int, dst_layer: int) -> int`

Copies the `from_texture` to `to_texture` with the specified `from_pos`, `to_pos` and `size` coordinates. For 2-dimensional textures, `from_pos` and `to_pos` must have a Z axis of `0`, and `size` must have a Z axis of `1`. Source and destination mipmaps/layers must also be specified, with these parameters being `0` for textures without mipmaps or single-layer textures. Returns `@GlobalScope.OK` if the texture copy was successful or `@GlobalScope.ERR_INVALID_PARAMETER` otherwise.
				**Note:** `from_texture` texture can't be copied while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to copy this texture.
				**Note:** `from_texture` texture requires the `TEXTURE_USAGE_CAN_COPY_FROM_BIT` to be retrieved.
				**Note:** `to_texture` can't be copied while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to copy this texture.
				**Note:** `to_texture` requires the `TEXTURE_USAGE_CAN_COPY_TO_BIT` to be retrieved.
				**Note:** `from_texture` and `to_texture` must be of the same type (color or depth).

### `texture_create(format: RDTextureFormat, view: RDTextureView, data: PackedByteArray[] = []) -> RID`

Creates a new texture. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				**Note:** `data` takes an `Array` of `PackedByteArray`s. For `TEXTURE_TYPE_1D`, `TEXTURE_TYPE_2D`, and `TEXTURE_TYPE_3D` types, this array should only have one element, a `PackedByteArray` containing all the data for the texture. For `_ARRAY` and `_CUBE` types, the length should be the same as the number of `RDTextureFormat.array_layers` in `format`.
				**Note:** Not to be confused with `RenderingServer.texture_2d_create`, which creates the Godot-specific `Texture2D` resource as opposed to the graphics API's own texture type.

### `texture_create_from_extension(type: int, format: int, samples: int, usage_flags: int, image: int, width: int, height: int, depth: int, layers: int, mipmaps: int = 1) -> RID`

Returns an RID for an existing `image` (`VkImage`) with the given `type`, `format`, `samples`, `usage_flags`, `width`, `height`, `depth`, `layers`, and `mipmaps`. This can be used to allow Godot to render onto foreign images.

### `texture_create_shared(view: RDTextureView, with_texture: RID) -> RID`

Creates a shared texture using the specified `view` and the texture information from `with_texture`.
				This will be freed automatically when the `with_texture` is freed.

### `texture_create_shared_from_slice(view: RDTextureView, with_texture: RID, layer: int, mipmap: int, mipmaps: int = 1, slice_type: int = 0) -> RID`

Creates a shared texture using the specified `view` and the texture information from `with_texture`'s `layer` and `mipmap`. The number of included mipmaps from the original texture can be controlled using the `mipmaps` parameter. Only relevant for textures with multiple layers, such as 3D textures, texture arrays and cubemaps. For single-layer textures, use `texture_create_shared`.
				For 2D textures (which only have one layer), `layer` must be `0`.
				**Note:** Layer slicing is only supported for 2D texture arrays, not 3D textures or cubemaps.
				This will be freed automatically when the `with_texture` is freed.

### `texture_get_data(texture: RID, layer: int) -> PackedByteArray`

Returns the `texture` data for the specified `layer` as raw binary data. For 2D textures (which only have one layer), `layer` must be `0`.
				**Note:** `texture` can't be retrieved while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to retrieve this texture. Otherwise, an error is printed and an empty `PackedByteArray` is returned.
				**Note:** `texture` requires the `TEXTURE_USAGE_CAN_COPY_FROM_BIT` to be retrieved. Otherwise, an error is printed and an empty `PackedByteArray` is returned.
				**Note:** This method will block the GPU from working until the data is retrieved. Refer to `texture_get_data_async` for an alternative that returns the data in more performant way.

### `texture_get_data_async(texture: RID, layer: int, callback: Callable) -> int`

Asynchronous version of `texture_get_data`. RenderingDevice will call `callback` in a certain amount of frames with the data the texture had at the time of the request.
				**Note:** At the moment, the delay corresponds to the amount of frames specified by `ProjectSettings.rendering/rendering_device/vsync/frame_queue_size`.
				**Note:** Downloading large textures can have a prohibitive cost for real-time even when using the asynchronous method due to hardware bandwidth limitations. When dealing with large resources, you can adjust settings such as `ProjectSettings.rendering/rendering_device/staging_buffer/texture_download_region_size_px` and `ProjectSettings.rendering/rendering_device/staging_buffer/block_size_kb` to improve the transfer speed at the cost of extra memory.
				
```gdscript
				func _texture_get_data_callback(array):
					value = array.decode_u32(0)

				...

				rd.texture_get_data_async(texture, 0, _texture_get_data_callback)
				
```

### `texture_get_format(texture: RID) -> RDTextureFormat`

Returns the data format used to create this texture.

### `texture_get_native_handle(texture: RID) -> int`
- 限定：deprecated=Use [method get_driver_resource] with [constant DRIVER_RESOURCE_TEXTURE] instead.

Returns the internal graphics handle for this texture object. For use when communicating with third-party APIs mostly with GDExtension.
				**Note:** This function returns a `uint64_t` which internally maps to a `GLuint` (OpenGL) or `VkImage` (Vulkan).

### `texture_is_discardable(texture: RID) -> bool`

Returns `true` if the `texture` is discardable, `false` otherwise. See `RDTextureFormat` or `texture_set_discardable`.

### `texture_is_format_supported_for_usage(format: int, usage_flags: int) -> bool`
- 限定：qualifiers=const

Returns `true` if the specified `format` is supported for the given `usage_flags`, `false` otherwise.

### `texture_is_shared(texture: RID) -> bool`

Returns `true` if the `texture` is shared, `false` otherwise. See `RDTextureView`.

### `texture_is_valid(texture: RID) -> bool`

Returns `true` if the `texture` is valid, `false` otherwise.

### `texture_resolve_multisample(from_texture: RID, to_texture: RID) -> int`

Resolves the `from_texture` texture onto `to_texture` with multisample antialiasing enabled. This must be used when rendering a framebuffer for MSAA to work. Returns `@GlobalScope.OK` if successful, `@GlobalScope.ERR_INVALID_PARAMETER` otherwise.
				**Note:** `from_texture` and `to_texture` textures must have the same dimension, format and type (color or depth).
				**Note:** `from_texture` can't be copied while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to resolve this texture.
				**Note:** `from_texture` requires the `TEXTURE_USAGE_CAN_COPY_FROM_BIT` to be retrieved.
				**Note:** `from_texture` must be multisampled and must also be 2D (or a slice of a 3D/cubemap texture).
				**Note:** `to_texture` can't be copied while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to resolve this texture.
				**Note:** `to_texture` texture requires the `TEXTURE_USAGE_CAN_COPY_TO_BIT` to be retrieved.
				**Note:** `to_texture` texture must **not** be multisampled and must also be 2D (or a slice of a 3D/cubemap texture).

### `texture_set_discardable(texture: RID, discardable: bool) -> void`

Updates the discardable property of `texture`.
				If a texture is discardable, its contents do not need to be preserved between frames. This flag is only relevant when the texture is used as target in a draw list.
				This information is used by `RenderingDevice` to figure out if a texture's contents can be discarded, eliminating unnecessary writes to memory and boosting performance.

### `texture_update(texture: RID, layer: int, data: PackedByteArray) -> int`

Updates texture data with new data, replacing the previous data in place. The updated texture data must have the same dimensions and format. For 2D textures (which only have one layer), `layer` must be `0`. Returns `@GlobalScope.OK` if the update was successful, `@GlobalScope.ERR_INVALID_PARAMETER` otherwise.
				**Note:** Updating textures is forbidden during creation of a draw or compute list.
				**Note:** The existing `texture` can't be updated while a draw list that uses it as part of a framebuffer is being created. Ensure the draw list is finalized (and that the color/depth texture using it is not set to `FINAL_ACTION_CONTINUE`) to update this texture.
				**Note:** The existing `texture` requires the `TEXTURE_USAGE_CAN_UPDATE_BIT` to be updatable.

### `tlas_build(tlas: RID, instances: RDAccelerationStructureInstance[]) -> int`
- 限定：experimental=

Builds the `tlas`. The contents of previous builds are discarded.
				Any BLAS provided through the `RDAccelerationStructureInstance.blas` member must already have been built using the `blas_build` method.
				The number of instances can be equal to or smaller than the maximum instance count provided in the `tlas_create` method.
				**Note:** Freeing or rebuilding any of the provided BLASes after this method invalidates the TLAS and requires it to be rebuilt.

### `tlas_create(max_instance_count: int, flags: int) -> RID`
- 限定：experimental=

Creates a new Top-Level Acceleration Structure (TLAS). It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `uniform_buffer_create(size_bytes: int, data: PackedByteArray = PackedByteArray(), creation_bits: int = 0) -> RID`

Creates a new uniform buffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `uniform_set_create(uniforms: RDUniform[], shader: RID, shader_set: int) -> RID`

Creates a new uniform set. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when the `shader` or any of the RIDs in the `uniforms` is freed.

### `uniform_set_is_valid(uniform_set: RID) -> bool`

Checks if the `uniform_set` is valid, i.e. is owned.

### `vertex_array_create(vertex_count: int, vertex_format: int, src_buffers: RID[], offsets: PackedInt64Array = PackedInt64Array()) -> RID`

Creates a vertex array based on the specified buffers. Optionally, `offsets` (in bytes) may be defined for each buffer.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.
				This will be freed automatically when any of the `src_buffers` is freed.

### `vertex_buffer_create(size_bytes: int, data: PackedByteArray = PackedByteArray(), creation_bits: int = 0) -> RID`

Creates a new vertex buffer. It can be accessed with the RID that is returned.
				Once finished with your RID, you will want to free the RID using the RenderingDevice's `free_rid` method.

### `vertex_format_create(vertex_descriptions: RDVertexAttribute[]) -> int`

Creates a new vertex format with the specified `vertex_descriptions`. Returns a unique vertex format ID corresponding to the newly created vertex format.

## 枚举

### `DeviceType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DEVICE_TYPE_OTHER` |  |
| `1` | `DEVICE_TYPE_INTEGRATED_GPU` |  |
| `2` | `DEVICE_TYPE_DISCRETE_GPU` |  |
| `3` | `DEVICE_TYPE_VIRTUAL_GPU` |  |
| `4` | `DEVICE_TYPE_CPU` |  |
| `5` | `DEVICE_TYPE_MAX` |  |

### `DriverResource`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRIVER_RESOURCE_LOGICAL_DEVICE` |  |
| `1` | `DRIVER_RESOURCE_PHYSICAL_DEVICE` |  |
| `2` | `DRIVER_RESOURCE_TOPMOST_OBJECT` |  |
| `3` | `DRIVER_RESOURCE_COMMAND_QUEUE` |  |
| `4` | `DRIVER_RESOURCE_QUEUE_FAMILY` |  |
| `5` | `DRIVER_RESOURCE_TEXTURE` |  |
| `6` | `DRIVER_RESOURCE_TEXTURE_VIEW` |  |
| `7` | `DRIVER_RESOURCE_TEXTURE_DATA_FORMAT` |  |
| `8` | `DRIVER_RESOURCE_SAMPLER` |  |
| `9` | `DRIVER_RESOURCE_UNIFORM_SET` |  |
| `10` | `DRIVER_RESOURCE_BUFFER` |  |
| `11` | `DRIVER_RESOURCE_COMPUTE_PIPELINE` |  |
| `12` | `DRIVER_RESOURCE_RENDER_PIPELINE` |  |
| `0` | `DRIVER_RESOURCE_VULKAN_DEVICE` |  |
| `1` | `DRIVER_RESOURCE_VULKAN_PHYSICAL_DEVICE` |  |
| `2` | `DRIVER_RESOURCE_VULKAN_INSTANCE` |  |
| `3` | `DRIVER_RESOURCE_VULKAN_QUEUE` |  |
| `4` | `DRIVER_RESOURCE_VULKAN_QUEUE_FAMILY_INDEX` |  |
| `5` | `DRIVER_RESOURCE_VULKAN_IMAGE` |  |
| `6` | `DRIVER_RESOURCE_VULKAN_IMAGE_VIEW` |  |
| `7` | `DRIVER_RESOURCE_VULKAN_IMAGE_NATIVE_TEXTURE_FORMAT` |  |
| `8` | `DRIVER_RESOURCE_VULKAN_SAMPLER` |  |
| `9` | `DRIVER_RESOURCE_VULKAN_DESCRIPTOR_SET` |  |
| `10` | `DRIVER_RESOURCE_VULKAN_BUFFER` |  |
| `11` | `DRIVER_RESOURCE_VULKAN_COMPUTE_PIPELINE` |  |
| `12` | `DRIVER_RESOURCE_VULKAN_RENDER_PIPELINE` |  |

### `DataFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DATA_FORMAT_R4G4_UNORM_PACK8` |  |
| `1` | `DATA_FORMAT_R4G4B4A4_UNORM_PACK16` |  |
| `2` | `DATA_FORMAT_B4G4R4A4_UNORM_PACK16` |  |
| `3` | `DATA_FORMAT_R5G6B5_UNORM_PACK16` |  |
| `4` | `DATA_FORMAT_B5G6R5_UNORM_PACK16` |  |
| `5` | `DATA_FORMAT_R5G5B5A1_UNORM_PACK16` |  |
| `6` | `DATA_FORMAT_B5G5R5A1_UNORM_PACK16` |  |
| `7` | `DATA_FORMAT_A1R5G5B5_UNORM_PACK16` |  |
| `8` | `DATA_FORMAT_R8_UNORM` |  |
| `9` | `DATA_FORMAT_R8_SNORM` |  |
| `10` | `DATA_FORMAT_R8_USCALED` |  |
| `11` | `DATA_FORMAT_R8_SSCALED` |  |
| `12` | `DATA_FORMAT_R8_UINT` |  |
| `13` | `DATA_FORMAT_R8_SINT` |  |
| `14` | `DATA_FORMAT_R8_SRGB` |  |
| `15` | `DATA_FORMAT_R8G8_UNORM` |  |
| `16` | `DATA_FORMAT_R8G8_SNORM` |  |
| `17` | `DATA_FORMAT_R8G8_USCALED` |  |
| `18` | `DATA_FORMAT_R8G8_SSCALED` |  |
| `19` | `DATA_FORMAT_R8G8_UINT` |  |
| `20` | `DATA_FORMAT_R8G8_SINT` |  |
| `21` | `DATA_FORMAT_R8G8_SRGB` |  |
| `22` | `DATA_FORMAT_R8G8B8_UNORM` |  |
| `23` | `DATA_FORMAT_R8G8B8_SNORM` |  |
| `24` | `DATA_FORMAT_R8G8B8_USCALED` |  |
| `25` | `DATA_FORMAT_R8G8B8_SSCALED` |  |
| `26` | `DATA_FORMAT_R8G8B8_UINT` |  |
| `27` | `DATA_FORMAT_R8G8B8_SINT` |  |
| `28` | `DATA_FORMAT_R8G8B8_SRGB` |  |
| `29` | `DATA_FORMAT_B8G8R8_UNORM` |  |
| `30` | `DATA_FORMAT_B8G8R8_SNORM` |  |
| `31` | `DATA_FORMAT_B8G8R8_USCALED` |  |
| `32` | `DATA_FORMAT_B8G8R8_SSCALED` |  |
| `33` | `DATA_FORMAT_B8G8R8_UINT` |  |
| `34` | `DATA_FORMAT_B8G8R8_SINT` |  |
| `35` | `DATA_FORMAT_B8G8R8_SRGB` |  |
| `36` | `DATA_FORMAT_R8G8B8A8_UNORM` |  |
| `37` | `DATA_FORMAT_R8G8B8A8_SNORM` |  |
| `38` | `DATA_FORMAT_R8G8B8A8_USCALED` |  |
| `39` | `DATA_FORMAT_R8G8B8A8_SSCALED` |  |
| `40` | `DATA_FORMAT_R8G8B8A8_UINT` |  |
| `41` | `DATA_FORMAT_R8G8B8A8_SINT` |  |
| `42` | `DATA_FORMAT_R8G8B8A8_SRGB` |  |
| `43` | `DATA_FORMAT_B8G8R8A8_UNORM` |  |
| `44` | `DATA_FORMAT_B8G8R8A8_SNORM` |  |
| `45` | `DATA_FORMAT_B8G8R8A8_USCALED` |  |
| `46` | `DATA_FORMAT_B8G8R8A8_SSCALED` |  |
| `47` | `DATA_FORMAT_B8G8R8A8_UINT` |  |
| `48` | `DATA_FORMAT_B8G8R8A8_SINT` |  |
| `49` | `DATA_FORMAT_B8G8R8A8_SRGB` |  |
| `50` | `DATA_FORMAT_A8B8G8R8_UNORM_PACK32` |  |
| `51` | `DATA_FORMAT_A8B8G8R8_SNORM_PACK32` |  |
| `52` | `DATA_FORMAT_A8B8G8R8_USCALED_PACK32` |  |
| `53` | `DATA_FORMAT_A8B8G8R8_SSCALED_PACK32` |  |
| `54` | `DATA_FORMAT_A8B8G8R8_UINT_PACK32` |  |
| `55` | `DATA_FORMAT_A8B8G8R8_SINT_PACK32` |  |
| `56` | `DATA_FORMAT_A8B8G8R8_SRGB_PACK32` |  |
| `57` | `DATA_FORMAT_A2R10G10B10_UNORM_PACK32` |  |
| `58` | `DATA_FORMAT_A2R10G10B10_SNORM_PACK32` |  |
| `59` | `DATA_FORMAT_A2R10G10B10_USCALED_PACK32` |  |
| `60` | `DATA_FORMAT_A2R10G10B10_SSCALED_PACK32` |  |
| `61` | `DATA_FORMAT_A2R10G10B10_UINT_PACK32` |  |
| `62` | `DATA_FORMAT_A2R10G10B10_SINT_PACK32` |  |
| `63` | `DATA_FORMAT_A2B10G10R10_UNORM_PACK32` |  |
| `64` | `DATA_FORMAT_A2B10G10R10_SNORM_PACK32` |  |
| `65` | `DATA_FORMAT_A2B10G10R10_USCALED_PACK32` |  |
| `66` | `DATA_FORMAT_A2B10G10R10_SSCALED_PACK32` |  |
| `67` | `DATA_FORMAT_A2B10G10R10_UINT_PACK32` |  |
| `68` | `DATA_FORMAT_A2B10G10R10_SINT_PACK32` |  |
| `69` | `DATA_FORMAT_R16_UNORM` |  |
| `70` | `DATA_FORMAT_R16_SNORM` |  |
| `71` | `DATA_FORMAT_R16_USCALED` |  |
| `72` | `DATA_FORMAT_R16_SSCALED` |  |
| `73` | `DATA_FORMAT_R16_UINT` |  |
| `74` | `DATA_FORMAT_R16_SINT` |  |
| `75` | `DATA_FORMAT_R16_SFLOAT` |  |
| `76` | `DATA_FORMAT_R16G16_UNORM` |  |
| `77` | `DATA_FORMAT_R16G16_SNORM` |  |
| `78` | `DATA_FORMAT_R16G16_USCALED` |  |
| `79` | `DATA_FORMAT_R16G16_SSCALED` |  |
| `80` | `DATA_FORMAT_R16G16_UINT` |  |
| `81` | `DATA_FORMAT_R16G16_SINT` |  |
| `82` | `DATA_FORMAT_R16G16_SFLOAT` |  |
| `83` | `DATA_FORMAT_R16G16B16_UNORM` |  |
| `84` | `DATA_FORMAT_R16G16B16_SNORM` |  |
| `85` | `DATA_FORMAT_R16G16B16_USCALED` |  |
| `86` | `DATA_FORMAT_R16G16B16_SSCALED` |  |
| `87` | `DATA_FORMAT_R16G16B16_UINT` |  |
| `88` | `DATA_FORMAT_R16G16B16_SINT` |  |
| `89` | `DATA_FORMAT_R16G16B16_SFLOAT` |  |
| `90` | `DATA_FORMAT_R16G16B16A16_UNORM` |  |
| `91` | `DATA_FORMAT_R16G16B16A16_SNORM` |  |
| `92` | `DATA_FORMAT_R16G16B16A16_USCALED` |  |
| `93` | `DATA_FORMAT_R16G16B16A16_SSCALED` |  |
| `94` | `DATA_FORMAT_R16G16B16A16_UINT` |  |
| `95` | `DATA_FORMAT_R16G16B16A16_SINT` |  |
| `96` | `DATA_FORMAT_R16G16B16A16_SFLOAT` |  |
| `97` | `DATA_FORMAT_R32_UINT` |  |
| `98` | `DATA_FORMAT_R32_SINT` |  |
| `99` | `DATA_FORMAT_R32_SFLOAT` |  |
| `100` | `DATA_FORMAT_R32G32_UINT` |  |
| `101` | `DATA_FORMAT_R32G32_SINT` |  |
| `102` | `DATA_FORMAT_R32G32_SFLOAT` |  |
| `103` | `DATA_FORMAT_R32G32B32_UINT` |  |
| `104` | `DATA_FORMAT_R32G32B32_SINT` |  |
| `105` | `DATA_FORMAT_R32G32B32_SFLOAT` |  |
| `106` | `DATA_FORMAT_R32G32B32A32_UINT` |  |
| `107` | `DATA_FORMAT_R32G32B32A32_SINT` |  |
| `108` | `DATA_FORMAT_R32G32B32A32_SFLOAT` |  |
| `109` | `DATA_FORMAT_R64_UINT` |  |
| `110` | `DATA_FORMAT_R64_SINT` |  |
| `111` | `DATA_FORMAT_R64_SFLOAT` |  |
| `112` | `DATA_FORMAT_R64G64_UINT` |  |
| `113` | `DATA_FORMAT_R64G64_SINT` |  |
| `114` | `DATA_FORMAT_R64G64_SFLOAT` |  |
| `115` | `DATA_FORMAT_R64G64B64_UINT` |  |
| `116` | `DATA_FORMAT_R64G64B64_SINT` |  |
| `117` | `DATA_FORMAT_R64G64B64_SFLOAT` |  |
| `118` | `DATA_FORMAT_R64G64B64A64_UINT` |  |
| `119` | `DATA_FORMAT_R64G64B64A64_SINT` |  |
| `120` | `DATA_FORMAT_R64G64B64A64_SFLOAT` |  |
| `121` | `DATA_FORMAT_B10G11R11_UFLOAT_PACK32` |  |
| `122` | `DATA_FORMAT_E5B9G9R9_UFLOAT_PACK32` |  |
| `123` | `DATA_FORMAT_D16_UNORM` |  |
| `124` | `DATA_FORMAT_X8_D24_UNORM_PACK32` |  |
| `125` | `DATA_FORMAT_D32_SFLOAT` |  |
| `126` | `DATA_FORMAT_S8_UINT` |  |
| `127` | `DATA_FORMAT_D16_UNORM_S8_UINT` |  |
| `128` | `DATA_FORMAT_D24_UNORM_S8_UINT` |  |
| `129` | `DATA_FORMAT_D32_SFLOAT_S8_UINT` |  |
| `130` | `DATA_FORMAT_BC1_RGB_UNORM_BLOCK` |  |
| `131` | `DATA_FORMAT_BC1_RGB_SRGB_BLOCK` |  |
| `132` | `DATA_FORMAT_BC1_RGBA_UNORM_BLOCK` |  |
| `133` | `DATA_FORMAT_BC1_RGBA_SRGB_BLOCK` |  |
| `134` | `DATA_FORMAT_BC2_UNORM_BLOCK` |  |
| `135` | `DATA_FORMAT_BC2_SRGB_BLOCK` |  |
| `136` | `DATA_FORMAT_BC3_UNORM_BLOCK` |  |
| `137` | `DATA_FORMAT_BC3_SRGB_BLOCK` |  |
| `138` | `DATA_FORMAT_BC4_UNORM_BLOCK` |  |
| `139` | `DATA_FORMAT_BC4_SNORM_BLOCK` |  |
| `140` | `DATA_FORMAT_BC5_UNORM_BLOCK` |  |
| `141` | `DATA_FORMAT_BC5_SNORM_BLOCK` |  |
| `142` | `DATA_FORMAT_BC6H_UFLOAT_BLOCK` |  |
| `143` | `DATA_FORMAT_BC6H_SFLOAT_BLOCK` |  |
| `144` | `DATA_FORMAT_BC7_UNORM_BLOCK` |  |
| `145` | `DATA_FORMAT_BC7_SRGB_BLOCK` |  |
| `146` | `DATA_FORMAT_ETC2_R8G8B8_UNORM_BLOCK` |  |
| `147` | `DATA_FORMAT_ETC2_R8G8B8_SRGB_BLOCK` |  |
| `148` | `DATA_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK` |  |
| `149` | `DATA_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK` |  |
| `150` | `DATA_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK` |  |
| `151` | `DATA_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK` |  |
| `152` | `DATA_FORMAT_EAC_R11_UNORM_BLOCK` |  |
| `153` | `DATA_FORMAT_EAC_R11_SNORM_BLOCK` |  |
| `154` | `DATA_FORMAT_EAC_R11G11_UNORM_BLOCK` |  |
| `155` | `DATA_FORMAT_EAC_R11G11_SNORM_BLOCK` |  |
| `156` | `DATA_FORMAT_ASTC_4x4_UNORM_BLOCK` |  |
| `157` | `DATA_FORMAT_ASTC_4x4_SRGB_BLOCK` |  |
| `158` | `DATA_FORMAT_ASTC_5x4_UNORM_BLOCK` |  |
| `159` | `DATA_FORMAT_ASTC_5x4_SRGB_BLOCK` |  |
| `160` | `DATA_FORMAT_ASTC_5x5_UNORM_BLOCK` |  |
| `161` | `DATA_FORMAT_ASTC_5x5_SRGB_BLOCK` |  |
| `162` | `DATA_FORMAT_ASTC_6x5_UNORM_BLOCK` |  |
| `163` | `DATA_FORMAT_ASTC_6x5_SRGB_BLOCK` |  |
| `164` | `DATA_FORMAT_ASTC_6x6_UNORM_BLOCK` |  |
| `165` | `DATA_FORMAT_ASTC_6x6_SRGB_BLOCK` |  |
| `166` | `DATA_FORMAT_ASTC_8x5_UNORM_BLOCK` |  |
| `167` | `DATA_FORMAT_ASTC_8x5_SRGB_BLOCK` |  |
| `168` | `DATA_FORMAT_ASTC_8x6_UNORM_BLOCK` |  |
| `169` | `DATA_FORMAT_ASTC_8x6_SRGB_BLOCK` |  |
| `170` | `DATA_FORMAT_ASTC_8x8_UNORM_BLOCK` |  |
| `171` | `DATA_FORMAT_ASTC_8x8_SRGB_BLOCK` |  |
| `172` | `DATA_FORMAT_ASTC_10x5_UNORM_BLOCK` |  |
| `173` | `DATA_FORMAT_ASTC_10x5_SRGB_BLOCK` |  |
| `174` | `DATA_FORMAT_ASTC_10x6_UNORM_BLOCK` |  |
| `175` | `DATA_FORMAT_ASTC_10x6_SRGB_BLOCK` |  |
| `176` | `DATA_FORMAT_ASTC_10x8_UNORM_BLOCK` |  |
| `177` | `DATA_FORMAT_ASTC_10x8_SRGB_BLOCK` |  |
| `178` | `DATA_FORMAT_ASTC_10x10_UNORM_BLOCK` |  |
| `179` | `DATA_FORMAT_ASTC_10x10_SRGB_BLOCK` |  |
| `180` | `DATA_FORMAT_ASTC_12x10_UNORM_BLOCK` |  |
| `181` | `DATA_FORMAT_ASTC_12x10_SRGB_BLOCK` |  |
| `182` | `DATA_FORMAT_ASTC_12x12_UNORM_BLOCK` |  |
| `183` | `DATA_FORMAT_ASTC_12x12_SRGB_BLOCK` |  |
| `184` | `DATA_FORMAT_G8B8G8R8_422_UNORM` |  |
| `185` | `DATA_FORMAT_B8G8R8G8_422_UNORM` |  |
| `186` | `DATA_FORMAT_G8_B8_R8_3PLANE_420_UNORM` |  |
| `187` | `DATA_FORMAT_G8_B8R8_2PLANE_420_UNORM` |  |
| `188` | `DATA_FORMAT_G8_B8_R8_3PLANE_422_UNORM` |  |
| `189` | `DATA_FORMAT_G8_B8R8_2PLANE_422_UNORM` |  |
| `190` | `DATA_FORMAT_G8_B8_R8_3PLANE_444_UNORM` |  |
| `191` | `DATA_FORMAT_R10X6_UNORM_PACK16` |  |
| `192` | `DATA_FORMAT_R10X6G10X6_UNORM_2PACK16` |  |
| `193` | `DATA_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16` |  |
| `194` | `DATA_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16` |  |
| `195` | `DATA_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16` |  |
| `196` | `DATA_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16` |  |
| `197` | `DATA_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16` |  |
| `198` | `DATA_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16` |  |
| `199` | `DATA_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16` |  |
| `200` | `DATA_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16` |  |
| `201` | `DATA_FORMAT_R12X4_UNORM_PACK16` |  |
| `202` | `DATA_FORMAT_R12X4G12X4_UNORM_2PACK16` |  |
| `203` | `DATA_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16` |  |
| `204` | `DATA_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16` |  |
| `205` | `DATA_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16` |  |
| `206` | `DATA_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16` |  |
| `207` | `DATA_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16` |  |
| `208` | `DATA_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16` |  |
| `209` | `DATA_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16` |  |
| `210` | `DATA_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16` |  |
| `211` | `DATA_FORMAT_G16B16G16R16_422_UNORM` |  |
| `212` | `DATA_FORMAT_B16G16R16G16_422_UNORM` |  |
| `213` | `DATA_FORMAT_G16_B16_R16_3PLANE_420_UNORM` |  |
| `214` | `DATA_FORMAT_G16_B16R16_2PLANE_420_UNORM` |  |
| `215` | `DATA_FORMAT_G16_B16_R16_3PLANE_422_UNORM` |  |
| `216` | `DATA_FORMAT_G16_B16R16_2PLANE_422_UNORM` |  |
| `217` | `DATA_FORMAT_G16_B16_R16_3PLANE_444_UNORM` |  |
| `218` | `DATA_FORMAT_ASTC_4x4_SFLOAT_BLOCK` |  |
| `219` | `DATA_FORMAT_ASTC_5x4_SFLOAT_BLOCK` |  |
| `220` | `DATA_FORMAT_ASTC_5x5_SFLOAT_BLOCK` |  |
| `221` | `DATA_FORMAT_ASTC_6x5_SFLOAT_BLOCK` |  |
| `222` | `DATA_FORMAT_ASTC_6x6_SFLOAT_BLOCK` |  |
| `223` | `DATA_FORMAT_ASTC_8x5_SFLOAT_BLOCK` |  |
| `224` | `DATA_FORMAT_ASTC_8x6_SFLOAT_BLOCK` |  |
| `225` | `DATA_FORMAT_ASTC_8x8_SFLOAT_BLOCK` |  |
| `226` | `DATA_FORMAT_ASTC_10x5_SFLOAT_BLOCK` |  |
| `227` | `DATA_FORMAT_ASTC_10x6_SFLOAT_BLOCK` |  |
| `228` | `DATA_FORMAT_ASTC_10x8_SFLOAT_BLOCK` |  |
| `229` | `DATA_FORMAT_ASTC_10x10_SFLOAT_BLOCK` |  |
| `230` | `DATA_FORMAT_ASTC_12x10_SFLOAT_BLOCK` |  |
| `231` | `DATA_FORMAT_ASTC_12x12_SFLOAT_BLOCK` |  |
| `232` | `DATA_FORMAT_MAX` |  |

### `BarrierMask`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `BARRIER_MASK_VERTEX` | （位标志） |
| `8` | `BARRIER_MASK_FRAGMENT` | （位标志） |
| `2` | `BARRIER_MASK_COMPUTE` | （位标志） |
| `4` | `BARRIER_MASK_TRANSFER` | （位标志） |
| `9` | `BARRIER_MASK_RASTER` | （位标志） |
| `32767` | `BARRIER_MASK_ALL_BARRIERS` | （位标志） |
| `32768` | `BARRIER_MASK_NO_BARRIER` | （位标志） |

### `TextureType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_TYPE_1D` |  |
| `1` | `TEXTURE_TYPE_2D` |  |
| `2` | `TEXTURE_TYPE_3D` |  |
| `3` | `TEXTURE_TYPE_CUBE` |  |
| `4` | `TEXTURE_TYPE_1D_ARRAY` |  |
| `5` | `TEXTURE_TYPE_2D_ARRAY` |  |
| `6` | `TEXTURE_TYPE_CUBE_ARRAY` |  |
| `7` | `TEXTURE_TYPE_MAX` |  |

### `TextureSamples`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_SAMPLES_1` |  |
| `1` | `TEXTURE_SAMPLES_2` |  |
| `2` | `TEXTURE_SAMPLES_4` |  |
| `3` | `TEXTURE_SAMPLES_8` |  |
| `4` | `TEXTURE_SAMPLES_16` |  |
| `5` | `TEXTURE_SAMPLES_32` |  |
| `6` | `TEXTURE_SAMPLES_64` |  |
| `7` | `TEXTURE_SAMPLES_MAX` |  |

### `TextureUsageBits`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `TEXTURE_USAGE_SAMPLING_BIT` | （位标志） |
| `2` | `TEXTURE_USAGE_COLOR_ATTACHMENT_BIT` | （位标志） |
| `4` | `TEXTURE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT` | （位标志） |
| `4096` | `TEXTURE_USAGE_DEPTH_RESOLVE_ATTACHMENT_BIT` | （位标志） |
| `8` | `TEXTURE_USAGE_STORAGE_BIT` | （位标志） |
| `16` | `TEXTURE_USAGE_STORAGE_ATOMIC_BIT` | （位标志） |
| `32` | `TEXTURE_USAGE_CPU_READ_BIT` | （位标志） |
| `64` | `TEXTURE_USAGE_CAN_UPDATE_BIT` | （位标志） |
| `128` | `TEXTURE_USAGE_CAN_COPY_FROM_BIT` | （位标志） |
| `256` | `TEXTURE_USAGE_CAN_COPY_TO_BIT` | （位标志） |
| `512` | `TEXTURE_USAGE_INPUT_ATTACHMENT_BIT` | （位标志） |

### `TextureSwizzle`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_SWIZZLE_IDENTITY` |  |
| `1` | `TEXTURE_SWIZZLE_ZERO` |  |
| `2` | `TEXTURE_SWIZZLE_ONE` |  |
| `3` | `TEXTURE_SWIZZLE_R` |  |
| `4` | `TEXTURE_SWIZZLE_G` |  |
| `5` | `TEXTURE_SWIZZLE_B` |  |
| `6` | `TEXTURE_SWIZZLE_A` |  |
| `7` | `TEXTURE_SWIZZLE_MAX` |  |

### `TextureSliceType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `TEXTURE_SLICE_2D` |  |
| `1` | `TEXTURE_SLICE_CUBEMAP` |  |
| `2` | `TEXTURE_SLICE_3D` |  |

### `SamplerFilter`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SAMPLER_FILTER_NEAREST` |  |
| `1` | `SAMPLER_FILTER_LINEAR` |  |

### `SamplerRepeatMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SAMPLER_REPEAT_MODE_REPEAT` |  |
| `1` | `SAMPLER_REPEAT_MODE_MIRRORED_REPEAT` |  |
| `2` | `SAMPLER_REPEAT_MODE_CLAMP_TO_EDGE` |  |
| `3` | `SAMPLER_REPEAT_MODE_CLAMP_TO_BORDER` |  |
| `4` | `SAMPLER_REPEAT_MODE_MIRROR_CLAMP_TO_EDGE` |  |
| `5` | `SAMPLER_REPEAT_MODE_MAX` |  |

### `SamplerBorderColor`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SAMPLER_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK` |  |
| `1` | `SAMPLER_BORDER_COLOR_INT_TRANSPARENT_BLACK` |  |
| `2` | `SAMPLER_BORDER_COLOR_FLOAT_OPAQUE_BLACK` |  |
| `3` | `SAMPLER_BORDER_COLOR_INT_OPAQUE_BLACK` |  |
| `4` | `SAMPLER_BORDER_COLOR_FLOAT_OPAQUE_WHITE` |  |
| `5` | `SAMPLER_BORDER_COLOR_INT_OPAQUE_WHITE` |  |
| `6` | `SAMPLER_BORDER_COLOR_MAX` |  |

### `VertexFrequency`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `VERTEX_FREQUENCY_VERTEX` |  |
| `1` | `VERTEX_FREQUENCY_INSTANCE` |  |

### `IndexBufferFormat`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INDEX_BUFFER_FORMAT_UINT16` |  |
| `1` | `INDEX_BUFFER_FORMAT_UINT32` |  |

### `StorageBufferUsage`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `STORAGE_BUFFER_USAGE_DISPATCH_INDIRECT` | （位标志） |

### `BufferCreationBits`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `BUFFER_CREATION_DEVICE_ADDRESS_BIT` | （位标志） |
| `2` | `BUFFER_CREATION_AS_STORAGE_BIT` | （位标志） |
| `8` | `BUFFER_CREATION_ACCELERATION_STRUCTURE_BUILD_INPUT_READ_ONLY_BIT` | （位标志） |

### `AccelerationStructureFlagBits`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT` | （位标志） |
| `2` | `ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT` | （位标志） |
| `4` | `ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT` | （位标志） |
| `8` | `ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT` | （位标志） |
| `16` | `ACCELERATION_STRUCTURE_LOW_MEMORY_BIT` | （位标志） |

### `AccelerationStructureGeometryFlagBits`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ACCELERATION_STRUCTURE_GEOMETRY_OPAQUE_BIT` | （位标志） |
| `2` | `ACCELERATION_STRUCTURE_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT` | （位标志） |

### `AccelerationStructureInstanceFlagBits`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `ACCELERATION_STRUCTURE_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT` | （位标志） |
| `2` | `ACCELERATION_STRUCTURE_INSTANCE_TRIANGLE_FLIP_FACING_BIT` | （位标志） |
| `4` | `ACCELERATION_STRUCTURE_INSTANCE_FORCE_OPAQUE_BIT` | （位标志） |
| `8` | `ACCELERATION_STRUCTURE_INSTANCE_FORCE_NO_OPAQUE_BIT` | （位标志） |

### `UniformType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `UNIFORM_TYPE_SAMPLER` |  |
| `1` | `UNIFORM_TYPE_SAMPLER_WITH_TEXTURE` |  |
| `2` | `UNIFORM_TYPE_TEXTURE` |  |
| `3` | `UNIFORM_TYPE_IMAGE` |  |
| `4` | `UNIFORM_TYPE_TEXTURE_BUFFER` |  |
| `5` | `UNIFORM_TYPE_SAMPLER_WITH_TEXTURE_BUFFER` |  |
| `6` | `UNIFORM_TYPE_IMAGE_BUFFER` |  |
| `7` | `UNIFORM_TYPE_UNIFORM_BUFFER` |  |
| `8` | `UNIFORM_TYPE_STORAGE_BUFFER` |  |
| `9` | `UNIFORM_TYPE_INPUT_ATTACHMENT` |  |
| `10` | `UNIFORM_TYPE_UNIFORM_BUFFER_DYNAMIC` |  |
| `11` | `UNIFORM_TYPE_STORAGE_BUFFER_DYNAMIC` |  |
| `12` | `UNIFORM_TYPE_ACCELERATION_STRUCTURE` |  |
| `13` | `UNIFORM_TYPE_MAX` |  |

### `RenderPrimitive`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `RENDER_PRIMITIVE_POINTS` |  |
| `1` | `RENDER_PRIMITIVE_LINES` |  |
| `2` | `RENDER_PRIMITIVE_LINES_WITH_ADJACENCY` |  |
| `3` | `RENDER_PRIMITIVE_LINESTRIPS` |  |
| `4` | `RENDER_PRIMITIVE_LINESTRIPS_WITH_ADJACENCY` |  |
| `5` | `RENDER_PRIMITIVE_TRIANGLES` |  |
| `6` | `RENDER_PRIMITIVE_TRIANGLES_WITH_ADJACENCY` |  |
| `7` | `RENDER_PRIMITIVE_TRIANGLE_STRIPS` |  |
| `8` | `RENDER_PRIMITIVE_TRIANGLE_STRIPS_WITH_AJACENCY` |  |
| `9` | `RENDER_PRIMITIVE_TRIANGLE_STRIPS_WITH_RESTART_INDEX` |  |
| `10` | `RENDER_PRIMITIVE_TESSELATION_PATCH` |  |
| `11` | `RENDER_PRIMITIVE_MAX` |  |

### `PolygonCullMode`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `POLYGON_CULL_DISABLED` |  |
| `1` | `POLYGON_CULL_FRONT` |  |
| `2` | `POLYGON_CULL_BACK` |  |

### `PolygonFrontFace`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `POLYGON_FRONT_FACE_CLOCKWISE` |  |
| `1` | `POLYGON_FRONT_FACE_COUNTER_CLOCKWISE` |  |

### `StencilOperation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `STENCIL_OP_KEEP` |  |
| `1` | `STENCIL_OP_ZERO` |  |
| `2` | `STENCIL_OP_REPLACE` |  |
| `3` | `STENCIL_OP_INCREMENT_AND_CLAMP` |  |
| `4` | `STENCIL_OP_DECREMENT_AND_CLAMP` |  |
| `5` | `STENCIL_OP_INVERT` |  |
| `6` | `STENCIL_OP_INCREMENT_AND_WRAP` |  |
| `7` | `STENCIL_OP_DECREMENT_AND_WRAP` |  |
| `8` | `STENCIL_OP_MAX` |  |

### `CompareOperator`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `COMPARE_OP_NEVER` |  |
| `1` | `COMPARE_OP_LESS` |  |
| `2` | `COMPARE_OP_EQUAL` |  |
| `3` | `COMPARE_OP_LESS_OR_EQUAL` |  |
| `4` | `COMPARE_OP_GREATER` |  |
| `5` | `COMPARE_OP_NOT_EQUAL` |  |
| `6` | `COMPARE_OP_GREATER_OR_EQUAL` |  |
| `7` | `COMPARE_OP_ALWAYS` |  |
| `8` | `COMPARE_OP_MAX` |  |

### `LogicOperation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LOGIC_OP_CLEAR` |  |
| `1` | `LOGIC_OP_AND` |  |
| `2` | `LOGIC_OP_AND_REVERSE` |  |
| `3` | `LOGIC_OP_COPY` |  |
| `4` | `LOGIC_OP_AND_INVERTED` |  |
| `5` | `LOGIC_OP_NO_OP` |  |
| `6` | `LOGIC_OP_XOR` |  |
| `7` | `LOGIC_OP_OR` |  |
| `8` | `LOGIC_OP_NOR` |  |
| `9` | `LOGIC_OP_EQUIVALENT` |  |
| `10` | `LOGIC_OP_INVERT` |  |
| `11` | `LOGIC_OP_OR_REVERSE` |  |
| `12` | `LOGIC_OP_COPY_INVERTED` |  |
| `13` | `LOGIC_OP_OR_INVERTED` |  |
| `14` | `LOGIC_OP_NAND` |  |
| `15` | `LOGIC_OP_SET` |  |
| `16` | `LOGIC_OP_MAX` |  |

### `BlendFactor`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_FACTOR_ZERO` |  |
| `1` | `BLEND_FACTOR_ONE` |  |
| `2` | `BLEND_FACTOR_SRC_COLOR` |  |
| `3` | `BLEND_FACTOR_ONE_MINUS_SRC_COLOR` |  |
| `4` | `BLEND_FACTOR_DST_COLOR` |  |
| `5` | `BLEND_FACTOR_ONE_MINUS_DST_COLOR` |  |
| `6` | `BLEND_FACTOR_SRC_ALPHA` |  |
| `7` | `BLEND_FACTOR_ONE_MINUS_SRC_ALPHA` |  |
| `8` | `BLEND_FACTOR_DST_ALPHA` |  |
| `9` | `BLEND_FACTOR_ONE_MINUS_DST_ALPHA` |  |
| `10` | `BLEND_FACTOR_CONSTANT_COLOR` |  |
| `11` | `BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR` |  |
| `12` | `BLEND_FACTOR_CONSTANT_ALPHA` |  |
| `13` | `BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA` |  |
| `14` | `BLEND_FACTOR_SRC_ALPHA_SATURATE` |  |
| `15` | `BLEND_FACTOR_SRC1_COLOR` |  |
| `16` | `BLEND_FACTOR_ONE_MINUS_SRC1_COLOR` |  |
| `17` | `BLEND_FACTOR_SRC1_ALPHA` |  |
| `18` | `BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA` |  |
| `19` | `BLEND_FACTOR_MAX` |  |

### `BlendOperation`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `BLEND_OP_ADD` |  |
| `1` | `BLEND_OP_SUBTRACT` |  |
| `2` | `BLEND_OP_REVERSE_SUBTRACT` |  |
| `3` | `BLEND_OP_MINIMUM` |  |
| `4` | `BLEND_OP_MAXIMUM` |  |
| `5` | `BLEND_OP_MAX` |  |

### `PipelineDynamicStateFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `1` | `DYNAMIC_STATE_LINE_WIDTH` | （位标志） |
| `2` | `DYNAMIC_STATE_DEPTH_BIAS` | （位标志） |
| `4` | `DYNAMIC_STATE_BLEND_CONSTANTS` | （位标志） |
| `8` | `DYNAMIC_STATE_DEPTH_BOUNDS` | （位标志） |
| `16` | `DYNAMIC_STATE_STENCIL_COMPARE_MASK` | （位标志） |
| `32` | `DYNAMIC_STATE_STENCIL_WRITE_MASK` | （位标志） |
| `64` | `DYNAMIC_STATE_STENCIL_REFERENCE` | （位标志） |

### `InitialAction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `INITIAL_ACTION_LOAD` |  |
| `1` | `INITIAL_ACTION_CLEAR` |  |
| `2` | `INITIAL_ACTION_DISCARD` |  |
| `3` | `INITIAL_ACTION_MAX` |  |
| `1` | `INITIAL_ACTION_CLEAR_REGION` |  |
| `1` | `INITIAL_ACTION_CLEAR_REGION_CONTINUE` |  |
| `0` | `INITIAL_ACTION_KEEP` |  |
| `2` | `INITIAL_ACTION_DROP` |  |
| `0` | `INITIAL_ACTION_CONTINUE` |  |

### `FinalAction`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FINAL_ACTION_STORE` |  |
| `1` | `FINAL_ACTION_DISCARD` |  |
| `2` | `FINAL_ACTION_MAX` |  |
| `0` | `FINAL_ACTION_READ` |  |
| `0` | `FINAL_ACTION_CONTINUE` |  |

### `ShaderStage`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADER_STAGE_VERTEX` |  |
| `1` | `SHADER_STAGE_FRAGMENT` |  |
| `2` | `SHADER_STAGE_TESSELATION_CONTROL` |  |
| `3` | `SHADER_STAGE_TESSELATION_EVALUATION` |  |
| `4` | `SHADER_STAGE_COMPUTE` |  |
| `5` | `SHADER_STAGE_RAYGEN` |  |
| `6` | `SHADER_STAGE_ANY_HIT` |  |
| `7` | `SHADER_STAGE_CLOSEST_HIT` |  |
| `8` | `SHADER_STAGE_MISS` |  |
| `9` | `SHADER_STAGE_INTERSECTION` |  |
| `10` | `SHADER_STAGE_MAX` |  |
| `1` | `SHADER_STAGE_VERTEX_BIT` |  |
| `2` | `SHADER_STAGE_FRAGMENT_BIT` |  |
| `4` | `SHADER_STAGE_TESSELATION_CONTROL_BIT` |  |
| `8` | `SHADER_STAGE_TESSELATION_EVALUATION_BIT` |  |
| `16` | `SHADER_STAGE_COMPUTE_BIT` |  |
| `32` | `SHADER_STAGE_RAYGEN_BIT` |  |
| `64` | `SHADER_STAGE_ANY_HIT_BIT` |  |
| `128` | `SHADER_STAGE_CLOSEST_HIT_BIT` |  |
| `256` | `SHADER_STAGE_MISS_BIT` |  |
| `512` | `SHADER_STAGE_INTERSECTION_BIT` |  |

### `ShaderLanguage`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `SHADER_LANGUAGE_GLSL` |  |
| `1` | `SHADER_LANGUAGE_HLSL` |  |

### `PipelineSpecializationConstantType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `PIPELINE_SPECIALIZATION_CONSTANT_TYPE_BOOL` |  |
| `1` | `PIPELINE_SPECIALIZATION_CONSTANT_TYPE_INT` |  |
| `2` | `PIPELINE_SPECIALIZATION_CONSTANT_TYPE_FLOAT` |  |

### `Features`

| 值 | 名称 | 说明 |
|---|---|---|
| `3` | `SUPPORTS_METALFX_SPATIAL` |  |
| `4` | `SUPPORTS_METALFX_TEMPORAL` |  |
| `6` | `SUPPORTS_BUFFER_DEVICE_ADDRESS` |  |
| `7` | `SUPPORTS_IMAGE_ATOMIC_32_BIT` |  |
| `11` | `SUPPORTS_RAY_QUERY` |  |
| `12` | `SUPPORTS_RAYTRACING_PIPELINE` |  |
| `13` | `SUPPORTS_HDR_OUTPUT` |  |

### `Limit`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `LIMIT_MAX_BOUND_UNIFORM_SETS` |  |
| `1` | `LIMIT_MAX_FRAMEBUFFER_COLOR_ATTACHMENTS` |  |
| `2` | `LIMIT_MAX_TEXTURES_PER_UNIFORM_SET` |  |
| `3` | `LIMIT_MAX_SAMPLERS_PER_UNIFORM_SET` |  |
| `4` | `LIMIT_MAX_STORAGE_BUFFERS_PER_UNIFORM_SET` |  |
| `5` | `LIMIT_MAX_STORAGE_IMAGES_PER_UNIFORM_SET` |  |
| `6` | `LIMIT_MAX_UNIFORM_BUFFERS_PER_UNIFORM_SET` |  |
| `7` | `LIMIT_MAX_DRAW_INDEXED_INDEX` |  |
| `8` | `LIMIT_MAX_FRAMEBUFFER_HEIGHT` |  |
| `9` | `LIMIT_MAX_FRAMEBUFFER_WIDTH` |  |
| `10` | `LIMIT_MAX_TEXTURE_ARRAY_LAYERS` |  |
| `11` | `LIMIT_MAX_TEXTURE_SIZE_1D` |  |
| `12` | `LIMIT_MAX_TEXTURE_SIZE_2D` |  |
| `13` | `LIMIT_MAX_TEXTURE_SIZE_3D` |  |
| `14` | `LIMIT_MAX_TEXTURE_SIZE_CUBE` |  |
| `15` | `LIMIT_MAX_TEXTURES_PER_SHADER_STAGE` |  |
| `16` | `LIMIT_MAX_SAMPLERS_PER_SHADER_STAGE` |  |
| `17` | `LIMIT_MAX_STORAGE_BUFFERS_PER_SHADER_STAGE` |  |
| `18` | `LIMIT_MAX_STORAGE_IMAGES_PER_SHADER_STAGE` |  |
| `19` | `LIMIT_MAX_UNIFORM_BUFFERS_PER_SHADER_STAGE` |  |
| `20` | `LIMIT_MAX_PUSH_CONSTANT_SIZE` |  |
| `21` | `LIMIT_MAX_UNIFORM_BUFFER_SIZE` |  |
| `22` | `LIMIT_MAX_VERTEX_INPUT_ATTRIBUTE_OFFSET` |  |
| `23` | `LIMIT_MAX_VERTEX_INPUT_ATTRIBUTES` |  |
| `24` | `LIMIT_MAX_VERTEX_INPUT_BINDINGS` |  |
| `25` | `LIMIT_MAX_VERTEX_INPUT_BINDING_STRIDE` |  |
| `26` | `LIMIT_MIN_UNIFORM_BUFFER_OFFSET_ALIGNMENT` |  |
| `27` | `LIMIT_MAX_COMPUTE_SHARED_MEMORY_SIZE` |  |
| `28` | `LIMIT_MAX_COMPUTE_WORKGROUP_COUNT_X` |  |
| `29` | `LIMIT_MAX_COMPUTE_WORKGROUP_COUNT_Y` |  |
| `30` | `LIMIT_MAX_COMPUTE_WORKGROUP_COUNT_Z` |  |
| `31` | `LIMIT_MAX_COMPUTE_WORKGROUP_INVOCATIONS` |  |
| `32` | `LIMIT_MAX_COMPUTE_WORKGROUP_SIZE_X` |  |
| `33` | `LIMIT_MAX_COMPUTE_WORKGROUP_SIZE_Y` |  |
| `34` | `LIMIT_MAX_COMPUTE_WORKGROUP_SIZE_Z` |  |
| `35` | `LIMIT_MAX_VIEWPORT_DIMENSIONS_X` |  |
| `36` | `LIMIT_MAX_VIEWPORT_DIMENSIONS_Y` |  |
| `46` | `LIMIT_METALFX_TEMPORAL_SCALER_MIN_SCALE` |  |
| `47` | `LIMIT_METALFX_TEMPORAL_SCALER_MAX_SCALE` |  |

### `MemoryType`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `MEMORY_TEXTURES` |  |
| `1` | `MEMORY_BUFFERS` |  |
| `2` | `MEMORY_TOTAL` |  |

### `BreadcrumbMarker`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `NONE` |  |
| `65536` | `REFLECTION_PROBES` |  |
| `131072` | `SKY_PASS` |  |
| `196608` | `LIGHTMAPPER_PASS` |  |
| `262144` | `SHADOW_PASS_DIRECTIONAL` |  |
| `327680` | `SHADOW_PASS_CUBE` |  |
| `393216` | `OPAQUE_PASS` |  |
| `458752` | `ALPHA_PASS` |  |
| `524288` | `TRANSPARENT_PASS` |  |
| `589824` | `POST_PROCESSING_PASS` |  |
| `655360` | `BLIT_PASS` |  |
| `720896` | `UI_PASS` |  |
| `786432` | `DEBUG_PASS` |  |

### `DrawFlags`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `DRAW_DEFAULT_ALL` | （位标志） |
| `1` | `DRAW_CLEAR_COLOR_0` | （位标志） |
| `2` | `DRAW_CLEAR_COLOR_1` | （位标志） |
| `4` | `DRAW_CLEAR_COLOR_2` | （位标志） |
| `8` | `DRAW_CLEAR_COLOR_3` | （位标志） |
| `16` | `DRAW_CLEAR_COLOR_4` | （位标志） |
| `32` | `DRAW_CLEAR_COLOR_5` | （位标志） |
| `64` | `DRAW_CLEAR_COLOR_6` | （位标志） |
| `128` | `DRAW_CLEAR_COLOR_7` | （位标志） |
| `255` | `DRAW_CLEAR_COLOR_MASK` | （位标志） |
| `255` | `DRAW_CLEAR_COLOR_ALL` | （位标志） |
| `256` | `DRAW_IGNORE_COLOR_0` | （位标志） |
| `512` | `DRAW_IGNORE_COLOR_1` | （位标志） |
| `1024` | `DRAW_IGNORE_COLOR_2` | （位标志） |
| `2048` | `DRAW_IGNORE_COLOR_3` | （位标志） |
| `4096` | `DRAW_IGNORE_COLOR_4` | （位标志） |
| `8192` | `DRAW_IGNORE_COLOR_5` | （位标志） |
| `16384` | `DRAW_IGNORE_COLOR_6` | （位标志） |
| `32768` | `DRAW_IGNORE_COLOR_7` | （位标志） |
| `65280` | `DRAW_IGNORE_COLOR_MASK` | （位标志） |
| `65280` | `DRAW_IGNORE_COLOR_ALL` | （位标志） |
| `65536` | `DRAW_CLEAR_DEPTH` | （位标志） |
| `131072` | `DRAW_IGNORE_DEPTH` | （位标志） |
| `262144` | `DRAW_CLEAR_STENCIL` | （位标志） |
| `524288` | `DRAW_IGNORE_STENCIL` | （位标志） |
| `327935` | `DRAW_CLEAR_ALL` | （位标志） |
| `720640` | `DRAW_IGNORE_ALL` | （位标志） |

## 常量

- **`INVALID_ID`** = `-1`
- **`INVALID_FORMAT_ID`** = `-1`
## 教程链接

- [Using compute shaders](None)

