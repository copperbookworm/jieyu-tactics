---
name: jieyu-progress-sync
description: "《解域》jieyu-1 开发收尾的文档对账流程：先按实测取证（跑测试 / 数行 / 查 git / 读数据表），再把 jieyu-1/本项目开发进度.txt 与 squad-2d 的 解域游戏.docx + 6 张 CSV 改到与工程实际进度一致。凡是开发完一轮 jieyu-1（候选 L/M/O~U 之类）、改完代码要收尾、要更新开发进度、要回流设计文档、或要核对「文档说 X 工程只有 Y」时用本技能。"
whenToUse: "jieyu-1 任一轮开发/修改代码结束后的收尾；需要更新 本项目开发进度.txt；需要把工程实测回流进 解域游戏.docx 或 6 张 解域游戏*.csv；需要核对文档与工程口径是否一致。"
metadata:
  project: jieyu-1
  version: 1
  updated: 2026-10-01
---

# jieyu-progress-sync · 《解域》开发收尾对账

一轮 jieyu-1 开发结束（或代码改完了）之后，**不要凭记忆写进度**，也**不要把上一轮的数字抄一遍**。
本技能的唯一产出目标：让下列 8 个文件的内容 = 工程的真实状态。

| 文件 | 位置 | 角色 |
|---|---|---|
| `本项目开发进度.txt` | `D:\Godot4.7_Proj\jieyu-1\` | jieyu-1 唯一进度入口（本文件为准） |
| `解域游戏.docx` | `D:\Godot4.7_Proj\squad-2d\` | 主设计文档（含「二十、工程实现现状」） |
| `解域游戏动画帧规格.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（动画） |
| `解域游戏美术资产表.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（美术资产 · 有「状态」列） |
| `解域游戏任务模板表.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（任务模板） |
| `解域游戏载具数据表.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（载具） |
| `解域游戏地图数据规格.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（地图文件规格） |
| `解域游戏武器数据表.csv` | `D:\Godot4.7_Proj\squad-2d\` | 设计目标（武器） |

> ⚠ 路径坑：`jieyu-1` 目录里**只有** `本项目开发进度.txt`；docx 与 6 张 CSV 在 `squad-2d`。
> 两边不要写反（squad-2d 是纯文档目录，没有 project.godot）。

---

## 铁律（违反任何一条，本轮对账作废）

1. **先取证，再写。** 所有数字（测试项数、行数、数据表行数、文件数）必须来自本轮**真跑/真数**的输出，不许抄上一轮、不许按「应该没变」推断。
2. **不许报绿。** 测试没全绿就写「有失败 + 失败项原文」，并把它登记进「待办」。上一轮写的「全绿」不构成本轮的依据。静默把失败写成通过是本技能最严重的错误。
3. **历史只追加，不改写、不重排。** `本项目开发进度.txt` 的「二、已完成」只在末尾追加新版本段；旧段落哪怕数字过时也不动（数行口径的旧账已在文件里订正过，不要二次改写）。
4. **设计文档不许被降级。** 6 张 CSV 与 docx 的**章节正文**是设计目标（TARGET），工程按切片实现是正常的。只允许在**登记现状的字段/章节**里写工程实况；绝不许把「目标 25 把武器」改成「5 把」来消灭不一致 —— 那种不一致本身就是要报告的信息。
5. **改动前先备份。** 每个被改的 docx/CSV/进度文件先复制一份 `原名.bak<YYYYMMDD-HHMM>`（docx 沿用既有 `.bakNN` 递增风格）。进度文件已有一份 `.bak-20261001`，不要覆盖它。
6. **锚点替换，命中数不对就整体不写。** 改文本文件时用「锚点 → 校验命中恰好 1 次 → 才落盘」的写法（见 `references/对账约定.md`），不做模糊正则替换。
7. **改不了就说改不了。** 写权限被拒、docx 结构不符预期、测试跑不起来 —— 原样报告并停止该文件的改写，不许绕过、不许改 ACL、不许用假数据填充。

---

## 执行顺序

### 第 0 步 · 先读进度文件
读 `D:\Godot4.7_Proj\jieyu-1\本项目开发进度.txt`（838 行 ± ）。
必须看：抬头「最后更新 / 本次更新」、`三、当前状态`、`四、接下来`、`六、其他待办`、`七、已知待拍板`。
另外读 `D:\Godot4.7_Proj\jieyu-1\AGENTS.md`（工程规则）与 `D:\Godot4.7_Proj\squad-2d\AGENTS.md`（若存在）。
**确认本轮「已经改了什么」**——`git status` 里未提交的改动就是本轮工作量。

### 第 1 步 · 实测取证（不可跳过）

**① 跑测试（必须真跑）**

```
$g = "E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe"
$p = "D:\Godot4.7_Proj\jieyu-1"
& $g --headless --path $p --script res://tools/run_tests_headless.gd        --log-file "$p\_verify_unit.log"
& $g --headless --path $p --script res://tools/run_integration_headless.gd --log-file "$p\_verify_integration.log"
```

- 退出码 `0` = 全绿 / `1` = 有失败。
- `--log-file` **必须加**：受限沙箱里 Godot 写不了 `user://` 会直接崩。
- 项数从日志汇总行取；单元测试每个脚本的行长这样：`<<<<< quest_test.gd 通过=90 失败=0`，
  总计 = 各脚本相加，并核对末尾 `#### 汇总：脚本 N 个，未全绿 M 个`。
