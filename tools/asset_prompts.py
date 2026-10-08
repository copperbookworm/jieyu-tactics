# -*- coding: utf-8 -*-
## 《解域》资产 AI 生成提示词库（2026-10-07 第一〇〇版）
##
## 为什么单独成模块：提示词要跟 art_manifest 的 id 一一对上，且**风格要成套** ——
## 逐条手写会跑偏（同一个兵种三张图三种画风）。这里用「统一风格串 + 各条主体」拼装，
## 保证整套图是同一套视觉。改风格只改下面的 STYLE 常量。

# ── 统一风格（所有图像类共用；改这里＝整套换画风）──────────────────────
STYLE_SPRITE = (
    "clean 2D top-down military game sprite, flat cel shading with a subtle rim light, "
    "muted olive-green and dark slate palette, crisp anti-aliased edges, no outline glow"
)
STYLE_UI = (
    "flat minimal mobile game UI, dark slate base #10141a, thin 1-2px light border #5a6878, "
    "green accent #7bd88f, translucent panels, crisp edges, no text"
)
STYLE_MAP = (
    "seamless tileable texture, even flat lighting with no baked light direction, no text"
)
STYLE_HEIGHTMAP = (
    "no colour, no lighting or shading, no contour lines, no baked shadows, seamless tileable"
)

# 铺满整张图的地图层（不透明、无透明通道）—— 与「限界精灵」的透明背景要求相反
FULLBLEED = {"map_heightmap", "map_tile_terrain", "map_contour"}
STYLE_ICON = (
    "bold readable mobile app icon, large simple silhouette, dark slate background with green accent "
    "#7bd88f, high contrast, centered, no text"
)

NEG_SPRITE = (
    "text, watermark, signature, logo, blurry, low contrast, 3D render, photorealistic, "
    "perspective distortion, isometric, drop shadow, background scenery, jpeg artifacts, extra limbs"
)
NEG_UI = "text, watermark, photo, 3D, gradient banding, busy texture, drop shadow, mockup frame, device bezel"
NEG_FX = "text, watermark, background scenery, hard square edges, jpeg artifacts, banding"
NEG_MAP = "text, watermark, buildings with perspective, 3D, tiling seams, jpeg artifacts"
NEG_AUDIO = "music, melody, reverb, echo, clipping, distortion, background noise, fade in, fade out"

TOOL_SPRITE = "SDXL/Flux + 透明背景（LayerDiffuse）；像素风可用 Aseprite 精修；固定同一 seed 保风格一致"
TOOL_UI = "SDXL/Flux 出底图；纯色块类建议直接用矢量工具画（更准且能做 9-slice）"
TOOL_MAP = "SDXL 平铺纹理需开 tiling；**高度图请用 World Machine / Gaea 生成，AI 图不可直接当高度图**"
TOOL_SFX = "ElevenLabs SFX / Stable Audio Open / AudioGen；导出 22.05kHz 单声道 WAV（与工程采样率一致）"
TOOL_BGM = "Suno / Udio（务必确认商用授权）；导出 44.1kHz 立体声 OGG，循环点切干净"

