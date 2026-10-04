# jieyu-1 开发笔记（从手机端 agent 持久记忆筛出）

**来源**：`D:\Godot4.7_Proj\kb\知识库\00-收件箱\Agent持久记忆导出-2026-09-29.md`
（facts.jsonl 66 条 + 工作记忆 state.json 快照）。原始导出仍在 `docs/kb/` 内，可回查 `[f0xx]` 原文。

**本文件收录范围**：与 Godot 开发 / GDD 写法 /《解域》设计定标 / jieyu-1 工程约定相关的条目。
已剔除：软件著作权等无关条目、载具原型 bradley-mangal-2、fight-1 / fight-2 历史原型、猫捉耗子 CMG 等其它项目，
以及手机端 agent 自身代码（server.py / Starlette / docx_vision 等）的实现细节。

> ⚠ **进度判断只有一个入口**：`本项目开发进度.txt`（见 `[f061]`）。本文件是「跨会话的经验与定标」，
> **不要**用它来判断「哪一版做到哪了」——它是 2026-09-29 的记忆快照，之后的工作全在进度文件里。
> 标记含义：✅ = 已闭环/已修；⚠️ = 已被后续条目取代，照它干活就是踩坑。

---

## 1. 铁律与协作约定（违反即返工）

- **[f001]** 绝不手改 `.tscn` / `.tres` / `.import` 以及 `.godot/` 目录。场景结构只在 Godot 编辑器里改。
- **[f055]** 《解域》是手机游戏（横屏 960×540），**用户不用键盘测试**，任何操作方案必须走触屏。
  已定输入分工：左下虚拟摇杆移动、右手拖动控准心（准心＝屏心＝相机中心）。
  **禁止** `Input.get_vector("ui_*")` 之类键盘方案。
- **[f061]** 工作流程约定（用户明确要求）：① 动手前先读 `jieyu-1\本项目开发进度.txt`；
  ② 做完更新该文件的「已完成」「接下来」两节。它是唯一进度入口，
  **不要凭记忆或别处笔记判断进度**。
- **[f060]** `[JIEYU]/squad-2d/使用Agent习惯.docx` 现有 7 条协作习惯：
  ① 拍板带本意/理由 ② 报错贴原始输出不转述 ③ 真机验证后回报 ④ 允许开工前先 read/grep 核对现状
  ⑤ 任务边界一次说清 ⑥ 重要决策写进文档留痕 ⑦ 一次推进一步、每步可验收。
- **[f054]** fight-2 项目**已封存**，不再折腾；后续《解域》实现在 jieyu-1 里做。
  fight-2 的弹道表 / 相机准星 / 曳光等成果**只作参考实现**，移植时必须重写适配，**不得直接依赖 fight-2 路径**。

## 2. Godot 4 通用坑（跨项目复用）

- **[f063] `:=` 类型推断失败会炸整个脚本**（jieyu-1 最高频坑之一）：对「动态类型来源」用 `var x := `
  直接报 "Cannot infer the type of x variable..." 并导致脚本加载失败。两类高发来源：
  ① preload 脚本实例的返回值/属性；② Dictionary 索引（`dict["k"]`）再取属性。
  修法：改 `var x = `（动态）或先标注 `var x: T = expr`。Main / Vehicle 各踩过一次。
  同类：**鸭子类型引用**（如 `main` 是 Variant）里写 `var x := main.xxx` 一律编不过，必须 `var x: float = main.xxx`。
- **[f062] `_draw` 不会自动清除**：若 `queue_redraw` 写在条件里（「有值才重绘」），从「有」掉到「无」
  的那一帧必须补一次重绘，否则最后一帧图形永久残留（jieyu-1 敌人压制弧曾残留 20 多秒）。
  写法：用 `_xxx_drawn` 标记上一帧状态，`if 当前 or 上一帧为真: queue_redraw`，再更新标记。
- **[f019] 物理回调里不能改碰撞状态**：Area2D.body_entered / CharacterBody2D 碰撞回调里直接
  remove_child / 改 collision_layer / monitoring 会被物理空间锁定拒绝
  （"Can't change this state while flushing queries"）。用 `call_deferred` / `set_deferred`，
  或等到自己的 `_process`/`_physics_process`。
- **[f022] 持久组**：`Node.add_to_group(g, persistent=false)`（默认）在编辑器脚本里对游离节点加的组
  **不会写进 .tscn**，只有运行时 add_to_group 才生效。生成场景的 EditorScript 必须写
  `add_to_group(NAME, true)`，否则 `get_first_node_in_group` 静默失效。出处 `refs/godot-api/Node.md:201-206`。
