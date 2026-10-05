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

## 知识 / 记忆落点
- `docs/kb/` —— 从手机端 agent 迁来的知识库（含 `refs/godot-api`、`refs/godot-guide` 官方文档）
- `docs/notes.md` —— 从 agent 持久记忆筛出的「Godot 通用坑 + 《解域》设计定标 + 工程实现」条目
- `docs/第一版垂直切片.md` —— 第一版切片说明