- 集成冒烟同理，失败项原文形如 `[FAIL] 全占 → 胜利结算 …  期望=true 实际=false`；**连带看 `SCRIPT ERROR:` 行**，它往往才是根因（例：`Nonexistent function 'main_quest' in base 'Nil'` ⇒ QuestSystem 没建起来）。
- 跑完把 `_verify_*.log` 删掉（工作区根可写；且它们不该进 git）。取证输出自己留摘要即可。

**② 数行与清点**

用本技能的 `scripts/inspect_project.py`（只读，一次给出全部数字）：

```
& "D:\dsh-data\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe" `
  "D:\dsh-data\skills\jieyu-progress-sync\scripts\inspect_project.py"
```

它给出：`.gd` 文件数 / 总行数（LF 口径）/ Main.gd 行数 / 各 gameplay 子模块行数 / 数据表行数 /
`entities/fob|lane|supply` 与 `scenes/gameplay/*Controller.gd` 是否存在 / `git HEAD` 与未提交改动数。

> 行数口径：**必须 LF 字节数**（`[System.IO.File]::ReadAllText($f) -split "`n"` 的 count-1）。
> `Get-Content` 在中文 UTF-8 文件上会少数约 6%，历史上因此把 Main.gd 数成 911 行。**不要用 Get-Content 数行。**

**③ 其他取证**
- `git -C D:\Godot4.7_Proj\jieyu-1 log -1 --format="%H %ad %s"` 取 HEAD（基线提交后才可用）。
- 被改动的文件清单：`git status --short`。
- 引擎行为/API 有疑问：`kb_search` → `kb_read`（MCP `agent-tools`，检索根 `docs/kb`），别猜。

### 第 2 步 · 列差异清单（先写下来，再动手）
把「文档说 / 工程实际」逐条并排写上，这就是要落盘的内容。常见差异源：
测试项数变化、`.gd` 数量与行数、Main.gd 行数、数据表行数、新增实体/模块、
新落地的 docx 章节（4.10.11 之类）、新增待拍板项、已修/未修的工程债。

### 第 3 步 · 更新 `本项目开发进度.txt`（骨架见 `references/对账约定.md`）
1. 抬头的「最后更新」「git HEAD」「本次更新」——写成**本轮**内容，并保留「上一轮 / 更早一轮」的指针格式。
2. `二、已完成` 末尾追加一个 `【第 N 版 · …（日期）】` 段：本轮做了什么、实测验收数字、未做与遗留、`待办（下一轮）`。
3. `三、当前状态`：规模、测试、数据表、可玩循环 —— **只改数字与结论**，保留原有小节结构与那些「口径警告」文字。
4. `四、接下来`：勾掉已完成的候选，更新「下一批建议」。
5. `六、其他待办`：已修的条目**标注「✅ 已修（见第 N 版）」而不是删行**；新发现的债追加。
6. `七、已知待拍板`：本轮拍板的写成「已拍板并落地」；新出现的待拍板追加。
7. 若本轮是**纯文档回流**（没动代码），照第二十一版的写法明确写「本轮不动代码」。

### 第 4 步 · 更新 `解域游戏.docx`
- 原地更新、先备份成 `解域游戏.docx.bak<NN>`（现有到 `.bak60`，本轮取下一个**不存在**的编号）。
- 主要动 **「二十、工程实现现状」**：20.1 规模与验收基线 / 20.2 已落地清单 / 20.3 与文档口径不一致 /
  20.4 工程侧开关与调试值 / 20.5 工程债 / 20.6 文档有设计工程为零。
  实测数字、测试项数、模块行数、数据表行数、已修好的债都要在这里对齐。
- 第二十章标题里的实测日期改成本轮日期；正文开头那句「所有数字均为 … 在本机实测」要跟着改。
- 第十八章「已确认决议清单」补本轮定下来的工程口径；第十九章「待确认决策清单」勾掉已拍板、补新开口项。
- 第二十一章「主要资料来源」的静态目录：**只在真的新增/改名章节时**同步条数。
- 写法沿用既有脚本 `D:\Godot4.7_Proj\_docx_update.py`（`OxmlElement` 造与文档同构的 `<w:p>`，
  多行用 `<w:br/>`，改完跑一次结构检查）。**改完必须验证**：段落数 / 表格数不低于改前，
  章节标题仍在，文件能被 `python-docx` 重新打开。

### 第 5 步 · 更新 6 张 CSV
- 默认**不动**（它们是设计目标）。只有工程真的落地了规格变更（表格结构、字段、口径）才动，
  且只动「工程实况」该占的字段。
- `解域游戏美术资产表.csv` 的 **`状态`** 列是唯一日常该跟着工程走的列（`待制作` → `已制作` 之类），
  以及 `备注` 里的接线路径。**注意**：本工程的画面多为程序绘制（`HudBuilder` / `HudTextureFactory` 程序生成贴图），
  别把「程序画出来的」当成「PNG 资产已完成」。
- 改 CSV 保持 **UTF-8（保留 BOM）** 与列数不变；行数变化要能说清原因。
- 各表现有表头与行数（2026-10-01 实测）见 `references/对账约定.md`。

### 第 6 步 · 复核（必做）
1. 重跑第 1 步的两条测试 —— 数字与你写进文档的一致。
2. `git -C D:\Godot4.7_Proj\jieyu-1 status --short` —— 确认只改了预期文件，无临时文件残留。
3. docx 用 `python-docx` 打开一次，报段落 / 表格数。
4. 把两边不一致但**本轮不打算解决**的，明确登记（docx 第十九章 + 进度文件第七节），不要闷掉。

---

## 收尾报告格式（给用户）
简短、可核对，四段：
1. **本轮实测**：测试 N 项通过 / M 项失败（失败项原文）、`.gd` 数 / 行数、Main.gd 行数、数据表行数。
2. **改了哪 8 个文件**：逐条一句话说清改了什么（备份文件名列上）。
3. **发现的文档↔工程差异**：还没消除的，逐条列（含你建议的处置）。
4. **下一轮待办**：从 `四、接下来` 里挑，别自己发明。

---

## 环境事实（本机实测，2026-10-01）
- Godot 控制台版：`E:\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe`（PATH 里没有 `godot`）。
- 带库 Python：`D:\dsh-data\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe`
  （`python-docx` 1.2.0 / lxml / pandas 在此；系统 `python` **没有** python-docx）。
- `git`：jieyu-1 **已有** `.git`（基线提交 `jieyu-1 基线提交（2026-10-01…）`）；
  `squad-2d` **不是** git 仓库（那份文档没有版本可回退，改前备份更重要）。
- `DSH_HOME` 必须是 `D:\dsh-data`，**绝不可覆盖**。
- PATH 里的裸 `node` 是坏的 v22；要跑 Node 用 `D:\dsh-data\dsh-runtimes\dsh-primary-runtime\dependencies\node\bin\node.exe`。
- `godot-ai` MCP 只在 Godot 编辑器打开时可用；`--headless` 下插件停用（所以取证靠 `--script` + 日志文件）。
- 进度文件里记的沙箱写权限机制：老文件若只带着上一轮会话的 ACL 授权项会被拒写，新建文件则继承当前授权项。
  遇到时申请一次完全访问授权即可，**不要**用 ACL 脚本改权限。

## 未决事项处理
若发现的是「需要用户拍板」的问题（分辨率与 PPU、烟雾是否进第一版、数据表规模口径……）：
**不要替用户决定**，写进 `docx 第十九章` 与`进度文件 七、已知待拍板`，并在收尾报告里点名提问。

---

## 本技能的副本与同步（重要）

本技能故意放了**两份**，内容是同一套，分别在两个完全不同的发现根上，别只改一份：

| 副本 | 发现根 | 何时可见 |
|---|---|---|
| `D:\dsh-data\skills\jieyu-progress-sync\` | DSH user 根 `<DSH_HOME>\skills`（rank 400） | 任何工作区的会话 |
| `D:\Godot4.7_Proj\jieyu-1\.dsh\skills\jieyu-progress-sync\` | project 根 `<projectRoot>/.dsh/skills`（rank 100，最高） | 工作区在 jieyu-1 里的会话 |

**为什么两份**：本机 `desktop` profile 把 host 层的 `skill-filesystem` / `tool-skill` 关掉了，
由 preset 层自己挂（见 `dsh-web-app/cordis.patch.yml` 与 `presets/standard.patch.yml`）。
user 根能不能被扫到取决于 `dshHome` 的解析结果，而 project 根只要求「工作区里有 `.git`」——
jieyu-1 有 `.git`，所以在 jieyu-1 工作区里那一份是必然可见的保险。

**改完必须同步**（改哪一份都行，改完立刻复制到另一份并核对）：

```powershell
$src = "D:\dsh-data\skills\jieyu-progress-sync"
$dst = "D:\Godot4.7_Proj\jieyu-1\.dsh\skills\jieyu-progress-sync"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Path (Join-Path $src '*') -Destination $dst -Recurse -Force
# 反向同步就把 $src / $dst 对调
```

- 同一会话里两份同名，按 registry 规则**近层优先**：在 jieyu-1 工作区时 project 根（rank 100）赢，
  所以那次加载的是 `jieyu-1\.dsh\skills\` 那份；改完不同步就会出现「我改了却还是旧行为」。
- 新增/改名/删除 `SKILL.md` 会被 watcher 捕到；但**bundle 里的 `references/` `scripts/` 改动不会触发
  目录刷新**，改这些要等下一次会话或手动确认加载结果。
- `.dsh/` 会进 git 工作区：别忘了它在 `git status` 里是未跟踪目录（按需要决定是否提交）。
- 想彻底改掉这个双份结构，就走配置路线：在 `D:\dsh-data\profiles\desktop\cordis.patch.yml`
  给 skill-filesystem 补 `customSkillDirs: ["D:\\dsh-data\\skills"]`，然后删掉 project 那份副本。
