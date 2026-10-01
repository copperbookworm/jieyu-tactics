# OpenXRSpatialCapabilityConfigurationMicroQrCode

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`OpenXRSpatialCapabilityConfigurationMicroQrCode` → `OpenXRSpatialCapabilityConfigurationBaseHeader` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/OpenXRSpatialCapabilityConfigurationMicroQrCode.md`

**摘要**：Configuration header for QR code markers.

## 描述

Configuration header for QR code markers. Pass this to `OpenXRSpatialEntityExtension.create_spatial_context` to create a spatial context that can detect QR code markers.

## 方法

### `get_enabled_components() -> PackedInt64Array`
- 限定：qualifiers=const

Returns the components enabled by this configuration.
				**Note:** Only valid after this configuration was used to create a spatial context.