- **[f024] CanvasLayer 下的 Control size=0**：直接挂 CanvasLayer 下的 Control，
  `set_anchors_preset(PRESET_FULL_RECT)` 不一定把 size 撑成视口大小 → `_draw` 里 size=(0,0)、绘制跑到左上角。
  可靠做法：在 `_ready` 与 `Viewport.size_changed` 里显式 `size = get_viewport_rect().size`、
  `position = Vector2.ZERO` 再 `queue_redraw`。
- **[f056] Camera2D.zoom 语义**：zoom 直接就是「每米多少像素」；默认 1 world unit = 1 屏幕 px。
  960px 屏幕要可视 60m 必须 `zoom=16`（不是 1.0）。《解域》三档 zoom=[32,16,8] = 可视 30/60/120m；
  拖拽换算 = `screen_delta / zoom.x`。
- **[f016] gdlint 内部类**必须写单行 `class ProbeState extends State:`；写成两行（`class X` 换行 `extends Y`）
  报 Unexpected token。
- **[f012] 导出漏文件**：`.xml` 不是资源，`export_filter=all_resources` 时不打包，必须在导出预设
  include_filter（面板 "Filters to export non-resource files/folders"）写 `*.xml`，
  否则导出后 `XMLParser.open("res://xxx.xml")` 读不到（编辑器里正常）。
- **[f034] Godot 4 导出 Android 官方要求**：OpenJDK 17（推荐）、Android SDK
  （Platform-Tools 35.0.0+ / Build-Tools 35.0.1 / Platform 35 / cmdline-tools latest /
  CMake 3.10.2.4988404 / NDK r28b 28.1.13356709）；编辑器设置填 Java SDK Path 与 Android SDK Path；
  上架 Google Play 需 AAB + 非调试 keystore（`keytool -v -genkey -keystore mygame.keystore -alias mygame -keyalg RSA -validity 10000`）。
- **[f017] 工具超时**（手机上 agent 的设定，本机参考）：shell/git 180s、gdlint 120s。
- **[f026] /storage/emulated/0 上的 git 会损坏**（Android 侧历史坑）：media_rw FUSE 上批量 `git add`
  会产出 0 字节空 loose object。修复：`git hash-object -w <文件>` 强制重写 → `git fsck --full` 验证。
  本机（Windows）不适用，保留作历史。

## 3. 《解域》设计定标（源头：`[JIEYU]/squad-2d/解域游戏.docx`）

- **[f030] 定位**：2D 俯视战术射击手游，受 Squad 启发，五节点 RAAS + 白旗点五结构，
  四大势力（泛亚/蓝/红/独立），模式含 PVP竞技/装甲对抗/休闲/PVEVP/困难/兵棋；用易经爻辞推演设计。
- **[f052] 设计本意（用户亲述）**：PVEVP 模式下《解域》= **「2D 化的 Arma 3」**——模拟向、硬核战术，
  **不迁就近距爽感**。所有数值取向服从这个本意（直瞄归零步枪 300 m，保留估距/抬枪手艺）。
  UI 持握：左手拇指控左下摇杆移动、左手食指控左上开火键、右手管准星瞄准。
- **[f036] 相机控制**（已确认）：准心＝屏幕中心＝相机中心三者恒等，单 Camera2D 跟准心
  （`CAMERA_SMOOTH_SPEED=12.0`，**无死区**）；输入＝滑动屏幕拖动，
  `crosshair_world += screen_delta / camera.zoom.x`；最大拖拽 `SIGHT_MAX_DISTANCE=500 m`、
  被挡回退 `CROSSHAIR_CLAMP_OFFSET=1.0 m`。原草稿「镜头绑角色+死区」「准星可偏离屏心 10%」**已作废**。
- **[f037]/[f056] 相机数值**：世界 1 unit = 1 m；逻辑分辨率 960×540；三档离散 zoom=[32,16,8]（整数 PPU 避免贴图撕裂）。
- **[f041] 高程网格 = 1 m × 1 m**（1000×1000，**取代** [f040] 的 128×128 / 7.8m 方案，别再照 7.8m 干活）：
  内存 ≈2-4 MB、DDA 最远约 700 格；与美术 Tile 1m 统一。高度图工作流＝噪声生成大起伏基底 + 手工雕刻关键区，
  灰度图只作审阅视图；0.5~3 m 人高掩体多数直接由高程表达，Occluder 退化为只管可破坏/可移动临时掩体 + 高于视线的实体墙。
  前置约束：**1 km 地图不扩到 2km**（2km 需 Chunk 分块）。
