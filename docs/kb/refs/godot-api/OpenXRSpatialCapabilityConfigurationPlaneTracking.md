# OpenXRSpatialCapabilityConfigurationPlaneTracking

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialCapabilityConfigurationPlaneTracking` → `OpenXRSpatialCapabilityConfigurationBaseHeader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialCapabilityConfigurationPlaneTracking.md`

**摘要**：Configuration header for plane tracking.

## 描述

Configuration header for plane tracking. Pass this to `OpenXRSpatialEntityExtension.create_spatial_context` to create a spatial context with plane tracking capabilities.

## 方法

### `get_enabled_components() -> PackedInt64Array`
- 限定：qualifiers=const

Returns the components enabled by this configuration.
				**Note:** Only valid after this configuration was used to create a spatial context.

### `supports_labels() -> bool`

Returns `true` if we support the plane semantic label component (only valid after the OpenXR session has started). You can query these using the `OpenXRSpatialComponentPlaneSemanticLabelList` data object.

### `supports_mesh_2d() -> bool`

Returns `true` if we support the mesh 2D component (only valid after the OpenXR session has started). You can query these using the `OpenXRSpatialComponentMesh2DList` data object.

### `supports_polygons() -> bool`

Returns `true` if we support the polygon 2D component (only valid after the OpenXR session has started). You can query these using the `OpenXRSpatialComponentPolygon2DList` data object.