SUBJECT = {
    # 角色
    "char_rifleman_base": "a rifleman soldier carrying an assault rifle",
    "char_autorifleman_base": "an automatic rifleman carrying a light machine gun with a drum magazine",
    "char_medic_base": "a combat medic with a medical backpack and a red-cross armband",
    "char_sniper_base": "a sniper carrying a long bolt-action sniper rifle with a large scope",
    "char_marksman_base": "a designated marksman carrying a scoped semi-automatic rifle",
    "char_mg_base": "a machine gunner carrying a general-purpose machine gun on a bipod",
    "char_grenadier_base": "a grenadier with an under-barrel grenade launcher on the rifle",
    "char_at_light_base": "a light anti-tank soldier carrying a disposable rocket launcher tube",
    "char_at_heavy_base": "a heavy anti-tank operator carrying a large reusable missile launcher",
    "char_scout_base": "a scout with a compact carbine and light reconnaissance gear",
    "char_squadleader_base": "a squad leader with a carbine, radio headset and binoculars",
    "char_engineer_base": "a combat engineer with a demolition satchel and a tool vest",
    "char_unarmed_base": "an unarmed civilian in plain clothes, no weapon, hands visible",
    "icon_faction": "a faction color badge, simple shield with a diagonal green stripe",
    # 载具
    "veh_mbt_hull": "a main battle tank hull, tracked, 8.3 m long, angular composite armor panels",
    "veh_mbt_turret": "a main battle tank turret with a long 125 mm smoothbore gun and a commander hatch",
    "veh_ifv_hull": "an infantry fighting vehicle hull with tracks and side armor skirts",
    "veh_ifv_turret": "an IFV turret with a slim autocannon and a missile rail",
    "veh_apc": "a wheeled armored personnel carrier with six road wheels and a small cupola",
    "veh_wheeled_assault": "a wheeled assault gun with a 105 mm gun in a low turret",
    "veh_spg": "a self-propelled howitzer with a very long 155 mm barrel and a wide tracked chassis",
    "veh_heli": "an attack helicopter seen from directly above, rotor disc and stub wings with rocket pods",
    "veh_track": "a horizontally seamless tank track and suspension texture strip",
    # 地图
    "map_heightmap": "a seamless grayscale heightmap of rolling hills with a river valley, white = high, black = low, strictly grayscale",
    "map_tile_terrain": "a seamless 32x32 terrain tile of dry grass and packed dirt",
    "map_contour": "a colorized terrain contour shading layer, elevation bands from dark valley green to pale ridge tan",
    "map_building": "a top-down ruined concrete building footprint used as a cover sprite, collapsed roof and rubble",
    # UI
    "ui_crosshair": "a minimal aiming arrow crosshair whose TIP is exactly at the canvas center and whose shaft points left (negative x), filled solid green #7bd88f",
    "ui_mark_enemy": "a military map marker: diamond outline, white stroke, semi-transparent red fill",
    "ui_mark_vehicle": "a military map marker: rounded rectangle outline, white stroke, semi-transparent red fill",
    "ui_mark_position": "a military map marker: downward pointing triangle, white stroke, semi-transparent yellow fill",
    "ui_mark_supply": "a military map marker: plus sign, thick white stroke",
    "ui_mark_smoke": "a military map marker: three overlapping soft circles, white outline",
    "ui_mark_rally": "a military map marker: a flag on a pole, white pole with a solid green flag",
    "ui_map_icon": "a small tactical map unit icon, a simple dot with a short direction arrow",
    "ui_quest_card": "a quest card panel background, dark slate rounded rectangle with a thin light border",
    "ui_vignette": "a full screen vignette overlay, fully transparent center fading to darkened edges",
    "ui_status_panel": "a HUD status panel background, dark translucent slate with a thin light border",
    "ui_squad_list": "a HUD squad list panel background, tall dark translucent slate with a thin light border",
    "ui_squad_portrait": "a circular portrait frame with a thin light border, empty center",
    "ui_command_wheel": "a radial command wheel background, a ring divided into five sectors, dark translucent with a light rim",
    "ui_feed_panel": "a kill feed panel background, wide dark translucent slate with a thin light border",
    "ui_tip_panel": "a thin tooltip bar background, dark translucent slate",
    "ui_button_nineslice": "a nine-slice button background, dark slate with a thin light border, corners designed to stay 4 px",
    "ui_joystick_base": "a virtual joystick base, a translucent white ring on a fully transparent background",
    "ui_joystick_knob": "a virtual joystick knob, a soft white translucent disc",
    "ui_vehicle_panel": "a vehicle HUD panel background, dark translucent slate with a thin light border",
    "ui_downed_overlay": "a full screen downed overlay, dark red vignette with a transparent center",
    # 特效
    "fx_smoke": "a soft round smoke puff, light grey, soft feathered edge, no hard boundary",
    "fx_muzzle": "a gun muzzle flash, orange-yellow star burst with a bright white core",
    "fx_tracer": "a thin bright tracer streak, yellow-white, horizontal",
    "fx_impact": "a small dust and debris impact burst",
    "fx_blob_shadow": "a soft elliptical black drop shadow with a feathered edge",
    # 单位
    "unit_drone_quad": "a quadcopter reconnaissance drone seen from directly above, four rotor arms",
    "unit_quadruped": "a quadruped legged robot seen from directly above, four articulated legs",
    # 图标
    "app_icon_192": "an app icon: a stylized military map contour with a bold green arrow, dark slate background",
    "app_icon_512": "an app icon: a stylized military map contour with a bold green arrow, dark slate background",
    "app_icon_fg_432": "an adaptive icon foreground layer: a green contour arrow emblem on a fully transparent background, centered with a safe margin",
    "app_icon_bg_432": "an adaptive icon background layer: a dark slate subtle gradient, no emblem, no text",
}

