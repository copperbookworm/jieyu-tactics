# OpenXRSpatialCapabilityConfigurationBaseHeader

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialCapabilityConfigurationBaseHeader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialCapabilityConfigurationBaseHeader.md`

**摘要**：Wrapper base class for OpenXR Spatial Capability Configuration headers.

## 描述

Wrapper base class for OpenXR Spatial Capability Configuration headers. This class needs to be implemented for each capability configuration structure usable within OpenXR's spatial entities system.

## 方法

### `_get_configuration() -> int`
- 限定：qualifiers=virtual

Return a pointer (encoded as an `int64_t`) to a struct holding the spatial capability configuration data. The memory for this struct should remain accessible as long as this object remains instantiated.

### `_has_valid_configuration() -> bool`
- 限定：qualifiers=virtual const

Return `true` if this object contains a valid configuration that can be retrieved when calling `_get_configuration`.

### `get_configuration() -> int`

Gets a pointer to the `XrSpatialCapabilityConfigurationBaseHeaderEXT` struct.
				**Note:** This method is intended to be used from GDExtensions.

### `has_valid_configuration() -> bool`
- 限定：qualifiers=const

Returns `true` if this object contains a valid configuration that can be used when calling `OpenXRSpatialEntityExtension.create_spatial_context`.