- **[f041]/[f060附] SIGHT_MARGIN 0.3 m**（＝文档 12.2 口径）；士兵**眼高 1.6 m**
  （依据英国 1635mm / GB-T 10000-2023 / 美国 ANSUR II 1636mm，眼高 ≈ 身高 × 0.94）。
- **[f042] 弹道模型定标**：直瞄=低弹道、间瞄=高弹道；带阻力（EF88 为 -30 m/s² 持续 2s）；
  离线数值积分（步长 0.01s）生成弹道表、按 1m 水平步长采样、运行时查表；
  命中判定＝沿准星方向逐米查表得 `h(d)/t(d)`，落入物体高度区间 `[H1,H2]` → 命中。
  7.4 无阻力闭式解**降级为校验基准**。
- **[f058] 命中判定坑（已修）**：① 俯视 2D **命中只看「水平线段穿圆 + 弹丸未落地」**，
  高度只决定「是否打地」——不能要求弹丸高度落在敌人身体区间，否则俯视下必然打空。② 不能用 1m 采样点
  离散查 + 命中半径 0.4m（采样间距大于判定直径会漏判），必须线段-圆相交。③ 命中半径 **0.6 m**（视觉 0.4 m）。
- **[f051] 直瞄归零（方案 B）**：每把直瞄武器配 `zero_m`，解出低弹道归零仰角，使表在归零距离处 h=0。
  归零取值：步枪/机枪/精确射手 300m、反器材 400m、卡宾 200m、冲锋枪 100m、手枪 50m、霰弹 25m、
  火箭 200m、间瞄不归零。⚠️ `solve_angle` 扫描下限**必须 ≤0.05°**。
- **[f050] 弹道表结论**：可覆盖 `drag_decel`/`drag_duration` 字段（阻力 30 m/s² 是给 900 m/s 步枪弹标的，
  套在 M320 低速榴弹上把射程砍到 82m）；M320 修正为 g×1.0 + 阻力5 → 射程 459m。
- **[f065] 屏幕布局约定（960×540）**：**左下角是摇杆地盘**（控件 200×200 贴左下，底座圆心 (100,440)、
  行程半径 90、触摸判定 144 px）。左侧功能键排在 x=16 / x=104 两列，行 y=140/186/232。
  **任何新增左侧 UI 都不得进 y>300 区间。**
- **[f057] 移动端卡顿两个来源**：① 两张 1000×1000 ImageTexture 的 Sprite2D 叠加 → 合并成一张；
  ② 每帧 DDA 通视检测的 Array/Vector2i 分配触发 GC → 敌人显隐降到 10Hz
  （**准心遮挡必须每帧，不能降**）。若仍卡，根因是单张大纹理的采样压力，彻底解决需分块(Chunk)纹理。
- **[f066] 载具对抗数据必然性**：`ifv_a` 穿深 60mm；`mbt_t1` 正面 700@30°→等效 808mm、侧面 260、后部 130、顶部 50。
  玩家开 IFV 对敌方 MBT **任何一面都打不穿**（除顶装甲，而游戏无攻顶手段）——
  「只有未击穿」是**数据必然，不是判定 bug**。建议给 IFV 加 ATGM（穿深 800）形成「绕侧后」战术梯度。
- 其它已定：**兵力值(Ticket) 取消**，改名「重生预算 = 进攻方总人数×2」（[f039]）；任务系统 6 类任务 +
  SMEAC 五段式 + 5 人小队 + AI 参谋用规则模板（不用生成式）（[f038]）；战术地图＝取消全部麦后唯一沟通渠道，
  **敌方默认不显、目击报点才显最后目击位置**（普通 30s / 侦察兵 90s）（[f045]）；
  付费只买身份与外观、不买胜负信息与数值（[f046]）；装备/军队名虚构化 vs 免责标注待拍板（[f047]）；
  动画选型＝精灵帧 + 骨骼混合（[f048]）。

## 4. jieyu-1 工程实现事实

