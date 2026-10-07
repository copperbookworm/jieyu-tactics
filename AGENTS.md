# AGENTS.md — jieyu-1（Godot 4.7.1）

## 项目速写
- 项目名 JIEYU1；主场景 `res://scenes/gameplay/Main.tscn`
- 渲染 mobile + d3d12；分辨率 960x540，`canvas_items` 拉伸，纹理过滤 Nearest（`default_texture_filter=0`）
- 物理：project.godot 里 3D 物理引擎设为 Jolt Physics（本项目是纯 2D，实际走 Godot 内置 2D 物理）
- Autoload：`EventBus`、`Audio`（`*res://systems/audio/AudioSystem.gd`，单例名 `Audio`）、
  `_mcp_game_helper`（`addons/godot_ai/runtime/game_helper.gd`）
- 编辑器插件：`addons/godot_ai`（godot-ai v4.2.3）
- 引擎：`E:\Godot_v4.7.1-stable_win64.exe\`（console 版跑脚本 / headless 自检）
- 工作副本：`D:\Godot4.7_Proj\jieyu-1`
- ✅ **本机工作区有 git**（2026-10-02 核实，旧说明「没有 .git」已作废）：分支 `main`、
  16 次提交（`fd8d622` → `ee6fb2a`）、有 `.gitignore`；**没有任何 remote（纯本地库）**
  ⇒ 能 revert / commit，但**改坏了没有离线备份兜底**（重要节点建议 `git bundle` 或推远端留一份）。
- **每轮收尾必须提交**（使用者要求）：`git add -A` → `git commit -F <消息文件>`
  （用文件传消息，避免中文与引号在命令行被转义）。消息写清：做了什么 + 验收数字 + 文档同步。
- ⚠ 提交前**必须两套测试全绿**，且校验要**同时看两个退出码 + 两行汇总**——历史教训：曾因只校验
  集成那一行，把一个红的单元测试提交了（后用 `--amend` 折回）。

## 工作规则（按重要度排序）

### 0) 动手前先读进度文件（唯一进度入口）
- 先读 `D:\Godot4.7_Proj\jieyu-1\本项目开发进度.txt`，做完回来更新它；
- **不要凭记忆或别处笔记判断进度**（历史教训：拿过期记忆瞎报「弹道定标未完成」）。

### 1) 文档必须落地（第一原则）
本项目所有设计产出都要能转成 Godot 可执行任务，拒绝空话。
- 每个系统/玩法写清：输入、状态、输出、边界条件、验收标准
- 节点名/信号名/场景路径用真实 res:// 路径，术语与代码一致
- 落不了地的设计当场改或删，不留"看起来很美"的条目

### 2) 输出克制（省 token；DeepSeek 前缀缓存不许被破坏）
- 不复述已知上下文，不整段重复贴代码/日志
- 大结果（场景树、节点列表、长日志）只给摘要 + 需要的行
- 历史只追加，不改写、不重排

### 3) GDD 结构用 Working Backwards（PR-FAQ 式）
先写"发布说明/玩家能做什么"，再倒推系统与实现。

### 4) 味道：默认「钉内 / 钉外」
写正式文档时逐条自问"这条能不能钉进工程？"；创意发散阶段可临时关闭。

### 5) GDScript 与验收约定
- 改完脚本必须跑测试（headless，不用开编辑器；退出码 0=全绿 / 1=有失败）：
  - 单元测试：`"E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe" --headless --path "D:\Godot4.7_Proj\jieyu-1" --script res://tools/run_tests_headless.gd`
  - 集成冒烟（改了装配/交互再加跑）：`... --script res://tools/run_integration_headless.gd`
- 解析/导入自检：
  `"...\Godot_v4.7.1-stable_win64_console.exe" --headless --path "D:\Godot4.7_Proj\jieyu-1" --import`
