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
- Android 侧静态检查（2026-10-06 起可用）：对 `android/build/` 跑 `lintStandardDebug`
  （flavor 是 standard/mono/instrumented，任务名必须带 flavor）。当前基线 **0 Error / 28 Warning**；
  报告在 `android/build/build/reports/`。

## 知识 / 记忆落点
- `docs/kb/` —— 从手机端 agent 迁来的知识库（含 `refs/godot-api`、`refs/godot-guide` 官方文档）
- `docs/notes.md` —— 从 agent 持久记忆筛出的「Godot 通用坑 + 《解域》设计定标 + 工程实现」条目
- `docs/第一版垂直切片.md` —— 第一版切片说明