- **[f053] ⚠️ 已过时**：2026-09-26 时 jieyu-1 还是空骨架。**看到「空骨架」直接跳过**，现状见进度文件。
- **[f059] 第一版垂直切片闭环**（用户验收通过）：出生 → 移动 → 通视感知 → 开火交战 → 白旗点占领 →
  全占胜利 → 点按重开。核心文件：`data/config/GameConfig.gd`（**唯一数值出口**）、
  `systems/terrain/{HeightGrid,MapGenerator,SightSystem}.gd`、`systems/camera/AimCameraController.gd`、
  `systems/combat/{BallisticsSystem,Tracer,CaptureZone}.gd`、`entities/{player/Player,enemy/Enemy}.gd`、
  `scenes/gameplay/Main.gd`、`ui/*`、`tools/build_scenes.gd`、`test/*_test.gd`。
- **[f064]「不在载具里点换座后血量变 -300」根因**（已修）：不是换座按钮，而是敌方坦克 `mbt_t1`
  （`gun_damage=400`）一炮打在 100 血步兵上、`take_damage` 未夹下限。修：`maxf(hp-amount, 0)`；
  并把敌方载具 `weapon_fired` 接到曳光（原先敌方载具开炮无曳光，玩家察觉不到被打）。
- **架构现状（2026-09-30，第二十版）**：`Main.gd` 已从 968 行拆到 391 行，分出四个 Node 子模块
  `scenes/gameplay/{WorldSetup,VehicleController}.gd`、`systems/marks/MarkController.gd`、`ui/HudBuilder.gd`
  （都刻意不写 `class_name`，Main 用 preload 引用、各自持 Main 引用走鸭子类型；模块要读的字段已改公开）。
  继续加功能时优先往这四个模块里放，别把 Main 喂胖（`.gdlintrc` max-file-lines 1000）。
- **架构现状（2026-10-04，第五十六版）**：`Main.gd` **337 行**（不是 398/403），子模块**九个**：
  `scenes/gameplay/` 下 WorldSetup / VehicleController / IndirectController / SupplyController /
  LaneController / SmokeController / **PlayerFireController**（玩家步兵开火链，本轮拆出），
  `systems/marks/MarkController.gd`、`ui/HudBuilder.gd`。
  Main.gd 的硬线是 **≤400**：第五十一版被结构值接线顶到 403（破了），第五十六版拆出开火链才收回 337。

## 5. 本机（DSH 这台机）环境备忘

- 工作区**没有 .git** ⇒ 不能 revert/commit，所有改动只能靠 `本项目开发进度.txt` 记录。
- **gdlint 不可用**（`gdtoolkit` 目录里只有一个 pickle，没有 linter 命令）⇒「gdlint 0 问题」只能在编辑器侧确认；
  本机验收改用 `tools/run_tests_headless.gd` + `tools/run_integration_headless.gd` + 真引擎 `--import`。
- 受限沙箱里跑 headless 要加 `--log-file <可写路径>`，否则 Godot 写不了 `user://` 日志会直接崩。
- 集成冒烟的两条硬约束（写进脚本文件头了）：`--script` 模式下本脚本编译早于 autoload 注册 ⇒
  ① 不能写 `EventBus.xxx`，也不能在编译期引用 CaptureZone / Player / Enemy / AimCameraController；
  ② 手动实例化的场景不会自动成为 `current_scene`，必须自己设。
- 数行口径：必须用 **LF 字节数**统计（pwsh `Get-Content` 在中文 UTF-8 上会少数约 6%）。
- Godot 操作走 godot-ai MCP（47 工具，`mcp__godot-ai__*`），**仅编辑器打开时可用**；
  端口 8000 / 9500 一次只能被一个编辑器占用。

## 6. 未决 / 待拍板（跨条目汇总）

1. **样张/数据表不在 git 保护内**：`[JIEYU]/squad-2d/解域弹道表` 与 `[JIEYU]/squad-2d` 整体无版本保护（[f050]）。
2. **1km 不扩 2km** 是前置约束（[f041]），扩图需引入 Chunk 分块。
3. **俯视 2D 的高度表现本质局限**：玩家无法俯仰补偿 ⇒ 命中只看水平线段穿圆（[f058]）；
   载具任何一面打不穿是数据必然（[f066]）。
4. **`_draw` 残留 + `:=` 推断失败 + 物理回调锁** 是 jieyu-1 最高频的三个坑（[f062]/[f063]/[f019]）。
5. 本文件来源分层提示：无 `[f0xx]` 标记的条目（载具相机配置、射程档、战术地图后续确认项、
   「挑队友」取消等）来自会话流水，**引用时请回文档或代码二次确认**。