- 不要手动编辑 `.godot\` 目录（引擎缓存）
- C# 仅文本编辑，不编译、不报编译错误
- 「无 class_name 的模块」引用方**必须 preload 成常量**（裸写名字会解析失败）
- 数行口径：本机必须用 **LF 字节数**统计（pwsh 的 `Get-Content` 在中文 UTF-8 文件上会少数约 6%）

### 6) 并行优先（使用者 2026-10-06 定的口径，**默认倾向并行**）
> 原话：「除非并行没收益、并行根本不能用（一用就慢两个数量级），否则优先考虑并行处理。」

- 遇到"要不要并行"先按**优先并行**想方案，只在以下三种情形才退回串行，且必须**写明是哪一种 + 给数字**：
  ① **没收益**（并行后没明显更快，或总量太小、建任务/等完成的开销吃掉收益）；
  ② **不能用**（引擎硬约束，例如主线程之外访问 `Node`/场景树被线程安全检查拒绝）；
  ③ **一用就慢数量级**（实测反而慢 10× 以上）。
- 反面案例（别重犯）：通视层属②——完整 `has_sight` 并行后 14258 µs/条 vs 顺序 154.7 µs/条
  （引擎一轮打 6.3 万行线程安全检查报错），见 `docs/性能预算.md` 第二十八节。
- 并行化的三条坑与等价性做法也都在第二十八节：共享 Packed 数组的 copy-on-write、惰性 LUT 必须在派发前建好、
  worker 只算数据不碰节点；**分块并行与单块串行必须逐字节等价**，并把这条钉进测试。
- 缩放的定标纪律：GDScript 的并行缩放**与写法强相关且根因未定位**（内联纯计算 7.4×、内层每次调 GDScript 方法 0.9×、
  真实 `terrain_first_blocker` 3.5×）⇒ 任何并行都要拿**真实代码 A/B**，不许按"是纯计算"推断。

## 工具/环境
- Godot 操作走 godot-ai MCP（`mcp__godot-ai__*`，47 工具）；**仅在编辑器打开时可用**，`--headless` 下插件停用
- 端口 8000 / 9500 一次只能被一个 Godot 编辑器占用；同时开两个项目，后开的连不上
- 语法校验优先用真 Godot，不用正则扫描
- 本机坑：PATH 里裸 `node` 是坏的 v22，脚本一律用 `C:\Program Files\nodejs\node.exe`；
  `DSH_HOME` 必须保持 `D:\dsh-data`，绝不可覆盖
- 重要项目别只存 E:（exFAT、无日志，断电易损）
- **Android 导出自第七十三版起走 gradle 自定义构建**：`export_presets.cfg` 的
  `gradle_build/use_gradle_build=true`，依赖 `android/build/`（约 206 MB，`.gitignore` 里 `/android/` 已忽略）
  与 JDK 17。换机器 / 换引擎版本后先跑 `pwsh -File tools/android_overrides/install_build_template.ps1`；
  导出时带 `$env:JAVA_HOME="C:\Program Files\Java\jdk-17"`。**原因与验收见 `docs/性能预算.md` 第十五节**
  （华为把包名钉在 60 Hz，只能由应用自己请求高刷）。
- Android 真机的「呈现刷新率」口径：`adb shell dumpsys display | Select-String mActiveModeId`（2=120Hz）
  与 `adb shell dumpsys SurfaceFlinger --latency <layer>` 首行 `period_ns`（8333333=120Hz / 16666666=60Hz）
- ⚠ **`export_android.ps1` 会「假死」**（2026-10-07 实证）：APK 已写、日志已到 [ DONE ] export，
  但常驻 **GradleDaemon 继承了本次导出的 stdout 管道不释放** ⇒ 脚本里 Invoke-Tool 的管道读取永不返回、job 一直 running
  （有一次因此 24 分钟才收尾）。**处理：确认 APK 已写后 kill 掉 GradleDaemon**，脚本会立刻继续第 3/4 步并 exit 0。
  另：本项目 `pwsh` 不在 PATH 上（`& pwsh -File …` 会 CommandNotFound）—— 直接 `& <脚本路径>` 调。
- ⚠ **真机 A/B 出包的三条纪律**（2026-10-07 一次做废的 A/B 换来的）：① **两版包必须分别命名**（同名覆盖后无法区分哪版是哪个变量）；
  ② **临时改 application/run/main_scene 要卡准导出窗口** —— 若在导出前就还原，那一版包会启动大厅而不是探针场景，两版就**不可比**；
  ③ 装完立刻用 `adb shell dumpsys package com.example.jieyu1` 的 lastUpdateTime 核对装的是哪一版，
  并用 `run-as … ls files/` 确认真出了 perf_*.csv（**没数字就是没跑，别按「跑过了」写文档**）。
- **出包一律走 `tools/android_overrides/export_android.ps1`**（2026-10-06 新增）：四步串起来
  —— ① headless 测试 ② `--export-debug/-release` ③ 导出后打 splash 主题补丁 ④ `aapt2 badging` 复核
  （minSdk / ABI / 体积 / `.so` 是压缩还是存储）。手敲导出会漏掉 ③，并忘记 `JAVA_HOME=jdk-17`。
- **splash 主题（API31 属性归位）有两道，各管一段，都不可省**：
  · `jieyu_splash_fix.gradle`（Gradle 级钩子；由 install_build_template.ps1 装入并 `apply from`）
    在资源合并前把 `android:windowSplashScreenBackground` 挪进 `values-v31/`，**这样编出来的 APK 才是对的**。
    实证：`aapt2 dump resources` 里 `GodotAppSplashTheme` 分两组 —— `()` 3 个 item 不含 0x0101062c，
    `(v31)` 4 个 item 含之。
  · `patch_themes.ps1`（导出后补丁，幂等）管**源码树 / lint**：Gradle 是内容级 up-to-date 判定，
    内容没变时钩子不执行，所以导出后仍需它把文件摆正，否则 lint 重新报 Error。
  · 只留补丁 → APK 里是错的；只留钩子 → lint 可能报 Error。
- `gradle_build/min_sdk` **必须显式写 "24"**：留空会拿到 **Godot 默认 29**（badging 实证），
  而 `config.gradle` 写的是 24 —— 会静默丢掉 Android 7~9 用户。出包后必须用 badging 复核。
- **包体 ~89 MB 是预期，不是 bug**（2026-10-06 更正）：`.so` 在 APK 里是**存储**而非压缩。
  两个包内的 `.so` 都是 72.65 MB 且都已 strip（`llvm-readelf` 查无 `.symtab`）；旧 34 MB 包是**压缩**态。
  旋钮 = `gradle_build/compress_native_libraries`，**本工程有意保持 false**（安装/启动更快）。
  ⚠ 别再往"NDK 缺失导致未 strip"方向查——那个判断是错的（曾据它误装 NDK 并误报）。
- ⚠ **`edit`/`write` 类工具会剥掉 .ps1 的 BOM**（实测：`EF BB BF` → `3C 23 0A`）。PS 5.1 把无 BOM 的
  UTF-8 当 ANSI 读，含中文的 `.ps1` **直接解析崩**。改过 `*.ps1` 后跑
  `& tools/android_overrides/fix_ps1_bom.ps1`（自扫、补 BOM、并重新 ParseFile 自检）。
  **`.gradle` 文件相反：必须无 BOM**（Groovy 解析器不认 BOM）。
  · 已实证受害：`export_android.ps1`（本轮踩了 3 次）、
    `.dsh/skills/release-engineering-android/scripts/build_aab.ps1` —— 后者在 HEAD 里就是无 BOM 的 UTF-8，
    **在 PS 5.1 下解析 FAIL（10 个错误，首个 L55）＝根本跑不起来**，已修。
- ⚠ **改 if/elif 链必须整段替换 + 回读（2026-10-07 第九十版踩到）**：给 `CaptureZone._process` 的
  「只有我方在圈内 → 涨 / 只有敌方在圈内 → 落」加一个条件时，替换串漏掉了前半段 `if`，
  留下一个**孤立的 `elif`** ⇒ 该脚本解析失败 ⇒ 类解析级联崩：报的是「取不到 map_preview_mode」、
  世界装配出 **0 敌 0 友**、`scale_wiring_check` 门禁 **0/21** —— 现场和「AI 部署改坏了」一模一样，
  极难定位。**纪律：if/elif/else 整条链一次换掉，换完把那段读回来确认**；`--import` **修不了语法错误**
  （那是类缓存问题，不是语法问题）。定位手法：跑批输出里先找 `SCRIPT ERROR: Parse Error`。
- Android 侧静态检查（2026-10-06 起可用）：对 `android/build/` 跑 `lintStandardDebug`
  （flavor 是 standard/mono/instrumented，任务名必须带 flavor）。当前基线 **0 Error / 28 Warning**；
  报告在 `android/build/build/reports/`。

- **技能（skills）改了必须同步工程镜像**：技能的单一来源是 `D:\dsh-data\skills`，但 agent 实际加载的是
  **rank100 的工程镜像** `<工程>\.dsh\skills`（2026-10-06 实测：`skill` 工具返回的 resourceBase 就是它）。
  改完 dsh-data 里的技能必须跑
  `& "D:\dsh-data\skills\_tools\sync_skills.ps1" -Project "D:\Godot4.7_Proj\jieyu-1"`，
  并用 `-WhatIfOnly` 复核「两边已经一致」（退出码 0）。否则改动**对 agent 不可见** ——
  第七十七版就漏了这一步：v2 的 `godot-perf-profile/SKILL.md` 与新增的 `perf_frame.ps1` 整轮没人看到。
  ⚠ 用 `run_code` 里的 `String.replace` 改脚本时，替换串里的 `$'` / `$1` 会被当成**替换模式**展开，
  能把文件炸成几倍长且难恢复 —— 一律用函数型 replacer（`s.replace(a, () => b)`）或 `split/join`。

## 知识 / 记忆落点
- `docs/kb/` —— 从手机端 agent 迁来的知识库（含 `refs/godot-api`、`refs/godot-guide` 官方文档）
- `docs/notes.md` —— 从 agent 持久记忆筛出的「Godot 通用坑 + 《解域》设计定标 + 工程实现」条目
- **「第一版」的唯一权威口径 = docx 22.10（2 阵营 / 1 张地图 / 3 模式，单机 + AI 填充）**
  —— 曾经那份 `docs/第一版垂直切片.md`（1 玩家 vs AI、砍掉载具/烟雾/报点/任务）**已于 2026-10-07 删除**：
  它描述的范围工程早就超过了，留着只会让排期按过期的「样机」口径算。