ANIM_SUBJECT = {
    "char_lower_idle": "the lower body (legs) of a top-down soldier in a relaxed idle stance with a slow weight shift",
    "char_lower_walk": "the lower body (legs) of a top-down soldier in a walk cycle",
    "char_lower_run": "the lower body (legs) of a top-down soldier in a sprint cycle with a strong forward lean",
    "char_lower_crouch": "the lower body (legs) of a top-down soldier in a kneeling crouch",
    "char_lower_prone": "the lower body (legs) of a top-down soldier lying prone and flat",
    "char_lower_crawl": "the lower body (legs) of a top-down soldier crawling forward on the ground",
    "char_upper_arm_aim": "the upper body and arms of a top-down soldier holding a rifle in an aiming pose",
    "char_upper_arm_focus": "the upper body and arms of a top-down soldier steadying the rifle for a precise shot",
    "char_hand_skeleton": "a simple skeletal hand rig reference for gripping a rifle, flat grey on transparent",
    "char_weapon_attach": "a weapon attachment point sheet showing common rifle parts and accessories, evenly spaced on transparent",
    "char_full_downed": "a full body top-down soldier knocked down and falling to the ground, arms flailing",
    "char_full_dead": "a full body top-down soldier lying motionless on the ground, weapon dropped aside",
    "veh_track_roll": "a horizontally looping tank track rolling texture, links shifting one pitch per frame",
    "veh_rotor_heli": "a helicopter rotor disc blur, rotation blur increasing across frames",
    "veh_m_kill": "a tank with a broken thrown track, mobility kill state, immobilized",
    "veh_f_kill": "a tank with its gun barrel destroyed and turret scorched, firepower kill state",
    "veh_k_kill_boom": "a catastrophic vehicle kill, turret popping off with a violent explosion and debris",
    "veh_k_kill_wreck": "a burned out vehicle wreck, blackened hull with soot and scattered debris",
    "veh_recoil": "a tank gun firing with the barrel recoiling backward into the turret",
    "fx_muzzle_flash": "a gun muzzle flash expanding then fading",
    "fx_tracer": "a tracer round streaking away with a fading tail",
    "fx_impact": "a bullet impact kicking up dust and small debris",
    "fx_explosion": "an explosion: bright core flash, expanding fireball, then dark smoke",
    "fx_smoke": "a smoke plume rising and dissipating, rolling soft puffs",
    "fx_hit_flash": "a pure flat white hit flash overlay, no detail, transparent outside the silhouette",
}

SFX_SUBJECT = {
    "shot": "a single rifle gunshot, sharp dry crack, close perspective, tight transient",
    "shot_enemy": "a single rifle gunshot, slightly lower pitch and duller, heard at a distance",
    "cannon": "a tank main gun firing, deep chesty boom with a short mechanical echo",
    "missile": "a missile launch, whoosh of propellant followed by a rocket roar",
    "impact": "a bullet striking dirt and gravel, very short dry tick with debris",
    "hit": "a bullet striking a body or soft armor, dull wet thud",
    "explosion": "a large ground explosion, deep boom with debris and a long tail",
    "reload": "a rifle magazine being seated and the bolt cycled, crisp mechanical click-clack",
    "flag": "a neutral positive notification chime signalling a capture, two clean tones",
    "down": "a soldier falling to the ground, body thud with gear and helmet rattle",
    "kill": "a short positive UI confirmation tone for a confirmed kill, single clean blip",
    "match": "a short end-of-match resolve, a warm low chord that fades cleanly",
}

