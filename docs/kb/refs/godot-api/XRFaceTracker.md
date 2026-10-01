# XRFaceTracker

> **Godot 4.7.1** · tag `4.7.1-stable` · commit `a13da4fe`
> 继承链：`XRFaceTracker` → `XRTracker` → `RefCounted` → `Object`
> 附加属性：api_type=core · experimental=
> 自动生成，勿手改。文件：`refs/godot-api/XRFaceTracker.md`

**摘要**：A tracked face.

## 描述

An instance of this object represents a tracked face and its corresponding blend shapes. The blend shapes come from the Unified Expressions (https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/unified-blendshapes) standard, and contain extended details and visuals for each blend shape. Additionally the Tracking Standard Comparison (https://docs.vrcft.io/docs/tutorial-avatars/tutorial-avatars-extras/compatibility/overview) page documents the relationship between Unified Expressions and other standards.
		As face trackers are turned on they are registered with the `XRServer`.

## 属性

- **`blend_shapes`** `PackedFloat32Array` = `PackedFloat32Array()`
  - 其它属性：getter=get_blend_shapes · setter=set_blend_shapes
- **`type`** `int` = `64` · 枚举 `XRServer.TrackerType`
  - 其它属性：getter=get_tracker_type · overrides=XRTracker · setter=set_tracker_type

## 方法

### `get_blend_shape(blend_shape: int) -> float`
- 限定：qualifiers=const

Returns the requested face blend shape weight.

### `set_blend_shape(blend_shape: int, weight: float) -> void`

Sets a face blend shape weight.

## 枚举

### `BlendShapeEntry`

| 值 | 名称 | 说明 |
|---|---|---|
| `0` | `FT_EYE_LOOK_OUT_RIGHT` |  |
| `1` | `FT_EYE_LOOK_IN_RIGHT` |  |
| `2` | `FT_EYE_LOOK_UP_RIGHT` |  |
| `3` | `FT_EYE_LOOK_DOWN_RIGHT` |  |
| `4` | `FT_EYE_LOOK_OUT_LEFT` |  |
| `5` | `FT_EYE_LOOK_IN_LEFT` |  |
| `6` | `FT_EYE_LOOK_UP_LEFT` |  |
| `7` | `FT_EYE_LOOK_DOWN_LEFT` |  |
| `8` | `FT_EYE_CLOSED_RIGHT` |  |
| `9` | `FT_EYE_CLOSED_LEFT` |  |
| `10` | `FT_EYE_SQUINT_RIGHT` |  |
| `11` | `FT_EYE_SQUINT_LEFT` |  |
| `12` | `FT_EYE_WIDE_RIGHT` |  |
| `13` | `FT_EYE_WIDE_LEFT` |  |
| `14` | `FT_EYE_DILATION_RIGHT` |  |
| `15` | `FT_EYE_DILATION_LEFT` |  |
| `16` | `FT_EYE_CONSTRICT_RIGHT` |  |
| `17` | `FT_EYE_CONSTRICT_LEFT` |  |
| `18` | `FT_BROW_PINCH_RIGHT` |  |
| `19` | `FT_BROW_PINCH_LEFT` |  |
| `20` | `FT_BROW_LOWERER_RIGHT` |  |
| `21` | `FT_BROW_LOWERER_LEFT` |  |
| `22` | `FT_BROW_INNER_UP_RIGHT` |  |
| `23` | `FT_BROW_INNER_UP_LEFT` |  |
| `24` | `FT_BROW_OUTER_UP_RIGHT` |  |
| `25` | `FT_BROW_OUTER_UP_LEFT` |  |
| `26` | `FT_NOSE_SNEER_RIGHT` |  |
| `27` | `FT_NOSE_SNEER_LEFT` |  |
| `28` | `FT_NASAL_DILATION_RIGHT` |  |
| `29` | `FT_NASAL_DILATION_LEFT` |  |
| `30` | `FT_NASAL_CONSTRICT_RIGHT` |  |
| `31` | `FT_NASAL_CONSTRICT_LEFT` |  |
| `32` | `FT_CHEEK_SQUINT_RIGHT` |  |
| `33` | `FT_CHEEK_SQUINT_LEFT` |  |
| `34` | `FT_CHEEK_PUFF_RIGHT` |  |
| `35` | `FT_CHEEK_PUFF_LEFT` |  |
| `36` | `FT_CHEEK_SUCK_RIGHT` |  |
| `37` | `FT_CHEEK_SUCK_LEFT` |  |
| `38` | `FT_JAW_OPEN` |  |
| `39` | `FT_MOUTH_CLOSED` |  |
| `40` | `FT_JAW_RIGHT` |  |
| `41` | `FT_JAW_LEFT` |  |
| `42` | `FT_JAW_FORWARD` |  |
| `43` | `FT_JAW_BACKWARD` |  |
| `44` | `FT_JAW_CLENCH` |  |
| `45` | `FT_JAW_MANDIBLE_RAISE` |  |
| `46` | `FT_LIP_SUCK_UPPER_RIGHT` |  |
| `47` | `FT_LIP_SUCK_UPPER_LEFT` |  |
| `48` | `FT_LIP_SUCK_LOWER_RIGHT` |  |
| `49` | `FT_LIP_SUCK_LOWER_LEFT` |  |
| `50` | `FT_LIP_SUCK_CORNER_RIGHT` |  |
| `51` | `FT_LIP_SUCK_CORNER_LEFT` |  |
| `52` | `FT_LIP_FUNNEL_UPPER_RIGHT` |  |
| `53` | `FT_LIP_FUNNEL_UPPER_LEFT` |  |
| `54` | `FT_LIP_FUNNEL_LOWER_RIGHT` |  |
| `55` | `FT_LIP_FUNNEL_LOWER_LEFT` |  |
| `56` | `FT_LIP_PUCKER_UPPER_RIGHT` |  |
| `57` | `FT_LIP_PUCKER_UPPER_LEFT` |  |
| `58` | `FT_LIP_PUCKER_LOWER_RIGHT` |  |
| `59` | `FT_LIP_PUCKER_LOWER_LEFT` |  |
| `60` | `FT_MOUTH_UPPER_UP_RIGHT` |  |
| `61` | `FT_MOUTH_UPPER_UP_LEFT` |  |
| `62` | `FT_MOUTH_LOWER_DOWN_RIGHT` |  |
| `63` | `FT_MOUTH_LOWER_DOWN_LEFT` |  |
| `64` | `FT_MOUTH_UPPER_DEEPEN_RIGHT` |  |
| `65` | `FT_MOUTH_UPPER_DEEPEN_LEFT` |  |
| `66` | `FT_MOUTH_UPPER_RIGHT` |  |
| `67` | `FT_MOUTH_UPPER_LEFT` |  |
| `68` | `FT_MOUTH_LOWER_RIGHT` |  |
| `69` | `FT_MOUTH_LOWER_LEFT` |  |
| `70` | `FT_MOUTH_CORNER_PULL_RIGHT` |  |
| `71` | `FT_MOUTH_CORNER_PULL_LEFT` |  |
| `72` | `FT_MOUTH_CORNER_SLANT_RIGHT` |  |
| `73` | `FT_MOUTH_CORNER_SLANT_LEFT` |  |
| `74` | `FT_MOUTH_FROWN_RIGHT` |  |
| `75` | `FT_MOUTH_FROWN_LEFT` |  |
| `76` | `FT_MOUTH_STRETCH_RIGHT` |  |
| `77` | `FT_MOUTH_STRETCH_LEFT` |  |
| `78` | `FT_MOUTH_DIMPLE_RIGHT` |  |
| `79` | `FT_MOUTH_DIMPLE_LEFT` |  |
| `80` | `FT_MOUTH_RAISER_UPPER` |  |
| `81` | `FT_MOUTH_RAISER_LOWER` |  |
| `82` | `FT_MOUTH_PRESS_RIGHT` |  |
| `83` | `FT_MOUTH_PRESS_LEFT` |  |
| `84` | `FT_MOUTH_TIGHTENER_RIGHT` |  |
| `85` | `FT_MOUTH_TIGHTENER_LEFT` |  |
| `86` | `FT_TONGUE_OUT` |  |
| `87` | `FT_TONGUE_UP` |  |
| `88` | `FT_TONGUE_DOWN` |  |
| `89` | `FT_TONGUE_RIGHT` |  |
| `90` | `FT_TONGUE_LEFT` |  |
| `91` | `FT_TONGUE_ROLL` |  |
| `92` | `FT_TONGUE_BLEND_DOWN` |  |
| `93` | `FT_TONGUE_CURL_UP` |  |
| `94` | `FT_TONGUE_SQUISH` |  |
| `95` | `FT_TONGUE_FLAT` |  |
| `96` | `FT_TONGUE_TWIST_RIGHT` |  |
| `97` | `FT_TONGUE_TWIST_LEFT` |  |
| `98` | `FT_SOFT_PALATE_CLOSE` |  |
| `99` | `FT_THROAT_SWALLOW` |  |
| `100` | `FT_NECK_FLEX_RIGHT` |  |
| `101` | `FT_NECK_FLEX_LEFT` |  |
| `102` | `FT_EYE_CLOSED` |  |
| `103` | `FT_EYE_WIDE` |  |
| `104` | `FT_EYE_SQUINT` |  |
| `105` | `FT_EYE_DILATION` |  |
| `106` | `FT_EYE_CONSTRICT` |  |
| `107` | `FT_BROW_DOWN_RIGHT` |  |
| `108` | `FT_BROW_DOWN_LEFT` |  |
| `109` | `FT_BROW_DOWN` |  |
| `110` | `FT_BROW_UP_RIGHT` |  |
| `111` | `FT_BROW_UP_LEFT` |  |
| `112` | `FT_BROW_UP` |  |
| `113` | `FT_NOSE_SNEER` |  |
| `114` | `FT_NASAL_DILATION` |  |
| `115` | `FT_NASAL_CONSTRICT` |  |
| `116` | `FT_CHEEK_PUFF` |  |
| `117` | `FT_CHEEK_SUCK` |  |
| `118` | `FT_CHEEK_SQUINT` |  |
| `119` | `FT_LIP_SUCK_UPPER` |  |
| `120` | `FT_LIP_SUCK_LOWER` |  |
| `121` | `FT_LIP_SUCK` |  |
| `122` | `FT_LIP_FUNNEL_UPPER` |  |
| `123` | `FT_LIP_FUNNEL_LOWER` |  |
| `124` | `FT_LIP_FUNNEL` |  |
| `125` | `FT_LIP_PUCKER_UPPER` |  |
| `126` | `FT_LIP_PUCKER_LOWER` |  |
| `127` | `FT_LIP_PUCKER` |  |
| `128` | `FT_MOUTH_UPPER_UP` |  |
| `129` | `FT_MOUTH_LOWER_DOWN` |  |
| `130` | `FT_MOUTH_OPEN` |  |
| `131` | `FT_MOUTH_RIGHT` |  |
| `132` | `FT_MOUTH_LEFT` |  |
| `133` | `FT_MOUTH_SMILE_RIGHT` |  |
| `134` | `FT_MOUTH_SMILE_LEFT` |  |
| `135` | `FT_MOUTH_SMILE` |  |
| `136` | `FT_MOUTH_SAD_RIGHT` |  |
| `137` | `FT_MOUTH_SAD_LEFT` |  |
| `138` | `FT_MOUTH_SAD` |  |
| `139` | `FT_MOUTH_STRETCH` |  |
| `140` | `FT_MOUTH_DIMPLE` |  |
| `141` | `FT_MOUTH_TIGHTENER` |  |
| `142` | `FT_MOUTH_PRESS` |  |
| `143` | `FT_MAX` |  |

## 教程链接

- [XR documentation index](None)