BGM_SUBJECT = {
    "bgm_menu": "a calm atmospheric military menu theme, sparse and patient, distant ambience, minimal percussion",
    "bgm_battle": "tense tactical battle music, driving low percussion, restrained melody, loopable",
}


def _px(size):
    if isinstance(size, list) and len(size) == 2:
        return "%dx%d" % (int(size[0]), int(size[1]))
    return ""


def for_image(a):
    """图片资产 → (提示词, 负面提示词, 工具建议)"""
    aid = a["id"]
    cat = a.get("category", "")
    subj = SUBJECT.get(aid, a.get("design_name", aid))
    size = _px(a.get("size"))
    if aid.startswith("app_icon"):
        base, neg, tool = subj + ", " + STYLE_ICON, NEG_UI, TOOL_UI
    elif cat == "UI" or aid.startswith("ui_") or aid.startswith("icon_"):
        base, neg, tool = subj + ", " + STYLE_UI, NEG_UI, TOOL_UI
    elif aid == "map_heightmap":
        # ⚠ 高度图不是「画」出来的图：它是一个数据通道（白高黑低）。
        # 绝不能套精灵那套 cel shading / 配色串 —— 那会把高度数据毁掉。
        base, neg, tool = subj + ", " + STYLE_HEIGHTMAP, NEG_MAP, TOOL_MAP
    elif cat == "地图" or aid.startswith("map_"):
        base, neg, tool = subj + ", " + STYLE_MAP, NEG_MAP, TOOL_MAP
    elif aid.startswith("fx_"):
        base, neg, tool = subj + ", " + STYLE_SPRITE, NEG_FX, TOOL_SPRITE
    else:
        base, neg, tool = subj + ", " + STYLE_SPRITE, NEG_SPRITE, TOOL_SPRITE
    if size:
        if aid in FULLBLEED:
            base += ", output %s px, full-bleed opaque image with no transparency, edge-to-edge, seamlessly tileable" % size
        else:
            base += ", output %s px, transparent background, subject centered with a small safe margin" % size
    return (base, neg, tool)


def for_anim(a):
    aid = a["id"]
    subj = ANIM_SUBJECT.get(aid, aid)
    frames = a.get("frames")
    fps = a.get("fps")
    if frames in (0, None):
        return ("无需贴图：该动画由引擎程序驱动（%s），生成器不适用" % aid, "", "—")
    n = int(frames)
    p = (subj + ", " + STYLE_SPRITE +
         ", %d-frame sprite sequence exported as %d separate PNGs (frame 01 to %02d)" % (n, n, n) +
         ", consistent subject, lighting and palette across every frame, transparent background")
    if fps not in (None, "", "—"):
        p += ", plays at %s fps" % fps
    return (p, NEG_SPRITE, TOOL_SPRITE)


def for_sfx(sid, dur):
    subj = SFX_SUBJECT.get(sid, sid)
    p = ("%s, game sound effect, %.2f seconds, mono, 22050 Hz, dry (no reverb), no music, "
         "single clean event, tight transient, no fade-out") % (subj, dur)
    return (p, NEG_AUDIO, TOOL_SFX)


def for_bgm(bid):
    subj = BGM_SUBJECT.get(bid, bid)
    p = (subj + ", instrumental game background music, 60-120 seconds, seamless loop, "
         "no fade in, no fade out, no vocals, stereo 44.1 kHz")
    return (p, "vocals, lyrics, fade out, abrupt ending, clipping", TOOL_BGM)
